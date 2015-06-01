" MaxMEllon's .vimrc
"---------------------------------------------------------<-------------
"|       ##     ## #### ##     ## ########   ######       |             |＼
"|       ##     ##  ##  ###   ### ##     ## ##    ##      |             |  |
"|       ##     ##  ##  #### #### ##     ## ##            |             |  |
"|       ##     ##  ##  ## ### ## ########  ##            |             |  |
"|        ##   ##   ##  ##     ## ##   ##   ##            |             |  |
"|   ###   ## ##    ##  ##     ## ##    ##  ##    ##      |             |  |
"|   ###    ###    #### ##     ## ##     ##  ######       |             |  |
"---------------------------------------------------------<-------------   |
" ＼                                                        ＼           ＼
"   ---------------------------------------------------------<----------

" init {{{
let mapleader='\'
augroup MyAutoCmd
  autocmd!
augroup END

function! s:source_rc(path)
  execute 'source' fnameescape(expand('~/.vim/rc/' . a:path))
endfunction

set nocompatible               " Be iMproved
filetype off                   " Required!
" }}}

" source plugin
call s:source_rc('plugin.rc.vim')

" source set
call s:source_rc('set.rc.vim')

" quotation github:Shougo/shougo-s-github
"----------------------------------------------------------------------
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/encoding.rc.vim
call s:source_rc('encoding.rc.vim')

" highlight {{{
highlight ZenkakuSpace cterm=underline ctermfg=7
"ステータスラインの色を変更(ノーマルモード時)
highlight StatusLine ctermfg=black ctermbg=cyan
" }}}
" autocmd {{{
aug myvimrc
  au!
  au BufNewFile,BufRead *.md     set filetype=markdown
  au BufNewFile,BufRead *.slim   set filetype=slim
  au BufNewFile,BufRead *.less   set filetype=less
  au BufNewFile,BufRead *.coffee set filetype=coffee
  au BufNewFile,BufRead *.scss   set filetype=less
  au BufNewFile,BufRead *.pu     set filetype=plantuml
  au BufNewFile,BufRead *.cjsx   set filetype=coffee
  au BufNewFile,BufRead *.jflex  set filetype=jflex
  au Syntax jflex call s:source_rc('syntax/jflex.vim')
  au FileType *        setlocal formatoptions-=ro
  au FileType python   setlocal tabstop=8 noexpandtab shiftwidth=4 softtabstop=4
  au FileType make     setlocal tabstop=4 noexpandtab shiftwidth=4 softtabstop=4
  au FileType yaml     setlocal tabstop=4 expandtab   shiftwidth=4 softtabstop=4
  au FileType conf     setlocal tabstop=2 noexpandtab shiftwidth=2 softtabstop=2
  au FileType coffee   setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
  au FileType slim     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
  au FileType plantuml setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
  au InsertLeave        * match TrailingSpaces /\s\+$/
  au BufNewFile,BufRead * match ZenkakuSpace /  /
  au VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
aug END
" }}}
" Status-line{{{
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

