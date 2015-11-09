"----------------------------------------------------------------------
" PluginConfig:
"

" neobndle がないとき読み込まない
if !HasPlugin('neobundle') | finish | endif

NeoBundleCheck

if neobundle#tap('rails.vim') " {{{
  let g:rails_level = 4
  let g:rails_defalut_database = 'postgresql'
  call neobundle#untap()
endif
" }}}

if neobundle#tap('neocomplcache.vim') " {{{
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
  call neobundle#untap()
endif
" }}}

if neobundle#tap('neocomplete.vim') " {{{
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

  call neobundle#untap()
endif
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
        \     '?': '      '
        \   },
        \   'component': {
        \     'readonly': '%{&readonly?"\u2b64":""}',
        \   },
        \   'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \   'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
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
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ &ft == 'undotree' ? 'UndoTree' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

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
  let g:indentLine_bufNameExclude = ['NERD_tree.*']
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
        \     "hook/back_window/enable" : 1,
        \     "hook/back_window/enable_exit" : 1,
        \   }
        \ }
  let g:quickrun_config['slim'] = {'command' : 'slimrb', 'exec' : ['%c -p %s']}
  nnoremap <silent><C-q> :QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "<C-c>"
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vimshell.vim') "{{{
  call neobundle#config({
    \   'autoload' : {
    \      'commands' : ['VimShell', 'VimShellPop']
    \   }
    \ })
  nnoremap <Space>sh :VimShellPop -toggle<CR>
  nnoremap <Space>cd :VimShellCurrentDir<CR>
  nnoremap <Space>rb :VimShellInteractive irb<CR>
  nnoremap <Space>rc :VimShellInteractive rails c<CR>
  " nnoremap ,pry :VimShellInteractive pry<CR>
  let g:vimshell_prompt_expr = 'getcwd()." > "'
  let g:vimshell_prompt_pattern = '^\f\+ > '
  call neobundle#untap()
endif

" }}}

if neobundle#tap('vimshell-pure.vim') "{{{
  call neobundle#config({
    \   'autoload' : {
    \       'on_source' : ['vimshell.vim']
    \   }
    \ })
endif
"}}}

if neobundle#tap('syntastic') "{{{
  let g:jsx_ext_required = 0
  let g:jsx_pragma_required = 1
  let g:syntastic_javascript_checkers = ['jsxhint']
  let g:syntastic_coffee_checkers     = ['jsxhint']
  " depend on Unite, Unite-QuickFix
  let g:syntastic_always_populate_loc_list=1
  let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
  nnoremap [unite]e :<C-u>Unite location_list -winheight=5<CR>
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
  nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//gc<Left><Left><Left>
  xnoremap s :<C-u>OverCommandLine<CR>'<,'>s///gc<Left><Left><Left>
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
  nnoremap ,rt :<C-u>Unite rails/spec<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('unite-rails-fat') " {{{
  nnoremap ,rd :<C-u>Unite rails/decorator<CR>
  nnoremap ,ra :<C-u>Unite rails/api<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('unite-outline') "{{{
  let g:unite_winwidth = 30
  let g:unite_spliit_rule = "rightbelow"
  nnoremap ,o :<C-u>Unite -vertical outline<CR>
  call neobundle#untap()
endif
"}}}

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
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-easymotion') " {{{
  " configure
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_keys = 'hjklasdgyuiopqwertnmzxcvb;:f'
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  " keymapping
  nmap <Space>e <Plug>(easymotion-s2)
  xmap <Space>e <Plug>(easymotion-s2)
  nmap g/ <Plug>(easymotion-sn)
  xmap g/ <Plug>(easymotion-sn)
  omap g/ <Plug>(easymotion-tn)
  map <Space>j <Plug>(easymotion-j)
  map <Space>k <Plug>(easymotion-k)

  hi EasyMotionTarget guifg=#80a0ff ctermfg=81
  call neobundle#untap()
endif
" }}}

if neobundle#tap('phpcomplete-extended') " {{{
  let g:phpcomplete_index_composer_command = 'composer'
  AutocmdFT php setlocal omnifunc=phpcomplete_extended
  call neobundle#untap()
endif
" }}}

if neobundle#tap('neocomplete-php.vim') " {{{
  let g:neocomplete_php_locale = 'ja'
  call neobundle#untap()
endif
" }}}

if neobundle#tap('splitjoin.vim') " {{{
  let g:splitjoin_join_mapping = ',j'
  let g:splitjoin_split_mapping = ',s'
endif
"}}}

if neobundle#tap('switch.vim') " {{{
  let g:switch_custom_definitions =
      \  [
      \     {
      \         '\(\k\+\)'    : '''\1''',
      \       '''\(.\{-}\)''' :  '"\1"',
      \        '"\(.\{-}\)"'  :   '\1',
      \     },
      \  ]
  nnoremap <Space>sw :<C-u>Switch<CR>
  call neobundle#untap()
endif
"}}}

if neobundle#tap('surround.vim') "{{{
  nmap ,( csw(
  nmap ,) csw)
  nmap ,{ csw{
  nmap ,} csw}
  nmap ,[ csw[
  nmap ,] csw]
  nmap ,' csw'
  nmap ," csw"
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-easy-align') "{{{
  vnoremap <Enter> :EasyAlign<CR>
  call neobundle#untap()
endif
"}}}

if neobundle#tap('codic-vim') "{{{
  nnoremap <Space>c :<C-u>Codic<CR>
  call neobundle#untap()
endif
"}}}

if neobundle#tap('incsearch.vim') "{{{
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  call neobundle#untap()
endif
"}}}

if neobundle#tap('vim-monster') "{{{
  let g:monster#completion#rcodetools#backend = "async_rct_complete"
  let g:neocomplete#sources#omni#input_patterns = {
      \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
      \}
  call neobundle#untap()
endif
" }}}

if neobundle#tap('clever-f.vim') " {{{
  let g:clever_f_use_migemo            = 1   " migemo likeな検索
  let g:clever_f_ignore_case           = 1   " ignore case
  let g:clever_f_fix_key_direction     = 1   " 行方向固定
  let g:clever_f_across_no_line        = 0   " 行をまたがない
  let g:clever_f_chars_match_any_signs = ';' " 記号は;
  call neobundle#untap()
endif
" }}}

if neobundle#tap('neocomplete-rsense.vim') "{{{
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:rsenseUseOmniFunc = 1
  if filereadable(expand('~/git/rsense/bin/rsense'))
    let g:rsenseHome = expand('~/git/rsense')
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  endif
  let g:rsenseUseOmniFunc = 1
  call neobundle#untap()
endif
" }}}

if neobundle#tap('php.vim') "{{{
  function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
  endfunction

  augroup phpSyntaxOverride
    autocmd!
    autocmd FileType php call PhpSyntaxOverride()
  augroup END
  call neobundle#untap()
endif
"}}}

if neobundle#tap('vim-markdown-quote-syntax') "{{{
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
  call neobundle#untap()
endif
"}}}

if neobundle#tap('auto-ctags.vim') "{{{
  let g:auto_ctags = 1
  let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'
  let g:auto_ctags_tags_name = 'tags'

  augroup AutoCtags
    autocmd!
    autocmd FileType coffee let g:auto_ctags = 0
  augroup END

  let g:auto_ctags_directory_list = ['.git', '.svn']
  call neobundle#untap()
endif
"}}}

if neobundle#tap('PDV--phpDocumentor-for-Vim') "{{{
  nnoremap <Leader>p :set formatoptions&<CR>:call PhpDocSingle()<CR>kv/func<CR>k=:%s/\s\+$//e<CR><C-o>
  let g:pdv_re_indent=''
  call neobundle#untap()
endif
"}}}

if neobundle#tap('vim-ruby') "{{{
  let g:rubycomplete_rails = 1
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_include_object = 1
  let g:rubycomplete_include_object_space = 1
  call neobundle#untap()
endif
" }}}

if neobundle#tap('ctrlp.vim') "{{{
  let g:ctrlp_map = '<Nop>'
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed']
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:18'
  nnoremap t <Nop>
  nnoremap tt :<C-u>CtrlPMixed<CR>
  nnoremap tb :<C-u>CtrlPBuffer<CR>
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-startify') " {{{
  let g:startify_custom_header = [
          \ '                                 ________  __ __',
          \ '            __                  /\_____  \/\ \\ \',
          \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \',
          \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \',
          \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
          \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/',
          \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/',
          \ '',
          \ '',
          \ ]
  call neobundle#untap()
endif
" }}}

if neobundle#tap('hl_matchit.vim') " {{{
  let g:hl_matchit_enable_on_vim_startup = 1
  let g:hl_matchit_hl_groupname = 'cursorlinenr'
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-quickhl') " {{{
  map ,m <Plug>(quickhl-manual-this)
  map ,M <Plug>(quickhl-manual-reset)
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-singleton') "{{{
  call singleton#enable()
  call neobundle#untap()
endif
"}}}

if neobundle#tap('jscomplete-vim') "{{{
  AutocmdFT javascript setlocal omnifunc=jscomplete#CompleteJS
  AutocmdFT coffee     setlocal omnifunc=jscomplete#CompleteJS
  call neobundle#untap()
endif
"}}}

if neobundle#tap('vim-altr') " {{{
  nnoremap <Space>a <Plug>(altr-forward)
  call neobundle#untap()
endif
"}}}

if neobundle#tap('vim-marching') "{{{
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  let g:marching_enable_neocomplete = 1
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-watchdogs') "{{{
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
      \   "cpp"    : 1,
      \   "python" : 0,
      \   "vim"    : 0,
      \   "php"    : 1,
      \   "ruby"   : 0,
      \   "slim"   : 0,
      \   "sass"   : 0,
      \ }
  let g:watchdogs_check_CursorHold_enable = 0
  call watchdogs#setup(g:quickrun_config)
  call neobundle#untap()
endif
" }}}

if neobundle#tap('vim-qfstatusline') " {{{
  function! StatuslineUpdate()
      return qfstatusline#Update()
  endfunction
  let g:Qfstatusline#UpdateCmd = function('StatuslineUpdate')
endif
" }}}

if neobundle#tap('lexima.vim') " {{{
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
  call neobundle#untap()
endif
" }}}

