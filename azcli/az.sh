# list account
az account list --output table

az account list --output json

az account list --query "[].{resource:resourceGroup, name:name}" -o table

az account set --subscription


