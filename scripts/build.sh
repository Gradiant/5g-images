#!/bin/bash

default_branch=main
images_dir=images

list_changed=`git diff --name-only $default_branch -- $images_dir | cut -f1-2 -d'/' | uniq`

for image in $list_changed; do
    pushd $image
    make build
    popd
done
