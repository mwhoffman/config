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
nothing has changed. Zsh plugins and fonts are also updated if a newer version
is available, but system and brew packages aren't upgraded; that's left to be
done manually, e.g. with `brew upgrade` or `apt upgrade`.

[core]: https://github.com/mwhoffman/config/tree/main/dotfiles/core
[macos]: https://github.com/mwhoffman/config/tree/main/dotfiles/macos
[linux]: https://github.com/mwhoffman/config/tree/main/dotfiles/linux

The dotfiles themselves live under [dotfiles/core][core] as well as
[dotfiles/macos][macos] and [dotfiles/linux][linux] for os-specific
configuration. They are symlinked into place so any local edits should be
reflected automatically in the git repository, and pulling down changes
automatically "updates" the dotfiles. Re-running `setup` is only strictly
necessary if there are new files.

Local settings can be given in `~/config/config.yaml`, which is ignored by git.
Currently the only setting is `gui`, which installs gui tools on linux:
```yaml
gui: true
```
If the git name and email settings aren't already set, the setup script will ask
for them.
