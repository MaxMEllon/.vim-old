" ---------------------------------------------------------------------------
" MinimalPlugin:
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

call neobundle#begin(expand('~/.vim/bundle/'))
call neobundle#load_cache()

if s:meet_neocomplete_requirements()
  NeoBundle    'Shougo/neocomplete.vim'
else
  NeoBundle    'Shougo/neocomplcache.vim'
endif

NeoBundle      'MaxMellon/molokai'

NeoBundleSaveCache
call neobundle#end()

