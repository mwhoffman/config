# zsh prompt function.

function _parse_pwd {
  # The variable $PWD_PATHS can be set to a space-separated list of global
  # paths with a single capture group () each. Any of these paths which match
  # the base path of $PWD will be abbreviated as "//foo/bar" where the base
  # component has been removed and replaced with "//". The string in the
  # capture-group will be assigned to $PWD_NAME which can then be used in $PS1
  # below.

  PWD_=$PWD
  PWD_NAME=""

  # Rewrite $PWD using any of the paths in $PWD_ARRAY. See above for an
  # explanation of how this is used.
  if [[ -n $PWD_PATH ]]; then
    if [[ $PWD_ =~ "^$PWD_PATH/?" ]]; then
      PWD_="//${PWD_#$MATCH}"
      PWD_NAME=$match[1]
    fi
  fi

  # Rewrite $PWD to translate $HOME into ~.
  if [[ $PWD_ == ${HOME}* ]]; then
    PWD_="~${PWD_#$HOME}"
  fi
}

function _parse_branch {
  # The VCS branch/status of the current directory (if applicable).
  BRANCH=""
  BRANCH_STAGED=0
  BRANCH_UNSTAGED=0
  BRANCH_UNTRACKED=0
  BRANCH_CONFLICT=0
  BRANCH_AHEAD=0
  BRANCH_BEHIND=0

  # Get the git branch/status; do this before mercurial because it's faster.
  if [[ -z "${BRANCH}" ]]; then
    BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)
    if [[ -n $BRANCH ]]; then
      STATUS=$(git status --porcelain --branch)
      for line in ${(f)STATUS}; do
        if [[ $line == 'M'* ]]; then BRANCH_STAGED=1; fi
        if [[ $line == 'A'* ]]; then BRANCH_STAGED=1; fi
        if [[ $line == 'D'* ]]; then BRANCH_STAGED=1; fi
        if [[ $line == 'U'* ]]; then BRANCH_CONFLICT=1; fi
        if [[ $line =~ '.[MD].*' ]]; then BRANCH_UNSTAGED=1; fi
        if [[ $line =~ '\?\?.*' ]]; then BRANCH_UNTRACKED=1; fi
        if [[ $line == '## '*'[ahead '*']' ]]; then BRANCH_AHEAD=1; fi
        if [[ $line == '## '*'[behind '*']' ]]; then BRANCH_BEHIND=1; fi
      done
    fi
  fi

  # Get the mercurial branch/status.
  if [[ -z "${BRANCH}" ]]; then
    BRANCH=$(chg branch 2>/dev/null)
    if [[ -n $BRANCH ]]; then
      STATUS=$(chg status)
      for line in ${(f)STATUS}; do
        if [[ $line =~ '[MA!] .*' ]]; then BRANCH_UNSTAGED=1; fi
        if [[ $line == '? '* ]]; then BRANCH_UNTRACKED=1; fi
      done
    fi
  fi
}

function _make_prompt {
  _parse_pwd
  _parse_branch

  PROMPT=""
  CARAT1=$'\uf105'
  CARAT2=$'\uf101'

  # Add the hostname.
  PROMPT+="%F{yellow}%B%m%b%f"
  PROMPT+=" $CARAT1 "

  # Add the current virtual environment's name.
  if [[ -n $VIRTUAL_ENV ]]; then
    if [[ $VIRTUAL_ENV:t == ".venv" ]]; then
      PROMPT+="%B${VIRTUAL_ENV:h:t}%b"
    elif [[ -n $VIRTUAL_ENV ]]; then
      PROMPT+="%B${VIRTUAL_ENV:t}%b"
    fi
    PROMPT+="  "
  fi

  # If we're in a named directory then add the name.
  if [[ -n $PWD_NAME ]]; then
    PROMPT+="%F{blue}%B$PWD_NAME%b%f"
    PROMPT+=" $CARAT1 "
  fi

  # Add the current working directory.
  PROMPT+="%F{blue}%B$PWD_%b%f"

  # If we're in a VCS directory then add the name/status of the current branch.
  if [[ -n $BRANCH ]]; then
    PROMPT+=" on %F{cyan}"
    PROMPT+=$'\ue725'
    PROMPT+=" %B$BRANCH"
    if [[ $BRANCH_STAGED -gt 0 || $BRANCH_UNSTAGED -gt 0 ||
          $BRANCH_UNTRACKED -gt 0 || $BRANCH_AHEAD -gt 0 ||
          $BRANCH_BEHIND -gt 0 ]]; then
      PROMPT+=" "
    fi
    if [[ $BRANCH_STAGED -gt 0 ]]; then
      PROMPT+=""
    fi
    if [[ $BRANCH_UNSTAGED -gt 0 ]]; then
      PROMPT+=""
    fi
    if [[ $BRANCH_CONFLICT -gt 0 ]]; then
      PROMPT+="!"
    fi
    if [[ $BRANCH_UNTRACKED -gt 0 ]]; then
      PROMPT+="?"
    fi
    if [[ $BRANCH_AHEAD -gt 0 ]]; then
      PROMPT+=""
    fi
    if [[ $BRANCH_BEHIND -gt 0 ]]; then
      PROMPT+=""
    fi
    PROMPT+="%b%f"
  fi

  # Add the trailing part of the prompt.
  PROMPT+=" $CARAT2 "
}

function _make_title {
  print -Pn "\e]0;%m\a"
}

precmd_functions+=(_make_prompt)
precmd_functions+=(_make_title)
