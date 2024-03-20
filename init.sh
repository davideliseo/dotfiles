#!/bin/bash

########################################################################
# Script de inicio para configurar un nuevo entorno de desarrollo.
# Probado en: MacBook Air M1 (Sonoma)
########################################################################

name="David Uribe"
email="daviduribe998@gmail.com"

DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

### BEGIN
# Abortar script en caso de error
set -ex
mkdir -p $HOME/.config

########
# Brew #
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

########
# Fish #
# https://github.com/fish-shell/fish-shell
brew install fish
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
fish=/opt/homebrew/bin/fish

mkdir -p $HOME/.config/fish
ln -sF $DIR/fish/config.fish $HOME/.config/fish/config.fish
rm -rf $HOME/.bashrc $HOME/.profile $HOME/.z**

#######
# Git #
# brew install git
git config --global user.email "$email"
git config --global user.name "$name"
# TODO: Importar configuración

########
# Fonts
brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono

##########
# Zoxide #
# https://github.com/ajeetdsouza/zoxide
brew install zoxide
# TODO: Importar historial de directorios

##########
# LF #
brew install lf
ln -sF $DIR/lf $HOME/.config/lf

########
# TLDR #
brew install tldr
tldr -u

########
# Tmux #
brew install tmux
ln -sF $DIR/tmux $HOME/.config/tmux

############
# Starship #
brew install starship
ln -sF $DIR/starship.toml $HOME/.config/starship.toml

##############
# GitHub CLI #
brew install gh

gh_auth() {
    ssh_key="$HOME/.ssh/ghid"
    read -p "Ingresa el access token de GitHub: " access_token
    echo "${access_token}" | gh auth login --with-token

    ssh-keygen -t ed25519 -f $ssh_key -C $email
    eval "$(ssh-agent -s)"
    ssh-add $ssh_key

    gh ssh-key add ${ssh_key}.pub --title "MBA M1"
}

##########
# Neovim #
brew install neovim
ln -sF $DIR/nvim $HOME/.config/nvim
nvim --headless "+Lazy! sync" +qa

#######
# FZF #
# https://github.com/junegunn/fzf
brew install fzf

########
# ASDF #
brew install asdf

###########
# Flutter #
brew install jq # Fixes https://github.com/oae/asdf-flutter/issues/44
$fish -c "
asdf plugin add flutter;
asdf install flutter latest;
asdf global flutter latest;
flutter config --disable-telemetry;
dart --disable-telemetry;"

###########
# Node #
$fish -c "
asdf plugin add nodejs;
asdf install nodejs latest;
asdf install nodejs 18.18.0;
asdf global nodejs 18.18.0;"

##########
# Python #
# TODO: Instalar miniconda
$fish -c "
asdf plugin add python;
asdf install python latest;
asdf global python latest;"

#######
# CLI #
brew install eza bat bottom trash massren ripgrep sqlite3
massren --config editor nvim && massren --config include_header 0

brew install surrealdb/tap/surreal

#######
# GUI #
brew install visual-studio-code iterm2-beta pictogram postman gitkraken orbstack spotify raycast arc keka android-studio
brew tap homebrew/cask-versions && brew install google-chrome-dev firefox-developer-edition

brew install rbenv ruby-build
rbenv install 3.2.2

# Faltantes:
# - Xcode
# - UnnaturalScrollWheels
# - AeroSpace
# - Tidal

################
# Shell extras #
$fish -c "
set -U fish_greeting;
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher;
fisher install wfxr/forgit # Interactive git: https://github.com/wfxr/forgit;
fish_update_completions;"

#########
# Fuentes #
sudo unzip -j $DIR/fonts/jetbrains-mono.zip -d /Library/Fonts

### END
