# Azure DevOps 
This directory contains Azure DevOps pipeline examples and details regarding best practises.  

### Azure DevOps Temp Dir

```
echo "Secret Data" > $(Agent.TempDirectory)/secret.txt

```

### Azure DevOps GOOD MARKETPLACE PLUGINS
https://marketplace.visualstudio.com/items?itemName=YodLabs.VariableTasks


### Stage Condition

```
parameters:
- name: 'StgCond'
  default: Val1
  type: string
  displayName: "Select StgCond!"
  values:
  - Val1
  - Val2
  
stages
- stage: Stage_Condition
  condition: eq('${{ parameters.StgCond }}', 'Val1')
```
