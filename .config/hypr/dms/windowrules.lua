-- DMS Window Rules — managed by DankMaterialShell
-- Do not edit manually; changes may be overwritten

-- DMS-RULE: id=dms-floating-windows, name=DMS Floating Windows
hl.window_rule({ match = { class = "^com.danklinux.dms$" }, float = true })

-- DMS-RULE: id=wr_1791853713234772270, name=zen
hl.window_rule({ match = { class = "^zen$", title = "^Picture-in-Picture$" }, float = true })

-- DMS-RULE: id=wr_1792723802544745494, name=steam_app_32370
hl.window_rule({ match = { class = "^steam_app_32370$" }, fullscreen = true })
