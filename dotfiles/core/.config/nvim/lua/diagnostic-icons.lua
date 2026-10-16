-- The icon for each diagnostic severity. The signs in the margin (options.lua),
-- the statusline (lualine.lua) and the diagnostics picker (snacks.lua) all use
-- these, so they match.
return {
  error = "\u{f015a}", -- nf-md-close_circle
  warn = "\u{f002a}", -- nf-md-alert
  info = "\u{f02fd}", -- nf-md-information
  hint = "\u{f0336}", -- nf-md-lightbulb
}
