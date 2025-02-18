#! /usr/bin/bash

## setup

# directories
TEMP_DIR=$(mktemp -du)
TEMP_DIR="$HOME/dev-setup/test_bin"
FISH_COMPLETIONS_DIR="$HOME/.config/fish/completions"
LOCAL_BIN_DIR="$HOME/.local/bin"

# create directories
mkdir -p $TEMP_DIR
mkdir -p $FISH_COMPLETIONS_DIR

# get the latest release info from a github repo
get_latest_release_info() {
    local owner=$1
    local repo=$2
    local url="https://api.github.com/repos/$owner/$repo/releases/latest"
    curl -s $url | grep tag_name | sed 's/.*"tag_name": "\(.*\)".*/\1/'
}

get_download_url() {
    local owner=$1
    local repo=$2
    local latest=$3
    local file=$4
    echo "https://github.com/$owner/$repo/releases/download/$latest/$file"
}

release_urls() {
    local url=$1
    local file=$2
    echo ""
    echo $url
    echo $url >> $file
}

trim_file() {
    local file=$1
    echo "${file%%.tar.*}"
}

# create a versions file year-month-date prefix
script_dir=$(dirname "$(readlink -f "$0")")
releases="$(dirname "$(readlink -f "$0")")/versions_$(date +%Y-%m-%d).txt"
if [ -f "$releases" ]; then
    rm -f "$releases"
fi
touch -f $releases

## install binaries

# bat
owner="sharkdp"
repo="bat"
latest=$(get_latest_release_info $owner $repo)
file="bat-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/bat $LOCAL_BIN_DIR
cp -f $TEMP_DIR/$folder/autocomplete/bat.fish $FISH_COMPLETIONS_DIR

# bat-extras
owner="eth-p"
repo="bat-extras"
latest=$(get_latest_release_info $owner $repo)
file="bat-extras-$latest.zip"
folder="bat-extras-$latest"
url=$(get_download_url $owner $repo $latest $file | sed 's/bat-extras-v/bat-extras-/')
release_urls $url $releases
curl -L -o "$TEMP_DIR/$file" $url
mkdir -p "$TEMP_DIR/$folder"
unzip -qo -d "$TEMP_DIR/$folder" $TEMP_DIR/$file
cp -f $TEMP_DIR/$folder/bin/* $LOCAL_BIN_DIR

# delta
owner="dandavison"
repo="delta"
latest=$(get_latest_release_info $owner $repo)
file="delta-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/delta $LOCAL_BIN_DIR

 # dust
 owner="bootandy"
 repo="dust"
 latest=$(get_latest_release_info $owner $repo)
 file="dust-$latest-x86_64-unknown-linux-musl.tar.gz"
 folder=$(trim_file $file)
 url=$(get_download_url $owner $repo $latest $file)
 release_urls $url $releases
 curl -L $url | tar -xzf - -C $TEMP_DIR
 cp -f $TEMP_DIR/$folder/dust $LOCAL_BIN_DIR

# eza
owner="eza-community"
repo="eza"
latest=$(get_latest_release_info $owner $repo)
file="eza_x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/eza $LOCAL_BIN_DIR

# fd
owner="sharkdp"
repo="fd"
latest=$(get_latest_release_info $owner $repo)
file="fd-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/fd $LOCAL_BIN_DIR
cp -f $TEMP_DIR/$folder/autocomplete/fd.fish $FISH_COMPLETIONS_DIR

# fish
owner="fish-shell"
repo="fish-shell"
latest=$(get_latest_release_info $owner $repo)
latest="4.0b1"
file="fish-static-linux-x86_64.tar.xz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xJf - -C $TEMP_DIR
cp -f $TEMP_DIR/fish* $LOCAL_BIN_DIR

# fzf
owner="junegunn"
repo="fzf"
latest=$(get_latest_release_info $owner $repo)
file="fzf-$latest-linux_amd64.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file | sed 's/fzf-v/fzf-/')
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/fzf $LOCAL_BIN_DIR

# numbat
owner="sharkdp"
repo="numbat"
latest=$(get_latest_release_info $owner $repo)
file="numbat-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR # --strip-components=1 --wildcards '**/*numbat'
cp -f $TEMP_DIR/$folder/numbat $LOCAL_BIN_DIR
cp -rf $TEMP_DIR/$folder/modules $HOME/.config/numbat

# nushell
owner="nushell"
repo="nushell"
latest=$(get_latest_release_info $owner $repo)
file="nu-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/nu* $LOCAL_BIN_DIR

# micro
owner="zyedidia"
repo="micro"
latest=$(get_latest_release_info $owner $repo)
file="micro-$latest-linux64-static.tar.gz"
folder=$(echo "micro-$latest" | sed 's/micro-v/micro-/')
url=$(get_download_url $owner $repo $latest $file)
url=$(echo $url | sed 's/micro-v/micro-/')
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/micro $LOCAL_BIN_DIR

# ripgrep
owner="BurntSushi"
repo="ripgrep"
latest=$(get_latest_release_info $owner $repo)
file="ripgrep-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/rg $LOCAL_BIN_DIR
cp -f $TEMP_DIR/$folder/complete/rg.fish $FISH_COMPLETIONS_DIR

# # skim
# owner="skim-rs"
# repo="skim"
# latest=$(get_latest_release_info $owner $repo)
# file="skim-x86_64-unknown-linux-musl.tgz"
# folder=$(trim_file $file)
# url=$(get_download_url $owner $repo $latest $file)
# release_urls $url $releases
# curl -L $url | tar -xzf - -C $TEMP_DIR
# cp -f $TEMP_DIR/sk $LOCAL_BIN_DIR

# starship
owner="starship"
repo="starship"
latest=$(get_latest_release_info $owner $repo)
file="starship-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/starship $LOCAL_BIN_DIR

# vivid
owner="sharkdp"
repo="vivid"
latest=$(get_latest_release_info $owner $repo)
file="vivid-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file)
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/$folder/vivid $LOCAL_BIN_DIR

# zoxide
owner="ajeetdsouza"
repo="zoxide"
latest=$(get_latest_release_info $owner $repo)
file="zoxide-$latest-x86_64-unknown-linux-musl.tar.gz"
folder=$(trim_file $file)
url=$(get_download_url $owner $repo $latest $file | sed 's/zoxide-v/zoxide-/')
release_urls $url $releases
curl -L $url | tar -xzf - -C $TEMP_DIR
cp -f $TEMP_DIR/zoxide $LOCAL_BIN_DIR

## cleanup
rm -rf $TEMP_DIR

# fish plugin manager
~/.local/bin/fish -c curl -L "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"~/
