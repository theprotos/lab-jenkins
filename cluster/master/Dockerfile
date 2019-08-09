FROM jenkins/jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY jenkins-config.yaml /usr/share/jenkins/ref/jenkins-config.yaml
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins-config.yaml
