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
"                       |88Z'    "DNNNNNNN"
"                       '"'        "MMMM"
"                                    ""

" start up {{{
if !1 | finish | endif
" Startup time. {{{
" See: https://gist.github.com/thinca/1518874
if has('vim_starting') && has('reltime')
  let s:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter *
          \   echomsg 'startuptime: ' . reltimestr(reltime(s:startuptime))
          \ | unlet s:startuptime
  augroup END
endif
"}}}
" autocmd {{{
" See: https://github.com/rhysd/dotfiles/blob/master/vimrc#23-27
augroup MyVimrc
  autocmd!
augroup END
command! -nargs=* Autocmd autocmd MyVimrc <args>
command! -nargs=* AutocmdFT autocmd MyVimrc FileType <args>
" }}}
" system type {{{
let s:is_windows = has('win16') || has('win32') || has('win64')
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
function! HasPlugin(name) "{{{
    let nosuffix = a:name =~? '\.vim$' ? a:name[:-5] : a:name
    let suffix   = a:name =~? '\.vim$' ? a:name      : a:name . '.vim'
    return &rtp =~# '\c\<' . nosuffix . '\>'
    \   || globpath(&rtp, suffix, 1) != ''
    \   || globpath(&rtp, nosuffix, 1) != ''
    \   || globpath(&rtp, 'autoload/' . suffix, 1) != ''
    \   || globpath(&rtp, 'autoload/' . tolower(suffix), 1) != ''
endfunction
" }}}
"}}}
" encoding {{{
" See:
" https://raw.githubusercontent.com/Shougo/shougo-s-github/master/vim/rc/encoding.rc.vim
"
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
  " For Kaoriya only.
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
" load Plugin {{{
call plug#begin('~/.vim/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'AtsushiM/sass-compile.vim', {'for' : 'sass'}
Plug 'KazuakiM/vim-qfstatusline'
Plug 'LeafCage/foldCC.vim'
Plug 'LeafCage/yankround.vim'
Plug 'MaxMEllon/molokai'
Plug 'MaxMEllon/unite-rails-fat', {'on' : 'Unite'}
Plug 'MaxMEllon/vim-tmng', {'for' : ['txt', 'tmng']}
Plug 'Shougo/context_filetype.vim'
if has('lua')
  Plug 'Shougo/neocomplete.vim'
elseif has('nvim')
  Plug 'Shougo/deoplete.nvim'
else
  Plug 'Shougo/neocomplcache.vim'
endif
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/unite-build', {'on' : 'Unite'}
Plug 'Shougo/unite-outline', {'on' : 'Unite'}
Plug 'Shougo/unite.vim', {'on' : 'Unite'}
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Shougo/vimshell.vim'
Plug 'The-NERD-tree'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'alpaca-tc/neorspec.vim', {'on' : 'RSpec'}
Plug 'altercation/vim-colors-solarized'
Plug 'basyura/unite-rails', {'on' : 'Unite', 'for' : 'ruby'}
Plug 'cespare/vim-toml', {'for' : 'toml'}
Plug 'chase/vim-ansible-yaml'
Plug 'cohama/lexima.vim'
Plug 'dannyob/quickfixstatus'
Plug 'easymotion/vim-easymotion'
Plug 'glts/vim-textobj-comment'
Plug 'groenewege/vim-less', {'for' : 'less'}
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-migemo.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align', {'on' : 'EasyAlign'}
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kchmck/vim-coffee-script', {'for' : ['coffee', 'slim']}
Plug 'koron/codic-vim', {'on' : 'Codic'}
Plug 'majutsushi/tagbar', {'on' : 'TagbarToggle' }
Plug 'matchit.zip'
Plug 'mattn/benchvimrc-vim', {'on' : 'BenchVimrc'}
Plug 'mattn/emoji-vim', {'on' : 'Emoji'}
Plug 'mattn/gist-vim', {'on' : 'Gist'}
Plug 'mattn/jscomplete-vim', {'for' : ['js', 'coffee']}
Plug 'mattn/vim-maketable', {'on' : 'MakeTable'}
Plug 'mattn/vim-textobj-url'
Plug 'mattn/webapi-vim'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'mtscout6/vim-cjsx', {'for' : 'coffee'}
Plug 'osyo-manga/shabadou.vim'
Plug 'osyo-manga/unite-filetype', {'on' : 'Unite'}
Plug 'osyo-manga/unite-quickfix', {'on' : 'Unite'}
Plug 'osyo-manga/vim-anzu'
Plug 'osyo-manga/vim-over'
Plug 'osyo-manga/vim-reunions'
Plug 'osyo-manga/vim-textobj-multiblock'
Plug 'osyo-manga/vim-watchdogs'
Plug 'othree/javascript-libraries-syntax.vim', {'for' : ['coffee', 'js']}
Plug 'rhysd/clever-f.vim'
Plug 'rhysd/vim-textobj-ruby'
Plug 'soramugi/auto-ctags.vim'
Plug 'supermomonga/vimshell-pure.vim'
Plug 'surround.vim'
Plug 't9md/vim-quickhl'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-scouter', {'on' : 'Scouter'}
Plug 'thinca/vim-singleton'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tyru/capture.vim', {'on' : 'Capture'}
Plug 'tyru/caw.vim'
Plug 'yonchu/accelerated-smooth-scroll'
Plug 'mattn/emmet-vim'
Plug 'slim-template/vim-slim', {'for' : 'slim'}
Plug 'vim-scripts/javacomplete', {'for' : 'java', 'do' : 'javac autoload/Reflection.java'}
Plug 'keith/rspec.vim'
Plug 'vim-ruby/vim-ruby', {'for' : 'ruby'}
Plug 'm2mdas/phpcomplete-extended', {'for' : 'php'}
Plug 'StanAngeloff/php.vim', {'for' : 'php'}
Plug 'violetyk/neocomplete-php.vim', {'for' : 'php'}
Plug 'PDV--phpDocumentor-for-Vim', {'for' : 'php'}
Plug 'osyo-manga/vim-marching', {'for' : ['cpp', 'c']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for' : ['cpp', 'c']}
Plug 'vim-jp/cpp-vim', {'for' : ['cpp', 'c']}
Plug 'Shougo/neoinclude.vim', {'for' : ['cpp', 'c']}
Plug 'MaxMellon/plantuml-syntax', {'for' : 'plantuml'}
Plug 'elixir-lang/vim-elixir', {'for' : 'elixir'}
Plug 'tmux-plugins/vim-tmux', {'for' : ['tmux', 'conf']}
if executable('rct-complete')
  Plug 'osyo-manga/vim-monster', {'for' : 'ruby'}
else
  Plug 'NigoroJr/rsense', {'for' : 'ruby'}
  Plug 'supermomonga/neocomplete-rsense.vim', {'for' : 'ruby'}
endif
if has('ruby') | Plug 'todesking/ruby_hl_lvar.vim' | endif
call plug#end()
" " }}}
if HasPlugin('rails.vim') " {{{
  let g:rails_level = 4
  let g:rails_defalut_database = 'postgresql'
  endif
" " }}}
if HasPlugin('neocomplcache.vim') " {{{
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
if HasPlugin('neocomplete.vim') " {{{
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

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()
  inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()

  " Enable omni completion.
  AutocmdFT css setlocal omnifunc=csscomplete#CompleteCSS
  AutocmdFT html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  AutocmdFT javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  AutocmdFT python setlocal omnifunc=pythoncomplete#Complete
  AutocmdFT xml setlocal omnifunc=xmlcomplete#CompleteTags

  endif
" }}}
if HasPlugin('neocomplete-php.vim') " {{{
  let g:neocomplete_php_locale = 'ja'
endif
" }}}
if HasPlugin('deoplete.nvim') " {{{
  let g:deoplete#enable_at_startup = 1
  endif
" }}}
if HasPlugin('neosnippet') " {{{
  let g:neosnippet#snipqets_directory='~/.vim/snippets'
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  endif
" }}}
if HasPlugin('lightline.vim') " {{{
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
        \   'component': {
        \     'readonly': '%{&readonly?"\u2b64":""}',
        \   },
        \   'separator': { 'left': " ", 'right': " " },
        \   'subseparator': { 'left': " ", 'right': " " },
        \   'active': {
        \     'left':  [ [ 'mode', 'paste', 'capstatus' ],
        \                [ 'anzu', 'fugitive', 'gitgutter' ],
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
        \     'gitgutter' : 'MyGitGutter',
        \     'mode' : 'MyMode'
        \   }
        \ }

  let g:Qfstatusline#UpdateCmd = function('lightline#update')

  function! MyMode()
    let fname = expand('%:t')
     return  fname =~ 'NERD_tree' ? 'NERDTree' :
          \ &ft == 'utenite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ &ft == 'undotree' ? 'UndoTree' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  endif
"}}}
if HasPlugin('vim-gitgutter') " {{{
  let g:gitgutter_sign_added    = '+'
  let g:gitgutter_sign_modified = '>'
  let g:gitgutter_sign_removed  = 'X'

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
  endif
" }}}
if HasPlugin('The-NERD-tree') " {{{
  " バッファがNERDTreeのみになったときNERDTreeをとじる
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType")
    \ && b:NERDTreeType == "primary") | q | endif
  " NERDTREE ignor'e
  let g:NERDTreeIgnore = ['\.clean$', '\.swp$', '\.bak$', '\~$']
  " 隠しファイルの表示設定 0 非表示 1,  表示
  let g:NERDTreeShowHidden = 0
  " 綺麗にディレクトリ構造を表示する
  let g:NERDTreeDirArrows = 0
  nnoremap <silent>,n :<C-u>NERDTreeToggle<CR>
  endif
"}}}
if HasPlugin('indentLine') " {{{
  let g:indentLine_color_term = 239
  let g:indentLine_color_tty_light = 59
  let g:indentLine_color_dark = 1
  let g:indentLine_bufNameExclude = ['NERD_tree.*']
  endif
" }}}
if HasPlugin('vim-quickrun') " {{{
  let g:quickrun_config = {
        \  '_': {
        \     'runner' : 'vimproc',
        \     'runner/vimproc/updatetime' : 60,
        \     'outputter/buffer/split' : ':botright 8sp',
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
if HasPlugin('syntastic') "{{{
  let g:jsx_ext_required = 0
  let g:jsx_pragma_required = 1
  let g:syntastic_javascript_checkers = ['jsxhint']
  let g:syntastic_coffee_checkers     = ['jsxhint']
  " depend on Unite, Unite-QuickFix
  let g:syntastic_always_populate_loc_list=1
  let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
  nnoremap [unite]e :<C-u>Unite location_list -winheight=5<CR>
  endif
" }}}
if HasPlugin('undotree') " {{{
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
if HasPlugin('yankround.vim') "{{{
  nmap p <Plug>(yankround-p)
  xmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  xmap gp <Plug>(yankround-gp)
  nmap <C-n> <Plug>(yankround-next)
  nmap <C-p> <Plug>(yankround-prev)
  nnoremap ,y :Unite yankround<CR>
  endif
" }}}
if HasPlugin('vim-over') " {{{
  nnoremap <silent> <Leader>m :OverCommandLine<CR>
  nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//gc<Left><Left><Left>
  xnoremap s :<C-u>OverCommandLine<CR>'<,'>s///gc<Left><Left><Left>
  endif
" }}}
if HasPlugin('unite.vim') "{{{
  nnoremap m  <nop>
  xnoremap m  <Nop>
  nnoremap [unite] <Nop>
  xnoremap [unite] <Nop>
  nmap m [unite]
  xmap m [unite]

  "uでUnite
  nnoremap [unite]u :<C-u>Unite<CR>

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
  nnoremap [unite]g :<C-u>Unite -buffer-name=search-buffer -winheight=20 -no-quit grep<CR>
  nnoremap ,g :<C-u>Unite grep:. -buffer-name=search-buffer -no-quit<CR>
  " if executable('hw')
  "   let g:unite_source_grep_command = 'hw'
  "   let g:unite_source_grep_default_opts = '--no-group --no-color'
  "   let g:unite_source_grep_recursive_opt = ''
  " endif
  "wでUnite window
  nnoremap [unite]w :<C-u>Unite window<CR>
  "sでUnite source
  nnoremap [unite]s :<C-u>Unite source<CR>
  "yでUnite yankround
  nnoremap [unite]y :<C-u>Unite yankround<CR>
  nnoremap ,e :<C-u>Unite file_rec/async:!<CR>
  nnoremap <Space>a :<C-u>Unite -start-insert file_rec/async<CR>
  "Space-rでキャッシュクリア
  nnoremap <Space>r <Plug>(unite_restart)

  endif
" }}}
if HasPlugin('unite-build') " {{{
  nnoremap ,b :<C-u>Unite build:make -buffer-name=unite-build -winheight=20<CR>
  endif
" }}}
if HasPlugin('unite-rails') " {{{
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
if HasPlugin('unite-rails-fat') " {{{
  nnoremap ,rd :<C-u>Unite rails/decorator<CR>
  nnoremap ,ra :<C-u>Unite rails/api<CR>
  endif
" }}}
if HasPlugin('unite-outline') "{{{
  let g:unite_winwidth = 30
  let g:unite_spliit_rule = "rightbelow"
  nnoremap ,o :<C-u>Unite -vertical outline<CR>
  endif
" }}}
if HasPlugin('caw.vim') "{{{
  nmap ,c <Plug>(caw:i:toggle)
  vmap ,c <Plug>(caw:i:toggle)
  endif
" }}}
if HasPlugin('TweetVim') "{{{
  nnoremap ,tt :<C-u>Unite tweetvim<CR>
  nnoremap ,ts :<C-u>TweetVimSay<CR>
  endif
" }}}
if HasPlugin('w3m.vim') "{{{
  let g:w3m#external_browser = 'firefox'
  let g:w3m#hit_a_hint_key = 'f'
  nnoremap <F8> [w3m]
  xnoremap <F8> [w3m]
  nnoremap [w3m]s :W3mTab google
  " rails デバッグ用
  nnoremap [w3m]r :W3mTab http://localhost:3000<CR>
  endif
" }}}
if HasPlugin('vim-anzu') " {{{
  nmap n <Plug>(anzu-n-with-echo) zz
  nmap N <Plug>(anzu-N-with-echo) zz
  nmap * <Plug>(anzu-star-with-echo) zz
  nmap # <Plug>(anzu-sharp-with-echo) zz
  nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
  endif
" }}}
if HasPlugin('vim-easymotion') " {{{
  " configure
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_keys = 'hjklasdgyuiopqwertnmzxcvb;:f'
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  " keymapping
  nmap <Leader>s <Plug>(easymotion-s2)
  xmap <Leader>s <Plug>(easymotion-s2)
  nmap ss <Plug>(easymotion-sn)
  xmap ss <Plug>(easymotion-sn)
  omap ss <Plug>(easymotion-tn)
  map <Space>j <Plug>(easymotion-j)
  map <Space>k <Plug>(easymotion-k)

  hi EasyMotionTarget guifg=#80a0ff ctermfg=81
  endif
" }}}
if HasPlugin('vim-easy-align') "{{{
  vnoremap <Enter> :EasyAlign<CR>
  endif
"}}}
if HasPlugin('phpcomplete-extended') " {{{
  let g:phpcomplete_index_composer_command = 'composer'
  AutocmdFT php setlocal omnifunc=phpcomplete_extended
  endif
" }}}
if HasPlugin('splitjoin.vim') " {{{
  let g:splitjoin_join_mapping = ',j'
  let g:splitjoin_split_mapping = ',s'
  endif
"}}}
if HasPlugin('switch.vim') " {{{
  let g:switch_custom_definitions =
      \  [
      \     {
      \         '\(\k\+\)'    : '''\1''',
      \       '''\(.\{-}\)''' :  '"\1"',
      \        '"\(.\{-}\)"'  :   '\1',
      \     },
      \  ]
  nnoremap <Space>sw :<C-u>Switch<CR>
  endif
"}}}
if HasPlugin('surround.vim') "{{{
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
if HasPlugin('SrcExpr') " {{{
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
if HasPlugin('codic-vim') "{{{
  nnoremap <Space>c :<C-u>Codic<CR>
  endif
"}}}
if HasPlugin('incsearch.vim') "{{{
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  endif
"}}}
if HasPlugin('vim-monster') "{{{
  let g:monster#completion#rcodetools#backend = "async_rct_complete"
  let g:neocomplete#sources#omni#input_patterns = {
      \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
      \}
  endif
" }}}
if HasPlugin('clever-f.vim') " {{{
  let g:clever_f_use_migemo            = 1   " migemo likeな検索
  let g:clever_f_ignore_case           = 1   " ignore case
  let g:clever_f_fix_key_direction     = 1   " 行方向固定
  let g:clever_f_across_no_line        = 1   " 行をまたがない
  let g:clever_f_chars_match_any_signs = ';' " 記号は;
  endif
" }}}
if HasPlugin('neocomplete-rsense.vim') "{{{
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
if HasPlugin('php.vim') "{{{
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
if HasPlugin('vim-markdown-quote-syntax') "{{{
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
if HasPlugin('auto-ctags.vim') "{{{
  let g:auto_ctags = 1
  let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'
  let g:auto_ctags_tags_name = 'tags'

  augroup AutoCtags
    autocmd!
    autocmd FileType coffee let g:auto_ctags = 0
  augroup END

  let g:auto_ctags_directory_list = ['.git', '.svn']
  endif
"}}}
if HasPlugin('PDV--phpDocumentor-for-Vim') "{{{
  nnoremap <Leader>p :set formatoptions&<CR>:call PhpDocSingle()<CR>kv/func<CR>k=:%s/\s\+$//e<CR><C-o>
  let g:pdv_re_indent=''
  endif
"}}}
if HasPlugin('vim-ruby') "{{{
  let g:rubycomplete_rails = 1
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_include_object = 1
  let g:rubycomplete_include_object_space = 1
  endif
" }}}
if HasPlugin('ctrlp.vim') "{{{
  let g:ctrlp_map = '<Nop>'
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed']
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:18'
  nnoremap t <Nop>
  nnoremap tt :<C-u>CtrlPMixed<CR>
  nnoremap tb :<C-u>CtrlPBuffer<CR>
  endif
" }}}
if HasPlugin('vim-startify') " {{{
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
if HasPlugin('hl_matchit.vim') " {{{
  let g:hl_matchit_enable_on_vim_startup = 1
  let g:hl_matchit_hl_groupname = 'cursorlinenr'
  endif
" }}}
if HasPlugin('vim-quickhl') " {{{
  map ,m <Plug>(quickhl-manual-this)
  map ,M <Plug>(quickhl-manual-reset)
  endif
" }}}
if HasPlugin('jscomplete-vim') "{{{
  AutocmdFT javascript setlocal omnifunc=jscomplete#CompleteJS
  AutocmdFT coffee     setlocal omnifunc=jscomplete#CompleteJS
  endif
"}}}
if HasPlugin('vim-marching') "{{{
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  let g:marching_enable_neocomplete = 1
  endif
" }}}
if HasPlugin('vim-watchdogs') "{{{
  let g:quickrun_config = {}
  let g:quickrun_config['watchdogs_checker/_'] = {
      \   'runner' : 'vimproc',
      \   'runner/vimproc/sleep' : 10,
      \   'runner/vimproc/updatetime' : 500,
      \   'hook/echo/enable' : 1,
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
      \   "c"      : 0,
      \   "cpp"    : 1,
      \   "python" : 0,
      \   "vim"    : 0,
      \   "php"    : 1,
      \   "ruby"   : 0,
      \   "slim"   : 0,
      \   "java"   : 0,
      \   "sass"   : 0,
      \ }
  let g:watchdogs_check_CursorHold_enable = 0
  call watchdogs#setup(g:quickrun_config)
  endif
" }}}
if HasPlugin('vim-qfstatusline') " {{{
  function! StatuslineUpdate()
      return qfstatusline#Update()
  endfunction
  let g:Qfstatusline#UpdateCmd = function('StatuslineUpdate')
endif
" }}}
if HasPlugin('lexima.vim') " {{{
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
  let g:lexima_enable_endwise_rules = 1
  let g:lexima_enable_newline_rules = 1
  let g:lexima_enable_basic_rules = 1
endif
" }}}
if HasPlugin('tagbar') " {{{
  let g:tagbar_width = 20
  nnoremap <silent> <leader>t :TagbarToggle<CR>
endif
" " }}}
" }}}
" set {{{
" common {{{
set autoread                  " vim外で編集された時の自動み込み
set autowrite                 " bufferが切り替わるときの自動保存
set backspace=indent,eol,start
set cmdheight=2
set cmdwinheight=5            " Command-line windowの行数
set cscopetag
set cursorline
set display=lastline          " 画面を超える長い１行も表示
set formatoptions=tcq
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
set showcmd                   " ステータスラインに常にコメンド表示
set showmatch                 " 閉じ括弧を入力時，開き括弧に一瞬ジャンプ
set splitbelow                " 横分割時、新しいウィンドウは下
set splitright                " 縦分割時、新しいウィンドウは右
set t_Co=256
set tags+=.svn/tags
set tags+=.git/tags
if has("path_extra")
  set tags+=tags;
endif
set textwidth=0
set ttyfast                   " スクロールが滑らかに
if ! has('nvim')
  set ttyscroll=1
endif
set vb t_vb=                  " no beep no flash
set whichwrap=b,s,h,l,<,>,[,] " hとlが非推奨
" }}}
" spelling {{{
" set spelllang=en_us
" ignore japanese
" set spelllang+=cjk
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
set undodir=~/.vim/_undo
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
set nowrapscan  " 検索をファイルの先頭へループしない
set smartcase   " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan
" }}}
" folding {{{
set foldenable         " 折りたたみon
set foldmethod =marker " 折りたたみ方法:マーカ
set foldcolumn =0      " 折りたたみの補助線幅
set foldlevel  =0      " foldをどこまで一気に開くか
if (!exists('FoldCCText'))
  set foldtext=FoldCCtext()
  set fillchars=vert:\|
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
" tab-editer {{{
set showtabline=2 " 常にタブ
" tab jump
for s:n in range(1, 9)
  execute 'nnoremap <silent> [Tab]' . s:n ':<C-u>tabnext' . s:n . '<CR>'
endfor

"}}}
" wildmenu {{{
set wildmenu " cmdline補完
set wildmode=longest:full,full
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
" }}}
" encode {{{
set encoding      =utf-8       " 文字コード指定
set fileencodings =utf-8,s-jis " 文字エンコードを次の順番で確認
scriptencoding     utf-8
set fileformats   =unix,dos,mac  " 改行コードの自動認識
set ambiwidth     =double        " ２バイト特殊文字の幅調整
" }}}
" clpum {{{
if exists('+clpum')
  set clpum
  set clpumheight=20
  set clcompleteopt+=noinsert
endif
" }}}
" fast scroll {{{
"" Fast vertical scroll
" source: http://qiita.com/kefir_/items/c725731d33de4d8fb096
" Use vsplit mode
if has('vim_starting') && !has('gui_running') && has('vertsplit')
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
" }}}
" autocmd {{{
" filetype {{{
Autocmd BufNewFile,BufRead *.md      set filetype=markdown
Autocmd BufNewFile,BufRead *.slim    set filetype=slim
Autocmd BufNewFile,BufRead *.less    set filetype=less
Autocmd BufNewFile,BufRead *.coffee  set filetype=coffee
Autocmd BufNewFile,BufRead *.scss    set filetype=scss
Autocmd BufNewFile,BufRead *.sass    set filetype=sass
Autocmd BufNewFile,BufRead *.less    set filetype=less
Autocmd BufNewFile,BufRead *.pu      set filetype=plantuml
Autocmd BufNewFile,BufRead *.cjsx    set filetype=coffee
Autocmd BufNewFile,BufRead *.exs     set filetype=elixir
Autocmd BufNewFile,BufRead *.ex      set filetype=elixir
Autocmd BufNewFile,BufRead *.toml    set filetype=toml
Autocmd BufNewFile,BufRead *_spec.rb set filetype=rspec
AutocmdFT python   setlocal tabstop=8 noexpandtab shiftwidth=4 softtabstop=4
AutocmdFT php      setlocal tabstop=4 expandtab   shiftwidth=4 softtabstop=4
AutocmdFT java     setlocal tabstop=4 expandtab   shiftwidth=4 softtabstop=4
AutocmdFT make     setlocal tabstop=4 noexpandtab shiftwidth=4 softtabstop=4
AutocmdFT yaml     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT conf     setlocal tabstop=2 noexpandtab shiftwidth=2 softtabstop=2
AutocmdFT coffee   setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT slim     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT toml     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT plantuml setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
" }}}
" QuickFix {{{
Autocmd QuickFixCmdPost make,*grep* cwindow
Autocmd VimEnter COMMIT_EDITMSG if getline(1) == ''
                                \ | execute 1
                                \ | startinsert
                                \ | endif
" }}}
AutocmdFT html     inoremap <silent> <buffer> </ </<C-x><C-o>
AutocmdFT sass,scss,css setlocal iskeyword+=-
" tails space highlight
Autocmd BufNewFile,BufRead,VimEnter,WinEnter,ColorScheme
    \ * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
Autocmd BufNewFile,BufRead,VimEnter,WinEnter
    \ * match TrailingSpaces /\s\+$/
Autocmd InsertLeave * set nopaste
" }}}
" function {{{
function! s:copy_mode_toggle() " {{{
  setlocal nolist! number! relativenumber!
  GitGutterSignsToggle
  IndentLinesToggle
endfunction
command! CopyModeToggle :call s:copy_mode_toggle()
nnoremap <silent> <C-c> :<C-u>CopyModeToggle<CR>
" }}}
function! s:load_help() "{{{
  helptags ~/.vim/help/vimdoc-ja/doc
  set runtimepath+=~/.vim/help/vimdoc-ja
  set helplang=ja
endfunction
command! LoadHelp :call s:load_help()
AutocmdFT help LoadHelp
nnoremap <silent> ,h :<C-u>call LoadHelp()<CR> :help <C-r><C-w><CR>
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
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction

command! RemoveFancyCharacters :call s:remove_fancy_characters()
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
" }}}
" command {{{
" TabIndent, SpaceIndent {{{
command! -bar -nargs=1 TabIndent
  \ setlocal noexpandtab softtabstop< tabstop=<args> shiftwidth=<args>

command! -bar -nargs=1 SpaceIndent
  \ setlocal expandtab tabstop< softtabstop=<args> shiftwidth=<args>
" }}}
" vimgrep alias {{{
command! -bar -nargs=* G vimgrep <args> %
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
"}}}
" cursol key {{{
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

nnoremap OA <C-w>l
nnoremap OB <C-w>j
nnoremap OC <C-w>h
nnoremap OD <C-w>k
nnoremap A  <C-w>l
nnoremap B  <C-w>j
nnoremap C  <C-w>h
nnoremap D  <C-w>k
"}}}
" tab {{{
nmap [Tab] <Nop>
nmap s [Tab]
nnoremap [Tab]e :<C-u>tabedit<Space>.<CR>
nnoremap <silent> [Tab]c :tablast <bar> tabnew<CR>
nnoremap <silent> [Tab]n :tabnew<CR>
nnoremap <silent> [Tab]x :tabclose<CR>
nnoremap <silent> [Tab]n :tabnext<CR>
nnoremap <silent> <F3> :tabnext<CR>
nnoremap <silent> [Tab]p :tabprevious<CR>
nnoremap <silent> <F2> :tabprevious<CR>
"}}}
" Disable key {{{
nnoremap M m
nnoremap Q q
nnoremap K  <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
"}}}
" change normal mode {{{
inoremap <silent> jj     <Esc>`^
inoremap <silent> <Esc>  <Esc>`^
inoremap <silent> <C-[>  <Esc>`^
inoremap <C-c> <Esc>`^
inoremap <C-j><C-j> <Esc>`^
vnoremap <C-j><C-j> <Esc>
" }}}
" Paste next line. {{{
nnoremap <silent> gp o<ESC>p^
nnoremap <silent> gP O<ESC>P^
xnoremap <silent> gp o<ESC>p^
xnoremap <silent> gP O<ESC>P^
" }}}
" change buffer {{{
nnoremap <silent> bp :bprevious<CR>
nnoremap <silent> bn :bnext<CR>
for s:k in range(1, 9)
  execute 'nnoremap <Leader>' . s:k ':e #' . s:k . '<CR>'
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
inoremap <C-Tab> <C-v><Tab>
inoremap <S-Tab> <C-v><Tab>
inoremap <C-l> <Right>
inoremap <C-e> <End>
" }}}
" home and end {{{
" See: https://github.com/martin-svk/dot-files/blob/682087a4ff45870f55bd966632156be07a2ff1c4/vim/vimrc#L343-347
nnoremap <expr> 0
  \ col('.') ==# 1 ? '^' : '0'
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_
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
nnoremap _ :sp .<CR>
" | : Quick vertical splits
nnoremap <bar> :vsp .<CR>
" }}}
" increment {{{
noremap + <C-a>
noremap - <C-x>
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
" }}}
" prefix [,] {{{
" remove white space of end line
nnoremap <silent> ,x :%s/\s\+$//e<CR>
vnoremap <silent> ,x :%s/\s\+$//e<CR>
" remove double width white space
nnoremap <silent> ,z :%s/  /  /g<CR>
vnoremap <silent> ,z :%s/  /  /g<CR>
" toggle paste mode
nnoremap <silent> ,p :set paste!<CR>
" }}}
" cmd window {{{
nnoremap :: q:
nnoremap ; :
vnoremap ; :
" history {{{
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Tab> <C-d>
nnoremap <sid>vcommand-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>
" }}}
" autoload {{{
augroup CmdWindow
  autocmd!
  autocmd CmdwinEnter * call s:init_cmdwin()
augroup END
" }}}
" cmdwindow mapping function {{{
function! s:init_cmdwin()
  setlocal nolist! number! relativenumber!
  nnoremap <silent><buffer>q :<C-u>q<CR>
  nnoremap <silent><buffer><CR> A<CR>
  inoremap <buffer><silent> <Tab> <C-d>
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  startinsert!
endfunction
" }}}
" }}}
" etc {{{
nnoremap <C-p> :<C-u>G<Space>
" }}}
" clear screan
nnoremap <silent><ESC><ESC> :<C-u>nohlsearch<CR><ESC>
nnoremap <silent><C-l> :<C-u>nohlsearch<CR><ESC>
" }}}
" statusline {{{
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
if HasPlugin('fugitive')
  set statusline+=%{fugitive#statusline()}
endif
" 構文チェック
if HasPlugin('syntastic')
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
set statusline+=%y
" 文字バイト数/カラム番号
" set statusline+=[ASCII=%B]
" 現在文字列/全体列表示
set statusline+=[C=%c/%{col('$')-1}]
" 現在文字行/全体行表示
set statusline+=[L=%l/%L]
" 現在行が全体行の何%目か表示
set statusline+=[%p%%]
" }}}
" color {{{
try
  colorscheme molokai
  let g:molokai_original = 1
catch
  colorscheme desert
endtry
syntax on
"}}}
" END {{{
filetype indent on
set secure " vimrcの最後に記述 vimhelpより
" }}}
