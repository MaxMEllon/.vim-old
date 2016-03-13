#/bin/sh

ln -s ~/.vim/.vimrc ~/ &> /dev/null
ln -s ~/.vim/.vimshrc ~/ &> /dev/null
mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
cat > ~/.config/nvim/init.vim <<EOF
source ~/.vim/.nvimrc
source ~/.vim/.vimrc
EOF
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &> /dev/null
