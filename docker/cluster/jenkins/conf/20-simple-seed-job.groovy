import hudson.model.CauseAction
import hudson.triggers.TimerTrigger
import hudson.model.Cause
import jenkins.model.Jenkins
import hudson.model.FreeStyleProject
import javaposse.jobdsl.plugin.ExecuteDslScripts
import javaposse.jobdsl.plugin.LookupStrategy
import javaposse.jobdsl.plugin.RemovedJobAction
import javaposse.jobdsl.plugin.RemovedViewAction
import javaposse.jobdsl.plugin.RemovedConfigFilesAction
import hudson.model.labels.LabelAtom;

def now = new Date()
def jenkinsInstance = Jenkins.getInstance()
def folder = jenkinsInstance.getItem("SeedJobs")
def jobName = "SimpleSeedJob"

println("\n=== Create job: " + folder.name + "/" + jobName + "\n")
if (jenkinsInstance.getItemByFullName(folder.name + "/" + jobName) != null) {
    println(jobName + " job has been already created, skipping the step")
    return
}

// jobDsl plugin uses a free style project in order to seed jobs, let's initialise it.
def seedProject = folder.createProject(FreeStyleProject, jobName)
def jobDslBuildTrigger = new TimerTrigger("0,20,40 * * * *");
def jobDslBuildStep = new ExecuteDslScripts();
jobDslBuildStep.with {
    ignoreExisting = false
    lookupStrategy = LookupStrategy.JENKINS_ROOT
    removedJobAction = RemovedJobAction.DELETE
    removedViewAction = RemovedViewAction.DELETE
    removedConfigFilesAction = RemovedConfigFilesAction.DELETE
    useScriptText = true
    scriptText = "job('Job-DSL') {\n" +
            "    description('Deployed from groovy') \n" +
            "    label('!docker') \n" +
            "    scm {\n" +
            "        git('git://github.com/quidryan/aws-sdk-test.git')\n" +
            "    }\n" +
            "    triggers {\n" +
            "        scm('H/15 * * * *')\n" +
            "    }\n" +
            "    steps {\n" +
            "       shell('java -version')\n" +
            "    }\n" +
            "    steps {\n" +
            "       maven{\n" +
            "              mavenInstallation('maven')\n" +
            "              goals('clean install')\n" +
            "        }\n" +
            "    }\n" +
            "}"
}
seedProject.setDescription("Seed job with scriptText\n Job created at " + now.format("dd.MM.YYYY-HH:mm:ss"))
seedProject.getBuildersList().add(jobDslBuildStep)
seedProject.addTrigger(jobDslBuildTrigger)
seedProject.setAssignedLabel(new LabelAtom("!docker"))
//jenkinsInstance.reload()

// Start
def job = jenkinsInstance.getItemByFullName(folder.name + "/" + jobName)
println("\n=== Run job: " + job.name + "\n")
jenkinsInstance.queue.schedule(job, 0, new CauseAction(new Cause() {
    @Override
    String getShortDescription() {
        'Jenkins startup script'
    }
}
)
)
