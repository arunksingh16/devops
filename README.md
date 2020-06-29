# devops
A repository for DevOps Learning

## workstation
https://ohmyz.sh/#install


### Docker Help 

stop all containers:
```
docker kill $(docker ps -q)
````
remove all containers
```
docker rm $(docker ps -a -q)
```

remove all docker images
```
docker rmi $(docker images -q)
```
