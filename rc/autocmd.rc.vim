"---------------------------------------------------------------------------
" Autocmdtocmd:
"

" syntax
Autocmd BufNewFile,BufRead *.md      set filetype=markdown
Autocmd BufNewFile,BufRead *.slim    set filetype=slim
Autocmd BufNewFile,BufRead *.less    set filetype=less
Autocmd BufNewFile,BufRead *.coffee  set filetype=coffee
" Autocmd BufNewFile,BufRead *.sass    set filetype=sass
Autocmd BufNewFile,BufRead *.scss    set filetype=scss
Autocmd BufNewFile,BufRead *.less    set filetype=less
Autocmd BufNewFile,BufRead *.pu      set filetype=plantuml
Autocmd BufNewFile,BufRead *.cjsx    set filetype=coffee
Autocmd BufNewFile,BufRead *.exs     set filetype=elixir
Autocmd BufNewFile,BufRead *.ex      set filetype=elixir
Autocmd BufNewFile,BufRead *_spec.rb set filetype=rspec
Autocmd QuickFixCmdPost *grep* cwindow
Autocmd InsertLeave * set nopaste
AutocmdFT python   setlocal tabstop=8 noexpandtab shiftwidth=4 softtabstop=4
AutocmdFT php      setlocal tabstop=4 expandtab   shiftwidth=4 softtabstop=4
AutocmdFT make     setlocal tabstop=4 noexpandtab shiftwidth=4 softtabstop=4
AutocmdFT yaml     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT conf     setlocal tabstop=2 noexpandtab shiftwidth=2 softtabstop=2
AutocmdFT coffee   setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT slim     setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT plantuml setlocal tabstop=2 expandtab   shiftwidth=2 softtabstop=2
AutocmdFT html     inoremap <silent> <buffer> </ </<C-x><C-o>

" lastline
Autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "normal g`\"" | endif

" tails space highlight
Autocmd BufNewFile,BufRead,VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
Autocmd BufNewFile,BufRead,VimEnter,WinEnter * match TrailingSpaces /\s\+$/
