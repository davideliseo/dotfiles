#!/bin/sh

########################################################################
# Script de inicio para configurar un nuevo entorno de desarrollo.
# Probado en: MacBook Air M1 (Sonoma)
########################################################################

name="David Uribe"
email="daviduribe998@gmail.com"

### BEGIN
# Abortar script en caso de error
set -ex
mkdir -p ~/.config

########
# Brew #
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

########
# Fish #
# https://github.com/fish-shell/fish-shell
brew install fish
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
rm -rf ~/.bashrc ~/.profile ~/.z**
set -U fish_greeting
rm -f ~/.config/fish/config.fish
ln -s fish/config.fish ~/.config/fish/config.fish

# Fisher: Fish plugin manager
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

#######
# Git #
brew install git
git config --global user.email "$email"
git config --global user.name "$name"
# TODO: Importar configuración

##########
# Zoxide #
# https://github.com/ajeetdsouza/zoxide
brew install zoxide
# TODO: Importar historial de directorios

##########
# Ranger #
brew install ranger
# TODO: Importar configuración

########
# TLDR #
brew install tldr
tldr -u

########
# Tmux #
brew install tmux
ln -s tmux ~/.config/tmux

############
# Starship #
brew install starship
ln -s starship.toml ~/.config/starship.toml

##############
# GitHub CLI #
brew install gh

gh_auth() {
    ssh_key="~/.ssh/ghid"
    read -p "Ingresa el access token de GitHub: " access_token
    echo "${access_token}" | gh auth login --with-token

    ssh-keygen -t ed25519 -f $ssh_key -C $email
    eval "$(ssh-agent -s)"
    ssh-add $ssh_key

    gh ssh-key add ${ssh_key}.pub --title "Arch Linux (via OrbStack)"
}

##########
# Neovim #
brew install neovim
ln -s nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa

#######
# FZF #
# https://github.com/junegunn/fzf
brew install fzf

###########
# Flutter #
asdf plugin add flutter
brew install jq # Fixes https://github.com/oae/asdf-flutter/issues/44
asdf install flutter latest
asdf global flutter latest
flutter config --disable-telemetry

###########
# Flutter #
asdf plugin add nodejs
asdf install nodejs latest
asdf install nodejs 18.18.0
asdf global nodejs 18.18.0

##########
# Python #
# TODO: Instalar miniconda
asdf plugin add python
asdf install python latest
asdf global python latest

#######
# CLI #
brew install exa bat bottom

#######
# GUI #
brew install visual-studio-code iterm2 postman gitkraken orbstack spotify raycast arc keka android-studio xcodes
xcodes install --latest

################
# Shell extras #
fisher install wfxr/forgit # Interactive git: https://github.com/wfxr/forgit
fish_update_completions

#########
# Fonts #
sudo unzip -j fonts/jetbrains-mono.zip -d /Library/Fonts

### END
source ~/.config/fish/config.fish