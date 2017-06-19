#!/bin/bash

BASEDIR=`dirname $0`

# install requirements from apt-get and pip

sudo apt-get -y update

sudo apt-get -y install $(grep -vE "^\s*#" $BASEDIR/apt_get_installs.txt | tr "\n" " ")
sudo pip install -U pip
sudo pip install $(grep -vE "^\s*#" $BASEDIR/pip_installs.txt | tr "\n" " ")

# this is needed for virtualbox guest additions, but requires the uname -r in it
sudo apt-get -y install linux-headers-$(uname -r)

# install sub modules
pushd $BASEDIR/requirements/
for i in $(ls -d -- */); do
    pushd $i
    make
    make install
    make clean
    popd
done
popd

if [[ $(dmesg | grep VirtualBox) ]] && [ -z "$(lsmod | grep vboxguest)" ]; then
    read -p "Please add VirtualBox guest additions [y/n]:" yn
        case $yn in
            [Yy]* ) sudo sh /media/cdrom/VBoxLinuxAdditions.run; break;;
            * ) break;;
        esac
fi
