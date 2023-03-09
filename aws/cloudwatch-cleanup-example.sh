#!/bin/bash

# Set the region and log group prefix
LOG_GROUP_PREFIX="/aws/appsync/apis/"
AWSProfile = "MY-DEV"

# Get a list of all the log groups with the specified prefix in the specified region
LOG_GROUPS=$(aws logs describe-log-groups --log-group-name-prefix $LOG_GROUP_PREFIX  --query "logGroups[*].logGroupName" --output text --profile $AWSProfile)

# Loop through each log group and check if its associated AppSync API still exists
for LOG_GROUP in $LOG_GROUPS
do
  # Extract the AppSync API ID from the log group name
  API_ID=$(echo $LOG_GROUP | sed "s|$LOG_GROUP_PREFIX||")

  # Check if the AppSync API with the extracted ID still exists
  API_EXISTS=$(aws appsync get-graphql-api --api-id $API_ID  --output text --query "graphqlApi.apiId" --profile $AWSProfile 2>/dev/null)

  # If the API does not exist, delete the log group
  if [ -z "$API_EXISTS" ]
  then
    
    echo "Deleting log group $LOG_GROUP..."
    aws logs describe-log-groups --log-group-name-prefix $LOG_GROUP --query 'logGroups[*].[logGroupName,storedBytes]' --profile $AWSProfile --output text
    aws logs delete-log-group --log-group-name $LOG_GROUP --profile $AWSProfile
  fi
done

echo "Log group cleanup complete."
