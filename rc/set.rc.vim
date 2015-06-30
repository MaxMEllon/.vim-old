"---------------------------------------------------------------------------
" Set:
"

set autoread                  " vim外で編集された時の自動み込み
set autowrite                 " bufferが切り替わるときの自動保存
set backspace=indent,eol,start"{{{"}}}
set cursorline
set cmdheight=1
set history=10000             " コマンドラインのヒストリ
set laststatus=2              " ステータス行を常に表示
set list
set listchars=eol:$,tab:>-,trail:_
set modeline
set modelines=3
set matchpairs+=<:>
set number
set nocompatible
set nf=alpha,hex              " アルファベットと16シンスうをC-a C-xで増減可能に
set relativenumber
set report=0                  " 変更された行数の報告がでる最小値
set ruler
set scrolloff=10
set secure                    " 安全モード
set splitbelow
set splitright
set showmatch                 " 閉じ括弧を入力時，開き括弧に一瞬ジャンプ
set ttyfast                   " スクロールが滑らかに
set ttyscroll=300
set t_Co=256
set vb t_vb=                  " no beep no flash
set whichwrap=b,s,h,l,<,>,[,] " hとlが非推奨

" spelling
" set spelllang=en_us
" ignore japanese
" set spelllang+=cjk
" enable spell check
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
helptags ~/.vim/help/vimdoc-ja/doc
set runtimepath+=~/.vim/help/vimdoc-ja
set helplang=ja

" search {{{
set ignorecase  " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set wrapscan
set smartcase   " 検索文字列に大文字が含まれている場合は区別して検索する
set nowrapscan  " 検索をファイルの先頭へループしない
set incsearch   " 検索ワードの最初の文字を入力した時点から検索開始
set hlsearch    " ハイライト検索
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

