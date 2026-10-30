# zsh theme colors, sourced by .zshrc and used by it and by prompt.zsh. The
# values are colors as given to the %F{...} prompt escape, i.e. a name (e.g.
# blue), a number (e.g. 11) or a hex color (e.g. #83a598).

typeset -gA THEME_COLORS=(
  # The host, directory and git branch in the prompt.
  host 11
  directory blue
  branch 14

  # The icons of repos needing attention in the prompt: those with local
  # changes, behind their upstream, or ahead of it. Local changes are yellow, to
  # match unstaged changes in git status and modified files in eza.
  changed yellow
  behind magenta
  ahead green

  # The descriptions (e.g. of completion groups), messages and warnings shown
  # when completing.
  completion_description green
  completion_message magenta
  completion_warning red
)

# Extra list-colors entries for completion menus, appended after $LS_COLORS:
# the selected item ("ma") is bold, on the menu's selected background.
typeset -ga THEME_LIST_COLORS=('ma=1;48;2;80;73;69')

# zle's own highlights: the region (outside of vi visual mode), incremental
# search (the text on the match color), and no highlighting of pasted text.
typeset -ga zle_highlight=(
  region:bg=#665c54
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
  arg0 fg=10,bold
  precommand fg=10,bold,underline
  suffix-alias fg=10,bold,underline
  autodirectory fg=10,bold,underline
  builtin fg=#fe8019

  # Keywords (if, for, ...), and unknown commands.
  reserved-word fg=9
  unknown-token fg=9,bold

  # Strings, with expansions inside them like variables.
  single-quoted-argument fg=10
  double-quoted-argument fg=10
  dollar-quoted-argument fg=10
  dollar-double-quoted-argument fg=12
  back-double-quoted-argument fg=12
  assign fg=12

  # Operators, separators (|, &&, ;) and special syntax.
  globbing fg=#fe8019
  history-expansion fg=#fe8019
  redirection fg=#fe8019
  commandseparator fg=#fe8019
  command-substitution-delimiter fg=#fe8019
  process-substitution-delimiter fg=#fe8019
  back-quoted-argument-delimiter fg=#fe8019

  # Options like variables, and comments. Existing paths are only underlined, in
  # the normal text color, since the plugin can't tell directories from files
  # (so a color like dircolors' would often be wrong).
  single-hyphen-option fg=12
  double-hyphen-option fg=12
  path underline
  comment fg=8
)

# zsh-autosuggestions: suggestions like comments.
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# zsh-vi-mode: the visual mode selection, like the region. These must be set
# before the plugin is sourced.
typeset -g ZVM_VI_HIGHLIGHT_BACKGROUND='#665c54'
typeset -g ZVM_VI_HIGHLIGHT_FOREGROUND='#ebdbb2'
