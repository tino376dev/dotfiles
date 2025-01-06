set -g fish_greeting
if status is-interactive
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias clc='clear'
    if command -q kubectl
        alias kube='kubectl'
    end
    if command -q flatpak
        alias zed='flatpak run dev.zed.Zed'
        alias edge='flatpak run com.microsoft.Edge'
        alias zen='flatpak run io.github.zen_browser.zen'
    end
    # editor
    if command -q micro
        set -x EDITOR (which micro)
        set -x VISUAL (which micro)
    end
    # better ls (eza)
    if command -q eza
        alias ll='eza -lah'
    end
    # colors
    if command -q vivid
        set -Ux LS_COLORS $(vivid generate catppuccin-mocha)
    end
    # prompt
    if command -q starship
        set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
        starship init fish | source
    end
    # micro
    if command -q micro
        set -x MICRO_TRUECOLOR 1
        set -x TERM xterm-256color
    end

    # fzf
    if command -q fzf
        # fzf --fish | source
        set -x FZF_DEFAULT_OPTS " \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a \
        --multi --tmux 80% --layout default
        "
        set -x fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
        fzf_configure_bindings --directory=\cf --variables=\e\cv
        if command -q fd
            set -x fzf_fd_opts --ignore-case --hidden --exclude .git --max-depth 6 --color=always
        end
        if command -q eza
            set -x fzf_preview_dir_cmd eza  --color=always --icons=always -laah
        end
        if command -q bat
            set -x fzf_preview_file_cmd bat --color=always -n
        end
        if command -q delta
            set -x fzf_diff_highlighter delta --paging=never --width=20
        end
    end
    # zoxide
    if command -q zoxide
        zoxide init fish | source
    end
    # task
    set -x TASKRC ~/.config/task/config
    # set -x TASKDATA ~/.local/task
end
