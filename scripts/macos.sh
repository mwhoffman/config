#!/bin/bash

defaults write -g com.apple.swipescrolldirection -bool false
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.controlcenter Sound -int 18
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

defaults write com.apple.dock persistent-apps -array

declare -a DOCK_APPS=(
  '/Applications/Google Chrome.app'
  '/Applications/kitty.app'
);

for APP in "${DOCK_APPS[@]}"; do
  defaults write com.apple.dock persistent-apps -array-add \
  "<dict>
    <key>tile-data</key>
    <dict>
      <key>file-data</key>
      <dict>
        <key>_CFURLString</key>
        <string>${APP}</string>
        <key>_CFURLStringType</key>
        <integer>0</integer>
      </dict>
    </dict>
  </dict>"
done

killall Finder
killall Dock
