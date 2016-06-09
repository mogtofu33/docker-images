# Specific and usefull bash aliases.

## Bash ##

# Interactive operation...
alias t='tail -n200'
alias rmf='rm -rf'

# Misc :)
alias gp='grep -nr'
alias ss='egrep'
alias fgp='fgrep'
alias gphp='grep -nr --include=*.{php,module,inc}'
alias gphpi='grep -nr -C 5 --include=*.{php,module,inc}'

# Some shortcuts for different directory listings
alias ll='ls -lA'
alias la='ls  -lA -1'
alias l='ls -lA'

# Custom alias
alias c='clear'
## get rid of command not found ##
alias cd..='cd ..'

## A quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# Create parent directories on demand
alias mkdir='mkdir -pv'

# Handy short cuts #
alias h='history'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Get web server headers #
alias header='curl -I'

# Find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

## set some other defaults ##
alias du='du -ch'

# Show text file without comment (#) lines
alias nocomm='grep -Ev '\''^(#|$)'\'''

# Grabs the disk usage in the current directory
alias usage='du -ch 2> /dev/null |tail -1'

# file tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias findfn="find . -name"

# tar
alias tarc='tar -zcvf'
alias untar='tar -zxvf'

## Drush ##

# Aliases for common Drush commands that work in a global context.
alias dr='drush'
alias ddd='drush drupal-directory'
alias dl='drush pm-download'
alias ev='drush php-eval'
alias sa='drush site-alias'
alias lsa='drush site-alias --local-only'
alias st='drush core-status'
alias use='drush site-set'

# Aliases for Drush commands that work on the current drupal site
alias cc='drush cache-clear'
alias cr='drush cache-rebuild'
alias cca='drush cache-clear all'
alias dis='drush pm-disable'
alias en='drush pm-enable'
alias pmi='drush pm-info'
alias pml='drush pm-list'
alias rf='drush pm-refresh'
alias unin='drush pm-uninstall'
alias up='drush pm-update'
alias upc='drush pm-updatecode'
alias updb='drush updatedb'
alias q='drush sql-query'
alias lup='drush locale-check && drush locale-update'

# Clean
alias wda='drush -y wd-del all'
alias ifa='drush image-flush --all -y'

# Features
alias dfd='drush features-diff'
alias dfr='drush features-revert'
alias dfr='drush features-revert all'
alias dfu='drush features-update'

# Watchdog logs
alias dws='drush ws --tail --count=5'

# Find information on drush cmd
alias drs='drush | egrep'

