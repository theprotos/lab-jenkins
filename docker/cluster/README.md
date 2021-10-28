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