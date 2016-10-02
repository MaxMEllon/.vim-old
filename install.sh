#/bin/sh

# vim
ln -fs ~/.vim/.vimrc ~/ &> /dev/null
ln -fs ~/.vim/.vimshrc ~/ &> /dev/null
ln -fs ~/.vim/.xvimrc ~/ &> /dev/null
# neovim
mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
cat > ~/.config/nvim/init.vim <<EOF
source ~/.vim/.nvimrc
source ~/.vim/.vimrc
EOF
# nyaovim
mkdir -p ~/.config/nyaovim
ln -fs ~/.config/nyaovim/nyaovimrc.html
# vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &> /dev/null
