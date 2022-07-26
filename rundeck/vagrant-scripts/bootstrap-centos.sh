#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Remove old docker"
yum remove -q docker docker-client docker-client-latest\
 docker-common docker-latest\
 docker-latest-logrotate docker-logrotate docker-engine\
 && echo -e "\tclean [ OK ]"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install addition packages"
yum update -y -q && echo -e "\tupdate [ OK ]"
yum install -y -q epel-release
yum install -y -q yum-utils jq

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y -q docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker-compose"
curl -sL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)"\
 -o /usr/bin/docker-compose && chmod +x /usr/bin/docker-compose

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Enable Docker API, --insecure-registry"
sed -i\
 -e 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd --dns 8.8.8.8 --insecure-registry 192.168.1.200:5000 --insecure-registry 0.0.0.0:5000 -H tcp:\/\/0.0.0.0:4243 -H unix:\/\/\/var\/run\/docker.sock/' \
/lib/systemd/system/docker.service

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Enable docker"
systemctl enable docker
systemctl daemon-reload
systemctl restart docker
usermod -aG docker vagrant

printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: ========== BOOTSTRAP COMPLETED ============"
