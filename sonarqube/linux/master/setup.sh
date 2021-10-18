#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login\n"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install additional packages"
yum install -y -q java-11-openjdk java-11-openjdk-devel unzip
yum update -y -q

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Set SonarQube variables\n"
sonarqube_url='https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip' &&\
export SONARQUBE_HOME=/opt/sonarqube && echo -e "\tSONARQUBE_HOME [ OK ]"


echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install SonarQube\n"
curl -sL $sonarqube_url -o /tmp/sonar.zip && echo -e "\tDownload [ OK ]"
unzip -q -o -d /tmp/ /tmp/sonar.zip && echo -e "\tExtracted [ OK ]"
mkdir -p /tmp && cp /tmp/sonar-*/* ${SONARQUBE_HOME} && echo -e "\t${SONARQUBE_HOME} [ OK ]"
#rm -rf /tmp/sonar.zip /tmp/sonar-* && echo -e "\tCleanup [ OK ]"


sed -i 's/^#sonar.jdbc.username=/sonar.jdbc.username=sonaruser/' $SONARQUBE_HOME/conf/sonar.properties &&\
sed -i 's/^#sonar.jdbc.password=/sonar.jdbc.password=sonarpassword/' $SONARQUBE_HOME/conf/sonar.properties && \
sed -i 's/^#sonar.jdbc.url=/sonar.jdbc.username=jdbc:postgresql://localhost/sonarqube/' $SONARQUBE_HOME/conf/sonar.properties && echo -e "\n\tConfig OK"
