# Default Nushell Environment Config File
# These "sensible defaults" are set before the user's `env.nu` is loaded
#
# version = "0.101.0"

# set up brew
if ("/home/linuxbrew/.linuxbrew/bin/brew" | path exists) {
    use std "path add"
    path add "/home/linuxbrew/.linuxbrew/bin"
    $env.HOMEBREW_NO_ENV_HINTS = true
}

# theming
if (which vivid | length) > 0 {
    $env.LS_COLORS = (vivid generate catppuccin-mocha)
}

# editor
if (which micro | length) > 0 {
    $env.EDITOR = which micro | get path.0
    $env.VISUAL = which micro | get path.0
}

# utils
if (which starship | length) > 0 {
    $env.STARSHIP_CONFIG = $env.HOME | path join ".config" | path join "starship" | path join "starship.toml" 
}
vendor "zoxide" "init nushell"
vendor "starship" "init nu"

def vendor [
    binary: string
    init: string
] {
    let folder = $nu.data-dir | path join "vendor/autoload/"
    let folder = $env.HOME | path join ".config" | path join "nushell" | path join "autoload"
    mkdir $folder
    let file = $folder | path join $"($binary).nu"
    if ($file | path exists) {return}
    let cmd = $"($binary) ($init) | save -f ($file)"
    $cmd | print
    nu -c $cmd
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
