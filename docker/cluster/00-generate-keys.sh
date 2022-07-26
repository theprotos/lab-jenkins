#!/usr/bin/bash

printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Generate keys: "
mkdir -p jenkins/.ssh
rm -rf jenkins/.ssh/jenkins*
/usr/bin/ssh-keygen -f jenkins/.ssh/jenkins -t rsa -C "" -N ""
export -p JENKINS_PUB_KEY=$(cat jenkins/.ssh/jenkins.pub)
