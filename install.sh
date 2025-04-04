#!/bin/bash

# fail on error
set -e

#debug 
#set -x 

#Include 
source "progs.sh"

UHOME=$(getent passwd $SUDO_USER | cut -d: -f6)
echo $UHOME
install="apt-get install -y -qq"
nonRootBash="sudo -u $SUDO_USER bash -c"
nonRoot="sudo -u $SUDO_USER"

# ####################### #
# Important Starting Deps # 
# ####################### #

# Sudo check
if [[ $EUID > 0 ]]
  then echo "Please run as root"
  exit
fi

# ##### #
# Setup # 
# ##### #

apt-get update -qq && apt-get upgrade -y -qq 

# My Preferred Folders
mkdir -p $UHOME/Applications $UHOME/Projects $UHOME/Documents $UHOME/Videos \
         $UHOME/Downloads 


# ################ #
# Package Download #
# ################ #

for package in ${programs[@]}; do 
  $install $package
  if [ $? -ne 0 ]; then 
    echo "Package $package Failed"
    exit 1
  fi 
done 

# Install Local Send
curl -s https://api.github.com/repos/localsend/localsend/releases/latest | grep "browser_download_url.*linux-x86-64.deb" | cut -d : -f 2,3 | tr -d \" | wget -qi -
$install ./LocalSend-*-linux-x86-64.deb
rm LocalSend-*-linux-x86-64.deb

# Install OBS
add-apt-repository ppa:obsproject/obs-studio
apt update
$install obs-studio

$nonRoot rustup install stable

# Install Wallust 
$nonRoot cargo install wallust

# obsidian
flatpak install md.obsidian.Obsidian/x86_64/stable

# nerdfonts
$nonRootBash "\
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz && \
mkdir -p $UHOME/.local/share/fonts && \
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec mv {} '$UHOME/.local/share/fonts' \;" 
rm -rf ./ryanoasis-nerd-fonts-*


# PxPlus font
$nonRootBash "git clone https://github.com/Love-Pengy/PxPlus_IBM_VGA8_Nerd.git"
$nonRoot mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf $UHOME/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd

# ############# #
# Configuration # 
# ############# #

# Move dotfiles to their respective places, adopts existing files then overrides them to what they should be 
$nonRoot stow . --adopt
$nonRoot git restore .

# Allow brightnessctl to work without sudo 
usermod -aG video ${USER} 

# Make random_bg script executable
$nonRootBash "chmod +x ~/.config/sway/random_bg"
