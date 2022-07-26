# Jenkins pre-baked server

## File structure 

conf:  
- *.groovy - create folder and seed jobs
- *.yaml - jenkins config: agents, views, tools
- plugins.txt


```
#docker build - < Dockerfile
sudo docker build -t jenkins -f Dockerfile .
docker run -it jenkins bash
docker exec -it jenkins bash
docker logs jenkins
```



### REFs
[Suspended agents](https://support.cloudbees.com/hc/en-us/articles/204690520-Why-do-Shared-Agents-Cloud-show-as-suspended-status-while-jobs-wait-in-the-queue-)

