# config

This repo includes all of the dotfiles and configuration I need to work
comfortably on a new machine. I also use this as a central repository for my
dotfiles in order to keep the configuration between multiple machines in sync.

## Quickstart

This configuration can be bootstrapped by running
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mwhoffman/config/HEAD/bootstrap)"
```
The `bootstrap` script will install homebrew along with `stow` and `just` which
are needed for the rest of the setup; it will then run `just _bootstrap` to
complete the installation.

The justfile contains additional targets `dotfiles`, `install`, and
`install-gui` (on linux) to install any new dotfiles or install additional
packages after syncing later.
