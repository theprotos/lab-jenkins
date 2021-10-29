FROM jenkins/jenkins:lts

COPY conf/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY conf/*.yaml /usr/share/jenkins/ref/jcasc/
COPY conf/*.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY .ssh /home/jenkins/.ssh/

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Djava.awt.headless -Dhudson.remoting.ClassFilter=javaposse.jobdsl.plugin.*"
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jcasc
