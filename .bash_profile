#This file is sourced by bash when you log in interactively.
source ~/.host_roles.bash .bash_profile
[ -f ~/.bashrc ] && . ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
