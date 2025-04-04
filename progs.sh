#!/bin/bash

# Programs needed for the entire system
programs=(
  ########
  # Core #
  ########

  "sway" 
  # NOTE: should come from pulseaudio 
  # "pactl" 
  "brightnessctl" 
  "grimshot" 
  "swayidle"  
  "swaylock" 
  "wl-clipboard" 
  "pipewire" 
  "pipewire-pulse" 
  "wlogout" 
  "dunst" 
  "tofi" 
  "waybar" 
  "kitty" 
  "hyfetch" 

  #########
  # Utils #
  #########

  "stow" 
  "samba-client" 
  "cifs-utils" 
  "firefox" 
  "tree" 
  "btop" 
  "ncdu" 
  "manpages-dev" 
  "manpages-posix-dev" 
  "ffmpeg" 
  "curl"

  ##########
  # Extras #
  #########

  "vlc" 
  "yt-dlp" 
  "network-manager" 
  "xdg-desktop-portal-wlr" 
  "v4l2loopback-dkms" 
  
  ###############
  # Pwogwamming #
  ##############
  
  "python3-pip"
  "rustup"
  "python3"
  "valgrind" 
  "gdb" 
  "ripgrep" 
  "fd-find" 
  "neovim"  
  "make" 
  "cmake" 
  "flatpak"  
  )
