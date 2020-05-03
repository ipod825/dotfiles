#!/bin/bash

# If using pyenv, you need to temporarily select system python version
if ! [ -z "$(command -v pyenv)" ]; then
  export PYENV_VERSION=system
fi

# Install dependencies
sudo apt-get install -y liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev

# (optional) clean old version, you don't need to do this if you install vim in specific path using --prefix flag
# sudo rm -rf /usr/local/share/vim /usr/bin/vim

git clone --depth 1 https://github.com/vim/vim /tmp/vimproeject
cd /tmp/vimproeject
cd src
make distclean
cd ..
make distclean

# Install vim on specific path. This should be in your $PATH variable
export PREFIX=$HOME/opt/vim

./configure \
--prefix=$PREFIX \
--enable-multibyte \
--enable-perlinterp=dynamic \
--enable-rubyinterp=dynamic \
--with-ruby-command=/usr/bin/ruby \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
--enable-luainterp \
--with-luajit \
--enable-cscope \
--enable-gui=auto \
--with-features=huge \
--with-x \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="yourname" \
--enable-fail-if-missing

make -j 9 && make install
