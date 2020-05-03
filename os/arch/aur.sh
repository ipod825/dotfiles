git clone https://aur.archlinux.org/trizen.git $HOME/opt/trizen
cd $HOME/opt/trizen
makepkg --needed --noconfirm -si

trizen -S --noconfirm --needed google-chrome alttab-git ttf-ancient-fonts libinput-gestures
sudo gpasswd -a $USER input
