"---------------------------------------------------------------------------
" Function:
"
function! CopyModeToggle() " {{{
  set nolist! number! relativenumber!
  GitGutterSignsToggle
  IndentLinesToggle
endfunction
" }}}

function! CommentBlock(comment, ...) " {{{
  let introducer =  a:0 >= 1  ?  a:1  :  "//"
  let box_char   =  a:0 >= 2  ?  a:2  :  "*"
  let width      =  a:0 >= 3  ?  a:3  :  strlen(a:comment) + 2
  return introducer . repeat(box_char,width) . "\<CR>"
  \    . introducer . " " . a:comment        . "\<CR>"
  \    . introducer . repeat(box_char,width) . "\<CR>"
endfunction

"}}}

function! Scouter(file, ...) " {{{
" See: http://d.hatena.ne.jp/thinca/20091031/1257001194
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
      \  echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
" }}}
