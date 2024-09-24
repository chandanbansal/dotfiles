#!/usr/bin/env bash

if [ ! -f /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

echo "install applications"
# recommended, uses /Applications now.
brew tap homebrew/cask
brew install --cask sublime-text firefox spotify sequel-pro evernote openoffice menumeters notion slack vlc

# resolve possible coreutils conflict
brew unlink md5sha1sum || true

# Upgrade or install (logic necessary)
packages=(
    mysql-client
    coreutils
    ffmpeg
    git
    htop
    jq
    maven
    pass
    perl
    tree
    vim
    wget
)

for package in "${packages[@]}"; do
    brew upgrade $package || brew install $package
done
