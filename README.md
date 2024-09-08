# config

This repo includes all of the configuration, i.e. dotfiles, I need whenever I
start working with a new machine.

## Installation with GNU stow

While these file can always be copied directly into your home directory, I
generally use [GNU stow][stow] to symlink these into place. This can be
accomplished by running

[stow]: https://www.gnu.org/software/stow/

```
stow -vv --no-folding -d dotfiles -t $HOME core
```

This will link the every individual file contained in `dotfiles/core` into
`$HOME` and will do so verbosely (due to the `-t` and `-vv` options
respectively). As a result of the `--no-folding` option it will also create the
intermediate directory structure along the way rather than symlinking
directories. `core` is what stow thinks of as a _package_ and can be
extended/replaced with other packages defined as any of the immediate
subdirectories of `dotfiles/`. I use this to group platform-specific dotfiles
into different packages so that, e.g. on linux, I can run `stow ... core linux`.

If you _delete_ any files from a stow package that will leave dangling symlinks
behind. In order to deal with this you can _restow_ packages, which will remove
and then re-add a package, removing any obsolete symlinks. This can be
accomplished with the `-R` flag, e.g. `stow ... -R core`.

Finally, stow will not overwrite any files that already exist. Conflicting files
must either be removed manually, _or_ the `--adopt` option can be used to
replace the stowed file with the version existing in the target directory (see
the documentation for more details). I often use this option to edit a raw
dotfile in place and then create an empty file, e.g. `touch dotfiles/core/.foo`,
before adopting the existing file with `stow ... core --adopt`. Obviously be
careful with this option since it will replace _all_ conflicting files in the
stow directory.

## Full setup with ansible

Alternatively, I've created a collection of ansible tasks to install these
dotfiles, install any common software I use, and do any necessary setup. This
can all be done by running

```
./setup
```

which is a small shell script wrapping the ansible run. By default this will
just install the dotfiles, but it takes additional options, e.g. `-s` for setup
that requires `sudo`, `-p` for any package installation, and `-g` for any
gui-specific packages.

Using this script requires git and ansible to be installed already, and
package-installation on macos requires brew. At some point I will likely get
around to having this script bootstrap those components.

