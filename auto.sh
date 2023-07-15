#!/usr/bin/env bash
Green='\033[0;32m'

git add .

echo -n "enter commit message: "

read -r message

git commit -S -m "$message"

git push -u origin master

echo "${Green}All Changes Pushed"
