---@meta

--- Statuscolumn state variables.
---@class statuscolumn.state
---
--- Is the module enabled?
---@field enable boolean
---
---@field attached_windows table<integer, boolean>

-----------------------------------------------------------------------------

--- Configuration table for the statuscolumn.
---@class statuscolumn.config
---
--- Filetypes to ignore.
---@field ignore_filetypes string[]
--- Buftypes to ignore.
---@field ignore_buftypes string[]
---
--- Additional condition for attaching to
--- windows.
---@field condition? fun(buffer: integer, window: integer): boolean | nil
---
--- Default style.
---@field default statuscolumn.style
---
--- Configuration style.
---@field [string] statuscolumn.style

--- A configuration style.
--- Must have a condition(unless `default`)
--- and a list of parts.
---@class statuscolumn.style
---
---@field condition? fun(buffer: integer, window: integer): boolean Condition for this style.
---
--- Parts for this style.
---@field parts statuscolumn_part[]

---@alias statuscolumn_part
---| statuscolumn.parts.lnum Line number.
---| statuscolumn.parts.folds Fold column.
---| statuscolumn.parts.signs Sign column.
---| statuscolumn.parts.empty An empty column.
---| statuscolumn.parts.border A statuscolumn border. 

-----------------------------------------------------------------------------

--- Line number for statuscolumn.
---@class statuscolumn.parts.lnum
---
--- Condition for this component.
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean
---
---@field kind "lnum" What kind of part is this?
---
---@field click? boolean | fun(buffer: integer, window: integer, statuscolumn: string): boolean
---
---@field mode
---| 1 Line number.
---| 2 Relative line number.
---| 3 Hybrid line number.
---
--- Text used for the wrapped lines.
--- Can be a list to create a *fake* gradient effect.
---@field wrap_markers string | string[]
---
--- Text used for the virtual lines.
--- Can be a list to create a *fake* gradient effect.
---@field virt_markers string | string[]
---
--- Highlight group for `wrap_markers`.
--- Can be a list to create a color gradient.
---@field wrap_hl? string | string[]
---
--- Highlight group for `virt_markers`.
--- Can be a list to create a color gradient.
---@field virt_hl? string | string[]
---
--- Highlight group for the line numbers.
--- Can be a list to create a color gradient.
---@field hl? string | string[]


---@class statuscolumn.parts.empty
---
---@field kind "empty"
---@field len integer
---
---@field hl? string


---@class statuscolumn.parts.border
---
---@field kind "border"
---
---@field text string | string[]
---@field hl? string | string[]


---@class statuscolumn.parts.folds
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


---@class statuscolumn.parts.signs
---
---@field kind "signs"
---@field hl? string



