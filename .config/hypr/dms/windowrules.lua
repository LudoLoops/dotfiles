-- DMS Window Rules — managed by Dux Modular Shell
-- Do not edit manually; changes may be overwritten

-- DMS-RULE: id=dms-floating-windows, name=DMS Floating Windows
hl.window_rule({ match = { class = "^(dev\\.duxlabs\\.shell|com\\.danklinux\\.dms)$" }, float = true })

-- DMS-RULE: id=wr_1791853713234772270, name=zen
hl.window_rule({ match = { class = "^zen$", title = "^Picture-in-Picture$" }, float = true })

-- DMS-RULE: id=wr_1792723802544745494, name=steam_app_32370
hl.window_rule({ match = { class = "^steam_app_32370$" }, fullscreen = true })

-- DMS-RULE: id=wr_1794643289276456046, name=nm-connection-editor
hl.window_rule({ match = { class = "^nm-connection-editor$", float = true } })

-- DMS-RULE: id=dms-window-opaque, name=DMS Window Opaque
hl.window_rule({ match = { class = "^(dev\\.duxlabs\\.shell|com\\.danklinux\\.dms)$" }, opaque = true })
