if !IsWindows()
  set guifont=Ricty\ Discord\ Regular\ for\ Powerline:h18
else
  set guifont=Ricty_for_Powerline:h14
endif
set mouse&
set mousemodel=extend
set mouse+=a
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
  augroup END
endif
command! -nargs=* AutocmdGui autocmd GUI <args>
AutocmdGui GUIEnter * set fullscreen
try
  set background=dark
  colorscheme molokai
catch
  colorscheme desert
endtry
syntax on
