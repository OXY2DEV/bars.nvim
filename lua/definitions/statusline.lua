--- Type definitions for the statusline.
---@meta

local M = {};


--- Statusline state variable(s).
---@class statusline.state
---
--- When `true`, attach to new windows.
---@field enable boolean
--- List of attached windows.
---@field attached_windows { [integer]: boolean }

-----------------------------------------------------------------------------

--- Statusline configuration table.
---@class statusline.config
---
--- Filetypes to ignore.
---@field ignore_filetypes? string[]
--- Buftypes to ignore.
---@field ignore_buftypes? string[]
---
---@field condition? fun(buffer: integer): boolean | nil
---
--- Default configuration.
---@field default statusline.group
--- Custom configuration group {string}.
---@field [string] statusline.group


--- Configuration group.
---@class statusline.group
---
--- Condition for this group.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
--- Parts of this statusline group.
---@field parts table[]

-----------------------------------------------------------------------------

--- Section
---@class statusline.parts.section
---
---@field kind? "section"
---
---@field corner_left? string
---@field padding_left? string
---@field icon? string
---
---@field text? string
---
---@field padding_right? string
---@field corner_right? string
---
---
---@field hl? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---@field icon_hl? string
---
---@field text_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Mode.
---@class statusline.parts.mode
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
---@field kind "mode"
---@field min_width? integer
---
---@field default statusline.parts.section
---@field [string] statusline.parts.section

-----------------------------------------------------------------------------

--- Buffer name.
---@class statusline.parts.bufname
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
---@field kind "bufname"
---@field max_len? integer
---@field truncate_symbol? string
---
---@field default bufname.opts
---@field [string] bufname.opts


---@class bufname.opts
---
---@field corner_left? string
---@field padding_left? string
---
---@field icon? string
---@field nomodifiable_icon? string
---
---@field text? string
---
---@field padding_right? string
---@field corner_right? string
---
---
---@field hl? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string[] | string
---@field nomodifiable_icon_hl? string
---
---@field text_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Empty space.
---@class statusline.parts.empty
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
---@field kind "empty"
---@field hl? string

-----------------------------------------------------------------------------

--- Diagnostics count.
---@class statusline.parts.diagnostics
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
---@field kind "diagnostics"
---@field auto_hide? boolean
---@field default_mode?
---| 1 Error
---| 2 Warning
---| 3 Info
---| 4 Hint
---| 5 All of the above
---
---@field error_icon? string
---@field error_hl? string
---
---@field warn_icon? string
---@field warn_hl? string
---
---@field info_icon? string
---@field info_hl? string
---
---@field hint_icon? string
---@field hint_hl? string
---
---@field empty_icon? string
---@field empty_text? string
---@field empty_hl? string
---
---@field separator? string
---@field separator_hl? string
---
---@field corner_left? string
---@field corner_left_hl? string
---
---@field padding_left? string
---@field padding_left_hl? string
---
---@field padding_right? string
---@field padding_right_hl? string
---
---@field corner_right? string
---@field corner_right_hl? string
---
---@field hl? string

-----------------------------------------------------------------------------

--- Git branch.
---@class statusline.parts.branch
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
---@field kind "branch"
---@field throttle? integer
---
---@field default statusline.parts.section
---@field [string] statusline.parts.section

-----------------------------------------------------------------------------

--- Custom ruler.
---@class statusline.parts.ruler
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
---@field kind "ruler"
---
---@field default ruler.opts
---@field visual ruler.opts


---@class ruler.opts
---
---@field separator? string
---@field separator_hl? string
---
---@field corner_left? string
---@field corner_left_hl? string
---
---@field padding_left? string
---@field padding_left_hl? string
---
---@field icon? string
---@field icon_hl? string
---
---@field padding_right? string
---@field padding_right_hl? string
---
---@field corner_right? string
---@field corner_right_hl? string
---
---@field hl? string

-----------------------------------------------------------------------------

return M;
