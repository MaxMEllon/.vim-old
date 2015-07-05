"---------------------------------------------------------------------------
" Autocmd:
"
aug filegroup
  au!
  au BufNewFile,BufRead *.md     set filetype=markdown
  au BufNewFile,BufRead *.slim   set filetype=slim
  au BufNewFile,BufRead *.less   set filetype=less
  au BufNewFile,BufRead *.coffee set filetype=coffee
  au BufNewFile,BufRead *.sass   set filetype=sass
  au BufNewFile,BufRead *.scss   set filetype=scss
  au BufNewFile,BufRead *.less   set filetype=less
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
aug END
augroup lastline
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END
