#!/bin/bash

# fail on error
set -e

#debug 
set -x 

#Include 
source "progs.sh"

install="apt-get install -y -qq"

# ####################### #
# Important Starting Deps # 
# ####################### #

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

# install termusic 
sudo $install libmpv2-dev  
cargo install termusic-server --features mpv
cargo install termusic 

# Add Cargo binary location to path 
echo 'export PATH="$PATH:~/.cargo/bin"' >> ~/.bashrc

source ~/.bashrc

# obsidian
flatpak install md.obsidian.Obsidian/x86_64/stable

# vesktop
flatpak install dev.vencord.Vesktop 

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


# neovim 
runDir=$(PWD)
cd ~/Applications
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo 
cd $runDir


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

# Install qutebrowser
runDir=$(PWD)
apt install --no-install-recommends git ca-certificates python3 python3-venv libgl1 libxkbcommon-x11-0 libegl1 libfontconfig1 libglib2.0-0 libdbus-1-3 libxcb-cursor0 libxcb-icccm4 libxcb-keysyms1 libxcb-shape0 libnss3 libxcomposite1 libxdamage1 libxrender1 libxrandr2 libxtst6 libxi6 libasound2t64 
cd ~/Applications
git clone https://github.com/qutebrowser/qutebrowser.git
cd qutebrowser
python3 scripts/mkvenv.py
cd $runDir
sudo cp externalScripts/qutebrowser /usr/local/bin/qutebrowser 
