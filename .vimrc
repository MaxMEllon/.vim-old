" MaxMEllon's .vimrc
"---------------------------------------------------------<-------------
"|       ##     ## #### ##     ## ########   ######       |             |＼
"|       ##     ##  ##  ###   ### ##     ## ##    ##      |             |  |
"|       ##     ##  ##  #### #### ##     ## ##            |             |  |
"|       ##     ##  ##  ## ### ## ########  ##            |             |  |
"|        ##   ##   ##  ##     ## ##   ##   ##            |             |  |
"|   ###   ## ##    ##  ##     ## ##    ##  ##    ##      |             |  |
"|   ###    ###    #### ##     ## ##     ##  ######       |             |  |
"---------------------------------------------------------<-------------   |
" ＼                                                        ＼           ＼
"   ---------------------------------------------------------<----------

" init {{{
let mapleader='\'
augroup MyAutoCmd
  autocmd!
augroup END

function! s:source_rc(path)
  execute 'source' fnameescape(expand('~/.vim/rc/' . a:path))
endfunction
" }}}
" source plugin {{{
try
  call s:source_rc('plugin.rc.vim')
catch
  echo " Please run '$ sh ./neo_bundle_install.sh'"
endtry
" }}}
" set {{{
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
set showmatch                 " 閉じ括弧を入力時，開き括弧に一瞬ジャンプ
set ttyfast                   " スクロールが滑らかに
set t_Co=256
set vb t_vb=                  " no beep no flash
set whichwrap=b,s,h,l,<,>,[,] " hとlが非推奨

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

" help
helptags ~/.vim/help/vimdoc-ja/doc
set runtimepath+=~/.vim/help/vimdoc-ja
set helplang=ja

" search {{{
set ignorecase  " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
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
" indent, tab{{{
set expandtab       "タブの代わりに空白文字を挿入する
set shiftwidth  =2  "タブ幅の設定
set tabstop     =2
set softtabstop =2
set autoindent
set smartindent
set smarttab
" }}}

" encode
set encoding     =utf-8       " 文字コード指定
set fileencodings=utf-8,s-jis " 文字エンコードを次の順番で確認
scriptencoding    utf-8

set fileformats=unix,dos,mac  " 改行コードの自動認識
set ambiwidth=double          " ２バイト特殊文字の幅調整

" quotation github:Shougo/shougo-s-github
"----------------------------------------------------------------------
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/encoding.rc.vim
call s:source_rc('encoding.rc.vim')

" }}}
" highlight {{{
highlight ZenkakuSpace cterm=underline ctermfg=7
"ステータスラインの色を変更(ノーマルモード時)
highlight StatusLine ctermfg=black ctermbg=cyan
" }}}
" autocmd {{{
aug myvimrc
  au!
  au BufNewFile,BufRead *.md     set filetype=markdown
  au BufNewFile,BufRead *.slim   set filetype=slim
  au BufNewFile,BufRead *.less   set filetype=less
  au BufNewFile,BufRead *.coffee set filetype=coffee
  au BufNewFile,BufRead *.scss   set filetype=less
  au BufNewFile,BufRead *.pu     set filetype=plantuml
  au BufNewFile,BufRead *.cjsx   set filetype=coffee
  au BufNewFile,BufRead *.jflex  set filetype=jflex
  au Syntax jflex :call s:source_rc('syntax/jflex.vim')
  au FileType *        setlocal formatoptions-=ro
  au FileType python   setlocal tabstop=8 noexpandtab shiftwidth=4 softtabstop=4
  au FileType make     setlocal tabstop=4 noexpandtab shiftwidth=4 softtabstop=4
  au FileType yaml     setlocal tabstop=4 expandtab   shiftwidth=4 softtabstop=4
  au FileType conf     setlocal tabstop=2 noexpandtab shiftwidth=2 softtabstop=2
  au FileType coffee   setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
  au FileType slim     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
  au FileType plantuml setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
  au InsertLeave        * match TrailingSpaces /\s\+$/
  au BufNewFile,BufRead * match ZenkakuSpace /  /
  au VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
aug END
" }}}
" key-bind {{{
" 感覚的移動mapping"{{{
nnoremap <silent> j  gj
nnoremap <silent> gj j
nnoremap <silent> k  gk
nnoremap <silent> gk k
nnoremap <silent> $  g$
nnoremap <silent> g$ $
vnoremap <silent> j  gj
vnoremap <silent> gj j
vnoremap <silent> k  gk
vnoremap <silent> gk k
vnoremap <silent> $  g$
vnoremap <silent> g$ $
nnoremap } }zz
nnoremap { {zz
nnoremap ]] ]]zz
nnoremap [[ [[zz
nnoremap [] []zz
nnoremap ][ ][zz
"}}}
" カーソルキーmapping"{{{
vnoremap OA <Up>
vnoremap OB <Down>
vnoremap OC <Right>
vnoremap OD <Left>
vnoremap A  <Up>
vnoremap B  <Down>
vnoremap C  <Right>
vnoremap D  <Left>
inoremap OA <Up>
inoremap OB <Down>
inoremap OC <Right>
inoremap OD <Left>
inoremap A  <Up>
inoremap B  <Down>
inoremap C  <Right>
inoremap D  <Left>

nnoremap OA <C-w>- 4
nnoremap OB <C-w>+ 4
nnoremap OC <C-w>< 2
nnoremap OD <C-w>> 2
nnoremap A  <C-w>- 4
nnoremap B  <C-w>+ 4
nnoremap C  <C-w>< 2
nnoremap D  <C-w>> 2
"}}}
" tab {{{
nmap [Tag] <Nop>
nmap t [Tag]
nnoremap [Tag]e :<C-u>tabedit<Space>
nnoremap <silent> [Tag]c :tablast <bar> tabnew<CR>
nnoremap <silent> [Tag]x :tabclose<CR>
nnoremap <silent> [Tag]n :tabnext<CR>
nnoremap <silent> <F3> :tabnext<CR>
nnoremap <silent> [Tag]p :tabprevious<CR>
nnoremap <silent> <F2> :tabprevious<CR>
"}}}
" Disable key {{{
nnoremap Q  q
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
"}}}
" jjでノーマルモードへ
inoremap jj <Esc>
inoremap <C-j><C-j> <Esc>
vnoremap <C-j><C-j> <Esc>

" vv矩形ビジュアル,vvvで行ビジュアル
vnoremap v  <C-v>
vnoremap vv <S-v>

" moving current window
nnoremap <C-j> <C-w><Down>
nnoremap <C-k> <C-w><Up>
nnoremap <Space><Space> <C-w><C-w>

" Paste next line.
nnoremap <silent> gp o<ESC>p^
nnoremap <silent> gP O<ESC>P^
xnoremap <silent> gp o<ESC>p^
xnoremap <silent> gP O<ESC>P^

" <TAB>: indent.
xnoremap <TAB>  >
" <S-TAB>: unindent.
xnoremap <S-TAB>  <

" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

" reload
nnoremap <silent><Leader>ev  :<C-u>edit $MYVIMRC<CR> :echo "Opened .vimrc"<CR>
nnoremap <silent><Leader>rv  :<C-u>source $MYVIMRC<CR> :echo "Reload"<CR>

" delete char
inoremap <C-d> <Del>

" カッコなどを入力したら自動的に中へ
inoremap {} {}<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap <> <><Left>
inoremap {% {%<Space><Space>%}<Left><Left><Left>
inoremap [] []<Left>

" 検索時のハイライトを解除
nnoremap <silent><C-l> :nohlsearch<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" JとDで半ページ移動
nnoremap J <C-D>
nnoremap K <C-U>

" 行末までヤンク
nnoremap Y y$

" C-eで行末
inoremap <C-e> <End>

" Useless command.
nnoremap M m

" Shougo-s-github
"----------------------------------------------------------------------
"https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim#L555-L578
" <angle>
onoremap aa  a>
xnoremap aa  a>
onoremap ia  i>
xnoremap ia  i>

" [rectangle]
onoremap ar  a]
xnoremap ar  a]
onoremap ir  i]
xnoremap ir  i]

" 'quote'
onoremap aq  a'
xnoremap aq  a'
onoremap iq  i'
xnoremap iq  i'

" "double quote"
onoremap ad  a"
xnoremap ad  a"
onoremap id  i"
xnoremap id  i"

" カーソル行空行化
nnoremap cc 0D

" バッファをキーで移動
noremap <silent><F4> <ESC>:bp<CR>
noremap <silent><F5> <ESC>:bn<CR>

" Prefix <Space> {{{
nnoremap <Space>h ^
nnoremap <Space>l $
nnoremap <Space>m %
" }}}
" Prefix[,] {{{
" ,xで行末のスペースを取り除く
nnoremap <silent> ,x :%s/\s\+$//e<CR>
vnoremap <silent> ,x :%s/\s\+$//e<CR>
" ,zで豆腐を取り除く
nnoremap <silent> ,z :%s/  /  /g<CR>
vnoremap <silent> ,z :%s/  /  /g<CR>
" ,pでpaste-modeとの切り替え
nnoremap <silent> ,p :set paste!<CR>
" ,jでjumplistを開く
nnoremap <silent> ,j :<C-u>jumps<CR>
" ,hでヘルプ
nnoremap <silent> ,h :<C-u>h <C-r><C-w><CR>
" }}}
" Prefix[\] {{{
" 任意の文字コードで再オープン
nnoremap <Leader>e :e ++enc=
" バッファを指定して移動できるように
for k in range(1, 9)
  execute 'nnoremap <Leader>'.k ':e #'.k.'<CR>'
endfor
" }}}

" コマンドラインの履歴移動
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" Shift-Sで単語をビジュアル選択
nnoremap <silent>S viw
" ハイライト消去
nnoremap <ESC><ESC> :nohlsearch<CR><ESC><C-l>

" Command-line Window {{{
set cmdwinheight=10 "Command-line windowの行数
nnoremap <sid>vcommand-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  nnoremap <buffer> q :<C-u>quit<CR>
  nnoremap <buffer> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  startinsert!
endfunction
" }}}

" }}}
" Status-line{{{
let g:hi_insert = 'highlight StatusLine ctermfg=red ctermbg=yellow cterm=NONE guifg=red guibg=yellow'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''

function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

" git branch
if has('fugitive')
  set statusline=%<%f\ %h%m%r%{fugitive#statusline(}%=%-14.(%l,%c%V%)\ %P)
endif
"}}}
" color {{{
try
  colorscheme molokai
  let g:molokai_original = 1
catch
  colorscheme koehler
endtry
syntax on
"}}}
" tab {{{
set showtabline=2 " 常にタブ
" tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

"}}}
" function {{{
" copymode {{{
function! CopyModeToggle()
  set number!
  set relativenumber!
  GitGutterSignsToggle
  IndentLinesToggle
endfunction
nnoremap <silent> <F6> :<C-u>call CopyModeToggle()<CR>
" }}}
" comment {{{
function! CommentBlock(comment, ...)
  let introducer =  a:0 >= 1  ?  a:1  :  "//"
  let box_char   =  a:0 >= 2  ?  a:2  :  "*"
  let width      =  a:0 >= 3  ?  a:3  :  strlen(a:comment) + 2
  return introducer . repeat(box_char,width) . "\<CR>"
  \    . introducer . " " . a:comment        . "\<CR>"
  \    . introducer . repeat(box_char,width) . "\<CR>"
endfunction

" ruby/shell/perl/python coment block
inoremap <silent> #### <C-R>=CommentBlock(input("  "), '#', '=', 50)<CR><CR><Up><Up><Right><Right>
" vimscript coment block
inoremap <silent> """" <C-R>=CommentBlock(input("  "), '"', '=', 50)<CR><CR><Up><Up><Right><Right>
" C/C++/java/PHP
inoremap <silent> //// <C-R>=CommentBlock(input("  "), '//', '=', 50)<CR><CR><Up><Up><Right><Right>
" lisp/e-lisp
inoremap <silent> ;;;; <C-R>=CommentBlock(input("  "), ';;', '=', 50)<CR><CR><Up><Up><Right><Right>
"}}}
" Sento-Ryoku {{{
" quotation
"----------------------------------------------------------------------
" http://d.hatena.ne.jp/thinca/20091031/1257001194
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
      \  echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
"}}}
" }}}

