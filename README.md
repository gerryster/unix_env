## Installation

```
$ cd $HOME
git clone --bare git@github.com:gerryster/unix_env.git .git
# Cloning the repo with the "bare" option allows it to be created in an existing directory.
$ vim .git/config
# remove the "bare=true" line
$ git checkout master
```

## Atom packages to install
* copy-path
* linter
* linter-eslint
* vim-mode
* git-plus
* custom-title with this config `<%= relativeFilePath %><% if (projectPath && gitHead) { %> [<%= gitHead %>] <% } %>`


## Sublime Text Packages to Install:

Package Control
GotoRecent
Git
Haml
SideBarEnhancements
SublimeLinter
All Autocomplete
HTML5
sublime-github
Syntax Highlight for SASS
BracketHighlighter
lispindent
SublimeREPL
sublime-paredit
