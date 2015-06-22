" ---------------------------------------------------------------------------
" Plugin:
"

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
" neobundle installation check {{{
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
endif
" }}}

" 参考 morygonzalez
" See: https://github.com/morygonzalez/dotfiles/blob/master/.vimrc#L33-35
"-----------------------------------------------------------------------
function! s:meet_neocomplete_requirements()
  return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

" neobundle {{{

call neobundle#begin(expand('~/.vim/bundle/'))
call neobundle#load_cache()

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle      'Shougo/neomru.vim'
NeoBundle      'Shougo/unite.vim'
" vimproc {{{
NeoBundle 'Shougo/vimproc', { 'build' : { 'windows' : 'make -f make_mingw32.mak', 'cygwin' : 'make -f make_cygwin.mak', 'mac' : 'make -f make_mac.mak', 'unix' : 'make -f make_unix.mak', }, } " }}}
if s:meet_neocomplete_requirements()
  NeoBundle    'Shougo/neocomplete.vim'
else
  NeoBundle    'Shougo/neocomplcache.vim'
endif
NeoBundle      'Shougo/neosnippet'
NeoBundle      'Shougo/neosnippet-snippets'
NeoBundle      'itchyny/lightline.vim'
NeoBundle      'tpope/vim-fugitive'
NeoBundle      'airblade/vim-gitgutter'
NeoBundle      'The-NERD-tree'
NeoBundle      'Yggdroot/indentLine'
NeoBundle      'osyo-manga/vim-over'
NeoBundle      'mopp/AOJ.vim'
NeoBundle      'mattn/webapi-vim'
NeoBundle      'tyru/caw.vim.git'
NeoBundle      'LeafCage/yankround.vim'
NeoBundle      'mbbill/undotree'
NeoBundle      'koron/nyancat-vim'
NeoBundle      'mattn/gist-vim'
NeoBundle      'tyru/open-browser.vim'
NeoBundle      'basyura/twibill.vim'
NeoBundle      'mattn/benchvimrc-vim'
NeoBundle      'osyo-manga/vim-anzu'
NeoBundle      'Lokaltog/vim-easymotion'
NeoBundleLazy  'basyura/TweetVim.git'
" depend-vimproc
NeoBundle      'thinca/vim-quickrun'
NeoBundle      'Shougo/vimshell.vim', { 'depends' : [ 'Shougo/vimproc' ] }
NeoBundleLazy  'yuratomo/w3m.vim', { 'autoload' : { 'commands' : [ 'W3mTab' ] } }
" depend-unite
NeoBundle      'basyura/unite-rails', { 'depends' : [ 'Shougo/unite.vim' ] }
NeoBundle      'osyo-manga/unite-filetype', { 'depends' : [ 'Shougo/unite.vim' ] }
NeoBundleLazy  'yomi322/unite-tweetvim.git'
" languages
NeoBundleLazy  'vim-ruby/vim-ruby', { 'autoload' : { 'filetypes' : [ 'ruby' ] } }
NeoBundleLazy  'MaxMEllon/ruby_matchit', { 'autoload' : { 'filetypes' : [ 'ruby' ] } }
NeoBundleLazy  'slim-template/vim-slim', { 'autoload' : { 'filetypes' : [ 'slim' ] } }
NeoBundleLazy  'groenewege/vim-less', { 'autoload' : { 'filetypes' : [ 'less' ] } }
NeoBundleLazy  'kchmck/vim-coffee-script', { 'autoload' : { 'filetypes' : [ 'coffee' ] } }
NeoBundleLazy  'mtscout6/vim-cjsx', { 'autoload' : { 'filetypes' : [ 'coffee' ] } }
NeoBundleLazy  'aklt/plantuml-syntax', { 'autoload' : { 'filetypes' : [ 'plantuml' ] } }
" framework
NeoBundle      'rails.vim'
" color
NeoBundle      'MaxMellon/molokai'
NeoBundleLazy  'altercation/vim-colors-solarized'
NeoBundleLazy  'vim-scripts/twilight'
NeoBundleLazy  'Wombat256.vim'
" disalble
" NeoBundle   'scrooloose/syntastic'
" NeoBundle   'surround.vim'
NeoBundleSaveCache
call neobundle#end()
" }}}

if neobundle#tap('rails.vim') " {{{
  let g:rails_level = 4
  let g:rails_defalut_database = 'postgresql'
  call neobundle#untap()
endif
" }}}

" if neobundle#tap('neocomplecache') " {{{
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
        \ 'default' : '',
        \ 'java' : $HOME . './.vim/dict/java.dict',
        \ 'ruby' : $HOME . './.vim/dict/ruby.dict',
        \ 'c'    : $HOME . './.vim/dict/c.dict',
        \ 'cpp'  : $HOME . './.vim/dict/cpp.dict',
        \ }
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><C-g> neocomplcache#undo_completion(
  inoremap <expr><C-l> neocomplcache#complete_common_string())
"   call neobundle#untap()
" endif
" }}}

if neobundle#tap('neosnippet') " {{{
  let g:neosnippet#snipqets_directory='~/.vim/snippets'
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  call neobundle#untap()
endif
" }}}

if neobundle#tap('lightline.vim') " {{{
  let g:lightline = {
        \   'component': {
        \     'readonly': '%{&readonly?"\u2b64":""}',
        \   },
        \   'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \   'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
        \   'active': {
        \     'left':  [ [ 'mode', 'paste', 'capstatus' ],
        \                [ 'fugitive', 'gitgutter' ],
        \                [ 'filename' ] ],
        \     'right': [ [ 'anzu', 'filetype' ],
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
        \     'anzu' : 'anzu#search_status',
        \     'capstatus' : 'CapsLockSTATUSLINE',
        \     'fugitive' : 'MyFugitive',
        \     'gitgutter' : 'MyGitGutter'
        \   }
        \ }
  call neobundle#untap()
endif
"}}}

if neobundle#tap('AOJ.vim') " {{{
  " aoj config
  let g:aoj#user_id = 'mozi_kke'
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-gitgutter') " {{{
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
  call neobundle#untap()
endif
" }}}

if neobundle#tap('The-NERD-tree') " {{{
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
  call neobundle#untap()
endif
"}}}

if neobundle#tap('indentLine') " {{{
  let g:indentLine_color_term = 239
  let g:indentLine_color_tty_light = 59
  let g:indentLine_color_dark = 1
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-quickrun') " {{{
  let g:quickrun_config = {
        \  '_': {
        \     'runner' : 'vimproc',
        \     'runner/vimproc/updatetime' : 60,
        \     'outputter/buffer/split' : ':botright 8sp',
        \     'hook/time/enable': '1',
        \   }
        \ }
  let g:quickrun_config['slim'] = {'command' : 'slimrb', 'exec' : ['%c -p %s']}
  nnoremap <silent><C-q> :QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vimshell.vim') "{{{
  nnoremap <Space>sh :VimShellPop -toggle<CR>
  nnoremap <Space>cd :VimShellCurrentDir<CR>
  nnoremap <Space>rb :VimShellInteractive irb<CR>
  nnoremap <Space>rc :VimShellInteractive rails c<CR>
  " nnoremap ,pry :VimShellInteractive pry<CR>
endif
" }}}

if neobundle#tap('syntastic') "{{{
  let g:syntastic_enable_signs  = 1
  let g:syntastic_auto_loc_list = 2
  let g:syntastic_enable_signs  = 1
  let g:syntastic_ruby_checkers =['rubocop']
  let g:syntastic_error_symbol  ='☠ '
  let g:syntastic_warning_symbol='☃ '
  let g:syntastic_mode_map = {
        \  'mode': 'active',
        \  'active_filetypes': ['c', 'c++', 'ruby'],
        \  'passive_filetypes': ['coffee']
        \ }
  augroup AutoSyntastic
    if v:version > 703
      autocmd!
      autocmd BufWritePost *.c,*.cpp,*.rb call s:syntastic()
    endif
  augroup END

  function! s:syntastic()
    try
      SyntasticCheck
      call lightline#update()
    catch
    endtry
  endfunction
  nnoremap ,sc :<C-u>SyntasticCheck<CR>
  nnoremap ,sct :<C-u>SyntasticToggleMode<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('undotree') " {{{
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_SplitWidth = 35
  let g:undotree_diffAutoOpen = 1
  let g:undotree_diffpanelHeight = 25
  let g:undotree_RelativeTimestamp = 1
  let g:undotree_TreeNodeShape = '*'
  let g:undotree_HighlightChangedText = 1
  nnoremap ,u :UndotreeToggle<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('yankround.vim') "{{{
  nmap p <Plug>(yankround-p)
  xmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  xmap gp <Plug>(yankround-gp)
  nmap <C-n> <Plug>(yankround-next)
  nmap <C-p> <Plug>(yankround-prev)
  nnoremap ,y :Unite yankround<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-over') " {{{
  nnoremap <silent> <Leader>m :OverCommandLine<CR>
  nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
  nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>
  xnoremap s :<C-u>OverCommandLine<CR>'<,'>s///g<Left><Left>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('unite.vim') "{{{
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
  nnoremap [unite]g :<C-u>Unite -buffer-name=search -winheight=20 -no-quit grep<CR>
  "wでUnite window
  nnoremap [unite]w :<C-u>Unite window<CR>
  "sでUnite source
  nnoremap [unite]s :<C-u>Unite source<CR>
  "yでUnite yankround
  nnoremap [unite]y :<C-u>Unite yankround<CR>
  "eでUnite file/async
  nnoremap [unite]e :<C-u>Unite file_rec/async:!<CR>
  nnoremap ,e :<C-u>Unite file_rec/async:!<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('unite-rails') " {{{
  nnoremap ,rc :<C-u>Unite rails/controller<CR>
  nnoremap ,rm :<C-u>Unite rails/model<CR>
  nnoremap ,rv :<C-u>Unite rails/view<CR>
  nnoremap ,rh :<C-u>Unite rails/helper<CR>
  nnoremap ,rs :<C-u>Unite rails/stylesheet<CR>
  nnoremap ,rj :<C-u>Unite rails/javascript<CR>
  nnoremap ,rg :<C-u>Unite rails/gemfile<CR>
  nnoremap ,rd :<C-u>Unite rails/db<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('caw.vim') "{{{
  nmap ,c <Plug>(caw:i:toggle)
  vmap ,c <Plug>(caw:i:toggle)
  call neobundle#untap()
endif
" }}}

if neobundle#tap('TweetVim') "{{{
  nnoremap ,tt :<C-u>Unite tweetvim<CR>
  nnoremap ,ts :<C-u>TweetVimSay<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('w3m.vim') "{{{
  let g:w3m#external_browser = 'firefox'
  let g:w3m#hit_a_hint_key = 'f'
  nnoremap <F8> [w3m]
  xnoremap <F8> [w3m]
  nnoremap [w3m]s :W3mTab google
  " rails デバッグ用
  nnoremap [w3m]r :W3mTab http://localhost:3000<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-anzu') " {{{
  nmap n <Plug>(anzu-n-with-echo) zz
  nmap N <Plug>(anzu-N-with-echo) zz
  nmap * <Plug>(anzu-star-with-echo) zz
  nmap # <Plug>(anzu-sharp-with-echo) zz
  nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
endif
" }}}

if neobundle#tap('vim-easymotion') " {{{
  " configure
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_keys = '123456789;:'
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  " keymapping
  nmap s <Plug>(easymotion-s2)
  xmap s <Plug>(easymotion-s2)
  omap z <Plug>(easymotion-s2)
  nmap g/ <Plug>(easymotion-sn)
  xmap g/ <Plug>(easymotion-sn)
  omap g/ <Plug>(easymotion-tn)
  map <Leader>j <Plug>(easymotion-j)
  map <Leader>k <Plug>(easymotion-k)

  hi EasyMotionTarget guifg=#80a0ff ctermfg=81
endif
" }}}

filetype plugin indent on     " Required!
NeoBundleCheck

if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif
