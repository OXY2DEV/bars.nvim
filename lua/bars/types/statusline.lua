---@meta

--- Statusline configuration table.
---@class statusline.config
---
---@field force_attach? string[] List of `statusline` values to ignore when attaching.
---
---@field ignore_filetypes string[] Filetypes to ignore when attaching.
---@field ignore_buftypes string[] Buffer types to ignore when attaching.
---
---@field condition? fun(buffer: integer, window: integer): boolean Additional condition for attaching to windows.
---
---@field default statusline.style Default style.
---@field [string] statusline.style Named style.

-----------------------------------------------------------------------------

--- Statusline style
---@class statusline.style
---
---@field condition? fun(buffer: integer, window: integer): boolean Condition for this style.(unused when style is `default`)
---@field components statusline.component[] Components for this style.


---@alias statusline.component
---| statusline.components.branch Git branch.
---| statusline.components.bufname Buffer name.
---| statusline.components.custom
---| statusline.components.diagnostics Diagnostics count.
---| statusline.components.empty Empty space.
---| statusline.components.macro Macro play/record indicator.
---| statusline.components.mode Current mode.
---| statusline.components.progress Progressbar.
---| statusline.components.ruler Ruler.
---| statusline.components.section Generic section.

-----------------------------------------------------------------------------

--- Shows current git branch.
---@class statusline.components.branch
---
---@field kind "branch"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field throttle? integer Number of milliseconds used between updating the branch name.
---
---@field default branch.opts Default configuration.
---@field [string] branch.opts Configuration for `string`.


--- Options for git branch.
---@class branch.opts
---
---@field corner_left? string
---@field padding_left? string
---
---@field text? string Alternate branch name.
---@field icon? string
---
---@field padding_right? string
---@field corner_right? string
---
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Shows buffer name.
---@class statusline.components.bufname
---
---@field kind "bufname"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field max_len? integer Maximum name length.
---@field truncate_symbol? string Symbol used to show name truncation.
---
---@field default bufname.opts Default configuration.
---@field [string] bufname.opts Configuration for buffer names matching `string`.


--- Options for buffer name.
---@class bufname.opts
---
---@field corner_left? string
---@field padding_left? string
---
---@field text? string Alternate name.
---@field icon? string
---
---@field nomodifiable_icon? string Icon for 'nomodifiable' buffers.
---
---@field padding_right? string
---@field corner_right? string
---
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string[] Highlight groups for the icons. Used by `icons.nvim`.
---@field nomodifiable_icon_hl? string Highlight group for `nomodifiable_icon`
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Shows diagnostics count.
---@class statusline.components.diagnostics
---
---@field kind "diagnostics"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field auto_hide? boolean When `true`, this component will be hidden if no diagnostics are available.
---@field compact? boolean When `true`, a compact sign is used if diagnostics are empty. Cannot be used with `auto_hide`.
---
---@field default_mode?
---|1 Error
---|2 Warning
---|3 Info
---|4 Hint
---|5 All of the above
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
---@field empty_icon? string Icon to show when no diagnostics are available and `compact = true` & `auto_hide = false`.
---@field empty_text? string Text to show when no diagnostics are available and `compact = true` & `auto_hide = false`.
---
---@field empty_hl? string Highlight group for `empty_icon` & `empty_text`.
---
---@field separator? string Text used as a separator between each diagnostics type.
---@field separator_hl? string
---
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.
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

-----------------------------------------------------------------------------

--- Empty space.
---@class statusline.components.empty
---
---@field kind "empty"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field hl? string

-----------------------------------------------------------------------------

--- Shows current mode.
---@class statusline.components.mode
---
---@field kind "mode"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field compact? boolean | fun(buffer: integer, window: integer): boolean Show a compact version(only show `padding` & `icon`)?
---
---@field default mode.opts Default configuration.
---@field [string] mode.opts Configuration for mode string matching `string`.


--- Options for mode indicator.
---@class mode.opts
---
---@field corner_left? string
---@field padding_left? string
---
---@field text? string Mode name.
---@field icon? string
---
---@field padding_right? string
---@field corner_right? string
---
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Structured section. Used as scaffolding for custom components.
---@class statusline.components.section
---
---@field kind? "section"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field click? string Click handler.
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
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.
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

--- Custom ruler.
---@class statusline.components.ruler
---
---@field kind "ruler"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field mode
---| "normal" Show cursor position.
---| "visual" Show selection size.
---| fun(buffer: integer, window: integer): ( "normal" | "visual" )
---
---@field default ruler.opts Default configuration.
---@field visual ruler.opts Configuration for visual modes.


--- Ruler options.
---@class ruler.opts
---
---@field corner_left? string
---@field padding_left? string
---
---@field icon? string
---
---@field separator? string Text between row & col.
---
---@field padding_right? string
---@field corner_right? string
---
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---@field separator_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string
---
---@field hl? string Primary highlight group. Used by other `*_hl` groups as fallback.

-----------------------------------------------------------------------------

--- Custom statusline component.
---@class statusline.components.custom
---
---@field kind "custom"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field value fun(buffer: integer, window: integer): string

-----------------------------------------------------------------------------

--- Macro record/play indicator.
---@class statusline.components.macro
---
---@field kind "macro"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field record_icon string Icon to show Macros being recorded.
---@field record_hl? string Highlight group for record icon.
---
---@field exec_icon string Icon to show Macros being executed.
---@field exec_hl? string Highlight group for exec icon.

-----------------------------------------------------------------------------

--- Progressbar.
---@class statusline.components.progress
---
---@field kind "progress"
---@field condition? fun(buffer: integer, window: integer, statusline: string): boolean Condition for this component.
---
---@field check? string The variable that holds the progress state, default is "progress_state".
---
---@field finish string Text used as the indicator for progress finish.
---@field finish_hl string Highlight group for the progress finish indicator.
---
---@field progress string[] Text used as the indicator for progress.
---@field progress_hl string[] Highlight group for the progress indicator.
---
---@field start string Text used as the indicator for progress start.
---@field start_hl string Highlight group for the progress start indicator.
---
---@field update_delay? integer Delay in milliseconds between state updates.

