# lab-jenkins

build jenkins cluster:
```
vagrant up

#or reload config after changes
vagrant reload --provision
```

Instances
- [jenkins](http://192.168.1.200:8080), [log](http://192.168.1.200:8080/log/all)
- [docker registry](http://192.168.1.200:5000/v2/_catalog)
- slaves



### REFs

- https://hub.docker.com/r/jenkins/agent/
- https://devopscube.com/docker-containers-as-build-slaves-jenkins/
- https://scriptcrunch.com/enable-docker-remote-api/