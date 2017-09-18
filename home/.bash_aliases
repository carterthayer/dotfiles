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


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias rmpyc="find . -name '*.pyc' -delete"

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
    extension="${filename##*.}"
    syntax=$extension
    if [ $extension == 'py' ]
    then
        syntax='python'
    fi
    vim <(git show HEAD:$file) -c "set syntax=$syntax"
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

  builtin cd "$@"  # do actual cd

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


