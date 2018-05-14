#!/bin/bash

BASEDIR=`dirname $0`

# install requirements from apt-get and pip

sudo apt-get -y update

sudo apt-get -y install $(grep -vE "^\s*#" $BASEDIR/apt_get_installs.txt | tr "\n" " ")


# link dot files
pushd home/
for i in $(ls -A); do
    rm -r ~/$i || true
    ln -sv $(pwd)/$i ~/
done
popd
