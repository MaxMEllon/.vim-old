#/bin/sh
cd
git clone git://github.com/Shougo/neobundle.vim .vim/bundle/neobundle.vim
cd ~/.vim/help
git clone https://github.com/vim-jp/vimdoc-ja.git
neo +":NeoBundleInstall"+:q
