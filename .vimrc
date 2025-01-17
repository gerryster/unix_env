" An example for a vimrc file from /usr/share/vim/vim64
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ryan Gerry's .vimrc file
" all effect indenting and tabs vs spaces
set expandtab    " change tabs to spaces.  A real tab can be inserted as long
                 " as it is escaped by a Ctrl + V.
set shiftwidth=2 " number of spaces to use for autoindent
set tabstop=2    " if tab is pressed, how many colums to move

" remove all trailing white space on write:
" see http://www.vim.org/tips/tip.php?tip_id=721 for more info.
"autocmd BufWritePre * :%s/\s\+$//e

" autoindent and smartindent work well together
set autoindent
set smartindent

" enable case insensitive searching
set ignorecase
" but do case sensative searching when upper case characters are present in
" the query
set smartcase

" no annoying highligh search
set nohlsearch


" make backspacing more natural
set backspace=eol,start,indent

syntax enable
" comment
vmap # <Esc>'<Oif (0) {<Esc>'>o}<Esc>:'<,'>><CR>

" make syntax highlighting work well with a black background
" hi Comment ctermfg=2
set bg=dark

" toggle number display.  noremap means that <C-n> cannot be mapped later on
noremap <C-n> :set number!<CR>
noremap <C-p> :set paste!<CR>

" t = summarize unit tests for the current file being edited
" t is actually the till command but I never use that
" apparently # and ! have special meaning to vim, so we have to escape them
noremap t <Esc>:wa<CR>:!clear; export FILENAME=%.run; echo -e '\#\!/bin/bash\nrt --union %' > $FILENAME; DB_TESTS=1 prove $FILENAME; rm -f $FILENAME; export FILENAME=''<CR>
" same as above not summarized
noremap T <Esc>:wa<CR>:!clear; echo DB_TESTS=1 rt --verbose --union %; DB_TESTS=1 rt --verbose --union % 2>&1 \| less<CR>
" testing debugging
noremap td <Esc>:wa<CR>:!DB_TESTS=1 perl -d ~/xdev-modules/perltest/rt --union %<CR>

" check perl syntax
noremap <F2> <Esc>:wa<CR>:!perl -cw %<CR>
" view POD
noremap <F3> <Esc>:wa<CR>:!perldoc %<CR>
" run the file being edited
noremap <F11> <Esc>:wa<CR>:!./% 2>&1 \| less<CR>

" pluggins
:nnoremap <silent> <F8> :Tlist<CR>
:nnoremap <silent> <F9> :SVNDiff<CR>

" treat varius files as Perl
au! BufRead,BufNewFile *.t set syn=perl
au! BufRead,BufNewFile *.mx set syn=perl
au! BufRead,BufNewFile *.sql.TEMPLATE set syn=sql

set textwidth=0

" a backup file will be generated during a vim session and deleted upon exit
set nobackup
set writebackup

set encoding=utf8

vmap sb "zdi<b><C-R>z</b><ESC> " wrap <b></b> around VISUALLY selected Text

" run pf on the VISUALLY selected text
" this would be better if it opened the file up in a new window
vmap pf "zy<Esc>:!pf <C-R>z<CR>

" show diff when running svn commit (from svncommand.vim)
" Sadly, this does not work
au BufNewFile,BufRead  svn-commit.* setf svn
au FileType svn map <Leader>sd :SVNCommitDiff<CR>

" HTML::Mason syntax highlighting from
" http://www.masonbook.com/book/appendix-c.mhtml
au BufNewFile,BufRead *.mas set ft=mason

function! HighlightTooLongLines()
  highlight def link RightMargin Error
  if &textwidth != 0
    exec 'match RightMargin /\%<' . (&textwidth + 4) . 'v.\%>' . (&textwidth + 2) . 'v/'
  endif
endfunction

" Spell checking :help spell
" ]s searches for the next misspelling
" z= shows suggestions
function Spell()
  :setlocal spell spelllang=en_us
endfunction

"" for clojure
" http://www.assembla.com/wiki/show/clojure/Getting_Started_with_Vim
" http://www.vim.org/scripts/script.php?script_id=2501
set nocompatible
filetype plugin indent on
let vimclojure#HighlightBuiltins = 1

call pathogen#infect()

" suggestion from http://vim.wikia.com/wiki/Avoid_the_escape_key
inoremap jk <Esc>

set spell
