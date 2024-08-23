config
======

This repo includes all of my configuration, i.e. dotfiles, that I need for any
new machine.

While these file can always be copied into your home directory, I generally use
[GNU stow][stow] to symlink these into place. This can be accomplished by
running

```
stow --no-folding -d dotfiles -t $HOME -S core
```

This will link the every individual file contained in `dotfiles/core` while
creating any intermediate directories. It will also not overwrite any files that
already exist.

