#!/usr/bin/bash

# Install Fedora with the following paritioning :
# 1. type: EFI                size:  ~500 MB  label: efi   mount point: /boot/efi
# 2. type: ext4               size: ~1000 MB  label: boot  mount point: /boot
# 3. type: btrfs (encrypted)  size:   big     label: ~     mount point: /
#
# Might be necessary to edit kernel parameters for it to boot on Wayland:
# - press e in Grub menu
# - add to the end of the line starting with linux: nomodeset

# basic cli pacakges
sudo dnf -y install dnf-plugins-core
sudo dnf -y copr enable awood/bat-extras
sudo dnf -y install bat bat-extras curl eza fd-find fish fzf git git-delta micro nu ripgrep wget which wl-clipboard xclip zoxide

# host config
if [ "$container" != "oci" ]; then

    # fish plugins/themes
    if [ ! -f  "$HOME/.config/fish/functions/fisher.fish" ]; then
        curl   -sL "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" | source
        fisher install jorgebucaran/fisher
        fisher install PatrickF1/fzf.fish
        fisher install catppuccin/fish
    fi

    # bat themes
    bat_config_dir=$(bat --config-dir)
    if [ ! -d "$bat_config_dir/themes" ]; then
        mkdir -p "$(bat --config-dir)/themes"
        wget  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin Latte.tmTheme" -O "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme"
        wget  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin Mocha.tmTheme" -O "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme"
        bat cache --build
    fi

    # micro themes
    if [ ! -d "$HOME/.config/micro/colorschemes" ]; then
        mkdir -p "$HOME/.config/micro/colorschemes"
        wget  "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-latte.micro" -O "$HOME/.config/micro/colorschemes/catppuccin-latte.micro"
        wget  "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-mocha.micro" -O "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro"
    fi

    # install zed
    if ! which zed &> /dev/null; then
        curl -f https://zed.dev/install.sh | ZED_CHANNEL=preview sh
    fi

    # configure git
    global_user_name=$(git config --global user.name)
    if [ -z "$global_user_name" ]; then
        git config --global user.name $(read -p "git config name: ")
        git config --global user.email $(read -p "git config name: ")
    fi

else

sudo dnf clean all

fi
