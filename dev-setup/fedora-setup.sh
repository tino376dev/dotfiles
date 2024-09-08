#! /usr/bin/bash
sudo dnf -y install dnf-plugins-core fira-code-fonts
sudo dnf -y copr enable awood/bat-extras
sudo dnf -y copr enable atim/starship
sudo dnf -y install bat bat-extras curl eza fd-find fish fzf git git-delta micro nu ripgrep starship wget which xclip zoxide

# setup dotfiles
git clone --bare https://github.com/tino376dev/.dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

# install gui tools for workstation environment
if [ ! -f /.dockerenv ]; then

    # install alacritty and tmux
    sudo dnf -y install alacritty tmux
    wget "https://github.com/catppuccin/alacritty/raw/main/catppuccin-latte.toml" -O "$HOME/.config/alacritty/catppuccin-latte.toml"
    wget "https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml" -O "$HOME/.config/alacritty/catppuccin-mocha.toml"

    # install docker
    curl -fsSL https://get.docker.com | sh
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # install zed
    curl -f "https://zed.dev/install.sh" | sh
    
    # configure git
    git config --global user.name (read -P "git config name: ")
    git config --global user.email (read -P "git config name: ")

fi

# fish plugins/themes
curl   -sL "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" | source
fisher install jorgebucaran/fisher
fisher install PatrickF1/fzf.fish
fisher install catppuccin/fish

# bat themes
mkdir -p "$(bat --config-dir)/themes"
wget  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin Latte.tmTheme" -O "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme"
wget  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin Mocha.tmTheme" -O "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme"
bat cache --build

# micro themes
mkdir -p "$HOME/.config/micro/colorschemes"
wget  "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-latte.micro" -O "$HOME/.config/micro/colorschemes/catppuccin-latte.micro"
wget  "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-mocha.micro" -O "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro"
