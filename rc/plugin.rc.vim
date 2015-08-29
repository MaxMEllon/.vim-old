" ---------------------------------------------------------------------------
" Plugin:
"
if has('vim_starting')
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif


" 参考 morygonzalez
" See: https://github.com/morygonzalez/dotfiles/blob/master/.vimrc#L33-35
"-----------------------------------------------------------------------
function! s:meet_neocomplete_requirements()
  return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif

if ! neobundle#load_cache()
  finish
else
  " neobundle {{{
  call neobundle#begin()
  NeoBundleFetch 'Shougo/neobundle.vim'
  NeoBundleCheck
  NeoBundle 'Shougo/neomru.vim'
  NeoBundle 'Shougo/unite.vim'
  NeoBundle 'Shougo/vimproc', {
        \ 'build' : {
        \     'windows' : 'make -f make_mingw32.mak',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make -f make_mac.mak',
        \     'unix' : 'make -f make_unix.mak' } }
  if s:meet_neocomplete_requirements()
    NeoBundle 'Shougo/neocomplete.vim'
  else
    NeoBundle 'Shougo/neocomplcache.vim'
  endif
  NeoBundle 'The-NERD-tree'
  NeoBundle 'AndrewRadev/splitjoin.vim'
  NeoBundle 'AndrewRadev/switch.vim'
  NeoBundle 'LeafCage/foldCC.vim'
  NeoBundle 'Shougo/neosnippet'
  NeoBundle 'Shougo/neosnippet-snippets'
  NeoBundle 'Yggdroot/indentLine'
  NeoBundle 'airblade/vim-gitgutter'
  NeoBundle 'haya14busa/incsearch.vim'
  NeoBundle 'itchyny/lightline.vim'
  NeoBundle 'mattn/webapi-vim'
  NeoBundle 'mhinz/vim-startify'
  NeoBundle 'rhysd/clever-f.vim'
  NeoBundle 'scrooloose/syntastic'
  NeoBundle 'tpope/vim-fugitive'
  NeoBundle 'tpope/vim-endwise'
  NeoBundle 'tyru/caw.vim'

  NeoBundleLazy 'AndrewRadev/switch.vim', {
        \ 'autoload': {
        \   'commands': ['Switch'] } }
  NeoBundleLazy 'LeafCage/nebula.vim', {
        \ 'autoload': {
        \   'commands': [ 'NebulaPutLazy', 'NebulaPutFromClipboard',
        \                 'NebulaYankOptions', 'NebulaYankConfig',
        \                 'NebulaPutConfig', 'NebulaYankTap'] } }
  NeoBundleLazy 'LeafCage/yankround.vim', {
        \ 'autoload': {
        \     'unite_sources': ['yankround'],
        \     'mappings': ['cxn', '<Plug>(yankround-'] } }
  NeoBundleLazy 'Lokaltog/vim-easymotion', {
        \ 'autoload': {
        \   'mappings': ['sxno', '<Plug>(easymotion-'],
        \   'commands': ['EMCommandLineNoreMap',
        \                'EMCommandLineMap',
        \                'EMCommandLineUnMap'] } }
  NeoBundleLazy 'alpaca-tc/neorspec.vim', {
        \ 'depends' : 'tpope/vim-rails',
        \ 'autoload' : {
        \   'commands' : [
        \       'RSpecAll', 'RSpecNearest', 'RSpecRetry',
        \       'RSpecCurrent', 'RSpec' ] }}
  NeoBundleLazy 'basyura/TweetVim'
  NeoBundleLazy 'junegunn/vim-easy-align', {
        \ 'autoload': {
        \   'mappings': ['<Plug>(EasyAlignOperator)',
        \                 ['sxn', '<Plug>(EasyAlign)'],
        \                 ['sxn', '<Plug>(LiveEasyAlign)'],
        \                 ['sxn', '<Plug>(EasyAlignRepeat)']],
        \   'commands': ['EasyAlign', 'LiveEasyAlign'] } }
  NeoBundleLazy 'koron/nyancat-vim', {
        \ 'autoload': {
        \   'commands': ['Nyancat2', 'Nyancat'] } }
  NeoBundleLazy 'koron/codic-vim', {
        \ 'autoload': {
        \   'commands': ['Codic'] } }
  NeoBundleLazy 'mattn/benchvimrc-vim', {
        \ 'autoload': {
        \   'commands': [{'complete': 'file', 'name': 'BenchVimrc'}] } }
  NeoBundleLazy 'mattn/gist-vim', {
        \ 'autoload': {
        \   'commands': ['Gist'] } }
  NeoBundleLazy 'mattn/vim-maketable', {
        \ 'autoload': {
        \   'commands': ['MakeTable' ] } }
  NeoBundleLazy 'mbbill/undotree', {
        \ 'autoload': {
        \   'commands': ['UndotreeToggle',
        \                'UndotreeShow',
        \                'UndotreeHide',
        \                'UndotreeFocus'] } }
  NeoBundleLazy 'mopp/AOJ.vim', {
        \ 'autoload': {
        \   'unite_sources': ['AOJ_Problems', 'AOJ_Statistics'],
        \   'commands': ['AOJSubmit',
        \                'AOJSubmitByProblemID',
        \                'AOJViewProblems',
        \                'AOJViewStaticticsLogs'] } }
  NeoBundleLazy 'osyo-manga/vim-anzu', {
        \ 'autoload': {
        \   'unite_sources': ['anzu'],
        \   'mappings': ['sxno', '<Plug>(anzu-'],
        \   'commands': ['AnzuUpdateSearchStatus',
        \                'AnzuClearSearchCache',
        \                'AnzuUpdateSearchStatusOutput',
        \                'AnzuClearSearchStatus',
        \                'AnzuSignMatchLine',
        \                'AnzuClearSignMatchLine'] } }
  NeoBundleLazy 'osyo-manga/vim-over', {
        \ 'autoload': {
        \   'mappings': ['n', '<Plug>(over-restore-'],
        \   'commands': ['OverCommandLineNoremap',
        \                'OverCommandLineMap',
        \                'OverCommandLine',
        \                'OverCommandLineUnmap'] } }
  NeoBundleLazy 'thinca/vim-scouter', {
        \ 'autoload': {
        \   'commands': [{'complete': 'file', 'name': 'Scouter'}] } }
  NeoBundleLazy 'tpope/vim-dispatch', {
        \ 'autoload' : {
        \   'commands' : ['Dispatch', 'FocusDispatch', 'Start'] }}
  NeoBundleLazy 'tyru/open-browser.vim', {
        \ 'autoload': {
        \   'mappings': ['sxn', '<Plug>(openbrowser-'],
        \   'commands': [ {
        \         'complete': 'customlist,openbrowser#_cmd_complete',
        \         'name': 'OpenBrowserSearch' }, {
        \         'complete': 'customlist,openbrowser#_cmd_complete',
        \         'name': 'OpenBrowserSmartSearch' }, 'OpenBrowser'] } }
  " depend-vimproc
  NeoBundleLazy 'Shougo/vimshell.vim', {'depends' : 'Shougo/vimproc'}
  NeoBundleLazy 'supermomonga/vimshell-pure.vim', {'depends' : 'Shougo/vimshell.vim'}
  NeoBundle     'thinca/vim-quickrun', { 'depends' : [ 'Shoguo/vimproc' ] }
  NeoBundleLazy 'yuratomo/w3m.vim', { 'autoload' : { 'commands' : [ 'W3mTab' ] } }
  " depend-unite
  NeoBundle     'basyura/unite-rails', { 'depends' : [ 'Shougo/unite.vim' ] }
  NeoBundle     'osyo-manga/unite-filetype', { 'depends' : [ 'Shougo/unite.vim' ] }
  NeoBundleLazy 'Shougo/unite-outline', {
        \ 'autoload': {
        \   'unite_sources': ['outline'] } }
  NeoBundleLazy 'yomi322/unite-tweetvim'

  " languages
  NeoBundleLazy 'MaxMEllon/ruby_matchit', {'autoload':{'filetypes':['ruby']}}
  NeoBundleLazy 'MaxMellon/plantuml-syntax', {'autoload':{'filetypes':['plantuml']}}
  NeoBundleLazy 'cakebaker/scss-syntax.vim', {
        \ 'autoload': {
        \   'filetypes': ['sass', 'css'] } }
  NeoBundleLazy 'elixir-lang/vim-elixir', {
        \ 'autoload': {
        \   'filetypes': ['elixir'] } }
  NeoBundleLazy 'groenewege/vim-less', {'autoload':{'filetypes':['less']}}
  NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':[ 'coffee' ]}}
  NeoBundleLazy 'keith/rspec.vim', {'autoload':{'filetypes':[ 'rspec' ]}}
  NeoBundleLazy 'NigoroJr/rsense', {
        \ 'autoload': {
        \   'filetypes': 'ruby', }, }
  NeoBundleLazy 'mattn/emmet-vim', {
        \ 'autoload':{
        \   'filetypes': ['html', 'php', 'markdown', 'coffee', 'js'] } }
  NeoBundleLazy 'mtscout6/vim-cjsx', {'autoload':{'filetypes':['coffee']}}
  NeoBundleLazy 'slim-template/vim-slim', {'autoload':{'filetypes':['slim']}}
  NeoBundle     'supermomonga/neocomplete-rsense.vim', {
        \ 'depends': ['Shougo/neocomplete.vim', 'marcus/rsense'],
        \ }
  NeoBundleLazy 'joker1007/vim-markdown-quote-syntax', {'autoload':{'filetyle':['markdown']}}
  NeoBundleLazy 'tmux-plugins/vim-tmux', {'autoload':{'filetypes':['conf','tmux']}}
  NeoBundleLazy 'vim-ruby/vim-ruby', {'autoload':{'filetypes':['ruby']}}
  NeoBundleLazy 'StanAngeloff/php.vim', {'autoload':{'filetypes':['php']}}
  NeoBundleLazy 'violetyk/neocomplete-php.vim', {'autoload':{ 'filetypes':['php']}}
  NeoBundle     'othree/javascript-libraries-syntax.vim'

  " framework
  NeoBundle     'tpope/vim-rails'

  " color
  NeoBundle     'MaxMellon/molokai'
  NeoBundleLazy 'altercation/vim-colors-solarized'
  NeoBundleLazy 'Wombat256.vim'
  NeoBundleLazy 'vim-scripts/twilight'
  " disalble
  " NeoBundle      'surround.vim'
  " NeoBundle      'm2mdas/phpcomplete-extended-laravel'
  " NeoBundle      'm2mdas/phpcomplete-extended'
  call neobundle#end()
  NeoBundleSaveCache
" }}}
endif
