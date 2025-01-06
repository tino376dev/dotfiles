#! /usr/bin/bash

# target directory
TARGET="$HOME/.local/bin"
# TARGET="$HOME/dev-setup/test_bin"

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


# # fish
# owner="fish-shell"
# repo="fish-shell"
# latest=$(get_latest_release_info $owner $repo)
# echo $latest
# latest="4.0b1"
# file="fish-static-linux-x86_64.tar.xz"
# url=$(get_download_url $owner $repo $latest $file)
# echo $url
# curl -L $url | tar -xvJf - -C $TARGET


# # nushell
# owner="nushell"
# repo="nushell"
# latest=$(get_latest_release_info $owner $repo)
# file="nu-$latest-x86_64-unknown-linux-musl.tar.gz"
# url=$(get_download_url $owner $repo $latest $file)
# curl -L $url | tar -xvzf - -C $TARGET --strip-components=1 --wildcards '**/nu*'


# # starship
# owner="starship"
# repo="starship"
# latest=$(get_latest_release_info $owner $repo)
# file="starship-x86_64-unknown-linux-musl.tar.gz"
# url=$(get_download_url $owner $repo $latest $file)
# curl -L $url | tar -xvzf - -C $TARGET


# # vivid
# owner="sharkdp"
# repo="vivid"
# latest=$(get_latest_release_info $owner $repo)
# file="vivid-$latest-x86_64-unknown-linux-musl.tar.gz"
# url=$(get_download_url $owner $repo $latest $file)
# curl -L $url | tar -xvzf - -C $TARGET --strip-components=1 --wildcards '**/vivid'


# # numbat
# owner="sharkdp"
# repo="numbat"
# latest=$(get_latest_release_info $owner $repo)
# file="numbat-$latest-x86_64-unknown-linux-musl.tar.gz"
# url=$(get_download_url $owner $repo $latest $file)
# curl -L $url | tar -xvzf - -C $TARGET --strip-components=1 --wildcards '**/*numbat'
# # include modules in the .config/numbat directory
# mkdir -p $HOME/.config/numbat
# curl -L $url | tar -xvzf - -C $HOME/.config/numbat --strip-components=1 --wildcards '**/*.nbt'


# # micro
# owner="zyedidia"
# repo="micro"
# latest=$(get_latest_release_info $owner $repo)
# file="micro-$latest-linux64-static.tar.gz"
# url=$(get_download_url $owner $repo $latest $file)
# url=$(echo $url | sed 's/micro-v/micro-/')
# curl -L $url | tar -xvzf - -C $TARGET --strip-components=1 --wildcards '**/micro'


# # eza
# owner="eza-community"
# repo="eza"
# latest=$(get_latest_release_info $owner $repo)
# file="eza_x86_64-unknown-linux-musl.tar.gz"
# url=$(get_download_url $owner $repo $latest $file)
# url=$(echo $url | sed 's/micro-v/micro-/')
# curl -L $url | tar -xvzf - -C $TARGET --strip-components=1
