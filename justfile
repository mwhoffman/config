set shell := ["bash", "-euo", "pipefail", "-c"]
set allow-duplicate-variables

home := home_directory()
os := os()

# Environment variables can be set which affect the setup process.
# MWCONFIG_GUI set to any true value will install GUI packages as if `just
# install --gui` was run; an empty value, 0, false, no, off or nil means off.
# MWCONFIG_GIT_NAME and MWCONFIG_GIT_EMAIL specify name and email for git.

gui_env := lowercase(env("MWCONFIG_GUI", ""))
gui_default := if gui_env =~ '^(|false|no|off|nil|0)$' {
  "false"
} else {
  "true"
}
git_name := env("MWCONFIG_GIT_NAME", "")
git_email := env("MWCONFIG_GIT_EMAIL", "")

# Require these tools so we fail early if they don't exist.
_ := require("brew")
_ := require("git")
_ := require("stow")

# Stow dotfiles.
dotfiles: (_link "core") (_link os) _gitconfig

# Link a single stow package, also removing links for files deleted upstream.
_link package:
  @echo "📦 Installing dotfiles: {{package}}"
  @stow --no-folding -d dotfiles -t {{home}} -R {{package}}

# Install packages.
[macos]
install:
  #!/usr/bin/env bash
  set -euo pipefail
  # Ask for sudo at most once for the steps below, and drop the cached
  # credentials when done, including if a step fails.
  trap 'sudo -k' EXIT
  just _brew Brewfile
  just _install-zsh-plugins
  just _install-fonts

# Install packages. (use --gui or MWCONFIG_GUI for graphical packages)
[linux]
[arg("gui", long="gui", value="true")]
install gui=gui_default:
  #!/usr/bin/env bash
  set -euo pipefail
  # Ask for sudo at most once for the steps below, and drop the cached
  # credentials when done, including if a step fails.
  trap 'sudo -k' EXIT
  just _brew Brewfile
  just _install-apt zsh
  just _install-zsh-plugins
  if [ "{{gui}}" = true ]; then
    # Install apt sources for third-party packages. Note: spotify's key doesn't
    # live in a consistent place. So this will likely need to be updated every
    # once in a while.
    just _install-apt-source 1password \
      https://downloads.1password.com/linux/keys/1password.asc \
      https://downloads.1password.com/linux/debian/amd64 stable main
    just _install-apt-source spotify \
      https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc \
      https://repository.spotify.com stable non-free
    just _install-apt i3-wm polybar rofi
    just _install-fonts
  fi

# Install the given brewfile. Brew's auto-update is skipped: existing packages
# aren't upgraded anyway, and this avoids re-downloading the package index (the
# "Downloading API data" step) on every run.
_brew brewfile:
  @echo "📦 Installing brew bundle: {{brewfile}}"
  @HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file={{brewfile}} -q --no-upgrade

# Install a source list and scoped apt key for a third-party repo.
[linux]
_install-apt-source name key source suite component:
  #!/usr/bin/env bash
  set -euo pipefail
  keyring=/usr/share/keyrings/{{name}}-archive-keyring.gpg
  list=/etc/apt/sources.list.d/{{name}}.list
  options="[arch=amd64 signed-by=$keyring]"
  if [ ! -e "$keyring" ]; then
    echo "📦 Installing apt key: $keyring"
    # Download the key before converting it (so a failed download only shows
    # curl's error), and build the keyring in a temporary file that's only
    # installed once that succeeds, so a failure doesn't leave an empty keyring
    # behind that later runs would skip.
    key=$(curl -fsSL {{key}})
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' EXIT
    gpg --dearmor <<< "$key" > "$tmp"
    sudo install -m 644 "$tmp" "$keyring"
  fi
  if [ ! -e "$list" ]; then
    echo "📦 Installing apt source: $list"
    echo "deb $options {{source}} {{suite}} {{component}}" \
      | sudo tee "$list" >/dev/null
  fi

# Install any of the given apt packages that aren't already installed.
[linux]
_install-apt *packages:
  #!/usr/bin/env bash
  set -euo pipefail
  missing=()
  for pkg in {{packages}}; do
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed" \
      || missing+=("$pkg")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    echo "📦 Installing apt packages: ${missing[*]}"
    sudo apt-get install -y "${missing[@]}"
  fi

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
      echo "📦 Installing zsh plugin: $target"
      git clone -q "https://github.com/$repo" "$target"
    fi
  done

# Install nerd fonts.
_install-fonts:
  #!/usr/bin/env bash
  set -euo pipefail
  case {{os}} in
    macos) font_dir={{home}}/Library/Fonts ;;
    *) font_dir={{home}}/.local/share/fonts ;;
  esac
  base=https://github.com/ryanoasis/nerd-fonts/releases/latest/download
  for font in Hack JetBrainsMono; do
    target="$font_dir/$font"
    if [ ! -d "$target" ]; then
      echo "📦 Installing font: $target"
      # Download and extract in a temporary directory next to the target and
      # only move it into place once that succeeds, so a failed download
      # doesn't leave an empty directory behind that later runs would skip.
      # Downloading before extracting also means a failure only shows curl's
      # error.
      mkdir -p "$font_dir"
      tmp=$(mktemp -d "$font_dir/.$font.XXXXXX")
      trap 'rm -rf "$tmp"' EXIT
      curl -fsSL -o "$tmp/$font.tar.xz" "$base/$font.tar.xz"
      tar -xJf "$tmp/$font.tar.xz" -C "$tmp"
      rm "$tmp/$font.tar.xz"
      mv "$tmp" "$target"
      trap - EXIT
    fi
  done
  if command -v fc-cache >/dev/null; then fc-cache; fi

# Populate local git config with name/email.
_gitconfig:
  #!/usr/bin/env bash
  set -euo pipefail
  target={{home}}/.config/git/local
  if [ -f "$target" ]; then
    exit 0
  fi
  name={{quote(git_name)}}
  email={{quote(git_email)}}
  [ -n "$name" ] || read -rp "Git name: " name
  [ -n "$email" ] || read -rp "Git email: " email
  mkdir -p "$(dirname "$target")"
  echo "📦 Installing git config: $target"
  git config --file "$target" user.name "$name"
  git config --file "$target" user.email "$email"
