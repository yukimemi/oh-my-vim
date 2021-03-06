"{{{ ========== Basics ================================================================
" vim config path"{{{
if isdirectory($HOME . '/.vim')
    let $MY_VIMRUNTIME = $HOME . '/.vim'
elseif isdirectory($HOME . '\vimfiles')
    let $MY_VIMRUNTIME = $HOME . '\vimfiles'
elseif isdirectory($VIM . '\vimfiles')
    let $MY_VIMRUNTIME = $VIM . '\vimfiles'
endif"}}}

" judge os type"{{{
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_darwin = has('mac') || has('macunix') || has('gui_macvim')
let s:is_linux = !s:is_windows && !s:is_cygwin && !s:is_darwin"}}}

" release autogroup in MyAutoCmd"{{{
augroup MyAutoCmd
    autocmd!
augroup END"}}}

" Echo startup time on start"{{{
if has('vim_starting') && has('reltime')
    let g:startuptime = reltime()
    augroup MyAutoCmd
        autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
                    \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
    augroup END
endif"}}}
"===================================================================================}}}

"{{{ ========== System ================================================================
" use clipboard
set clipboard+=unnamed
" for log files
au MyAutoCmd BufNewFile,BufRead *.csv,*.log setl nowrap
" no insert comment
au MyAutoCmd FileType * set formatoptions-=ro
" http://d.hatena.ne.jp/osyo-manga/20140210/1392036881
au MyAutoCmd CmdwinEnter * :silent! 1,$-20 delete _ | call cursor("$", 1)
"===================================================================================}}}

"{{{ ========== Search ================================================================
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
set grepprg=grep\ -nH
" use verymagic
nnoremap / /\v
inoremap %s/ %s/\v
"===================================================================================}}}

"{{{ ========== Appearance ============================================================
" set list
if s:is_windows
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<
else
"     set listchars=tab:\¦\ ,trail:-,extends:»,precedes:«,nbsp:%
endif
highlight Search ctermbg=88
"===================================================================================}}}

"{{{ ========== Function ============================================================
" Restore last cursor position when open a file"{{{
au MyAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"}}}

" highlight Zenkaku space"{{{
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
    silent! match ZenkakuSpace /　/
endfunction

if has('syntax')
    au MyAutoCmd VimEnter,BufEnter * call ZenkakuSpace()
endif"}}}

" autochdir"{{{
au MyAutoCmd BufEnter * execute ":silent! lcd " . escape(expand("%:p:h"), ' ')
"}}}

" use vimproc for system
let s:system = exists('g:loaded_vimproc') ? 'vimproc#system_bg' : 'system'

function! Rtrim()"{{{
    " delete space at the end of line
    let save_cursor = getpos(".")
    %s/\s\+$//e
    call setpos(".", save_cursor)
endfunction
au MyAutoCmd BufWritePre *.coffee,*.js,*.ps1,*.md,*.jade,Vagrantfile call Rtrim()
"}}}

function! Format()"{{{
    " auto indent format
    let save_view = winsaveview()
    normal gg=G
    call winrestview(save_view)
endfunction
nnoremap <LocalLeader>f :call Format()<CR>
"au MyAutoCmd BufWrite * call Format()
"}}}

function! AddQuote()"{{{
    normal gg2dd
    17,$s/^/> /
    normal gg
endfunction
au MyAutoCmd FileType mail nnoremap <buffer> <LocalLeader>q :<C-u>silent! call AddQuote()<CR>
"}}}

function! s:open_in_browser()"{{{
    " open html in browser
    if s:is_windows
        silent ! start iexplore "%:p"
    else
        silent ! start firefox "%:p"
    endif
endfunction"}}}

" diff original"{{{
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
"}}}

" save as root"{{{
com! Wsu w !sudo tee > /dev/null %
"}}}
"===================================================================================}}}

"{{{ ========== Mappings ==============================================================
inoremap <silent> jj <ESC>

nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap h <Left>
nnoremap l <Right>
" open folding in "l"
nnoremap <expr> l foldlevel(line('.')) ? "\<Right>zo" : "\<Right>"
" for buffer
nnoremap gh :bp<CR>
nnoremap gl :bn<CR>

" like emacs
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-y> <C-r>

" Vim-users.jp - Hack #74: http://vim-users.jp/2009/09/hack74/
nnoremap <silent> <LocalLeader>ev  :<C-u>tabedit $MYVIMRC<CR>
nnoremap <silent> <LocalLeader>eg  :<C-u>tabedit $MYGVIMRC<CR>

" cmdwin
nnoremap : q:i
vnoremap : q:A

"  for git mergetool
if &diff
    nnoremap <Leader>1 :diffget LOCAL<CR>
    nnoremap <Leader>2 :diffget BASE<CR>
    nnoremap <Leader>3 :diffget REMOTE<CR>
    nnoremap <Leader>u :<C-u>diffupdate<CR>
    nnoremap u u:<C-u>diffupdate<CR>
endif

" hilight over 100 column {{{
" http://blog.remora.cx/2013/06/source-in-80-columns-2.html
noremap <Plug>(ToggleColorColumn)
            \ :<c-u>let &colorcolumn = len(&colorcolumn) > 0 ? '' :
            \   join(range(101, 9999), ',')<CR>

nmap cc <Plug>(ToggleColorColumn)"}}}
"===================================================================================}}}

"{{{ ========== Plugin Settings =======================================================
if neobundle#tap('vim-singleton')"{{{
    if has('clientserver')
        call singleton#enable()
    endif

    let g:singleton#ignore_pattern = {
                \ 'eml': ['\.eml$']
                \ }

    call neobundle#untap()
endif"}}}

if neobundle#tap('lightline.vim')"{{{
    if s:is_windows || s:is_cygwin
        let g:lightline = {
                    \ 'colorscheme': 'solarized',
                    \ 'mode_map': { 'c': 'NORMAL' },
                    \ 'active': {
                    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'anzu' ] ]
                    \ },
                    \ 'component_function': {
                    \   'modified': 'MyModified',
                    \   'readonly': 'MyReadonly',
                    \   'fugitive': 'MyFugitive',
                    \   'filename': 'MyFilename',
                    \   'fileformat': 'MyFileformat',
                    \   'filetype': 'MyFiletype',
                    \   'fileencoding': 'MyFileencoding',
                    \   'mode': 'MyMode',
                    \   'anzu': 'anzu#search_status'
                    \ }
                    \ }
    else
        let g:lightline = {
                    \ 'colorscheme': 'solarized',
                    \ 'mode_map': { 'c': 'NORMAL' },
                    \ 'active': {
                    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'anzu' ] ]
                    \ },
                    \ 'component_function': {
                    \   'modified': 'MyModified',
                    \   'readonly': 'MyReadonly',
                    \   'fugitive': 'MyFugitive',
                    \   'filename': 'MyFilename',
                    \   'fileformat': 'MyFileformat',
                    \   'filetype': 'MyFiletype',
                    \   'fileencoding': 'MyFileencoding',
                    \   'mode': 'MyMode',
                    \   'anzu': 'anzu#search_status'
                    \ },
                    \ 'separator': { 'left': '⮀', 'right': '⮂' },
                    \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
                    \ }
    endif
    function! MyModified()"{{{
        return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction"}}}

    function! MyReadonly()"{{{
        if s:is_windows
            return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'R' : ''
        else
            return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
        endif
    endfunction"}}}

    function! MyFilename()"{{{
        return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                    \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
                    \  &ft == 'unite' ? unite#get_status_string() :
                    \  &ft == 'vimshell' ? vimshell#get_status_string() :
                    \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
                    \ ('' != MyModified() ? ' ' . MyModified() : '')
    endfunction"}}}

    function! MyFugitive()"{{{
        if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
            let _ = fugitive#head()
            if s:is_windows
                return strlen(_) ? '| '._ : ''
            else
                return strlen(_) ? '⭠ '._ : ''
            endif
        endif
        return ''
    endfunction"}}}

    function! MyFileformat()"{{{
        return winwidth('.') > 70 ? &fileformat : ''
    endfunction"}}}

    function! MyFiletype()"{{{
        return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction"}}}

    function! MyFileencoding()"{{{
        return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction"}}}

    function! MyMode()"{{{
        return winwidth('.') > 60 ? lightline#mode() : ''
    endfunction"}}}

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-gitgutter')"{{{
    let g:gitgutter_sign_added = '✚'
    let g:gitgutter_sign_modified = '➜'
    let g:gitgutter_sign_removed = '✘'

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-submode')"{{{
    let g:submode_leave_with_key = 1

    " user prefix 's' http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
    nnoremap s <Nop>
    nnoremap sj <C-w>j
    nnoremap sk <C-w>k
    nnoremap sl <C-w>l
    nnoremap sh <C-w>h
    nnoremap sJ <C-w>J
    nnoremap sK <C-w>K
    nnoremap sL <C-w>L
    nnoremap sH <C-w>H
    nnoremap sn gt
    nnoremap sp gT
    nnoremap sr <C-w>r
    nnoremap s= <C-w>=
    nnoremap sw <C-w>w
    nnoremap so <C-w>_<C-w>|
    nnoremap s0 :<C-u>only<CR>
    nnoremap sO :<C-u>tabonly<CR>
    nnoremap sN :<C-u>bn<CR>
    nnoremap sP :<C-u>bp<CR>
    nnoremap st :<C-u>tabnew<CR>
    nnoremap sT :<C-u>Unite tab<CR>
    nnoremap ss :<C-u>sp<CR>
    nnoremap sv :<C-u>vs<CR>
    nnoremap sq :<C-u>q<CR>
    nnoremap sQ :<C-u>bd<CR>
    nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
    nnoremap sf :<C-u>Unite file -buffer-name=file<CR>
    nnoremap sF :<C-u>Unite file_rec/async -buffer-name=file_rec<CR>
    nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

    call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
    call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
    call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
    call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
    call submode#map('bufmove', 'n', '', '>', '<C-w>>')
    call submode#map('bufmove', 'n', '', '<', '<C-w><')
    call submode#map('bufmove', 'n', '', '+', '<C-w>+')
    call submode#map('bufmove', 'n', '', '-', '<C-w>-')

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-anzu')"{{{
    au MyAutoCmd BufEnter,BufLeave,BufWinEnter,BufWinLeave,WinEnter,CmdwinLeave * nnoremap <ESC><ESC> :<C-u>nohlsearch<CR>
    "nmap n <Plug>(anzu-mode-n)
    "nmap N <Plug>(anzu-mode-N)
    "nnoremap <expr> n anzu#mode#mapexpr("n", "", "zzzv")
    "nnoremap <expr> N anzu#mode#mapexpr("N", "", "zzzv")
    nmap n <Plug>(anzu-n)zzzv
    nmap N <Plug>(anzu-N)zzzv
    nmap * <Plug>(anzu-star)zzzv
    nmap # <Plug>(anzu-sharp)zzzv
    "set statusline=%{anzu#search_status()}

    call neobundle#untap()
endif"}}}

if neobundle#tap('TweetVim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['TweetVimVersion',
                \                'TweetVimAddAccount',
                \                'TweetVimSwitchAccount',
                \                'TweetVimHomeTimeline',
                \                'TweetVimMentions',
                \                'TweetVimListStatuses',
                \                'TweetVimUserTimeline',
                \                'TweetVimSay',
                \                'TweetVimUserStream',
                \                'TweetVimCommandSay',
                \                'TweetVimCurrentLineSay',
                \                'TweetVimSearch'],
                \   'unite_sources': ['tweetvim/account', 'tweetvim']
                \ }
                \ })

    au MyAutoCmd FileType tweetvim call s:my_tweetvim_mappings()
    nnoremap <LocalLeader>ut :<C-u>Unite tweetvim<CR>
    nnoremap <LocalLeader>us :<C-u>TweetVimUserStream<CR>

    function! s:my_tweetvim_mappings()
        setl nowrap
        nnoremap <buffer> <LocalLeader>s :<C-u>TweetVimSay<CR>
        nnoremap <buffer> <leader>s :<C-u>TweetVimSearch<Space>
        nnoremap <buffer> <LocalLeader>tl :<C-u>Unite tweetvim<CR>
        nnoremap <buffer> <LocalLeader>ta :<C-u>Unite tweetvim/account<CR>
    endfunction

    let g:tweetvim_default_account = "yukimemi"
    let g:tweetvim_tweet_per_page = 100
    let g:tweetvim_cache_size = 50
    "let g:tweetvim_display_username = 1
    let g:tweetvim_display_source = 1
    let g:tweetvim_display_time = 1
    "let g:tweetvim_display_icon = 1
    let g:tweetvim_async_post = 1

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-indent-guides')"{{{
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 1
    let g:indent_guides_start_level = 2
    let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'calendar', 'thumbnail']

    call neobundle#untap()
endif"}}}

if neobundle#tap('vimfiler.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['vimfiler_drive', 'vimfiler_execute', 'vimfiler_history',
                \                     'vimfiler_mask', 'vimfiler_popd', 'vimfiler_sort'],
                \   'mappings': [['n', '<Plug>(vimfiler_']],
                \   'commands': [{'complete': 'customlist,vimfiler#complete', 'name': 'Read'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'VimFiler'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'Edit'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'VimFilerExplorer'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'VimFilerSplit'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'Write'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'VimFilerDouble'},
                \                {'complete': 'customlist,vimfiler#complete', 'name': 'Source'}]
                \ }
                \ })

    nnoremap <Leader>f :<C-u>VimFiler -split -simple -toggle -winwidth=35 -no-quit<CR>
    nnoremap <C-e> :<C-u>VimFilerDouble<CR>
    nnoremap <expr><Leader>g <SID>git_root_dir()
    function! s:git_root_dir()
        " http://qiita.com/items/39134f75e9360e1e733d
        if(system('git rev-parse --is-inside-work-tree') == "true\n")
            return ':VimFiler ' . '-split ' . '-simple ' . '-winwidth=35 ' . '-no-quit '
                        \ . system('git rev-parse --show-cdup') . '\<CR>'
        else
            echoerr '!!!current directory is outside git working tree!!!'
        endif
    endfunction
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:vimfiler_as_default_explorer = 1
        let g:vimfiler_enable_auto_cd = 1
        if s:is_windows
            let g:unite_kind_file_use_trashbox = 1
        endif
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('vimshell.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['n', '<Plug>(vimshell_']],
                \   'commands': ['VimShell', 'VimShellPop']
                \ }
                \ })
    function! neobundle#tapped.hooks.on_source(bundle)
        " PATH
        if has('unix')
            " home bin
            let $PATH = $PATH . ':' . $HOME . '/bin:' . $HOME . '/bin/scripts'
            " homebrew
            let $PATH = '/usr/local/bin:' . $PATH
        endif

        let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
        let g:vimshell_enable_smart_case = 1

        let g:vimshell_execute_file_list['zip'] = 'zipinfo'
        call vimshell#set_execute_file('tgz,gz', 'gzcat')
        call vimshell#set_execute_file('tbz,bz2', 'bzcat')

        let g:vimshell_execute_file_list = {}
        call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
        let g:vimshell_execute_file_list['rb'] = 'ruby'
        let g:vimshell_execute_file_list['pl'] = 'perl'
        let g:vimshell_execute_file_list['py'] = 'python'
        call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

        au MyAutoCmd FileType vimshell
                    \ if ! s:is_windows
                    \| call vimshell#altercmd#define('i', 'iexe')
                    \| call vimshell#altercmd#define('ll', 'ls -l')
                    \| call vimshell#altercmd#define('la', 'ls -a')
                    \| call vimshell#altercmd#define('lla', 'ls -al')
                    \| call vimshell#altercmd#define('lv', 'vim -R')
                    \| call vimshell#altercmd#define('vimfiler', 'vim -c VimFilerDouble')
                    \| call vimshell#altercmd#define('rm', 'rmtrash')
                    \| call vimshell#altercmd#define('s', ':UniteBookmarkAdd .')
                    \| call vimshell#altercmd#define('g', ':Unite bookmark -start-insert')
                    \| call vimshell#altercmd#define('l', ':Unite bookmark')
                    \| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
                    \| else
                        \| call vimshell#altercmd#define('vimfiler', 'gvim -c VimFilerDouble')
                        \| endif


        function! g:my_chpwd(args, context)
            call vimshell#execute('ls')
        endfunction

        au MyAutoCmd FileType int-* call s:interactive_settings()
        function! s:interactive_settings()
        endfunction

        " history
        let g:vimshell_max_command_history = 5000000
        " mapping
        "nnoremap <LocalLeader>s :<C-u>VimShell<CR>
        au MyAutoCmd FileType vimshell inoremap <C-^> cd<Space>../<CR>
        au MyAutoCmd FileType vimshell imap <C-l> <Plug>(vimshell_clear)
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('vimshell-pure.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'on_source': ['vimshell.vim']
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('neocomplete.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'insert': 1
                \ }
                \ })
    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default': '',
                \ 'vimshell': $HOME . '/.vimshell_hist',
                \ 'scheme': $HOME . '/.gosh_completions',
                \ 'coffee': $MY_VIMRUNTIME . '/dict/coffee.dict',
                \ 'vbs': $MY_VIMRUNTIME . '/dict/vbs.dict',
                \ 'dosbatch': $MY_VIMRUNTIME . '/dict/dosbatch.dict',
                \ 'scala': $MY_VIMRUNTIME . '/dict/scala.dict',
                \ 'ps1': $MY_VIMRUNTIME . '/dict/ps1.dict',
                \ 'javascript': $MY_VIMRUNTIME . '/dict/wsh.dict'
                \ }

    " SQL
    if !exists('g:neocomplete#sources#omni#functions')
        let g:neocomplete#sources#omni#functions = {}
    endif
    let g:neocomplete#sources#omni#functions.sql = 'sqlcomplete#Complete'

    call neobundle#untap()
endif"}}}

if neobundle#tap('neosnippet.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'insert': 1,
                \   'unite_sources': ['neosnippet_file', 'snippet', 'snippet_target'],
                \   'mappings': [['sxi', '<Plug>(neosnippet_']],
                \   'commands': ['NeoSnippetEdit', 'NeoSnippetSource']
                \ }
                \ })

    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
    function! neobundle#tapped.hooks.on_source(bundle)
        " Tell Neosnippet about the other snippets
        let g:neosnippet#snippets_directory = $HOME . '/.snippets,'

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        " for unite
        imap <C-s> <Plug>(neocomplcache_start_unite_snippet)
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-help')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['help']
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-colorscheme')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['colorscheme']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('open-browser.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['sxn', '<Plug>(openbrowser-']],
                \   'commands': [{'complete': 'customlist,openbrowser#_cmd_complete', 'name': 'OpenBrowserSearch'},
                \                {'complete': 'customlist,openbrowser#_cmd_complete', 'name': 'OpenBrowserSmartSearch'},
                \                'OpenBrowser']
                \ }
                \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        " http://vim-users.jp/2011/08/hack225/
        nmap gx <Plug>(openbrowser-smart-search)
        vmap gx <Plug>(openbrowser-smart-search)
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('sonictemplate-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['sonictemplate'],
                \   'mappings': [['in', '<Plug>(sonictemplate']],
                \   'commands': ['Template']
                \ }
                \ })
    au MyAutoCmd BufNewFile *.rb Template template
    au MyAutoCmd BufNewFile *.ps1 Template template
    au MyAutoCmd BufNewFile *.cmd Template template
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:sonictemplate_vim_template_dir = $MY_VIMRUNTIME . '/template'
    endfunction
endif"}}}

if neobundle#tap('vim-fugitive') "{{{
    nnoremap <LocalLeader>gd :<C-u>Gdiff<Enter>
    nnoremap <LocalLeader>gs :<C-u>Gstatus<Enter>
    nnoremap <LocalLeader>gl :<C-u>Glog<Enter>
    nnoremap <LocalLeader>ga :<C-u>Gwrite<Enter>
    nnoremap <LocalLeader>gc :<C-u>Gcommit<Enter>
    nnoremap <LocalLeader>gC :<C-u>Git commit --amend<Enter>
    nnoremap <LocalLeader>gp :<C-u>Git pull --rebase<Enter>
    nnoremap <LocalLeader>gb :<C-u>Gblame<Enter>

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-quickrun')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['sxn', '<Plug>(quickrun']],
                \   'commands': {'complete': 'customlist,quickrun#complete', 'name': 'QuickRun'}
                \ }
                \ })
    "nnoremap <Leader>r <Plug>(quickrun)
    " echo quickrun command output {{{
    " http://d.hatena.ne.jp/osyo-manga/searchdiary?word=quickrun
    let s:hook = {
                \   "name": "output_command",
                \   "kind": "hook",
                \   "config": {
                \       "enable": 0,
                \       "log": 0
                \   }
                \ }

    function! s:hook.on_ready(session, context)
        HierClear
        for command in a:session.commands
            execute self.config.log ? "echom command" : "echo command"
        endfor
    endfunction

    call quickrun#module#register(s:hook, 1)
    unlet s:hook"}}}

    " TypeScript compile according to the reference path {{{
    let s:hook = {
                \ "name": "typescript_compile",
                \ "kind": "hook",
                \ "config": {
                \       "enable": 0
                \  }
                \ }
    function! s:hook.on_module_loaded(session, context)
        let references = []
        for line in readfile(a:session.config.srcfile, '', 15)
            if line =~ '^///<reference path='
                "echom 'reference : ' . line[stridx(line, '"') + 1 : -4]
                if line[stridx(line, '"') + 1 : -4] !~ 'lib.d.ts'
                    call add(references, line[stridx(line, '"') + 1 : -4])
                endif
            endif
        endfor
        "echom 'exec : %c --nolib %s ' . join(references, ' ') . ' --out %s:p:r.js'
        let a:session.config.exec = '%c --nolib %s ' . join(references, ' ') . ' --out %s:p:r.js'
    endfunction
    call quickrun#module#register(s:hook, 1)
    unlet s:hook"}}}

    " coffeescript compile {{{
    let s:hook = {
                \ "name": "coffeescript_compile",
                \ "kind": "hook",
                \ "config": {
                \       "enable": 0
                \  }
                \ }
    function! s:hook.on_module_loaded(session, context)
        let imports = []
        for line in readfile(a:session.config.srcfile, '', 15)
            if line =~ '^# import'
                "echom 'import : ' . line[10 : -2]
                call add(imports, line[10 : -2])
            endif
        endfor
        "echom 'exec : %c -j %s:p:r.js -cb ' . join(imports, ' ') . ' %s'
        let a:session.config.exec = '%c -j %s:p:r.js -cb ' . join(imports, ' ') . ' %s'
    endfunction
    call quickrun#module#register(s:hook, 1)
    unlet s:hook"}}}

    " add wsh header {{{
    let s:hook = {
                \ "name": "js2cmd",
                \ "kind": "hook",
                \ "config": {
                \       "enable": 0
                \  }
                \ }
    function! s:hook.on_success(session, context)
        let list = []
        call add(list, "@if(0)==(0) ECHO OFF")
        for line in readfile(a:session.config.srcfile, '', 10)
            if line =~ '^//' || line =~ '^#'
                if line[3 : 4] =~ 'OP' || line[2 : 3] =~ 'OP'
                    "echom 'option : ' . line[stridx(line, '"') + 1 : -2]
                    if line[stridx(line, '"') + 1 : -2] =~ '^pushd'
                        call add(list, "    pushd \"%~dp0\" > nul")
                        call add(list, "    CScript.exe //NoLogo //E:JScript \"%~f0\" %*")
                        call add(list, "    popd > nul")
                        break
                    else
                        call add(list, "    CScript.exe //NoLogo //E:JScript \"%~f0\" %*")
                        break
                    endif
                endif
            endif
        endfor
        call add(list, "pause")
        call add(list, "GOTO :EOF")
        call add(list, "@end")
        call add(list, "")
        let inJs = fnamemodify(a:session.config.srcfile, ":p:r") . '.js'
        let outCmd = fnamemodify(a:session.config.srcfile, ":p:h") . '/_cmd/'
                    \ . fnamemodify(a:session.config.srcfile, ":t:r") .'.cmd'
        "echom inJs
        "echom outCmd
        let utf8List = list + readfile(inJs, 'b')
        let cp932List = []
        for line in utf8List
            "call add(cp932List, iconv(line, "UTF-8", "CP932"))
            call add(cp932List, iconv(substitute(line, "\n", "\r\n", "",), "UTF-8", "CP932"))
        endfor
        if isdirectory(fnamemodify(a:session.config.srcfile, ":p:h") . '/_cmd')
            call writefile(cp932List, outCmd, 'b')
            if has('win32') || has('win64')
                "call {s:system}('del ' . inJs)
                call {s:system}('unix2dos ' . outCmd)
            else
                "call {s:system}('rm ' . inJs)
                call {s:system}('nkf --windows --overwrite ' . outCmd)
            endif
        else
            echom fnamemodify(a:session.config.srcfile, ":p:h") . '/_cmd' . 'is not found !'
        endif
    endfunction

    call quickrun#module#register(s:hook, 1)
    unlet s:hook"}}}

    let g:quickrun_config = {}
    let g:quickrun_config = {
                \   "_": {
                \       "hook/output_command/enable": 1,
                \       "hook/output_command/log": 1,
                \       "hook/close_unite_quickfix/enable_hook_loaded": 1,
                \       "hook/unite_quickfix/enable_failure": 1,
                \       "hook/close_quickfix/enable_exit": 1,
                \       "hook/close_buffer/enable_failure": 0,
                \       "hook/close_buffer/enable_empty_data": 1,
                \       "hook/echo/enable": 1,
                \       "hook/echo/output_success": "success!!!",
                \       "hook/echo/output_failure": "failure...",
                \       "outputter": "multi:buffer:quickfix",
                \       "outputter/buffer/split": ":botright 18sp",
                \       "runner": "vimproc",
                \       "runner/vimproc/updatetime": 40
                \   },
                \ "typescript": {
                \       "commad": "tsc",
                \       "cmdopt": "--nolib --out",
                \       "exec"  : "%c %s _lib.ts %o %s:p:r.js",
                \       "hook/typescript_compile/enable": 1,
                \       "hook/js2cmd/enable": 1,
                \       "hook/output_command/log": 1
                \   },
                \ "plantuml": {
                \       "command": "java",
                \       "cmdopt": "-jar plantuml.jar -tpng",
                \       "exec": "%c %o %s"
                \   },
                \ "blockdiag": {
                \       "command": "blockdiag",
                \       "cmdopt": "-Tsvg",
                \       "exec": "%c %o %s"
                \   },
                \ "rst": {
                \       "command": "make",
                \       "cmdopt": "html",
                \       "exec": "%c %o"
                \ },
                \ "ps1": {
                \       'hook/output_encode/enable': 1,
                \       'hook/output_encode/encoding': "cp932"
                \ },
                \ "markdown": {
                \       "type": "markdown/pandoc",
                \       "outputter": "browser"
                \ }
                \ }

    " stop quickrun
    nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
    call neobundle#untap()
endif"}}}

if neobundle#tap('shabadou.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'on_source': ['vim-quickrun'],
                \   'mappings': [['sxn', '<Plug>(quickrun']],
                \   'commands': {'complete': 'customlist,quickrun#complete', 'name': 'QuickRun'}
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-coffee-script')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': ['coffee'],
                \   'commands': ['CoffeeCompile', 'CoffeeWatch', 'CoffeeRun', 'CoffeeLint']
                \ }
                \ })

    let coffee_compile_vert = 1
    let coffee_make_options = '--bare'

    call neobundle#untap()
endif"}}}

if neobundle#tap('jedi-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'custom,jedi#py_import_completions', 'name': 'Pyimport'},
                \                'Python'],
                \   'filetypes': ['python', 'python3']
                \ }
                \ })
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:jedi#auto_initialization = 1
        let g:jedi#auto_vim_configuration = 0
        let g:jedi#goto_assignments_command = '<Leader>G'
        let g:jedi#popup_select_first = 0
        let g:jedi#rename_command = '<Leader>R'
        let g:jedi#show_call_signatures = 1
        "let g:jedi#popup_on_dot = 1
        au MyAutoCmd FileType python let b:did_ftplugin = 1
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('ag.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'file', 'name': 'AgFromSearch'},
                \                {'complete': 'help', 'name': 'LAgHelp'},
                \                {'complete': 'file', 'name': 'LAg'},
                \                {'complete': 'file', 'name': 'LAgAdd'},
                \                {'complete': 'file', 'name': 'AgFile'},
                \                {'complete': 'file', 'name': 'AgAdd'},
                \                {'complete': 'file', 'name': 'Ag'},
                \                {'complete': 'help', 'name': 'AgHelp'}],
                \   'unite_sources': 'grep'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-ref')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['ref'],
                \   'mappings': [['sxn', '<Plug>(ref-keyword)']],
                \   'commands': [{'complete': 'customlist,ref#complete', 'name': 'Ref'},
                \                'RefHistory']
                \ }
                \ })

    function! s:unite_ref_doc()
        if &filetype =~ 'perl'
            Unite ref/perldoc
        elseif &filetype =~ 'python'
            Unite -start-insert ref/pydoc
        elseif &filetype =~ 'ruby'
            Unite ref/refe
        else
            Unite ref/man
        endif
    endfunction
    nnoremap <LocalLeader>r :<C-u>call s:unite_ref_doc()<CR>
    call neobundle#untap()
endif"}}}

if neobundle#tap('tagbar')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['TagbarGetTypeConfig', 'TagbarSetFoldlevel', 'TagbarOpen',
                \                'TagbarDebug', 'Tagbar', 'TagbarClose', 'TagbarTogglePause',
                \                'TagbarOpenAutoClose', 'TagbarDebugEnd', 'TagbarCurrentTag',
                \                'TagbarShowTag', 'TagbarToggle']
                \ }
                \ })

    nnoremap <Leader>t :<C-u>TagbarToggle<CR>
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:tagbar_type_scala = {
                    \ 'ctagstype': 'Scala',
                    \ 'kinds': [
                    \   'p:packages:1',
                    \   'V:values',
                    \   'v:variables',
                    \   'T:types',
                    \   't:traits',
                    \   'o:objects',
                    \   'a:aclasses',
                    \   'c:classes',
                    \   'r:cclasses',
                    \   'm:methods'
                    \ ]
                    \ }
        let g:tagbar_type_ruby = {
                    \ 'kinds': [
                    \   'm:modules',
                    \   'c:classes',
                    \   'd:describes',
                    \   'C:contexts',
                    \   'f:methods',
                    \   'F:singleton methods'
                    \ ]
                    \ }
        let g:tagbar_type_markdown = {
                    \ 'ctagstype': 'markdown',
                    \ 'kinds': [
                    \   'h:Heading_L1',
                    \   'i:Heading_L2',
                    \   'k:Heading_L3'
                    \ ]
                    \ }
        let g:tagbar_type_css = {
                    \ 'ctagstype': 'Css',
                    \ 'kinds': [
                    \   'c:classes',
                    \   's:selectors',
                    \   'i:identities'
                    \ ]
                    \ }
        if executable('coffeetags')
            let g:tagbar_type_coffee = {
                        \ 'ctagsbin': 'coffeetags',
                        \ 'ctagsargs': '',
                        \ 'kinds': [
                        \   'f:functions',
                        \   'o:object',
                        \ ],
                        \ 'sro': ".",
                        \ 'kind2scope' : {
                        \   'f': 'object',
                        \   'o': 'object',
                        \ }
                        \ }
        endif

        " Posix regular expressions for matching interesting items. Since this will
        " be passed as an environment variable, no whitespace can exist in the options
        " so [:space:] is used instead of normal whitespaces.
        " Adapted from: https://gist.github.com/2901844
        let s:ctags_opts = '
                    \ --langdef=coffee
                    \ --langmap=coffee:.coffee
                    \ --regex-coffee=/(^|=[ \t])*class ([A-Za-z_][A-Za-z0-9_]+\.)*([A-Za-z_][A-Za-z0-9_]+)( extends ([A-Za-z][A-Za-z0-9_.]*)+)?$/\3/c,class/
                    \ --regex-coffee=/^[ \t]*(module\.)?(exports\.)?@?(([A-Za-z][A-Za-z0-9_.]*)+):.*[-=]>.*$/\3/m,method/
                    \ --regex-coffee=/^[ \t]*(module\.)?(exports\.)?(([A-Za-z][A-Za-z0-9_.]*)+)[ \t]*=.*[-=]>.*$/\3/f,function/
                    \ --regex-coffee=/^[ \t]*(([A-Za-z][A-Za-z0-9_.]*)+)[ \t]*=[^->\n]*$/\1/v,variable/
                    \ --regex-coffee=/^[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)[ \t]*=[^->\n]*$/\1/f,field/
                    \ --regex-coffee=/^[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+):[^->\n]*$/\1/f,static field/
                    \ --regex-coffee=/^[ \t]*(([A-Za-z][A-Za-z0-9_.]*)+):[^->\n]*$/\1/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?/\3/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){0}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){1}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){2}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){3}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){4}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){5}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){6}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){7}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){8}/\8/f,field/
                    \ --regex-coffee=/((constructor|initialize):[ \t]*\()@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?(,[ \t]*@(([A-Za-z][A-Za-z0-9_.]*)+)([ \t]*=[ \t]*[^,)]+)?){9}/\8/f,field/'

        let $CTAGS = substitute(s:ctags_opts, '\v\([nst]\)', '\\', 'g')
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('SrcExpl')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['SrcExplToggle', 'SrcExplClose', 'SrcExpl']
                \ }
                \ })
    " The switch of the Source Explorer
    nmap <F8> :SrcExplToggle<CR>
    function! neobundle#tapped.hooks.on_source(bundle)
        "  Set the height of Source Explorer window
        let g:SrcExpl_winHeight = 8

        "  Set 100 ms for refreshing the Source Explorer
        let g:SrcExpl_refreshTime = 100

        "  Set "Enter" key to jump into the exact definition context
        let g:SrcExpl_jumpKey = "<ENTER>"

        "  Set "Space" key for back from the definition context
        let g:SrcExpl_gobackKey = "<SPACE>"

        "  In order to Avoid conflicts, the Source Explorer should know what plugins
        "  are using buffers. And you need add their bufname into the list below
        "  according to the command ":buffers!"
        let g:SrcExpl_pluginList = [
                    \ "__Tag_List__",
                    \ "Source_Explorer"
                    \ ]

        "  Enable/Disable the local definition searching, and note that this is not
        "  guaranteed to work, the Source Explorer doesn't check the syntax for now.
        "  It only searches for a match with the keyword according to command 'gd'
        let g:SrcExpl_searchLocalDef = 1

        "  Do not let the Source Explorer update the tags file when opening
        let g:SrcExpl_isUpdateTags = 0

        "  Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to
        "  create/update a tags file
        let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."

        "  Set "<F12>" key for updating the tags file artificially
        "let g:SrcExpl_updateTagsKey = "<F12>"

        "  Set "<F3>" key for displaying the previous definition in the jump list
        let g:SrcExpl_prevDefKey = "<F3>"

        "  Set "<F4>" key for displaying the next definition in the jump list
        let g:SrcExpl_nextDefKey = "<F4>"
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('qfixhowm')"{{{
    " use markdown
    let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.md'
    " filetype markdown
    let QFixHowm_FileType = 'markdown'
    let QFixHowm_Title = '#'
    let QFixMRU_Title = {}
    let QFixMRU_Title['mkd'] = '^###[^#]'
    let QFixMRU_Title['mkd_regxp'] = '^###[^#]'
    let howm_dir = $HOME . '/.howm'
    call neobundle#untap()
endif"}}}

if neobundle#tap('ctrlp.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['CtrlPMixed', 'CtrlPClearAllCaches', 'CtrlPCurWD', 'CtrlP',
                \                'CtrlPRTS', 'CtrlPBuffer', 'CtrlPMRUFiles', 'CtrlPBookmarkDirAdd',
                \                'CtrlPDir', 'CtrlPRoot', 'CtrlPChange', 'ClearCtrlPCache',
                \                'CtrlPLine', 'ClearAllCtrlPCaches', 'CtrlPBufTagAll',
                \                'CtrlPClearCache', 'CtrlPQuickfix', 'CtrlPBufTag', 'CtrlPTag',
                \                'CtrlPCurFile', 'CtrlPLastMode', 'CtrlPUndo', 'CtrlPChangeAll',
                \                'CtrlPBookmarkDir']
                \ }
                \ })

    nnoremap <LocalLeader>p :<C-u>CtrlP<CR>
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-automatic')"{{{
    " http://blog.supermomonga.com/articles/vim/automatic.html

    nnoremap <silent> <Plug>(quit) :<C-u>q<CR>
    function! s:my_temporary_window_init(config, context)
"         silent! nunmap <ESC><ESC>
        nmap <buffer> <C-[> <Plug>(quit)
    endfunction

    let g:automatic_enable_autocmd_Futures = {}
    let g:automatic_default_match_config = {
                \   'is_open_other_window': 1
                \ }
    let g:automatic_default_set_config = {
                \   'height': '40%',
                \   'move': "bottom",
                \   'apply': function('s:my_temporary_window_init')
                \ }
    let g:automatic_config = [
                \   {'match': {'buftype': 'help'}},
                \   {'match': {'bufname': '^.vimshell'}},
                \   {'match': {'bufname': 'MacDict.*'}},
                \   {
                \       'match': {
                \           'autocmd_history_pattern': 'BufWinEnterFileType$',
                \           'filetype' : 'unite'
                \       },
                \       'set': {
                \           'unsettings': ['move', 'resize']
                \       }
                \   },
                \   {
                \       'match': {
                \           'filetype': 'qf',
                \           'autocmds': ['FileType']
                \       },
                \   },
                \   {
                \       'match': {
                \           'filetype': '\v^ref-.+',
                \           'autocmds': ['FileType']
                \       }
                \   },
                \   {
                \       'match': {
                \           'bufname': '\[quickrun output\]'
                \       },
                \       'set': {
                \           'height': 8
                \       }
                \   },
                \   {
                \       'match': {
                \           'autocmds': ['CmdwinEnter']
                \       },
                \       'set': {
                \           'is_close_focus_out': 1,
                \           'unsettings': ['move', 'resize']
                \       }
                \   }
                \ ]

    call neobundle#untap()
endif"}}}

if neobundle#tap('macdict-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['MacDictThesaurus', 'MacDictFrench', 'MacDict', 'MacDictJapan',
                \                'MacDictGerman', 'MacDictClose', 'MacDictCWord', 'MacDictEnglish']
                \ }
                \ })
    if s:is_darwin
        nnoremap <LocalLeader>d :<C-u>MacDictCWord<CR>
    endif
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-golang')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': ['<Plug>(godoc-keyword)'],
                \   'commands': [{'complete': 'customlist,go#complete#Package', 'name': 'Godoc'}],
                \   'filetypes': 'go'
                \ }
                \ })
    function! neobundle#tapped.hooks.on_source(bundle)
        " user goimports
        let g:gofmt_command = 'goimports'
        set rtp^=$GOROOT/misc/vim
        exe "set rtp^=" . globpath($GOPATH, "src/github.com/nsf/gocode/vim")
        setl completeopt=menu
        " golint
        exe "set rtp+=" . globpath($GOPATH, "src/github.com/golang/lint/misc/vim")
        au MyAutoCmd BufWritePre *.go Fmt
        au MyAutoCmd FileType go compiler go
        nnoremap <buffer> K :<C-u>Godoc<Space><C-R><C-W><CR>
    endfunction
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-go')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['n', '<Plug>(go-']],
                \   'commands': ['GoErrCheck', 'GoOracleCallgraph', 'GoRun', 'GoDeps', 'GoInstall',
                \                'GoDef', 'GoOracleDescribe', 'GoUpdateBinaries', 'GoVet', 'GoTest',
                \                'GoOracleCallers', 'GoOracleChannelPeers', 'GoOracleCallees', 'GoOracleImplements',
                \                {'complete': 'customlist,go#package#Complete', 'name': 'GoDoc'},
                \                'GoFiles', 'GoBuild'],
                \   'filetypes': 'go'
                \ }
                \ })

    au MyAutoCmd Filetype go nnoremap <buffer> <leader>i :exe 'GoImport ' . expand('<cword>')<CR>
    au MyAutoCmd Filetype go nnoremap <buffer> <leader>v :vsp <CR>:exe "GoDef" <CR>
    au MyAutoCmd Filetype go nnoremap <buffer> <leader>s :sp <CR>:exe "GoDef"<CR>
    au MyAutoCmd Filetype go nnoremap <buffer> <leader>t :tab split <CR>:exe "GoDef"<CR>

    let g:go_snippet_engine = "neosnippet"
    call neobundle#untap()
endif"}}}

if neobundle#tap('ghcmod-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'haskell'
                \ }
                \ })
    function! neobundle#tapped.hooks.on_source(bundle)
        "au MyAutoCmd BufWritePost <buffer> GhcModCheckAsync
    endfunction

    call neobundle#untap()
endif"}}}

if neobundle#tap('neco-ghc')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['NecoGhcDiagnostics'],
                \   'filetypes': 'haskell'
                \ }
                \ })

    let g:necoghc_enable_detailed_browse = 1

    call neobundle#untap()
endif"}}}

if neobundle#tap('yankround.vim')"{{{
    nmap p <Plug>(yankround-p)
    nmap P <Plug>(yankround-P)
    nmap <C-p> <Plug>(yankround-prev)
    nmap <C-n> <Plug>(yankround-next)
    let g:yankround_max_history = 100

    nnoremap <silent>g<C-p> :<C-u>CtrlPYankRound<CR>
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-over')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['OverCommandLineNoremap', 'OverCommandLine']
                \ }
                \ })
    nnoremap <silent> <Leader>o :<C-u>OverCommandLine<CR>%s/
    call neobundle#untap()
endif"}}}

if neobundle#tap('nebula.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['NebulaPutLazy', 'NebulaPutFromClipboard', 'NebulaYankOptions',
                \                'NebulaPutConfig', 'NebulaYankTap']
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('foldCC')"{{{
    set foldmethod=marker
    set foldtext=foldCC#foldtext()
    set foldcolumn=0
    set fillchars=vert:\|
    nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'
    nnoremap <silent><C-_> :<C-u>call <SID>smart_foldcloser()<CR>
    function! s:smart_foldcloser() "{{{
        if foldlevel('.') == 0
            norm! zM
            return
        endif

        let foldc_lnum = foldclosed('.')
        norm! zc
        if foldc_lnum == -1
            return
        endif

        if foldclosed('.') != foldc_lnum
            return
        endif
        norm! zM
    endfunction
    "}}}
    nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
    nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
    function! s:put_foldmarker(foldclose_p) "{{{
        let crrstr = getline('.')
        let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
        let [cms_start, cms_end] = ['', '']
        let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
        if outside_a_comment_p
            let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
            let cms_end = matchstr(&cms,'\V%s\zs\.\+')
        endif
        let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
        exe 'norm! A'. padding. cms_start. fmr. cms_end
    endfunction
    "}}}
    nnoremap <silent>z<C-_>    zMzvzc
    nnoremap <silent>z0    :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR><CR>

    call neobundle#untap()
endif"}}}

if neobundle#tap('junkfile.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['junkfile'],
                \   'commands': ['JunkfileOpen']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('plantuml-syntax')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'plantuml'
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-endwise')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['i', '<Plug>DiscretionaryEnd'], ['i', '<Plug>AlwaysEnd']]
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('chalice')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': 'Chalice'
                \ }
                \ })
    call neobundle#untap()
endif"}}}

if neobundle#tap('syntastic')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'custom,s:CompleteCheckerName', 'name': 'SyntasticCheck'},
                \                'SyntasticInfo', 'Errors', 'SyntasticSetLoclist', 'SyntasticReset',
                \                'SyntasticToggleMode']
                \ }
                \ })
    let g:syntastic_go_checkers = ['go', 'golint']

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-ps1')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'ps1'
                \ }
                \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        function! s:addHeader(flg)
            let list = []
            call add(list, "@echo off")
            call add(list, "pushd \"%~dp0\" > nul")
            call add(list, "set tm=%time: =0%")
            call add(list, "set ps1file=%~n0___%date:~-10,4%%date:~-5,2%%date:~-2,2%_%tm:~0,2%%tm:~3,2%%tm:~6,2%%tm:~9,2%.ps1")
            call add(list, "for /f \"usebackq skip=10 delims=\" %%i in (\"%~f0\") do @echo %%i >> \"%ps1file%\"")
            call add(list, "powershell -NoProfile -ExecutionPolicy unrestricted -File \"%ps1file%\" %*")
            call add(list, "del \"%ps1file%\"")
            call add(list, "popd > nul")
            if ! a:flg
                call add(list, "pause")
            endif
            call add(list, "exit %ERRORLEVEL%")
            call add(list, "\# ========== do ps1 file as a dosbatch ==========")
            call extend(list, getline("1", "$"))
            let cp932List = []
            for line in list
                call add(cp932List, line . "\r")
            endfor
            call writefile(cp932List, expand("%:p:r") . ".cmd")
        endfunction
        au MyAutoCmd BufWritePost *.ps1 call s:addHeader(0)
        au MyAutoCmd FileType ps1 nnoremap <buffer> <expr><Leader>m <SID>addHeader(1)
    endfunction

    call neobundle#untap()
endif"}}}

if neobundle#tap('poshcomplete-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'ps1'
                \ }
                \ })

    au MyAutoCmd FileType ps1 setl omnifunc=poshcomplete#CompleteCommand
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-alignta')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['alignta'],
                \   'commands': [{'complete': 'customlist,s:complete_command_option', 'name': 'Alignta'},
                \                {'complete': 'customlist,s:complete_command_option', 'name': 'Align'}]
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-splash')"{{{
    call neobundle#config({
                \ 'augroup': 'plugin',
                \   'autoload': {
                \   'commands': {'complete': 'file', 'name': 'Splash'}
                \ }
                \ })
    " clone splash gist "{{{
    function! s:clone_splash()
        let s:splash_dir = $HOME . "/.vim-splash"
        if !isdirectory(s:splash_dir)
            echom "cloning vim splash ..."
            let s:com = "git clone https://gist.github.com/7630711.git " . s:splash_dir
            echom s:com
            call system(s:com)
        endif
    endfunction"}}}
    call s:clone_splash()

    let g:splash#path = s:splash_dir . '/vim_intro.txt'

    call neobundle#untap()
endif"}}}

if neobundle#tap('splitjoin.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['n', '<Plug>Splitjoin']],
                \   'commands': ['SplitjoinSplit', 'SplitjoinJoin']
                \ }
                \ })
    nmap sj :SplitjoinSplit<cr>
    nmap sk :SplitjoinJoin<cr>

    call neobundle#untap()
endif"}}}

if neobundle#tap('linediff.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['LinediffReset', 'Linediff']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('emmet-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['Emmet', 'EmmetInstall'],
                \   'filetypes': ['html']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-fireplace')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['<Plug>Fireplace']],
                \   'commands': [{'complete': 'customlist,fireplace#eval_complete', 'name': 'Eval'},
                \                'Last',
                \                {'complete': 'customlist,s:connect_complete', 'name': 'FireplaceConnect'},
                \                {'complete': 'customlist,fireplace#ns_complete', 'name': 'Require'}],
                \   'filetypes': 'clojure'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-ft-clojure')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'clojure'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('capture.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'command', 'name': 'Capture'}]
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('restart.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': 'Restart'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-qfixhowm')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': 'qfixhowm'
                \ }
                \ })

    nnoremap <silent> <LocalLeader>uq :<C-u>Unite -no-split -buffer-name=qfixhowm qfixhowm<CR>

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-prettyprint')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'expression', 'name': 'PP'},
                \                {'complete': 'expression', 'name': 'PrettyPrint'}]
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-quickhl')"{{{
    call neobundle#config({
                \ 'augroup': 'QuickhlManual', 'autoload': {
                \   'mappings': [['sxn', '<Plug>(quickhl-']],
                \   'commands': ['QuickhlManualUnlockWindow', 'QuickhlManualDelete',
                \                'QuickhlTagToggle', 'QuickhlManualDisable', 'QuickhlTagDisable',
                \                'QuickhlManualAdd', 'QuickhlManualColors', 'QuickhlManualReset',
                \                'QuickhlManualLockToggle', 'QuickhlManualLock',
                \                'QuickhlManualEnable', 'QuickhlManualList', 'QuickhlCwordEnable',
                \                'QuickhlManualUnlock', 'QuickhlCwordDisable', 'QuickhlTagEnable',
                \                'QuickhlManualLockWindowToggle', 'QuickhlManualLockWindow',
                \                'QuickhlCwordToggle']
                \ }
                \ })

    nmap <LocalLeader>m <Plug>(quickhl-manual-this)
    xmap <LocalLeader>m <Plug>(quickhl-manual-this)
    "nmap <F9>     <Plug>(quickhl-manual-toggle)
    "xmap <F9>     <Plug>(quickhl-manual-toggle)

    nmap <LocalLeader>M <Plug>(quickhl-manual-reset)
    xmap <LocalLeader>M <Plug>(quickhl-manual-reset)

    nmap <LocalLeader>j <Plug>(quickhl-cword-toggle)

    nmap <LocalLeader>] <Plug>(quickhl-tag-toggle)

    "map H <Plug>(operator-quickhl-manual-this-motion)

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-visualstar')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': '<Plug>(visualstar-'
                \ }
                \ })

    map * <Plug>(visualstar-*)
    map # <Plug>(visualstar-#)
    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-operator-search')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': '<Plug>(operator-search'
                \ }
                \ })
    nmap <LocalLeader>/ <Plug>(operator-search)

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-textobj-multiblock')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['xo', '<Plug>(textobj-multiblock'],
                \                ['xo', '<Plug>(textobj-multiblock']]
                \ }
                \ })

    omap ab <Plug>(textobj-multiblock-a)
    omap ib <Plug>(textobj-multiblock-i)
    xmap ab <Plug>(textobj-multiblock-a)
    xmap ib <Plug>(textobj-multiblock-i)

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-textobj-ruby')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': '<Plug>(textobj-ruby',
                \   'filetypes': 'ruby'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('gitv')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['Gitv']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('simple-javascript-indenter')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'javascript'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-javascript-syntax')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'javascript'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-javascript')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'javascript'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-vimperator')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'vimperator'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('calendar.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'customlist,calendar#argument#complete', 'name': 'Calendar'}]
                \ }
                \ })

    let g:calendar_google_calendar = 1
    let g:calendar_google_task = 1

    nnoremap <LocalLeader>c :<C-u>Calendar<CR>

    call neobundle#untap()
endif"}}}

if neobundle#tap('thumbnail.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'customlist,thumbnail#complete', 'name': 'Thumbnail'}]
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-choosewin')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': '<Plug>(choosewin)',
                \   'commands': ['FontReview', 'FontPerfSmall', 'ChooseWin', 'FontPerfLarge']
                \ }
                \ })

    nmap  -  <Plug>(choosewin)

    let g:choosewin_overlay_enable = 1
    let g:choosewin_overlay_clear_multibyte = 1

    " color like tmux
    let g:choosewin_color_overlay = {
                \ 'gui': ['DodgerBlue3', 'DodgerBlue3' ],
                \ 'cterm': [ 25, 25 ]
                \ }
    let g:choosewin_color_overlay_current = {
                \ 'gui': ['firebrick1', 'firebrick1' ],
                \ 'cterm': [ 124, 124 ]
                \ }

    let g:choosewin_blink_on_land      = 0
    let g:choosewin_statusline_replace = 0
    let g:choosewin_tabline_replace    = 0

    call neobundle#untap()

endif"}}}

if neobundle#tap('indentLine')"{{{
    call neobundle#config({})

    let g:indentLine_fileTypeExclude = ['help', 'nerdtree', 'calendar', 'thumbnail']

    call neobundle#untap()
endif"}}}

if neobundle#tap('vimplenote-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['VimpleNote']
                \ }
                \ })

    nnoremap <Leader>vl :<C-u>VimpleNote -l<CR>
    nnoremap <Leader>vn :<C-u>VimpleNote -n<CR>

    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-vim_advent-calendar')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['vim_advent_calendar']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-advent_calendar')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['advent_calendar']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('codic-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': [{'complete': 'customlist,codic#complete', 'name': 'Codic'}]
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-codic.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['codic']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-ft-help_fold')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'help'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-qfreplace')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['Unite', 'Qfreplace']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('neomru.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \     'unite_sources': ['mru', 'neomru', 'neomru/file'],
                \     'commands': [{'complete': 'file', 'name': 'NeoMRUImportFile'},
                \                  'NeoMRUSave',
                \                  {'complete': 'file', 'name': 'NeoMRUImportDirectory'},
                \                  'NeoMRUReload']
                \ }
                \ })

    let g:neomru#file_mru_limit = 5000

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-clojure-static')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'clojure'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('rainbow_parentheses.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['RainbowParenthesesLoadChevrons', 'RainbowParenthesesActivate',
                \                'RainbowParenthesesToggleAll', 'RainbowParenthesesLoadRound',
                \                'RainbowParenthesesLoadSquare', 'RainbowParenthesesLoadBraces',
                \                'RainbowParenthesesToggle'],
                \   'filetypes': 'clojure'
                \ }
                \ })

    let g:rbpt_colorpairs = [
                \ ['brown',       'RoyalBlue3'],
                \ ['Darkblue',    'SeaGreen3'],
                \ ['darkgray',    'DarkOrchid3'],
                \ ['darkgreen',   'firebrick3'],
                \ ['darkcyan',    'RoyalBlue3'],
                \ ['darkred',     'SeaGreen3'],
                \ ['darkmagenta', 'DarkOrchid3'],
                \ ['brown',       'firebrick3'],
                \ ['gray',        'RoyalBlue3'],
                \ ['black',       'SeaGreen3'],
                \ ['darkmagenta', 'DarkOrchid3'],
                \ ['Darkblue',    'firebrick3'],
                \ ['darkgreen',   'RoyalBlue3'],
                \ ['darkcyan',    'SeaGreen3'],
                \ ['darkred',     'DarkOrchid3'],
                \ ['red',         'firebrick3']
                \ ]

    au MyAutoCmd VimEnter * RainbowParenthesesToggle
    au MyAutoCmd Syntax * RainbowParenthesesLoadRound
    au MyAutoCmd Syntax * RainbowParenthesesLoadSquare
    au MyAutoCmd Syntax * RainbowParenthesesLoadBraces

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-tagsgen')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['TagsgenSetDir', 'Tagsgen']
                \ }
                \ })

    let g:tagsgen_tags_command = {
                \ '_': 'ctags',
                \ 'go': 'gotags'
                \ }
    let g:tagsgen_option = {
                \ '_' : '-R',
                \ 'vim': '-R --languages=Vim',
                \ 'python': '-R --languages=Python',
                \ 'go': '{CURFILES} > tags'
                \ }

    au MyAutoCmd BufWinEnter *.{vim,go,python} TagsgenSetDir
    au MyAutoCmd BufWritePost *.{vim,go,python} Tagsgen

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-visual-increment')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['sx', '<Plug>Visual']]
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-easymotion')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['sxno', '<Plug>(easymotion-']],
                \   'commands': ['EMCommandLineNoreMap', 'EMCommandLineMap', 'EMCommandLineUnMap']
                \ }
                \ })

    " Disable default mappings
    let g:EasyMotion_do_mapping = 0
    let g:EasyMotion_use_migemo = 1

    " `JK` Motions: Extend line motions
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
    " keep cursor column with `JK` motions
    let g:EasyMotion_startofline = 0
    " Turn on case sensitive feature
    let g:EasyMotion_smartcase = 1


    "let g:EasyMotion_keys = ';HKLYUIOPNM,QWERTASDGZXCVBJF'

    " Show target key with upper case to improve readability
    let g:EasyMotion_use_upper = 1
    " Jump to first match with enter & space
    let g:EasyMotion_enter_jump_first = 1
    let g:EasyMotion_space_jump_first = 1

    nmap <LocalLeader>s <Plug>(easymotion-s2)

    map f <Plug>(easymotion-fl)
    map t <Plug>(easymotion-tl)
    map F <Plug>(easymotion-Fl)
    map T <Plug>(easymotion-Tl)

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-markdown')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'markdown'
                \ }
                \ })


    call neobundle#untap()
endif"}}}

if neobundle#tap('previm')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['PrevimOpen']
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-filetype-haskell')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'filetypes': 'haskell'
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('jazzradio.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['jazzradio'],
                \   'commands': ['JazzradioUpdateChannels', 'JazzradioStop',
                \                {'complete': 'customlist,jazzradio#channel_key_complete', 'name': 'JazzradioPlay'}],
                \   'function_prefix': 'jazzradio'
                \ }
                \ })

    call neobundle#untap()

endif"}}}

if neobundle#tap('tern_for_vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['TernDocBrowse', 'TernType', 'TernRename', 'TernDefPreview',
                \                'TernDoc', 'TernDef', 'TernDefTab', 'TernDefSplit', 'TernRefs'],
                \   'filetypes': ['javascript', 'typescript', 'coffee']
                \ }
                \ })

    au MyAutoCmd FileType coffee,typescript call tern#Enable()
    au MyAutoCmd FileType coffee,typescript setlocal omnifunc=tern#Complete

    call neobundle#untap()
endif"}}}

if neobundle#tap('memolist.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'commands': ['MemoList', 'MemoGrep', 'MemoNew']
                \ }
                \ })

    if isdirectory($HOME . '/Dropbox')
        let g:memolist_path = $HOME . '/Dropbox/memolist'
    else
        let g:memolist_path = $HOME . '/.memolist'
    endif

    call MakeDirIfNoExists(g:memolist_path)

    "let g:memolist_vimfiler = 1
    let g:memolist_unite = 1
    let g:memolist_unite_source = "file_rec"

    " mappings
    nnoremap <Leader>mn :<C-u>MemoNew<CR>
    nnoremap <Leader>ml :<C-u>MemoList<CR>
    nnoremap <Leader>mg :<C-u>MemoGrep<CR>

    call neobundle#untap()
endif"}}}

if neobundle#tap('ZoomWin')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['n', '<Plug>ZoomWin']],
                \   'commands': ['ZoomWin']
                \ }
                \ })

    nmap so <Plug>ZoomWin

    call neobundle#untap()
endif"}}}

if neobundle#tap('lingr-vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['sxno', '<Plug>(lingr-messages-quote)']],
                \   'commands': ['LingrLaunch', 'LingrExit']
                \ }
                \ })

    let g:lingr_vim_user = 'yukimemi'

    call neobundle#untap()
endif"}}}

if neobundle#tap('googlesuggest-source.vim')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'insert': 1
                \ }
                \ })

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-operator-blockwise')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['n', '<Plug>(operator-blockwise-']]
                \ }
                \ })

	" yank
	nmap YY <Plug>(operator-blockwise-yank-head)
	" delete
	nmap DD <Plug>(operator-blockwise-delete-head)
	" change
	nmap CC <Plug>(operator-blockwise-change-head)

    call neobundle#untap()
endif"}}}

if neobundle#tap('caw.vim')"{{{

    nmap <Leader>c <Plug>(caw:I:toggle)
    vmap <Leader>c <Plug>(caw:I:toggle)

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-operator-surround')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'mappings': [['nx', '<Plug>(operator-surround'],
                \               ['n', '<Plug>(operator-surround-repeat)']]
                \ }
                \ })

    " operator mappings
    map <silent>sa <Plug>(operator-surround-append)
    map <silent>sd <Plug>(operator-surround-delete)
    map <silent>sr <Plug>(operator-surround-replace)

    " vim-textobj-multiblock
    nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

    call neobundle#untap()
endif"}}}

if neobundle#tap('unite-haddock')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['haddock', 'hoogle']
                \ }
                \ })

    au MyAutoCmd FileType haskell call s:my_haskell_mappings()

    function! s:my_haskell_mappings()
        nnoremap <buffer> K :<C-u>UniteWithCursorWord hoogle<CR>
        nnoremap <buffer> <LocalLeader>h :<C-u>Unite hoogle<CR>
    endfunction

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-gista')"{{{
    call neobundle#config({
                \ 'autoload': {
                \   'unite_sources': ['g', 'gista'],
                \   'mappings': [['n', '<Plug>(gista-']],
                \   'commands': ['Gista']
                \ }
                \ })

    let g:gista#github_user = 'yukimemi'

    call neobundle#untap()
endif"}}}

if neobundle#tap('vim-watchdogs')"{{{
    call neobundle#config({
        \ 'autoload': {
        \   'commands': ['WatchdogsRunSweep', {'complete': 'customlist,quickrun#complete',
        \                'name': 'WatchdogsRun'}, {'complete': 'customlist,quickrun#complete', 'name': 'WatchdogsRunSilent'}]
        \ }
        \ })

    cal neobundle#untap()
endif"}}}

" disable plugin
let plugin_dicwin_disable = 1
"===================================================================================}}}

"{{{ ========== Language Settings =====================================================
" html
let g:html_indent_inctags = "html,body,head,tbody"
"===================================================================================}}}

"{{{ ========== Temp Settings =========================================================


"===================================================================================}}}
