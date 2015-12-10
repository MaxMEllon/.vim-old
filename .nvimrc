if has('nvim')
  let &rtp = expand('~/.vim/') . ', '
        \  . expand('~/.vim/after/') . ', ' . &rtp
  runtime! plugin/python_setup.vim
endif
let g:python3_host_prog = expand('$HOME') . '/.pyenv/shims/python'
