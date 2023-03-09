#!/usr/bin/env bash

git add .

echo -n "enter commit message: "

read message

git commit -S -m "$message"

git push -u origin master