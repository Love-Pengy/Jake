#!/bin/bash

# Thank you to this person: 
#   https://gist.github.com/singulared/7c6d53c1b84fbb7cf22d07c5c7d3e945?permalink_comment_id=3179677#gistcomment-3179677

JAKE=~/.config/sway/jakeSmol.png
LOCKARGS="--inside-color 00000000 --indicator-thickness 15 --indicator-radius 125 --key-hl-color 8fccf9 --ring-color fbf5b9 -f -e" 

for OUTPUT in `swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name'`
do
  IMAGE=/tmp/$OUTPUT-lock.png
  grim -o $OUTPUT $IMAGE
  convert -filter Gaussian -resize 25% -blur 0x1 -resize 400% $IMAGE $IMAGE 
  composite -gravity center $JAKE $IMAGE $IMAGE
  LOCKARGS="${LOCKARGS} --image ${OUTPUT}:${IMAGE}"
  IMAGES="${IMAGES} ${IMAGE}"
done
swaylock $LOCKARGS
rm $IMAGES
