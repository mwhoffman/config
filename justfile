set shell := ["bash", "-euo", "pipefail", "-c"]
set allow-duplicate-variables

home := home_directory()
os := os()

# Require these tools so we fail early if they don't exist.
_ := require("brew")
_ := require("git")
_ := require("stow")

# List the available recipes.
_default:
  @just --list

# Finish the bootstrap process.
_bootstrap: install dotfiles _gitconfig

# Stow dotfiles from "core" and os-specific packages.
dotfiles: (_link "core") (_link os)

# Link a single stow package, also removing links for files deleted upstream.
_link package:
  stow --no-folding -d dotfiles -t {{home}} -R {{package}}

# Install core packages [macos].
[macos]
install:
  brew bundle --file=Brewfile -q --no-upgrade
  @just _install-zsh-plugins
  @just _install-fonts

# Install core packages [linux].
[linux]
install:
  brew bundle --file=Brewfile -q --no-upgrade
  @just _apt-install zsh
  @just _install-zsh-plugins

# Install gui packages [linux].
[linux]
install-gui:
  @just _apt-install i3-wm polybar rofi
  @just _install-fonts

# Install any of the given apt packages that aren't already installed.
_apt-install *packages:
  #!/usr/bin/env bash
  set -euo pipefail
  missing=()
  for pkg in {{packages}}; do
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed" \
      || missing+=("$pkg")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    echo "# Installing (apt): ${missing[@]}"
    sudo apt-get install -y "${missing[@]}"
  fi

# Populate local git config with name/email.
_gitconfig:
  #!/usr/bin/env bash
  set -euo pipefail
  target={{home}}/.config/git/local
  if [ -f "$target" ]; then
    exit 0
  fi
  name=${GIT_NAME:-}
  email=${GIT_EMAIL:-}
  [ -n "$name" ] || read -rp "Git name: " name
  [ -n "$email" ] || read -rp "Git email: " email
  mkdir -p "$(dirname "$target")"
  echo "# Installing: $target"
  git config --file "$target" user.name "$name"
  git config --file "$target" user.email "$email"


# Install zsh plugins.
_install-zsh-plugins:
  #!/usr/bin/env bash
  set -euo pipefail
  dest={{home}}/.local/share/zsh
  mkdir -p "$dest"
  for repo in \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    jeffreytse/zsh-vi-mode
  do
    target="$dest/${repo#*/}"
    if [ ! -d "$target" ]; then
      echo "# Installing: $target"
      git clone -q "https://github.com/$repo" "$target"
    fi
  done

# Install nerd fonts.
_install-fonts:
  #!/usr/bin/env bash
  set -euo pipefail
  font_dir={{ if os == "macos" { home / "Library/Fonts" } else { home / ".local/share/fonts" } }}
  base=https://github.com/ryanoasis/nerd-fonts/releases/latest/download
  for font in Hack JetBrainsMono; do
    target="$font_dir/$font"
    if [ ! -d "$target" ]; then
      mkdir -p "$target"
      echo "# Installing: $target"
      curl -sSL "$base/$font.tar.xz" | tar -xJf - -C "$target"
    fi
  done
  if command -v fc-cache >/dev/null; then fc-cache; fi
