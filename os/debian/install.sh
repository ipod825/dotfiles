sudo apt-get -y install acpi
sudo apt-get -y install xbacklight x11-xserver-utils
sudo apt-get -y install xdotool wmctrl libinput-tools sxhkd

if ! [ -x /usr/bin/libinput-gestures ]; then
    pushd /tmp
    sudo gpasswd -a $USER input
    git clone https://github.com/bulletmark/libinput-gestures.git
    cd libinput-gestures
    sudo make install
    popd
fi
sudo apt-get -y install dmenu dunst

sudo apt-get -y install i3-wm i3blocks i3lock rofi keynav xterm xautolock
sudo apt-get -y install ibus librime-bin ibus-rime python-gobject
sudo apt-get -y install zathura zathura-pdf-poppler sxiv
sudo apt-get -y install pulsemixer mpv mpd xclip copyq deepin-screenshot

sudo apt-get -y install libssl-dev
sudo apt-get -y install man zsh git sudo htop dtach

# # Not up-to-date. Install from source
# sudo apt-get -y install alttab
# sudo apt-get -y install qutebrowser
