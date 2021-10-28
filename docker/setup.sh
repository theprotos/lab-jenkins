#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Remove old docker"

yum remove -q docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install addition packages"
yum update -y -q
yum install -y -q epel-release
yum install -y -q yum-utils jq

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y -q docker-ce docker-ce-cli containerd.io

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker-compose"
curl -sL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)"\
 -o /usr/bin/docker-compose && chmod +x /usr/bin/docker-compose

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Enable Docker API"
sed -i\
 -e 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/0.0.0.0:4243 -H unix:\/\/\/var\/run\/docker.sock/' \
/lib/systemd/system/docker.service

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Enable docker"
systemctl enable docker
systemctl daemon-reload
systemctl start docker
usermod -aG docker vagrant

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start compose"
cd /vagrant/cluster
chmod +x *.sh
sh 01-start-cluster.sh
