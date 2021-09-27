# devops
A repository for DevOps Learning


### What is CI
Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early.
By integrating regularly, you can detect errors quickly, and locate them more easily.
- https://www.thoughtworks.com/continuous-integration

### What is CD
Continuous Deployment is closely related to Continuous Integration and refers to the release into production of software that passes the automated tests.
"Essentially, it is the practice of releasing every good build to users”, explains Jez Humble, author of Continuous Delivery.
- https://www.thoughtworks.com/continuous-integration

## workstation
https://ohmyz.sh/#install


## Folders explained


> #### **Azure_ARM**
>
> - Azure ARM templates example
</br>


> #### **azcli**
>
> - Azure CLI Examples
</br>

> #### **curl**
>
> - Curl Examples
</br>

> #### **gitbasics**
>
> - Git Specific Knowledge
</br>


> #### **helm-cheatsheet**
>
> - Helm Details
</br>


> #### **kubernetes**
>
> - Deploying Jenkins using Kubernetes
</br>


> #### **openssl**
>
> - OpenSSL Example 
</br>


> #### **pipelines**
>
> - Azure DevOps Pipeline examples
</br>


> #### **powershell**
>
> - Powershell Scripts
</br>

> #### **python**
>
> - Python Scripts
</br>

> #### **shell**
>
> - Shell Scripts
</br>


> #### **tips**
>
> - Tips
</br>

> #### **windows**
>
> - Azure Powershell
</br>



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

dangling vol
```
docker volume ls -qf dangling=true | xargs -r docker volume rm
```
