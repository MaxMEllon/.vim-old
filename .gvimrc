if IsWindows()
  let &guifont = 'Ricty_for_Powerline:h14'
" elseif has('mac') && has('gui_running')
"   set macligatures
"   set guifont=FiraCode-Retina:h12
else
  let &guifont = 'Ricty_for_Powerline:h14'
  let &guifontwide = 'Ricty_for_Powerline:h14'
  " let &guifont = 'Ubuntu Mono:h14'
  " let &guifontwide = 'Ubuntu Mono:h14'
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
set guioptions-=e
set imdisable
augroup GUI
  autocmd!
augroup END
if has("gui_running")
  command! -nargs=* AutocmdGui autocmd GUI <args>
endif
" AutocmdGui GUIEnter * set fullscreen
set lines=60
set columns=120
syntax on
