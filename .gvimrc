if !IsWindows()
  set guifont=Ricty\ Discord\ Regular\ for\ Powerline:h18
else
  set guifont=Ricty_for_Powerline:h14
endif
set mousemodel=extend
set clipboard=unnamed
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=M
set guioptions-=m
set guioptions-=T
set guioptions-=C
set guioptions-=b
if has("gui_running")
  augroup GUI
    autocmd!
    autocmd GUIEnter * set fullscreen
  augroup END
endif
try
  set background=dark
  colorscheme molokai
catch
  colorscheme desert
endtry
syntax on
