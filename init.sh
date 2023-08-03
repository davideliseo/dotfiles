#!/bin/bash

################################################################################
# Script de inicio para configurar un nuevo entorno de desarrollo.
# Probado en:
# Ubuntu 20.04 LTS (WSL 2, Windows 10 22H2)
################################################################################

# Abortar script en caso de error
set -eux

sudo apt update && sudo apt upgrade -y
sudo apt install curl -y

#######
# Git #
sudo apt install git -y
# TODO: Importar configuración

########
# Brew #
if [[ $WSL_BREW != "off" ]]; then
     sudo apt install build-essential -y
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/$USER/.bashrc
     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
     brew install exa bat httpie
     WSL_BREW="off"
fi

########
# Rust #
if [[ $WSL_RUST != "off" ]]; then
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
     WSL_RUST="off"
fi

###########
# Node.js #
# https://github.com/nvm-sh/nvm
if [[ $WSL_NODE != "off" ]]; then
     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
     exec $SHELL
     nvm install --lts
     nvm use --lts
     npm install -g npm@latest yarn
     WSL_NODE="off"
fi

##########
# Python #
sudo apt install python3-pip -y
# TODO: Instalar miniconda

##########
# Zoxide #
brew install zoxide
# TODO: Importar historial de directorios

##########
# Ranger #
sudo apt install ranger -y
# TODO: Importar configuración

########
# TLDR #
brew install tldr
tldr -u

#######
# FZF #
# https://github.com/junegunn/fzf
sudo apt install fzf -y
echo 'eval "$(zoxide init bash)"' >> $HOME/.bashrc
echo 'source /usr/share/doc/fzf/examples/key-bindings.bash' >> $HOME/.bashrc
echo 'source /usr/share/doc/fzf/examples/completion.bash' >> $HOME/.bashrc

##########
# Neovim #
sudo apt install neovim -y
# TODO: Importar configuración

########
# Tmux #
sudo apt install tmux -y
# TODO: Importar configuración

##########
# Podman #
# https://linux.how2shout.com/how-to-install-podman-on-ubuntu-20-04-lts-focal-fossa/
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" \
     | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key" \
     | sudo apt-key add -

sudo apt update
sudo apt install podman -y

# https://github.com/containers/buildah/issues/3726#issuecomment-1171146242
sudo mount --make-rshared /

# Probar instalación de Podman
podman search ubuntu

# Instalación de Podman Compose
sudo -H pip install podman-compose

# Reiniciar shell
exec $SHELL

# Iniciar nueva sesión de Tmux
tmux new -s dev

# Limpia variables de entorno
clear() {
     unset $(compgen -v | grep "^WSL_")
}
