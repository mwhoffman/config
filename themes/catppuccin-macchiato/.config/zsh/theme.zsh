# zsh theme colors, for zsh's config (e.g. its prompt) to use. The values are
# colors as given to the %F{...} prompt escape, i.e. a name (e.g. blue), a
# number (e.g. 11) or a hex color (e.g. #83a598), quoted so that a hex color
# isn't read as a comment.

typeset -gA THEME_COLORS=(
  # The host, directory and git branch in the prompt, and the icons of repos
  # needing attention.
  host 'yellow'
  directory 'blue'
  branch '#8bd5ca'
  repos '#f5a97f'

  # The descriptions (e.g. of completion groups), messages and warnings shown
  # when completing.
  completion_description '#8087a2'
  completion_message '#91d7e3'
  completion_warning 'yellow'
)

# Extra list-colors entries for completion menus, appended after $LS_COLORS:
# the selected item ("ma") is bold, on the menu's selected background.
typeset -ga THEME_LIST_COLORS=('ma=1;48;2;54;58;79')

# zle's own highlights: the region (outside of vi visual mode), incremental
# search (the text on the match color), and no highlighting of pasted text.
typeset -ga zle_highlight=(
  region:bg=#494d64
  isearch:fg=#24273a,bg=yellow
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
  builtin fg=#f5a97f

  # Keywords (if, for, ...), and unknown commands.
  reserved-word fg=#c6a0f6
  unknown-token fg=red,bold

  # Strings, with expansions inside them like variables.
  single-quoted-argument fg=green
  double-quoted-argument fg=green
  dollar-quoted-argument fg=green
  dollar-double-quoted-argument fg=#ee99a0
  back-double-quoted-argument fg=#ee99a0
  assign fg=#ee99a0

  # Operators, separators (|, &&, ;) and special syntax.
  globbing fg=#91d7e3
  history-expansion fg=#91d7e3
  redirection fg=#91d7e3
  commandseparator fg=#91d7e3
  command-substitution-delimiter fg=#91d7e3
  process-substitution-delimiter fg=#91d7e3
  back-quoted-argument-delimiter fg=#91d7e3

  # Options like variables, and comments. Existing paths are only underlined, in
  # the normal text color, since the plugin can't tell directories from files
  # (so a color like dircolors' would often be wrong).
  single-hyphen-option fg=#ee99a0
  double-hyphen-option fg=#ee99a0
  path underline
  comment fg=#939ab7
)

# zsh-autosuggestions: suggestions like comments.
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#939ab7'

# zsh-vi-mode: the visual mode selection, like the region. These must be set
# before the plugin is sourced.
typeset -g ZVM_VI_HIGHLIGHT_BACKGROUND='#494d64'
typeset -g ZVM_VI_HIGHLIGHT_FOREGROUND='#cad3f5'
