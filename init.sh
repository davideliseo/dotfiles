#!/bin/sh

################################################################################
# Script de inicio para configurar un nuevo entorno de desarrollo.
# Probado en:
# Ubuntu 20.04 LTS (WSL 2, Windows 10 22H2)
################################################################################

# Abortar script en caso de error
set -ex

xdg_config() {
    ln -s $(pwd)/$1 $HOME/.config/$1
}

email="daviduribe998@gmail.com"
name="David Uribe"

sudo apt update && sudo apt upgrade -y
sudo apt reinstall libc-bin
sudo apt install curl -y

#######
# Git #
sudo apt install git gh -y
git config --global user.email "$email"
git config --global user.name "$name"
# TODO: Importar configuración

########
# Brew #
sudo apt install build-essential -y
yes "" | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install exa bat httpie

########
# Rust #
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

###########
# Node.js #
# https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
nvm install --lts
nvm use --lts
npm install -g npm@latest yarn

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
echo "eval '$(zoxide init bash)'" >> $HOME/.bashrc
echo "source /usr/share/doc/fzf/examples/key-bindings.bash" >> $HOME/.bashrc
echo "source /usr/share/doc/fzf/examples/completion.bash" >> $HOME/.bashrc

##########
# Neovim #
brew install neovim
xdg_config nvim

########
# Tmux #
sudo apt install tmux -y
xdg_config tmux

############
# Starship #
brew install starship
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
xdg_config starship

if [[ "$WSL_VIRT_ENGINE" == "docker" ]]; then
    ##########
    # Docker #
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done
    sudo apt install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    docker run hello-world
elif [[ "$WSL_VIRT_ENGINE" == "podman" ]]; then
    ##########
    # Podman #
    # https://linux.how2shout.com/how-to-install-podman-on-ubuntu-20-04-lts-focal-fossa/
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" |
        sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

    curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key" |
        sudo apt-key add -

    sudo apt update
    sudo apt install podman -y

    # https://github.com/containers/buildah/issues/3726#issuecomment-1171146242
    sudo mount --make-rshared /

    # Probar instalación de Podman
    podman search ubuntu

    # Instalación de Podman Compose
    sudo -H pip install podman-compose
else
    echo "No se especificó un motor de virtualización"
fi

# Convertir "/" en compartido
# https://github.com/containers/buildah/issues/3726#issuecomment-1171146242
sudo mount --make-rshared /

gh_auth() {
    ssh_key="$HOME/.ssh/ghid"
    read -p "Ingresa el access token de GitHub: " access_token
    echo "${access_token}" | gh auth login --with-token

    ssh-keygen -t ed25519 -f $ssh_key -C $email
    eval "$(ssh-agent -s)"
    ssh-add $ssh_key

    gh ssh-key add ${ssh_key}.pub --title "Ubuntu 22.04"
}