local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Cobalt2'
config.use_fancy_tab_bar = false

config.font = wezterm.font 'Hasklug Nerd Font'

config.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }


local act = wezterm.action
config.keys = {
    {
        key = '|',
        mods = 'LEADER',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '-',
        mods = 'LEADER',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'z',
        mods = 'LEADER',
        action = act.TogglePaneZoomState,
    },
    {
        key = 'LeftArrow',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'RightArrow',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'UpArrow',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'LEADER',
        action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'LeftArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'RightArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'UpArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'LeftArrow',
        mods = 'LEADER|CTRL',
        action = act.AdjustPaneSize { 'Left', 5 },
    },
    {
        key = 'RightArrow',
        mods = 'LEADER|CTRL',
        action = act.AdjustPaneSize { 'Right', 5, },
    },
    {
        key = 'UpArrow',
        mods = 'LEADER|CTRL',
        action = act.AdjustPaneSize { 'Up', 5 },
    },
    {
        key = 'DownArrow',
        mods = 'LEADER|CTRL',
        action = act.AdjustPaneSize { 'Down', 5, },
    },
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab { DomainName = 'unix' },
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = act.ActivateTabRelative(-1),
    },
    {
        key = 'n',
        mods = 'LEADER',
        action = act.ActivateTabRelative(1),
    },
}
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = act.ActivateTab(i - 1),
    })
end

config.unix_domains = {
    {
        name = 'unix',
    },
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { 'connect', 'unix' }


return config
