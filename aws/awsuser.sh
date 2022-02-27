#!/bin/sh
aws iam create-user --user-name arun
aws iam add-user-to-group --group-name FullAdministrator --user-name arun
aws iam create-login-profile --user-name arun --password <pass> --password-reset-required
aws iam create-access-key --user-name arun
######### Another way #########
read -p ''Enter the username for the new IAM User Object: '' username && touch ./$username
read -p ''Enter the initial password for AWS Management Console Access: '' initialpassword && echo ''Your temporary AWS Management Console password is $initialpassword'' > ./$username

aws iam create-user --user-name $username >> ./$username
aws iam add-user-to-group --group-name FullAdministrator --user-name $username >> ./$username
aws iam create-login-profile --user-name $username --password $initialpassword --password-reset-required >> ./$username
aws iam create-access-key --user-name $username >> ./$username
