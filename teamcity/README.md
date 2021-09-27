# teamcity
Repository for Teamcity CI-CD Tool

### TEAMCITY
- Jetbrain product
- Server - Agent Model
- Teamcity cloud or Installer 
- Tomcat

#### Example Docker Based deployment

Create Network
```
sudo docker network create teamcity
```

Server 
```
sudo docker run -u 0 -it --name teamcity-server-instance -v /home/arun/devops/teamcity/datadir:/data/teamcity_server/datadir -v /home/arun/devops/teamcity/logs:/opt/teamcity/logs -p 8111:8111 --network teamcity jetbrains/teamcity-server
```
Agent
```
sudo docker run --name teamcity-agent -u 0 -it -e SERVER_URL="http://teamcity-server-instance:8111" -v /home/arun/devops/teamcity/agent/conf:/data/teamcity_agent/conf --network teamcity jetbrains/teamcity-agent
```
Please dont use localhost. Use docker container ip if required.
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container-id>
```

#### Example Docker Compose

- default environment variable file named .env sets teamcity version
- refer docker-compose.yml file for config details
- https://github.com/JetBrains/teamcity-docker-samples/tree/master/compose-ubuntu


#### Managing Agents
- Connect Manually on machine and deploy required softwares
- Use CM tool
- Docker Container
- Teamcity Agent


