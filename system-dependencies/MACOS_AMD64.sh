
if [ ! -f /usr/local/bin/brew ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
fi

brew tap homebrew/cask

#https://github.com/Toxblh/MTMR
#https://github.com/eczarny/spectacle
brew cask install mtmr spectacle sublime-text firefox spotify sequel-pro evernote

# resolve possible coreutils conflict
brew unlink md5sha1sum || true

# Upgrade or install (logic necessary)
packages=(
    bash    
    coreutils
    csshx
    ffmpeg
    git
    gnupg2
    htop
    jq
    maven
    mpssh
    openssl
    openssh
    pass
    perl
    python
    ssh-copy-id
    tmux
    tree
    vim
    wget
)

for package in "${packages[@]}"; do
    brew upgrade $package || brew install $package
done

# create alias for gsha256sum
ln -sf /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# browserpass host
TARGZ="$(
    obtain \
        https://github.com/browserpass/browserpass-native/releases/download/3.0.6/browserpass-darwin64-3.0.6.tar.gz \
        422bc6dd1270a877af6ac7801a75b4c4b57171d675c071470f31bc24196701e3
)"
[ -f /usr/local/bin/browserpass ] && sudo rm -f /usr/local/bin/browserpass
sudo tar -C /usr/local/bin/ --strip=1 -xzf "$TARGZ" browserpass-darwin64-3.0.6/browserpass-darwin64
sudo mv /usr/local/bin/browserpass-darwin64 /usr/local/bin/browserpass

