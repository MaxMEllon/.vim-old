#/bin/sh

set -eu

DOTPATH=~/.dotfiles

if [ -n "$1" ]; then
  DOTPATH=$1
fi

ln -s $1/vim ~/.vim &> /dev/null
ln -s ~/.vim/.vimrc ~/ &> /dev/null
ln -s ~/.vim/.vimshrc ~/ &> /dev/null
mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
cat > ~/.config/nvim/init.vim <<EOF
source ~/.vim/.nvimrc
source ~/.vim/.vimrc
EOF
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null
