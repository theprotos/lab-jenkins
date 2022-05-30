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

docker exec -it jenkins bash



https://plugins.jenkins.io/docker-plugin/

curl -X GET http://0.0.0.0:5000/v2/_catalog

ssh-keygen -f ./jenkins -t rsa -C "" -N ""

docker run -d jenkins/ssh-agent "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEJpykWZv0JFqwfapv6TIpETY2C64BfoV4p8CjmEX4s8RJlBkyQYwWlzj8G1cts/A1JeppIrBPPtrROd6sTr4f1v8jgipVJta37wT68JhjZDMOViCxKApERgiDl94kiyidik3hbq9elFNjluhuWx/wrsX1uBuUWVdIv9x13DFeCEenAot4QnUYtg9wEg5VNe9v3E5BlOGFgEfGOg/xEeCOMohj8cKl+M3YX5vOYsJAyvS8CX6KQOZ3fQ3oRMdnQnzKJW4Tmtr7QEMNeiCfcNvKRHY77zdQYdOz7jW5NWbCHgayFDe8HqSP6BnZbiFsgJDqFRiNnGn3LnwYVvpvmqdr"

#get ip
docker inspect <container>
ssh jenkins@172.17.0.5 -i /vagrant/cluster/jenkins/.ssh/jenkins -vvv
172.17.0.3