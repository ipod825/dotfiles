#!/bin/bash

print_usage() {
  printf "Flags:
          -g: specifies the gpg private file to set up gpg and unlock\n\ files
          in this repo crypted by git-crypt. "
}

while getopts 'g:hl' flag; do
  case "${flag}" in
    g) gpg_key="${OPTARG}" ;;
    l) install_lua="true" ;;
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
LinkDotfiles $DOTDIR/partial_config/Vieb ~/.config/Vieb

echo "==Setting pyenv=="
if [ ! -d $HOME/.pyenv ];then
    echo "Installing pyenv Dependencies:"
    export PATH="$HOME/.pyenv/bin:$PATH"
    git clone --depth 1 https://github.com/pyenv/pyenv.git ~/.pyenv
    git clone --depth 1 https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    git clone --depth 1 https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv_install 3
    pyenv global miniconda3-latest
fi

if [[ ! -x $HOME/.local/kitty.app/bin/kitty ]]; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi

echo "==Setting neovim=="
if [[ ! -d $HOME/.local/share/fonts ]]; then
    mkdir -p $HOME/.local/share/fonts
    cd $HOME/.local/share/fonts &&curl -fLo "Hack Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
fi
if [[ ! -x $HOME/.local/bin/nvim ]]; then
    mkdir -p $HOME/.local/bin
    if [[ "$OSTYPE" == "darwin"* ]]; then
        wget -O /tmp/nvim-macos.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
        mkdir -p $HOME/.local/nvim
        tar -xf /tmp/nvim-macos.tar.gz -C $HOME/.local/nvim --strip-components 1
        ln -s $HOME/.local/nvim/bin/nvim $HOME/.local/bin
    else
        wget -O $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    fi
    chmod u+x $HOME/.local/bin/nvim
    nvim -u $HOME/dotfiles/config/nvim/lua/plugins.lua +PlugInstall +qall
    pip install pynvim --upgrade
fi

if [[ ! -x $HOME/.local/bin/luarocks ]]; then
    echo "==Setting luarocks=="
    luarocks_version="3.9.0"
    echo $luarocks_version
    wget https://luarocks.org/releases/luarocks-${luarocks_version}.tar.gz
    tar zxpf luarocks-${luarocks_version}.tar.gz
    pushd luarocks-${luarocks_version}
    ./configure --prefix=$HOME/.local
    make && make install
    luarocks install penlight ldoc
fi

if [[ ! -z $gpg_key ]]; then
    gpg-connect-agent KILLAGENT
    gpg --import $gpg_key
    echo "==Setting git-crypt=="
    if [ ! -x $HOME/.local/bin/git-crypt ]; then
          git clone --depth 1 https://github.com/AGWA/git-crypt.git /tmp/git-crypt
          pushd /tmp/git-crypt
          make -j 9
          make install PREFIX=$HOME/.local
          popd
    fi
    git-crypt unlock
fi
