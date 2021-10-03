## AWS CLI USING DOCKER


Using AWS CLI docker image for all tasks 

```
$ docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure
```

Using Alias is very helpful
```
$ alias aws='docker run --rm -it amazon/aws-cli'
$ aws --version
###########################################################################
#### output
#### aws-cli/2.2.41 Python/3.8.8 Linux/5.10.25-linuxkit docker/x86_64.amzn.2 prompt/off
##########################################################################
```
