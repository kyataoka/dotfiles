"dein
if &compatible
    set nocompatible
endif
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:toml= expand('~/dotfiles/dein.toml')
    let s:toml_lazy = expand('~/dotfiles/dein_lazy.toml')
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:toml_lazy, {'lazy': 1})

    call dein#end()

    call dein#save_state()
endif
if dein#check_install()
    call dein#install()
endif
"/dein

" Modern Vim
set nocompatible
filetype plugin indent on
syntax enable

" UTF-8
scriptencoding utf-8
set encoding=utf8
set fileencoding=utf-8

" No dumps
set noswapfile
set nowritebackup
set nobackup

" Surpress warnings when switch buffers having changes
set hidden

" Normal backspace
set backspace=indent,eol,start

" Show cmd in status line
set showcmd

set ruler
set number

" Default indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

autocmd FileType c              setl ts=4 sw=4 sts=4 et
autocmd FileType javascript     setl ts=2 sw=2 sts=2 et
autocmd FileType javascript.jsx setl ts=2 sw=2 sts=2 et
autocmd FileType toml           setl ts=4 sw=4 sts=4 et

augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.mkd set filetype=markdown
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.toml set filetype=toml
augroup END
