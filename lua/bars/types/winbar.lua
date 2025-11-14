---@meta

--- Configuration for the winbar module.
---@class winbar.config
---
---@field force_attach? string[] List of `winbar`s to ignore when attaching.
---
---@field ignore_filetypes string[] Filetypes to ignore when attaching.
---@field ignore_buftypes string[] Buffer types to ignore when attaching.
---
---@field condition? fun(buffer: integer, window: integer): boolean Additional condition for attaching to windows.
---
---@field default winbar.style Default style.
---@field [string] winbar.style Named style.


--[[ Style for the `winbar`. ]]
---@class winbar.style
---
---@field condition? fun(buffer: integer, window: integer): boolean Condition for this style.(unused when style is `default`)
---@field components winbar.component[] Components for this style.


---@alias winbar.component
---| winbar.components.custom Custom text.
---| winbar.components.node Node hierarchy for the node under cursor.
---| winbar.components.path Path segments relative to `current working directory`.


--- Shows the current node's hierarchy.
---@class winbar.components.node
---
---@field kind "node"
---@field condition? fun(buffer: integer, window: integer, winbar: string): boolean Condition for this component.
---
---@field throttle? integer Update delay(in milliseconds).
---@field depth? integer Maximum node depth.
---
---@field separator? string Separator between nodes.
---@field separator_hl? string Highlight group for the separator.
---
---@field default node.language.opts Default configuration for languages.
---@field [string] node.language.opts Configuration for language named `string`.


--[[ Language options for the `node` component. ]]
---@class node.language.opts
---
---@field default winbar.section Default configuration for nodes.
---@field _ellipsis winbar.section Configuration for the ellipsis(shown when a node's depth is higher than `depth`).
---@field [string] winbar.section Configuration for nodes named `string.


--- Configuration for file path segment.
---@class winbar.components.path
---
---@field kind "path"
---@field condition? fun(buffer: integer, window: integer, winbar: string): boolean Condition for this component.
---
---@field throttle? integer Update delay(in milliseconds).
---
---@field separator? string Separator between path components.
---@field separator_hl? string Highlight group for the separator.
---
---@field default winbar.section Default configuration for path segment.
---@field [string] winbar.section Configuration for segments matching `string`.


--- Custom section for the winbar.
---@class winbar.components.custom
---
---@field kind "custom"
---@field condition? fun(buffer: integer, window: integer, winbar: string): boolean Condition for this component.
---
---@field value string | fun(buffer: integer, window: integer, winbar: string): string Text to show for this section.


--- Options for a structured section of the winbar.
---@class winbar.section
---
---@field corner_left? string
---@field padding_left? string
---
---@field icon? string
---@field text? string
---
---@field padding_right? string
---@field corner_right? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.
---
---@field padding_right_hl? string
---@field corner_right_hl? string

