# config

This repo includes all of the dotfiles and configuration I need to work
comfortably on a new machine. I also use this as a central repository for my
dotfiles in order to keep the configuration between multiple machines in sync.

## Quickstart

This configuration can be bootstrapped by running
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mwhoffman/config/HEAD/bootstrap)"
```
The `bootstrap` command (run as above or downloaded and run directly) will clone
this repository into the `$TARGET` directory (`~/config` by default) and will
create a `~/config/setup` frontend script. The `setup` script itself is a thin
wrapper around [setuppy] (a lightweight orchestration framework) so to be as
minimally invasive as possible this bootstrap procedure will install that
package and its requirements into `$TARGET/.venv`. On macos systems
bootstrapping will also install [homebrew] along with an updated `python`
package.

Running `~/config/setup` will, by default, _only_ install dotfiles by symlinking
them into your home directory. However, this will likely fail due to missing
packages necessary to run `setup` itself (primarily [GNU stow][stow]). To
install those packages _and_ install dotfiles run:
```
~/config/setup -t bootstrap
```
The `-t bootstrap` option is only necessary to install the prerequisite packages
and can be dropped from subsequent runs.

> [!NOTE]
> Why would you want to run `setup` more than once? As noted above I also use
> this repository to keep dotfiles and configuration in sync between multiple
> machines. However, using `git pull` to get upstream changes will only apply to
> those files that have already been symlinked (and any removed files will now
> be dead links). Running `setup` again will correct theses issues (as well as
> install any additional packages as noted below).

> [!IMPORTANT]
> `setup` will also fail if any conflicts exist between the dotfiles and
> pre-existing files in your home directory. These conflicts must either be
> resolved manually, e.g. by deleting the pre-existing files or by _adopting_
> them into the repository (read further for a way to do this automatically with
> [GNU stow][stow]).

## Additional setup

The `setup` script can also be used to perform additional setup and install
additional packages using the `-t` option to specify tags (the use of `-t
bootstrap` above is an example of this). While the tags themselves are arbitrary
(see `recipes/` for more details) I've tried to use them relatively
consistently. In addition to the `bootstrap` tag you can use the following:

- `install`, used to mark actions which will install packages.
- `external`, used to mark actions involving external sources.
- `gui`, used to mark actions involving the gui.

These tags can be used independently and a recipe or action will only run if all
of its associated tags have been specified. E.g. `setup -t gui` will install
gui-related dotfiles, but gui-related packages will only be installed with
`setup -t gui -t install`. As a short-hand you can also use `setup -a` to
automatically include all tags.

Finally, `setup` has additional options which can be useful. The most useful of
these are `-n` which will simulate actions (i.e. it will make no changes on
disk) and `-v` which adjusts the verbosity of the output. See `--help` for more
information.

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
