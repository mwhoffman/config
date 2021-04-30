config
======

This includes most of the configuration files and setup for any new machine
that I have an account on. Over time I've ended up putting more and more
configuration here so that on a new machine I just need to run `setup.sh` and
it should be good to go.

The most important configuration files are in `dotfiles/` which can be
symlinked into the home directory. These are currently arranged into a set of
"packages" for different systems. To install these I've been using GNU `stow`
to link them into place, e.g. by running `stow -t $HOME -S core` from the
`dotfiles` directory.

