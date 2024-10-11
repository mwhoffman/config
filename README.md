# config

This repo includes all of the configuration/dotfiles I need whenever I start
working with a new machine, or just to keep this configuration in sync between
different machines. It also includes a `setup` script to install these dotfiles
as well as the various packages I frequently use.

## Quickstart

Bootstrap the configuration by running
```
BOOTSTRAP="https://raw.githubusercontent.com/mwhoffman/config/HEAD/bootstrap"
/bin/bash -c "$(curl -fsSL ${BOOTSTRAP})"  
```
which will install [homebrew] on macos systems, download this git repository,
and install any prerequisites for running setup (i.e. none so far; see the note
below). Setup can then be run with
```
cd ~/config && ./setup
```
By default `setup` will only install the dotfiles (as symlinks). It will also
fail if any conflicts exist between the dotfiles and their targets (i.e. the
files in your home directory). These conflicts must either be resolved manually
or _adopted_ with stow (see the next section).

The `setup` script also has additional options to install the full set of
packages I generally use; see `setup --help` for more info.

> [!NOTE]  
> The setup script relies on [setuppy] a setup framework I wrote that is like
> ansible, but worse (and faster). At some point I will get around to
> bootstrapping this into a venv, but for the moment it requires it to be
> installed and findable by python.

## Manually installing dotfiles using GNU stow

While the dotfiles can always be copied directly into your home directory,
internally the `setup` script uses [GNU stow][stow] to symlink these into place.
This can also be done manually by running

```
stow -v --no-folding -d dotfiles -t $HOME -R core
```

This will link every individual file contained in `dotfiles/core` into your home
directory. `core` is what stow thinks of as a _package_ and this list can be
extended/replaced with other packages defined as any of the immediate
subdirectories of `dotfiles/`, i.e. in order to group platform-specific
dotfiles. In addition, this command will remove and then re-add any packages
(due to the `-R` option). This means that any dotfiles that are removed upstream
will be removed locally as well.

Finally, stow will not overwrite any files that already exist. Conflicting files
must either be removed manually, _or_ the `--adopt` option can be used to
replace a stowed file with its corresponding version from the target directory.
I often use this option if I need to create a new dotfile, e.g. running `touch
dotfiles/core/foo` and then `stow ... core --adopt`; this will move `~/foo` by
replacing `dotfiles/core/foo` and will then link it in place. Obviously be
careful with this option since it will replace _all_ conflicting files in the
stow directory.

[homebrew]: https://brew.sh
[stow]: https://www.gnu.org/software/stow/
[setuppy]: https://github.com/mwhoffman/setuppy
