if has('nvim')
  let &rtp = expand('~/.vim/') . ', '
        \  . expand('~/.vim/after/') . ', ' . &rtp
  runtime! plugin/python_setup.vim
endif
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = '/usr/local/bin/python3'

