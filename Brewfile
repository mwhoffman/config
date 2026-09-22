# Installed with `brew bundle` on both macos and linux. Gui apps are macos-only
# (they're always wanted there); on linux those come from apt (see the justfile).

brew "fd"
brew "fzf"
brew "just"
brew "lazygit"
brew "neovim"
brew "ripgrep"
brew "stow"
brew "tmux"

if OS.mac?
  brew "coreutils"

  cask "1password"
  cask "hammerspoon"
  cask "jordanbaird-ice"
  cask "karabiner-elements"
  cask "kitty"
  cask "launchbar"
  cask "spotify"
end
