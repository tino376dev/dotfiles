#!/usr/bin/fish

# as a pre-requisite clone the dotfiles management repo to the home, e.g. as follows:
: '
# make sure basics are installed
sudo dnf install -y fish git

# setup dotfiles
git clone --bare https://github.com/tino376dev/.dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

# run setup
$HOME/dev-setup/setup.sh
'

# platform specific setup
if test -f /etc/fedora-release

    # fedora basics
    sudo dnf -y install dnf-plugins-core

    # setup fish script
    ~/dev-setup/fedora.sh

end

# configure git for workstation environment
if not test -f /.dockerenv

    git config --global user.name (read -P "git config name: ")
    git config --global user.email (read -P "git config name: ")

end
