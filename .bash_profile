#This file is sourced by bash when you log in interactively.
source ~/.host_roles.bash .bash_profile
[ -f ~/.bashrc ] && . ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash
