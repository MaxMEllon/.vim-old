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

function! LoadHelp() "{{{
  helptags ~/.vim/help/vimdoc-ja/doc
  set runtimepath+=~/.vim/help/vimdoc-ja
  set helplang=ja
endfunction
  AutocmdFT help call LoadHelp()
nnoremap <silent> ,h :<C-u>call LoadHelp()<CR> :help <C-r><C-w><CR>
"}}}

" See: https://github.com/garybernhardt/dotfiles/blob/master/.vimrc#L471-L482
function! RemoveFancyCharacters() "{{{
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

command! RemoveFancyCharacters :call RemoveFancyCharacters()
"}}}

