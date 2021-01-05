# Much of this bashrc file is from the book "Automating UNIX and Linux
# Administration" by Kirk Bauer.  Apress, 2003.  ISBN: 1590592123
#
# This file is sourced by all *interactive* bash shells on startup.  This
# file *should generate no output* or it will break the scp and rcp commands.
#
# All page numbers correspond to:
# O'Reilly's "Learning the Bash shell", 2nd Ed.
# unless otherwise stated

# Deal with OS's like Darwin where VPN clients like to change the
# host name
if [ -f ~/.real_hostname ]; then
  HOSTNAME=`cat ~/.real_hostname`;
fi

# Change the window title of X terminals
case $TERM in
	xterm*|rxvt|Eterm|eterm)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

# Databases:

# so that Oracle's sqlplus sees the login.sql file in my home dir
export SQLPATH=$HOME

# DB2 setup
if [ -f /home/rgerry/sqllib/db2profile ]; then
    source /home/rgerry/sqllib/db2profile
fi

####################### David Bush's prompt magic #####################

#Detect OS
case $(uname -s) in
	Linux) os=linux ;;
	CYGWIN_NT-5.0) os=cygwin ;;
	*[Bb][Ss][Dd]) os=bsd ;;
	Darwin) os=darwin ;;
	*) os=unix ;;
esac

#Global Definitions
if [ -f /etc/bashrc ] ; then
	source /etc/bashrc
fi

#ls alias

unset ALL
if [ $UID -eq 0 ] ; then
	ALL='-a'
fi

if [ "$os" = "linux" ] ; then
	alias ls='/bin/ls $ALL --classify'
elif [ -x /usr/local/bin/ls ] ; then
	alias ls='/usr/local/bin/ls $ALL --classify'
elif [ -x /usr/bin/ls ] ; then
	alias ls='/usr/bin/ls $ALL'
elif [ -x /usr/local/bin/gnuls ] ; then
	alias ls='/usr/local/bin/gnuls --classify'
else
	alias ls='/bin/ls $ALL -F'
fi



#Define ANSI color sequences

NORMAL="\[\033[0m\]"
WHITE="\[\033[0;37;38m\]"
#WHITE="\[\033[1;35;38m\]"
CYAN="\[\033[0;36;36m\]"
BRIGHTBLUE="\[\033[1;34;38m\]"
BRIGHTWHITE="\[\033[1;37;38m\]"
#BRIGHTWHITE="\[\033[0;35;38m\]"
BRIGHTCYAN="\[\033[1;36;36m\]"
BRIGHTMAGENTA="\[\033[1;35;40m\]"

#Find out if we are root

if [ $UID -eq 0 ] ; then
   # The # character serves as an extra reminder that I am root
   SYM='#'
else
   SYM='-'
fi

# https://github.com/jimeh/git-aware-prompt
# TODO: set this up using a git remote
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

determine_previous_command_result() {
  local result=$?
  case "$result" in
   0) previous_command_success_icon='✓'
      previous_command_error_icon='' ;;
   *) previous_command_error_icon="⚠  $result"
      previous_command_success_icon='' ;;
  esac
}

PROMPT_COMMAND="determine_previous_command_result; $PROMPT_COMMAND"

#Define the actual prompt
P1="$CYAN$SYM$BRIGHTCYAN-$BRIGHTBLUE($WHITE\u$CYAN@$WHITE"
P2="\h$BRIGHTBLUE)$BRIGHTCYAN-$BRIGHTBLUE($BRIGHTWHITE\w$BRIGHTBLUE"
P3=")$BRIGHTCYAN-$BRIGHTBLUE\$git_branch\[$txtred\]\$git_dirty$BRIGHTCYAN-$CYAN$SYM$NORMAL\n$CYAN$SYM$BRIGHTCYAN-"
P4="$BRIGHTBLUE($BRIGHTWHITE\$previous_command_success_icon\$previous_command_error_icon$BRIGHTBLUE)$CYAN>$NORMAL "
PS1="$P1$P2$P3$P4"

####################### variables ############################

# Andy Lester's ack:
export ACK_COLOR_MATCH=underline
export ACK_COLOR_FILENAME=green

# export EDITOR='subl -w'
# TODO(make vim the editor if the subl symlink does not point to anything)
export EDITOR='code --wait'

# history stuff:
# HISTCONTROL controls what is added to the history file, ignoreboth means don't but blank lines or duplicates in (p. 67)
HISTCONTROL=ignoreboth
HISTFILESIZE=10000

export PATH=$HOME/bin:\
$HOME/local/bin:\
/usr/local/bin:\
$PATH

# put /usr/local/share/man first for osx with homebrew
export MANPATH=$HOME/local/man:/usr/local/share/man:$MANPATH

####################### aliases ############################
alias cd..='cd ..'
# csh style: alias psg='ps -ax | grep \!* | grep -v grep'
alias psg='ps -ax | grep $1 | grep -v grep'
alias l="ls -alF"
alias ll="l |less"
alias lsl="ls|less"
alias psme="ps -fu $USER"
alias lpsme="ps -flu $USER" # long format
alias psusers="ps -eo user,pid,args | sort | less"
alias v=vim
alias e="$EDITOR ."

# screen
#export TERM_ORIG=$TERM
### This causes problems with gnome-terminal.  Setting TERM manually here
### causes tab completion to print out strange characters.
#export TERM=screen
alias sr="screen -r"
alias sx="screen -x"
alias sl="screen -list" # list all of the available screens
alias sS="screen -U -S" # start a screen session and specify a name in UTF-8 mode (-U)
alias alert='tput bel'

alias hg="history|grep"

# config file stuff:
alias vbrc="v ~/.bashrc" # edit the bashrc file
alias vhbrc="v ~/host_config/$HOSTNAME/.bashrc" # edit the host specific bashrc file
alias vbp="v ~/.bash_profile" # edit the bash profile file
alias vvrc="v ~/.vimrc" # edit the vim config
alias sbrc="source ~/.bashrc"
alias sbp="source ~/.bash_profile"

# ruby
alias be="bundle exec"
alias bopen="EDITOR=atom bundle open"
alias rchanged='git diff --name-only | xargs bundle exec rubocop'

####################### Subversion ###########################
# svn stuff
alias sd="svn diff | $PAGER"

####################### Perforce #############################
export P4DIFFOPTS=-du

####################### functions ############################
# print $PATH replacing ':' with '\n'.
# Also prints anything in PATH format (separated by ':') given as an argument.
# See page 102 of bash book for an explanation of the echo statement
#
# this has a BUG where if an undefined variable is passed, the function prints out $PATH
function prettypath {
	if [ -z "$1" ]; then        # no argument given, use $PATH
		echo -e ${PATH//:/'\n'}
	else                     # print arg 1
		OTHER_PATH=$1
		echo -e ${OTHER_PATH//:/'\n'}
	fi
}

# list what files / directories are taking the most space
function space {
	du -sk * | sort -n
}

# print the source of the current directory assuming it is a svn or svk repo
function scm_source {
    if [ -e .svn ]; then
        svn info | grep URL
    else
        svk info | grep 'Depot Path:'
    fi
}

function topdf {
    enscript  --title='$1' -fCourier8 --header-font=Courier-Bold8 --pretty-print=perl --line-numbers -p- $1 --tabsize=4 | ps2pdf - $1.pdf
}

# Find the plist file for something in LaunchCtl:
# This is required to unload a deamon so that it does not get restarted.
# http://stackoverflow.com/questions/18502705/how-to-know-a-specific-launchd-plist-file-location
launchctlFind () {
    LaunchctlPATHS=( \
        ~/Library/LaunchAgents \
        /Library/LaunchAgents \
        /Library/LaunchDaemons \
        /System/Library/LaunchAgents \
        /System/Library/LaunchDaemons \
    )

    for curPATH in "${LaunchctlPATHS[@]}"
    do
        grep -r "$curPATH" -e "$1"
    done
    return 0;
}

####################### host specific config #####################
if [ -f ~/host_config/$HOSTNAME/.bashrc ]; then
      source ~/host_config/$HOSTNAME/.bashrc
fi

####################### Darwin specific #########################

if [ "$os" = "darwin" -a -f /sw/bin/init.sh ] ; then
  source /sw/bin/init.sh
fi

export TZ='America/Chicago'

# support my the host_roles directory defined for this host
source ~/.host_roles.bash .bashrc

# RVM for ruby http://rvm.beginrescueend.com/rvm/install/
#[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

####################### Git #########################
source ~/bin/git-completion.bash
alias gs="git stat"
alias gp="git pull"
alias gps="git push"
alias gdas="git diff && git stat"
# https://stackoverflow.com/questions/2466821/how-do-i-pipe-in-filemerge-as-a-diff-tool-with-git-on-os-x
alias gdopendiff="git difftool -t opendiff -y"
alias gd="git diff"
alias gds="git diff --staged"
alias gdh="git diff head"
# Adapted from http://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit :
alias grecent="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' | tail"

# Thanks MHB!
# use "gitg --all" to see the whole tree
gitg () {
        git log --graph --color --date-order --date=short --pretty=tformat:"%h [%an] %ad%Cred%d%Creset %s" "$@" | less -R -S
}

PATH=$PATH:$HOME:/usr/local/Cellar/mysql@5.6/5.6.38/bin


# in Bash 4.0 and later: The new autocd option causes bash to change to the directory that is the first word in a command.
shopt -s autocd

####################### GPG #########################
# This allows GPG v2 to work with Git.
# https://stackoverflow.com/questions/39494631/gpg-failed-to-sign-the-data-fatal-failed-to-write-commit-object-git-2-10-0
export GPG_TTY=$(tty)

####################### AWS #########################
# This breaks the Ruby client!!!
# export AWS_CONFIG_FILE=~/.aws

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


####################### rbenv #########################
# eval "$(rbenv init -)"

####################### pow #########################
export POW_TIMEOUT=86400  # (one day)

# command multiplexer
function cmux {
  for dir in *; do
    cd $dir
    echo
    echo "Run '$@' in project $dir..."
    "$@"
    cd ..
done
}

####################### Rails/Ruby #########################
alias migrateall="be rake db:migrate && RAILS_ENV=test be rake db:migrate"
alias migratetest="RAILS_ENV=test be rake db:migrate"
alias reset_test="RAILS_ENV=test be rake db:reset --trace"
alias reset_and_run="reset_test && be rspec; say tests done"
alias test_and_notify="be rspec; notifyme tests done"
alias r="be rake"

####################### Node #########################
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Elixir
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# added by travis gem
[ -f /Users/rgerry/.travis/travis.sh ] && source /Users/rgerry/.travis/travis.sh

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

####################### Home Brew #########################
# load all installed completions (https://apple.stackexchange.com/questions/103818/bash-not-running-script-at-opt-local-etc-bash-completion-d):
if [ -d /usr/local/etc/bash_completion.d ]; then
    for F in "/usr/local/etc/bash_completion.d/"*; do
        if [ -f "${F}" ]; then
            source "${F}";
        fi
    done
fi

####################### Docker #########################
alias d=docker
alias dl='docker images'
alias dr='docker run'
alias doc=docker-compose
