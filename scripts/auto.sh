#!/usr/bin/env bash
Green="\e[32m"

git add .

echo -n "enter commit message: "

read -r message

git commit -S -m "$message"

git push -u origin master

echo -e  "${Green}All Changes Pushed Successfully"
