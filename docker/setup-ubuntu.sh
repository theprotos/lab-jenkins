#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Remove old docker"
apt-get remove -y -q docker docker-engine docker.io containerd runc && echo -e "\tremove [ OK ]"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install addition packages"
apt-get -y -qq update && echo -e "\tupdate [ OK ]"
apt-get -y -q install ca-certificates curl gnupg lsb-release jq

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y -q install docker-ce docker-ce-cli containerd.io docker-compose-plugin

#echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker-compose"
#curl -sL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)"\
# -o /usr/bin/docker-compose && chmod +x /usr/bin/docker-compose

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Enable Docker API, --insecure-registry"
sed -i\
 -e 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd --dns 8.8.8.8 --insecure-registry 192.168.1.200:5000 --insecure-registry 0.0.0.0:5000 -H tcp:\/\/0.0.0.0:4243 -H unix:\/\/\/var\/run\/docker.sock/' \
/lib/systemd/system/docker.service

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Enable docker"
systemctl enable docker
systemctl daemon-reload
systemctl restart docker
usermod -aG docker vagrant

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Clean packages"
apt-get autoremove -y -q
apt-get clean -y -q

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start compose"
cd /vagrant/cluster
chmod +x *.sh
sh 01-start-cluster.sh

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: COMPLETED"
