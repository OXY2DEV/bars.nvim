---@meta

---@class winbar.state
---
---@field enable boolean
---@field attached_windows { [integer]: boolean }


---@class winbar.config
---
---@field ignore_filetypes string[]
---@field ignore_buftypes string[]
---
---@field condition? fun(buffer: integer): boolean | nil
---
---@field defaukt table
---@field [string] table


---@class winbar.node
---
---@field kind "node"
---@field throttle? integer
---@field lookup? integer
---@field max_width? integer
---
---@field separator? string
---@field separator_hl? string
---
---@field default node.opts
---@field [string] node.opts


---@class node.opts
---
---@field default table
---@field __lookup table
---@field [string] table

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

