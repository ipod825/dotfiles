ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc --utc
echo -e "en_US.UTF-8 UTF-8\nen_US ISO-8859-1"> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo "mlap" > /etc/hostname

pacman -Syu
pacman -S --noconfirm --needed grub efibootmgr os-prober
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --recheck

pacman -S --noconfirm --needed pacman-contrib
systemctl enable paccache.timer


pacman -S --noconfirm --needed  xorg-server xorg-xinit
pacman -S --noconfirm --needed  acpi
pacman -S --noconfirm --needed  xf86-video-intel xorg-xbacklight xorg-xrandr
pacman -S --noconfirm --needed  xorg-xinput xdotool wmctrl xf86-input-libinput xorg-xkbcomp sxhkd
pacman -S --noconfirm --needed  dmenu dunst pass

pacman -S --noconfirm --needed networkmanager network-manager-applet
systemctl enable NetworkManager.service
# Discard unused blocks once a week
systemctl enable fstrim.timer


pacman -S --noconfirm --needed i3-wm i3blocks i3lock rofi keynav xterm xautolock
pacman -S --noconfirm --needed ibus librime ibus-rime python-gobject
pacman -S --noconfirm --needed zathura zathura-pdf-poppler sxiv
pacman -S --noconfirm --needed ttf-droid noto-fonts-cjk ttf-font-awesome
pacman -S --noconfirm --needed pulsemixer mpv mpd xclip copyq deepin-screenshot
pacman -S --noconfirm --needed easystroke
pacman -S --noconfirm --needed clang-format
pacman -S --noconfirm --needed ripgrep

# Set larget font for virtual console
sudo pacman -S --noconfirm --needed terminus-font
echo "FONT=ter-132n" | sudo tee /etc/vconsole.conf 1> /dev/null

echo "Setting root password..."
passwd

pacman -S --noconfirm --needed man zsh git ctags sudo htop openssh fuse2
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
useradd -mg users -G wheel,storage,power -s /usr/bin/zsh mingo

echo "Setting user password..."
passwd mingo
