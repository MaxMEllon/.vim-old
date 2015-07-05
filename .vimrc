
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
let mapleader='\'
augroup MyAutoCmd
  autocmd!
augroup END

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

" source set
call s:source_rc('set.rc.vim')

" encoding configure
" See: https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/encoding.rc.vim
call s:source_rc('encoding.rc.vim')

" source autocomd
call s:source_rc('autocmd.rc.vim')

" Status-line{{{
let g:hi_insert = 'highlight StatusLine ctermfg=red ctermbg=yellow cterm=NONE guifg=red guibg=yellow'
highlight StatusLine ctermfg=black ctermbg=cyan

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
if has('fugitive')
  set statusline=%<%f\ %h%m%r%{fugitive#statusline(}%=%-14.(%l,%c%V%)\ %P)
endif
"}}}

" source function
call s:source_rc('function.rc.vim')

" source key-mapping
call s:source_rc('mapping.rc.vim')

" color {{{
try
  colorscheme molokai
  let g:molokai_original = 1
catch
  colorscheme koehler
endtry
syntax on
"}}}

