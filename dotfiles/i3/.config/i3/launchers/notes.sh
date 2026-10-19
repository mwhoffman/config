#!/bin/bash

# Pick a note to edit with zk, in a floating kitty window (with no tab bar)
# which closes when zk exits.

exec kitty --class floating --name notes \
  -o tab_bar_min_tabs=2 -o remember_window_size=no \
  -o initial_window_width=100c -o initial_window_height=50c \
  --directory "$HOME/notes" zk edit --interactive
