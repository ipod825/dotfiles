#!/bin/bash

print_usage() {
  printf "Flags:
          -g: specifies the gpg private file to set up gpg and unlock\n\ files
          in this repo crypted by git-crypt. "
}

while getopts 'g:h' flag; do
  case "${flag}" in
    g) gpg_key="${OPTARG}" ;;
    h) print_usage
       exit;;
  esac
done


DOTDIR="$(dirname `realpath $0`)"
cd $DOTDIR

echo "==Linking dotfiles=="
[ ! -d $XDG_CONFIG_HOME ] && mkdir $XDG_CONFIG_HOME

function LinkDotfiles {
    mkdir -p $2
    find "$1" -maxdepth 1 -mindepth 1 | rev | cut -d / -f 1 | rev | xargs -I{} rm -rf "$2"/{}
    find "$1" -maxdepth 1 -mindepth 1 | rev | cut -d / -f 1 | rev | xargs -I{} ln -sf "$1"/{} "$2"/{}
}

function pyenv_install(){
    pyenv install miniconda$1-latest
    export PYENV_VERSION=miniconda$1-latest
    conda update -q -y conda

    LD=$(pyenv root)/versions/miniconda$1-latest/compiler_compat/ld
    mv ${LD} ${LD}-old
    pip install -r $DOTDIR/misc/pyenv_default_packages
}

LinkDotfiles $DOTDIR/config $XDG_CONFIG_HOME
LinkDotfiles $DOTDIR/home_config ~
LinkDotfiles $DOTDIR/partial_config/.ssh ~/.ssh
LinkDotfiles $DOTDIR/partial_config/.local/share/applications ~/.local/share/applications

echo "==Setting pyenv=="
if [ ! -d $HOME/.pyenv ];then
    echo "Installing pyenv Dependencies:"
    export PATH="$HOME/.pyenv/bin:$PATH"
    git clone --depth 1 https://github.com/pyenv/pyenv.git ~/.pyenv
    git clone --depth 1 https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv_install 3
    pip install qutebrowser PyQt5 PyQtWebEngine
    pyenv global miniconda3-latest
fi


echo "==Setting qutebrowser=="
pip install qutebrowser PyQt5 PyQtWebEngine --upgrade

echo "==Setting kitty=="
mkdir -p $HOME/opt
if [ ! -d $HOME/opt/kitty.app ]; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin dest=$HOME/opt
fi

echo "==Setting neovim=="
if [ ! -x $HOME/opt/bin/nvim ]; then
    mkdir -p $HOME/opt/bin
    if [[ "$OSTYPE" == "darwin"* ]]; then
        wget -O /tmp/nvim-macos.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
        mkdir -p $HOME/opt/nvim
        tar -xf /tmp/nvim-macos.tar.gz -C $HOME/opt/nvim --strip-components 1
        ln -s $HOME/opt/nvim/bin/nvim $HOME/opt/bin
    else
        wget -O $HOME/opt/bin/nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    fi
    chmod u+x $HOME/opt/bin/nvim
fi
if [ ! -d config/nvim/bundle ];then
     $HOME/opt/bin/nvim +PlugInstall +qall
fi

if [ ! -z $gpg_key ]; then
    gpg-connect-agent KILLAGENT
    gpg --import $gpg_key
    echo "==Setting git-crypt=="
    if [ ! -x $HOME/opt/bin/git-crypt ]; then
          git clone --depth 1 https://github.com/AGWA/git-crypt.git /tmp/git-crypt
          pushd /tmp/git-crypt
          make -j 9
          make install PREFIX=$HOME/opt
          popd
    fi
    git-crypt unlock
fi

# echo -n "Install (compile from source) vim?(y/n):"
# read decision
# if [ $decision == "y" ]; then
#     echo "==Setting vim=="
#     if [ ! -x $HOME/opt/vim ]; then
#         bash ./vim_install.sh
#     fi
#     if [ ! -d home_config/.vim/bundle ];then
#         vim +PlugInstall +qall
#     fi
# fi
