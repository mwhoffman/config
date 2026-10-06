#!/usr/bin/env python3
"""Claude Code status line.

This prints the vim mode left aligned followed by the project, model, and
session/weekly usage right aligned.
"""

import json
import os
import sys


# Columns that Claude Code's own spacing takes away from the terminal width.
MARGIN = 4

# Weekly usage percentage above which it is shown alongside session usage.
WEEKLY_THRESHOLD = 80


def main():
  data = json.load(sys.stdin)

  # Get the vimmode. It will be None if vim doesn't exist.
  vimmode = (data.get("vim") or {}).get("mode")

  # Try to get the project/model names or note if they don't exist.
  workspace = data.get("workspace") or {}
  project = os.path.basename(workspace.get("project_dir") or "UNKNOWN PROJECT")
  model = (data.get("model") or {}).get("display_name") or "UNKNOWN MODEL"

  # Get the rate limits; they're not reported until the first interaction.
  limits = data.get("rate_limits") or {}
  session = (limits.get("five_hour") or {}).get("used_percentage")
  weekly = (limits.get("seven_day") or {}).get("used_percentage") or 0

  # Format usage.
  used = "--%" if session is None else f"{round(100-session)}%"
  if weekly > WEEKLY_THRESHOLD:
    used += f"; {round(100-weekly)}% weekly"

  # Formate left/right.
  left = f"-- {vimmode} --" if vimmode else ""
  right = f"{project} • {model} [{used}]"

  # Align everything and print it.
  width = int(os.environ.get("COLUMNS") or 80) - MARGIN
  gap = max(width - len(left) - len(right), 1)
  print(f"{left}{' ' * gap}{right}")


if __name__ == "__main__":
  main()
