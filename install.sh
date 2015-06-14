#/bin/sh
ln -s ~/.vim/.vimrc ~/
git submodule update --init
vim +":NeoBundleInstall"+:q
