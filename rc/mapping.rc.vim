"---------------------------------------------------------------------------
" Mapping:
"

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
nmap s [Tag]
nnoremap [Tag]e :<C-u>tabedit<Space>
nnoremap <silent> [Tag]c :tablast <bar> tabnew<CR>
nnoremap <silent> [Tag]n :tabnew<CR>
nnoremap <silent> [Tag]x :tabclose<CR>
nnoremap <silent> [Tag]n :tabnext<CR>
nnoremap <silent> <F3> :tabnext<CR>
nnoremap <silent> [Tag]p :tabprevious<CR>
nnoremap <silent> <F2> :tabprevious<CR>
"}}}
" Disable key {{{
nnoremap M m
nnoremap Q q
nnoremap K  <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
"}}}

" `^ は 挿入モードが終了した場所へのジャンプ
" ノーマルモードに入った時，カーソルがずれるのを無効化
" jjでノーマルモードへ
inoremap <silent> jj     <Esc>`^
inoremap <silent> <Esc>  <Esc>`^
inoremap <silent> <C-[>  <Esc>`^
" insertモード強制終了の封印
inoremap <C-c> <Esc>`^

inoremap <C-j><C-j> <Esc>`^
vnoremap <C-j><C-j> <Esc>

" vv矩形ビジュアル,vvvで行ビジュアル
vnoremap v  <C-v>
vnoremap vv <S-v>

nnoremap <expr> 0
  \ col('.') ==# 1 ? '^' : '0'

" Paste next line.
nnoremap <silent> gp o<ESC>p^
nnoremap <silent> gP O<ESC>P^
xnoremap <silent> gp o<ESC>p^
xnoremap <silent> gP O<ESC>P^

" <TAB>: indent.
xnoremap <TAB>  >gv
" <S-TAB>: unindent.
xnoremap <S-TAB>  <gv

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
nnoremap <BS>  X

" カッコなどを入力したら自動的に中へ
inoremap {} {}<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap <> <><Left>
inoremap [] []<Left>
inoremap <bar><bar> <bar><bar><Left>
inoremap {% {%<Space><Space>%}<Left><Left><Left>
" inoremap {}<CR> {}<Left><CR><Up><End><Left><CR><Esc>o
" inoremap (){}<CR> (){}<Left><CR><Up><End><Left><CR><Esc>o

" 検索時のハイライトを解除
nnoremap <silent><C-l> :nohlsearch<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
" nnoremap n nzz
" nnoremap N Nzz
" nnoremap * *zz
" nnoremap # #zz
"=> Use anzu
nnoremap g* g*zz
nnoremap g# g#zz

nnoremap <C-j> *
nnoremap <C-k> #

" See: https://github.com/martin-svk/dot-files/blob/682087a4ff45870f55bd966632156be07a2ff1c4/vim/vimrc#L343-347
" Remap H and L (top, bottom of screen to left and right end of line)
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_

" 行末までヤンク
nnoremap Y y$

" C-eで行末
inoremap <C-e> <End>

" See: https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim#L555-L578
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

nnoremap cid ci"
nnoremap ciq ci'
nnoremap cir ci]
nnoremap cia ci>

" Increment [1,2]
noremap + <C-a>
noremap - <C-x>
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" See: https://github.com/supermomonga/dot-vimrc/blob/master/.vimrc#L462-466
" _ : Quick horizontal splits
nnoremap _ :sp .<CR>
" | : Quick vertical splits
nnoremap <bar> :vsp .<CR>

" カーソル行空行化
nnoremap cc 0Di

" バッファをキーで移動
noremap <silent><F4> <ESC>:bp<CR>
noremap <silent><F5> <ESC>:bn<CR>

" Prefix <Space> {{{
nnoremap <Space>h ^
nnoremap <Space>l $
nnoremap <Space>m %
nnoremap <Space><Space> <C-w><C-w>
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
" nnoremap <silent> ,j :<C-u>jumps<CR>
" }}}
" Prefix[\] {{{
" 任意の文字コードで再オープン
nnoremap <Leader>e :e ++enc=
" バッファを指定して移動できるように
for s:k in range(1, 9)
  execute 'nnoremap <Leader>' . s:k ':e #' . s:k . '<CR>'
endfor
" }}}

" Shift-Sで単語をビジュアル選択
nnoremap <silent>S viw
" ハイライト消去
nnoremap <ESC><ESC> :nohlsearch<CR><ESC><C-l>

" Command-line Window {{{
" enable command line
" : without
nnoremap : q:
vnoremap : q:
nnoremap ; :

" コマンドラインの履歴移動
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
set cmdwinheight=5 "Command-line windowの行数
nnoremap <sid>vcommand-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>

au MyVimrc CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  nnoremap <buffer> q :<C-u>quit<CR>
  nnoremap <buffer> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR>   pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h>  pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS>   pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  startinsert!
endfunction
" }}}

