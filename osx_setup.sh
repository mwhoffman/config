#!/bin/bash

COMPUTER_NAME="MattsBookPro"

# setup the computer's name.
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

# install homebrew
HOMEBREW='/usr/local/homebrew'
sudo mkdir $HOMEBREW && sudo chown $USER $HOMEBREW
curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C $HOMEBREW
$HOMEBREW/bin/brew install coreutils

# allow keys to be held
defaults write -g ApplePressAndHoldEnabled -bool false

