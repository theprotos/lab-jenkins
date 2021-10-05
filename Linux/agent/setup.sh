#!/usr/bin/bash

echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install additional packages"
yum install -y -q epel-release yum-utils net-tools java-11-openjdk java-11-openjdk-devel lsof git maven gradle
yum update -y -q

echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: Set /home/jenkins permissions"
mkdir -p /home/jenkins
chown -R vagrant:vagrant /home/jenkins
