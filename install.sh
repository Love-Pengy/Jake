#!/bin/bash

#debug 
# set -x 

#Include 
source "progs.sh"

UHOME=$(getent passwd $SUDO_USER | cut -d: -f6)
echo $UHOME
install="apt-get install -y -qq"

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


## Install Rust |  requires user input
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install cargo 
$install cargo 

# Install Wallust 
cargo install wallust

# nerdfonts
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz
mkdir -p $UHOME/.local/share/fonts
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec cp {} $UHOME/.local/share/fonts \;
rm -rf ./ryanoasis-nerd-fonts-*

# PxPlus font
git clone https://github.com/Love-Pengy/PxPlus_IBM_VGA8_Nerd.git
mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf $UHOME/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGANerd

# obsidian
flatpak install md.obsidian.Obsidian/x86_64/stable

# vesktop
curl -s https://api.github.com/repos/Vencord/Vesktop/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d : -f 2,3 | tr -d \" | wget -qi -
$install ./vesktop_*_amd64.deb
rm vesktop_*_amd64.deb

# qmk
python3 -m pip install --user qmk 
qmk setup -H ~/Projects/qmk_firmware

exit 1
# ############# #
# Configuration # 
# ############# #

# Move dotfiles to their respective places
stow .

# Allow brightnessctl to work without sudo 
usermod -aG video ${USER} 

# Make random_bg script executable
chmod +x ~/.config/sway/random_bg
