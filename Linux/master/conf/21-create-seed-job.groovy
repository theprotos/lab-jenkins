import hudson.plugins.git.*
import jenkins.*
import jenkins.model.*
import hudson.*
import javaposse.jobdsl.plugin.*
import hudson.model.*

def jenkinsInstance = Jenkins.getInstance()
def folder = jenkinsInstance.getItem("SeedJobs")

/**
 * Advanced job creation
 */

def jobScriptsRepository = "https://github.com/theprotos/lab-jenkins.git"
def branch = "*/development"
def jobsScriptFile = "job-dsl/*.jobdsl"
def scm = new GitSCM(GitSCM.createRepoList(jobScriptsRepository, ""), [new BranchSpec(branch)], false, [], null, null, [])
def advancedJobName = "AdvancedSeedJob"
println("\n=== Initialize the " + folder.name + "/" + advancedJobName + " job\n")
if(jenkinsInstance.getItem(folder.name + "/" + advancedJobName) != null){
    println(advancedJobName + " job has been already initialized, skipping the step")
    return
}
def advancedSeedProject = folder.createProject(FreeStyleProject, advancedJobName)
advancedSeedProject.scm = scm
advancedSeedProject.save()

def advancedJobDslBuildStep = new ExecuteDslScripts()
advancedJobDslBuildStep.with {
    ignoreExisting = true
    lookupStrategy = LookupStrategy.JENKINS_ROOT
    removedJobAction = RemovedJobAction.DELETE
    removedViewAction = RemovedViewAction.DELETE
    scriptText = ""
    useScriptText = false
    //create jobs using the scripts in a remote repository
    targets = jobsScriptFile
}
advancedSeedProject.getBuildersList().add(advancedJobDslBuildStep)
advancedSeedProject.addTrigger(jobDslBuildTrigger)
jenkinsInstance.reload()


// Start
jenkinsInstance.queue.schedule(
        jenkinsInstance.getJob(advancedJobName), 0, new CauseAction(
        new Cause() {
            @Override
                String getShortDescription() {
                    'Jenkins startup script'
                }
            }
        )
)
