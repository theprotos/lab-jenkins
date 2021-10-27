#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\n\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Add jenkins LTS repo"
curl -sL https://pkg.jenkins.io/redhat-stable/jenkins.repo -o /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key && echo -e "\n\tRepo [ OK ]"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install additional packages"
yum install -y -q epel-release yum-utils net-tools java-11-openjdk java-11-openjdk-devel lsof unzip git
yum update -y -q

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install Jenkins"
yum install -y -q jenkins jq

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Set Jenkins variables"
JENKINS_JAVA_OPTIONS="$JENKINS_JAVA_OPTIONS -Djenkins.install.runSetupWizard=false"
JENKINS_WAR=/usr/lib/jenkins
JENKINS_HOME=/var/lib/jenkins
CASC_JENKINS_CONFIG=$JENKINS_HOME/casc
pimt_url=`curl -sL https://api.github.com/repos/jenkinsci/plugin-installation-manager-tool/releases/latest | jq -r ".assets[].browser_download_url"`
pimt_url_alt='https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.11.0/jenkins-plugin-manager-2.11.0.jar'
pimt_url=${pimt_url:-$pimt_url_alt}

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Copy Jenkins files\n"
mkdir -p $JENKINS_HOME/plugins && cp conf/plugins.txt $JENKINS_HOME/plugins && echo -e "\tPlugins [ OK ]"
mkdir -p $JENKINS_HOME/init.groovy.d && cp conf/*.groovy $JENKINS_HOME/init.groovy.d/ && echo -e "\tinit.groovy.d [OK]"
mkdir -p $CASC_JENKINS_CONFIG && cp conf/jcasc.yml $CASC_JENKINS_CONFIG/ && echo -e "\tJCaSC [OK]"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install plugins via jenkins-plugin-manager \n$pimt_url"
curl -sL $pimt_url -o $JENKINS_HOME/jenkins-plugin-manager.jar
java -jar $JENKINS_HOME/jenkins-plugin-manager.jar\
     --war $JENKINS_WAR/jenkins.war\
     --plugin-file $JENKINS_HOME/plugins/plugins.txt\
     --plugin-download-directory $JENKINS_HOME/plugins
chown -R jenkins:jenkins $JENKINS_HOME/plugins
chmod -R 755 $JENKINS_HOME/plugins

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start and Setup Jenkins daemon"
sed -i "s|JENKINS_JAVA_OPTIONS=.*|JENKINS_JAVA_OPTIONS=\"\
-Djava.awt.headless=true \
-Djava.net.preferIPv4Stack=true \
-Djenkins.install.runSetupWizard=false \
-Dcasc.jenkins.config=$JENKINS_HOME/casc\"|g" /etc/sysconfig/jenkins
chmod 644 /etc/sysconfig/jenkins
setenforce 0
systemctl daemon-reload
systemctl restart jenkins
systemctl status jenkins
