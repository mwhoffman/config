# zsh prompt function.
#
# The prompt is rebuilt before each command by _prompt_set. Helpers are also
# defined which uniformly return their results by setting the $reply array.
# _prompt_set unpacks these values to create the prompt. All variables are
# declared local so nothing should leak into the shell.
#
# There are also functions which set the title and additionally set OSC 1337
# user variables for the host and cmd which can be used by supporting terminals.

function _prompt_parse_pwd {
  # Parse $PWD, returning reply=(dir name). If $PWD_PATH is set to a regex with
  # a single capture group matching the start of $PWD, that part of dir is
  # replaced with "//" and the captured text is returned as the name; otherwise
  # name is "". $HOME is also translated to ~. E.g. with
  # PWD_PATH='/foo/([^/]+)/baz' and PWD=/foo/bar/baz/bub, the returned value is
  # ("//bub" "bar").
  local dir=$PWD
  local name=""

  # These are set by =~ below.
  local MATCH MBEGIN MEND
  local -a match mbegin mend

  # $PWD_PATH has to match whole path components (so "/foo/bar" doesn't match
  # "/foo/barbaz"). The (/|$) adds a second capture group, so $match[1] is
  # still the one from $PWD_PATH.
  if [[ -n $PWD_PATH && $dir =~ "^$PWD_PATH(/|\$)" ]]; then
    dir="//${dir:${#MATCH}}"
    name=$match[1]
  fi

  # Translate $HOME into ~ (but not e.g. $HOME-old).
  if [[ $dir == "$HOME" || $dir == "$HOME"/* ]]; then
    dir="~${dir:${#HOME}}"
  fi

  reply=("$dir" "$name")
}

function _prompt_parse_branch {
  # Return the git branch of the given directory (or the current one) and its
  # status flags: reply=(branch flags), or reply=() if it isn't a git directory.
  # This uses a single call to git; see "Porcelain Format Version 2" in
  # git-status(1).
  reply=()

  # Check for git or return nothing.
  (( $+commands[git] )) || return

  # Run git on the given directory, if any.
  local -a git_dir
  [[ -n $1 ]] && git_dir=(-C "$1")

  # Run git status or return nothing. GIT_OPTIONAL_LOCKS=0 stops status from
  # taking the index lock to refresh it, which could otherwise make a git
  # command run at the same time (e.g. in another shell) fail.
  local git_status
  git_status=$(GIT_OPTIONAL_LOCKS=0 git $git_dir status --porcelain=v2 \
    --branch 2> /dev/null) || return

  # We'll fill these in with output from git status.
  local oid xy branch
  local staged unstaged conflict untracked ahead behind
  local -a ab

  local line
  for line in ${(f)git_status}; do
    case $line in
      ('# branch.oid '*)
        # Get the commit hash which we'll use for a detached HEAD.
        oid=${line#\# branch.oid }
        ;;
      ('# branch.head '*)
        # Get the branch name or "(detached)".
        branch=${line#\# branch.head }
        ;;
      ('# branch.ab '*)
        # Get flags for whether we're ahead/behind upstream.
        ab=(${=${line#\# branch.ab }})
        (( ${ab[1]#+} > 0 )) && ahead=1
        (( ${ab[2]#-} > 0 )) && behind=1
        ;;
      ('1 '*|'2 '*)
        # Changed (1) or renamed/copied (2) entries have a two character XY
        # status: X is the staged change and Y the unstaged change, with "." for
        # no change.
        xy=${line[3,4]}
        [[ ${xy[1]} != . ]] && staged=1
        [[ ${xy[2]} != . ]] && unstaged=1
        ;;
      ('u '*) 
        # Flag conflicting entry (u is unmerged).
        conflict=1
        ;;
      ('? '*)
        # Flag for untracked where "?" matches the standard format.
        untracked=1
        ;;
    esac
  done

  # With a detached HEAD (e.g. mid-rebase, or a checked out tag) show the
  # abbreviated commit instead.
  if [[ $branch == "(detached)" ]]; then
    branch=${oid[1,7]}
  fi

  # The status flags, in the order they're shown.
  local flags=""
  [[ -n $staged    ]] && flags+="✓"
  [[ -n $unstaged  ]] && flags+="*"
  [[ -n $conflict  ]] && flags+="!"
  [[ -n $untracked ]] && flags+="?"
  [[ -n $ahead     ]] && flags+="↑"
  [[ -n $behind    ]] && flags+="↓"

  reply=("$branch" "$flags")
}

function _prompt_set {
  # Declared here so the helpers' results don't leak into the shell.
  local -a reply

  _prompt_parse_pwd
  local dir=$reply[1] dir_name=$reply[2]

  _prompt_parse_branch
  local branch=$reply[1] flags=$reply[2]

  # Collect the icon of each repo in $PROMPT_REPOS that needs attention,
  # separated by spaces and colored by its status, from most to least pressing: local
  # changes (staged, unstaged, conflicted or untracked), behind its upstream,
  # or ahead of it. Local changes use gruvbox's orange, to match git status and
  # nvim; it has no ANSI equivalent, so it's a hex (24-bit) color. Repos with
  # nothing to report are left out. Whether a repo is behind depends on its
  # last fetch; see _prompt_fetch_repos.
  local entry repo icon repo_flags repo_color repo_icons=""
  for entry in $PROMPT_REPOS; do
    icon=${entry%%|*} repo=${entry#*|}
    [[ -d $repo/.git ]] || continue
    _prompt_parse_branch $repo
    repo_flags=$reply[2] repo_color=""
    if [[ $repo_flags == *[✓*!?]* ]]; then
      repo_color="#fe8019"
    elif [[ $repo_flags == *↓* ]]; then
      repo_color=magenta
    elif [[ $repo_flags == *↑* ]]; then
      repo_color=green
    fi
    [[ -n $repo_color ]] && repo_icons+="${repo_icons:+ }%F{$repo_color}$icon%f"
  done

  local caret1=$'\uf105'       # single caret to separate prompt sections.
  local caret2=$'\uf101'       # double caret to end the prompt.
  local branch_icon=$'\ue725'  # git branch icon.

  # Below, text like directory and branch names is added with every "%" doubled
  # (${var//\%/%%}) so it's shown literally rather than read as a prompt escape
  # (e.g. a directory named "100%F{red}").
  PROMPT=""

  # Add the hostname.
  PROMPT+="%F{11}%B%m%b%f"
  PROMPT+=" ${caret1} "

  # If we're in a named directory then add the name.
  if [[ -n $dir_name ]]; then
    PROMPT+="%F{blue}%B${dir_name//\%/%%}%b%f"
    PROMPT+=" ${caret1} "
  fi

  # Add the current working directory.
  PROMPT+="%F{blue}%B${dir//\%/%%}%b%f"

  # If we're in a git directory then add the name of the current branch, and its
  # status flags (after a space) if there are any.
  if [[ -n $branch ]]; then
    PROMPT+=" on %F{14}${branch_icon} %B${branch//\%/%%}${flags:+ $flags}%b%f"
  fi

  # Add the trailing part of the prompt.
  PROMPT+=" ${caret2} "

  # Show the icons of any repos that need attention on the right of the prompt
  # (which is empty otherwise). They're followed by a space since kitty only
  # draws an icon wider than a cell if it's followed by one.
  RPROMPT=${repo_icons:+$repo_icons }
}

# The git repos whose status is shown in the prompt, as "ICON|DIR" entries in
# the order the icons are shown. Repos that don't exist (or aren't git repos)
# are skipped. This is only set if it isn't already, so local.zsh (which is
# sourced before this file) can set it differently for a machine.
(( ${+PROMPT_REPOS} )) || typeset -ga PROMPT_REPOS=(
  $'\uf423|'"$HOME/config"  # config repo with gear icon.
  $'\uf405|'"$HOME/notes"   # notes repo with book icon.
)

# The directory of files whose mtimes record when _prompt_fetch_repos last
# started a fetch of each repo. Like the cache below, this is global.
typeset -g _prompt_fetch_stamps="$HOME/.local/share/zsh/fetch"

function _prompt_fetch_repos {
  # Fetch the upstream of each repo in $PROMPT_REPOS in the background, so the
  # prompt can show when it's behind, unless it was fetched (by us or by hand)
  # in the last hour. The fetches are disowned (with &!) so a slow or missing
  # network doesn't hold up the prompt, and their results show up in a later
  # prompt. Git and ssh are stopped from prompting for anything themselves
  # (e.g. https credentials or an ssh passphrase), though an ssh agent like
  # 1Password's may still ask to approve using a key.
  (( $+commands[git] )) || return 0

  local entry repo stamp
  local -a recent
  for entry in $PROMPT_REPOS; do
    repo=${entry#*|}
    [[ -d $repo/.git ]] || continue

    # Git updates FETCH_HEAD after a successful fetch. The stamp (named after
    # the repo's path, with / replaced by %) is touched when a fetch starts, so
    # one that fails or hangs isn't retried at every prompt.
    stamp=$_prompt_fetch_stamps/${repo//\//%}
    recent=($repo/.git/FETCH_HEAD(N.mm-60) $stamp(N.mm-60))
    (( $#recent )) && continue

    mkdir -p $_prompt_fetch_stamps && touch $stamp
    GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-ssh} -o BatchMode=yes" \
      git -C $repo fetch --quiet >/dev/null 2>&1 &!
  done
}

# Values already base64 encoded by _prompt_set_user_var, since running base64
# is the slowest part of setting the title. E.g. the host is sent before every
# prompt and command but only needs encoding once. Unlike the variables in the
# functions this is global, so that it persists between calls.
typeset -gA _prompt_base64_cache

function _prompt_set_user_var {
  # Set the terminal user var name to value, or unset it if value is empty. This
  # uses the \e]1337;SetUserVar=name=value\a escape sequence (OSC 1337,
  # originally from iTerm2, but also supported by e.g. kitty and WezTerm). The
  # value is base64 encoded and leaving out "=value" unsets the var.
  local name=$1 value=$2
  local encoded=""
  if [[ -n $value ]]; then
    encoded=${_prompt_base64_cache[$value]}
    if [[ -z $encoded ]]; then
      # GNU base64 wraps long output, so remove any newlines.
      encoded=$(print -rn -- $value | base64)
      encoded=${encoded//$'\n'/}
      _prompt_base64_cache[$value]=$encoded
    fi
    encoded="=$encoded"
  fi
  print -rn -- $'\e]1337;SetUserVar='"$name$encoded"$'\a'
}

function _prompt_set_title {
  # Set the title to the host and the running command or just the host if the
  # passed command is empty. This also sets the shell_host and shell_cmd user
  # vars which can be used by terminal emulators that support OSC 1337 (see
  # kitty/tab_bar.py for an example). The user vars are sent first since kitty
  # redraws the tab bar when the title changes. Inside tmux the user vars are
  # skipped because tmux doesn't pass them through, so the terminal keeps
  # whatever was set when tmux was started (e.g. "host: tmux").
  local cmd=$1
  local host=${(%):-%m}
  if [[ -z $TMUX ]]; then
    _prompt_set_user_var shell_host $host
    _prompt_set_user_var shell_cmd $cmd
  fi
  print -rn -- $'\e]0;'"$host${cmd:+: $cmd}"$'\a'
}

function _prompt_set_title_preexec {
  # Before each command set the title to the host and command, where the
  # command is just its name: the first word of the command line as typed
  # ($1), without its path and with any control characters removed. Variable
  # assignments (e.g. "FOO=1 make") are skipped, as is env and its options so
  # the command it runs is shown. Similarly sudo and its options are skipped,
  # but the command is shown as "sudo cmd".
  local -a words=(${(z)1})
  local prefix=""

  # Options taking an argument (which also has to be skipped) for env or sudo,
  # including when last in a group of options (e.g. "sudo -Eu root").
  local arg_opts=""

  # Stop at the last word, so e.g. "sudo -i" shows as "sudo -i".
  while (( $#words > 1 )); do
    case $words[1] in
      ([[:alpha:]_]*=*)
        shift words
        ;;
      (env|*/env)
        arg_opts="(-|-[!-]*)[uCSP]"
        shift words
        ;;
      (sudo|*/sudo)
        prefix="sudo "
        arg_opts="(-|-[!-]*)[ugpCDrtTU]"
        shift words
        ;;
      (-*)
        # Only skip options after env or sudo.
        [[ -n $arg_opts ]] || break
        [[ $words[1] == ${~arg_opts} ]] && shift words
        shift words
        ;;
      (*)
        break
        ;;
    esac
  done

  local cmd=$prefix${words[1]:t}
  cmd=${cmd//[[:cntrl:]]/}
  _prompt_set_title $cmd
}

function _prompt_reset_term_modes {
  # Turn off terminal modes a program may have left on if it died without
  # cleaning up, e.g. tmux over an ssh connection that dropped. Nothing at a
  # prompt should have them on: focus reporting, mouse tracking (X10, normal,
  # button, any and SGR) and a hidden cursor.
  print -rn -- $'\e[?1004l\e[?9l\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?25h'
}

# Only show the right prompt (the repo icons) on the current prompt, removing
# it from earlier ones once their command runs.
setopt TRANSIENT_RPROMPT

# add-zsh-hook doesn't add a function twice if this file is sourced again.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_reset_term_modes
add-zsh-hook precmd _prompt_fetch_repos
add-zsh-hook precmd _prompt_set
add-zsh-hook precmd _prompt_set_title
add-zsh-hook preexec _prompt_set_title_preexec
