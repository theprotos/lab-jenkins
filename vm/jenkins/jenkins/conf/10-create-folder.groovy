import jenkins.model.Jenkins
import com.cloudbees.hudson.plugins.folder.Folder

def folder = "SeedJobs"
def now = new Date()

if (Jenkins.instance.getItem(folder) != null) {
    println "\nDelete folder: " + Jenkins.instance.getItem(folder).name + "\n"
    Jenkins.instance.getItem(folder).doDisable()
    Jenkins.instance.getItem(folder).delete()
}
println("\n=== Create folder: " + folder + "\n")
Jenkins.instance.createProject(Folder.class, folder)
Jenkins.instance.getItem(folder).setDescription("\n Folder created at " + now.format("dd.MM.YYYY-HH:mm:ss"))
