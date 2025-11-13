---@meta

--- Configuration table for the statuscolumn.
---@class statuscolumn.config
---
---@field force_attach? string[] List of `statuscolumn` values to ignore when attaching.
---
---@field ignore_filetypes string[] Filetypes to ignore when attaching.
---@field ignore_buftypes string[] Buffer types to ignore when attaching.
---
---@field condition? fun(buffer: integer, window: integer): boolean Additional condition for attaching to windows.
---
---@field default statuscolumn.style Default style.
---@field [string] statuscolumn.style Named style.


--[[ Style for the `statuscolumn`. ]]
---@class statuscolumn.style
---
---@field condition? fun(buffer: integer, window: integer): boolean Condition for this style.(unused when style is `default`)
---@field components statuscolumn.component[] Components for this style.


---@alias statuscolumn.component
---| statuscolumn.components.border Border.
---| statuscolumn.components.custom Custom text.
---| statuscolumn.components.empty Empty column.
---| statuscolumn.components.folds Fold column.
---| statuscolumn.components.lnum Line numbers.
---| statuscolumn.components.signs Sign column.

-----------------------------------------------------------------------------

--[[ Line numbers. ]]
---@class statuscolumn.components.lnum
---
---@field kind "lnum"
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean Condition for this component.
---
---@field click? boolean | fun(buffer: integer, window: integer, statuscolumn: string): boolean
---
---@field mode
---| 1 Absolute line number.
---| 2 Relative line number.
---| 3 Hybrid line number.
---
---@field wrap_markers string | string[] Text used for the wrapped lines. Can be a list to change the character used for `n`th wrapped line.
---@field virt_markers string | string[] Text used for the virtual lines. Can be a list to change the character used for `n`th virtual line.
---
---@field wrap_hl? string | string[] Highlight group for `wrap_markers`. Can be a list to create a *gradient effect*(relative to the main line).
---@field virt_hl? string | string[] Highlight group for `virt_markers`. Can be a list to create a *gradient effect*(relative to the main line).
---
---@field hl? string | string[] | fun(buffer: integer, window: integer): ( string | string[] ) Highlight group for the line numbers. Can be a list to create a *gradient effect*(relative to current line).


--[[ Empty column. ]]
---@class statuscolumn.components.empty
---
---@field kind "empty"
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean Condition for this component.
---
---@field width integer How many columns should this span?
---@field hl? string Highlight group for this component.


--[[ Border. ]]
---@class statuscolumn.components.border
---
---@field kind "border"
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean Condition for this component.
---
---@field text string | string[] Text to use for the border. Can be a list to change the character used for `n`th line relative to the current line..
---@field hl? string | string[] Highlight group for the border. Can be a list to change the highlight group used for `n`th line relative to the current line..


--[[ Fold column. ]]
---@class statuscolumn.components.folds
---
---@field kind "folds"
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean Condition for this component.
---
---@field close_text string | string[] Text used for indicating a closed fold. Can be a list to change the character used for the `n`th fold level.
---@field close_hl? string | string[] Highlight group used for indicating a closed fold. Can be a list to change the Highlight group used for the `n`th fold level.
---
---@field open_text string | string[] Text used for indicating a opened fold. Can be a list to change the character used for the `n`th fold level.
---@field open_hl? string | string[] Highlight group used for indicating a opened fold. Can be a list to change the Highlight group used for the `n`th fold level.
---
---@field scope_text string | string[] Text used for indicating the scope of a fold. Can be a list to change the character used for the `n`th fold level.
---@field scope_hl? string | string[] Highlight group used for indicating the scope of a fold. Can be a list to change the Highlight group used for the `n`th fold level.
---
---@field scope_end_text string | string[] Text used for indicating the end of scope of a fold. Can be a list to change the character used for the `n`th fold level.
---@field scope_end_hl? string | string[] Highlight group used for indicating the end of scope of a fold. Can be a list to change the Highlight group used for the `n`th fold level.
---
---@field scope_merge_text string | string[] Text used for indicating the change of fold level. Can be a list to change the character used for the `n`th fold level where the level is shifting from `n -> m`.
---@field scope_merge_hl? string | string[] Highlight group used for indicating the change of fold level. Can be a list to change the highlight group used for the `n`th fold level where the level is shifting from `n -> m`.
---
---@field fill_text string Text for normal lines.
---@field fill_hl? string Highlight group for `fill_text`.


--[[ Sign column. ]]
---@class statuscolumn.components.signs
---
---@field kind "signs"
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean Condition for this component.
---
---@field filter? fun(buffer: integer, ns_map: table<integer, string>, ns: integer, row: integer, col: integer, extmark: table): boolean Filter for signs.
---@field hl? string Custom highlight group for the signs.


--[[ Custom component. ]]
---@class statuscolumn.components.custom
---
---@field kind "custom"
---@field condition? fun(buffer: integer, window: integer, statuscolumn: string): boolean Condition for this component.
---
---@field value
---| string
---| fun(buffer: integer, window: integer, statuscolumn: string): string


