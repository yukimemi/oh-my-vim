"{{{ ========== Plugins ===============================================================
NeoBundle 'LeafCage/foldCC'
NeoBundle 'LeafCage/yankround.vim', {'depends': 'kien/ctrlp.vim'}
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'banyan/recognize_charcode.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'chrisbra/Recover.vim'
NeoBundle 'cocopon/lightline-hybrid.vim', {'depends': 'itchyny/lightline.vim'}
"NeoBundle 'fuenor/qfixgrep'
"NeoBundle 'hunner/vim-plist'
NeoBundle 'itchyny/lightline.vim'
"NeoBundle 'jceb/vim-hier'
"NeoBundle 'kana/vim-textobj-fold', {'depends': 'kana/vim-textobj-user'}
NeoBundle 'kana/vim-textobj-function', {'depends': 'kana/vim-textobj-user'}
"NeoBundle 'kana/vim-textobj-indent', {'depends': 'kana/vim-textobj-user'}
NeoBundle 'kana/vim-textobj-user'
"NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mhinz/vim-hugefile'
NeoBundle 'osyo-manga/shabadou.vim', {'depends': 'thinca/vim-quickrun'}
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'osyo-manga/vim-automatic', {'depends': ['osyo-manga/vim-gift', 'osyo-manga/vim-reunions']}
"NeoBundle 'osyo-manga/vim-textobj-blockwise'
"NeoBundle 'osyo-manga/vim-textobj-multitextobj', {'depends': 'kana/vim-textobj-user'}
NeoBundle 'osyo-manga/vim-watchdogs', {'depends': 'thinca/vim-quickrun'}
NeoBundle 'rhysd/committia.vim'
"NeoBundle 'sickill/vim-monokai'
NeoBundle 'szw/vim-tags', {'build': {'mac': 'brew install ctags'}}
NeoBundle 'thinca/vim-singleton'
NeoBundle 'thinca/vim-submode'
"NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/operator-star.vim', {'depends': ['kana/vim-operator-user', 'thinca/vim-visualstar']}
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'w0ng/vim-hybrid'
"NeoBundleLazy 'AndrewRadev/splitjoin.vim'
"NeoBundleLazy 'Shougo/neosnippet.vim', {'depends': 'Shougo/neosnippet-snippets'}
"NeoBundleLazy 'Shougo/unite.vim', {'depends': 'Shougo/vimproc.vim'}
"NeoBundleLazy 'Shougo/vimfiler.vim', {'depends': 'Shougo/unite.vim'}
"NeoBundleLazy 'adogear/vim-blockdiag-series'
"NeoBundleLazy 'jelera/vim-javascript-syntax'
"NeoBundleLazy 'jiangmiao/simple-javascript-indenter'
"NeoBundleLazy 'mopp/googlesuggest-source.vim', {'depends': 'mattn/googlesuggest-complete-vim'}
"NeoBundleLazy 'pekepeke/titanium-vim'
"NeoBundleLazy 'rcmdnk/vim-markdown'
"NeoBundleLazy 'thinca/vim-ft-clojure'
"NeoBundleLazy 'vim-scripts/ZoomWin'
"NeoBundleLazy 'AndrewRadev/linediff.vim'
"NeoBundleLazy 'DrawIt'
NeoBundleLazy 'LeafCage/nebula.vim'
NeoBundleLazy 'PProvost/vim-ps1'
NeoBundleLazy 'SQLUtilities'
NeoBundleLazy 'Shougo/echodoc.vim'
NeoBundleLazy 'Shougo/junkfile.vim'
NeoBundleLazy 'Shougo/neomru.vim', {'depends': 'Shougo/unite.vim'}
"NeoBundleLazy 'Shougo/vim-vcs'
NeoBundleLazy 'Shougo/vimshell.vim', {'depends': 'Shougo/vimproc.vim'}
"NeoBundleLazy 'Shougo/vinarise.vim'
"NeoBundleLazy 'aklt/plantuml-syntax'
"NeoBundleLazy 'alpaca-tc/alpaca_tags', {'depends': 'Shougo/vimproc.vim'}
"NeoBundleLazy 'basyura/J6uil.vim', {'depends': ['Shougo/vimproc.vim', 'mattn/webapi-vim']}
"NeoBundleLazy 'basyura/unite-firefox-bookmarks', {'depends': ['tyru/open-browser.vim', 'mattn/webapi-vim']}
"NeoBundleLazy 'basyura/unite-rails', {'depends': 'Shougo/unite.vim'}
NeoBundleLazy 'cd01/poshcomplete-vim'
NeoBundleLazy 'choplin/unite-vim_hacks'
"NeoBundleLazy 'cocopon/colorswatch.vim'
NeoBundleLazy 'dag/vim2hs'
"NeoBundleLazy 'derekwyatt/vim-scala', {'build': {'mac': 'brew install scala sbt'}}
NeoBundleLazy 'digitaltoad/vim-jade'
NeoBundleLazy 'drakontia/sphinx.vim'
NeoBundleLazy 'eagletmt/ghcmod-vim', {'build': {'mac': 'cabal install ghc-mod'}}
NeoBundleLazy 'eagletmt/neco-ghc', {'build': {'mac': 'cabal install ghc-mod'}}
NeoBundleLazy 'eagletmt/unite-haddock', {'build': {'others': 'cabal install hoogle'}}
NeoBundleLazy 'edsono/vim-matchit'
NeoBundleLazy 'glidenote/memolist.vim', {'depends': 'Shougo/unite.vim'}
NeoBundleLazy 'gregsexton/gitv', {'depends': 'tpope/vim-fugitive'}
"NeoBundleLazy 'guns/vim-clojure-static'
"NeoBundleLazy 'hachibeeDI/vim-vbnet'
NeoBundleLazy 'itchyny/calendar.vim'
NeoBundleLazy 'itchyny/dictionary.vim'
NeoBundleLazy 'itchyny/thumbnail.vim'
NeoBundleLazy 'jmcantrell/vim-virtualenv'
NeoBundleLazy 'jpo/vim-railscasts-theme'
NeoBundleLazy 'kana/vim-filetype-haskell'
NeoBundleLazy 'kannokanno/previm.git', {'depends': 'tyru/open-browser.vim'}
NeoBundleLazy 'kchmck/vim-coffee-script'
NeoBundleLazy 'kien/ctrlp.vim'
NeoBundleLazy 'kien/rainbow_parentheses.vim'
NeoBundleLazy 'koron/chalice'
NeoBundleLazy 'koron/codic-vim'
"NeoBundleLazy 'lambdalisue/vim-django-support'
NeoBundleLazy 'lambdalisue/vim-gista', {'depends': 'tyru/open-browser.vim'}
NeoBundleLazy 'leafgarland/typescript-vim'
"NeoBundleLazy 'majutsushi/tagbar', {'build': {'mac': 'brew install ctags'}}
NeoBundleLazy 'marijnh/tern_for_vim', {'build': {'others': 'npm install'}}
NeoBundleLazy 'mattn/emmet-vim'
NeoBundleLazy 'mattn/excitetranslate-vim'
"NeoBundleLazy 'mattn/gist-vim', {'depends': 'mattn/webapi-vim'}
"NeoBundleLazy 'mattn/googletasks-vim', {'depends': 'mattn/webapi-vim'}
"NeoBundleLazy 'mattn/unite-advent_calendar'
"NeoBundleLazy 'mattn/unite-advent_calendar', {'depends': ['Shougo/unite.vim', 'mattn/webapi-vim']}
"NeoBundleLazy 'mattn/unite-vim_advent-calendar', {'depends': ['Shougo/unite.vim', 'mattn/webapi-vim']}
NeoBundleLazy 'mattn/vimplenote-vim'
"NeoBundleLazy 'mitechie/pyflakes-pathogen'
"NeoBundleLazy 'modsound/macdict-vim'
"NeoBundleLazy 'nanotech/jellybeans.vim'
NeoBundleLazy 'osyo-manga/unite-qfixhowm', {'depends': 'fuenor/qfixhowm'}
"NeoBundleLazy 'osyo-manga/vim-operator-blockwise', {'depends': 'kana/vim-operator-user'}
"NeoBundleLazy 'osyo-manga/vim-operator-search', {'depends': 'kana/vim-operator-user'}
NeoBundleLazy 'osyo-manga/vim-over'
"NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {'depends': 'kana/vim-textobj-user'}
NeoBundleLazy 'pangloss/vim-javascript'
"NeoBundleLazy 'pasela/unite-webcolorname'
NeoBundleLazy 'rhysd/unite-codic.vim', {'depends': ['Shougo/unite.vim', 'koron/codic-vim']}
NeoBundleLazy 'rhysd/vim-operator-surround', {'depends': 'kana/vim-operator-user'}
"NeoBundleLazy 'rhysd/vim-textobj-ruby', {'depends': 'kana/vim-textobj-user'}
"NeoBundleLazy 'rking/ag.vim'
"NeoBundleLazy 'sjl/gundo.vim'
"NeoBundleLazy 'superbrothers/vim-vimperator'
NeoBundleLazy 'supermomonga/jazzradio.vim', {'depends': ['Shougo/unite.vim']}
NeoBundleLazy 'supermomonga/vimshell-pure.vim', {'depends' : 'Shougo/vimshell.vim'}
NeoBundleLazy 't9md/vim-choosewin'
"NeoBundleLazy 't9md/vim-quickhl'
"NeoBundleLazy 'tacroe/unite-mark'
"NeoBundleLazy 'thinca/vim-ft-help_fold'
"NeoBundleLazy 'thinca/vim-prettyprint'
NeoBundleLazy 'thinca/vim-qfreplace'
NeoBundleLazy 'thinca/vim-quickrun'
NeoBundleLazy 'thinca/vim-ref'
"NeoBundleLazy 'thinca/vim-splash'
"NeoBundleLazy 'thinca/vim-template'
NeoBundleLazy 'thinca/vim-visualstar'
NeoBundleLazy 'tpope/vim-endwise'
NeoBundleLazy 'tpope/vim-fireplace', {'depends': ['tpope/vim-classpath', 'guns/vim-clojure-static']}
"NeoBundleLazy 'tpope/vim-rails'
"NeoBundleLazy 'triglav/vim-visual-increment'
NeoBundleLazy 'tsukkee/lingr-vim'
"NeoBundleLazy 'tsukkee/unite-help', {'depends': 'Shougo/unite.vim'}
"NeoBundleLazy 'tsukkee/unite-tag', {'depends': 'Shougo/unite.vim'}
NeoBundleLazy 'tyru/capture.vim'
NeoBundleLazy 'tyru/open-browser.vim'
NeoBundleLazy 'tyru/restart.vim'
"NeoBundleLazy 'ujihisa/ref-hoogle', {'build': {'mac': 'cabal install hoogle'}, 'depends': 'thinca/vim-ref'}
NeoBundleLazy 'ujihisa/unite-colorscheme'
NeoBundleLazy 'ujihisa/unite-font'
"NeoBundleLazy 'vim-ruby/vim-ruby'
"NeoBundleLazy 'vim-scripts/Wombat'
NeoBundleLazy 'vim-scripts/copypath.vim'
NeoBundleLazy 'wavded/vim-stylus'
"NeoBundleLazy 'wesleyche/SrcExpl'
NeoBundleLazy 'yuyunko/dosbatch-indent', {'depends': 'taku-o/vim-batch-source'}
"NeoBundleLazy 'zhisheng/visualmark.vim'
NeoBundleLazy 'davidhalter/jedi-vim', {
            \ 'depends': 'mitechie/pyflakes-pathogen',
            \ 'build': {
            \   'others': 'pip install jedi',
            \ }}
NeoBundleLazy 'basyura/TweetVim', 'dev', {
            \ 'depends': [
            \   'tyru/open-browser.vim',
            \   'basyura/twibill.vim',
            \   'basyura/bitly.vim',
            \   'Shougo/unite.vim',
            \   'Shougo/unite-outline',
            \   'Shougo/vimproc.vim',
            \   'mattn/favstar-vim',
            \   'mattn/webapi-vim'
            \ ]}
NeoBundleLazy 'fatih/vim-go'
if has('lua') && ((v:version >= 703 && has('patch885')) || v:version >= 704)
  NeoBundleLazy 'Shougo/neocomplete.vim'
else
  NeoBundleLazy 'Shougo/neocomplcache.vim'
endif
"===================================================================================}}}

