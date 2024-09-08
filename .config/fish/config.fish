set -g fish_greeting
set -x EDITOR micro
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if status is-interactive
    alias ll='eza -lah'
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    # starship config
    set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
    # micro
    set -x MICRO_TRUECOLOR 1
    set -x TERM xterm-256color
    # fzf
    set -x FZF_DEFAULT_OPTS " \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a \
    --multi --tmux 80% --layout default
    "
    set -x fzf_preview_dir_cmd eza  --color=always -laah
    set -x fzf_preview_file_cmd bat --color=always -n
    set -x fzf_diff_highlighter delta --paging=never --width=20
    set -x fzf_fd_opts --ignore-case --hidden --exclude .git --max-depth 6 --color=always
    set -x fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
    fzf_configure_bindings --directory=\cf --variables=\e\cv
    # zoxide
    zoxide init fish | source
end
