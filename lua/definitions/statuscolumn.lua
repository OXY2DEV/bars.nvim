---@meta


---@class statuscolumn.state
---
---@field enable boolean
---@field attached_windows { [integer]: boolean }


---@class statuscolumn.config
---
---@field ignore_filetypes string[]
---@field ignore_buftypes string[]
---
---@field condition? fun(buffer: integer): boolean | nil
---
---@field default table
---@field [string] table


---@class statuscolumn.lnum
---
---@field kind "lnum"
---@field mode
---| 1 Line number.
---| 2 Relative line number.
---| 3 Hybrid line number.
---
---@field wrap_markers string | string[]
---@field virt_markers string | string[]
---
---@field wrap_hl? string | string[]
---@field virt_hl? string | string[]
---
---@field hl? string | string[]


---@class statuscolumn.empty
---
---@field kind "empty"
---@field len integer
---
---@field hl? string


---@class statuscolumn.border
---
---@field kind "border"
---
---@field text string | string[]
---@field hl? string | string[]


---@class statuscolumn.folds
---
---@field kind "folds"
---
---@field close_text string | string[]
---@field close_hl? string | string[]
---
---@field open_text string | string[]
---@field open_hl? string | string[]
---
---@field scope_text string | string[]
---@field scope_hl? string | string[]
---
---@field scope_end_text string | string[]
---@field scope_end_hl? string | string[]
---
---@field scope_merge_text string | string[]
---@field scope_merge_hl? string | string[]
---
---@field fill_text string | string[]
---@field fill_hl? string


---@class statuscolumn.signs
---
---@field kind "signs"
---@field hl? string



