if has('nvim')
  let &rtp = expand('~/.vim/') . ', '
        \  . expand('~/.vim/after/') . ', ' . &rtp
  runtime! plugin/python_setup.vim
endif
