# Git Basics

- Follow perfect commit, commit those files or part of code which comes under one issue/fix or whatever, do not bulk commit!
```
git add <filename>
# partial commit
git add -p <filename> 
```
- Branches - Short running / long running 
- Merge / Rebase
- Branch Strategies GitHub Flow / GitFlow / Release Flow
- Pull req (you can simply merge code but if you want to get it controlled and reviewed )




```
git status
```

gitignore 

```
https://github.com/github/gitignore
```


update your .gitconfig file

```
git config --global --list
git config --global user.name "Firstname LastName"
git config --global user.email "yourEmail@email.com"
git config --global core.editor "yourFavoriteTextEditor"
```

## flow can be followed


do not work on master !



```
git checkout -b x-feature-work
git checkout dev
git merge x-feature-work
git branch -d x-feature-work
git checkout dev
git branch -d YYYY-MM-DD

```

## before commit

```
git pull origin master
git push origin master
git push --set-upstream origin master
< > <  > <remote> <current>
```

## Tracked Files
```
git ls-files
```

## unstage file
```
git reset HEAD <file>
```

## trace commit

```
git log <file name>
git log --all --graph --decorate --oneline
git show <id>

```

## Merge conflicts


## Merge / REBASE

## Graph

```

git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'

git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'

git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'
```
