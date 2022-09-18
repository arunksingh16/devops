# Git Basics

- Follow perfect commit, commit those files or part of code which comes under one issue/fix or whatever, do not bulk commit!
```
$ git add <filename>
# partial commit
$ git add -p <filename> 
```
- Branches - Short running / long running 
- Merge / Rebase
- Branch Strategies GitHub Flow / GitFlow / Release Flow
- Pull req (you can simply merge code but if you want to get it controlled and reviewed )


#### To find all commits that added or removed the "hello"

```
# list commit only
$ git log -S "hell0" --source --all
# list data in commit
$ git log --all -p --reverse --source -S 'hell0'
$ git log --color -p -S 'hell0'
# setting alias
$ git config --global alias.find '!git log --color -p -S '; git find hell0
```

#### To remove unwanted commit 
```
# assuming you are on a commit, The HEAD~1 means the commit before head.
$ git reset --hard HEAD~1 

# specific commit
$ git reset --hard <sha1-commit-id>

# if you have pushed that commit then
$ git push origin HEAD --force

```



#### gitignore
```
https://github.com/github/gitignore
```


#### update your .gitconfig file

```
$ git config --global --list
$ git config --global user.name "Firstname LastName"
$ git config --global user.email "yourEmail@email.com"
$ git config --global core.editor "yourFavoriteTextEditor"
```

#### Generic Flow

- do not work on master !

```
$ git checkout -b x-feature-work
$ git checkout dev
$ git merge x-feature-work
$ git branch -d x-feature-work
$ git checkout dev
$ git branch -d YYYY-MM-DD

```

#### before commit

```
$ git pull origin master
$ git push origin master
$ git push --set-upstream origin master
< > <  > <remote> <current>
```

#### Tracked Files
```
$ git ls-files
```

#### unstage file
```
$ git reset HEAD <file>
```

#### trace commit

```
$ git log <file name>
$ git log --all --graph --decorate --oneline
$ git show <id>
```

#### Merge conflicts


#### Merge / REBASE

#### Graph

```
$ git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'

$ git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'

$ git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'
```


### Rebase
```
# check history
$ git log --oneline
# decide how many commits you want to rebase, lets do it 10
$ git rebase -i HEAD~10
# something wrong
git rebase --abort
```

### file delete
If you want to remove the file from the Git repository and the filesystem, use:
```
git rm file1.txt
git commit -m "remove file1.txt"
```
But if you want to remove the file only from the Git repository and not remove it from the filesystem, use:
```
git rm --cached file1.txt
git commit -m "remove file1.txt"
```
And to push changes to remote repo
```
git push origin branch_name
```

### branch delete
To delete the local branch use one of the following:
```
git branch -d <branch_name>
git branch -D <branch_name>
```
remote
```
git push <remote_name> --delete <branch_name>
```

Fetch changes from all remotes and locally delete 
- remote deleted branches/tags etc --prune will do the job
```
git fetch --all --prune
```
