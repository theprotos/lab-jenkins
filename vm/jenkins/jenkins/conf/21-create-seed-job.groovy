import hudson.model.CauseAction
import hudson.triggers.TimerTrigger
import hudson.model.Cause
import hudson.plugins.git.GitSCM
import hudson.plugins.git.BranchSpec
import jenkins.model.Jenkins
import hudson.model.FreeStyleProject
import javaposse.jobdsl.plugin.ExecuteDslScripts
import javaposse.jobdsl.plugin.*

def jenkinsInstance = Jenkins.getInstance()
def folder = jenkinsInstance.getItem("SeedJobs")


def now = new Date()
def jobScriptsRepository = "https://github.com/theprotos/lab-jenkins.git"
def branch = "*/development"
def jobsScriptFile = "job-dsl/*.jobdsl"
def scm = new GitSCM(GitSCM.createRepoList(jobScriptsRepository, ""), [new BranchSpec(branch)], false, [], null, null, [])
def advancedJobName = "AdvancedSeedJob"
println("\n=== Create job: " + folder.name + "/" + advancedJobName + "\n")
if (jenkinsInstance.getItemByFullName(folder.name + "/" + advancedJobName) != null) {
    println(advancedJobName + " job has been already created, skipping the step")
    return
}
def advancedSeedProject = folder.createProject(FreeStyleProject, advancedJobName)
def jobDslBuildTrigger = new TimerTrigger("0,20,40 * * * *");
advancedSeedProject.scm = scm
advancedSeedProject.save()

def advancedJobDslBuildStep = new ExecuteDslScripts()
advancedJobDslBuildStep.with {
    ignoreExisting = true
    lookupStrategy = LookupStrategy.JENKINS_ROOT
    removedJobAction = RemovedJobAction.DELETE
    removedViewAction = RemovedViewAction.DELETE
    removedConfigFilesAction = RemovedConfigFilesAction.DELETE
    scriptText = ""
    useScriptText = false
    //create jobs using the scripts in a remote repository
    targets = jobsScriptFile
}
advancedSeedProject.setDescription("\n Job created at " + now.format("dd.MM.YYYY-HH:mm:ss"))
advancedSeedProject.getBuildersList().add(advancedJobDslBuildStep)
advancedSeedProject.addTrigger(jobDslBuildTrigger)
jenkinsInstance.reload()


// Start
def job = jenkinsInstance.getItemByFullName(folder.name + "/" + advancedJobName)
println("\n=== Run job: " + job.name + "\n")
jenkinsInstance.queue.schedule(job, 0, new CauseAction(new Cause() {
    @Override
    String getShortDescription() {
        'Jenkins startup script'
    }
}
)
)
