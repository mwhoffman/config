# zsh theme colors, for zsh's config (e.g. its prompt) to use. The values are
# colors as given to the %F{...} prompt escape, i.e. a name (e.g. blue), a
# number (e.g. 11) or a hex color (e.g. #83a598), quoted so that a hex color
# isn't read as a comment.

typeset -gA THEME_COLORS=(
  # The host, directory and git branch in the prompt, and the icons of repos
  # needing attention.
  host 'yellow'
  directory 'blue'
  branch '#94e2d5'
  repos '#fab387'

  # The descriptions (e.g. of completion groups), messages and warnings shown
  # when completing.
  completion_description '#7f849c'
  completion_message '#89dceb'
  completion_warning 'yellow'
)

# Extra list-colors entries for completion menus, appended after $LS_COLORS:
# the selected item ("ma") is bold, on the menu's selected background.
typeset -ga THEME_LIST_COLORS=('ma=1;48;2;49;50;68')

# zle's own highlights: the region (outside of vi visual mode), incremental
# search (the text on the match color), and no highlighting of pasted text.
typeset -ga zle_highlight=(
  region:bg=#45475a
  isearch:fg=#1e1e2e,bg=yellow
  paste:none
  suffix:bold
)

# zsh-syntax-highlighting styles. The plugin only fills in styles that aren't
# set, so these are set before it's sourced. Its default for comments is bold
# black, which is the background.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES+=(
  # Commands, which are bold (which is what tells them apart from strings), and
  # builtins (echo, cd, ...).
  arg0 fg=blue,bold
  precommand fg=blue,bold,underline
  suffix-alias fg=blue,bold,underline
  autodirectory fg=blue,bold,underline
  builtin fg=#fab387

  # Keywords (if, for, ...), and unknown commands.
  reserved-word fg=#cba6f7
  unknown-token fg=red,bold

  # Strings, with expansions inside them like variables.
  single-quoted-argument fg=green
  double-quoted-argument fg=green
  dollar-quoted-argument fg=green
  dollar-double-quoted-argument fg=#eba0ac
  back-double-quoted-argument fg=#eba0ac
  assign fg=#eba0ac

  # Operators, separators (|, &&, ;) and special syntax.
  globbing fg=#89dceb
  history-expansion fg=#89dceb
  redirection fg=#89dceb
  commandseparator fg=#89dceb
  command-substitution-delimiter fg=#89dceb
  process-substitution-delimiter fg=#89dceb
  back-quoted-argument-delimiter fg=#89dceb

  # Options like variables, and comments. Existing paths are only underlined, in
  # the normal text color, since the plugin can't tell directories from files
  # (so a color like dircolors' would often be wrong).
  single-hyphen-option fg=#eba0ac
  double-hyphen-option fg=#eba0ac
  path underline
  comment fg=#9399b2
)

# zsh-autosuggestions: suggestions like comments.
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#9399b2'

# zsh-vi-mode: the visual mode selection, like the region. These must be set
# before the plugin is sourced.
typeset -g ZVM_VI_HIGHLIGHT_BACKGROUND='#45475a'
typeset -g ZVM_VI_HIGHLIGHT_FOREGROUND='#cdd6f4'
