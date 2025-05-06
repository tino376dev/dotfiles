# Nushell Config File
#
# version = "0.101.0"
$env.config.show_banner = false

alias dotfiles = /usr/bin/git --git-dir=($env.HOME)/dotfiles/ --work-tree=($env.HOME)
alias ll = ls -la
alias zed = flatpak run dev.zed.Zed
alias edge = flatpak run com.microsoft.Edge
alias zen = flatpak run io.github.zen_browser.zen
alias dbx = distrobox
alias pdm = podman
alias fg = job unfreeze 1
alias linuxbrew = distrobox enter linuxbrew --additional-flags "-e HOMEBREW_NO_ENV_HINTS=true"

def vpn [] {let COOKIE = (openfortivpn-webview vpn.belimo.ch:443) ; echo $COOKIE | sudo openfortivpn --set-dns=1 --use-resolvconf=1 --cookie-on-stdin vpn.belimo.ch:443 --trusted-cert 2d79d1ccd22681522d1f2cf3f3401a82a0b207edd29867ac8fff227ff2e570cc}
def windows [] {$env.G_MESSAGES_DEBUG = "remmina"; flatpak run org.remmina.Remmina -c ~/.config/remmina/connections/windows.remmina}

def code-server-list [] {
    podman image list --filter reference=code-server* | from ssv | insert image {|it| $"($it.REPOSITORY):($it.TAG)"} | get image | sort
}

def podman-network-list [] {["podman", "host"]}

def code-server [host_work: string, --image: string@code-server-list = "localhost/code-server-nushell:latest-bookworm", --expose = false, --network: string@podman-network-list = "podman"] {
    let client_work = "/root/work"
    let host_code_config = $env.HOME | path join ".local" "share" "vscode"
    let client_code_config = "/root/.vscode-insiders"
    let host_code_server_config = $env.HOME | path join ".local" "share" "vscode-server"
    let client_code_server_config = "/root/.vscode-server-insiders"
    let host_nu_config = $env.HOME | path join ".config" "nushell"
    let client_nu_config = "/root/.config/nushell"
    let host_secrets = $env.HOME | path join ".secrets"
    let client_secrets = "/root/.secrets"
    podman stop vscode-server --ignore
    # podman run -it --rm --name vscode-server -v $"($host_work):($client_work):z" -v $"($host_code_config):($client_code_config):z" -v $"($host_code_server_config):($client_code_server_config):z" -v $"($host_nu_config):($client_nu_config):z" -v $"($host_secrets):($client_secrets):z" -p 8080:8080 $image
    podman run --network $network -it --rm --name vscode-server -v $"($host_work):($client_work):z" -v $"($host_code_config):($client_code_config):z" -v $"($host_code_server_config):($client_code_server_config):z" -v $"($host_nu_config):($client_nu_config):z" -v $"($host_secrets):($client_secrets):z" -p 8080:8080 $image
     # serve using ngrok
    if $expose {
        podman stop vscode-server-ngrok --ignore
        podman run --rm -it --name vscode-server-ngrok --env-file ~/.secrets/ngrok.txt ngrok/ngrok:latest http --url=informally-sunny-sunbird.ngrok-free.app --oauth google --oauth-allow-email=forest.reider@gmail.com host.containers.internal:8080
    }
}

# # completions
# let fish_completer = {|spans|
#     fish --command $'complete "--do-complete=($spans | str join " ")"'
#     | from tsv --flexible --noheaders --no-infer
#     | rename value description
# }

# let zoxide_completer = {|spans|
#     $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
# }

# {
#     __zoxide_z => $zoxide_completer
#     __zoxide_zi => $zoxide_completer
# }

# # This completer will use carapace by default
# let external_completer = {|spans|
#     let expanded_alias = scope aliases
#     | where name == $spans.0
#     | get -i 0.expansion

#     let spans = if $expanded_alias != null {
#         $spans
#         | skip 1
#         | prepend ($expanded_alias | split row ' ' | take 1)
#     } else {
#         $spans
#     }

#     match $spans.0 {
#         # carapace completions are incorrect for nu
#         nu => $fish_completer
#         # fish completes commits and branch names in a nicer way
#         git => $fish_completer
#         # carapace doesn't have completions for asdf
#         asdf => $fish_completer
#         # use zoxide completions for zoxide commands
#         __zoxide_z | __zoxide_zi => $zoxide_completer
#         _ => $fish_completer
#     } | do $in $spans
# }

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.external.enable = true
# $env.config.completions.external.completer = $external_completer

const file = $nu.default-config-dir | path join "theme.nu"
if ($file | path exists) {source $file}
