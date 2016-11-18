#!/bin/bash

# install requirements from apt-get and pip

sudo apt-get install $(grep -vE "^\s*#" apt_get_installs.txt | tr "\n" " ")
sudo pip install $(grep -vE "^\s*#" pip_installs.txt | tr "\n" " ")

# this is needed for virtualbox guest additions, but requires the uname -r in it
sudo apt-get install linux-headers-$(uname -r)

# install sub modules
pushd requirements/
for i in $(ls -d -- */); do
    pushd $i
    make
    make install
    make clean
    popd
done
popd

# link dot files
pushd home/
for i in $(ls -A); do
    rm -r ~/$i || true
    ln -sv $(pwd)/$i ~/
done
popd
