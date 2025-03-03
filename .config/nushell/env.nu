# Default Nushell Environment Config File
# These "sensible defaults" are set before the user's `env.nu` is loaded
#
# version = "0.101.0"

$env.PROMPT_COMMAND = $env.PROMPT_COMMAND? | default {||
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

$env.PROMPT_COMMAND_RIGHT = $env.PROMPT_COMMAND_RIGHT? | default {||
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

if ("/home/linuxbrew/.linuxbrew/bin/brew" | path exists) {
    use std "path add"
    path add "/home/linuxbrew/.linuxbrew/bin"
    $env.HOMEBREW_NO_ENV_HINTS = true
}


if ((which vivid | length) > 0) {
    $env.LS_COLORS = (vivid generate catppuccin-mocha)
}

if ((which micro | length) > 0) {
    $env.EDITOR = which micro | get path.0
    $env.VISUAL = which micro | get path.0
}

vendor "zoxide" "init nushell"
vendor "starship" "init nu"

def vendor [
    binary: string
    init: string
] {
    let folder = $nu.data-dir | path join "vendor/autoload/"
    mkdir $folder
    let file = $folder | path join $"($binary).nu"
    if (which $binary | length) == 0 {
        if ($file | path exists) {rm $file}
        return
        }
    if ($file | path exists) {return}
    nu -c $"($binary) ($init) | save -f ($file)"
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
