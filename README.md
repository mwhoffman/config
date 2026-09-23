# config

This repo includes all of the dotfiles and configuration I need to work
comfortably on a new machine as well as to keep said configuration in sync
between multiple machines.

## Quickstart

This configuration can be bootstrapped by running
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mwhoffman/config/HEAD/bootstrap)"
```
The `bootstrap` script will install [homebrew](https://brew.sh/) and use that to
install [stow](https://www.gnu.org/software/stow/) and
[just](https://github.com/casey/just) which are needed for the rest of the
setup. `stow` is used to symlink collections of dotfiles into the home directory
and `just` is a command/recipe runner&mdash;think of it like a modern
replacement for `make`.

After that this repository will be cloned into `~/config` and `just _bootstrap`
is run. This is (mostly) just a wrapper around `just install` which installs the
core set of apps I use and `just dotfiles` which symlinks my dotfiles into
place. The dotfiles themselves live under
[dotfiles/core](https://github.com/mwhoffman/config/tree/main/dotfiles/core) as
well as
[dotfiles/macos](https://github.com/mwhoffman/config/tree/main/dotfiles/macos)
and
[dotfiles/linux](https://github.com/mwhoffman/config/tree/main/dotfiles/linux)
for os-specific configuration. Finally on linux `just install-gui` will install
graphical packages that aren't otherwise installed by default.

All of these commands can be run again and if nothing has changed they should do
nothing. Typically I will just run `git pull` and `just dotfiles` to get any
upstream configuration changes (if files have only been changed but nothing has
been explicitly added the `just` call is unnecessary).
