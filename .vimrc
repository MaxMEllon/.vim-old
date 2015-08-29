
"
"                    ##     ## #### ##     ## ########   ######
"                    ##     ##  ##  ###   ### ##     ## ##    ##
"                    ##     ##  ##  #### #### ##     ## ##
"                    ##     ##  ##  ## ### ## ########  ##
"                     ##   ##   ##  ##     ## ##   ##   ##
"                ###   ## ##    ##  ##     ## ##    ##  ##    ##
"                ###    ###    #### ##     ## ##     ##  ######
"

" init {{{
if !1 | finish | endif
if !&compatible | set nocompatible | endif

let mapleader='\'
augroup MyVimrc
  autocmd!
augroup END

" See: https://github.com/rhysd/dotfiles/blob/master/vimrc#23-27
command! -nargs=* Autocmd autocmd MyVimrc <args>
command! -nargs=* AutocmdFT autocmd MyVimrc FileType <args>

" Startup time.
" See: https://gist.github.com/thinca/1518874
if has('vim_starting') && has('reltime')
  let s:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter *
          \   echomsg 'startuptime: ' . reltimestr(reltime(s:startuptime))
          \ | unlet s:startuptime
  augroup END
endif

" easy source
" See: https://github.com/Shougo/shougo-s-github/blob/master/vim/vimrc#16-18
function! s:source_rc(path)
  execute 'source' fnameescape(expand('~/.vim/rc/' . a:path))
endfunction
" }}}

" source plugin
call s:source_rc('plugin.rc.vim')

call s:source_rc('plugin_config.rc.vim')

" minimal style {{{
" source minimal plugin
" call s:source_rc('minimal.plugin.rc.vim')

" source statusline
" call s:source_rc('statusline.rc.vim')
" }}}

" source set
call s:source_rc('set.rc.vim')

" encoding configure
" See: https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/encoding.rc.vim
call s:source_rc('encoding.rc.vim')

" source autocomd
call s:source_rc('autocmd.rc.vim')

" source function
call s:source_rc('function.rc.vim')

" source key-mapping
call s:source_rc('mapping.rc.vim')

" color {{{
try
  colorscheme molokai
  let g:molokai_original = 1
catch
  colorscheme desert
endtry
syntax on
"}}}


" vimrcの最後に記述 vimhelpより
set secure
