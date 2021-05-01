#!/bin/bash

# Don't do anything if not interactive.
[ -z "$PS1" ] && return

# Source everything under ~/.bash.
srcall "$HOME/.bash"

