set shell := ["bash", "-euo", "pipefail", "-c"]
set allow-duplicate-variables

home := home_directory()
os := os()

# Environment variables can be set which affect the setup process. MWCONFIG_GUI
# set to any true value will install GUI packages on linux; an empty value, 0,
# false, no, off or nil means off. MWCONFIG_GIT_NAME and MWCONFIG_GIT_EMAIL
# specify name and email for git.

gui_env := lowercase(env("MWCONFIG_GUI", ""))
gui := if gui_env =~ '^(|false|no|off|nil|0)$' {
  "false"
} else {
  "true"
}
git_name := env("MWCONFIG_GIT_NAME", "")
git_email := env("MWCONFIG_GIT_EMAIL", "")

#--------------#
# Core targets #
#--------------#

# Install dotfiles and clean up.
dotfiles: (_link "core") (_link os) _gitconfig _prune-links

# Install packages.
[macos]
install:
  #!/usr/bin/env bash
  set -euo pipefail
  # Ask for sudo at most once for the steps below, and drop the cached
  # credentials when done, including if a step fails.
  trap 'sudo -k' EXIT
  just _brew bundles/Brewfile
  just _install-zsh-plugins bundles/zsh-plugins.yaml
  just _install-fonts bundles/fonts.yaml

# Install packages.
[linux]
install:
  #!/usr/bin/env bash
  set -euo pipefail
  # Ask for sudo at most once for the steps below, and drop the cached
  # credentials when done, including if a step fails.
  trap 'sudo -k' EXIT
  just _brew bundles/Brewfile
  just _install-apt zsh
  just _install-zsh-plugins bundles/zsh-plugins.yaml
  if [ "{{gui}}" = true ]; then
    just _install-apt-bundle bundles/apt-gui.yaml
    just _install-fonts bundles/fonts.yaml
  fi

# Update installed packages.
[macos]
update:
  #!/usr/bin/env bash
  set -euo pipefail
  # Ask for sudo at most once for the steps below, and drop the cached
  # credentials when done, including if a step fails.
  trap 'sudo -k' EXIT
  just _update-brew bundles/Brewfile
  just _update-zsh-plugins bundles/zsh-plugins.yaml
  just _update-fonts bundles/fonts.yaml

# Update installed packages.
[linux]
update:
  #!/usr/bin/env bash
  set -euo pipefail
  # Ask for sudo at most once for the steps below, and drop the cached
  # credentials when done, including if a step fails.
  trap 'sudo -k' EXIT
  just _update-brew bundles/Brewfile
  just _update-apt zsh
  just _update-zsh-plugins bundles/zsh-plugins.yaml
  if [ "{{gui}}" = true ]; then
    just _update-apt-bundle bundles/apt-gui.yaml
    just _update-fonts bundles/fonts.yaml
  fi

#----------------#
# Helper targets #
#----------------#

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

# Upgrade the packages in the given brewfile. Unlike the other update targets
# this also installs any that are missing, since that's how brew bundle works.
# Brew's auto-update refreshes the package index first if it's over a day old.
_update-brew brewfile:
  @echo "🔄 Updating brew bundle: {{brewfile}}"
  @brew bundle --file={{brewfile}} -q

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

# Upgrade any of the given apt packages that are installed and have a newer
# version available. This doesn't refresh the package index, which needs sudo;
# it relies on the system doing that regularly.
[linux]
_update-apt *packages:
  #!/usr/bin/env bash
  set -euo pipefail
  outdated=()
  for pkg in {{packages}}; do
    policy=$(LC_ALL=C apt-cache policy "$pkg")
    installed=$(awk '/Installed:/ {print $2}' <<< "$policy")
    candidate=$(awk '/Candidate:/ {print $2}' <<< "$policy")
    if [ -n "$installed" ] && [ "$installed" != "(none)" ] \
        && [ "$installed" != "$candidate" ]; then
      outdated+=("$pkg")
    fi
  done
  if [ "${#outdated[@]}" -gt 0 ]; then
    echo "📥 Updating apt packages: ${outdated[*]}"
    sudo apt-get install -y --only-upgrade "${outdated[@]}"
  fi

# Upgrade the packages in the given apt bundle.
[linux]
_update-apt-bundle bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "🔄 Updating apt bundle: {{bundle}}"
  # This is assigned first, rather than expanded inline, so that a missing or
  # malformed bundle is an error.
  packages=$(yq -r '.packages[]' {{bundle}})
  just _update-apt $packages

# Install the zsh plugins in the given bundle: a yaml list of github owner/repo
# entries.
_install-zsh-plugins bundle:
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
    fi
  done

# Update the zsh plugins in the given bundle that are installed.
_update-zsh-plugins bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "🔄 Updating zsh plugins: {{bundle}}"
  dest={{home}}/.local/share/zsh
  # This is assigned first, rather than expanded inline, so that a missing or
  # malformed bundle is an error.
  repos=$(yq -r '.[]' {{bundle}})
  for repo in $repos; do
    target="$dest/${repo#*/}"
    [ -d "$target" ] || continue
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
# names.
_install-fonts bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "📦 Installing fonts: {{bundle}}"
  # This is assigned first, rather than expanded inline, so that a missing or
  # malformed bundle is an error.
  fonts=$(yq -r '.[]' {{bundle}})
  version=
  for font in $fonts; do
    target={{font_dir}}/$font
    if [ ! -d "$target" ]; then
      echo "📥 Installing font: $target"
      # Only look up the version once, and only if there's a font to install.
      [ -n "$version" ] || version=$(just _font-version)
      just _install-font "$font" "$version"
    fi
  done
  if command -v fc-cache >/dev/null; then fc-cache; fi

# Update the nerd fonts in the given bundle that are installed, if they aren't
# from the latest release. Fonts installed without a recorded version are
# treated as out of date.
_update-fonts bundle:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "🔄 Updating fonts: {{bundle}}"
  # These are assigned first, rather than expanded inline, so that a missing or
  # malformed bundle is an error.
  fonts=$(yq -r '.[]' {{bundle}})
  version=$(just _font-version)
  for font in $fonts; do
    target={{font_dir}}/$font
    [ -d "$target" ] || continue
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
  name={{quote(git_name)}}
  email={{quote(git_email)}}
  # Whether the given user option is already set.
  has() { git config --file "$target" --get "user.$1" >/dev/null; }
  if has name && has email; then
    exit 0
  fi
  echo "🔧 Updating git config: $target"
  mkdir -p "$(dirname "$target")"
  if ! has name; then
    [ -n "$name" ] || read -rp "Git name: " name
    git config --file "$target" user.name "$name"
  fi
  if ! has email; then
    [ -n "$email" ] || read -rp "Git email: " email
    git config --file "$target" user.email "$email"
  fi

# Install kitty's source, which has the modules and type stubs that kitty's
# tab_bar.py imports, so type checkers can find them. This checks out the tag
# matching the installed kitty (or master without kitty) and can be rerun to
# update it, e.g. after upgrading kitty. It isn't run by install.
_install-kitty-src:
  #!/usr/bin/env bash
  set -euo pipefail
  target={{home}}/.local/share/kitty-src
  ref=master
  if command -v kitty >/dev/null; then
    ref="v$(kitty --version | awk '{print $2}')"
  fi
  echo "📥 Installing kitty source: $target ($ref)"
  if [ ! -d "$target" ]; then
    # Only check out the kitty directory, and only fetch its files as needed.
    git clone -q --depth 1 --no-checkout --filter=blob:none \
      https://github.com/kovidgoyal/kitty "$target"
    git -C "$target" sparse-checkout set kitty
  fi
  git -C "$target" fetch -q --depth 1 origin "$ref"
  git -C "$target" checkout -q --detach FETCH_HEAD
