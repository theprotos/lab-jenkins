import hudson.plugins.git.*

import jenkins.*
import jenkins.model.*
import hudson.*
import javaposse.jobdsl.plugin.*
import hudson.model.*

/**
 * Api documentation for job dsl https://jenkins.io/doc/pipeline/steps/job-dsl/
 * Create a simple seed job and execute a job dsl script to create a job
 */
def jenkinsInstance = Jenkins.getInstance()
def jobName = "SimpleSeedJob"
// jobDsl plugin uses a free style project in order to seed jobs, let's initialise it.
def seedProject = new FreeStyleProject(jenkinsInstance, jobName);
seedProject.save()

def jobDslBuildStep = new ExecuteDslScripts()
jobDslBuildStep.with {
    ignoreExisting = true
    lookupStrategy = LookupStrategy.JENKINS_ROOT
    removedJobAction = RemovedJobAction.DELETE
    removedViewAction = RemovedViewAction.DELETE
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
            "              mavenInstallation('maven3')\n" +
            "              goals('clean install')\n" +
            "        }" +
            "    }\n" +
            "}"
}
seedProject.getBuildersList().add(jobDslBuildStep)


/**
 * Advanced job creation
 */

def jobScriptsRepository = "https://github.com/theprotos/lab-jenkins.git"
def branch = "*/development"
def jobsScriptFile = "job-dsl/*.jobdsl"
def scm = new GitSCM(GitSCM.createRepoList(jobScriptsRepository, ""), [new BranchSpec(branch)], false, [], null, null, [])

def advancedJobName = "AdvancedSeedJob"
def advancedSeedProject = new FreeStyleProject(jenkinsInstance, advancedJobName)
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