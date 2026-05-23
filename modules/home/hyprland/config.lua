hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
hl.monitor({
	output = "DP-1",
	mode = "highrr",
	position = "auto",
	scale = "auto",
})
hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

local function monitor_set(mon)
	for i = 1, 9 do
		local ws = (mon.id * 9) + i
		hl.workspace_rule({ workspace = ws, monitor = mon.name, persistent = true })
		hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = mon.name }))
	end
	hl.workspace_rule({ workspace = (mon.id * 9) + 1, default = true })
end
local function workspaces_set()
	for _, mon in pairs(hl.get_monitors()) do
		monitor_set(mon)
	end
end

--variables and functions

local terminal = "kitty"

local function exec(cmd)
	return hl.dsp.exec_cmd(nix.pkgs.runapp .. " -- " .. cmd)
end
local function exec_term(cmd)
	return exec(terminal .. " " .. cmd)
end

-----

-- autostart
hl.on("hyprland.start", function()
	local function exec(cmd)
		hl.exec_cmd(nix.pkgs.runapp .. " -- " .. cmd)
	end
	exec(nix.pkgs.noctalia)
	workspaces_set()
end)

hl.on("monitor.added", monitor_set)

hl.on("config.reloaded", workspaces_set)

-- Look and feel

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		float_gaps = 10,
		resize_on_border = true,
		layout = "scrolling",
	},
	misc = {
		enable_anr_dialog = false,
		vrr = true,
	},
	input = {
		kb_layout = "br",
		follow_mouse = 1,
		touchpad = { natural_scroll = false },
		numlock_by_default = true,
	},
	decoration = {
		rounding = 5,
	},
	animations = {
		enabled = true,
	},
})

--layout configs
hl.config({
	master = {
		new_status = "inherit",
		new_on_top = true,
		special_scale_factor = 0.99,
	},
	scrolling = {
		column_width = 1,
		fullscreen_on_one_column = true,
		focus_fit_method = 1,
	},
})

--window rules
hl.window_rule({ match = { class = "(brave-browser)" }, workspace = 2 })
hl.window_rule({ match = { class = "(firefox)" }, workspace = 2 })
hl.window_rule({ match = { class = "(discord)" }, workspace = 6 })
hl.window_rule({ match = { class = "(WebCord)" }, workspace = 6 })
hl.window_rule({ match = { class = "(teams-for-linux)" }, workspace = 7 })
hl.window_rule({ match = { class = "(info.cemu.Cemu)" }, idle_inhibit = "focus" })

--layer rules
hl.layer_rule({
	name = "noctalia",
	match = { namespace = "noctalia-background-.*$" },
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

--keybindings
local mainMod = "SUPER"

local bind = hl.bind
local dsp = hl.dsp

local noctalia = function(cmd)
	return dsp.exec_cmd(nix.pkgs.noctalia .. " ipc call " .. cmd)
end

bind(mainMod .. " + SHIFT + C", dsp.window.close())
bind(
	mainMod .. " + SHIFT + Q",
	dsp.exec_cmd(
		"command -v "
			.. nix.pkgs.hyprshutdown
			.. " >/dev/null 2>&1 && "
			.. nix.pkgs.hyprshutdown
			.. " || hyprctl dispatch 'hl.dsp.exit()'"
	)
)
bind(mainMod .. " + T", dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + R", noctalia("launcher toggle"))
bind(mainMod .. " + P", exec("$(bemenu-run --binding vim)"))

-- Launch keybindings
bind(mainMod .. " + Return", exec(terminal))
bind(mainMod .. " + SHIFT + Return", exec("thunar"))
bind(mainMod .. " + B", exec("firefox"))
bind(mainMod .. " + V", noctalia("launcher clipboard"))

-- Move focus with mainMod + arrow keys
bind(mainMod .. " + left", dsp.focus({ direction = "left" }))
bind(mainMod .. " + right", dsp.focus({ direction = "right" }))
bind(mainMod .. " + up", dsp.focus({ direction = "up" }))
bind(mainMod .. " + down", dsp.focus({ direction = "down" }))

--workspaces
for i = 1, 9 do
	bind(mainMod .. " + " .. i, dsp.focus({ workspace = "r~" .. i, on_current_monitor = true }))
	bind(mainMod .. " + SHIFT + " .. i, dsp.window.move({ workspace = "r~" .. i }))
end
bind(mainMod .. " + 0", dsp.workspace.toggle_special())
bind(mainMod .. " + SHIFT + 0", dsp.window.move({ workspace = "special" }))

-- Move focus with mod + JK
bind(mainMod .. " + J", dsp.focus({ workspace = "r+1" }))
bind(mainMod .. " + K", dsp.focus({ workspace = "r-1" }))

-- move column
bind(mainMod .. " + H", dsp.layout("focus l"), { repeating = true })
bind(mainMod .. " + L", dsp.layout("focus r"), { repeating = true })
bind(mainMod .. " + SHIFT + H", dsp.layout("swapcol l"), { repeating = true })
bind(mainMod .. " + SHIFT + L", dsp.layout("swapcol r"), { repeating = true })
--
-- Focus or swap master
bind(mainMod .. " + M", dsp.layout("focusmaster"))
bind(mainMod .. " + SHIFT + M", dsp.layout("swapwithmaster"))
-- Add and remove masters
bind(mainMod .. " + I", dsp.layout("addmaster"))
bind(mainMod .. " + D", dsp.layout("removemaster"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind(mainMod .. " + mouse:272", dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", dsp.window.resize(), { mouse = true })

-- enter fullscreen
bind(mainMod .. " + SHIFT + F", dsp.window.fullscreen({ action = "toggle" }))

bind(mainMod .. " + F", dsp.layout("fit active"))
bind(mainMod .. " + C", dsp.layout("colresize 0.5"))
bind(mainMod .. " + minus", dsp.layout("colresize -0.1"))
bind(mainMod .. " + equal", dsp.layout("colresize +0.1"))

-- Monitors bindings
bind(mainMod .. " + period", dsp.focus({ monitor = "l" }))
bind(mainMod .. " + comma", dsp.focus({ monitor = "r" }))
bind(mainMod .. " + CONTROL + l", dsp.focus({ monitor = "l" }))
bind(mainMod .. " + CONTROL + h", dsp.focus({ monitor = "r" }))

-- Move Windows throug monitors
bind(mainMod .. " + SHIFT + period", dsp.window.move({ monitor = "l" }))
bind(mainMod .. " + SHIFT + comma", dsp.window.move({ monitor = "r" }))
bind(mainMod .. " + SHIFT + CONTROL + l", dsp.window.move({ monitor = "l" }))
bind(mainMod .. " + SHIFT + CONTROL + h", dsp.window.move({ monitor = "r" }))

-- Open task manager
bind("CONTROL + SHIFT + ESCAPE", exec_term("btop"))

-- Laptop multimedia keys for volume and LCD brightness
bind(
	"XF86AudioRaiseVolume",
	dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioLowerVolume",
	dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
bind("XF86AudioMute", dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
bind(
	"XF86AudioMicMute",
	dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
bind(
	"XF86MonBrightnessUp",
	dsp.exec_cmd(nix.pkgs.brightnessctl .. " -e4 -n2 set 5%+"),
	{ locked = true, repeating = true }
)
bind(
	"XF86MonBrightnessDown",
	dsp.exec_cmd(nix.pkgs.brightnessctl .. " -e4 -n2 set 5%-"),
	{ locked = true, repeating = true }
)
-- Requires playerctl
bind("XF86AudioNext", dsp.exec_cmd(nix.pkgs.playerctl .. " next"), { locked = true })
bind("XF86AudioPause", dsp.exec_cmd(nix.pkgs.playerctl .. " play-pause"), { locked = true })
bind("XF86AudioPlay", dsp.exec_cmd(nix.pkgs.playerctl .. " play-pause"), { locked = true })
bind("XF86AudioPrev", dsp.exec_cmd(nix.pkgs.playerctl .. " previous"), { locked = true })

-- Notifications
bind("CONTROL + SPACE", noctalia("notifications dismissOldest"))
bind("CONTROL + SHIFT + SPACE", noctalia("notifications dismissAll"))
