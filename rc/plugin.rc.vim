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
  NeoBundle 'cohama/vim-hier'
  NeoBundle 'cohama/lexima.vim'
  NeoBundle 'dannyob/quickfixstatus'
  NeoBundle 'haya14busa/incsearch.vim'
  NeoBundle 'itchyny/lightline.vim'
  NeoBundle 'KazuakiM/vim-qfstatusline'
  " NeoBundle 'KazuakiM/vim-qfsigns'
  NeoBundle 'matchit.zip'
  NeoBundle 'mattn/webapi-vim'
  NeoBundle 'mhinz/vim-startify'
  NeoBundle 'osyo-manga/shabadou.vim'
  NeoBundle 'osyo-manga/vim-watchdogs'
  NeoBundle 'rhysd/clever-f.vim'
  " NeoBundle 'scrooloose/syntastic'
  NeoBundle 'soramugi/auto-ctags.vim'
  NeoBundle 'thinca/vim-singleton'
  " NeoBundle 'tpope/vim-endwise'
  NeoBundle 'tpope/vim-fugitive'
  NeoBundle 'tyru/caw.vim'
  NeoBundle 'vimtaku/hl_matchit.vim'
  NeoBundle 'yonchu/accelerated-smooth-scroll'
  NeoBundleLazy 't9md/vim-quickhl', {
        \ 'augroup':
        \   'QuickhlManual',
        \ 'autoload': {
        \   'mappings':
        \     [['sxn', '<Plug>(quickhl-']],
        \ 'commands': ['QuickhlManualUnlockWindow',
        \      'QuickhlManualDelete', 'QuickhlTagDisable',
        \     'QuickhlTagToggle', 'QuickhlManualDisable',
        \     'QuickhlManualAdd', 'QuickhlManualColors',
        \     'QuickhlManualReset', 'QuickhlManualLockToggle',
        \     'QuickhlManualLock', 'QuickhlManualEnable',
        \     'QuickhlManualList', 'QuickhlCwordEnable',
        \     'QuickhlManualUnlock', 'QuickhlCwordDisable',
        \     'QuickhlTagEnable', 'QuickhlManualLockWindowToggle',
        \     'QuickhlManualLockWindow', 'QuickhlCwordToggle']}}
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
  NeoBundleLazy 'easymotion/vim-easymotion', {
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
  NeoBundleLazy 'ctrlpvim/ctrlp.vim', {
        \ 'autoload': {
        \   'commands': ['CtrlPMixed', 'CtrlPClearAllCaches', 'CtrlPCurWD',
        \                'CtrlP', 'CtrlPRTS', 'CtrlPBuffer', 'CtrlPMRUFiles',
        \                'CtrlPBookmarkDirAdd', 'CtrlPDir', 'CtrlPRoot',
        \                'CtrlPChange', 'ClearCtrlPCache', 'CtrlPLine',
        \                'ClearAllCtrlPCaches', 'CtrlPBufTagAll',
        \                'CtrlPClearCache', 'CtrlPQuickfix', 'CtrlPBufTag',
        \                'CtrlPTag', 'CtrlPCurFile', 'CtrlPLastMode',
        \                'CtrlPUndo', 'CtrlPChangeAll', 'CtrlPBookmarkDir']}}
  NeoBundleLazy 'junegunn/vim-easy-align', {
        \ 'autoload': {
        \   'mappings': ['<Plug>(EasyAlignOperator)',
        \                 ['sxn', '<Plug>(EasyAlign)'],
        \                 ['sxn', '<Plug>(LiveEasyAlign)'],
        \                 ['sxn', '<Plug>(EasyAlignRepeat)']],
        \   'commands': ['EasyAlign', 'LiveEasyAlign'] } }
  NeoBundleLazy 'kana/vim-altr', {
        \ 'autoload': {
        \   'filetypes' : ['c', 'cpp'],
        \   'mappings': [['scxino', '<Plug>(altr-']]}}
  NeoBundleLazy 'koron/nyancat-vim', {
        \ 'autoload': {
        \   'commands': ['Nyancat2', 'Nyancat'] } }
  NeoBundleLazy 'koron/codic-vim', {
        \ 'autoload': {
        \   'commands': ['Codic'] } }
  NeoBundleLazy 'mattn/benchvimrc-vim', {
        \ 'autoload': {
        \   'commands': [{'complete': 'file', 'name': 'BenchVimrc'}] } }
  NeoBundleLazy 'mattn/emoji-vim', {
        \ 'autoload': {
        \   'mappings': [['in', '<Plug>(emoji-selector-']],
        \   'commands': ['Emoji']}}
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
  NeoBundleLazy 'osyo-manga/vim-reunions'
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
  NeoBundleLazy 'terryma/vim-multiple-cursors', {
        \ 'autoload': {
        \   'mappings': [['xin', '<Plug>(multiple-cursors-']],
        \   'commands': ['MultipleCursorsFind']}}
  NeoBundleLazy 'thinca/vim-scouter', {
        \ 'autoload': {
        \   'commands': [{'complete': 'file', 'name': 'Scouter'}] } }
  NeoBundleLazy 'thinca/vim-ref', {
        \ 'autoload': {
        \   'unite_sources': ['ref'],
        \   'mappings': [['sxn', '<Plug>(ref-keyword)']],
        \   'commands': [{
        \     'complete':
        \       'customlist,ref#complete',
        \       'name': 'Ref'},
        \       'RefHistory']}}
  NeoBundleLazy 'tpope/vim-dispatch', {
        \ 'autoload' : {
        \   'commands' : ['Dispatch', 'FocusDispatch', 'Start'] }}
  NeoBundleLazy 'tyru/capture.vim', {
        \ 'autoload': {
        \   'commands': [{
        \     'complete': 'command', 'name': 'Capture'}]}}
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
  NeoBundleLazy 'thinca/vim-quickrun', {
        \ 'autoload': {
        \   'mappings': [['sxn', '<Plug>(quickrun']],
        \   'commands': [{'complete': 'customlist,quickrun#complete'
        \ ,               'name': 'QuickRun'}]}}
  NeoBundleLazy 'yuratomo/w3m.vim', { 'autoload' : { 'commands' : [ 'W3mTab' ] } }
  " depend-unite
  NeoBundle     'basyura/unite-rails', {'autoload': {'unite_sources': ['rails']}}
  NeoBundle     'MaxMEllon/unite-rails-fat', { 'depends' : [ 'basyura/unite-rails' ] }
  NeoBundle     'osyo-manga/unite-filetype', { 'depends' : [ 'Shougo/unite.vim' ] }
  NeoBundleLazy 'Shougo/unite-outline', {
        \ 'autoload': {
        \   'unite_sources': ['outline'] } }
  NeoBundleLazy 'osyo-manga/unite-quickfix',{
        \ 'autoload': {
        \   'unite_sources': ['location_list', 'q', 'quickfix']}}
  NeoBundleLazy 'yomi322/unite-tweetvim'

  " languages {{{
  " css " {{{
  NeoBundleLazy 'groenewege/vim-less', {'autoload':{'filetypes':['less']}}
  NeoBundleLazy 'AtsushiM/sass-compile.vim', { 'autoload': { 'filetypes': ['sass'] } }
  " }}}

  " js " {{{
  NeoBundleLazy 'mattn/jscomplete-vim', {'autoload':{'filetypes':[ 'js', 'coffee' ]}}
  NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':[ 'coffee','slim']}}
  NeoBundleLazy 'mtscout6/vim-cjsx', {'autoload':{'filetypes':['coffee']}}
  NeoBundleLazy 'othree/javascript-libraries-syntax.vim' , {
        \ 'autoload':{
        \   'filetypes': ['html', 'coffee', 'js'] } }
  " }}}

  " html {{{
  NeoBundleLazy 'mattn/emmet-vim', {
        \ 'autoload':{
        \   'filetypes': ['html', 'php', 'markdown', 'coffee', 'js'] } }
  NeoBundleLazy 'slim-template/vim-slim', {'autoload':{'filetypes':['slim']}}
  " }}}

  " ruby {{{
  NeoBundleLazy 'keith/rspec.vim', {'autoload':{'filetypes':[ 'rspec' ]}}
  NeoBundleLazy 'vim-ruby/vim-ruby', {'autoload':{'filetypes':['ruby']}}
  " if executable('rct-complete')
  "   " NeoBundleLazy 'osyo-manga/vim-monster', {'autoload':{'filetype': ['ruby']}}
  " else
  NeoBundleLazy 'NigoroJr/rsense', { 'autoload': { 'filetypes': 'ruby', }, }
  " endif
  " NeoBundleLazy 'MaxMEllon/ruby_matchit', {'autoload':{'filetypes':['ruby']}}
  if has('ruby')
    NeoBundle 'todesking/ruby_hl_lvar.vim'
  endif
  NeoBundleLazy 'supermomonga/neocomplete-rsense.vim', {
        \ 'depends': ['Shougo/neocomplete.vim', 'marcus/rsense'],
        \ 'autoload' : {'filetypes': ['ruby']} }
  " }}}

  " php {{{
  NeoBundleLazy 'm2mdas/phpcomplete-extended', {
        \ 'autoload': {'unite_sources': ['phpcomplete']}}
  NeoBundleLazy 'StanAngeloff/php.vim', {'autoload':{'filetypes':['php']}}
  NeoBundleLazy 'violetyk/neocomplete-php.vim', {'autoload':{ 'filetypes':['php']}}
  NeoBundleLazy 'PDV--phpDocumentor-for-Vim', {'autoload':{'filetypes':['php']}}
  " }}}

  " cpp {{{
  NeoBundleLazy 'osyo-manga/vim-marching',  {
        \ 'depends' : ['Shougo/vimproc',  'osyo-manga/vim-reunions'],
        \ 'autoload' : {'filetypes' : ['c', 'cpp'] } }
  NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', {
        \ 'autoload' : {'filetypes' : ['c',  'cpp']} }
  NeoBundleLazy 'vim-jp/cpp-vim', {
        \ 'autoload' : {'filetypes' : ['c', 'cpp']} }
  " }}}

  " etc " {{{
  NeoBundleLazy 'MaxMellon/plantuml-syntax', {'autoload':{'filetypes':['plantuml']}}
  NeoBundle     'chase/vim-ansible-yaml'
  NeoBundleLazy 'elixir-lang/vim-elixir', { 'autoload': { 'filetypes': ['elixir'] } }
  NeoBundleLazy 'tmux-plugins/vim-tmux', {'autoload':{'filetypes':['conf','tmux']}}
  " }}}
  " }}}

  " textobj
  NeoBundle 'surround.vim'
  NeoBundle 'glts/vim-textobj-comment'
  NeoBundle 'kana/vim-textobj-fold'
  NeoBundle 'kana/vim-textobj-line'
  NeoBundle 'kana/vim-textobj-user'
  NeoBundle 'mattn/vim-textobj-url'
  NeoBundle 'rhysd/vim-textobj-ruby'
  NeoBundle 'osyo-manga/vim-textobj-multiblock'

  " framework
  NeoBundle     'tpope/vim-rails'

  " color
  NeoBundle     'MaxMellon/molokai'
  NeoBundleLazy 'altercation/vim-colors-solarized'
  NeoBundleLazy 'Wombat256.vim'
  NeoBundleLazy 'vim-scripts/twilight'
  " disalble
  " NeoBundle     'rhysd/vim-operator-surround'
  " NeoBundle     'm2mdas/phpcomplete-extended-laravel'
  " NeoBundle     'kana/vim-smartinput'
  call neobundle#end()
  NeoBundleSaveCache
" }}}
endif

