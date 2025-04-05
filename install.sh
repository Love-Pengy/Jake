#!/bin/bash

# fail on error
set -e

#debug 
set -x 

#Include 
source "progs.sh"

#UHOME=$(getent passwd $SUDO_USER | cut -d: -f6)
install="apt-get install -y -qq"
nonRootBash="sudo -u $SUDO_USER bash -c"
nonRoot="sudo -u $SUDO_USER"

# ####################### #
# Important Starting Deps # 
# ####################### #
echo $HOME

# Sudo check
#if [[ $EUID > 0 ]]
#  then echo "Please run as root"
#  exit
#fi

# ##### #
# Setup # 
# ##### #

sudo apt-get update -qq && sudo apt-get upgrade -y -qq 

# My Preferred Folders
mkdir -p ~/Applications ~/Projects ~/Documents ~/Videos ~/Downloads 

# ################ #
# Package Download #
# ################ #

for package in ${programs[@]}; do 
  sudo $install $package
  if [ $? -ne 0 ]; then 
    echo "Package $package Failed"
    exit 1
  fi 
done 

# Install Local Send
curl -s https://api.github.com/repos/localsend/localsend/releases/latest | grep "browser_download_url.*linux-x86-64.deb" | cut -d : -f 2,3 | tr -d \" | wget -qi -
sudo $install ./LocalSend-*-linux-x86-64.deb
rm LocalSend-*-linux-x86-64.deb

# Install OBS
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update -qq
sudo $install obs-studio

# install rust and cargo
rustup install stable

# Install Wallust 
cargo install wallust

# Add Cargo binary location to path 
export PATH="$PATH:~/.cargo/bin"

source ~/.bashrc

# obsidian
flatpak install md.obsidian.Obsidian/x86_64/stable

mkdir -p ~/.local/share/fonts

# nerdfonts
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz && \
mkdir -p ~/.local/share/fonts && \
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec mv {} ~/.local/share/fonts \; 

rm -rf ./ryanoasis-nerd-fonts-*


# PxPlus font
git clone https://github.com/Love-Pengy/PxPlus_IBM_VGA8_Nerd.git
mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf ~/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd

# ############# #
# Configuration # 
# ############# #

# Move dotfiles to their respective places, adopts existing files then overrides them to what they should be 
stow . --adopt
git restore .

# Allow brightnessctl to work without sudo 
sudo usermod -aG video ${USER} 

# Make random_bg script executable
sudo chmod +x ~/.config/sway/random_bg
