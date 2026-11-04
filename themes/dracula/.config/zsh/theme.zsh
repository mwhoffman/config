# zsh theme colors, for zsh's config (e.g. its prompt) to use. The values are
# colors as given to the %F{...} prompt escape, i.e. a name (e.g. blue), a
# number (e.g. 11) or a hex color (e.g. #83a598), quoted so that a hex color
# isn't read as a comment.

typeset -gA THEME_COLORS=(
  # The host, directory and git branch in the prompt, and the icons of repos
  # needing attention.
  host '11'
  directory 'blue'
  branch '14'
  repos '#ffb86c'

  # The descriptions (e.g. of completion groups), messages and warnings shown
  # when completing.
  completion_description '8'
  completion_message '12'
  completion_warning '11'
)

# Extra list-colors entries for completion menus, appended after $LS_COLORS:
# the selected item ("ma") is bold, on the menu's selected background.
typeset -ga THEME_LIST_COLORS=('ma=1;48;2;66;68;80')

# zle's own highlights: the region (outside of vi visual mode), incremental
# search (the text on the match color), and no highlighting of pasted text.
typeset -ga zle_highlight=(
  region:bg=#44475a
  isearch:fg=black,bg=11
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
  arg0 fg=green,bold
  precommand fg=green,bold,underline
  suffix-alias fg=green,bold,underline
  autodirectory fg=green,bold,underline
  builtin fg=cyan

  # Keywords (if, for, ...), and unknown commands.
  reserved-word fg=magenta
  unknown-token fg=9,bold

  # Strings, with expansions inside them like variables.
  single-quoted-argument fg=yellow
  double-quoted-argument fg=yellow
  dollar-quoted-argument fg=yellow
  dollar-double-quoted-argument fg=#ffb86c
  back-double-quoted-argument fg=#ffb86c
  assign fg=#ffb86c

  # Operators, separators (|, &&, ;) and special syntax.
  globbing fg=magenta
  history-expansion fg=magenta
  redirection fg=magenta
  commandseparator fg=magenta
  command-substitution-delimiter fg=magenta
  process-substitution-delimiter fg=magenta
  back-quoted-argument-delimiter fg=magenta

  # Options like variables, and comments. Existing paths are only underlined, in
  # the normal text color, since the plugin can't tell directories from files
  # (so a color like dircolors' would often be wrong).
  single-hyphen-option fg=#ffb86c
  double-hyphen-option fg=#ffb86c
  path underline
  comment fg=8
)

# zsh-autosuggestions: suggestions like comments.
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# zsh-vi-mode: the visual mode selection, like the region. These must be set
# before the plugin is sourced.
typeset -g ZVM_VI_HIGHLIGHT_BACKGROUND='#44475a'
typeset -g ZVM_VI_HIGHLIGHT_FOREGROUND='#f8f8f2'
