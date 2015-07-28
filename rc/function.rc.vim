"---------------------------------------------------------------------------
" Function:
"
function! CopyModeToggle() " {{{
  set nolist! number! relativenumber!
  GitGutterSignsToggle
  IndentLinesToggle
endfunction
nnoremap <silent> <F6> :<C-u>call CopyModeToggle()<CR>
nnoremap <silent> <C-c> :<C-u>call CopyModeToggle()<CR>
" }}}

function! HelpLoad() "{{{
  helptags ~/.vim/help/vimdoc-ja/doc
  set runtimepath+=~/.vim/help/vimdoc-ja
  set helplang=ja
endfunction
command! HelpLoad call HelpLoad()
" ,hで日本語ヘルプ
nnoremap <silent> ,h :<C-u>HelpLoad<CR> :<C-u>h <C-r><C-w><CR>
"}}}

