" ---------------------------------------------------------------------------
" Set:
"

set autoread                  " vim外で編集された時の自動み込み
set autowrite                 " bufferが切り替わるときの自動保存
set backspace=indent,eol,start"{{{"}}}
set cmdheight=2
set cursorline
set display=lastline          " 画面を超える長い１行も表示
set history=10000             " コマンドラインのヒストリ
set laststatus=2              " ステータス行を常に表示
set list
set listchars=eol:$,tab:>-
set matchpairs+=<:>           " 対応カッコのマッチを追加
set matchtime=1               " 対応するカッコを表示する時間
set modeline                  " vim:set tx=4 sw=4..みたいな設定を有効
set modelines=3               " 上の設定をファイル先頭3行にあるかないか調べる
set nf=alpha,hex              " アルファベットと16シンスうをC-a C-xで増減可能に
set nocompatible              " VI互換を無効化
set number
set pumheight=5               " 補完ウィンドウの行数
set relativenumber            " 相対行番号
set report=0                  " 変更された行数の報告がでる最小値
set ruler
set scrolloff=10              " 常に10行表示
set secure                    " 安全モード
set showcmd                   " ステータスラインに常にコメンド表示
set showmatch                 " 閉じ括弧を入力時，開き括弧に一瞬ジャンプ
set splitbelow                " 横分割時、新しいウィンドウは下
set splitright                " 縦分割時、新しいウィンドウは右
set t_Co=256
set ttyfast                   " スクロールが滑らかに
set ttyscroll=300
set vb t_vb=                  " no beep no flash
set whichwrap=b,s,h,l,<,>,[,] " hとlが非推奨
set wildmenu " cmdline補完
set wildmode=longest:full,full

" wildignores
set wildignore=*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" " spelling
" set spelllang=en_us
" " ignore japanese
" set spelllang+=cjk
" " enable spell check
" set spell!

" swap
if !isdirectory($HOME.'/.vim/_swap')
  call mkdir($HOME.'/.vim/_swap', 'p')
endif
set directory=~/.vim/_swap
set backupdir=~/.vim/_swap
set swapfile
set backup
" undofile
if !isdirectory($HOME.'/.vim/_undo')
  call mkdir($HOME.'/.vim/_undo', 'p')
endif
set undodir=~/.vim/undo
set undofile
set undolevels=200

" help
" helptags ~/.vim/help/vimdoc-ja/doc
" set runtimepath+=~/.vim/help/vimdoc-ja
" set helplang=ja


" search {{{
set hlsearch    " ハイライト検索
set ignorecase  " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set incsearch   " 検索ワードの最初の文字を入力した時点から検索開始
set nowrapscan  " 検索をファイルの先頭へループしない
set smartcase   " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan
" }}}
" folding {{{
if version >=703
  set foldenable         " 折りたたみon
  set foldmethod =marker " 折りたたみ方法:マーカ
  set foldcolumn =0      " 折りたたみの補助線幅
  set foldlevel  =0      " foldをどこまで一気に開くか
endif
" }}}
" indent, tab2space {{{
set expandtab       "タブの代わりに空白文字を挿入する
set shiftwidth  =2  "タブ幅の設定
set tabstop     =2
set softtabstop =2
set autoindent
set smartindent
set smarttab
" }}}
" tab-editer {{{
set showtabline=2 " 常にタブ
" tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

"}}}

" encode
set encoding      =utf-8       " 文字コード指定
set fileencodings =utf-8,s-jis " 文字エンコードを次の順番で確認
scriptencoding     utf-8

set fileformats   =unix,dos,mac  " 改行コードの自動認識
set ambiwidth     =double        " ２バイト特殊文字の幅調整

