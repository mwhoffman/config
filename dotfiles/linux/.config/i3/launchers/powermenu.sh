#!/bin/bash

# Power menu script.

# Print the pids of apps with an icon in polybar's system tray, which may have
# no windows (e.g. 1Password). Each tray icon is a window embedded in the bar
# which carries its app's pid.
tray_pids() {
  local bars bar win
  bars=$(xwininfo -root -tree | awk '/\("polybar" "Polybar"\)/ {print $1}')
  for bar in $bars; do
    for win in $(xwininfo -tree -id "$bar" | awk '$1 ~ /^0x/ {print $1}'); do
      xprop -id "$win" _NET_WM_PID | grep -o '[0-9]*$'
    done
  done | sort -u | grep -vxF -f <(pgrep -x polybar)
}

# Succeed if any windows are still open. The [tiling] and [floating] criteria
# match app windows but not docks like polybar. Focusing also brings forward any
# window that's still open, e.g. one prompting about unsaved changes.
windows_open() {
  i3-msg -q '[tiling] focus' 2>/dev/null ||
    i3-msg -q '[floating] focus' 2>/dev/null
}

# Quit apps while the session is still intact, rather than letting them be torn
# down along with X and the session bus (which e.g. 1Password reports as not
# having been shut down properly). Windows are closed politely, as if by their
# close buttons, and tray apps are sent SIGTERM. Fails if anything is still
# running after 10s.
quit_apps() {
  local pids pid
  pids=$(tray_pids)
  i3-msg -q '[tiling] kill; [floating] kill'
  [ -n "$pids" ] && kill -TERM $pids
  for _ in $(seq 20); do
    sleep 0.5
    windows_open && continue
    for pid in $pids; do
      kill -0 "$pid" 2>/dev/null && continue 2
    done
    return 0
  done

  # List what's still running (there's no notification daemon, so use rofi).
  local apps
  apps=$(
    i3-msg -t get_tree | grep -o '"class":"[^"]*"' | cut -d'"' -f4 |
      grep -vx Polybar
    for pid in $pids; do ps -o comm= -p "$pid"; done
  )
  rofi -e "Cancelled, apps are still running: $(echo $apps | sed 's/ /, /g')"
  return 1
}

# The menu's actions.
lock_screen() { i3lock -i "$HOME/Wallpaper/haz-mat.png"; }
log_out() { quit_apps && i3-msg exit; }
reboot_system() { quit_apps && reboot; }
shut_down() { quit_apps && poweroff; }

# The menu's rows, each with three fields separated by "|": a label, the name
# of its icon, and the action to run when it's chosen.
ROWS=(
  "Lock Screen|xfsm-lock|lock_screen"
  "Log Out|xfsm-logout|log_out"
  "Reboot|xfsm-reboot|reboot_system"
  "Shutdown|xfsm-shutdown|shut_down"
)

# Print the rows' labels, each with its icon (passed with rofi's "\0icon\x1f"
# row option).
menu() {
  local row label icon
  for row in "${ROWS[@]}"; do
    IFS='|' read -r label icon _ <<<"$row"
    printf '%s\0icon\x1f%s\n' "$label" "$icon"
  done
}

# Show the menu. When an action is selected it's index will be put in INDEX.
INDEX=$(
  menu | rofi -i -dmenu -format i -l "${#ROWS[@]}" \
    -theme-str 'window { width: 300px; } inputbar { enabled: false; }'
)

# Run the chosen command.
[[ "$INDEX" =~ ^[0-9]+$ ]] && ((INDEX < ${#ROWS[@]})) || exit 1
IFS='|' read -r _ _ ACTION <<<"${ROWS[INDEX]}"
"$ACTION"
