# Jenkins java-agents

- Dockerfile.dind
```
sudo docker build -t jnlp-linux-dind -f Dockerfile.dind .
docker run -it jnlp-linux-dind bash
docker exec -it jnlp-linux-dind bash
docker logs jnlp-linux-dind
```

- Dockerfile.jdk8
```
sudo docker build -t jnlp-linux-jdk8 -f Dockerfile.jdk8 .
```

- Dockerfile.jdk11
```
sudo docker build -t jnlp-linux-jdk11 -f Dockerfile.jdk11 .
```
