#!/bin/bash

set -ex

source variables.env

for test in tests/*; do
    echo "running test $test"
    cd $test
    echo "image is $IMAGE"
    ./run.sh
    cd -
done