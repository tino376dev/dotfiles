# Default Nushell Environment Config File
# These "sensible defaults" are set before the user's `env.nu` is loaded
#
# version = "0.101.0"
use std "path add"

def exists [] {which $in | is-not-empty}

# set up brew
let path = $env.HOME | path dirname | path join "linuxbrew" ".linuxbrew" "bin"
if ($path | path exists) {
    path add $path
    $env.HOMEBREW_NO_ENV_HINTS = true
}

# set up cargo
let path = $env.HOME | path dirname | path join "cargo" ".cargo" "bin"
if ($path | path exists) {path add $path}

# set up path
let path = $env.HOME | path join ".local" "bin"
if ($path | path exists) {path add $path}

# scipts
let path = $nu.default-config-dir | path join "modules"
if ($path | path exists) {path add $path}

# theming
let path = $nu.default-config-dir | path join "themes"
if ($path | path exists) {path add $path}
if ("vivid" | exists) {$env.LS_COLORS = (vivid generate catppuccin-mocha)}

# editor
if ("micro" | exists) {
    $env.EDITOR = which micro | get path.0
    $env.VISUAL = which micro | get path.0
}

# utils
if ("starship" | exists) {
    $env.STARSHIP_CONFIG = $env.HOME | path join ".config" | path join "starship" | path join "starship.toml"
}

if ("carapace" | exists) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
}

# topiary formatting
if ("topiary" | exists) {
    # Set environment variables according to the path of the clone
    $env.TOPIARY_CONFIG_FILE = ($env.HOME | path join "repos" "topiary" "languages.ncl")
    $env.TOPIARY_LANGUAGE_DIR = ($env.HOME | path join "repos" "topiary" "languages")
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

# colorize string
let mime_to_lang = {
    application/json: json,
    application/xml: xml,
    application/yaml: yaml,
    text/csv: csv,
    text/tab-separated-values: tsv,
    text/x-toml: toml,
    text/markdown: markdown,
}
if (which bat | is-not-empty) {
    $env.config.hooks.display_output = {
        metadata access {|meta| match $meta.content_type? {
            null => {}
            "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
            $mimetype if $mimetype in $mime_to_lang => { ^bat -Ppf --language=($mime_to_lang | get $mimetype) },
            _ => {},
        }}
        | if (term size).columns >= 100 { table -e } else { table }
    }
}

def vendor [
    binary: string
    init: string
] {
    if (not ($binary | exists)) {return}
    let file = $nu.vendor-autoload-dirs | last | path join $"($binary).nu"
    # let file = $nu.user-autoload-dirs | last | path join $"($binary).nu"
    if (not ($file | path exists)) {nu -c $"($binary) ($init) | save -f ($file)"}
}

vendor "zoxide" "init nushell"
vendor "starship" "init nu"
vendor "carapace" "_carapace nushell"
