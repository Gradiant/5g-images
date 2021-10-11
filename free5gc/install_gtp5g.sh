#!/bin/bash

pushd /tmp

git clone https://github.com/PrinzOwO/gtp5g.git
cd gtp5g
make clean && make
sudo make install

popd