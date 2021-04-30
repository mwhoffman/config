#!/bin/bash

# if we're not using an interactive shell then get out of here before we
# do anything other than set paths.
[ -z "$PS1" ] && return

# little helper to source files if they exist.
function _source { [ -r $1 ] && source $1; }

# add all the subparts.
for file in $HOME/.bash/* ; do
    _source "$file"
done

