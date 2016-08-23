let &rtp = expand('~/.vim/') . ', '
      \  . expand('~/.vim/after/') . ', ' . &rtp

runtime! plugin/python_setup.vim

let g:deoplete#enable_at_startup = 1
" let g:python3_host_prog = '/usr/local/bin/python3'
let g:python3_host_prog = '/Users/maxmellon/.pyenv/shims/python3'

tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <C-w><C-h> <C-\><C-n><C-w>h
tnoremap <C-w><C-j> <C-\><C-n><C-w>j
tnoremap <C-w><C-k> <C-\><C-n><C-w>k
tnoremap <C-w><C-l> <C-\><C-n><C-w>l
tnoremap <F2> <C-\><C-n>:<C-u>tabprevious<CR>
tnoremap <F3> <C-\><C-n>:<C-u>tabnext<CR>
tnoremap jj <C-\><C-n>
tnoremap <ESC> <C-\><C-n>
" nnoremap <Space>sh :<C-u>sp<CR>:<C-u>terminal<CR>

try
  " nvim-qt config
  command! SetWin set lines=80 | set columns=120
  command! -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  Guifont Ubuntu Mono:h14
catch
endtry

let g:playlist_directory = "~/Music/MyList"

