"---------------------------------------------------------------------------
" Function:
"
function! CopyModeToggle() " {{{
  setlocal nolist! number! relativenumber!
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

" See: http://cohama.hateblo.jp/entry/2013/08/11/020849
" SyntaxInfo {{{
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
" }}}

