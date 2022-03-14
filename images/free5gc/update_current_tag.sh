#/bin/bash

current_tag=`wget -O- -q https://api.github.com/repos/free5gc/free5gc/git/refs/tags/ | jq -r '.[].ref' | cut -d '/' -f3 | cut -c2- | tail -1`
echo "updating IMAGE_TAG to ${current_tag} in image_info.sh"
sed -i "s/IMAGE_TAG=.*/IMAGE_TAG=${current_tag}/g" image_info.sh
