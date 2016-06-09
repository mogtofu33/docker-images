# Global PS1 for containers

# Color Definitions for .bashrc
COL_RED="\[\e[1;31m\]"
COL_GRE="\[\e[1;32m\]"
COL_YEL="\[\e[0;33m\]"
COL_PUR="\[\e[0;35m\]"
COL_BLU="\[\e[1;34m\]"
COL_GRA="\[\e[0;36m\]"

# Bash Prompt
if test "$UID" -eq 0 ; then
  _COL_USER=$COL_RED
else
  _COL_USER=$COL_GRE
fi

MYIP=$(ip addr show dev eth0 | grep "inet " | cut -d" " -f6 | cut -d"/" -f1 | awk '{ print $1}')
#MYIP=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

PS1="${_COL_USER}\u${COL_GRA}@${COL_BLU}${CONTAINER_NAME}${COL_YEL}[${MYIP}]${COL_PUR}:\w${COL_BLU}$ \[\e[m\]"
