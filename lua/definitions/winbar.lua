---@meta

--- State variables for the winbar
--- module.
---@class winbar.state
---
---@field enable boolean
---
--- State for attached windows.
---@field attached_windows { [integer]: boolean }

----------------------------------------------------------------------

--- Configuration for the winbar module.
---@class winbar.config
---
--- Filetypes to ignore.
---@field ignore_filetypes string[]
---
--- Buftypes to ignore.
---@field ignore_buftypes string[]
---
--- Additional condition for attaching to
--- windows.
---@field condition? fun(buffer: integer, window: integer): boolean | nil
---
--- Default style.
---@field default winbar_component[]
---
--- Style named `string`
---@field [string] winbar_component[]


---@alias winbar_component
---| winbar.component.node
---| winbar.component.path


---@class winbar.component.node
---
---@field kind "node"
---
--- Condition for this component
---@field condition? fun(buffer: integer, window: integer, winbar: string): boolean | nil
---
--- Update delay(in milliseconds).
---@field throttle? integer
---
--- Maximum node depth.
---@field depth? integer
---
--- Separator between nodes.
---@field separator? string
---
--- Highlight group for the separator.
---@field separator_hl? string
---
--- Default configuration for languages.
---@field default node.opts
---
--- Configuration for language named `string`.
---@field [string] node.opts


---@class node.opts
---
--- Default configuration for nodes.
---@field default winbar.section
---
--- Configuration for the ellipsis.
---@field __lookup table
---
--- Configuration for nodes named `string.
---@field [string] winbar.section


--- Configuration for file path.
---@class winbar.component.path
---
--- What kind of component is this?
---@field kind "path"
---
--- Condition for this component
---@field condition? fun(buffer: integer, window: integer, winbar: string): boolean | nil
---
--- Update delay(in milliseconds).
---@field throttle? integer
---
--- Separator between path components.
---@field separator? string
---
---Highlight group for separator.
---@field separator_hl? string
---
--- Default configuration for path segment.
---@field default winbar.section
---
--- Configuration for segments matching `string`.
---@field [string] winbar.section


--- Custom section for the winbar.
---@class winbar.component.custom
---
--- What kind of component is this?
---@field kind "custom"
---
--- Condition for this component
---@field condition? fun(buffer: integer, window: integer, winbar: string): boolean | nil
---
--- Text to show for this section.
---@field value string | fun(buffer: integer, window: integer, winbar: string): string


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
---@field hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

