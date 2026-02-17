---@meta

--[[
# 🧬 Generics

Base class for various bars & lines. All bars/lines extends from it.

## 📚 Usage

```lua
local bar = require("bars.generics").new();

bar:attach(0);
bar:enable(0);
```

]]
---@class bars.generic
---
---@field config bars.generic.config Bars configuration.
---@field default string Default value for a `bar@` used by the plugin.
---@field state bars.generic.state Bars state.
---@field use_blank_output? boolean Uses blank output for windows without styles.
---@field var_name string Variable name for storing current style name.
---
---@field set_default_state fun(self: bars.generic): nil Sets the config & state for a bar.
---@field original fun(self: bars.generic): any Gets original bar value. **MUST BE SET AFTER CREATION.**
---@field current fun(self: bars.generic, win: integer): string Gets current bar value. **MUST BE SET AFTER CREATION.**
---@field should_attach fun(self: bars.generic, win: integer): boolean Should a bar attach to a `window`?
---@field should_detach fun(self: bars.generic, win: integer): boolean Should a bar detach from a `window`?
---@field set fun(self: bars.generic, win: integer): nil Sets bar/line for a `window`. **MUST BE SET AFTER CREATION.**
---@field remove fun(self: bars.generic, win: integer): nil Removes bar/line for a `window`. **MUST BE SET AFTER CREATION.**
---@field attach fun(self: bars.generic, win: integer): nil Attaches to a `window`.
---@field detach fun(self: bars.generic, win: integer): nil Detaches from a `window`.
---@field handle_new_window fun(self: bars.generic, win: integer): nil Handle events that causes a window to be attached/detached. Mainly `WinNew`..
---@field update_style fun(self: bars.generic, win: integer): nil Updates the bar/line style for a `window`.
---
---@field start fun(self: bars.generic): nil Starts a bar.
---@field enable fun(self: bars.generic, win: integer): nil Enables bar/line for a `window`.
---@field disable fun(self: bars.generic, win: integer): nil Disables bar/line for a `window`.
---@field render fun(self: bars.generic): string Renders a bar.
---@field toggle fun(self: bars.generic, win: integer): nil Toggles bar/line for a `window`.
---@field update fun(self: bars.generic, win: integer): nil Update bar/line style for a `window`.
---@field Enable fun(self: bars.generic): nil Enable bar/line `globally`.
---@field Disable fun(self: bars.generic): nil Disable bar/line `globally`.
---@field Toggle fun(self: bars.generic): nil Toggle bar/line `globally`.
---
---@field styled_component fun(self: bars.generic, win: integer, buf: integer, components: table<string, function>, entry: table, last: string): string Gets output of a styled component of a bar/line.
---@field get_styled_output fun(self: bars.generic, win: integer, components: table<string, function>): string Gets the styled bar/line for a window from a source.
---
---@field __index table


---@class bars.generic.state
---
---@field enable boolean
---@field window_state table<integer, boolean>


---@class bars.generic.config
---
---@field buftypes? string[]
---@field filetypes? string[]
---
---@field ignore_buftypes? string[]
---@field ignore_filetypes? string[]
---
---@field condition? fun(win: integer, buf: integer): boolean
---@field force_attach? string[]
---
---@field default bars.generic.config.style


---@class bars.generic.config.style
---
---@field condition? fun(win: integer, buf: integer): boolean
---@field components bars.generic.config.component[]



---@alias bars.generic.config.component
---| bars.statusline.component
---| bars.statuscolumn.component
---| bars.winbar.component
---| bars.tabline.component

