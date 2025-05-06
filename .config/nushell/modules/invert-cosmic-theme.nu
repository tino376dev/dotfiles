let root = $env.HOME | path join ".config"
let system_theme = $root | path join "cosmic" "com.system76.CosmicTheme.Mode" "v1" "is_dark"

# cosmic
let flavor = match (open $system_theme) {"true" => "latte", "false" => "mocha"}
not (open $system_theme | into bool) | save -rf $system_theme

# bat
let themes = $root | path join "bat" "themes"
let config = $root | path join "bat" "config"
let url = $"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin ($flavor | str pascal-case).tmTheme"
$themes | fetch $url
$env.BAT_THEME = $"Catppuccin ($flavor | str pascal-case)"

# micro
let themes = $root | path join "micro" "colorschemes"
let config = $root | path join "micro" "settings.json"
let url = $"https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-($flavor).micro"
$themes | fetch $url
open $config | update "colorscheme" $"catppuccin-($flavor)" | save -f $config

# helix
let config = $root | path join "helix" "config.toml"
open $config | update "theme" $"catppuccin_($flavor)" | save -f $config

# yazi
let themes = $root | path join "yazi" "themes"
let config = $root | path join "yazi" "theme.toml"
let url = $"https://raw.githubusercontent.com/catppuccin/yazi/main/themes/($flavor)/catppuccin-($flavor)-green.toml"
let filename = $themes | fetch $url
cp $filename $config

# starship
let themes = $root | path join "starship" "themes"
let config = $root | path join "starship" "starship.toml"
let url = $"https://raw.githubusercontent.com/catppuccin/starship/main/themes/($flavor).toml"
let filename = $themes | fetch $url
open $config | update $.palettes.theme (open $filename | get (["palettes", $"catppuccin_($flavor)"] | into cell-path)) | save -f $config

# nushell
let themes = $root | path join "nushell" "themes"
let url = $"https://raw.githubusercontent.com/catppuccin/nushell/main/themes/catppuccin_($flavor).nu"
$themes | fetch $url
match $flavor {
  "latte" => (source ~/.config/nushell/themes/catppuccin_latte.nu)
  "mocha" => (source ~/.config/nushell/themes/catppuccin_mocha.nu)
}

# download theme
def fetch [url] {
  let path = $in
  mkdir $path
  let filename = $path | path join ($url | path basename)
  if not ($filename | path exists) {http get $url | save -f $filename}
  $filename
}
