# build filename
def fetch [url] {
  let path = $in
  mkdir $path
  let filename = $path | path join ($url | path basename)
  if not ($filename | path exists) {http get $url | save -f $filename}
  $filename
}

# config path
let root = $env.HOME | path join ".config"
let theme = "mocha"
# let theme = "latte"

# ghostty terminal
let themes = $root | path join "ghostty" "themes"
let config = $root | path join "ghostty" "config"
let url = $"https://raw.githubusercontent.com/catppuccin/ghostty/main/themes/catppuccin-($theme).conf"
$themes | fetch $url
open $config --raw | str replace 'theme = .*' $'theme = "catppuccin-($theme).conf"' --regex | save -f $config

# bat
let themes = $root | path join "bat" "themes"
let config = $root | path join "bat" "config"
let url = $"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin ($theme | str pascal-case).tmTheme"
$themes | fetch $url
bat cache --build
open $config --raw | str replace '--theme=.*' $'--theme="Catppuccin ($theme | str pascal-case)"' --regex | save -f $config

# micro
let themes = $root | path join "micro" "colorschemes"
let url = $"https://raw.githubusercontent.com/catppuccin/micro/main/src/catppuccin-($theme).micro"
$themes | fetch $url

# yazi
let themes = $root | path join "yazi" "themes"
let config = $root | path join "theme.toml"
let url = $"https://raw.githubusercontent.com/catppuccin/yazi/main/themes/($theme)/catppuccin-($theme)-green.toml"
let filename = $themes | fetch $url
cp $filename $config

# starship
let themes = $root | path join "starship" "themes"
let config = $root | path join "starship" "starship.toml"
let url = $"https://raw.githubusercontent.com/catppuccin/starship/main/themes/($theme).toml"
let filename = $themes | fetch $url
open $config --raw | str replace 'palette = .*' $'palette = "catppuccin_($theme)"' --regex | save -f $config
