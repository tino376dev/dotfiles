#!/usr/bin/fish

# add enable copr repos and install packages
sudo dnf -y copr enable awood/bat-extras
sudo dnf -y copr enable atim/starship
sudo dnf -y install bat bat-extras curl eza fd-find fontconfig fzf git git-delta micro ncurses ripgrep starship tmux wget which xclip

# install nerd fonts
mkdir -p $HOME/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraMono.tar.xz -O - | tar -xJ -C $HOME/.local/share/fonts \
fc-cache -v

# fish plugins/themes
if not test   -f  "$HOME/.config/fish/functions/fisher.fish"
       curl   -sL "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" | source
       fisher install jorgebucaran/fisher
       fisher install PatrickF1/fzf.fish
       fisher install catppuccin/fish
end

# bat themes
if not test  -d "$(bat --config-dir)/themes"
       mkdir -p "$(bat --config-dir)/themes"
       wget  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin Latte.tmTheme" -O "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme"
       wget  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin Mocha.tmTheme" -O "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme"
       bat cache --build
end

# micro themes
if not test  -d "$HOME/.config/micro/colorschemes"
       mkdir -p "$HOME/.config/micro/colorschemes"
       wget  "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-latte.micro" -O "$HOME/.config/micro/colorschemes/catppuccin-latte.micro"
       wget  "https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-mocha.micro" -O "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro"
end

# install gui tools for workstation environment
if not test -f /.dockerenv

    # install alacritty
    sudo dnf -y install alacritty

    # alacritty themes
    if not test -f "$HOME/.config/alacritty/catppuccin-latte.toml"
           wget "https://github.com/catppuccin/alacritty/raw/main/catppuccin-latte.toml" -O "$HOME/.config/alacritty/catppuccin-latte.toml"
           wget "https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml" -O "$HOME/.config/alacritty/catppuccin-mocha.toml"
    end

    # install zed
    if not test -d "$HOME/.local/zed.app"
           curl -f "https://zed.dev/install.sh" | sh
    end

end
