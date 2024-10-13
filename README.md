# config

This repo includes all of the configuration/dotfiles I need whenever I start
working with a new machine, or just to keep this configuration in sync between
different machines. It also includes a `setup` script to install these dotfiles
as well as the various packages I frequently use.

## Quickstart

Bootstrap the configuration by running
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mwhoffman/config/HEAD/bootstrap)"
```
which will install [homebrew] on macos systems, download this git repository to
the `$TARGET` directory, and install any prerequisites for running `setup` (it
will create a python venv in `$TARGET/.venv` and install [setuppy]). Once this
finishes you can run `~/config/setup`. 

By default `setup` will only install dotfiles (as symlinks). However, this will
likely fail unless `stow` is installed (see the next section for more details).
While installing `stow` can be done manually, you can also include the
`bootstrap` tag, i.e.
```
~/config/setup -t bootstrap
```
which will additionally install stow before linking any dotfiles. Running
`setup` will fail if any conflicts exist between the dotfiles and their targets
(i.e. the files in your home directory). These conflicts must either be resolved
manually or _adopted_ with `stow` (see the next section).

The `setup` script can also be used to install additional packages, however
these require the use of tags to include. The `bootstrap` tag used above is an
example of this which installs any packages needed by `setup` itself (e.g.
`stow`). See the recipes in `recipes/` to find out more tags; see also `setup
--help` for more info on the command itself.

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
