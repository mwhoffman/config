# config

This repo includes all of the dotfiles and configuration I need to work
comfortably on a new machine as well as to keep said configuration in sync
between multiple machines.

## Quickstart

This configuration can be bootstrapped by running
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mwhoffman/config/HEAD/setup)"
```
which will clone the repository into `~/config`, install any missing apps and
install the core dotfiles. After pulling in recent changes from github this
process can be repeated by running `~/config/setup` to get any new
changes&mdash;importantly this should be a no op if nothing has changed (albeit
zsh plugins and fonts will be updated if newer versions are available). Packages
will not be upgraded; that's left to be done manually via whatever package
manager is used.

[core]: https://github.com/mwhoffman/config/tree/main/dotfiles/core
[dotfiles]: https://github.com/mwhoffman/config/tree/main/dotfiles

The dotfiles themselves live under [dotfiles/core][core], which is always
linked, as well as other packages under [dotfiles][dotfiles] (e.g. `macos`)
which are only linked if listed in the local config (see below). They are
symlinked into place so any local edits should be reflected automatically in the
git repository, and pulling down changes automatically "updates" the dotfiles.
Re-running `setup` is only strictly necessary if there are new files.

Local settings can be given in `~/config/config.yaml`, which is ignored by git.
The available settings are `gui`, which installs gui tools on linux, and
`dotfiles`, a list of the packages under `dotfiles/` to link besides `core` (any
other packages are unlinked).
