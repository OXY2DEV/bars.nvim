---@meta

---@alias bars.command
---| "Disable" Disable `bar/line` for **all** windows.
---| "Enable" Enable `bar/line` for **all** windows.
---| "Start" Start a `bar/line`.
---| "Stop" Stop a `bar/line`.
---| "Toggle" Toggle `bar/line` for **all** windows.
---| "disable" Disable `bar/line` for **specific** window.
---| "enable" Enable `bar/line` for **specific** window.
---| "toggle" Toggle `bar/line` for **specific** window.
---| "update" Update *style* of a `bar/line` for **specific** window.

--[[ Target for a command. ]]
---@alias bars.target
---| "statuscolumn"
---| "statusline"
---| "tabline"
---| "winbar"

--[[ Configuration for `bars.nvim`. ]]
---@class bars.config
---
---@field statuscolumn? table | boolean
---@field statusline? table | boolean
---@field tabline? table | boolean
---@field winbar? table | boolean
