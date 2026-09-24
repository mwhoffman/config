# zsh prompt function.
#
# The prompt is rebuilt before each command by _prompt_make. Helpers are also
# defined which uniformly return their results by setting the $reply array.
# _prompt_make unpacks these values to create the prompt. All variables are
# declared local so nothing should leak into the shell.

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
  # Return the git branch of the current directory and its status flags:
  # reply=(branch flags), or reply=() if this isn't a git directory. This uses a
  # single call to git; see "Porcelain Format Version 2" in git-status(1).
  reply=()

  # Check for git or return nothing.
  (( $+commands[git] )) || return

  # Run git status or return nothing.
  local git_status
  git_status=$(git status --porcelain=v2 --branch 2> /dev/null) || return

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

function _prompt_make {
  # Declared here so the helpers' results don't leak into the shell.
  local -a reply

  _prompt_parse_pwd
  local dir=$reply[1] dir_name=$reply[2]

  _prompt_parse_branch
  local branch=$reply[1] flags=$reply[2]

  local caret1=$'\uf105'       # single caret to separate prompt sections.
  local caret2=$'\uf101'       # double caret to end the prompt.
  local branch_icon=$'\ue725'  # git branch icon.

  # Below, text like directory and branch names is added with every "%" doubled
  # (${var//\%/%%}) so it's shown literally rather than read as a prompt escape
  # (e.g. a directory named "100%F{red}").
  PROMPT=""

  # Add the hostname.
  PROMPT+="%F{yellow}%B%m%b%f"
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
    PROMPT+=" on %F{cyan}${branch_icon} %B${branch//\%/%%}${flags:+ $flags}%b%f"
  fi

  # Add the trailing part of the prompt.
  PROMPT+=" ${caret2} "
}

function _prompt_make_title {
  # Set the terminal's window/tab title to the short hostname (%m). \e]0;...\a
  # is the escape sequence terminals read as "set the title", and print -P
  # expands prompt escapes like %m (-n skips the newline). Since this runs
  # before every prompt, it also resets the title after programs that change it
  # (e.g. ssh or nvim).
  print -Pn "\e]0;%m\a"
}

# add-zsh-hook doesn't add a function twice if this file is sourced again.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_make
add-zsh-hook precmd _prompt_make_title
