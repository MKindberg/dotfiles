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
}

return config
