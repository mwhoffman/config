"""Custom tab drawing for kitty.

Tabs are drawn as "index host: cmd" (or "index host" with no command) with
slanted separators and colors. The host and command come from the shell_host
and shell_cmd user vars rather than the window title, since any program (e.g.
nvim or claude) can set the window title. The shell sets these (see
zsh/prompt.zsh) using OSC 1337 SetUserVar escapes, which kitty stores in
window.user_vars.

The command is only shown once it has been running for CMD_DELAY, so short
lived commands don't flash, and is dropped if the tab is too narrow. If
shell_host isn't set (e.g. while the shell starts) the local short hostname is
shown instead.
"""

# Tell ty where to find kitty's modules. Install them with `just
# _install-kitty-src` (see ~/config/justfile).
# /// script
# [tool.ty.environment]
# extra-paths = ["~/.local/share/kitty-src"]
# ///

import socket
import time

from kitty import fast_data_types as dt
from kitty import tab_bar as tb

# The local short hostname (like zsh's %m), which is shown if the shell hasn't
# set the shell_host user var, rather than kitty's initial title (e.g. "zsh").
HOST = socket.gethostname().split(".")[0]

# How long in seconds a command has to run before it's shown, so short lived
# commands (e.g. ls) don't flash in the tab.
CMD_DELAY = 0.5

# The last host and command seen for each window id and when they were first
# seen.
seen_vars: dict[int, tuple[str, str, float]] = {}


def redraw(timer_id: int | None) -> None:
  """Redraw all tab bars."""
  del timer_id
  for tab_manager in dt.get_boss().all_tab_managers:
    tab_manager.mark_tab_bar_dirty()

  # Marking the tab bars dirty only redraws them the next time kitty's main
  # loop runs, which otherwise waits for an event (e.g. output or a key press).
  dt.wakeup_main_loop()


def get_title(
  draw_data: tb.DrawData, tab: tb.TabBarData, max_tab_length: int, index: int
) -> str:
  """Get the tab's title from the shell, dropping the command if needed."""
  # The shell sets the shell_host and shell_cmd user vars (see prompt.zsh). Use
  # these rather than the regular title, which any program can set, or the
  # local host if shell_host isn't set.
  kitty_tab = dt.get_boss().tab_for_id(tab.tab_id)
  window = kitty_tab.active_window if kitty_tab else None
  if window is None:
    return HOST
  host = window.user_vars.get("shell_host") or HOST
  cmd = window.user_vars.get("shell_cmd", "")

  # Only show the command once it's been running for CMD_DELAY. When the host
  # or command changes, record the time and redraw again after the delay (plus
  # a little so the delay has definitely passed).
  now = time.monotonic()
  seen_host, seen_cmd, seen_time = seen_vars.get(window.id, ("", "", 0.0))
  if (host, cmd) != (seen_host, seen_cmd):
    seen_vars[window.id] = (host, cmd, now)
    seen_time = now
    if cmd:
      dt.add_timer(redraw, CMD_DELAY + 0.05, False)
  if not cmd or now - seen_time < CMD_DELAY:
    return host

  # The tab is drawn as "[bell]index sep title" plus 2 cells of padding (see
  # the templates and truncation in draw_tab), where the one cell separator
  # glyph is counted as a space here. If the title doesn't fit then use just
  # the host so it doesn't get truncated.
  title = f"{host}: {cmd}"
  width = dt.wcswidth(f"{index}   ") + 2 + dt.wcswidth(title)
  if tab.needs_attention and not tab.is_active:
    width += dt.wcswidth(draw_data.bell_on_tab)
  if width > max_tab_length:
    return host
  return title


def draw_tab(
  draw_data: tb.DrawData, screen: dt.Screen, tab: tb.TabBarData,
  before: int, max_tab_length: int, index: int, is_last: bool,
  extra_data: tb.ExtraData
) -> int:
  """Draw the tab."""
  del is_last

  tab = tab._replace(
    title=get_title(draw_data, tab, max_tab_length, index)
  )

  # This implements active slanted tabs with two colors, one for the index and
  # one for the title using standard/bright color variants.
  draw_data = draw_data._replace(
    title_template=(
      "\x1b[38;5;1m{bell_symbol}"    # Red bell.
      "\x1b[38;5;0m{index} "
      "\x1b[38;5;8m\x1b[48;5;7m "   # Gray inactive tab.
      "\x1b[38;5;0m{title}"
    ),
    active_title_template=(
      "\x1b[38;5;0m{index} "
      "\x1b[38;5;4m\x1b[48;5;12m "  # Blue active tab.
      "\x1b[38;5;0m{title}"
    ),
  )

  tab_bg = screen.cursor.bg
  separator_symbol = ""
  soft_separator_symbol = ""
  min_title_length = 1 + 2
  start_draw = 2

  if screen.cursor.x == 0:
    screen.cursor.bg = tab_bg
    screen.draw(" ")
    start_draw = 1

  screen.cursor.bg = tab_bg
  if min_title_length >= max_tab_length:
    screen.draw("…")
  else:
    tb.draw_title(draw_data, screen, tab, index, max_tab_length)
    extra = screen.cursor.x + start_draw - before - max_tab_length
    if extra > 0 and extra + 1 < screen.cursor.x:
      screen.cursor.x -= extra + 1
      screen.draw("…")

  tab_bg = screen.cursor.bg
  tab_fg = screen.cursor.fg
  default_bg = tb.as_rgb(int(draw_data.default_bg))
  if extra_data.next_tab:
    next_tab_bg = tb.as_rgb(draw_data.tab_bg(extra_data.next_tab))
    needs_soft_separator = next_tab_bg == tab_bg
  else:
    next_tab_bg = default_bg
    needs_soft_separator = False

  if not needs_soft_separator:
    screen.draw(" ")
    screen.cursor.fg = tab_bg
    screen.cursor.bg = next_tab_bg
    screen.draw(separator_symbol)
  else:
    prev_fg = screen.cursor.fg
    if tab_bg == tab_fg:
      screen.cursor.fg = default_bg
    elif tab_bg != default_bg:
      c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
      c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
      if c1 < c2:
        screen.cursor.fg = default_bg
    screen.draw(f" {soft_separator_symbol}")
    screen.cursor.fg = prev_fg

  end = screen.cursor.x
  if end < screen.columns:
    screen.draw(" ")
  return end
