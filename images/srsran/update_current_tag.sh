#/bin/bash

current_tag=`wget -O- -q https://api.github.com/repos/srsran/srsRAN/git/refs/tags/ | jq -r '.[].ref' | grep release | cut -d '/' -f3 | cut -c9- | tail -1`
echo "updating IMAGE_TAG to ${current_tag} in image_info.sh"
sed -i "s/IMAGE_TAG=.*/IMAGE_TAG=${current_tag}/g" image_info.sh