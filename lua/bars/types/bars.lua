---@meta

--- Primary configuration table.
---@class bars.config
---
--- When true, all options are set
--- **globally**.
--- Can be used to prevent visible
--- changes to the bars & lines when
--- opening Neovim or new windows.
---@field global? boolean
---
--- Statusline configuration.
---@field statusline? boolean | statusline.config | fun(): (boolean | statusline.config)
---
--- Statuscolumn configuration.
---@field statuscolumn? boolean | statuscolumn.config | fun(): (boolean | statuscolumn.config)
---
--- Winbar configuration.
---@field winbar? boolean | winbar.config | fun(): (boolean | winbar.config)
---
--- Tabline configuration.
---@field tabline? boolean | tabline.config | fun(): (boolean | tabline.config)


--- State of a `module`.
---@class bars.mod.state
---
---@field enable boolean Should this module listen to Autocmds?
---@field attached_windows table<integer, boolean> Maps window state to it's ID. State is `true` when the module is in use for that window.

