#!/usr/bin/zsh

# Update the config dir if it's older than a day.
GITDIR=${HOME}/config/
NOW=$(date +%s)
LAST_FETCH=$(stat -c '%Y' ${GITDIR}/.git/FETCH_HEAD)
if ((${NOW} - ${LAST_FETCH} >= 86400)); then
  git -C ${GITDIR} fetch
fi
