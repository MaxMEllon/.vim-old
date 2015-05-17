#/bin/sh
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/_tmp
cd
git clone git://github.com/Shougo/neobundle.vim .vim/bundle/neobundle.vim
cd ~/.vim/help/vimdoc-ja
git clone https://github.com/vim-jp/vimdoc-ja.git
