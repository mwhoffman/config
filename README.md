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
will not be upgraded; that's left to be done manually.

On macos packages are installed with homebrew, which setup installs if needed.
On linux homebrew will be used if the environment variable
`LINUX_INSTALL_BREW=1` is set before running setup; otherwise packages come from
the system package manager. Dotfiles live under multiple packages in
[dotfiles/][dotfiles] and will be linked into place using `stow`. The `core`
package is always linked and other packages will be linked if they are listed in
the local config (see below).

[dotfiles]: https://github.com/mwhoffman/config/tree/main/dotfiles

Once bootstrapped `setup` essentially amounts to calling `just install dotfiles`
which runs the `install` and `dotfiles` just commands. In most instances you can
run only `just dotfiles` to skip the installation command which is marginally
slower due to its requirement to make network connections.

Finally, minimal local settings can be specified in `~/config/config.yaml`,
which is ignored by git. The available settings are `gui`, which installs gui
tools on linux, and `dotfiles`, a list of the packages under `dotfiles/` to link
besides `core`&mdash;unspecified packages will be unlinked.
