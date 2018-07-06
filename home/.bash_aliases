#!/bin/bash

# some aliases that were in my bashrc at some point
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Aliases for common misspellings, to not slow me down
alias sl='ls'
alias sls='ls'
alias scd='cd'
alias cclear='clear'
alias gti='git'
alias svim='vim'
alias pytohn='python'

# Make opening ptpython correct
alias ptpython='python -m ptpython'
alias ptpython3='python3 -m ptpython'

# No need to remember how to open a tar file
alias untar='tar -xvzf'


alias rmpyc='find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf'
alias wifi-scan="nmcli device wifi rescan && nmcli device wifi list"
alias wifi-connect="nmcli device wifi connect"

alias pipgdal='pip install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal"'


#
# Usage: open-package <python package>
#
# Open the source directory for a python package installed in the current virtualenv
#
open-package(){

    if [ -z "$VIRTUAL_ENV" ]; then
        echo "No virtual env active"
        return 1
    else
        cd $VIRTUAL_ENV/lib/python$(python -c "import sys; print('.'.join(str(x) for x in sys.version_info[0:2]))")/site-packages/$1
    fi
}

#
# Usage: init3
#
# Initialize a virtual environment with python2 for the project in the current directory
#
init2(){
    mkvirtualenv $(basename $(pwd)) -a . --python=python2
}

#
# Usage: init3
#
# Initialize a virtual environment with python3 for the project in the current directory
#
init3(){
    mkvirtualenv $(basename $(pwd)) -a . --python=python3
}

#
# Usage: rf <search string>
#
# Search for files with name including the <search string>
#
rf(){
    find . -type f -path "*$1*" -exec sh -c '
        for f do
            git check-ignore -q "$f" ||
                echo "$f"
        done
        ' find-sh {} +
}

#
# Usage: rv <search string>
#
# Search for provided string with rg and open the files containing with the string highlighted in vim.
#
#
rv(){
    vim $(rg -l "$@") +/"$@"
}


#
# Usage: awsprofile
#        awsprofile <profile-name>
#
# Print out the AWS_DEFAULT_PROFILE environment variable or set it to <profile-name>
# This is used, so a default profile isn't set and isn't accidentally used.
#
awsprofile(){
    if [ ! -z "$1" ]; then
        export AWS_DEFAULT_PROFILE=$1
    else
        echo "$AWS_DEFAULT_PROFILE"
    fi
}

#
# Usage: old <file>
#
# Open the <file> with vim at the HEAD version of the file
#
old(){
    file=./$@
    filename=$(basename "$file")
    temp_dir=$(mktemp -d)

    git show HEAD:$file > $temp_dir/$filename
    vim $temp_dir/$filename
}

#
# Usage: loadhistory
# Load the bash history for the current directory
#
# Adapted from:
# https://github.com/aaronharnly/dotfiles-public/blob/master/.bash-functions.s://github.com/aaronharnly/dotfiles-public/blob/master/.bash-functions.sh 
function loadhistory()
{
  local HISTDIR="$HOME/.bash_history.d$PWD" # use nested folders for history
  if [ ! -d "$HISTDIR" ]; then # create folder if needed
    mkdir -p "$HISTDIR"
  fi
  export HISTFILE="$HISTDIR/${USER}_bash_history.txt" # set new history file
  history -c  # clear memory
  history -r #read from current histfile

}

#
# Usage: mycd <path>
#
#  Replacement for builtin 'cd', which keeps a separate bash-history
#   for every directory, activates the appropriate virtualenv
#
# Adapted from:
# https://github.com/aaronharnly/dotfiles-public/blob/master/.bash-functions.s://github.com/aaronharnly/dotfiles-public/blob/master/.bash-functions.sh 

function mycd()
{
  #
  # set new bash history for this directory
  #
  history -w # write current history file

  # do actual cd
  builtin cd "$@"

  #if [[ $# -ne 0 ]] || [ -z "$VIRTUAL_ENV" ] && [ ! -f "$VIRTUAL_ENV/.project" ]; then
  #  builtin cd "$@"
  #else
  #  builtin cd $(cat "$VIRTUAL_ENV/.project")
  #fi

  loadhistory "$@"

  #
  # if we're entering a project directory, check for a virtualenv
  #
  if [ -z "$WORKINGON" ]; then
    for venv_dir in $WORKON_HOME/*; do
        if [ -f "$venv_dir/.project" ] && [ "$(cat $venv_dir/.project)" == "$PWD" ]; then
          if [ -z "$VIRTUAL_ENV" ] ; then
            venv_name=$(basename "$venv_dir")
            echo "Activating virtualenv $venv_name..."
            export WORKINGON="$venv_name"
            workon "${venv_name}"
          fi
        fi
    done
  else
    unset WORKINGON
  fi
}
alias cd="mycd" ; export HISTFILE="$HOME/.dir_bash_history$PWD/${USER}_bash_history.txt"


#
# Usage: hist <search-string>
# Use rg to search all the history files
#
function hist(){
    rg "$@" ~/.bash_history.d/
}
