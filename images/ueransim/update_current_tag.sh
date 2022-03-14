#/bin/bash

current_tag=`wget -O- -q https://api.github.com/repos/aligungr/UERANSIM/git/refs/tags/ | jq -r '.[].ref' | cut -d '/' -f3 | cut -c2- | tail -1`
sed -i "s/TAG=.*/TAG=${current_tag}/g" Makefile
