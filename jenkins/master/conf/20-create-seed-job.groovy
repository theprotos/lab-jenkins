import hudson.model.CauseAction
import hudson.model.Cause
import jenkins.model.Jenkins
import javaposse.jobdsl.plugin.ExecuteDslScripts
import com.cloudbees.hudson.plugins.folder.Folder

/**
 * Api documentation for job dsl https://jenkins.io/doc/pipeline/steps/job-dsl/
 * Create a simple seed job and execute a job dsl script to create a job
 */
def jenkinsInstance = Jenkins.getInstance()
def folder = jenkinsInstance.getItem("SeedJobs")
def jobName = "SimpleSeedJob"
println("\n=== Initialize the " + folder.name + "/" + jobName + " job\n")
if(jenkinsInstance.getItemByFullName(folder.name + "/" + jobName) != null){
    println(jobName + " job has been already initialized, skipping the step")
    return
}

// jobDsl plugin uses a free style project in order to seed jobs, let's initialise it.
def seedProject = folder.createProject(FreeStyleProject, jobName)
def jobDslBuildTrigger = new hudson.triggers.TimerTrigger("H/20 * * * *");
def jobDslBuildStep = new ExecuteDslScripts();
jobDslBuildStep.with {
    ignoreExisting = false
    lookupStrategy = LookupStrategy.JENKINS_ROOT
    removedJobAction = RemovedJobAction.DELETE
    removedViewAction = RemovedViewAction.DELETE
    removedConfigFilesAction = RemovedConfigFilesAction.DELETE
    useScriptText = true
    scriptText = "job('DSL-Tutorial-1-Test') {\n" +
            "    scm {\n" +
            "        git('git://github.com/quidryan/aws-sdk-test.git')\n" +
            "    }\n" +
            "    triggers {\n" +
            "        scm('H/15 * * * *')\n" +
            "    }\n" +
            "    steps {\n" +
            "       maven{" +
            "              mavenInstallation('maven')\n" +
            "              goals('clean install')\n" +
            "        }" +
            "    }\n" +
            "}"
}
seedProject.getBuildersList().add(jobDslBuildStep)
seedProject.addTrigger(jobDslBuildTrigger)

jenkinsInstance.reload()

// Start
jenkinsInstance.queue.schedule(
        jenkinsInstance.getJob(jobName), 0, new CauseAction(
        new Cause() {
            @Override
                String getShortDescription() {
                    'Jenkins startup script'
                }
            }
        )
)
