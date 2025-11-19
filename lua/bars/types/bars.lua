---@meta

--- Primary configuration table.
---@class bars.config
---
---@field global? boolean When true, all options are set **globally**.
---
---@field statusline?
---| boolean Set to `false` to disable the statusline module.
---| statusline.config Configuration for the `statusline` module.
---| fun(): (boolean | statusline.config) Dynamic value(evaluated during `setup()` call).
---
---@field statuscolumn?
---| boolean Set to `false` to disable the statuscolumn module.
---| statuscolumn.config Configuration for the `statuscolumn` module.
---| fun(): (boolean | statuscolumn.config) Dynamic value(evaluated during `setup()` call).
---
---@field winbar?
---| boolean Set to `false` to disable the winbar module.
---| winbar.config Configuration for the `winbar` module.
---| fun(): (boolean | winbar.config) Dynamic value(evaluated during `setup()` call).
---
---@field tabline?
---| boolean Set to `false` to disable the tabline module.
---| tabline.config Configuration for the `tabline` module.
---| fun(): (boolean | tabline.config) Dynamic value(evaluated during `setup()` call).


--[[ State of a `module` of `bars.nvim`. ]]
---@class bars.mod.state
---
---@field enable boolean When `true`, the module will listen to various events and attach to *valid* windows.
---@field attached_windows table<integer, boolean> Map between the `window` and whether the module is in use for that window.

