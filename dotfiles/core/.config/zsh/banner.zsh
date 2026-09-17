#!/usr/bin/zsh

# Where is our config dir.
CONFIG="${HOME}/config/"
FETCH_HEAD="${CONFIG}/.git/FETCH_HEAD"

# Update the config dir if it's older than a day. The complicated mtime
# computation just makes sure stat works if we're using coreutils or bsd stat.
if [ ! -f "${FETCH_HEAD}" ] ||
   mtime=$(stat -c '%Y' "${FETCH_HEAD}" 2>/dev/null ||
           stat -f '%m' "${FETCH_HEAD}")
   (($(date +%s) - mtime >= 86400)); then
  git -C "${CONFIG}" fetch
fi

CONFIG_STATUS=$(git -C "${CONFIG}" status --porcelain --branch)
CONFIG_CHANGED=0
CONFIG_AHEAD=0
CONFIG_BEHIND=0

for line in "${(f)CONFIG_STATUS}"; do
  if [[ $line =~ '[ MADU?][ MD?].*' ]]; then CONFIG_CHANGED=1; fi
  if [[ $line == '## '*'[ahead '*']' ]]; then CONFIG_AHEAD=1; fi
  if [[ $line == '## '*'['*'behind '*']' ]]; then CONFIG_BEHIND=1; fi
done

RESET="\u001b[0m"
RED="\u001b[31m"
GREEN="\u001b[32m"
MAGENTA="\u001b[35m"

if [[ "${CONFIG_CHANGED}" -gt 0 ||
      "${CONFIG_AHEAD}" -gt 0 ||
      "${CONFIG_BEHIND}" -gt 0 ]]; then
  echo -n "config directory "
  if [[ "${CONFIG_CHANGED}" -gt 0 ]]; then
    echo -n "has ${RED}local changes${RESET}; "
  fi
  if [[ "${CONFIG_AHEAD}" -gt 0 ]]; then
    echo -n "is ${GREEN}ahead${RESET}; ";
  fi
  if [[ "${CONFIG_BEHIND}" -gt 0 ]]; then
    echo -n "is ${MAGENTA}behind${RESET}; ";
  fi
  echo
fi
