import jenkins.model.Jenkins
import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
import java.util.logging.Logger

def instance = Jenkins.instance
Logger logger = Logger.getLogger('jobdsl')

def jobDslSecurityConfig = instance.getExtensionList(GlobalJobDslSecurityConfiguration.class)[0]
if(jobDslSecurityConfig.useScriptSecurity) {
    jobDslSecurityConfig.useScriptSecurity = false;
    jobDslSecurityConfig.save()
    logger.info("\nScript security disabled for jobDsl plugin\n")
}