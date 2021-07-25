# Git Basics



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
