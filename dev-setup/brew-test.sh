#! /bin/bash
# install brew
if [ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# install brew packages
brew install bat bat-extras dust eza fd fish ffmpeg fzf helix imagemagick jq gcc git-delta micro nu numbat poppler ripgrep sevenzip starship vivid wl-clipboard yazi zoxide
brew install --cask font-fira-code-nerd-font
