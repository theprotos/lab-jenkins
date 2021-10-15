import jenkins.model.Jenkins
import com.cloudbees.hudson.plugins.folder.Folder

def folder="SeedJobs"
println("\n=== Initialize the " + folder + " folder\n")
if (Jenkins.instance.getItem(folder) != null) {
    println(folder + " folder has been already initialized, skipping the step")
    return
}

def jenkinsInstance = Jenkins.getInstance()
folder = jenkinsInstance.createProject(Folder.class, "SeedJobs")
