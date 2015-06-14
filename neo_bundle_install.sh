#/bin/sh
cd
ln -s ./vim/.vimrc
git clone git://github.com/Shougo/neobundle.vim .vim/bundle/neobundle.vim
git submodule update --init
vim +":NeoBundleInstall"+:q
