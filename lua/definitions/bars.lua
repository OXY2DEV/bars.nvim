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
---@field statusline? statusline.config Statusline configuration.
---@field statuscolumn? statuscolumn.config Statuscolumn configuration.
---@field winbar? winbar.config Winbar configuration.
---
---@field tabline? tabline.config Tabline configuration.
