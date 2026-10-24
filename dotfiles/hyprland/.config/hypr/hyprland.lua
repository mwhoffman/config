-- Hyprland config.

-- Include configs for the monitor/mouse/keyboard as well as general look and
-- feel of the GUI.
require("input_output")
require("look_and_feel")

-- Define mod keys.
local mainMod = "SUPER"
local shftMod = "SHIFT+SUPER"

-- "Default" programs and commands.
local terminal = "ghostty"
local browser = "firefox"
local volumeUp = "wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
local volumeDn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
local volumeMt = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

-- Autostart.
hl.on("hyprland.start", function ()
  hl.exec_cmd("qs")
  hl.exec_cmd("1password --silent")
end)

-- "Global" launcher mods.
hl.bind(mainMod .. " + SPACE", hl.dsp.global("quickshell:launcher"))
hl.bind(shftMod .. " + Q", hl.dsp.global("quickshell:powerMenu"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- Window management.
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(shftMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"))

-- Move focus.
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move the current window.
hl.bind(shftMod .. " + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(shftMod .. " + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(shftMod .. " + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(shftMod .. " + L", hl.dsp.window.move({ direction = "right" }))

-- Switch workspace focus or move the current window to a workspace.
for i = 1, 10 do
  hl.bind(mainMod .. " + " .. i % 10, hl.dsp.focus({ workspace = i }))
  hl.bind(shftMod .. " + " .. i % 10, hl.dsp.window.move({ workspace = i }))
end

-- Move/resize windows with mod + left/right mouse and dragging.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volumeUp), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volumeDn), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volumeMt))
hl.bind("XF86AudioPlay", hl.dsp.global("quickshell:mediaPlayPause"))
hl.bind("XF86AudioNext", hl.dsp.global("quickshell:mediaNext"))
hl.bind("XF86AudioPrev", hl.dsp.global("quickshell:mediaPrevious"))
