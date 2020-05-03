#!/bin/bash


export D="$HOME/dotfiles"
export HC="$D/home_config"
export C="$D/config"
export A="$D/os/arch"
export M="$D/misc"

common="$HC/.zshrc $HC/.profile $HC/.xinitrc $HC/.Xresources \
        $C/i3/config $C/kitty/kitty.conf $C/libinput-gestures.conf $C/nvim/settings/rifle.conf $C/sxhkd/sxhkdrc* \
        $C/qutebrowser/config.py \
        $M/watchfiles.sh $M/cheatsheet \
        $A/postchroot.sh"

if [ "$1" == "vim" ]; then
    vimfiles="$HC/.vim/*.vim $HC/.vim/vimrc"
else
    vimfiles=$C/nvim/*.vim
fi
ls $common $vimfiles; ls -d $D $HC $C $A $M $D/bin;
