import jenkins.model.*
import jenkins.install.InstallState


def disableCasC = new File("${System.env.JENKINS_HOME}/plugins/configuration-as-code.jpi.disabled")

if (!disableCasC.exists()) {
  disableCasC.createNewFile()
}
  
Jenkins.instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

// setting the Jenkins URL
url = System.env.JENKINS_URL
urlConfig = JenkinsLocationConfiguration.get()
urlConfig.setUrl(url)
urlConfig.save()
