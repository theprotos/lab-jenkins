# cluster

Vagrant used as VM facility, it is optional

This folder contains the dockerized environment.

```
# Create a Jenkins facility
./01-start.sh

# Destroy Jenkins facility
./99-stop.sh

# Start a shell in node of the Jenkins facility 
./node1-shell.sh [node_name]
```





https://plugins.jenkins.io/docker-plugin/

curl -X GET http://0.0.0.0:5000/v2/_catalog

ssh-keygen -f ./jenkins -t rsa -C "" -N ""




#get ip
docker inspect <container>
ssh jenkins@172.17.0.5 -i /vagrant/cluster/jenkins/.ssh/jenkins -vvv
172.17.0.3