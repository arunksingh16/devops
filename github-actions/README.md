


```
on:
  push:
    branches:    
      - main
      - 'releases/**'
    tags:        
      - v2
      - v1.*
    tags-ignore:        
      - v1.1.*
  pull_request:
    branches:    
      - main
    branches-ignore:    
      - 'releases/**-alpha'


```
