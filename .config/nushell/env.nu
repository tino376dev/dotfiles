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
source ($nu.user-autoload-dirs | path join "theme.nu")

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
    let folder = $nu.user-autoload-dirs | get 0
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


# # colorize string
let mime_to_lang = {
    application/json: json,
    application/xml: xml,
    application/yaml: yaml,
    text/csv: csv,
    text/tab-separated-values: tsv,
    text/x-toml: toml,
    text/markdown: markdown,
}

$env.config.hooks.display_output = {
    metadata access {|meta| match $meta.content_type? {
        null => {}
        "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
        $mimetype if $mimetype in $mime_to_lang => { ^bat -Ppf --language=($mime_to_lang | get $mimetype) },
        _ => {},
    }}
    | if (term size).columns >= 100 { table -e } else { table }
}
