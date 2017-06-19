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
    sudo make install
    make clean
    popd
done
popd

if [[ $(sudo dmesg | grep VirtualBox) ]] && [ -z "$(lsmod | grep vboxguest)" ]; then
    read -p "Please add VirtualBox guest additions [y/n]:" yn
        case $yn in
            [Yy]* ) sudo mount /media/cdrom; sudo sh /media/cdrom/VBoxLinuxAdditions.run; break;;
            * ) break;;
        esac
fi

# link dot files
pushd home/
for i in $(ls -A); do
    rm -r ~/$i || true
    ln -sv $(pwd)/$i ~/
done
popd

# vim plugins
if command -v vim >/dev/null 2>&1; then
    vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
fi
