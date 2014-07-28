"
"                       __   _(_)_ __ ___  _ __ ___
"                       \ \ / / | '_ ` _ \| '__/ __|
"                        \ V /| | | | | | | | | (__
"                       (_)_/ |_|_| |_| |_|_|  \___|
"
" Author: Xianzhe Liang <liangxianzhe@gmail.com>
" Source: https://github.com/liangxianzhe/oh-my-vim

" Setup language {{{ ==========================================================

" language en_US.UTF-8           " Solve some plugins incompatibilities

" }}}

set nocompatible             " No to the total compatibility with the ancient vi

" TODO use vimscript to check update, this will leave some blank lines after
" leaving vim
silent !sh $OH_MY_VIM/tools/check_for_upgrade.sh

" Load external configuration before anything else {{{

let s:before_vimrc = expand('~/.before.vimrc')
if filereadable(s:before_vimrc)
    exec ':so ' . s:before_vimrc
endif
" }}}
"
" NEOBUNDLE {{{ ===============================================================

" NeoBundle auto-installation and setup {{{

" Auto installing NeoBundle
let iCanHazNeoBundle=1
let neobundle_readme=expand($OH_MY_VIM."/bundle/neobundle.vim/README.md")
let neobundle_runtimepath=expand($OH_MY_VIM."/bundle/neobundle.vim/")
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    execute "silent !mkdir -p ".$OH_MY_VIM."/bundle"
    execute "silent !git clone https://github.com/Shougo/neobundle.vim ".$OH_MY_VIM."/bundle/neobundle.vim"
    let iCanHazNeoBundle=0
endif

" Call NeoBundle
if has('vim_starting')
    let &rtp=neobundle_runtimepath.','.&rtp
endif

call neobundle#begin(expand($OH_MY_VIM.'/bundle/'))

" is better if NeoBundle rules NeoBundle (needed!)
NeoBundle 'Shougo/neobundle.vim'
" }}}

" BUNDLES (plugins administrated by NeoBundle) {{{

" Shougo's way {{{

" Vimproc to asynchronously run commands (NeoBundle, Unite)
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

" Unite. The interface to rule almost everything
NeoBundle 'Shougo/unite.vim'

" Unite sources
NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}}
NeoBundleLazy 'tsukkee/unite-help', {'autoload':{'unite_sources':'help'}}
NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':
            \ 'colorscheme'}}
NeoBundleLazy 'ujihisa/unite-locate', {'autoload':{'unite_sources':'locate'}}
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' :
            \ ['history/command', 'history/search']}}
NeoBundleLazy 'osyo-manga/unite-filetype', { 'autoload' : {'unite_sources' :
            \ 'filetype', }}
NeoBundleLazy 'osyo-manga/unite-quickfix', {'autoload':{'unite_sources':
            \ ['quickfix', 'location_list']}}
NeoBundleLazy 'osyo-manga/unite-fold', {'autoload':{'unite_sources':'fold'}}
NeoBundleLazy 'tacroe/unite-mark', {'autoload':{'unite_sources':'mark'}}
NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':'tag'}}
NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':
            \ ['file_mru', 'directory_mru', 'neomru/file']}}

" }}}

" END BUNDLES }}}

" <Leader> & <LocalLeader> mapping {{{

let mapleader=','
let maplocalleader= ' '

" }}}

" menus {{{

let g:unite_source_menu_menus = {}

" menu prefix key (for all Unite menus) {{{
nnoremap [menu] <Nop>
nmap <LocalLeader> [menu]
" }}}

" menus menu
nnoremap <silent>[menu]u :Unite -silent -winheight=20 menu<CR>

" }}}

" Local vimrc configuration {{{

let s:local_vimrc = expand('~/.local.vimrc')
if filereadable(s:local_vimrc)
    exec ':so ' . s:local_vimrc
endif

" }}}

" Auto install the plugins {{{

" First-time plugins installation
if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :NeoBundleInstall
endif

" Check if all of the plugins are already installed, in other case ask if we
" want to install them (useful to add plugins in the .vimrc)
NeoBundleCheck

" }}}
call neobundle#end()

filetype plugin indent on      " Indent and plugins by filetype

" END NEOBUNDLE }}}


" IMPORT PACKAGES {{{

for package in g:oh_my_vim_packages
    let package_path = $OH_MY_VIM . "/packages/" . package . ".vimrc"
    if filereadable(package_path)
        exec ':so ' package_path
    endif
endfor

" END IMPORT PACKAGES }}}


" PLUGINS Setup {{{

" }}}

" Font {{{

set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 11

" " }}}}

" Neomru {{{

let g:neomru#file_mru_path = $OH_MY_VIM.'/tmp/neomru/file'
let g:neomru#directory_mru_path = $OH_MY_VIM.'/tmp/neomru/directory'

" }}}

" Unite {{{

" files
nnoremap <silent><Leader>o :Unite -silent -start-insert file<CR>
nnoremap <silent><Leader>O :Unite -silent -start-insert file_rec/async<CR>
nnoremap <silent><Leader>m :Unite -silent neomru/file<CR>
" buffers
nnoremap <silent><Leader>b :Unite -silent buffer<CR>
" tabs
nnoremap <silent><Leader>B :Unite -silent tab<CR>
" buffer search
nnoremap <silent><Leader>f :Unite -silent -no-split -start-insert -auto-preview
            \ line<CR>
nnoremap <silent>[menu]8 :UniteWithCursorWord -silent -no-split -auto-preview
            \ line<CR>
" yankring
nnoremap <silent><Leader>i :Unite -silent history/yank<CR>
" help
nnoremap <silent> g<C-h> :UniteWithCursorWord -silent help<CR>
" tasks
nnoremap <silent><Leader>; :Unite -silent -toggle
            \ grep:%::FIXME\|TODO\|NOTE\|XXX\|COMBAK\|@todo<CR>
" outlines (also ctags)
nnoremap <silent><Leader>t :Unite -silent -vertical -winwidth=40
            \ -direction=topleft -toggle outline<CR>

" }}}

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_mru,file_rec,file_rec/async,grep,locate',
            \ 'ignore_pattern', join(['\.git/', 'tmp/', 'bundle/'], '\|'))

let g:unite_source_history_yank_enable = 1
let g:unite_enable_start_insert = 0
let g:unite_enable_short_source_mes = 0
let g:unite_force_overwrite_statusline = 0
let g:unite_prompt = '>>> '
let g:unite_marked_icon = '✓'
" let g:unite_candidate_icon = '∘'
let g:unite_winheight = 15
let g:unite_update_time = 200
let g:unite_split_rule = 'botright'
let g:unite_data_directory = $OH_MY_VIM.'/tmp/unite'
let g:unite_source_buffer_time_format = '(%d-%m-%Y %H:%M:%S) '
let g:unite_source_file_mru_time_format = '(%d-%m-%Y %H:%M:%S) '
let g:unite_source_directory_mru_time_format = '(%d-%m-%Y %H:%M:%S) '

" }}}


" END PLUGINS SETUP }}}

" Additional Configuration {{{

let s:after_vimrc = expand('~/.after.vimrc')
if filereadable(s:after_vimrc)
    exec ':so ' . s:after_vimrc
endif

" }}}
