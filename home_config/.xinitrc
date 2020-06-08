xset r rate 200 40
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

$HOME/projects/keynav/keynav daemonize
libinput-gestures &
dunst &
# copyq &
xautolock -corners 00+- -cornerdelay 1 -cornerredelay 10 -time 20 -locker "i3lock -e -c 000000" -detectsleep &


[[ ! -f /etc/systemd/system/display-manager.service ]] && exec i3
