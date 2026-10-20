set shell := ["bash", "-euo", "pipefail", "-c"]
set allow-duplicate-variables

# Local settings are read from config.yaml if it exists. See the README for the
# available settings.

home := home_directory()
os := os()

# Fail early if any of the tools that the recipes rely on are missing.
_ := require("git")
_ := require("stow")
_ := require("yq")

#--------------#
# Core targets #
#--------------#

# Install dotfiles and clean up.
dotfiles:
  @just _link "core"
  @if [[ -d "dotfiles/{{os}}" ]]; then just _link "{{os}}"; fi
  @just _gitconfig
  @just _prune-links

# Install packages.
[macos]
install:
  #!/usr/bin/env bash
  set -euo pipefail
  trap 'sudo -k' EXIT

  # This is simpler than the linux checks below because macos always uses the
  # "gui" option and there's only one real package manager.
  just _brew bundles/Brewfile
  just _zsh-plugins bundles/zsh-plugins.yaml
  just _fonts bundles/fonts.yaml

# Install packages.
[linux]
install:
  #!/usr/bin/env bash
  set -euo pipefail
  trap 'sudo -k' EXIT

  # Attempt to use known package managers with the associated bundles.
  if command -v brew >/dev/null; then
    just _brew bundles/Brewfile
  elif command -v apt-get >/dev/null; then
    just _install-apt-bundle bundles/apt.yaml
  else
    echo "warning: No known package manager" >&2
  fi

  # Install the zsh plugins. Will also update them.
  just _zsh-plugins bundles/zsh-plugins.yaml

  # Install any gui-specific bundles.
  gui=$(just _config-bool gui)
  if [ "$gui" = true ]; then
    just _fonts bundles/fonts.yaml
  fi

#----------------#
# Helper targets #
#----------------#

# Print the value of a boolean setting from the local config.yaml, which is
# false if the file or setting is missing.
_config-bool key:
  #!/usr/bin/env bash
  set -euo pipefail
  value=false
  if [ -f config.yaml ]; then value=$(yq '.{{key}} // false' config.yaml); fi
  if [ "$value" != true ] && [ "$value" != false ]; then
    echo "error: {{key}} in config.yaml must be true or false, not '$value'" >&2
    exit 1
  fi
  echo "$value"

# Link a single stow package.
_link package:
  @echo "📦 Installing dotfiles: {{package}}"
  @stow --no-folding -d dotfiles -t {{home}} -R {{package}}

# Remove dead links into dotfiles, e.g. left over from deleted directories.
# Stow's links are relative, so they start with config/dotfiles/ or ../.
# Packages only hold dotfiles, so skip non-hidden top-level entries; on macOS
# that also avoids privacy-protected dirs like ~/Library and ~/Documents.
_prune-links:
  @echo "🗑️ Pruning dead dotfiles"
  @find {{home}} -mindepth 1 -maxdepth 6 \
    \(  ! -path '{{home}}/.*' \
       -o -path '{{home}}/.cache' \
       -o -path '{{home}}/.Trash' \
       -o -path '{{home}}/.local/share/Trash' \) -prune \
    -o -type l \( -lname 'config/dotfiles/*' -o -lname '*../config/dotfiles/*' \) \
    ! -exec test -e {} \; -exec rm {} +


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
    echo "📥 Installing apt key: $keyring"
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
    echo "📥 Installing apt source: $list"
    echo "deb $options {{source}} {{suite}} {{component}}" \
      | sudo tee "$list" >/dev/null
    # Fetch the new source's package index so its packages can be installed.
    sudo apt-get update
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
    echo "📥 Installing apt packages: ${missing[*]}"
    sudo apt-get install -y "${missing[@]}"
  fi

# Install the given apt bundle: a yaml file with a list of packages and,
# optionally, a list of the sources (third-party repos) they need.
[linux]
_install-apt-bundle bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "📦 Installing apt bundle: {{bundle}}"
  # The lists are assigned first, rather than expanded inline, so that a missing
  # or malformed bundle is an error. Each source is a line of its fields, read
  # on a separate file descriptor so the install can't consume the others.
  sources=$(yq -r '.sources[] | [.name, .key, .url, .suite, .component] | join(" ")' {{bundle}})
  packages=$(yq -r '.packages[]' {{bundle}})
  while read -r -u 3 name key url suite component; do
    [ -n "$name" ] || continue
    just _install-apt-source "$name" "$key" "$url" "$suite" "$component"
  done 3<<< "$sources"
  just _install-apt $packages

# Install the zsh plugins in the given bundle: a yaml list of github owner/repo
# entries. Plugins that are already installed are updated.
_zsh-plugins bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "📦 Installing zsh plugins: {{bundle}}"
  dest={{home}}/.local/share/zsh
  mkdir -p "$dest"
  # This is assigned first, rather than expanded inline, so that a missing or
  # malformed bundle is an error.
  repos=$(yq -r '.[]' {{bundle}})
  for repo in $repos; do
    target="$dest/${repo#*/}"
    if [ ! -d "$target" ]; then
      echo "📥 Installing zsh plugin: $target"
      # Github asks for a login when a repo doesn't exist, so disable prompts
      # to make that fail instead, and say which entry was at fault.
      if ! GIT_TERMINAL_PROMPT=0 git clone -q "https://github.com/$repo" "$target"; then
        echo "error: failed to clone zsh plugin '$repo' from {{bundle}}" >&2
        exit 1
      fi
      continue
    fi
    if ! GIT_TERMINAL_PROMPT=0 git -C "$target" fetch -q; then
      echo "error: failed to fetch zsh plugin '$repo' from {{bundle}}" >&2
      exit 1
    fi
    old=$(git -C "$target" rev-parse --short HEAD)
    new=$(git -C "$target" rev-parse --short '@{upstream}')
    if [ "$old" != "$new" ]; then
      echo "📥 Updating zsh plugin: $target ($old -> $new)"
      git -C "$target" merge -q --ff-only '@{upstream}'
    fi
  done

font_dir := if os == "macos" {
  home / "Library/Fonts"
} else {
  home / ".local/share/fonts"
}
font_url := "https://github.com/ryanoasis/nerd-fonts/releases"

# Install the nerd fonts in the given bundle: a yaml list of release asset
# names. Fonts that are already installed are updated if they aren't from the
# latest release; those installed without a recorded version are treated as out
# of date.
_fonts bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "📦 Installing fonts: {{bundle}}"
  # These are assigned first, rather than expanded inline, so that a missing or
  # malformed bundle is an error.
  fonts=$(yq -r '.[]' {{bundle}})
  version=$(just _font-version)
  for font in $fonts; do
    target={{font_dir}}/$font
    if [ ! -d "$target" ]; then
      echo "📥 Installing font: $target"
      just _install-font "$font" "$version"
      continue
    fi
    current=$(cat "$target/.version" 2>/dev/null || true)
    if [ "$current" != "$version" ]; then
      echo "📥 Updating font: $target (${current:-unknown} -> $version)"
      just _install-font "$font" "$version"
    fi
  done
  if command -v fc-cache >/dev/null; then fc-cache; fi

# Print the version of the latest nerd fonts release, which is the tag that the
# latest release's url redirects to.
_font-version:
  #!/usr/bin/env bash
  set -euo pipefail
  url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' {{font_url}}/latest)
  echo "${url##*/}"

# Install the given version of a single nerd font, replacing any that's already
# installed, and record the version alongside it.
_install-font font version:
  #!/usr/bin/env bash
  set -euo pipefail
  target={{font_dir}}/{{font}}
  # Download and extract in a temporary directory next to the target and only
  # move it into place once that succeeds, so a failed download doesn't leave an
  # empty directory behind that later runs would skip (or remove a font that's
  # being updated). Downloading before extracting also means a failure only
  # shows curl's error.
  mkdir -p {{font_dir}}
  tmp=$(mktemp -d {{font_dir}}/.{{font}}.XXXXXX)
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL -o "$tmp/{{font}}.tar.xz" \
    {{font_url}}/download/{{version}}/{{font}}.tar.xz
  tar -xJf "$tmp/{{font}}.tar.xz" -C "$tmp"
  rm "$tmp/{{font}}.tar.xz"
  echo {{version}} > "$tmp/.version"
  rm -rf "$target"
  mv "$tmp" "$target"
  trap - EXIT

# Populate local git config with name/email.
_gitconfig:
  #!/usr/bin/env bash
  set -euo pipefail
  target={{home}}/.config/git/local
  # Whether the given user option is already set.
  has() { git config --file "$target" --get "user.$1" >/dev/null; }
  if has name && has email; then
    exit 0
  fi
  echo "🔧 Updating git config: $target"
  mkdir -p "$(dirname "$target")"
  if ! has name; then
    read -rp "Git name: " name
    git config --file "$target" user.name "$name"
  fi
  if ! has email; then
    read -rp "Git email: " email
    git config --file "$target" user.email "$email"
  fi
