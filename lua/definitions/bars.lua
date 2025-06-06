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
