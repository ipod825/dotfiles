sudo rm -rf /etc/X11/xorg.conf.d
sudo cp -r ./xorg.conf.d /etc/X11

# Automatic login to virtual console
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty -n -o mingo %I" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf 1> /dev/null

sudo rm /etc/alternatives/editor
sudo -E ln $HOME/opt/bin/nvim /etc/alternatives/editor
