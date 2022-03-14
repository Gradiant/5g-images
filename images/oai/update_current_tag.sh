#/bin/bash

current_tag=`wget -O- -q https://gitlab.eurecom.fr/api/v4/projects/223/repository/tags | jq -r '.[].name' | head -1`
echo "updating IMAGE_TAG to ${current_tag} in image_info.sh"
sed -i "s/IMAGE_TAG=.*/IMAGE_TAG=${current_tag}/g" image_info.sh