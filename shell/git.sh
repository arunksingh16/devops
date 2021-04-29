#!/bin/bash

# list all branches
git for-each-ref --format='%(refname:short)' refs/heads |
while read branch; do

    echo $branch
    git checkout $branch
    git branch -m 'features/$branch'
    git push origin -u 'features/$branch'
    git push origin --delete $branch
done 
