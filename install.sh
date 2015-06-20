#/bin/sh
ln -s ~/.vim/.vimrc ~/
ln -s ~/.vim/.vimshrc ~/
git submodule update --init
vim +":NeoBundleInstall"+:q
