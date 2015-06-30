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

