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

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

#Define the actual prompt

# TODO: the problem with the return code is that the git prompt command is running before $? evaluates.  Perhaps $? can be saved off?
P1="$CYAN$SYM$BRIGHTCYAN-$BRIGHTBLUE($WHITE\u$CYAN@$WHITE"
P2="\h$BRIGHTBLUE)$BRIGHTCYAN-$BRIGHTBLUE($BRIGHTWHITE\w$BRIGHTBLUE"
P3=")$BRIGHTCYAN-$BRIGHTBLUE($NORMAL\$(parse_git_branch)$BRIGHTBLUE)$BRIGHTCYAN-$CYAN$SYM$NORMAL\n$CYAN$SYM$BRIGHTCYAN-"
P4="$BRIGHTBLUE($BRIGHTWHITE\$?$BRIGHTBLUE)$CYAN>$NORMAL "
PS1="$P1$P2$P3$P4"

####################### variables ############################

# Andy Lester's ack:
export ACK_COLOR_MATCH=underline
export ACK_COLOR_FILENAME=green

# export EDITOR='subl -w'
# TODO(make vim the editor if the subl symlink does not point to anything)
export EDITOR=vim

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

# screen
#export TERM_ORIG=$TERM
### This causes problems with gnome-terminal.  Setting TERM manually here
### causes tab completion to print out strange characters.
#export TERM=screen
alias sr="screen -r"
alias sx="screen -x"
alias sl="screen -list" # list all of the available screens
alias sS="screen -U -S" # start a screen session and specify a name in UTF-8 mode (-U)

alias hg="history|grep"

# config file stuff:
alias vbrc="v ~/.bashrc" # edit the bashrc file
alias vbp="v ~/.bash_profile" # edit the bash profile file
alias vvrc="v ~/.vimrc" # edit the vim config
alias sbrc="source ~/.bashrc"
alias sbp="source ~/.bash_profile"

# ruby
alias be="bundle exec"

####################### Subversion ###########################
# svn stuff
alias sd="svn diff | $PAGER"

####################### Perforce #############################
export P4DIFFOPTS=-du

####################### functions ############################
# print $PATH replacing ':' with '\n'.
# Also prints anything in PATH format (seporated by ':') given as an argument.
# See page 102 of bash book for an explination of the echo statement
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
alias gd="git diff head"
alias gds="git diff && git stat"

# Thanks MHB!
# use "gitg --all" to see the whole tree
gitg () {
        git log --graph --color --date-order --date=short --pretty=tformat:"%h [%an] %ad%Cred%d%Creset %s" "$@" | less -R -S
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# in Bash 4.0 and later: The new autocd option causes bash to change to the directory that is the first word in a command.
shopt -s autocd

####################### AWS #########################
export AWS_CONFIG_FILE=~/.aws

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


####################### rbenv #########################
eval "$(rbenv init -)"

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
