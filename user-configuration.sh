#!/bin/bash
# This script configures the user account by copying dotfiles and running
# commands that result in persistent configuration changes.

#!/bin/bash
# This script configures the user account by copying dotfiles and running
# commands that result in persistent configuration changes.

if [ $SUDO_USER ] && [ $HOME != /etc/skel ]; then
    >&2 echo "This script must not be run via sudo (to avoid home directory file permission issues)"
    exit 1
fi

# exit on error
set -Eeo pipefail

cd $(dirname $0)

PLATFORM=$(uname)

test -d ~/.vim/ && rm -rf ~/.vim/

mkdir -p ~/.local/bin
mkdir -p ~/.ssh

# Ubuntu creates some annoying empty directories. Delete if empty.
rmdir Documents/ Pictures/ Public/ Videos/ &>/dev/null || true

# copy dotfiles separately , normal glob does not match
cp -r home/.??* ~
cp -a scripts/* ~/.local/bin/
cp etc/quotes.txt ~

PLATFORM=$(uname)

if [ $PLATFORM == 'Darwin' ]; then
    cp -r home/Library ~
    echo "setting mac properties"
  	#disable dialoge to same documents to cloud
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    #do not show warning while changing extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    #show extension of all files
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    #show all hidden files
    defaults write com.apple.finder AppleShowAllFiles TRUE
    chflags nohidden ~/Library/

    # stop preview from opening every PDF you've ever opened every time you view a PDF
    # (how did apple think this was a good idea!?!?!)
    defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false

    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Finder: show status bar, path bar, posix path
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # remove everything from dock (only active applications should be there, as
    # I use spotlight to launch apps with CMD+Space)
    defaults write com.apple.dock persistent-apps -array;
    defaults write com.apple.dock static-only -bool true;
    # Hence we don't need indicator for recent apps, as only active apps will be visible.
    defaults write com.apple.dock show-process-indicators -bool false;
    defaults write com.apple.dock autohide -bool true;
    #to reload Dock
    killall Dock;
fi


# if [ $PLATFORM == 'Darwin' ]; then
#     # 'Gah! Darwin!? XQuartz crashes in an annoying focus-stealing loop with this .xinirc. Removing...'
#     rm ~/.xinitrc
# elif [ -n "$DISPLAY" ] && which xrdb &>/dev/null; then
# 	xrdb -merge ~/.Xresources
#     xset -dpms
#     xset s 7200 7200
# fi


if [ -f ~/.bash_history ] && [ ! -f ~/.history ]; then
    cp ~/.bash_history ~/.history
fi


# set important permissions
touch ~/.history
touch ~/.ssh/known_hosts
touch ~/.ssh/authorized_keys
chmod 600 ~/.history
chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/config

# trust github pubkey
grep -q github.com ~/.ssh/known_hosts || cat <<EOF >> ~/.ssh/known_hosts
github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EOF

# customise firefox
#if PATH="$PATH:/Applications/Firefox.app/Contents/MacOS/" which firefox &> /dev/null; then
#    echo "setup firefox properties.."
#    etc/firefox/customise-profile
#fi

# Backup evernote
crontab -l > mycron
echo "00 01 * * * osascript ~/.local/bin/EvernoteBackup.scpt >/dev/null 2>&1" >> mycron 
cat mycron | uniq | tee mycron 
crontab mycron
rm mycron

# copy terminal font and rebuild font cache if necessary
if [ $PLATFORM == 'Darwin' ]; then
    mkdir -p ~/Library/Fonts
    cp etc/fonts/* ~/Library/Fonts/
else
    # list fonts with fc-list
    mkdir -p ~/.fonts
    cp etc/fonts/* ~/.fonts/
    if [ etc/fonts/Hack-Regular.ttf -nt ~/.fonts/Hack-Regular.ttf ]; then
        fc-cache -f -v
    fi
fi

