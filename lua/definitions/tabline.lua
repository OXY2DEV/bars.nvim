---@meta


--- State variables for the tabline module.
---@class tabline.state
---
--- Is the tabline enabled?
---@field enable boolean
---
--- Is the custom tabline attached?
---@field attached boolean


--- Configuration table for the tabline.
---@class tabline.config
---
--- Should tabline be set?
---@field condition? fun(): boolean
---
--- Default style.
---@field default? tabline.opts
---
--- Style named `string`.
---@field [string]? tabline.opts


--- Options for a tabline style.
---@class tabline.opts
---
--- Condition for this tabline.
--- Has no effect for `default`.
---@field condition? boolean | fun(): boolean
---
--- Components for the tabline.
---@field components tabline_component[]


---@alias tabline_component
---| tabline.components.tabs
---| tabline.components.bufs
---| tabline.components.empty
---| tabline.components.custom

----------------------------------------------------------------------

--- Empty tabline component.
---@class tabline.components.empty
---
--- Condition for this component.
---@field condition? fun(): boolean
---
--- Component type.
---@field kind "empty"
---
--- Highlight group for the component.
---@field hl? string


---@class tabline.components.tabs
---
--- Condition for this component.
---@field condition? fun(): boolean
---
--- Component type.
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
--- Format string to show the current
--- buffer's name.
---@field bufname? string
---
--- Highlight group for the bufname.
---@field bufname_hl? string
---
--- Text to use between the bufname &
--- window count.
---@field divider? string
---@field divider_hl? string
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


---@class tabline.components.bufs
---
--- Condition for this component.
---@field condition? fun(): boolean
---
--- Component type.
---@field kind "bufs"
---
--- Maximum number of tabs to show.
---@field max integer
---
--- Text to use for truncating long buffer name.
---@field truncate_symbol? string
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
---@field active bufs.opts
---@field inactive bufs.opts


---@class bufs.opts
---
--- Should filetype icons be shown?
--- NOTE: Requires external dependency.
---@field ft_icon? boolean
---
--- Maximum length of buffer name.
---@field max_name_len? integer
---
--- Format string to show window count
--- of a buffer.
---@field win_count? string
---
--- Highlight group for window count.
---@field win_count_hl? string
---
--- Text to use between the bufname &
--- window count.
---@field divider? string
---@field divider_hl? string
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


---@class tabline.components.custom
---
--- Condition for this component.
---@field condition? fun(): boolean
---
--- Component type.
---@field kind "custom"
---
--- Text for this component.
---@field value string | fun(): string


