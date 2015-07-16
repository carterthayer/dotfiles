#!/bin/bash

### Variables
DIR=`dirname $0`
cd $DIR
DIR=`pwd`
FILES=".bashrc .vim .wallpaper.png .xmobarrc .xmonad .Xresources .xsessionrc"

PROGRAMS_ARG=false
FILES_ARG=false
VIRTUAL_ARG=false


for i in "$@"; do
    if [ $i == "all" ]; then
	PROGRAMS_ARG=true
	FILES_ARG=true
	VIRTUAL_ARG=true
    fi
    if [ $i == "programs" ]; then
	PROGRAMS_ARG=true
    fi
    if [ $i == "files" ]; then
	FILES_ARG=true
    fi
    if [ $i == "virtual" ]; then
	VIRTUAL_ARG=true
    fi
done

### Install programs
if [ $PROGRAMS_ARG = true ]; then
    apt-get install libx11-dev xmonad suckless-tools xinit xmobar xterm \
        x11-xserver-utils feh xcompmgr firefox python-pip python-dev cmake \
        build-essentials
    pip install virtualenv virtualenvwrapper
fi

### Link in files
if [ $FILES_ARG = true ]; then
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
fi


### Virtual box guest addition
if [ $VIRTUAL_ARG = true ]; then
    mount /dev/cdrom /mnt
    cd /mnt 
    ./VBoxLinuxAdditions.run
    shutdown -r now
fi
