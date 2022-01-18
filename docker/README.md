
### DOCKER TIPS


#### Docker Help 

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

dangling vol
```
docker volume ls -qf dangling=true | xargs -r docker volume rm
```

run with mounting volume
```
docker run --name ubuntu -v C:/arun/:/opt  --rm -it centos:centos7
```

#### Benchmarking Docker Python Images
```
BENCHMARK="import timeit; print(timeit.timeit('import json; json.dumps(list(range(10000)))', number=5000))"
docker run python:2-alpine3.6 python -c $BENCHMARK

docker run python:2-slim python -c $BENCHMARK

docker run python:3-alpine3.6 python -c $BENCHMARK

docker run python:3-slim python -c $BENCHMARK

```

