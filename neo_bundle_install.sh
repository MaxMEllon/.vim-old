#/bin/sh
cd
ln -s ./vim/.vimrc
git clone git://github.com/Shougo/neobundle.vim .vim/bundle/neobundle.vim
cd ~/.vim/help
git clone https://github.com/vim-jp/vimdoc-ja.git
neo +":NeoBundleInstall"+:q
