# config

This repo includes all of the dotfiles and configuration I need to work
comfortably on a new machine as well as to keep said configuration in sync
between multiple machines.

## Quickstart

This configuration can be bootstrapped by running
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mwhoffman/config/HEAD/setup)"
```
which will clone the repository into `~/config`, install my common collection of
apps, and install my dotfiles. After pulling in recent changes from github this
process can be repeated by running `~/config/setup` which will install any
missing apps and missing dotfiles&mdash;importantly it should be a no op if
nothing has changed.

[core]: https://github.com/mwhoffman/config/tree/main/dotfiles/core
[macos]: https://github.com/mwhoffman/config/tree/main/dotfiles/macos
[linux]: https://github.com/mwhoffman/config/tree/main/dotfiles/linux

The dotfiles themselves live under [dotfiles/core][core] as well as
[dotfiles/macos][macos] and [dotfiles/linux][linux] for os-specific
configuration. They are symlinked into place so any local edits should be
reflected automatically in the git repository, and pulling down changes
automatically "updates" the dotfiles. Re-running `setup` is only strictly
necessary if there are new files.

By setting the environment variable `MWCONFIG_GUI=1` the setup process will also
install gui tools on linux. Finally, the `MWCONFIG_GIT_NAME` and
`MWCONFIG_GIT_EMAIL` can be used to initialize the git name and email settings.
If these are not set the setup script will ask for them.
