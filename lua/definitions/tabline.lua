---@meta


---@class tabline.state
---
---@field enable boolean
---@field attached boolean

---@class tabline.config
---
--- Should tabline be set?
---@field condition? fun(): boolean
---
---@field default? tabline.opts
---@field [string]? tabline.opts


---@class tabline.opts
---
---@field condition? boolean | fun(): boolean
---@field parts (tabline.parts.empty | tabline.parts.tabs)[]


--- Empty tabline section.
---@class tabline.parts.empty
---
--- Section type.
---@field kind "empty"
---
--- Highlight group for the section.
---@field hl? string


---@class tabline.parts.tabs
---
--- Section type.
---@field kind "tabs"
---
--- Maximum number of tabs to show.
---@field max integer
---
--- List entry to start showing from.
---@field from integer
---
--- Text used to separate tabs.
---@field separator? string
--- Highlight group for the separator
---@field separator_hl? string
---
--- Text used to separate tabs.
---@field overflow? string
--- Highlight group for the separator
---@field overflow_hl? string
---
---
--- Text for the left navigation button.
---@field nav_left? string
--- Highlight group for the left navigation
--- button
---@field nav_left_hl? string
---
--- Text for the (locked) left navigation
--- button.
---@field nav_left_locked? string
--- Highlight group for the (locked) left
--- navigation button
---@field nav_left_locked_hl? string
---
---
--- Text for the right navigation button.
---@field nav_right? string
--- Highlight group for the right navigation
--- button
---@field nav_right_hl? string
---
--- Text for the (locked) right navigation
--- button.
---@field nav_right_locked? string
--- Highlight group for the (locked) right
--- navigation button
---@field nav_right_locked_hl? string
---
---@field active tabs.opts
---@field inactive tabs.opts


---@class tabs.opts
---
--- Format string to show window count
--- of a tab.
---@field win_count? string
---
--- Highlight group for window count.
---@field win_count_hl? string
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

