#!/bin/bash

########################################################################
# Ubuntu 22.04+
# Script de inicio para configurar un nuevo entorno de desarrollo.
# Probado en: ?
########################################################################

name="David Uribe"
email="daviduribe998@gmail.com"

DIR=$(dirname "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)")

### BEGIN
# Abortar script en caso de error
set -ex
mkdir -p $HOME/.config

sudo apt update && sudo apt upgrade
sudo apt install build-essential

echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

########
# Brew #
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/deliseo/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc

########
# Fish #
# https://github.com/fish-shell/fish-shell
sudo apt install fish
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

mkdir -p $HOME/.config/fish
ln -sfF $DIR/fish/config.fish $HOME/.config/fish/config.fish
# Instalar función fish_ssh_agent
wget https://gitlab.com/kyb/fish_ssh_agent/raw/master/functions/fish_ssh_agent.fish -P ~/.config/fish/functions/
rm -rf $HOME/.bashrc $HOME/.profile $HOME/.z**

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
# LF #
brew install lf
ln -sfF $DIR/lf $HOME/.config/lf

########
# TLDR #
brew install tldr
tldr -u

########
# Tmux #
brew install tmux
ln -sfF $DIR/tmux $HOME/.config/tmux

############
# Starship #
brew install starship
ln -sfF $DIR/starship.toml $HOME/.config/starship.toml

#######
# FZF #
# https://github.com/junegunn/fzf
brew install fzf

########
# ASDF #
brew install asdf

##########
# Neovim #
brew install neovim
ln -sfF $DIR/nvim $HOME/.config/nvim
nvim --headless "+Lazy! sync" +qa

###########
# Node #
fish -c "
asdf plugin add nodejs;
asdf install nodejs latest;
asdf install nodejs 18.18.0;
asdf global nodejs 18.18.0;"

# ##########
# # Python #
# # TODO: Instalar miniconda
# fish -c "
# asdf plugin add python;
# asdf install python latest;
# asdf global python latest;"

# ######
# .NET #
# ######
sudo apt install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0 dotnet-sdk-9.0 aspnetcore-runtime-9.0
dotnet tool install --global dotnet-ef

#######
# CLI #
brew install eza bat bottom trash-cli massren ripgrep sqlite3 lazygit
massren --config editor nvim && massren --config include_header 0

################
# Shell extras #
fish -c "
set -U fish_greeting;
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher;
fisher install wfxr/forgit # Interactive git: https://github.com/wfxr/forgit;
fish_update_completions;"

### END
