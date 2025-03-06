#!/bin/bash
grimshot save output /tmp/blurDesktop.png > /dev/null
convert -scale 10% -blur 0x.75 -resize 1000% /tmp/blurDesktop.png /tmp/blurDesktop.png  
convert /tmp/blurDesktop.png -gravity center ~/.config/sway/jakeSmol.png -composite /tmp/blurDesktop.png
swaylock --inside-color 00000000\
         --indicator-thickness 15\
         --indicator-radius 125\
         --key-hl-color 8fccf9\
         --ring-color fbf5b9\
         -f -e -i /tmp/blurDesktop.png
