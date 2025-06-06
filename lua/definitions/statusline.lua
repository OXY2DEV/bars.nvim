--- Type definitions for the statusline.
---@meta

--- Statusline state variable(s).
---@class statusline.state
---
--- Should we attach to new windows?
---@field enable boolean
---
--- State of attached windows.
---   true -> Attached & rendering.
---   false -> Attached only.
---@field attached_windows table<integer, boolean>

-----------------------------------------------------------------------------

--- Statusline configuration table.
---@class statusline.config
---
--- Filetypes to ignore.
---@field ignore_filetypes? string[]
--- Buftypes to ignore.
---@field ignore_buftypes? string[]
---
--- Additional condition for attaching to new windows.
---@field condition? fun(buffer: integer, window: integer): boolean | nil
---
--- Default style.
---@field default statusline.style
---
--- Custom style.
---@field [string] statusline.style

-----------------------------------------------------------------------------

--- Statusline style
---@class statusline.style
---
---@field condition? boolean | fun(buffer: integer, window: integer): boolean Condition for this style. Unused for `default`.
---
---@field components statusline_component[] Statusline components.

---@alias statusline_component
---| statusline.components.section
---| statusline.components.ruler
---| statusline.components.mode
---| statusline.components.diagnostics
---| statusline.components.branch
---| statusline.components.bufname
---| statusline.components.empty
---| statusline.components.custom
---| statusline.components.macro
---| statusline.components.progress

-----------------------------------------------------------------------------

--- Shows current git branch.
---@class statusline.components.branch
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "branch"
---
--- Delay(in milliseconds) between branch
--- name updates.
---@field throttle? integer
---
--- Default configuration for git branch.
---@field default branch.opts
---
--- Configuration for branches whose name
--- matches `string`.
---@field [string] branch.opts


--- Git branch component options.
--- Drawn like so,
---
---```txt
--- abc----de
--- │││    │└ corner_right
--- │││    └ padding_right
--- ││└ icon
--- │└ padding_left
--- └ corner_left
---```
---@class branch.opts
---
---@field corner_left? string
---@field padding_left? string
---
--- Alternate branch name.
---@field text? string
---@field icon? string
---
---@field padding_right? string
---@field corner_right? string
---
--- Primary highlight group.
---@field hl? string
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
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "bufname"
---
--- Maximum name length.
---@field max_len? integer
---
--- Symbol used to show truncation.
---@field truncate_symbol? string
---
---@field default bufname.opts
---@field [string] bufname.opts


--- Buffer name component options.
--- Drawn like so,
---
---```txt
--- abc----de
--- │││    │└ corner_right
--- │││    └ padding_right
--- ││└ icon / nomodifiable_icon
--- │└ padding_left
--- └ corner_left
---```
---@class bufname.opts
---
---@field corner_left? string
---@field padding_left? string
---
--- Alternate branch name.
---@field text? string
---@field icon? string
---
--- Icon for 'nomodifiable' buffers.
---@field nomodifiable_icon? string
---
---@field padding_right? string
---@field corner_right? string
---
--- Primary highlight group.
---@field hl? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
--- Highlight groups for the icons.
--- Used by `icon.nvim`
---@field icon_hl? string[]
---
--- Highlight group for `nomodifiable_icon`
---@field nomodifiable_icon_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Shows diagnostics count.
---@class statusline.components.diagnostics
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "diagnostics"
---
--- Should this component be automatically hidden?
---
--- > This component gets hidden if a buffer has
--- > no client attached to it.
---@field auto_hide? boolean
---
--- Determines what type of diagnostics are
--- shown.
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
--- Icon to show when no diagnostics are available.
---@field empty_icon? string
---
--- Text to show when no diagnostics are available.
---@field empty_text? string
---
--- Highlight group to use when no diagnostics are
--- available.
---@field empty_hl? string
---
--- Text used as separator between each diagnostics
--- type.
---@field separator? string
---
--- Highlight group for the separator.
---@field separator_hl? string
---
--- Left corner of the component. 
---@field corner_left? string
---@field corner_left_hl? string
---
--- Left padding of the component. 
---@field padding_left? string
---@field padding_left_hl? string
---
--- Right padding of the component. 
---@field padding_right? string
---@field padding_right_hl? string
---
--- Right corner of the component. 
---@field corner_right? string
---@field corner_right_hl? string
---
--- Primary highlight group for the component
---@field hl? string

-----------------------------------------------------------------------------

--- Empty space.
---@class statusline.components.empty
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "empty"
---
--- Highlight group for this component.
---@field hl? string

-----------------------------------------------------------------------------

--- Shows current mode.
---@class statusline.components.mode
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "mode"
---
--- Should we show a compact version?
---@field compact? boolean | fun(buffer: integer, window: integer): boolean
---
---@field default mode.opts
---@field [string] mode.opts


--- Mode name component options.
--- Drawn like so,
---
---```txt
--- abc----de
--- │││    │└ corner_right
--- │││    └ padding_right
--- ││└ icon
--- │└ padding_left
--- └ corner_left
---```
---@class mode.opts
---
---@field corner_left? string
---@field padding_left? string
---
--- Mode name.
---@field text? string
---@field icon? string
---
---@field padding_right? string
---@field corner_right? string
---
--- Primary highlight group.
---@field hl? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---
---@field icon_hl? string
---
---@field padding_right_hl? string
---@field corner_right_hl? string

-----------------------------------------------------------------------------

--- Custom section for the statusline.
--- Drawn like so,
---
--- abc-de
--- │││││└ corner_right
--- ││││└ padding_right
--- │││└ text
--- ││└ icon
--- │└ padding_left
--- └ corner_left
---@class statusline.components.section
---
--- Condition for this component.
---@field condition? fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind? "section"
---
--- Reference to a click handler.
---@field click? string
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
--- Primary highlight group
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

-----------------------------------------------------------------------------

--- Custom ruler.
---@class statusline.components.ruler
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "ruler"
---
--- Should visual modes be shown
---@field mode
---| "normal" Show cursor position.
---| "visual" Show selection size.
---| fun(buffer: integer, window: integer): ( "normal" | "visual" )
---
--- Default configuration.
---@field default ruler.opts
---
--- Configuration for visual modes.
---@field visual ruler.opts


--- Ruler component options.
--- Drawn like so,
---
---```txt
--- abcXX-YYde
--- │││  │  │└ corner_right
--- │││  │  └ padding_right
--- │││  └ separator
--- ││└ icon
--- │└ padding_left
--- └ corner_left
---@class ruler.opts
---
---@field corner_left? string
---@field padding_left? string
---
---@field icon? string
---
--- Separator between texts.
---@field separator? string
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
--- Primary highlight group.
---@field hl? string

-----------------------------------------------------------------------------

--- Custom statusline component.
---@class statusline.components.custom
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "custom"
---
--- Text to show for this component.
---@field value fun(buffer: integer, window: integer): string

-----------------------------------------------------------------------------

---@class statusline.components.macro
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "macro"
---
--- Icon to show Macros being recorded.
---@field record_icon string
---
--- Highlight group for record icon.
---@field record_hl? string
---
--- Icon to show Macros being executed.
---@field exec_icon string
---
--- Highlight group for exec icon.
---@field exec_hl? string

-----------------------------------------------------------------------------

---@class statusline.components.progress
---
--- Optional condition for this component.
---@field condition? boolean | fun(buffer: integer, window: integer): boolean
---
--- What kind of component is this?
---@field kind "progress"
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

