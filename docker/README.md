
### DOCKER TIPS



#### Benchmarking Python
```
BENCHMARK="import timeit; print(timeit.timeit('import json; json.dumps(list(range(10000)))', number=5000))"
docker run python:2-alpine3.6 python -c $BENCHMARK

docker run python:2-slim python -c $BENCHMARK

docker run python:3-alpine3.6 python -c $BENCHMARK

docker run python:3-slim python -c $BENCHMARK

```
