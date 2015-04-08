" init {{{
"=====================================================================
" 初期設定
"=====================================================================
autocmd!

let mapleader='\'

"Windows環境判別用変数
let s:is_windows = has('win32') || has('win64')

"Kaoriya版プラグインの無効化
if has('kaoriya')
  "autodate.vim
  let plugin_autodate_disable = 1
  "cmdex.vim
  let plugin_cmdex_disable = 1
  "dicwin.vim
  let plugin_dicwin_disable = 1
  "format.vim
  let plugin_format_disable = 1
  "hz_ja.vim
  let plugin_hz_ja_disable = 1
  "scrnmode.vim
  let plugin_scrnmode_disable = 1
  "verifyenc.vim
  let plugin_verifyenc_disable = 1
endif
" }}}

" plugin {{{
"======================================================================
" neobundle
"======================================================================

set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" call neobundle#rc(expand('~/.vim/bundle/')) is depercated function
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
call neobundle#end()

filetype plugin indent on     " Required!

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

"======================================================================
" vimproc
"======================================================================

NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \   'windows' : 'make -f make_mingw32.mak',
      \   'cygwin' : 'make -f make_cygwin.mak',
      \   'mac' : 'make -f make_mac.mak',
      \   'unix' : 'make -f make_unix.mak',
      \   },
      \ }

"======================================================================
" neocomplcache
"======================================================================

" if_luaが有効ならneocompleteを使う
"NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache'

"neocomplcacheを有効化
let g:neocomplcache_enable_at_startup = 1
"ポップアップメニューに表示する候補最大数
let g:neocomplcache_max_list = 50
"補完候補とするキーワードの最小の長さ
let g:neocomplcache_min_keyword_length = 3
"補完候補とするシンタックスの最小の長さ
let g:neocomplcache_min_syntax_length = 3
"数字を選択するクイックマッチを有効化
let g:neocomplcache_enable_quick_match = 1
"ワイルドカード展開をする
let g:neocomplcache_enable_wildcard = 1
"自動補完を開始する長さ
let g:neocomplcache_auto_completion_start_length = 2
"CursorHoldIを使用しない
let g:neocomplcache_enable_cursor_hold_i = 0
"入力してから補完候補を表示するまでの時間(ms)
let g:neocomplcache_cursor_hold_i_time = 100
"手動補完を開始する長さ
let g:neocomplcache_manual_completion_start_length = 0
"自動補完開始時、自動的に候補を選択しない
let g:neocomplcache_enable_auto_select = 0
"camel case補完(大文字をワイルドカードのように扱う)
let g:neocomplcache_enable_camel_case_completion = 1
"fuzzy補完 よくわからんので無効化
let g:neocomplcache_enable_fuzzy_completion = 0
"_(underbar)区切りの補完をしない
let g:neocomplcache_enable_underbar_completion = 0

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-g> neocomplcache#undo_completion(
inoremap <expr><C-l> neocomplcache#complete_common_string())

"======================================================================
" dict
"======================================================================

let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'java' : $HOME . './.vim/dict/java.dict',
      \ 'ruby' : $HOME . './.vim/dict/ruby.dict',
      \ 'c'    : $HOME . './.vim/dict/c.dict',
      \ 'cpp'  : $HOME . './.vim/dict/cpp.dict',
      \ }

"======================================================================
" neosnipet
"======================================================================

NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

" mysnipets
let g:neosnippet#snipqets_directory='~/.vim/snippets'

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

"======================================================================
" CapsLock.vim (vim-capslock)
"======================================================================

NeoBundle 'https://github.com/MaxMEllon/vim-capslock'
imap <C-L> <Plug>CapsLockToggle
nmap ,l    <Plug>CapsLockToggle

"======================================================================
" vimpowerline
"======================================================================
" NeoBundle 'Lokaltog.vim-powerline'
" NeoBundle 'alpaca-tc/alpaca_powertabline'
" NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

let g:lightline = {
      \   'colorscheme': 'solarized',
      \   'component': {
      \     'readonly': '%{&readonly?"\u2b64":""}',
      \   },
      \   'separator': { 'left': "\u2b80", 'right': "\u2b82" },
      \   'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
      \   'active': {
      \     'left':  [ [ 'mode', 'paste', 'capstatus' ],
      \                [ 'fugitive', 'gitgutter' ],
      \                [ 'filename' ] ],
      \     'right': [ [ 'filetype' ],
      \                [ 'fileencoding' ],
      \                [ 'fileformat' ] ]
      \   },
      \   'component_expand': {
      \     'syntastic': 'SynasticStatuslineFlag',
      \   },
      \   'component_type': {
      \     'syntastic': 'error',
      \   },
      \   'component_function': {
      \     'capstatus' : 'CapsLockSTATUSLINE',
      \     'fugitive' : 'MyFugitive',
      \     'gitgutter' : 'MyGitGutter'
      \   }
      \ }

" カラー設定
set t_Co=256

" 見た目に関する設定
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" gitbranch名
function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head())
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

"======================================================================
" vim.rails
"======================================================================

NeoBundle 'rails.vim'
let g:rails_level = 4
let g:rails_devalut_database = 'postgresql'

"======================================================================
" The-NERD-tree  ディレクトリ構造表示
"======================================================================

" プロジェクトのツリー表示
NeoBundle 'The-NERD-tree'
" NERDTree
nnoremap <silent>,n :<C-u>NERDTreeToggle<CR>
" バッファがNERDTreeのみになったときNERDTreeをとじる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType")
  \ && b:NERDTreeType == "primary") | q | endif
" ignore
let g:NERDTreeIgnore = ['\.clean$', '\.swp$', '\.bak$', '\~$']
" 隠しファイルの表示設定 0 非表示 1,  表示
let g:NERDTreeShowHidden = 0
" 綺麗にディレクトリ構造を表示する
let g:NERDTreeDirArrows = 0

"======================================================================
" emmet-vim
"======================================================================

NeoBundle 'mattn/emmet-vim'

"======================================================================
" zencoding-vim  htmlサポート
"======================================================================

" NeoBundle 'mattn/zencoding-vim'

" let g:user_zen_leader_key = '<C-y>'
" let g:use_zsn_complete_tag = 1

"======================================================================
" vim-multiple-cursors  sublimeっぽいマルチカーソル
"======================================================================

" NeoBundle 'terryma/vim-multiple-cursors'
" let g:multi_cursor_exit_from_insert_mode = 1

"======================================================================
" vim-indent-guides
"======================================================================

" NeoBundle 'nathanaelkane/vim-indent-guides'
"
" " vim-indent-guides
" let g:indent_guides_auto_colors = 0
" " 起動時にハイライト有効
" let g:indent_guides_enable_on_vim_startup = 1
" " インデントの大きさ
" let g:indent_guides_guide_size = 2
" " 色の手動設定
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg = 008
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg = 017

"======================================================================
" indentLine
"======================================================================

NeoBundle 'Yggdroot/indentLine'

let g:indentLine_color_term = 239
let g:indentLine_color_tty_light = 59
let g:indentLine_color_dark = 1

"======================================================================
" vim-over  置換強化
"======================================================================

NeoBundle 'osyo-manga/vim-over'

" over.vimの起動
nnoremap <silent> <Leader>m :OverCommandLine<CR>
" カーソル下の単語をハイライト付きで置換
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
" コピーした文字列をハイライト付きで置換
nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>

"======================================================================
" vim-quickrun
"======================================================================

NeoBundle 'thinca/vim-quickrun'

let g:quickrun_config = {
      \  '_': {
      \     'runner' : 'vimproc',
      \     'runner/vimproc/updatetime' : 60,
      \     'outputter/buffer/split' : ':botright 8sp',
      \     'hook/time/enable': '1',
      \   }
      \ }
let g:quickrun_config['slim'] = {'command' : 'slimrb', 'exec' : ['%c -p %s']}

set splitbelow

nnoremap <silent><C-q> :QuickRun<CR>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"======================================================================
" unite.vim  .vimproc必要
"======================================================================

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
" NeoBundle 'h1mesuke/unite-outline' # 更新停止?
NeoBundle 'osyo-manga/unite-filetype'

"Unite用のPrefix-key
nnoremap m  <nop>
xnoremap m  <Nop>
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap m [unite]
xmap m [unite]

"Unite向けのマッピング
"uでUnite
nnoremap [unite]u :<C-u>Unite<Space>
";でUnite
nnoremap [unite]; :<C-u>Unite command<CR>

""""" unite neobundle
"neでUnite neobundle
nnoremap [unite]ne :<C-u>Unite -no-split neobundle/
"nuでUnite neobundle/update
nnoremap [unite]nu :<C-u>Unite -no-split neobundle/update<CR>
"bでUnite buffer
nnoremap [unite]b :<C-u>Unite buffer -winheight=5<CR>

""""" unite filer
"fでUnite file_point, file, file_mru
nnoremap [unite]f :<C-u>Unite -buffer-name=files file_point file file_mru<CR>
"hfでUnite file_mru(最近アクセスしたファイルリストを取得)
nnoremap [unite]hf :<C-u>Unite -buffer-name=files file_mru<CR>
"rfでUnite file_rec(カレント以下を再帰的に非同期取得)
nnoremap [unite]rf :<C-u>Unite -buffer-name=files file_rec<CR>
"tでUnite filetype
nnoremap [unite]t :<C-u>Unite -start-insert -vertical -winwidth=20 filetype<CR>
"dでUnite directory, directory_mru
nnoremap [unite]d :<C-u>Unite -buffer-name=files directory directory_mru<CR>

"maでUnite mapping
nnoremap [unite]ma :<C-u>Unite mapping<CR>
"hでUnite help
nnoremap [unite]he :<C-u>Unite -start-insert -winheight=32 help<CR>
"lでUnite locate
nnoremap [unite]l :<C-u>Unite -start-insert locate<CR>
"gでUnite grep
nnoremap [unite]g :<C-u>Unite -buffer-name=search -winheight=20 -no-quit grep<CR>
"wでUnite window
nnoremap [unite]w :<C-u>Unite window<CR>
"sでUnite source
nnoremap [unite]s :<C-u>Unite source<CR>
"yでUnite yankround
nnoremap [unite]y :<C-u>Unite yankround<CR>

""""" disable
" "pでUnite process
" nnoremap [unite]p :<C-u>Unite -vertical process<CR>
" "rでUnite register, history/yank
" nnoremap [unite]r :<C-u>Unite register history/yank<CR>
" cでUnite change
" nnoremap [unite]c :<C-u>Unite change<CR>
" oまたは\oでUnite outline
" nnoremap [unite]o :<C-u>Unite -vertical -winwidth=25 outline<CR>
" nnoremap <Leader>o :<C-u>Unite -vertical -winwidth=25 outline<CR>
" "rmでUnite ref/man
" nnoremap [unite]rm :<C-u>Unite ref/man<CR>
" "rpでUnite ref/pydoc
" nnoremap [unite]rp :<C-u>Unite ref/pydoc<CR>

"======================================================================
" unite-rails
"======================================================================

NeoBundle 'basyura/unite-rails'

nnoremap ,rc :<C-u>Unite rails/controller<CR>
nnoremap ,rm :<C-u>Unite rails/model<CR>
nnoremap ,rv :<C-u>Unite rails/view<CR>
nnoremap ,rh :<C-u>Unite rails/helper<CR>
nnoremap ,rs :<C-u>Unite rails/stylesheet<CR>
nnoremap ,rj :<C-u>Unite rails/javascript<CR>
nnoremap ,rg :<C-u>Unite rails/gemfile<CR>
nnoremap ,rd :<C-u>Unite rails/db<CR>

"======================================================================
" TweetVim (unite)
"======================================================================

NeoBundle 'git://github.com/basyura/TweetVim.git'
NeoBundle 'git://github.com/yomi322/unite-tweetvim.git'
NeoBundle 'https://github.com/tyru/open-browser.vim'
NeoBundle 'https://github.com/basyura/twibill.vim'

nnoremap ,tt :<C-u>Unite tweetvim<CR>
nnoremap ,ts :<C-u>TweetVimSay<CR>

"======================================================================
" AOJproblem
"======================================================================

let g:aoj#user_id = 'mozi_kke'
NeoBundle 'mopp/AOJ.vim'
NeoBundle 'mattn/webapi-vim'

"======================================================================
" caw.vim
"======================================================================

NeoBundle "tyru/caw.vim.git"
nmap ,c <Plug>(caw:i:toggle)
vmap ,c <Plug>(caw:i:toggle)

"======================================================================
" vim-smartchr
"======================================================================

" NeoBundle 'kana/vim-smartchr'
" smartchr
" inoremap <buffer> <expr> = smartchr#loop('=', ' == ', ' = ')
" inoremap <buffer> <expr> + smartchr#loop('+', '++', ' + ')
" inoremap <buffer> <expr> - smartchr#loop('-', '--', ' - ')
" inoremap <buffer> <expr> , smartchr#loop(',', ', ')

" ======================================================================
" syntastic
"======================================================================

NeoBundle 'scrooloose/syntastic'

let g:syntastic_enable_signs  = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_signs  = 1
let g:syntastic_ruby_checkers =['rubocop']
let g:syntastic_error_symbol  ='☠ '
let g:syntastic_warning_symbol='☃ '
let g:syntastic_mode_map = {
      \  'mode': 'active',
      \  'active_filetypes': ['c', 'c++', 'ruby'],
      \  'passive_filetypes': []
      \ }

augroup AutoSyntastic
  if v:version > 703
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.rb call s:syntastic()
  endif
augroup END

function! s:syntastic()
  SyntasticCheck
  " なぜかindentguideが消えるので再呼び出し
  " silent IndentGuidesEnable
  call lightline#update()
endfunction

nnoremap ,sc :<C-u>SyntasticCheck<CR>
nnoremap ,sct :<C-u>SyntasticToggleMode<CR>

"======================================================================
" vim-smartinput do end の自動化
"======================================================================

" NeoBundle "kana/vim-smartinput"
" NeoBundle "cohama/vim-smartinput-endwise"
"
" call smartinput_endwise#define_default_rules()

"======================================================================
" Yankring.vim
"======================================================================

" NeoBundle 'YankRing.vim'
"
" " Yank履歴表示
" nnoremap ,y :YRShow<CR>
" let g:yankring_window_use_bottom = 1
" let g:yankring_window_height = 20
" let g:yankring_n_keys = 'y D yy'

"======================================================================
" Yankround.vim
"======================================================================

NeoBundle 'LeafCage/yankround.vim'

nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

" nnoremap <silent>,y :<C-u>CtrlPYankRound<CR>

"======================================================================
" undotree
"======================================================================

NeoBundle 'mbbill/undotree'

nnoremap ,u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_SplitWidth = 35
let g:undotree_diffAutoOpen = 1
let g:undotree_diffpanelHeight = 25
let g:undotree_RelativeTimestamp = 1
let g:undotree_TreeNodeShape = '*'
let g:undotree_HighlightChangedText = 1

"======================================================================
" minibufexpl
"======================================================================

" NeoBundle 'fholgado/minibufexpl.vim'
"
" let g:miniBufExplorerMoreThanOne = 0      " 無条件でバッファ一覧が開く
" let g:miniBufExplMapWindowNavVim = 1      " hjklで移動
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBuffs = 1
" let g:miniBufExplSplitBelow = 0
" let g:miniBufExplSplitToEdge = 1
" au BufNewFile,BufRead *.ejs set filetype=jst

"======================================================================
" switch.vim
"======================================================================

NeoBundle 'AndrewRadev/switch.vim'

" switch.vim
" http://www.vimninjas.com/2012/09/12/switch/
let g:variable_style_switch_definitions = [
       \   {
       \     't': {
       \       'true': 'false'
       \     },
       \
       \     'f': {
       \       'false': 'true'
       \     },
       \     'T': {
       \       'TRUE': 'FALSE'
       \     },
       \     'F': {
       \       'FALSE': 'TRUE'
       \     },
       \   }
       \ ]
nnoremap <Leader>+ :call switch#Switch(g:variable_style_switch_definitions)<CR>
nnoremap <Leader>- :Switch<CR>

"======================================================================
" vim-slim
"======================================================================

NeoBundle 'slim-template/vim-slim'

"======================================================================
" vim-less
"======================================================================

NeoBundle 'groenewege/vim-less'

"======================================================================
" vim-coffee-script
"======================================================================

NeoBundle 'kchmck/vim-coffee-script'

"======================================================================
" surround
"======================================================================

NeoBundle 'surround.vim'

"======================================================================
" w3m.vim
"======================================================================

NeoBundle 'yuratomo/w3m.vim'

let g:w3m#external_browser = 'firefox'
let g:w3m#hit_a_hint_key = 'f'

" terminal用
nmap <F8> [w3m]
xmap <F8> [w3m]
nnoremap [w3m]s :W3mTab google
nnoremap [w3m]r :W3mTab http://localhost:3000<CR>

" xwindow,windows用
nmap <F9> [w3mEx]
xmap <F9> [w3mEx]
nnoremap [w3mEx]s :W3mTabExtenalBrowser google
nnoremap [w3mEx]r :W3mTab http://localhost:3000<CR>

"======================================================================
" TwitVim
"======================================================================

" NeoBundle 'TwitVim'
"
" let twitvim_force_ssl = 1
" let twitvim_count = 40

"======================================================================
" platUML-syntax
"======================================================================

NeoBundle 'https://github.com/MaxMEllon/plantuml-syntax'

"======================================================================
" colorscheme
"======================================================================

" 黒が見にくい環境用
NeoBundle 'altercation/vim-colors-solarized'
" 白色がぼやけて見える、molokaiやwobatがぼやけて見にくい環境用
NeoBundle 'vim-scripts/twilight'
" molokaiに飽きを感じたころ用
NeoBundle 'Wombat256.vim'
" }}}

" 自作プラグイン {{{
" NeoBundle 'comeblo'
" }}}

" 基本設定 {{{
" =====================================================================
" 基本的な設定
"======================================================================

"autocmd!をMyAutoCmdに追加
augroup MyAutoCmd
  autocmd!
augroup END

"256色使えるように
set t_Co=256

"行番号をつける
set number
set relativenumber

" vim以外で変更された時自動的に更新
set autoread

"viとの互換性をOFF
"OFFにするとなぜかwhichwrapが効かなくなる
"whichwrapより前に書くと解決
set nocompatible

"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

"少し賢いBackSpace
set backspace=indent,eol,start

"前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" encode {{{
"文字コード指定
set encoding=utf-8
if !s:is_windows
  set fileencoding=utf-8
else
  set fileencodings=sjis
endif
" 文字エンコードを次の順番で確認
set fileencodings=iso-2022-jp,sjis,euc-jp,utf-8,cp932

"文字エンコーディングの自動判別
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double

"}}}

" :next :previous などのコマンドを実行する度に保存
set autowrite

"組みとして扱う文字の追加
set matchpairs+=<:>

" 上下10行の視界を確保
set scrolloff=10

" 自動コメントアウトの解除
autocmd FileType * setlocal formatoptions-=ro

" モードラインを有効
set modeline
" 3行目までをモードラインとして検索する
set modelines=3

" インクリメント，デクリメント時10進数
set nf=alpha,hex

" helpの言語設定 検索順序 japanese
helptags ~/.vim/help/vimdoc-ja/doc
set runtimepath+=~/.vim/help/vimdoc-ja
set helplang=ja

" folding {{{
"======================================================================
" 折りたたみ
"======================================================================

" 折りたたみon
set foldenable
" 折りたたみ方法:マーカ
set foldmethod=marker
"
set foldcolumn=3
"
set foldlevel=0
" 自動オープン
" set foldopen=all
" 自動クローズ
" set foldclose=all

"}}}
"}}}

" indent, tab{{{
"===========================================================
" indent, tab
"===========================================================

"タブの代わりに空白文字を挿入する
set expandtab

"タブ幅の設定
set shiftwidth=2
set tabstop=2
set softtabstop=2

"自動インデント
set autoindent

"スマートインデント
set smartindent

"スマートタブ
set smarttab

" }}}

" file固有 {{{
"======================================================================
" file固有
"======================================================================
" Pysonでの<tab>文字の設定
autocmd FileType python setlocal tabstop=8 noexpandtab shiftwidth=4 softtabstop=4
" Makefileでの<tab>文字の設定
autocmd FileType make   setlocal tabstop=4 noexpandtab shiftwidth=4 softtabstop=4
" yamlでの<tab>文字の設定
autocmd FileType yaml setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4
" confでの<tab>文字の設定
autocmd FileType conf setlocal tabstop=2 noexpandtab shiftwidth=2 softtabstop=2
" coffeeでの<tab>文字の設定
autocmd FileType coffee setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
" slimでの自動インデント無効化
autocmd FileType slim setlocal tabstop=2 noautoindent nosmartindent expandtab shiftwidth=2 softtabstop=2
" plantuml
autocmd FileType plantuml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
" markdownax
autocmd BufNewFile,BufRead *.md set filetype=markdown
" slim
autocmd BufNewFile,BufRead *.slim set filetype=slim
" less
autocmd BufNewFile,BufRead *.less set filetype=less
" coffee
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
" scssのハイライトがおかしいのでlessで代用
autocmd BufNewFile,BufRead *.scss set filetype=less
" platuml
autocmd BufNewFile,BufRead *.pu set filetype=plantuml
" }}}

" swap, backup {{{
"===========================================================
" swap, backup file
"===========================================================

if !s:is_windows  "Linuxのとき
  "スワップファイルを作る
  set swapfile
  "バックアップファイルを作る
  set backup
  "スワップファイルの出力先を指定
  set directory=~/.vim/_tmp
  "バックアップファイルの出力先を指定
  set backupdir=~/.vim/_tmp
else              "Windowsのとき
  "スワップファイルをつくらない
  set noswapfile
  "バックアップを作らない
  set nobackup
endif
" }}}

" search {{{
"===========================================================
" search
"===========================================================

"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

"検索をファイルの先頭へループしない
set nowrapscan

"インクリメンタルサーチを有効
"検索ワードの最初の文字を入力した時点から検索開始
set incsearch

"ハイライト検索
set hlsearch

" ハイライトの除去
nnoremap <ESC><ESC> :nohlsearch<CR><ESC><C-l>
" }}}

" Command-line Window {{{
"=====================================================================
" Command-line Window
"=====================================================================
"Command-line windowの行数
set cmdwinheight=10

nnoremap <sid>vcommand-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>

nmap :: <sid>(command-line-enter)
xmap :: <sid>(command-line-enter)

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  "Command-line windowで補完を開始する長さ
  "NeoComplCacheAutoCompletionLength 2

  nnoremap <buffer> q :<C-u>quit<CR>
  nnoremap <buffer> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"

  "Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  startinsert!
endfunction
" }}}

" reload {{{
"======================================================================
" 戦闘力を上げるために
"======================================================================

"'\e[v|g]'で.(g)vimrcを編集
nnoremap <silent><Leader>ev  :<C-u>edit $MYVIMRC<CR> :echo "Opened .vimrc"<CR>
nnoremap <silent><Leader>eg  :<C-u>edit $MYGVIMRC<CR> :echo "Opened .gvimrc"<CR>

"'\r[v|g]'で.(g)vimrcを再読み込み
nnoremap <silent><Leader>rv :<C-u>source $MYVIMRC<CR> :echo "Finish Loading .vimrc"<CR>
nnoremap <silent><Leader>rg :<C-u>source $MYGVIMRC<CR> :echo "Finish Loading .vimrc"<CR>
" }}}

" bind {{{
"=====================================================================
" keybind
"=====================================================================
" 移動を直感的に
nnoremap <silent> j gj
nnoremap <silent> gj j
nnoremap <silent> k gk
nnoremap <silent> gk k
nnoremap <silent> $ g$
nnoremap <silent> g$ $
vnoremap <silent> j gj
vnoremap <silent> gj j
vnoremap <silent> k gk
vnoremap <silent> gk k
vnoremap <silent> $ g$
vnoremap <silent> g$ $

"jjでガチノーマルモードへ
inoremap jj <Esc>
inoremap <C-j><C-j> <Esc>
vnoremap <C-j><C-j> <Esc>

"vvガチ矩形ビジュアル,vvvでガチ行ビジュアル
vnoremap v  <C-v>
vnoremap vv <S-v>

" カーソルキーからABCDが出現する謎現象を解消
vnoremap OA <Up>
vnoremap OB <Down>
vnoremap OC <Right>
vnoremap OD <Left>
vnoremap A <Up>
vnoremap B <Down>
vnoremap C <Right>
vnoremap D <Left>
inoremap OA <Up>
inoremap OB <Down>
inoremap OC <Right>
inoremap OD <Left>
inoremap A <Up>
inoremap B <Down>
inoremap C <Right>
inoremap D <Left>

" ウィンドウサイズ変更
nnoremap OA <C-w>- 4
nnoremap OB <C-w>+ 4
nnoremap OC <C-w>< 2
nnoremap OD <C-w>> 2
nnoremap A <C-w>- 4
nnoremap B <C-w>+ 4
nnoremap C <C-w>< 2
nnoremap D <C-w>> 2

"1文字のみの移動はこれで
inoremap <C-f><C-h> <Left>
inoremap <C-f><C-j> <Down>
inoremap <C-f><C-k> <Up>
inoremap <C-f><C-l> <Right>

"バックスペースとデリートキーをエイリアス
"inoremap <C-u> <BS>
inoremap <C-d> <Del>

"行の先頭へ移動
nnoremap <Space>h ^

"行の後ろへ移動
nnoremap <Space>l $

"Tabでウィンドウの移動
" nnoremap <silent><Tab> <C-w>w

"カッコなどを入力したら自動的に中へ
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

" バッファをキーで移動
noremap <silent> <F4> <ESC>:bp<CR>
noremap <silent> <F5> <ESC>:bn<CR>

" 行番号切り替え
nnoremap <F5> :<C-u>setlocal relativenumber!<CR>

" 削除でレジスタに格納しない(ビジュアルモードでの選択後は格納する)
" nnoremap x "_x
" nnoremap X "_X"

" Spaceを使った画面移動
nnoremap <Space><Space> <C-w><C-w>

""" Prefix[,]
" ,xで行末のスペースを取り除く
nnoremap <silent> ,x :%s/\s\+$//e<CR>
vnoremap <silent> ,x :%s/\s\+$//e<CR>
" ,zで豆腐を取り除く
nnoremap <silent> ,z :%s/　/  /g<CR>
vnoremap <silent> ,z :%s/　/  /g<CR>
" ,pでpaste-modeとの切り替え
nnoremap <silent> ,p :set paste!<CR>
" ,jでjumplistを開く
nnoremap <silent> ,j :<C-u>jumps<CR>
" ,vでカーソルから行末までヤンク
nnoremap ,v v$hy

""" Prefix[\]
" 行番号とシンタックスを無効化
nnoremap <silent> <Leader>f :call Alloff()<CR>
" 行番号とシンタックスを有効化
nnoremap <silent> <Leader>g :call Allon()<CR>
" 任意の文字コードで再オープン
nnoremap <Leader>e :e ++enc=
" バッファを指定して移動できるように
for k in range(1, 9)
  execute 'nnoremap <Leader>'.k ':e #'.k.'<CR>'
endfor

" 便利だけど誤タイプでトラウマにになったので
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" コマンドラインの履歴移動
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Shift-Sで単語をビジュアル選択
nnoremap <silent>S viw
" }}}

" view {{{
"=====================================================================
" 視覚化、表示など
"=====================================================================

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=7
au BufNewFile,BufRead * match ZenkakuSpace /　/

"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch

"タブ文字、行末など不可視文字を表示する
set list

"listで表示される文字のフォーマットを指定する
set listchars=eol:$,tab:>-,trail:_

"ステータスラインを常に表示
set laststatus=2

"ステータスラインを1行
set cmdheight=1

"ステータスラインに色々表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
"ノーマルモード後にすぐ反映されない対策
if has('unix') && !has('gui_running')
  inoremap <silent> <ESC> <ESC>
  vnoremap <silent> <ESC> <ESC>
endif

" ステータスラインの色を変更(ノーマルモード時)
highlight StatusLine ctermfg=black ctermbg=cyan

"カーソル行をハイライト
set cursorline

" 行末のスペースをハイライト
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd InsertLeave * match TrailingSpaces /\s\+$/
augroup END
" }}}

" Status-line{{{
"=================================================
" インサートモード時に、ステータスラインの色を変更
" Windowsのときのみ
"=================================================
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
set statusline=%<%f\ %h%m%r%{fugitive#statusline(}%=%-14.(%l,%c%V%)\ %P)
"}}}

" color {{{
"=====================================================================
" color
"=====================================================================

colorscheme molokai
syntax on
let g:molokai_original = 1
let g:rehash256 = 1

" syntaxと行番号をoff
function! Alloff()
  set relativenumber!
  silent set nonumber
  silent syntax off
  " silent IndentGuidesDisable
  silent IndentLinesToggle
  silent SyntasticToggleMode
  silent set listchars-=eol:$
endfunction

" syntaxと行番号をon
function! Allon()
  set relativenumber!
  silent set number
  silent syntax on
  silent set cursorline
  " silent IndentGuidesEnable
  silent IndentLinesToggle
  silent SyntasticToggleMode
  silent set listchars=eol:$,tab:>-,trail:_
endfunction
"}}}

" tab-editer {{{
"=====================================================================
" tab-editer
"=====================================================================
set showtabline=2 " 常にタブ
" prefix
nnoremap [Tag] <Nop>
nmap t [Tag]
" tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap [Tag]e :<C-u>tabedit<Space>
" tab create
nnoremap <silent> [Tag]c :tablast <bar> tabnew<CR>
" tab close
nnoremap <silent> [Tag]x :tabclose<CR>
" tab next
nnoremap <silent> [Tag]n :tabnext<CR>
nnoremap <silent> <F3> :tabnext<CR>
" tab preb
nnoremap <silent> [Tag]p :tabprevious<CR>
nnoremap <silent> <F2> :tabprevious<CR>
"}}}

" comment{{{
"=====================================================================
" comment
"=====================================================================

" コメントブロック作成関数
function! CommentBlock(comment, ...)
    let introducer =  a:0 >= 1  ?  a:1  :  "//"
    let box_char   =  a:0 >= 2  ?  a:2  :  "*"
    let width      =  a:0 >= 3  ?  a:3  :  strlen(a:comment) + 2
    " blockの出力
    return introducer . repeat(box_char,width) . "\<CR>"
    \    . introducer . " " . a:comment        . "\<CR>"
    \    . introducer . repeat(box_char,width) . "\<CR>"
endfunction

" ruby/shell/perl/python coment block
inoremap <silent> #### <C-R>=CommentBlock(input("  "), '#', '=', 70)<CR><CR><Up><Up><Right><Right>
" vimscript coment block
inoremap <silent> """" <C-R>=CommentBlock(input("  "), '"', '=', 70)<CR><CR><Up><Up><Right><Right>
" C/C++/java/PHP
inoremap <silent> //// <C-R>=CommentBlock(input("  "), '//', '=', 70)<CR><CR><Up><Up><Right><Right>
" lisp/e-lisp
inoremap <silent> ;;;; <C-R>=CommentBlock(input("  "), ';;', '=', 70)<CR><CR><Up><Up><Right><Right>
"}}}

" Sento-Ryoku {{{
" http://d.hatena.ne.jp/thinca/20091031/1257001194
"======================================================================
" Sento-Ryoku
"======================================================================
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
