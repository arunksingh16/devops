## AWS CLI USING DOCKER


Using AWS CLI docker image for all tasks 

```
$ docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure
```

Using Alias
```
$ alias aws='docker run --rm -it amazon/aws-cli'
```
