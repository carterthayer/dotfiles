#!/bin/bash

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# for my fat fingers
alias sl='ls'
alias sls='ls'
alias scd='cd'
alias cclear='clear'
alias gti='git'
alias svim='vim'

#git undo commit
alias guc='git reset --soft HEAD~'

alias pytohn='python'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias awsprofile='aws configure set default.profile'
