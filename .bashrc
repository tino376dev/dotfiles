# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# set up brew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export HOMEBREW_NO_ENV_HINTS=true
fi

if [ -x "$(command -v git)" ]; then
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fi

if [ -f ~/.local/share/blesh/ble.sh ]; then
    source ~/.local/share/blesh/ble.sh
fi

if [ -x "$(command -v vivid)" ]; then
    export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

if [ -x "$(command -v starship)" ]; then
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
    eval "$(starship init bash)"
fi

if [ -x "$(command -v micro)" ]; then
    export EDITOR=$(which micro)
    export VISUAL=$(which micro)
    # micro editor setting
    export  MICRO_TRUECOLOR=1
    # makes shortxcuts in micro work
    export TERM=xterm-256color
fi

if [ -x "$(command -v eza)" ]; then
    alias ll='eza -lah'
fi

if [ -x "$(command -v flatpak)" ]; then
    alias zed='flatpak run dev.zed.Zed'
    alias edge='flatpak run com.microsoft.Edge'
    alias zen='flatpak run io.github.zen_browser.zen'
fi

# eval "$(fzf --bash)"
# export=FZF_DEFAULT_COMMAND 'fd --color=always --hidden --follow --no-ignore --exclude .git "" ~'
# export FZF_DEFAULT_OPTS="\
# export FZF_COLOR="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a"
# export FZF_OPTS="--tmux 80% --layout=default $FZF_COLOR"
# export FZF_DEFAULT_OPTS=$FZF_OPTS
# export FZF_CTRL_R_OPTS=$FZF_OPTS
# export FZF_CTRL_T_OPTS=$FZF_OPTS
# export FZF_ALT_C_OPTS=$FZF_OPTS
