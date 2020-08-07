# Git Basics

 update your .gitconfig file

```
git config --global user.name "Firstname LastName"
git config --global user.email "yourEmail@email.com"
git config --global core.editor "yourFavoriteTextEditor"
```

## flow can be followed


do not work on master !

git checkout -b x-feature-work

```
git checkout dev
git merge x-feature-work
git branch -d x-feature-work
git checkout dev
git branch -d YYYY-MM-DD

```
