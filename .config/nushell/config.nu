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

const file = $nu.default-config-dir | path join "themes" "catppuccin_mocha.nu"
if ($file | path exists) {source $file}
