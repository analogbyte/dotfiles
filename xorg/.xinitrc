# load config
xrdb -merge ~/.Xresources

# desktop background
~/.fehbg

# set lockscreen hook
xss-lock -l ~/code/scripts/lock.sh &

# start caffeine
caffeine &

# set color shift
redshift -l 48.775846:9.182932 &

# start dockd
dockd --daemon &

# set touchpad scroll speed
xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Scrolling Distance" -120 -120

# time format for some programs
set -x LC_TIME de_DE.utf-8

# and go
exec i3
