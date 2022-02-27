#!/bin/sh
aws iam create-user --user-name arun
aws iam add-user-to-group --group-name FullAdministrator --user-name arun
aws iam create-login-profile --user-name arun --password <pass> --password-reset-required
aws iam create-access-key --user-name arun
