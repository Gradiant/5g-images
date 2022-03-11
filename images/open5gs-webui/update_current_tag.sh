#/bin/bash

current_tag=`wget -O- -q https://api.github.com/repos/open5gs/open5gs/git/refs/tags/ | jq -r '.[].ref' | cut -d '/' -f3 | cut -c2- | tail -1`
sed -i "s/TAG=.*/TAG=${current_tag}/g" Makefile
