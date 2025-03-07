set -g fish_greeting
if test -e /home/linuxbrew/.linuxbrew/Homebrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    set -x HOMEBREW_NO_ENV_HINTS true
end
set -gx PATH $HOME/.local/bin $PATH
if status is-interactive

    alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
    alias clc='clear'

    if command -q kubectl
        alias kube='kubectl'
    end

    if command -q flatpak
        alias zed='flatpak run dev.zed.Zed'
        alias edge='flatpak run com.microsoft.Edge'
        alias zen='flatpak run io.github.zen_browser.zen'
        alias vpn='set COOKIE $(openfortivpn-webview vpn.belimo.ch:443) ;and echo $COOKIE | sudo openfortivpn --set-dns=1 --use-resolvconf=1 --cookie-on-stdin vpn.belimo.ch:443'
        alias windows='flatpak run org.remmina.Remmina -c ~/.config/remmina/connections/windows.remmina'
    end

    # editor
    if command -q micro
        set -x EDITOR (which micro)
        set -x VISUAL (which micro)
    end

    # eza
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
        set -x FZF_DEFAULT_OPTS " \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a \
        --multi --tmux 80% --layout default
        "
        set -x fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

        fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp
        if command -q fd
            set -x fzf_fd_opts --ignore-case --hidden --exclude .git --max-depth 6 --color=always
        end

        if command -q eza
            set -x fzf_preview_dir_cmd eza --color=always --icons=always -laah
        end

        if command -q bat
            set -x fzf_preview_file_cmd bat --color=always -n
        end

        if command -q delta
            set -x fzf_diff_highlighter delta --paging=never --width=20
        end
    end

    # skim
    # if command -q sk
    #     skim_key_bindings
    #     set -x SKIM_DEFAULT_COMMAND fd .
    #     set -x SKIM_DEFAULT_OPTS --color=always
    #     set -x SKIM_TMUX_OPTS
    #     set -x SKIM_CTRL_T_COMMAND fd --type f .
    #     set -x SKIM_CTRL_T_OPTS --color=always
    #     set -x SKIM_CTRL_R_OPTS --color=always
    #     set -x SKIM_ALT_C_COMMAND fd --type
    #     set -x SKIM_ALT_C_OPTS --color=always
    # end

    # zoxide
    if command -q zoxide
        zoxide init fish | source
    end
    # task
    set -x TASKRC ~/.config/task/config
    # set -x TASKDATA ~/.local/task
end
