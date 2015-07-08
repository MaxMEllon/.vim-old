#/bin/sh
ln -s ~/.vim/.vimrc ~/
ln -s ~/.vim/.vimshrc ~/
git submodule update --init
if [ $# -eq 0 ]; then
  git checkout master
  vim +":NeoBundleInstall"+:q
elif [ $1 = "minimal" ]; then
  git checkout minimal-mode
  vim +":NeoBundleInstall"+:q
else
  echo "no such option ${1}"
fi
