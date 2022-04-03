## Installation

```
$ cd $HOME
git clone --bare git@github.com:gerryster/unix_env.git .git
# Cloning the repo with the "bare" option allows it to be created in an existing directory.
$ vim .git/config
# remove the "bare=true" line
$ git checkout main

# Git Aware Prompt:
cd ~/.bash
git clone https://github.com/jimeh/git-aware-prompt.git
```

## VS Code Extensions to install

* All Autocomplete
* Atom Keymap
* Code Spell Checker
* EditorConfig for VS Code
* GitLense
* markdownlint
* npm intellisense
* Open in Github (highly recommended! Also works with Bitbucket)
* Ruby
* ruby-rubocop
* vscode-spitify
* YAML
* YAML key viewer
* [Paste and Indent](https://marketplace.visualstudio.com/items?itemName=Rubymaniac.vscode-paste-and-indent)

## Atom packages to install
* copy-path
* [linter](https://atom.io/packages/linter)
* linter-eslint
* vim-mode
* git-plus
* custom-title with this config `<%= relativeFilePath %><% if (projectPath && gitHead) { %> [<%= gitHead %>] <% } %>`
* set-syntax
* [goto-definition](https://atom.io/packages/goto-definition)
* [open-on-bitbucket](https://atom.io/packages/open-on-bitbucket)

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
