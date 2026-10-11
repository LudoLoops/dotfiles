-- DMS default keybinds (Hyprland 0.55+ Lua)

-- === Application Launchers ===
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"), { description = "Open Ghostty" })
hl.bind("SUPER + space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"), { description = "Open full launcher" })
hl.bind("ALT + space", hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"), { description = "Open compact launcher" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"), { description = "Open clipboard history" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"), { description = "Open process manager" })
hl.bind("SUPER + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"), { description = "Open DMS settings" })
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"), { description = "Toggle notifications" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"), { description = "Toggle notepad" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd("dms ipc call dash toggle wallpaper"), { description = "Open wallpaper picker" })
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"), { description = "Toggle overview" })
hl.bind("SUPER + O", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"), { description = "Toggle overview" })
hl.bind("SUPER + X", hl.dsp.exec_cmd("dms ipc call powermenu toggle"), { description = "Open power menu" })

-- === Cheat sheet
hl.bind("SUPER + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"), { description = "Show keyboard shortcuts" })

-- === Security ===
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"), { description = "Lock screen" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exit(), { description = "Exit Hyprland" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"), { description = "Open process manager" })

-- === Audio Controls ===
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true, description = "Increase volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true, description = "Decrease volume" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true, description = "Toggle audio mute" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true, description = "Toggle microphone mute" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true, description = "Play or pause media" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true, description = "Play or pause media" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true, description = "Previous media track" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true, description = "Next media track" })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 3"), { locked = true, repeating = true, description = "Increase media player volume" })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 3"), { locked = true, repeating = true, description = "Decrease media player volume" })

-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true, description = "Increase brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true, description = "Decrease brightness" })

-- === Window Management ===
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close focused window" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle maximized window" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle fullscreen window" })
hl.bind("SUPER + SHIFT + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating window" })
hl.bind("SUPER + W", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"), { description = "Open window rules" })

-- === Focus Navigation ===
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }), { description = "Focus window left" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }), { description = "Focus window down" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }), { description = "Focus window up" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }), { description = "Focus window right" })
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "Focus window left" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "Focus window down" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "Focus window up" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "Focus window right" })

-- === Window Movement ===
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })

-- === Column Navigation ===
hl.bind("SUPER + Home", hl.dsp.focus({ window = "first" }), { description = "Focus first window" })
hl.bind("SUPER + End", hl.dsp.focus({ window = "last" }), { description = "Focus last window" })

-- === Monitor Navigation ===
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ monitor = "l" }), { description = "Focus left monitor" })
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ monitor = "r" }), { description = "Focus right monitor" })
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ monitor = "l" }), { description = "Focus left monitor" })
hl.bind("SUPER + CTRL + J", hl.dsp.focus({ monitor = "d" }), { description = "Focus down monitor" })
hl.bind("SUPER + CTRL + K", hl.dsp.focus({ monitor = "u" }), { description = "Focus up monitor" })
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ monitor = "r" }), { description = "Focus right monitor" })

-- === Move to Monitor ===
hl.bind("SUPER + SHIFT + CTRL + left", hl.dsp.window.move({ monitor = "l" }), { description = "Move window to left monitor" })
hl.bind("SUPER + SHIFT + CTRL + down", hl.dsp.window.move({ monitor = "d" }), { description = "Move window to down monitor" })
hl.bind("SUPER + SHIFT + CTRL + up", hl.dsp.window.move({ monitor = "u" }), { description = "Move window to up monitor" })
hl.bind("SUPER + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "r" }), { description = "Move window to right monitor" })
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "l" }), { description = "Move window to left monitor" })
hl.bind("SUPER + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "d" }), { description = "Move window to down monitor" })
hl.bind("SUPER + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "u" }), { description = "Move window to up monitor" })
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "r" }), { description = "Move window to right monitor" })

-- === Workspace Navigation ===
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next existing workspace" })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous existing workspace" })
hl.bind("SUPER + U", hl.dsp.focus({ workspace = "e+1" }), { description = "Next existing workspace" })
hl.bind("SUPER + I", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous existing workspace" })
hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next existing workspace" })
hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous existing workspace" })
hl.bind("SUPER + CTRL + U", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next existing workspace" })
hl.bind("SUPER + CTRL + I", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous existing workspace" })

-- === Workspace Management ===
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("dms ipc call workspace-rename open"), { description = "Rename workspace" })

-- === Move Workspaces ===
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next existing workspace" })
hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous existing workspace" })
hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next existing workspace" })
hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous existing workspace" })

-- === Mouse Wheel Navigation ===
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next existing workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous existing workspace" })
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next existing workspace" })
hl.bind("SUPER + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous existing workspace" })

-- === Touchpad Gestures ===
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- === Numbered Workspaces ===
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }), { description = "Switch to workspace 1 (external monitor)" })
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }), { description = "Switch to workspace 2 (external monitor)" })
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }), { description = "Switch to workspace 3 (external monitor)" })
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }), { description = "Switch to workspace 4 (external monitor)" })
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }), { description = "Switch to workspace 5 (external monitor)" })
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }), { description = "Switch to workspace 6 (external monitor)" })
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }), { description = "Switch to workspace 7 (external monitor)" })
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }), { description = "Switch to workspace 8 (external monitor)" })
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }), { description = "Switch to workspace 9 (external monitor)" })

-- === Move to Numbered Workspaces ===
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }), { description = "Move window to workspace 1 (external monitor)" })
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }), { description = "Move window to workspace 2 (external monitor)" })
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }), { description = "Move window to workspace 3 (external monitor)" })
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }), { description = "Move window to workspace 4 (external monitor)" })
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }), { description = "Move window to workspace 5 (external monitor)" })
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }), { description = "Move window to workspace 6 (external monitor)" })
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }), { description = "Move window to workspace 7 (external monitor)" })
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }), { description = "Move window to workspace 8 (external monitor)" })
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }), { description = "Move window to workspace 9 (external monitor)" })

-- === Column Management ===
hl.bind("SUPER + bracketleft", hl.dsp.layout("preselect l"), { description = "Preselect left split" })
hl.bind("SUPER + bracketright", hl.dsp.layout("preselect r"), { description = "Preselect right split" })

-- === Sizing & Layout ===
hl.bind("SUPER + R", hl.dsp.layout("togglesplit"), { description = "Toggle split orientation" })
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "set" }), { description = "Maximize focused window" })

-- === Move/resize windows with mainMod + LMB/RMB and dragging ===
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Expand window left" })
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Shrink window left" })

-- === Manual Sizing ===
hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true, description = "Decrease window width" })
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true, description = "Increase window width" })
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true, description = "Decrease window height" })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true, description = "Increase window height" })

-- === Screenshots ===
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"), { description = "Take a screenshot" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"), { description = "Capture full screen" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"), { description = "Capture focused window" })

-- === Display Profiles ===
hl.bind("SUPER + P", hl.dsp.exec_cmd("dms ipc outputs cycleProfile"), { description = "Cycle display profile" })

-- === System Controls ===
hl.bind("SUPER + SHIFT + P", hl.dsp.dpms({ action = "toggle" }), { description = "Toggle display power" })
