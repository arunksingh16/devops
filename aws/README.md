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
- https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html
- api gateway domain name api mapping
```
aws apigatewayv2 get-api-mappings --domain-name xxxxxx 
```

- pull name of api gateway using API-ID
```
aws apigatewayv2 get-apis --query 'Items[?ApiId==`xxxxxx`].Name' --output text
```

- lambda list
```
aws lambda list-functions --region us-east-1 --query 'Functions[].FunctionName' --output text
aws lambda list-functions --region us-east-1 --query 'Functions[?starts_with(FunctionName, `some-prefix`) == `true`].FunctionName' --output text
```

- lambda env
```
aws lambda get-function-configuration --function-name xxxxxx --query "Environment.Variables"
```

- ecr
```
export REPOSITORY_URI=$(aws ecr describe-repositories --query 'repositories[].[repositoryUri]' --output text)
echo ${REPOSITORY_URI}
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
aws ecs create-cluster --cluster-name XXXX
```
- EC2
```
SN_DATE=$(date '+%Y-%m-%d')
SN_DATE=$(date -d "-3 month" +"%Y-%m-%d")

aws ec2 describe-snapshots --owner self --query "Snapshots[?StartTime <= '${SN_DATE}' && State == 'completed'].{Id:SnapshotId,VId:VolumeId,Size:VolumeSize,StartTime:StartTime,State:State}" --output text

aws ec2 describe-snapshots --owner self --query "sum(Snapshots[?StartTime <= '${SN_DATE}' && State == 'completed'].VolumeSize.to_number(@))"
```

Good Tool to review 
- https://github.com/benkehoe/aws-sso-util
