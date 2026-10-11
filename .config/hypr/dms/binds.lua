-- DMS default keybinds (Hyprland 0.55+ Lua)

-- === Application Launchers ===
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"), { description = "Ghostty" })
hl.bind("SUPER + space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"), { description = "Launcher" })
hl.bind("ALT + space", hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"), { description = "Quick launcher" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"), { description = "Clipboard" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"), { description = "Processes" })
hl.bind("SUPER + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"), { description = "Settings" })
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"), { description = "Notifications" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"), { description = "Notepad" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd("dms ipc call dash toggle wallpaper"), { description = "Wallpapers" })
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"), { description = "Overview" })
hl.bind("SUPER + O", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"), { description = "Overview" })
hl.bind("SUPER + X", hl.dsp.exec_cmd("dms ipc call powermenu toggle"), { description = "Power menu" })

-- === Cheat sheet
hl.bind("SUPER + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"), { description = "Shortcuts" })

-- === Security ===
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"), { description = "Lock screen" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exit(), { description = "Exit session" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"), { description = "Processes" })

-- === Audio Controls ===
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true, description = "Mute audio" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true, description = "Mute mic" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true, description = "Play / Pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true, description = "Play / Pause" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true, description = "Previous track" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true, description = "Next track" })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 3"), { locked = true, repeating = true, description = "Media volume up" })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 3"), { locked = true, repeating = true, description = "Media volume down" })

-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true, description = "Brightness down" })

-- === Window Management ===
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Maximize" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Fullscreen" })
hl.bind("SUPER + SHIFT + T", hl.dsp.window.float({ action = "toggle" }), { description = "Floating mode" })
hl.bind("SUPER + W", hl.dsp.group.toggle(), { description = "Window group" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"), { description = "Window rules" })

-- === Focus Navigation ===
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })

-- === Window Movement ===
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }), { description = "Move left" })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }), { description = "Move down" })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }), { description = "Move up" })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }), { description = "Move right" })
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move left" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move down" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move up" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move right" })

-- === Column Navigation ===
hl.bind("SUPER + Home", hl.dsp.focus({ window = "first" }), { description = "First window" })
hl.bind("SUPER + End", hl.dsp.focus({ window = "last" }), { description = "Last window" })

-- === Monitor Navigation ===
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ monitor = "l" }), { description = "Left monitor" })
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ monitor = "r" }), { description = "Right monitor" })
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ monitor = "l" }), { description = "Left monitor" })
hl.bind("SUPER + CTRL + J", hl.dsp.focus({ monitor = "d" }), { description = "Lower monitor" })
hl.bind("SUPER + CTRL + K", hl.dsp.focus({ monitor = "u" }), { description = "Upper monitor" })
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ monitor = "r" }), { description = "Right monitor" })

-- === Move to Monitor ===
hl.bind("SUPER + SHIFT + CTRL + left", hl.dsp.window.move({ monitor = "l" }), { description = "Send to left monitor" })
hl.bind("SUPER + SHIFT + CTRL + down", hl.dsp.window.move({ monitor = "d" }), { description = "Send to lower monitor" })
hl.bind("SUPER + SHIFT + CTRL + up", hl.dsp.window.move({ monitor = "u" }), { description = "Send to upper monitor" })
hl.bind("SUPER + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "r" }), { description = "Send to right monitor" })
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "l" }), { description = "Send to left monitor" })
hl.bind("SUPER + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "d" }), { description = "Send to lower monitor" })
hl.bind("SUPER + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "u" }), { description = "Send to upper monitor" })
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "r" }), { description = "Send to right monitor" })

-- === Workspace Navigation ===
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next existing workspace" })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous existing workspace" })
hl.bind("SUPER + U", hl.dsp.focus({ workspace = "e+1" }), { description = "Next existing workspace" })
hl.bind("SUPER + I", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous existing workspace" })
hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Send to next existing" })
hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Send to previous existing" })
hl.bind("SUPER + CTRL + U", hl.dsp.window.move({ workspace = "e+1" }), { description = "Send to next existing" })
hl.bind("SUPER + CTRL + I", hl.dsp.window.move({ workspace = "e-1" }), { description = "Send to previous existing" })

-- === Workspace Management ===
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("dms ipc call workspace-rename open"), { description = "Rename workspace" })

-- === Move Workspaces ===
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Send to next existing" })
hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Send to previous existing" })
hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "e+1" }), { description = "Send to next existing" })
hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({ workspace = "e-1" }), { description = "Send to previous existing" })

-- === Mouse Wheel Navigation ===
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next existing workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous existing workspace" })
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Send to next existing" })
hl.bind("SUPER + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Send to previous existing" })

-- === Touchpad Gestures ===
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- === Numbered Workspaces ===
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }), { description = "Workspace 1 (external)" })
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }), { description = "Workspace 2 (external)" })
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }), { description = "Workspace 3 (external)" })
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }), { description = "Workspace 4 (external)" })
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }), { description = "Workspace 5 (external)" })
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }), { description = "Workspace 6 (external)" })
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }), { description = "Workspace 7 (external)" })
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }), { description = "Workspace 8 (external)" })
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }), { description = "Workspace 9 (external)" })

-- === Move to Numbered Workspaces ===
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }), { description = "Send to 1 (external)" })
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }), { description = "Send to 2 (external)" })
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }), { description = "Send to 3 (external)" })
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }), { description = "Send to 4 (external)" })
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }), { description = "Send to 5 (external)" })
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }), { description = "Send to 6 (external)" })
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }), { description = "Send to 7 (external)" })
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }), { description = "Send to 8 (external)" })
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }), { description = "Send to 9 (external)" })

-- === Column Management ===
hl.bind("SUPER + bracketleft", hl.dsp.layout("preselect l"), { description = "Split left" })
hl.bind("SUPER + bracketright", hl.dsp.layout("preselect r"), { description = "Split right" })

-- === Sizing & Layout ===
hl.bind("SUPER + R", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "set" }), { description = "Maximize window" })

-- === Move/resize windows with mainMod + LMB/RMB and dragging ===
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Resize left (-100)" })
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Resize right (+100)" })

-- === Manual Sizing ===
hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true, description = "Narrower window" })
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true, description = "Wider window" })
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true, description = "Shorter window" })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true, description = "Taller window" })

-- === Screenshots ===
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"), { description = "Screenshot" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"), { description = "Full screenshot" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"), { description = "Window screenshot" })

-- === Display Profiles ===
hl.bind("SUPER + P", hl.dsp.exec_cmd("dms ipc outputs cycleProfile"), { description = "Display profiles" })

-- === System Controls ===
hl.bind("SUPER + SHIFT + P", hl.dsp.dpms({ action = "toggle" }), { description = "Display power" })
