#/bin/bash

current_tag=`wget -O- -q https://gitlab.eurecom.fr/api/v4/projects/223/repository/tags | jq -r '.[].name' | head -1`
sed -i "s/TAG=.*/TAG=${current_tag}/g" Makefile
