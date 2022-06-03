#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login\n"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install additional packages"
yum install -y -q java-1.8.0-openjdk unzip lsof net-tools
yum update -y -q

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install Nexus\n"
nexus_url='https://download.sonatype.com/nexus/3/latest-unix.tar.gz' &&\
export NEXUS_HOME=/opt/nexus && echo -e "\tset NEXUS_HOME [ OK ]"
curl -sL $nexus_url -o /tmp/nexus.tar.gz && echo -e "\tDownload [ OK ]"
mkdir -p ${NEXUS_HOME} && tar -xf /tmp/nexus.tar.gz --directory /tmp && echo -e "\tExtracted [ OK ]"
cp -a /tmp/nexus-*/. ${NEXUS_HOME}/nexus && cp -a /tmp/sonatype-* ${NEXUS_HOME} && echo -e "\tCopy to ${NEXUS_HOME} [ OK ]"


echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Add nexus user and permissions\n"
useradd -m nexus -s /bin/bash || true
usermod -L -a -G nexus nexus &&\
chown -R nexus:nexus ${NEXUS_HOME} &&\
echo -e "\tPermissions [ OK ]"

su nexus -c '/opt/nexus/nexus/bin/nexus restart'