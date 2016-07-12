"
"                                    ..
"                                  .::::.
"                     ___________ :;;;;:`____________
"                     \_________/ ?????L \__________/
"                       |.....| ????????> :.......'
"                       |:::::| $$$$$$"`.:::::::' ,
"                      ,|:::::| $$$$"`.:::::::' .OOS.
"                    ,7D|;;;;;| $$"`.;;;;;;;' .OOO888S.
"                  .GDDD|;;;;;| ?`.;;;;;;;' .OO8DDDDDNNS.
"                   'DDO|IIIII| .7IIIII7' .DDDDDDDDNNNF`
"                     'D|IIIIII7IIIII7' .DDDDDDDDNNNF`
"                       |EEEEEEEEEE7' .DDDDDDDNNNNF`
"                       |EEEEEEEEZ' .DDDDDDDDNNNF`
"                       |888888Z' .DDDDDDDDNNNF`
"                       |8888Z' ,DDDDDDDNNNNF`
"                       |88Z'    'DNNNNNNN"
"                       '"'        'MMMM"
"                                    '"
" start up {{{
if !1 | finish | endif
" Startup time. {{{
" See: https://gist.github.com/thinca/1518874
" if has('vim_starting') && has('reltime')
"   let s:startuptime = reltime()
"   augroup vimrc-startuptime
"     autocmd! VimEnter *
"           \   echomsg 'startuptime: ' . reltimestr(reltime(s:startuptime))
"           \ | unlet s:startuptime
"   augroup END
" endif
"}}}
filetype off
filetype plugin indent off
" autocmd {{{
" See: https://github.com/rhysd/dotfiles/blob/master/vimrc#23-27
autocmd!
augroup MyVimrc
  autocmd!
augroup END
command! -nargs=* Autocmd autocmd MyVimrc <args>
command! -nargs=* AutocmdFT autocmd MyVimrc FileType <args>
" }}}
" wrapper {{{
function! s:cnoreabbrev_wrap(...)
  execute a:1 . 'noreabbrev ' . a:2 . ' ' . a:3
endfunction
command! -nargs=* Abbr call s:cnoreabbrev_wrap(<f-args>)
" }}}
" system type {{{
let s:is_windows = has('win32') || has('win64') " || has('win16') omoide
let s:is_cygwin = has('win32unix')
let s:is_sudo = $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

function! IsWindows()
  return s:is_windows
endfunction

function! IsMac()
  return !s:is_windows && !s:is_cygwin
        \ && (has('mac') || has('macunix') || has('gui_macvim') ||
        \   (!executable('xdg-open') &&
        \     system('uname') =~? '^darwin'))
endfunction
" }}}
let s:true = !0
let s:false = 0
" }}}

" python {{{
if !has('nvim') && !has('gui_running') && !empty($PYENV_ROOT)
  let s:python2home = $PYENV_ROOT . '/versions/2.7.11'
  let s:python2dll  = $PYENV_ROOT . '/versions/2.7.11/lib/libpython2.7.dylib'
  let &pythondll = s:python2dll
  let $PYTHONHOME = s:python2home

  " let s:python3home = $PYENV_ROOT . '/versions/3.5.1'
  " let s:python3dll  = $PYENV_ROOT . '/versions/3.5.1/lib/libpython3.5m.dylib'
  " let &pythonthreedll = s:python3dll
  " let $PYTHONHOME = s:python3home
endif
" }}}

" encoding {{{
" See:
" https://raw.githubusercontent.com/Shougo/shougo-s-github/master/vim/rc/encoding.rc.vim
" The automatic recognition of the character code.
" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting')
  set encoding=utf-8
endif
" Setting of terminal encoding."{{{
if !has('gui_running')
  if &term ==# 'win32' &&
        \ (v:version < 703 || (v:version == 703 && has('patch814')))
    " Setting when use the non-GUI Japanese console.

    " Garbled unless set this.
    set termencoding=cp932
    " Japanese input changes itself unless set this.  Be careful because the
    " automatic recognition of the character code is not possible!
    set encoding=japan
  else
    if $ENV_ACCESS ==# 'linux'
      set termencoding=euc-jp
    elseif $ENV_ACCESS ==# 'colinux'
      set termencoding=utf-8
    else  " fallback
      set termencoding=  " same as 'encoding'
    endif
  endif
elseif IsWindows()
  " For system.
  set termencoding=cp932
endif
"}}}
" The automatic recognition of the character code."{{{
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " Does iconv support JIS X 0213?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " Build encodings.
  let &fileencodings = 'ucs-bom'
  if &encoding !=# 'utf-8'
    let &fileencodings .= ',' . 'ucs-2le'
    let &fileencodings .= ',' . 'ucs-2'
  endif
  let &fileencodings .= ',' . s:enc_jis
  let &fileencodings .= ',' . 'utf-8'

  if &encoding ==# 'utf-8'
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings .= ',' . 'cp932'
    let &fileencodings .= ',' . &encoding
  else  " cp932
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . &encoding
  endif
  let &fileencodings .= ',' . 'cp20932'

  unlet s:enc_euc
  unlet s:enc_jis

  let did_encoding_settings = 1
endif
"}}}
if has('kaoriya')
  set fileencodings=guess
endif

" When do not include Japanese, use encoding for fileencoding.
function! s:ReCheck_FENC() "{{{
  let is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction"}}}

Autocmd BufReadPost * call s:ReCheck_FENC()

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac

" Command group opening with a specific character code again."{{{
" In particular effective when I am garbled in a terminal.
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8
      \ edit<bang> ++enc=utf-8 <args>
" Open in iso-2022-jp again.
command! -bang -bar -complete=file -nargs=? Iso2022jp
      \ edit<bang> ++enc=iso-2022-jp <args>
" Open in Shift_JIS again.
command! -bang -bar -complete=file -nargs=? Cp932
      \ edit<bang> ++enc=cp932 <args>
" Open in EUC-jp again.
command! -bang -bar -complete=file -nargs=? Euc
      \ edit<bang> ++enc=euc-jp <args>
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16
      \ edit<bang> ++enc=ucs-2le <args>
" Open in UTF-16BE again.
command! -bang -bar -complete=file -nargs=? Utf16be
      \ edit<bang> ++enc=ucs-2 <args>

" Aliases.
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}
" Tried to make a file note version."{{{
" Don't save it because dangerous.
command! WUtf8 setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932 setlocal fenc=cp932
command! WEuc setlocal fenc=euc-jp
command! WUtf16 setlocal fenc=ucs-2le
command! WUtf16be setlocal fenc=ucs-2
" Aliases.
command! WJis  WIso2022jp
command! WSjis  WCp932
command! WUnicode WUtf16
"}}}
" Appoint a line feed."{{{
command! -bang -complete=file -nargs=? WUnix
      \ write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos
      \ write<bang> ++fileformat=dos <args> | edit <args>
command! -bang -complete=file -nargs=? WMac
      \ write<bang> ++fileformat=mac <args> | edit <args>
"}}}
if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
" }}}

" plugin {{{

call plug#begin('~/.vim/plugged')

" load Plugin {{{
" out {{{
" Plug '5t111111/alt-gtags.vim'
" Plug 'Command-T'                 " ruby のバージョンが異なるのか，vimが落ちる
" Plug 'KazuakiM/vim-qfstatusline'
" Plug 'MaxMEllon/molokai'
" Plug 'MaxMEllon/vim-css-color', {'for' : ['css', 'sass', 'scss', 'stylus']}
" Plug 'MaxMEllon/vim-dirvish'
" Plug 'PDV--phpDocumentor-for-Vim', {'on' : 'PhpDocSingle', 'for' : 'php'}
" Plug 'Shougo/context_filetype.vim'
" Plug 'Shougo/neocompletecache'                                 " 依存なし低速
" Plug 'Shougo/neoinclude.vim', {'for' : ['cpp', 'c']}
" Plug 'Shougo/unite-build'
" Plug 'Shougo/unite-outline'
" Plug 'Shougo/vimshell.vim'
" Plug 'ahayman/vim-nodejs-complete'
" Plug 'airblade/vim-gitgutter'
" Plug 'alpaca-tc/alpaca_tags'                   " ctagsマネージャー，自動ctags
" Plug 'alpaca-tc/neorspec.vim', {'on' : 'RSpec'}
" Plug 'altercation/vim-colors-solarized'
" Plug 'cespare/vim-toml', {'for' : 'toml'}
" Plug 'chase/vim-ansible-yaml'
" Plug 'cohama/lexima.vim'
" Plug 'cohama/vim-smartinput-endwise'
" Plug 'ctrlpvim/ctrlp.vim'                                          " ファイラ
" Plug 'glts/vim-textobj-comment'
" Plug 'haya14busa/incsearch-easymotion.vim'
" Plug 'haya14busa/incsearch-fuzzy.vim'
" Plug 'haya14busa/incsearch-migemo.vim'
" Plug 'haya14busa/incsearch.vim'
" Plug 'isRuslan/vim-es6', {'for' : 'javascript'}
" Plug 'itchyny/vim-cursorword'              " カーソル下の同じワードハイライト
" Plug 'jelera/vim-javascript-syntax', {'for' : 'javascript'}
" Plug 'justinj/vim-react-snippets'
" Plug 'justinmk/vim-dirvish'
" Plug 'kana/vim-textobj-fold'
" Plug 'koron/codic-vim'
" Plug 'm2mdas/phpcomplete-extended', {'for' : 'php'}
" Plug 'majutsushi/tagbar'
" Plug 'marijnh/tern_for_vim', {'do': 'npm install' }
" Plug 'mattn/benchvimrc-vim', {'on' : 'BenchVimrc'}
" Plug 'mattn/emoji-vim', {'on' : 'Emoji'}
" Plug 'mattn/jscomplete-vim'
" Plug 'mattn/vim-maketable', {'on' : 'MakeTable'}
" Plug 'mattn/vim-textobj-url'
" Plug 'mhartington/oceanic-next'
" Plug 'myhere/vim-nodejs-complete'
" Plug 'nanotech/jellybeans.vim'
" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'octol/vim-cpp-enhanced-highlight', {'for' : ['cpp', 'c']}
" Plug 'osyo-manga/unite-filetype'
" Plug 'osyo-manga/unite-quickfix'
" Plug 'osyo-manga/vim-marching', {'for' : ['cpp', 'c']}
" Plug 'osyo-manga/vim-over'
" Plug 'osyo-manga/vim-textobj-multiblock'
" Plug 'pangloss/vim-javascript', {'for' : 'javascript.jsx'}
" Plug 'ramele/agrep'                                             " 非同期vimgrep
" Plug 'rhysd/endwize.vim'
" Plug 'rhysd/vim-textobj-ruby'
" Plug 'soramugi/auto-ctags.vim'
" Plug 'supermomonga/vimshell-pure.vim'
" Plug 't9md/vim-quickhl'
" Plug 'thinca/vim-scouter', {'on' : 'Scouter'}
" Plug 'tmhedberg/matchit'
" Plug 'toyamarinyon/vim-swift', {'for' : 'swift'}
" Plug 'tpope/vim-dispatch'
" Plug 'tpope/vim-rails'
" Plug 'vim-ruby/vim-ruby'
" Plug 'vim-scripts/javacomplete', {'for' : 'java', 'do' : 'javac autoload/Reflection.java'}
" Plug 'violetyk/neocomplete-php.vim', {'for' : 'php'}
" Plug 'yonchu/accelerated-smooth-scroll'
"   }}}

" completer {{{
"" 補完プラグインリスト
if has('nvim')
  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction
  Plug 'Shougo/deoplete.nvim',  { 'do': function('DoRemote')  }
  Plug 'carlitux/deoplete-ternjs'
elseif has('gui_running')
  Plug 'Valloric/YouCompleteMe' " clang, python2依存 optional: msbuild, eclim等
else
  Plug 'Shougo/neocomplete.vim'                                       " lua依存
endif
Plug 'ternjs/tern_for_vim', {'do' : 'npm install'}
" }}}

" snippets {{{
" Plug 'Shougo/neosnippet'
" Plug 'Shougo/neosnippet-snippets'
if has('python')
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
endif
"   }}}

" common {{{
Plug 'AndrewRadev/switch.vim'              " 決まった文字列を順番にスイッチング
Plug 'LeafCage/foldCC.vim'                        " fold のスタイルをいい感じに
Plug 'LeafCage/yankround.vim'                " yank履歴 optional-depends: unite
Plug 'Shougo/neomru.vim'                             " uniteやneocompleteの依存
Plug 'Shougo/unite-outline'                    " ソースコードのアウトライン表示
Plug 'Shougo/unite.vim'                            " 統合ユーザインターフェース
Plug 'The-NERD-tree'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}               " :system() を非同期化
Plug 'Yggdroot/indentLine'                 " indentごとに線 indent-guidとの選択
Plug 'basyura/unite-rails'                              " railsのM-V-C 移動強化
Plug 'dannyob/quickfixstatus'
Plug 'easymotion/vim-easymotion'                 " 画面内の文字に自由にジャンプ
Plug 'eugen0329/vim-esearch'               " 複数ファイルに対して一括置換，検索
Plug 'gabesoft/vim-ags', {'on' : 'Ags'}             " vim内でag，QuickFixに出力
Plug 'gerw/vim-HiLinkTrace', {'on' : 'HLT'}                       " syntax-info
Plug 'haya14busa/vim-operator-flashy', {'on' : '<Plug>(operator-flashy)'}
Plug 'iyuuya/unite-rails-fat'                           " unite-railsを更に強化
Plug 'jistr/vim-nerdtree-tabs'                     " タブを超えたツリーファイラ
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }         " fzf
Plug 'junegunn/fzf.vim'                                 " fzf-powerfull utility
Plug 'junegunn/vim-easy-align', {'on' : 'EasyAlign'} " 縦にいい感じに揃えるやつ
Plug 'kana/vim-operator-replace'                              " text-object拡張
Plug 'kana/vim-operator-user'        " オレオレディレクトリ構成を自由にジャンプ
Plug 'kana/vim-smartinput'                              " ( -> (|) とかするやつ
Plug 'kana/vim-textobj-function'                            " text obj function
Plug 'kana/vim-textobj-line'                            " text-object拡張(line)
Plug 'kana/vim-textobj-user'                                  " text-object拡張
Plug 'kshenoy/vim-signature'                                       " markを表示
Plug 'mattn/emmet-vim'                                     " htmlに展開するマン
Plug 'mattn/gist-vim', {'on' : 'Gist'}               " カレントバッファをGistに
Plug 'mattn/webapi-vim'                                        " vimでget, post
Plug 'mbbill/undotree'                                               " undo履歴
Plug 'mhinz/vim-signify'                  " signつけるやつ git-gutterとの選択
Plug 'mhinz/vim-startify'                                        " 起動画面拡張
Plug 'osyo-manga/shabadou.vim'                        " QuickFixの汎用hooks提供
Plug 'osyo-manga/vim-brightest'                " カーソル下のワードハイライト
Plug 'osyo-manga/vim-watchdogs'                " 各種lintをQuickRunを通して実行
Plug 'pocke/vim-hier'                         " Quick-fixハイライト，forkのfork
Plug 'prabirshrestha/async.vim'                              " job async utilty
Plug 'rhysd/clever-f.vim'                                    " f, F, t, Tを強化
Plug 'rhysd/committia.vim'                             " Rich vim commit editor
Plug 'sf1/devdoc-vim'                                                  " devdoc
Plug 'surround.vim'                  " () や{} でテキストオブジェクトを囲うマン
Plug 'thinca/vim-quickrun'                               " コンパイル＆ランナー
Plug 'thinca/vim-textobj-function-javascript'             " js function textobj
Plug 'tpope/vim-fugitive'                                     " Gdiffとかを提供
Plug 'tyru/capture.vim', {'on' : 'Capture'}    " コマンドの結果をバッファに出力
Plug 'tyru/caw.vim'                                    " コメントアウトするマン
"   }}}

" html {{{
Plug 'othree/html5.vim'
Plug 'slim-template/vim-slim', {'for' : 'slim'}
Plug 'jaxbot/semantic-highlight.vim', {'on' : 'SemanticHighlightToggle'}
"   }}}

" css {{{
Plug 'wavded/vim-stylus', {'for' : 'stylus'}
Plug 'groenewege/vim-less', {'for' : 'less'}
Plug 'AtsushiM/sass-compile.vim', {'for' : 'sass'}
Plug 'ap/vim-css-color'
" }}}

" go {{{
Plug 'fatih/vim-go', {'for' : 'go'}
"   }}}

" ruby {{{
Plug 'AndrewRadev/splitjoin.vim', {'for' : 'ruby'}
if executable('rct-complete')
  Plug 'osyo-manga/vim-monster', {'for' : 'ruby'}
" else
  " Plug 'NigoroJr/rsense', {'for' : 'ruby'}
  " Plug 'supermomonga/neocomplete-rsense.vim', {'for' : 'ruby'}
endif
" Plug 'keith/rspec.vim'
if has('ruby') | Plug 'todesking/ruby_hl_lvar.vim', {'for' : 'ruby'} | endif
"   }}}

" php {{{
Plug 'StanAngeloff/php.vim', {'for' : 'php'}
"   }}}

" elixir {{{
Plug 'elixir-lang/vim-elixir', {'for' : 'elixir'}
"   }}}

" cpp {{{
Plug 'vim-jp/cpp-vim', {'for' : ['cpp', 'c']}
"   }}}

" haskell {{{
Plug 'dag/vim2hs'
" }}}

" vim {{{
Plug 'vim-jp/syntax-vim-ex'
" }}}

" etc {{{
Plug 'MaxMEllon/plantuml-syntax', {'for' : 'plantuml'}
Plug 'MaxMEllon/vim-tmng', {'for' : ['txt', 'tmng']}
Plug 'tmux-plugins/vim-tmux', {'for' : ['tmux', 'conf']}
Plug 'dag/vim-fish'
"   }}}

" javascript {{{

" syntax {{{
" out {{{
" Plug 'mxw/vim-jsx'
" Plug 'pangloss/vim-javascript'
" Plug 'jelera/vim-javascript-syntax'
" Plug 'MaxMEllon/vim-jsx-pretty' " 自作プラグインはローカルのを読み込む
" Plug 'othree/xml.vim' " See: https://github.com/othree/es.next.syntax.vim/issues/5
" Plug 'othree/vim-jsx'
" }}}
Plug 'leafgarland/typescript-vim'
Plug 'kchmck/vim-coffee-script', {'for' : 'coffee'}
Plug 'mtscout6/vim-cjsx', {'for' : 'coffee'}
Plug 'moll/vim-node'
Plug 'othree/yajs.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'rhysd/npm-debug-log.vim'
" }}}

" etc {{{
Plug 'heavenshell/vim-jsdoc'
Plug 'samuelsimoes/vim-jsx-utils'                       " jsxの整形などを手助け
" }}}

" }}}

" json {{{
Plug 'elzr/vim-json'
"}}}

" fot nyaovim {{{
" Plug 'rhysd/nyaovim-mini-browser'
" Plug 'MaxMEllon/nyaovim-nicolive-comment-viewer', {'do': 'npm install nicolive@0.0.4'}
"   }}}

" if {{{
if has('gui_running') || has('nvim')
  Plug 'artur-shaik/vim-javacomplete2', {'for' : 'java'}
  Plug 'ervandew/eclim'                    " eclipse-backendとvimをつなげるやつ
  Plug 'itchyny/lightline.vim'                     " かっこいいステータスライン
  Plug 'kana/vim-altr'                             " Qucick-fix該当行ハイライト
  Plug 'morhetz/gruvbox'
  Plug 'wakatime/vim-wakatime'
  Plug 'osyo-manga/vim-anzu'                             " 検索時の該当個数表示
else
  " Plug 'MaxMEllon/molokai'
endif
if has('clientserver') | Plug 'thinca/vim-singleton' | endif
" }}}

" }}}

" local plugins {{{
function! s:maxmellon_plug(...) abort " {{{
  let plugin = '~/.vim/localPlugged/' . a:1
  Plug plugin
  unlet plugin
endfunction
command! -nargs=* MyPlug call s:maxmellon_plug(<args>)
" }}}

" MyPlug 'vim-dirvish'
" MyPlug 'music.nyaovim'
MyPlug 'vim-cmus'
MyPlug 'vim-jsx-pretty'
MyPlug 'molokai'

" }}}

call plug#end()

" set plug list {{{
let s:plug = {
      \ "plugs": get(g:, 'plugs', {})
      \ }
function! s:plug.is_installed(name)
  return has_key(self.plugs, a:name) ? isdirectory(self.plugs[a:name].dir) : 0
endfunction
" }}}

" plugin config {{{

if s:plug.is_installed('rails.vim') " {{{
  let g:rails_level = 4
  let g:rails_defalut_database = 'postgresql'
endif
" }}}

if s:plug.is_installed('neocomplcache.vim') " {{{
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
  let g:neocomplcache_dictionary_filetype_lists = {
        \   'default' : '',
        \   'java' : $HOME . './.vim/dict/java.dict',
        \   'ruby' : $HOME . './.vim/dict/ruby.dict',
        \   'c'    : $HOME . './.vim/dict/c.dict',
        \   'cpp'  : $HOME . './.vim/dict/cpp.dict',
        \ }
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " inoremap <expr><C-g> neocomplcache#undo_completion()
  inoremap <expr><C-l> neocomplcache#complete_common_string()
endif
" }}}

if s:plug.is_installed('neocomplete.vim') " {{{
  " Disable AutoComplPop
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 2
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  if !exists('g:neocomplete#sources#force_omni_input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.javascript = '\%(\h\w*\|[^. \t]\.\w*\)'
  let g:neocomplete#sources#omni#input_patterns.markdown = ''
  let g:neocomplete#sources#omni#input_patterns.gitcommit = ''

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y> neocomplete#close_popup()
  inoremap <expr><C-e> neocomplete#cancel_popup()

  let g:neocomplete#sources#omni#functions = get(g:,  'neocomplete#sources#omni#functions',  {})
  let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'

  " Enable omni completion.
  autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript    setlocal omnifunc=tern#Comple
  autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby          setlocal omnifunc=monster#omnifunc

  " let g:jscomplete_use = ['dom',  'moz']
  " let g:nodejs_complete_config = {
  "       \  'js_compl_fn': 'jscomplete#CompleteJS',
  "       \  'max_node_compl_len': 15
  "       \} 

endif
" }}}

if s:plug.is_installed('neocomplete-php.vim') " {{{
  let g:neocomplete_php_locale = 'ja'
endif
" }}}

if s:plug.is_installed('deoplete.nvim') " {{{
  let g:deoplete#enable_at_startup = 1
  imap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ deoplete#mappings#manual_complete()
  function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction "}}}

  " <S-TAB>: completion back.
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

  function! s:my_cr_function() abort
    return deoplete#mappings#close_popup() . "\<CR>"
  endfunction

  call deoplete#custom#set('_', 'converters', [
        \ 'converter_remove_paren',
        \ 'converter_remove_overlap',
        \ 'converter_truncate_abbr',
        \ 'converter_truncate_menu',
        \ 'converter_auto_delimiter',
        \ ])

  " call deoplete#custom#set('buffer', 'min_pattern_length', 9999)

  let g:deoplete#keyword_patterns = {}
  let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'
  " let g:deoplete#keyword_patterns.tex = '\\?[a-zA-Z_]\w*'

  let g:deoplete#omni#input_patterns = {}
  let g:deoplete#omni#functions = {}

  let g:tern#command = ["tern"]
  let g:tern#arguments = ["--persistent"]

  " let g:deoplete#enable_refresh_always = 1
  let g:deoplete#enable_camel_case = 1
  let g:deoplete#auto_complete_start_length = 3

  let g:deoplete#ignore_sources = {'_': ['tag']}
  let g:tern_request_timeout = 1
  let g:tern_show_signature_in_pum = 0
endif
" }}}

if s:plug.is_installed('neosnippet') " {{{
  let g:neosnippet#snipqets_directory='~/.vim/snippets'
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
endif
" }}}

if s:plug.is_installed('lightline.vim') " {{{
  let g:lightline = {
        \   'mode_map': {
        \     'n' : 'N',
        \     'i' : 'I',
        \     'R' : 'R',
        \     'v' : 'V',
        \     'V' : 'V-L',
        \     'c' : 'COMMAND',
        \     "\<C-v>": 'V-B',
        \     's' : 'SELECT',
        \     'S' : 'S-L',
        \     "\<C-s>": 'S-B',
        \   },
        \   'colorscheme': 'wombat',
        \   'component': {
        \     'readonly': '%{&readonly?"\u2b64":""}',
        \   },
        \   'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \   'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
        \   'active': {
        \     'left':  [ [ 'mode', 'paste', 'capstatus' ],
        \                [ 'anzu', 'fugitive' ],
        \                [ 'filename' ] ],
        \     'right': [ [ 'qfstatusline' ],
        \                [ 'filetype' ],
        \                [ 'fileencoding' ],
        \                [ 'fileformat' ] ]
        \   },
        \   'component_expand': {
        \     'syntastic': 'SyntasticStatuslineFlag',
        \     'qfstatusline' : 'qfstatusline#Update'
        \   },
        \   'component_type': {
        \     'syntastic': 'error',
        \     'qfstatusline': 'error',
        \   },
        \   'component_function': {
        \     'anzu' : 'anzu#search_status',
        \     'fugitive' : 'MyFugitive',
        \     'mode' : 'MyMode'
        \   }
        \ }

  let g:Qfstatusline#UpdateCmd = function('lightline#update')

  function! MyMode()
    let fname = expand('%:t')
    return  fname =~ 'NERD_tree' ? 'NERDTree' :
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ &ft == 'undotree' ? 'UndoTree' :
          \ &ft == 'dirvish' ? 'Dirvish' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

endif
"}}}

if s:plug.is_installed('The-NERD-tree') " {{{
  " バッファがNERDTreeのみになったときNERDTreeをとじる
  Autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType")
        \ && b:NERDTreeType == "primary") | q | endif
  " NERDTREE ignor'e
  let g:NERDTreeIgnore = ['\.log, \.clean$', '\.swp$', '\.bak$', '\~$']
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeDirArrows = 0
  let g:NERDTreeWinSize = 20
  nnoremap <silent>,n :<C-u>NERDTreeToggle<CR>
endif
"}}}

if s:plug.is_installed('vim-nerdtree-tabs') " {{{
  nnoremap <silent>,n :<C-u>NERDTreeTabsToggle<CR>
endif
"}}}

if s:plug.is_installed('vim-dirvish') " {{{
  Autocmd BufEnter * if (winnr("$") == 1 && &ft == 'dirvish') | q | endif
  let g:dirvish_window = -1
  function! s:toggle_dirvish()
    if (g:dirvish_window == -1 && &ft != 'dirvish')
      leftabove topleft vsplit .
      let g:dirvish_window = bufwinnr('$')
      vertical resize 20
      wincmd p
    else
      exe g:dirvish_window . 'quit'
      let g:dirvish_window = -1
    endif
  endfunction
  command! -nargs=0 ToggleDirvish call s:toggle_dirvish()
  nnoremap <silent>,n :<C-u> ToggleDirvish<CR>
endif
"}}}

if s:plug.is_installed('indentLine') " {{{
  let g:indentLine_color_term = 239
  let g:indentLine_color_tty_light = 59
  let g:indentLine_color_dark = 1
  let g:indentLine_bufNameExclude = ['NERD_tree.*']
endif
" }}}

if s:plug.is_installed('vim-quickrun') " {{{
  let g:quickrun_config = {
        \  '_': {
        \     'runner' : 'vimproc',
        \     'runner/vimproc/updatetime' : 60,
        \     'outputter/buffer/split' : '',
        \     'outputter/quickfix/open_cmd' : "",
        \     'hook/time/enable': '1',
        \     "hook/back_window/enable" : 1,
        \     "hook/back_window/enable_exit" : 1,
        \   }
        \ }
  let g:quickrun_config['slim'] = {'command' : 'slimrb', 'exec' : ['%c -p %s']}
  nnoremap <silent><C-q> :QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"
endif
" }}}

if s:plug.is_installed('syntastic') "{{{
  let g:syntastic_javascript_checkers = ['jsxhint']
  let g:syntastic_coffee_checkers     = ['jsxhint']
  " depend on Unite, Unite-QuickFix
  let g:syntastic_always_populate_loc_list=1
  let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
  nnoremap [unite]e :<C-u>Unite location_list -winheight=5<CR>
endif
" }}}

if s:plug.is_installed('undotree') " {{{
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_SplitWidth = 35
  let g:undotree_diffAutoOpen = 1
  let g:undotree_diffpanelHeight = 25
  let g:undotree_RelativeTimestamp = 1
  let g:undotree_TreeNodeShape = '*'
  let g:undotree_HighlightChangedText = 1
  nnoremap ,u :UndotreeToggle<CR>
endif
" }}}

if s:plug.is_installed('yankround.vim') "{{{
  nmap p <Plug>(yankround-p)
  xmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  xmap gp <Plug>(yankround-gp)
  " nmap <C-n> <Plug>(yankround-next)
  " nmap <C-p> <Plug>(yankround-prev)
  nnoremap ,y :Unite yankround<CR>
endif
" }}}

if s:plug.is_installed('unite.vim') "{{{
  " nnoremap m  <nop>
  " xnoremap m  <Nop>
  " nnoremap [unite] <Nop>
  " xnoremap [unite] <Nop>
  " nmap m [unite]
  " xmap m [unite]

  " nnoremap [unite]u :<C-u>Unite<CR>
  " nnoremap [unite]g :<C-u>Unite grep:. -buffer-name=search-buffer -no-quit<CR>
  " nnoremap [unite]j :<C-u>Unite jump<CR>
  " nnoremap [unite]e :<C-u>Unite file_rec/async:!<CR>
  " nnoremap [unite]a :<C-u>Unite -start-insert file_rec/async<CR>
  " nnoremap [unite]r <Plug>(unite_restart)
endif
" }}}

if s:plug.is_installed('unite-build') " {{{
  nnoremap ,b :<C-u>Unite build:make -buffer-name=unite-build -winheight=20<CR>
endif
" }}}

if s:plug.is_installed('unite-rails') " {{{
  nnoremap ,rc :<C-u>Unite rails/controller<CR>
  nnoremap ,rm :<C-u>Unite rails/model<CR>
  nnoremap ,rv :<C-u>Unite rails/view<CR>
  nnoremap ,rh :<C-u>Unite rails/helper<CR>
  nnoremap ,rs :<C-u>Unite rails/stylesheet<CR>
  nnoremap ,rj :<C-u>Unite rails/javascript<CR>
  nnoremap ,rg :<C-u>Unite rails/gemfile<CR>
  nnoremap ,rt :<C-u>Unite rails/spec<CR>
endif
" }}}

if s:plug.is_installed('unite-rails-fat') " {{{
  nnoremap ,rd :<C-u>Unite rails/decorator<CR>
  nnoremap ,ra :<C-u>Unite rails/api<CR>
endif
" }}}

if s:plug.is_installed('unite-outline') "{{{
  let g:unite_winwidth = 30
  let g:unite_spliit_rule = "rightbelow"
  nnoremap ,o :<C-u>Unite -vertical outline<CR>
endif
" }}}

if s:plug.is_installed('caw.vim') "{{{
  let g:caw_no_default_keymappings = 1
  nmap ,c <Plug>(caw:hatpos:toggle)
  vmap ,c <Plug>(caw:hatpos:toggle)
endif
" }}}

if s:plug.is_installed('TweetVim') "{{{
  nnoremap ,tt :<C-u>Unite tweetvim<CR>
  nnoremap ,ts :<C-u>TweetVimSay<CR>
endif
" }}}

if s:plug.is_installed('w3m.vim') "{{{
  let g:w3m#external_browser = 'firefox'
  let g:w3m#hit_a_hint_key = 'f'
  nnoremap <F8> [w3m]
  xnoremap <F8> [w3m]
  nnoremap [w3m]s :W3mTab google
  " rails デバッグ用
  nnoremap [w3m]r :W3mTab http://localhost:3000<CR>
endif
" }}}

if s:plug.is_installed('vim-gitgutter') " {{{
  let g:gitgutter_sign_added    = '+'
  let g:gitgutter_sign_modified = '*'
  let g:gitgutter_sign_removed  = '-'
  let g:gitgutter_map_keys = 0

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
    for s:i in [0, 1, 2]
      if hunks[s:i] > 0
        call add(ret, symbols[s:i] . hunks[s:i])
      endif
    endfor
    return join(ret, ' ')
  endfunction
endif
" }}}

if s:plug.is_installed('vim-over') " {{{
  nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//gc<Left><Left><Left>
  xnoremap s :<C-u>OverCommandLine<CR>'<,'>s///gc<Left><Left><Left>
else
  nnoremap sub :%s/<C-r><C-w>//gc<Left><Left><Left>
  xnoremap s :<C-u>'<,'>s///gc<Left><Left><Left><Left><Left>
endif
" }}}

if s:plug.is_installed('vim-anzu') " {{{
  nmap n <Plug>(anzu-n-with-echo) zz
  nmap N <Plug>(anzu-N-with-echo) zz
  nmap * <Plug>(anzu-star-with-echo) zz
  nmap # <Plug>(anzu-sharp-with-echo) zz
  nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
endif
" }}}

if s:plug.is_installed('vim-easymotion') " {{{
  " configure
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_keys = 'hjklasdgyuiopqwertnmzxcvb;:f'
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_use_migemo = 1
  " keymapping
  nmap ss <Plug>(easymotion-s2)
  xmap ss <Plug>(easymotion-s2)
  nmap <Space>j <Plug>(easymotion-j)
  nmap <Space>k <Plug>(easymotion-k)

  highlight EasyMotionTarget guifg=#80a0ff guibg=#80a0ff ctermfg=81 ctermbg=14
endif
" }}}

if s:plug.is_installed('vim-easy-align') "{{{
  vnoremap <Enter> :EasyAlign<CR>
endif
"}}}

if s:plug.is_installed('vim-altr') " {{{
  call altr#define('autoload/%.vim', 'doc/%-doc.txt', 'plugin/%.vim')
  call altr#define('actions/%Action.coffee', 'stores/%Store.coffee')
  call altr#define('actions/%Action.js', 'stores/%Store.js')
  call altr#define('src/%.cpp', 'src/include/%.h')
  nmap ,a <Plug>(altr-forward)
endif
" }}}

if s:plug.is_installed('vim-ruby') " {{{
  let g:rubycomplete_rails = 1
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_include_object = 1
  let g:rubycomplete_include_object_space = 1
endif
" }}}

if s:plug.is_installed('vim-monster') " {{{
  let g:monster#completion#rcodetools#backend = "async_rct_complete"
  let g:neocomplete#sources#omni#input_patterns = {
        \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
        \}
endif
" }}}

if s:plug.is_installed('vim-marching') " {{{
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.cpp =
        \   '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  let g:marching_enable_neocomplete = 1
endif
" }}}

if s:plug.is_installed('vim-watchdogs') "{{{
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config['watchdogs_checker/_'] = {
        \   'runner' : 'vimproc',
        \   'runner/vimproc/sleep' : 10,
        \   'runner/vimproc/updatetime' : 500,
        \   'outputter/buffer/split' : '',
        \   'outputter/quickfix/open_cmd' : "",
        \   'hook/echo/enable' : 0,
        \   'hook/echo/output_success': '> No Errors Found.',
        \   'hook/back_window/enable' : 1,
        \   'hook/back_window/enable_exit' : 1,
        \   'hock/close_buffer/enable_hock_loaded' : 1,
        \   'hock/close_buffer/enable_success' : 1,
        \   'hook/qfstatusline_update/enable_exit' : 1,
        \   'hook/qfstatusline_update/priority_exit' : 4,
        \ }
  let g:watchdogs_check_BufWritePost_enable_on_wq = 0
  let g:quickrun_config['watchdogs_checker/clang++'] = {
        \   'command': 'clang++',
        \   'exec':    '%c %o -Wall -Wextra -std=c++1y -stdlib=libc++ -fsyntax-only %s:p',
        \ }
  let g:quickrun_config['watchdogs_checker/g++'] = {
        \   'command': 'g++',
        \   'exec':    '%c %o -Wall -Wextra -std=c++11 -fsyntax-only %s:p',
        \ }
  let g:quickrun_config['cpp/watchdogs_checker'] = {
        \   'type': 'watchdogs_checker/g++',
        \ }
  if executable('sass')
    let g:quickrun_config['watchdogs_checker/sass'] = {
          \   'command':     'sass',
          \   'exec':        '%c %o --check --compass --trace --no-cache %s:p',
          \   'errorformat': '%f:%l:%m\ (Sass::SyntaxError),%-G%.%#',
          \ }
    let g:quickrun_config['sass/watchdogs_checker'] = {
          \   'type': 'watchdogs_checker/sass',
          \ }

    let g:quickrun_config['watchdogs_checker/scss'] = {
          \   'command': 'sass',
          \   'exec': '%c %o --check --compass --trace --no-cache %s:p',
          \   'errorformat': '%f:%l:%m\ (Sass::SyntaxError),%-G%.%#',
          \ }
    let g:quickrun_config['scss/watchdogs_checker'] = {
          \   'type': 'watchdogs_checker/scss',
          \ }
  endif
  if executable('eslint')
    let g:quickrun_config['javascript/watchdogs_checker'] = {
          \   'type' : 'watchdogs_checker/eslint',
          \ }
    let g:quickrun_config['javascript.jsx/watchdogs_checker'] = {
          \   'type' : 'watchdogs_checker/eslint',
          \ }
    let g:quickrun_config['watchdogs_checker/eslint'] = {
          \    'command' : 'eslint_d',
          \    'exec'    : '%c -f compact %o %s:p',
          \    'errorformat' : '%E%f: line %l\, col %c\, Error - %m,' .
          \            '%W%f: line %l\, col %c\, Warning - %m,' .
          \            '%-G%.%#',
          \ }
  endif
  if executable('rubocop')
    let g:quickrun_config['ruby/watchdogs_checker'] = {
          \   "type" : "watchdogs_checker/rubocop"
          \ }
  endif
  if executable('slimrb')
    let g:quickrun_config['watchdogs_checker/slim'] = {
          \   'command': 'slimrb',
          \   'exec':    '%c %o > /dev/null %s:p',
          \   'errorformat': '(Slim::Parser::SyntaxError)',
          \ }
    let g:quickrun_config['slim/watchdogs_checker'] = {
          \   'type': 'watchdogs_checker/slim',
          \ }
  end
  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
        \ 'c'              : 0,
        \ 'cpp'            : 1,
        \ 'python'         : 0,
        \ 'vim'            : 0,
        \ 'php'            : 1,
        \ 'ruby'           : 0,
        \ 'slim'           : 0,
        \ 'java'           : 0,
        \ 'sass'           : 0,
        \ 'javascript'     : 1,
        \ 'javascript.jsx' : 1,
        \ }
  let g:watchdogs_check_CursorHold_enable = 0
  call watchdogs#setup(g:quickrun_config)
endif
" }}}

if s:plug.is_installed('vim-qfstatusline') " {{{
  function! StatuslineUpdate()
    return qfstatusline#Update()
  endfunction
  let g:Qfstatusline#UpdateCmd = function('StatuslineUpdate')
endif
" }}}

if s:plug.is_installed('vim-quickhl') " {{{
  map ,m <Plug>(quickhl-manual-this)
  map ,M <Plug>(quickhl-manual-reset)
endif
" }}}

if s:plug.is_installed('vim-markdown-quote-syntax') "{{{
  let g:markdown_quote_syntax_filetypes = {
        \   "coffee" : {
        \     "start" : "coffee",
        \  },
        \   "css" : {
        \     "start" : "\\%(css\\|scss\\)",
        \  },
        \   "mustache" : {
        \     "start" : "mustache",
        \  },
        \}
  let g:markdown_fenced_languages = [
        \  'css',
        \  'erb=eruby',
        \  'javascript',
        \  'js=javascript',
        \  'json=javascript',
        \  'ruby',
        \  'sass',
        \  'xml',
        \]
endif
"}}}

if s:plug.is_installed('vim-startify') " {{{
  let g:startify_custom_header = [
        \ '',
        \ '                                    ..',
        \ '                                  .::::.',
        \ '                     ___________ :;;;;:`____________',
        \ '                     \_________/ ?????L \__________/',
        \ '                       |.....| ????????> :.......,',
        \ '                       |:::::| $$$$$$$`.:::::::; ,',
        \ '                      ,|:::::| $$$$$`.:::::::; .OOS.',
        \ '                    ,7D|;;;;;| $$$`.;;;;;;;; .OOO888S.',
        \ '                  .GDDD|;;;;;| ?`.;;;;;;;; .OO8DDDDDNNS.',
        \ '                   `DDO|IIIII| .7IIIII7` .DDDDDDDDNNNF`',
        \ '                     `D|IIIIII7IIIII7` .DDDDDDDDNNNF`',
        \ '                       |EEEEEEEEEE7` .DDDDDDDNNNNF`',
        \ '                       |EEEEEEEEZ` .DDDDDDDDNNNF`',
        \ '                       |888888Z` .DDDDDDDDNNNF`',
        \ '                       |8888Z` ,DDDDDDDNNNNF`',
        \ '                       |88Z`    "DNNNNNNN"',
        \ '                       `"`        "MMMM"',
        \ '                                    ""',
        \ '',
        \ '',
        \ ]
endif
" }}}

if s:plug.is_installed('vim-tmng') " {{{
  let g:tmng#student_id = 's12t241'
  let g:tmng#title_template    = '課題ページ'
  let g:tmng#subtitle_template = ''
  let g:neosnippet#snippets_directory = '~/.vim/plugged/vim-tmng/snippets'
  Autocmd BufWrite *.txt,*.tmng
        \ :TmngReplaceDotAndComma
endif
" }}}

if s:plug.is_installed('vim-jsx') " {{{
  let g:jsx_ext_required = 0
  let g:jsx_pragma_required = 0
endif
" }}}

if s:plug.is_installed('phpcomplete-extended') " {{{
  let g:phpcomplete_index_composer_command = 'composer'
  AutocmdFT php setlocal omnifunc=phpcomplete_extended
endif
" }}}

if s:plug.is_installed('splitjoin.vim') " {{{
  let g:splitjoin_join_mapping = ',j'
  let g:splitjoin_split_mapping = ',s'
endif
"}}}

if s:plug.is_installed('switch.vim') " {{{
  let g:switch_custom_definitions =
        \  [
        \     {
        \         '\(\k\+\)'    : '''\1''',
        \       '''\(.\{-}\)''' :  '"\1"',
        \        '"\(.\{-}\)"'  :   '\1',
        \     },
        \     {
        \       'true'  : 'false',
        \       'false' : 'true',
        \     },
        \     {
        \       'if'     : 'unless',
        \       'unless' : 'if',
        \     },
        \     {
        \       '='  : '\ =\ ',
        \       '\ =\ ' : '\ ==\ ',
        \       '\ ==\ ' : '=',
        \     },
        \     {
        \       '->'  : '=>',
        \       '=>' : '->',
        \     },
        \     {
        \       '-'  : '\ -\ ',
        \       '\ -\ ' : '-',
        \     },
        \     {
        \       '+'  : '\ +\ ',
        \       '\ +\ ' : '+',
        \     },
        \     {
        \       '/'  : '\ /\ ',
        \       '\ /\ ' : '/',
        \     },
        \     {
        \       '\*'  : '\ \*\ ',
        \       '\ \*\ ' : '\*',
        \     },
        \     {
        \       ')'  : ');',
        \       ');' : ')',
        \     },
        \     {
        \       '}'  : '};',
        \       '};' : '},',
        \       '},' : '}',
        \     },
        \     {
        \       ']'  : '];',
        \       '];' : ']',
        \     },
        \  ]
  nnoremap <C-s> :<C-u>Switch<CR>
  nnoremap <Space>sw :<C-u>Switch<CR>
  " <C-o> 使わんし上書き
  inoremap <C-o> <ESC>`^:<C-u>Switch<CR>i
endif
"}}}

if s:plug.is_installed('surround.vim') "{{{
  nmap ,( csw(
  nmap ,) csw)
  nmap ,{ csw{
  nmap ,} csw}
  nmap ,[ csw[
  nmap ,] csw]
  nmap ,' csw'
  nmap ," csw"
endif
" }}}

if s:plug.is_installed('vim-singleton') && has('clientserver') " {{{
  call singleton#enable()
endif
" }}}

if s:plug.is_installed('SrcExpr') " {{{
  " プレビューウインドウの高さ
  let g:SrcExpl_WinHeight     = 9
  " tagsは自動で作成する
  let g:SrcExpl_UpdateTags    = 1
  " マッピング
  let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."
  let g:SrcExpl_RefreshMapKey = "<Space>"
  let g:SrcExpl_GoBackMapKey  = "<C-b>"
  nmap <F8> :SrcExplToggle<CR>
endif
" }}}

if s:plug.is_installed('codic-vim') "{{{
  nnoremap <Space>c :<C-u>Codic<CR>
endif
"}}}

if s:plug.is_installed('incsearch.vim') "{{{
  " map /  <Plug>(incsearch-forward)
  " map ?  <Plug>(incsearch-backward)
  " map g/ <Plug>(incsearch-stay)
  " nnoremap ;/ /
  " nnoremap ;? ?
endif
"}}}

if s:plug.is_installed('clever-f.vim') " {{{
  let g:clever_f_use_migemo            = 1   " migemo likeな検索
  let g:clever_f_ignore_case           = 1   " ignore case
  let g:clever_f_fix_key_direction     = 1   " 行方向固定
  let g:clever_f_across_no_line        = 1   " 行をまたがない
  let g:clever_f_chars_match_any_signs = ';' " 記号は;
endif
" }}}

if s:plug.is_installed('neocomplete-rsense.vim') "{{{
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:rsenseUseOmniFunc = 1
  if filereadable(expand('/usr/local/bin/rsense'))
    let g:rsenseHome = expand('/usr/local/bin/rsense')
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  endif
endif
" }}}

if s:plug.is_installed('php.vim') "{{{
  function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
  endfunction

  augroup phpSyntaxOverride
    autocmd!
    autocmd FileType php call PhpSyntaxOverride()
  augroup END
endif
"}}}

if s:plug.is_installed('auto-ctags.vim') "{{{
  let g:auto_ctags = 1
  let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'
  let g:auto_ctags_bin_path = '/usr/local/bin/ctags'
  let g:auto_ctags_tags_name = 'tags'

  augroup AutoCtags
    autocmd!
    autocmd FileType coffee let g:auto_ctags = 0
  augroup END

  let g:auto_ctags_directory_list = ['.git', '.svn']
endif
"}}}

if s:plug.is_installed('PDV--phpDocumentor-for-Vim') "{{{
  nnoremap <Leader>p :set formatoptions&<CR>:call PhpDocSingle()<CR>kv/func<CR>k=:%s/\s\+$//e<CR><C-o>
  let g:pdv_re_indent=''
endif
"}}}

if s:plug.is_installed('ctrlp.vim') "{{{
  let g:ctrlp_map = '<C-p>'
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed']
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:18'
  let g:ctrlp_user_command = 'files -a %s'
endif
" }}}

if s:plug.is_installed('hl_matchit.vim') " {{{
  let g:hl_matchit_enable_on_vim_startup = 1
  let g:hl_matchit_hl_groupname = 'cursorlinenr'
endif
" }}}

if s:plug.is_installed('jscomplete-vim') "{{{
  AutocmdFT javascript setlocal omnifunc=jscomplete#CompleteJS
  AutocmdFT coffee     setlocal omnifunc=jscomplete#CompleteJS
endif
"}}}

if s:plug.is_installed('tagbar') " {{{
  let g:tagbar_width = 20
  nnoremap <silent> ,o :TagbarToggle<CR>
endif
" " }}}

if s:plug.is_installed('vim-css-colors') " {{{
  let g:cssColorVimDoNotMessMyUpdatetime = 1
endif
" }}}

if s:plug.is_installed('lexima.vim') " {{{
  let g:lexima_enable_basic_rules = 1
  let g:lexima_enable_space_rules = 1
  let g:lexima_enable_endwise_rules = 1
  let g:lexima_enable_newline_rules = 1
  call lexima#set_default_rules()
  call lexima#add_rule({
        \   "at" : '\%#',
        \   "char" : ",",
        \   "input" : ",<Space>",
        \})
  " 誤爆防止用
  call lexima#add_rule({
        \   "at" : ', \%#',
        \   "char" : '<Space>',
        \   "input" : "",
        \})
  call lexima#add_rule({
        \   "at" : ', \%#',
        \   "char" : '<Enter>',
        \   "input" : '<BS><Enter>',
        \})
endif
" }}}

if s:plug.is_installed('tagbar') " {{{
  let g:tagbar_width = 20
  nnoremap <silent> <leader>t :TagbarToggle<CR>
endif
" " }}}

if s:plug.is_installed('vim-css-colors') " {{{
  let g:cssColorVimDoNotMessMyUpdatetime = 1
endif
" }}}

if s:plug.is_installed('vim-go') " {{{
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
endif
" }}}

if s:plug.is_installed('vim-indent-guides') " {{{
  let g:indent_guides_enable_on_vim_startup = 1
  if has('gui_running')
    let g:indent_guides_auto_colors  = 1
    let g:indent_guides_color_change_percent = 20
  else
    let g:indent_guides_auto_colors  = 0
    augroup Indent
      autocmd!
      autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
      autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234
    augroup END
  endif
  let g:indent_guides_guide_size = &shiftwidth
  let g:indent_guides_start_level = 1
endif
" }}}

if s:plug.is_installed('alpaca_tags') " {{{
  let g:alpaca_tags#config = {
        \   '_' : '--recurse=yes --sort=yes --append=yes',
        \   'ruby' : '--exclude=.bundle,vendor/bundle --languages=+Ruby',
        \   'javascript' : '--exclude=node_modules --exclude=packages/*/.build/'
        \ }
  augroup AlpacaTags
    autocmd!
  augroup END
  command! -nargs=* AutoAlpaca autocmd AlpacaTags <args>
  AutoAlpaca BufWritePost Gemfile AlpacaTagsBundle
  AutoAlpaca BufEnter * AlpacaTagsSet
  AutoAlpaca BufWritePost * AlpacaTagsUpdate
endif
" }}}

if s:plug.is_installed('incsearch-migemo') " {{{
  map ,/ <Plug>(incsearch-migemo-/)
  map ,? <Plug>(incsearch-migemo-?)
  map ,m/ <Plug>(incsearch-migemo-stay)
endif
" }}}

if s:plug.is_installed('vim-operator-flashy') " {{{
  let g:operator#flashy#group = 'MyGlashy'
  if exists('g:nyaovim_version')
    let g:operator#flashy#flash_time = 30
  else
    let g:operator#flashy#flash_time = 300
  endif
  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endif
" }}}

if s:plug.is_installed('vim-signify') " {{{
  nmap <Leader>gj <Plug>(signify-next-hunk)zz
  nmap <Leader>gk <Plug>(signify-prev-hunk)zz
  nmap <Leader>gh <Plug>(signify-toggle-highlight)
  nmap <Leader>gt <Plug>(signify-toggle)
endif
" }}}

if s:plug.is_installed('tern_for_vim') " {{{
  let tern#is_show_argument_hints_enabled = 1
  AutocmdFT javascript setlocal omnifunc=tern#Complete
  Autocmd BufEnter *.js call tern#Enable()
  Autocmd BufEnter * set completeopt-=preview
  nnoremap <buffer><C-]> :<C-u>TernDef<CR>
endif " }}}

if s:plug.is_installed('endwise') " {{{
  inoremap <silent><CR> <CR><Plug>DiscretionaryEnd
endif
" }}}

if s:plug.is_installed('vim-smartinput') "{{{
  imap <expr><CR> <Plug>(physical_key_return)
  call smartinput#define_default_rules()
  call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
  call smartinput#define_rule({
        \   'at'    : '(\%#)',
        \   'char'  : '<Space>',
        \   'input' : '<Space><Space><Left>',
        \   })

  call smartinput#map_to_trigger('i', '<BS>', '<BS>', '<BS>')
  call smartinput#define_rule({
        \   'at'    : '( \%# )',
        \   'char'  : '<BS>',
        \   'input' : '<Del><BS>',
        \   })

  call smartinput#define_rule({
        \   'at'    : '{\%#}',
        \   'char'  : '<Space>',
        \   'input' : '<Space><Space><Left>',
        \   })

  call smartinput#define_rule({
        \   'at'    : '{ \%# }',
        \   'char'  : '<BS>',
        \   'input' : '<Del><BS>',
        \   })

  call smartinput#define_rule({
        \   'at'    : '\[\%#\]',
        \   'char'  : '<Space>',
        \   'input' : '<Space><Space><Left>',
        \   })

  call smartinput#define_rule({
        \   'at'    : '\[ \%# \]',
        \   'char'  : '<BS>',
        \   'input' : '<Del><BS>',
        \   })

  call smartinput#map_to_trigger('i', '<Plug>(physical_key_return)', '<CR>', '<CR>')
  call smartinput#define_rule({
        \   'at'    : '\s\+\%#',
        \   'char'  : '<CR>',
        \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', '')) <Bar> echo 'delete trailing spaces'<CR><CR>",
        \   })

  call smartinput#map_to_trigger('i', '$', '$', '$')
  call smartinput#define_rule({
        \   'at'       : '\%#',
        \   'char'     : '$',
        \   'input'    : '${}<Left>',
        \   'filetype' : ['javascript'],
        \   })

  call smartinput#map_to_trigger('i', '#', '#', '#')
  call smartinput#define_rule({
        \   'at'       : '\%#',
        \   'char'     : '#',
        \   'input'    : '#{}<Left>',
        \   'filetype' : ['ruby'],
        \   'syntax'   : ['Constant', 'Special'],
        \   })

  call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
  call smartinput#define_rule({
        \   'at' : '\%({\|\<do\>\)\s*\%#',
        \   'char' : '|',
        \   'input' : '||<Left>',
        \   'filetype' : ['ruby', 'dachs'],
        \    })

  call smartinput#define_rule({
        \   'at' :       '<\%#>',
        \   'char' :     '<Space>',
        \   'input' :    '<Space><Space><Left>',
        \   'filetype' : ['cpp'],
        \   })
  call smartinput#define_rule({
        \   'at' :       '< \%# >',
        \   'char' :     '<BS>',
        \   'input' :    '<Del><BS>',
        \   'filetype' : ['cpp'],
        \   })

  call smartinput#map_to_trigger('i', '*', '*', '*')
  call smartinput#define_rule({
        \   'at'       : '\/\%#',
        \   'char'     : '*',
        \   'input'    : '**/<Left><Left>',
        \   'filetype' : ['c', 'cpp', 'javascript'],
        \   })
  call smartinput#define_rule({
        \   'at'       : '/\*\%#\*/',
        \   'char'     : '<Space>',
        \   'input'    : '<Space><Space><Left>',
        \   'filetype' : ['c', 'cpp', 'javascript'],
        \   })
  call smartinput#define_rule({
        \   'at'       : '/* \%# */',
        \   'char'     : '<BS>',
        \   'input'    : '<Del><BS>',
        \   'filetype' : ['c', 'cpp', 'javascript'],
        \   })

  call smartinput#define_rule({
        \   'at'       : '\%(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
        \   'char'     : '{',
        \   'input'    : '{};<Left><Left>',
        \   'filetype' : ['cpp'],
        \   })
  call smartinput#define_rule({
        \   'at'       : '\<template\>\s*\%#',
        \   'char'     : '<',
        \   'input'    : '<><Left>',
        \   'filetype' : ['cpp'],
        \   })

  call smartinput#define_rule({
        \   'at'       : '\\\%(\|%\|z\)\%#',
        \   'char'     : '(',
        \   'input'    : '(\)<Left><Left>',
        \   'filetype' : ['vim'],
        \   'syntax'   : ['String'],
        \   })
  call smartinput#define_rule({
        \   'at'       : '\\[%z](\%#\\)',
        \   'char'     : '<BS>',
        \   'input'    : '<Del><Del><BS><BS><BS>',
        \   'filetype' : ['vim'],
        \   'syntax'   : ['String'],
        \   })
  call smartinput#define_rule({
        \   'at'       : '\\(\%#\\)',
        \   'char'     : '<BS>',
        \   'input'    : '<Del><Del><BS><BS>',
        \   'filetype' : ['vim'],
        \   'syntax'   : ['String'],
        \   })

  call smartinput#define_rule({
        \   'at'    : '\%#',
        \   'char'  : '<CR>',
        \   'input' : "<CR><C-r>=endwize#crend()<CR>",
        \   'filetype' : ['vim', 'ruby', 'sh', 'zsh', 'dachs'],
        \   })
  call smartinput#define_rule({
        \   'at'    : '\s\+\%#',
        \   'char'  : '<CR>',
        \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR><C-r>=endwize#crend()<CR>",
        \   'filetype' : ['vim', 'ruby', 'sh', 'zsh', 'dachs'],
        \   })
  call smartinput#define_rule({
        \   'at'    : '^#if\%(\|def\|ndef\)\s\+.*\%#',
        \   'char'  : '<CR>',
        \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR><C-r>=endwize#crend()<CR>",
        \   'filetype' : ['c', 'cpp'],
        \   })

  call smartinput#map_to_trigger('i', '=', '=', '=')
  call smartinput#define_rule(
        \ { 'at'    : '\s\%#'
        \ , 'char'  : '='
        \ , 'input' : '= '
        \ , 'filetype' : ['c', 'cpp']
        \ })

  call smartinput#define_rule(
        \ { 'at'    : '=\s\%#'
        \ , 'char'  : '='
        \ , 'input' : '<BS>= '
        \ , 'filetype' : ['c', 'cpp']
        \ })

  call smartinput#map_to_trigger('i', '~', '~', '~')
  call smartinput#define_rule(
        \ { 'at'    : '=\s\%#'
        \ , 'char'  : '~'
        \ , 'input' : '<BS>~ '
        \ , 'filetype' : ['c', 'cpp']
        \ })

  call smartinput#map_to_trigger('i', '#', '#', '#')
  call smartinput#define_rule(
        \ { 'at'    : '=[~=]\s\%#'
        \ , 'char'  : '#'
        \ , 'input' : '<BS># '
        \ , 'filetype' : ['vim']
        \ })

  call smartinput#define_rule(
        \ { 'at'    : '\%#'
        \ , 'char'  : '|'
        \ , 'input' : '||<Left>'
        \ , 'filetype' : ['help']
        \ })
  call smartinput#define_rule(
        \ { 'at'    : '|\%#|'
        \ , 'char'  : '<BS>'
        \ , 'input' : '<Del><BS>'
        \ , 'filetype' : ['help']
        \ })
  call smartinput#map_to_trigger('i', '*', '*', '*')
  call smartinput#define_rule(
        \ { 'at'    : '\%#'
        \ , 'char'  : '*'
        \ , 'input' : '**<Left>'
        \ , 'filetype' : ['help']
        \ })
  call smartinput#define_rule(
        \ { 'at'    : '\*\%#\*'
        \ , 'char'  : '<BS>'
        \ , 'input' : '<Del><BS>'
        \ , 'filetype' : ['help']
        \ })
endif
" }}}

if s:plug.is_installed('YouCompleteMe') " {{{
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:EclimCompletionMethod = 'omnifunc'
  AutocmdFT javascript nnoremap ,gd :<C-u>YcmCompleter GetDoc<CR>
  AutocmdFT javascript nnoremap ,gt :<C-u>YcmCompleter GoTo<CR>
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " autocmd FileType ruby setlocal omnifunc=
endif
" }}}

if s:plug.is_installed('vim-brightest') " {{{
  let g:brightest#pattern = '\k\+'
  let g:brightest#highlight =  {
        \     'group' : 'MyBrightest'
        \  }
endif
" }}}

if s:plug.is_installed('vim-javacomplete2') " {{{
  AutocmdFT java setlocal omnifunc=javacomplete#Complete
  nmap <F5> <Plug>(JavaComplete-Imports-AddSmart)
  imap <F5> <Plug>(JavaComplete-Imports-AddSmart)
  nmap <F6> <Plug>(JavaComplete-Imports-Add)
  imap <F6> <Plug>(JavaComplete-Imports-Add)
  nmap <F7> <Plug>(JavaComplete-Imports-AddMissing)
  imap <F7> <Plug>(JavaComplete-Imports-AddMissing)
  nmap <F8> <Plug>(JavaComplete-Imports-RemoveUnused)
  imap <F8> <Plug>(JavaComplete-Imports-RemoveUnused)
endif
" }}}

if s:plug.is_installed('ultisnips')  " {{{
  let g:UltiSnipsExpandTrigger = '<C-k>'
  let g:UltiSnipsJumpForwardTrigger = '<C-n>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-b>'
  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"
endif
" }}}

if s:plug.is_installed('vim-operator-replace') "{{{
  nmap R <Plug>(operator-replace)
  xmap R <Plug>(operator-replace)
endif
"}}}

if s:plug.is_installed('emmet-vim') "{{{
  let g:user_emmet_settings = {
        \  'javascript' : {
        \      'extends' : 'jsx',
        \  },
        \}
endif
" }}}

if s:plug.is_installed('vim-jsx-utils') "{{{
  nnoremap ,ja :call JSXEncloseReturn()<CR>
  nnoremap ,ji :call JSXEachAttributeInLine()<CR>
  nnoremap ,je :call JSXExtractPartialPrompt()<CR>
  nnoremap ,jc :call JSXChangeTagPrompt()<CR>
  nnoremap ,js :call JSXSelectTag()<CR>
endif
command! React :map ,j
" }}}

if s:plug.is_installed('Command-T') "{{{
  let s:commandTHeight=18
  let g:CommandTMaxHeight=s:commandTHeight
  let g:CommandTMinHeight=s:commandTHeight
  let g:CommandTClearMap=['<C-u>', '<C-w>']
  let g:CommandTCancelMap=['<C-[>', '<C-c>', '<Esc>']
  let g:CommandTMaxDepth=20
  nnoremap ,t :CommandTFlush<CR>\|:CommandT<Space><UP>
  nnoremap <silent> ,l :CommandTFlush<CR>\|:CommandT<CR>
  nnoremap <silent> ,b :CommandTFlush<CR>\|:CommandTBuffer<CR>
endif
" }}}

if s:plug.is_installed('fzf') "{{{
  nnoremap <silent> <C-@> :<C-u>FZF<CR>
  if s:plug.is_installed('fzf.vim')
    " my mapping
    nnoremap 　a :<C-u>Ag <C-r><C-w><CR>
    nnoremap 　b :<C-u>Buffers<CR>
    nnoremap 　c :<C-u>BCommits<CR>
    nnoremap 　g :<C-u>GFiles<CR>
    nnoremap 　s :<C-u>GFiles?<CR>
    nnoremap 　t :<C-u>Filetypes<CR>
    nnoremap 　w :<C-u>Windows<CR>
  endif
  nnoremap 　f :<C-u>FZF<CR>
endif
"}}}

if s:plug.is_installed('vim-signature') "{{{
  let g:SignatureMarkTextHLDynamic = 1
  nnoremap m<C-h> m<BS>
  nnoremap mn ]`
  nnoremap mp [`
endif
"}}}
" }}}

" matchit {{{
runtime macros/matchit.vim
augroup matchit
  autocmd!
  autocmd FileType ruby
  \ let b:match_words =
  \ '\<\(module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
augroup END
" }}}

" }}}

" set {{{
" common {{{
set autoread                  " vim外で編集された時の自動み込み
set autowrite                 " bufferが切り替わるときの自動保存
set backspace=indent,eol,start
if !has('nvim')
  set clipboard=unnamed,autoselect
endif
set cmdheight=1
set cmdwinheight=5            " Command-line windowの行数
set completeopt=menuone,longest,preview
set cscopetag
" set clipboard=exclude:.*
if has('gui_running')
  set cursorline              " これをsetすると描画がだいぶ遅くなる
  " set cursorcolumn
endif
set display=lastline          " 画面を超える長い１行も表示
set fillchars  =vert:\|,fold:\-
set history    =100           " コマンドラインのヒストリ
set laststatus =2             " ステータス行を常に表示
set lazyredraw                " マクロなどの途中部分の動作を描画しない
set list
set listchars     =eol:$,tab:>-
set linespace     =0
set maxmem        =500000     " 1バッファ 500MB(about)
set maxmemtot     =1000000    " vimのすべてのバッファで1000MB(about)
set maxmempattern =500000     " パターンマッチにメモリ最大500MB(about)
set matchpairs+=<:>           " 対応カッコのマッチを追加
set matchtime=1               " 対応するカッコを表示する時間
set modeline                  " vim:set tx=4 sw=4..みたいな設定を有効
set modelines=2               " 上の設定をファイル先頭2行にあるかないか調べる
set nrformats=alpha,hex       " アルファベットと16シンスうをC-a C-xで増減可能に
set noequalalways             " vs, spの時のwindow幅
" set number
set pumheight=5               " 補完ウィンドウの行数
set pastetoggle=<F11>
" set relativenumber            " 相対行番号
set report=1                  " 変更された行数の報告がでる最小値
set ruler
" set rulerformat=%15(%c%V\ %p%%%)
set scrolloff=10              " 常に10行表示
set showcmd                   " ステータスラインに常にコメンド表示
set showmatch                 " 閉じ括弧を入力時，開き括弧に一瞬ジャンプ
set splitbelow                " 横分割時、新しいウィンドウは下
set splitright                " 縦分割時、新しいウィンドウは右
set synmaxcol=140             " 長過ぎる文字はsyntax off
set textwidth=0
" set nocompatible              " VI互換を無効化 deplecated
if ! IsWindows()
  set path =.,/usr/local/include,/usr/include
  set path+=,/usr/include/c++/4.2.1
endif
if exists('&macatsui')
  set nomacatsui
endif
if has("path_extra")
  set tags+=tags;
  set tags+=.svn/tags
  set tags+=.git/tags
endif
if has('nvim')
  set novisualbell
else
  set ttyfast                   " スクロールが滑らかに
  set t_Co     =256
  set ttyscroll=20000
  set vb t_vb  =                " no beep no flash
endif
set virtualedit=block
set whichwrap  =b,s,h,l,<,>,[,] " hとlが非推奨
" }}}
" formatoptions {{{
let &formatoptions = 'lmj'
" }}}
" mouse {{{
set mouse&
set mouse-=a
" }}}
" spelling {{{
set spelllang=en_us
" ignore japanese
set spelllang+=cjk
" enable spell check
" set spell
" }}}
" swap {{{
if !isdirectory(expand('~/.vim/_swap'))
  call mkdir($HOME.'/.vim/_swap', 'p')
endif
set directory=~/.vim/_swap
set backupdir=~/.vim/_swap
set swapfile
set backup
" }}}
" undofile {{{
if !isdirectory(expand('~/.vim/_undo'))
  call mkdir($HOME.'/.vim/_undo', 'p')
endif
set undodir   =~/.vim/_undo
set undofile
set undolevels=200
" }}}
" colorcolumn {{{
" See: http://mattn.kaoriya.net/software/vim/20150209151638.htm
if (exists('+colorcolumn'))
  set colorcolumn=80,100
endif
" }}}
" search {{{
set hlsearch    " ハイライト検索
set ignorecase  " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set incsearch   " 検索ワードの最初の文字を入力した時点から検索開始
set wrapscan    " 検索をファイルの先頭へループ
set smartcase   " 検索文字列に大文字が含まれている場合は区別して検索する
" }}}
" folding {{{
set foldenable         " 折りたたみon
set foldmethod =marker " 折りたたみ方法:マーカ
set foldcolumn =0      " 折りたたみの補助線幅
set foldlevel  =0      " foldをどこまで一気に開くか
if (!exists('FoldCCText'))
  let g:foldCCtext_maxchars = 78
  set foldtext=FoldCCtext()
endif
" }}}
" indent {{{
set expandtab       "タブの代わりに空白文字を挿入する
set shiftwidth  =2  "タブ幅の設定
set tabstop     =2
set softtabstop =2
set autoindent
set smartindent
set cindent
set smarttab
" }}}
" vim-grep {{{
" See: https://github.com/iyuuya/bksd/blob/master/nvim/.config/nvim/rc/edit.vim#L83-L91
if executable('ag')
  set grepprg=ag\ --nogroup\ -iS
  set grepformat=%f:%l:%m
elseif executable('grep')
  set grepprg=grep\ -Hnd\ skip\ -r
  set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
else
  set grepprg=internal
endif
" }}}
" tab-editer {{{
set showtabline=2 " 常にタブ
"}}}
" wildmenu {{{
try
  set wildmode=popup
  set wildmenu
  set clpumheight=20
  augroup Clpum
    autocmd!
    autocmd ColorScheme * call s:reset_clpum_highlight()
  augroup END
  function! s:reset_clpum_highlight() abort
    highlight clear ClPmenu
    highlight clear ClPmenuSbar
    highlight clear ClPmenuSel
    highlight clear ClPmenuThumb
    highlight link ClPmenu Pmenu
    highlight link ClPmenuSbar PmenuSbar
    highlight link ClPmenuSel PmenuSel
    highlight link ClPmenuThumb PmenuThumb
  endfunction
catch
  set wildmenu " cmdline補完
  set wildmode =longest:full,full
endtry
set wildignore =*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.sql
" }}}
" encode {{{
set fileformats   =unix,dos,mac  " 改行コードの自動認識
set ambiwidth     =double        " ２バイト特殊文字の幅調整
" }}}
" fast scroll {{{
"" Fast vertical scroll
" source: http://qiita.com/kefir_/items/c725731d33de4d8fb096
" Use vsplit mode
if has('vim_starting') && !has('gui_running') && has('vertsplit') && !has('nvim')
  function! g:EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6h\e[?69h" ], "/dev/tty", "a")
  endfunction
  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>
  " new vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R g:EnableVsplitMode()
  set t_F9=^[[3;3R
  map <expr> <t_F9> g:EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif
" }}}
" etc {{{
let g:rubycomplete_rails = 1
let g:user_javascript_libs = 'underscore,react,chai,jasmine,ramda,flux'
let g:vim_json_syntax_conceal = 0
" }}}
" " twty {{{
" function! s:append(line)
"   let wn = bufwinnr("tweets")
"   if wn == -1
"     return 0
"   endif
"   exe wn 'wincmd w'
"   try
"     let o = jsondecode(a:line)
"     let ts = type(o) == 3 ? o : [o]
"     for t in ts
"       1put!=t.user.screen_name . ': ' . t.text
"     endfor
"   finally
"     wincmd p
"   endtry
" endfunction
"
" if bufwinnr("tweets") == -1
"   10new tweets
"   setlocal buftype=nofile bufhidden=hide noswapfile
"   wincmd p
" endif
"
" function! TweetsCallback(handle, msg)
"   for line in split(a:msg, "\n")
"     call s:append(line)
"   endfor
"   redraw
" endfunction
"
" if exists('s:handle')
"   call disconnect(s:handle)
" endif
" let s:handle = connect("127.0.0.1:7777", "raw", "TweetsCallback")
" }}}
" }}}

" autocmd {{{
" filetype {{{

" indent {{{

function! s:set_tab_width(width, is_expand)
  let &l:tabstop = a:width
  let &l:shiftwidth = a:width
  let &l:softtabstop = a:width
  if a:is_expand == s:true
    setlocal expandtab
  else
    setlocal noexpandtab
  end
endfunction

command! -bar -nargs=1 TabIndent
      \ call s:set_tab_width(<args>, s:false)

command! -bar -nargs=1 SpaceIndent
      \ call s:set_tab_width(<args>, s:true)
" }}}

" set filetype {{{
function! s:set_filetype(...)
  execute 'Autocmd BufNewFile,BufRead ' . '*'.a:1 . ' set filetype=' . a:2
endfunction
command! -nargs=* SetFileType call s:set_filetype(<f-args>)

let s:MyFileTypes = [
      \   {'file' : '.md',       'type' : 'markdown'},
      \   {'file' : '.slim',     'type' : 'slim'},
      \   {'file' : '.less',     'type' : 'less'},
      \   {'file' : '.coffee',   'type' : 'coffee'},
      \   {'file' : '.scss',     'type' : 'scss'},
      \   {'file' : '.sass',     'type' : 'sass'},
      \   {'file' : '.cjsx',     'type' : 'coffee'},
      \   {'file' : '.exs',      'type' : 'elixir'},
      \   {'file' : '.ex',       'type' : 'elixir'},
      \   {'file' : '.toml',     'type' : 'toml'},
      \   {'file' : '_spec.rb',  'type' : 'rspec'},
      \   {'file' : '.jsx',      'type' : 'javascript.jsx'},
      \   {'file' : '.es6',      'type' : 'javascript'},
      \   {'file' : '.react.js', 'type' : 'javascript.jsx'},
      \   {'file' : '.fish',     'type' : 'fish'},
      \   {'file' : '.babelrc',  'type' : 'json'},
      \   {'file' : '.eslintrc', 'type' : 'yaml'},
      \ ]

for s:e in s:MyFileTypes
  execute 'SetFileType ' . s:e['file'] . ' ' . s:e['type']
endfor
" }}}

" tab width {{{
function! s:set_indent(...)
  execute 'AutocmdFT ' . a:1 'call s:set_tab_width(' . a:2 . ',' . a:3 . ')'
endfunction
command! -nargs=* IndentFT call s:set_indent(<f-args>)

IndentFT python   4 s:false
IndentFT java     4 s:true
IndentFT php      4 s:false
IndentFT make     4 s:false
IndentFT yaml     2 s:true
IndentFT conf     4 s:false
IndentFT coffee   2 s:true
IndentFT slim     2 s:true
IndentFT fish     2 s:true
IndentFT toml     4 s:true
IndentFT plantuml 2 s:true
" }}}

" javascript {{{
function! s:callback(job_id, data, event_type)
  echo 'Fixed'
  checktime
endfunction

function! s:on_error(job_id, data, event_type)
  echo a:data
endfunction

function! s:on_FileType_javascript() "{{{
  Abbr i == ===
  Abbr i != !==
  call s:set_tab_width(2, s:true)
  if executable('eslint_d') && !has('nvim')
    call vimproc#system_bg('eslint_d restart')
  endif
  if s:plug.is_installed('tern_for_vim')
    call tern#Enable()
  endif
endfunction
"}}}

function! s:auto_fix_by_eslint()
  if executable('eslint_d') && !has('nvim')
    let argv = ['eslint_d', '--format', 'compact', '--fix', expand('%')]
    let job = async#job#start(argv, {
    \ 'on_stderr': function('s:on_error'),
    \ 'on_exit': function('s:callback'),
    \})
  else
    echo 'Please execute next command `$ npm install -g eslint_d`'
  endif
endfunction

augroup javascript
  autocmd!
  autocmd BufWrite *.js call s:auto_fix_by_eslint()
  autocmd FileType javascript call s:on_FileType_javascript()
augroup END
" }}}

" ruby"{{{
function! s:on_FileType_ruby() "{{{
  call s:set_tab_width(2, s:true)
endfunction
"}}}

function! s:auto_fix_by_rubocop()
  if executable('rubocop')
    let argv = ['rubocop', '-a', expand('%')]
    let job = async#job#start(argv, {
    \ 'on_stderr': function('s:on_error'),
    \ 'on_exit': function('s:callback'),
    \})
  endif
endfunction

augroup ruby
  autocmd!
  autocmd BufWrite *.rb call s:auto_fix_by_rubocop()
  autocmd FileType ruby call s:on_FileType_ruby()
augroup END
"}}}

" }}}

" QuickFix {{{
Autocmd QuickFixCmdPost make,*grep* cwindow
" }}}

" etc "{{{
Autocmd VimEnter COMMIT_EDITMSG if getline(1) == ''
      \ | execute 1
      \ | startinsert
      \ | endif
Autocmd VimEnter COMMIT_EDITMSG setlocal spell
AutocmdFT html     inoremap <silent> <buffer> </ </<C-x><C-o>
AutocmdFT sass,scss,css setlocal iskeyword+=-
" tails space highlight
" Autocmd BufNewFile,BufRead,VimEnter,WinEnter,ColorScheme
"       \ * highlight TailSpace term=underline guibg=#FF0000 ctermbg=9
" Autocmd BufNewFile,BufRead,VimEnter,WinEnter
"       \ * syntax match TailSpace containedin=ALL /\s\+$/
Autocmd BufNewFile,BufRead,VimEnter,WinEnter,ColorScheme
      \ * highlight ZenkakuSpaces term=underline guibg=Blue ctermbg=Blue
Autocmd BufNewFile,BufRead,VimEnter,WinEnter
      \ * syntax match ZenkakuSpaces containedin=ALL /　/
Autocmd InsertLeave * set nopaste
Autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$")
      \ | exe "normal g`\"" | endif
function! s:enable_sound()
  " simplayer を使えば windows でも遊べるけどまあいらんやろ
  " See: https://github.com/MaxMEllon/simplayer
  if IsMac()
    Autocmd BufWrite
        \ * call vimproc#system_bg("afplay -v 0.5 " . expand("~/.vim/gun.mp3"))
    Autocmd CursorMoved
        \ * call vimproc#system_bg("afplay -v 0.5 " . expand("~/.vim/shyuin.mp3"))
    Autocmd TextChangedI,TextChanged
        \ * call vimproc#system_bg("afplay -v 0.5 " . expand("~/.vim/ishi.mp3"))
  endif
endfunction
command! SoundEnable call s:enable_sound()
" }}}
" }}}

" function {{{
function! s:copy_mode_toggle() " {{{
  setlocal nolist!
  if exists(":IndentGuidesToggle")
    IndentGuidesToggle
  endif
  if exists("IndentLinesToggle")
    IndentLinesToggle
  endif
endfunction
command! MyCopyModeToggle :call s:copy_mode_toggle()
nnoremap <silent> <C-c> :<C-u>MyCopyModeToggle<CR>
" }}}
" help {{{
if !IsWindows()
  function! s:load_help()
    if isdirectory(expand('~/.vim/help/vimdoc-ja/doc'))
      helptags ~/.vim/help/vimdoc-ja/doc
      set runtimepath+=~/.vim/help/vimdoc-ja
      set helplang=ja
    endif
  endfunction
  command! MyLoadHelp :call s:load_help()
  AutocmdFT help MyLoadHelp
  nnoremap <silent> ,h :<C-u>MyLoadHelp<CR> :<C-u>help <C-r><C-w><CR>
else
  nnoremap <silent> ,h :<C-u>help <C-r><C-w><CR>
endif
"}}}
function! s:remove_fancy_characters() "{{{
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  let typo["，"] = ', '
  let typo["．"] = '. '
  execute ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
  unlet typo
endfunction

command! RemoveFancyCharacters call s:remove_fancy_characters()
"}}}
function! s:get_syn_id(transparent)  " {{{
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
" }}}
function! s:codic_complete() " {{{
  "See: https://gist.github.com/sgur/4e1cc8e93798b8fe9621
  let line = getline('.')
  let start = match(line, '\k\+$')
  let cand = s:codic_candidates(line[start :])
  call complete(start +1, cand)
  return ''
endfunction
function! s:codic_candidates(arglead)
  let cand = codic#search(a:arglead, 30)
  " error
  if type(cand) == type(0)
    return []
  endif
  " english -> english terms
  if a:arglead =~# '^\w\+$'
    return map(cand, '{"word": v:val["label"], "menu": join(map(copy(v:val["values"]), "v:val.word"), ",")}')
  endif
  " japanese -> english terms
  return s:reverse_candidates(cand)
endfunction
function! s:reverse_candidates(cand)
  let _ = []
  for s:c in a:cand
    for s:v in s:c.values
      call add(_, {"word": s:v.word, "menu": !empty(s:v.desc) ? s:v.desc : s:c.label })
    endfor
  endfor
  return _
endfunction
" }}}
" }}}

" command {{{
" vimgrep alias {{{
command! -bar -nargs=* G vimgrep <args> %
command! -bar -nargs=* GG vimgrep <args> ./*
" }}}
command! Date  :call setline('.', getline('.') . strftime('○ %Y.%m.%d (%a) %H:%M'))
command! JSONFormat %!python -m json.tool
if executable('xo')
  command! XoFix :call  vimproc#system_bg("xo --fix " . expand("%"))
endif
if executable('shiba')
  command! Shiba  :! shiba % &>/dev/null 2>&1 &
endif
if executable('eslint')
  command! EsFix  :call vimproc#system_bg("eslint_d --fix " . expand("%"))
endif
if executable('google')
  command! Google :call vimproc#system_bg("google " . expand("<cword>"))
endif
if executable('github')
  command! Github :call vimproc#system_bg("github maxmellon")
endif

" cd-fzf "{{{
if executable('fzf-tmux') && executable('fzf') && !has('gui_running')
  function! s:get_current_path()
    redir! => s:current_path
    silent pwd
    redir END
    return s:current_path
  endfunction

  function! s:select_directory_tmux_fzf()
    let s:current_path = s:get_current_path()
    try
      let directory = system('find * -type d | fzf-tmux')
    catch
    endtry
    if empty(directory)
      let directory = '.'
    endif
    let directory = substitute(directory, ' ', '\ ', 'g')
    execute 'cd ' . directory
    unsilent pwd
    unlet directory
  endfunction

  command! Cd :call s:select_directory_tmux_fzf()
  nnoremap <silent> 　d :<C-u>Cd<CR>
endif
"}}}

" cd-gitroot " {{{

if executable('git')
  function! s:cd_gitroot() abort
    if(system('git rev-parse --is-inside-work-tree') ==# "true\n")
      return system('git rev-parse --show-cdup')
    else
      echoerr 'current directory is outside git working tree'
    endif
  endfunction
  command! Cdu :call s:cd_gitroot()
endif
" }}}

" }}}

" mapping {{{
" move {{{
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
nnoremap <C-j> }
nnoremap <C-k> {
noremap <Esc>(  [(
noremap <Esc>)  ])
noremap <Esc>{  [{
noremap <Esc>}  ]}

" See: http://qiita.com/itmammoth/items/312246b4b7688875d023
nnoremap <C-n> "zdd"zp
vnoremap <C-p> "zx<Up>"zP`[V`]
vnoremap <C-n> "zx"zp`[V`]
nnoremap <C-p> "zdd<Up>"zP
"}}}
" cursol key {{{
noremap! OA <Up>
noremap! OB <Down>
noremap! OC <Right>
noremap! OD <Left>
noremap! A <Up>
noremap! B <Down>
noremap! C <Right>
noremap! D <Left>

nnoremap <Right> <C-w>>
nnoremap <Down> <C-w>-
nnoremap <Left> <C-w><
nnoremap <Up> <C-w>+
"}}}
" tab {{{
nmap g <Nop>
nmap g g
nnoremap ge :<C-u>tabedit<Space>.<CR>
nnoremap <silent> gc :<C-u>tablast <bar> tabnew<CR>
nnoremap <silent> gn :<C-u>tabnew<CR>
nnoremap <silent> gx :<C-u>tabclose<CR>
nnoremap <silent> gn :<C-u>tabnext<CR>
nnoremap <silent> <F3>   :<C-u>tabnext<CR>
nnoremap <silent> gp :<C-u>tabprevious<CR>
nnoremap <silent> <F2>   :<C-u>tabprevious<CR>
" tab jump
for s:n in range(1, 9)
  execute 'nnoremap <silent> g' . s:n ':<C-u>tabnext' . s:n . '<CR>'
endfor
"}}}
" Disable key {{{
nnoremap M m
nnoremap Q q
nnoremap K  <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
"}}}
" change normal mode {{{
" Neojj
" inoremap <expr> j getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>`^" : 'j'
" cnoremap <expr> j getcmdline()[getcmdpos() - 2] ==# 'j' ? "\<BS>\<ESC>`^" : 'j'
inoremap jj <Esc>`^
cnoremap jj <Esc>`^
inoremap <silent> <Esc>  <Esc>`^
inoremap <silent> <C-[>  <Esc>`^
inoremap <C-c> <Esc>`^
inoremap <C-j> j
" }}}
" Paste next line. {{{
nnoremap <silent> gp o<ESC>p^
nnoremap <silent> gP O<ESC>P^
xnoremap <silent> gp o<ESC>p^
xnoremap <silent> gP O<ESC>P^
" }}}
" change buffer {{{
" nnoremap <silent> bp :<C-u>bprevious<CR>
" nnoremap <silent> bn :<C-u>bnext<CR>
for s:k in range(1, 9)
  execute 'nnoremap <Leader>' . s:k ':<C-u>e #' . s:k . '<CR>'
endfor
" }}}
" indent {{{
xnoremap <TAB>  >gv
xnoremap <S-TAB>  <gv
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv
" }}}
" insert {{{

" emacs-like
inoremap <C-Tab> <C-v><Tab>
inoremap <S-Tab> <C-v><Tab>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k> <ESC>`^Da
inoremap <C-p> <UP>
inoremap <C-n> <Down>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-m> <CR>

" insert paste
inoremap <C-v> <C-o>:set paste<CR><C-r>*<C-o>:set nopaste<CR>

function! s:indent_braces()
  let s:nowletter = getline(".")[col(".")-1]
  let s:beforeletter = getline(".")[col(".")-2]
  if s:nowletter == "}" && s:beforeletter == "{" || s:nowletter == "]" && s:beforeletter == "["
    let s:res = "\<C-]>\n\t\n\<UP>\<RIGHT>\<ESC>\A"
  elseif s:beforeletter == ' '
    let s:res = "\<C-]>\n\<ESC>\:RemoveWhiteSpace\n\ii\<ESC>==xa"
  else
    let s:res = "\<C-]>\n"
  endif
  return s:res
endfunction
inoremap <silent> <expr> <CR> <SID>indent_braces()
inoremap , ,<Space>
" }}}
" home and end {{{
" See: https://github.com/martin-svk/dot-files/blob/682087a4ff45870f55bd966632156be07a2ff1c4/vim/vimrc#L343-347
nnoremap <expr> 0
      \ col('.') ==# 1 ? '^' : '0'
nnoremap <C-h> ^
" }}}
" text obj {{{
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
" }}}
" split window {{{
" See: https://github.com/supermomonga/dot-vimrc/blob/master/.vimrc#L462-466
" _ : Quick horizontal splits
nnoremap _ :<C-u>sp .<CR>
" | : Quick vertical splits
nnoremap <bar> :<C-u>vsp .<CR>
" }}}
" increment {{{
noremap + <C-a>
noremap - <C-x>
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
" }}}
" prefix [,] {{{
" remove white space of end line
function! s:RemoveWhiteSpace()
  let l:save_cursor = getpos(".")
  silent! execute ':%s/\s\+$//e'
  call setpos('.', l:save_cursor)
endfunction
command! -range=% RemoveWhiteSpace call <SID>RemoveWhiteSpace()
nnoremap <silent> ,x :RemoveWhiteSpace<CR>
vnoremap <silent> ,x :RemoveWhiteSpace<CR>
" remove double width white space
nnoremap <silent> ,z :<C-u>%s/　/  /g<CR>
vnoremap <silent> ,z :<C-u>%s/　/  /g<CR>

" toggle paste mode
nnoremap <silent> ,p :<C-u>set paste!<CR>

nnoremap <silent> ,g :<C-u>Google<CR>
" }}}
" cmd window {{{
nnoremap ;; q:
nnoremap q; q:
vnoremap q; q:
nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;
" }}}
" history {{{
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" cnoremap <Tab> <C-d>
nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:
nnoremap <SID>(command-line-norange) q:<C-u>
" }}}
" cmdwindow mapping function {{{
nnoremap / q/
nnoremap ? q?

augroup CmdWindow
  autocmd!
  autocmd CmdwinEnter * call s:init_cmdwin()
augroup END
function! s:init_cmdwin()
  " setlocal nolist! number! relativenumber!
  nnoremap <silent><buffer>q :<C-u>q<CR>
  nnoremap <silent><buffer><CR> A<CR>
  inoremap <buffer><silent> <Tab> <C-d>
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  startinsert!
endfunction

" emacs like
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <BS>
cnoremap <C-d> <Del>
cnoremap <C-k> <End><C-u>

" :unite -> :Unite
cnoremap <CR> <C-]><CR>
" }}}
" clear screan {{{
nnoremap <silent><ESC><ESC> :<C-u>nohlsearch<CR><ESC>
" <C-l> -> <ESC><ESC>
" <C-l> -> <C-i>
" <C-i> -> system key map
nnoremap <silent><C-l> <C-i>
" }}}
" VS like " {{{
nnoremap <f4> :<C-u>cnext<CR>
nnoremap <s-f4> :<C-u>cprevious<CR>
" }}}
" etc {{{
" 即座にvimgrep
nnoremap <C-g> :<C-u>G<Space>
" 行末ヤンク
nnoremap Y y$
nnoremap <C-Tab> <C-w><C-w>
nnoremap <S-tab> :<C-u>tabnext<CR>
nnoremap <C-S-Tab> :<C-u>bnext<CR>
" ls
nnoremap <silent> <Leader>b :ls<CR>:b
nnoremap <F1> <Nop>
" }}}
" }}}

" abbrev {{{
let s:Abbrs = [
      \ {'type': 'i', 'before' : 'tihs',      'after' : 'this'},
      \ {'type': 'i', 'before' : 'edn',       'after' : 'end'},
      \ {'type': 'i', 'before' : 'REact',     'after' : 'React'},
      \ {'type': 'i', 'before' : '):',        'after' : ');'},
      \ {'type': 'i', 'before' : '= =',       'after' : '=='},
      \ {'type': 'i', 'before' : 'initalize', 'after' : 'initialize'},
      \ {'type': 'c', 'before' : 'fzf',       'after' : 'FZF'},
      \ {'type': 'c', 'before' : 'cdu',       'after' : 'Cdu'},
      \ {'type': 'c', 'before' : 'unite',     'after' : 'Unite'},
      \ {'type': 'c', 'before' : 'ag',        'after' : 'Ags'},
      \ {'type': 'c', 'before' : 'ggrep',     'after' : 'Ggrep'},
      \ {'type': 'c', 'before' : 'gist',      'after' : 'Gist'},
      \ ]
for s:e in s:Abbrs
  execute 'Abbr ' . s:e['type'] . ' ' . s:e['before'] ' ' . s:e['after']
endfor
" }}}

" statusline {{{
let g:hi_insert = 'highlight StatusLine ctermfg=red ctermbg=yellow cterm=NONE guifg=red guibg=yellow'
let g:hi_normal = 'highlight StatusLine ctermfg=white ctermbg=blue cterm=NONE guifg=white guibg=blue'
if has('syntax') && !has('gui_running')
  augroup InsertHook
    autocmd!
    autocmd VimEnter * call s:StatusLine('Init')
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''

function! s:StatusLine(mode)
  if has('gui_running') | return | endif
  if a:mode == 'Enter'
    silent exec g:hi_insert
  else
    silent exec g:hi_normal
  endif
endfunction

function! s:GetHighlight(hi)
  redir => s:hl
  exec 'highlight ' . a:hi
  redir END
  let s:hl = substitute(s:hl, '[\r\n]', '', 'g')
  let s:hl = substitute(s:hl, 'xxx', '', '')
  return s:hl
endfunction

" See: http://qiita.com/kotashiratsuka/items/dcd1f4231385dc9c78e7
" ステータスラインにコマンドを表示
set showcmd
" ステータスラインを常に表示
set laststatus=2
" ファイルナンバー表示
set statusline=[%n]
" ファイル名表示
set statusline+=%<%t:
" git branch
if s:plug.is_installed('fugitive')
  set statusline+=%{fugitive#statusline()}
endif
" 構文チェック
if s:plug.is_installed('syntastic')
  set statusline+=%{SyntasticStatuslineFlag()}
endif
" 変更のチェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" ここからツールバー右側
set statusline+=%=
" ファイルタイプ表示
" 現在行が全体行の何%目か表示
set statusline+=%15(%c%V\ %p%%%)
" filetype
set statusline+=%y
" 文字バイト数/カラム番号
" set statusline+=[ASCII=%B]
" set statusline+=%{system('battery')}
" 現在文字列/全体列表示
" set statusline+=[C=%c/%{col('$')-1}]
" 現在文字行/全体行表示
set statusline+=[L=%l/%L]
" }}}

" color {{{
try
  if has('gui_running')
    set background=dark
    colorscheme gruvbox
  else
    colorscheme molokai
    Autocmd VimEnter * highlight FoldColumn ctermfg=67  ctermbg=16
    Autocmd VimEnter * highlight Folded     ctermfg=67  ctermbg=16
  endif
catch
  colorscheme pablo
endtry
Autocmd VimEnter * highlight MyGlashy ctermbg=48 term=bold,reverse guibg=#00FF00
Autocmd VimEnter * highlight MyBrightest ctermfg=11 ctermbg=18 cterm=bold gui=underline
Autocmd VimEnter * highlight clear CursorLine
Autocmd VimEnter * highlight CursorLine ctermbg=17 cterm=bold
"}}}

" END {{{
syntax on
filetype indent on
set secure " vimrcの最後に記述 vimhelpより
" }}}
