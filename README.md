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

This will link the every individual file contained in `dotfiles/core` as well as
creating the intermediate directory structure along the way (this is what the
`--no-folding` option does). `core` can be replaced by any immediate
subdirectory of `dotfiles/` and allows me to separate different sets of
configuration for different machine types. Finally, the `-vv` option will
explicitly tell us what the command is doing. 

Note that stow will not overwrite any files that already exist. Conflicting
files must either be removed or the `--adopt` option can be used to overwrite
the file in the stow directory; see the documentation for more details.

