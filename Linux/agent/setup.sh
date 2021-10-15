#!/usr/bin/bash

gradle_url="https://services.gradle.org/distributions/gradle-7.2-bin.zip"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login" && echo -e "\n\tSSH OK"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install additional packages"
yum install -y -q epel-release yum-utils net-tools java-11-openjdk java-11-openjdk-devel lsof unzip
yum update -y -q

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install build tools"
yum install -y -q git maven
mkdir -p /opt
curl -sL $gradle_url -o gradle.zip
unzip -q -o gradle.zip -d /opt
rm -f gradle.zip
mv /opt/gradle* /opt/gradle

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Set /home/jenkins permissions"
mkdir -p /home/jenkins/workspace
chown -R vagrant:vagrant /home/jenkins
