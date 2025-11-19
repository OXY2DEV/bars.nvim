---@meta

---@class tabline.state
---
---@field enable boolean Attempt to set custom tabline?
---@field attached boolean Custom tabline is being used?

--- Configuration table for the tabline.
---@class tabline.config
---
---@field condition? fun(): boolean Additional condition for attaching to windows.
---
---@field default? tabline.style Default style.
---@field [string]? tabline.style Named style.


--[[ Style for the `tabline`. ]]
---@class tabline.style
---
---@field condition? fun(): boolean Condition for this style.(unused when style is `default`)
---@field components tabline.component[] Components for this style.


---@alias tabline.component
---| tabline.components.bufs Buffer list.
---| tabline.components.custom Custom text.
---| tabline.components.empty Empty space.
---| tabline.components.tabs Tab list.

----------------------------------------------------------------------

--- Empty tabline component.
---@class tabline.components.empty
---
---@field kind "empty"
---@field condition? fun(): boolean Condition for this component.
---
---@field hl? string Highlight group for the component.


--- List of tabs.
---@class tabline.components.tabs
---
---@field kind "tabs"
---@field condition? fun(): boolean Condition for this component.
---
---@field max integer Maximum number of tabs to show.
---@field from integer List entry to start showing from.
---
---@field separator? string Text used to separate tabs.
---@field separator_hl? string Highlight group for the separator
---
---@field overflow? string Text used to indicate where the tab list ends(the list is looped).
---@field overflow_hl? string Highlight group for `overflow`.
---
---@field nav_left? string Text for the left navigation button.
---@field nav_left_hl? string Highlight group for the left navigation button.
---
---@field nav_left_locked? string Text for the left navigation button when list scroll is locked.
---@field nav_left_locked_hl? string Highlight group for `nav_left_locked`.
---
---@field nav_right? string Text for the right navigation button.
---@field nav_right_hl? string Highlight group for the left navigation button.
---
---@field nav_right_locked? string Text for the right navigation button when list scroll is locked.
---@field nav_right_locked_hl? string Highlight group for `nav_right_locked`.
---
---@field active tabs.opts Options for current tab.
---@field inactive tabs.opts Options for normal tabs.


--- Options for tabs in tab list.
---@class tabs.opts
---
---@field win_count? string Format string to show window count of a tab.
---@field win_count_hl? string Highlight group for window count.
---
---@field bufname? string Format string to show the current buffer's name.
---@field bufname_hl? string Highlight group for the bufname.
---
---@field divider? string Text to use between the `tab number`, `bufname` & `window count`.
---@field divider_hl? string Highlight group for divider.
---
---@field corner_left? string
---@field padding_left? string
---
---@field icon? string
---
---@field padding_right? string
---@field corner_right? string
---
---@field hl? string Default highlight group. Used by other `*_hl` options as fallback.
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string


--- List of buffers.
---@class tabline.components.bufs
---
---@field kind "bufs"
---@field condition? fun(): boolean Condition for this component.
---
---@field max integer Maximum number of buffers to show.
---@field truncate_symbol? string Text to use for truncating long buffer name.
---
---@field from integer List entry to start showing from.
---
---@field separator? string Text used to separate buffers.
---@field separator_hl? string Highlight group for the separator
---
---@field overflow? string Text used to indicate where the buffer list ends(the list is looped).
---@field overflow_hl? string Highlight group for `overflow`.
---
---@field nav_left? string Text for the left navigation button.
---@field nav_left_hl? string Highlight group for the left navigation button.
---
---@field nav_left_locked? string Text for the left navigation button when list scroll is locked.
---@field nav_left_locked_hl? string Highlight group for `nav_left_locked`.
---
---@field nav_right? string Text for the right navigation button.
---@field nav_right_hl? string Highlight group for the left navigation button.
---
---@field nav_right_locked? string Text for the right navigation button when list scroll is locked.
---@field nav_right_locked_hl? string Highlight group for `nav_right_locked`.
---
---@field active bufs.opts
---@field inactive bufs.opts


--- Options for each buffer in buffer list.
---@class bufs.opts
---
---@field ft_icon? boolean Should filetype icons be shown? NOTE: Requires `icons.nvim`.
---@field max_name_len? integer Maximum length of buffer name.
---
---@field win_count? string Format string to show window count of a buffer.
---@field win_count_hl? string Highlight group for window count.
---
---@field divider? string Text to use between the bufname & window count.
---@field divider_hl? string Highlight group for divider.
---
---@field corner_left? string
---@field padding_left? string
---
---@field icon? string
---
---@field padding_right? string
---@field corner_right? string
---
---@field hl? string Default highlight group. Used by other `*_hl` options as fallback.
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string


--- Custom text.
---@class tabline.components.custom
---
---@field kind "custom"
---@field condition? fun(): boolean Condition for this component.
---
---@field value string | fun(): string Text for this component.


