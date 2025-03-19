#!/bin/bash
# grimshot save output /tmp/blurDesktop.png > /dev/null
grim /tmp/lockscreen.png &&\
convert -filter Gaussian -resize 25% -blur 0x1 -resize 400% /tmp/lockscreen.png /tmp/lockscreen.png
convert /tmp/lockscreen.png -gravity center ~/.config/sway/jakeSmol.png -composite /tmp/lockscreen.png
# convert -scale 25% -resize 400% -blur 0x1 /tmp/lockscreen.png /tmp/lockscreen.png  
# convert -blur 0x4 /tmp/lockscreen.png /tmp/lockscreen.png  
swaylock --inside-color 00000000\
         --indicator-thickness 15\
         --indicator-radius 125\
         --key-hl-color 8fccf9\
         --ring-color fbf5b9\
         -f -e -i /tmp/lockscreen.png


