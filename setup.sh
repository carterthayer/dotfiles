#!/bin/bash

### Variables
DIR=`dirname $0`
cd $DIR
DIR=`pwd`
FILES=".bashrc .vim .wallpaper.png .xmobarrc .xmonad .Xresources .xsessionrc"

### Install programs
if [ $1=='install' || $2=='install' ]; then
    apt-get install libx11-dev xmonad suckless-tools xinit xmobar xterm \
        x11-xserver-utils feh xcompmgr firefox python-pip python-dev cmake \
        build-essentials
    pip install virtualenv virtualenvwrapper
fi

### Link in files

for file in $FILES; do
	if [ -e ~/$file ]
	then
		if [ ! -e ~/.dotfiles_old/ ]
		then
			mkdir ~/.dotfiles_old/
		fi
		mv ~/$file ~/.dotfiles_old/
	fi
	ln -s $DIR/$file ~/$file
done

### Setup YouCompleteMe
cd .vim/bundle/YouCompleteMe
git submodule update --init --recursive
./install.sh --clang-completer


### Virtual box guest addition
if [ $1=='virtual' || $2=='virtual' ]; then
    mount /dev/cdrom /mnt
    cd /mnt 
    ./VBoxLinuxAdditions.run
    shutdown -r now
fi
