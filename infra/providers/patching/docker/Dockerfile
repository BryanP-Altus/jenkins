FROM jenkins/jenkins:2.346.2-lts-jdk11
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
COPY files/jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
COPY --chown=root:jenkins files/InitialConfig.groovy /usr/share/jenkins/ref/init.groovy.d/InitialConfig.groovy
COPY --chown=root:jenkins files/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt