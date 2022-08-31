# AWS

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

## AWS METADATA
```
$ curl http://169.254.169.254/latest/user-data
$ curl http://169.254.169.254/latest/meta-data
```

## AWS CLI

export AWS_CLI_AUTO_PROMPT=on

`--generate-cli-skeleton` parameter to create a full template for the object then use it as per your req
```
$ aws iam create-user --generate-cli-skeleton yaml-input > admin.yml
$ aws iam create-user --cli-input-yaml file://admin.yml
```

config location
```
cat <home>/.aws/config
```

```
aws configure
# list profiles
aws configure list-profiles
# acccess profile
aws configure --profile trndev
export AWS_PROFILE=trndev
aws sts get-caller-identity
```

#### AWS POLICY
```
$ aws iam list-policies --scope AWS
$ aws iam list-policies --scope Local
```

#### AWS CLI Examples
- api gateway domain name api mapping
```
aws apigatewayv2 get-api-mappings --domain-name xxxxxx 
```

- pull name of api gateway using API-ID
```
aws apigatewayv2 get-apis --query 'Items[?ApiId==`xxxxxx`].Name' --output text
```
