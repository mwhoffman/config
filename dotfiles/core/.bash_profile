#!/bin/bash

# Functions for sourcing or adding to the path that check whether the
# file/directory exists.
function pth { [ -d $1 ] && PATH="$1:$PATH"; }
function src { [ -r $1 ] && source $1; }
function srcall { [ -d $1 ] && for f in "$1"/*; do source "$f"; done }

src "$HOME/.bash_local"  # Add machine-specific environment vars.
src "$HOME/.bashrc"      # Run common bashrc.
pth "$HOME/bin"          # Append ~/bin.

unset pth
unset src
unset srcall

