# 📐 Architecture

This document describes how the various modules are structured & how they interact with each other under the hood.

<!-- GRAPH -->

Each module is composed of 2 files,

1. A `<module>.lua` which holds all the commands & set/reset functions.
2. A `components/<module>.lua` which holds all the components.

For example, the `statusline` module uses the following files,

- [../lua/bars/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/statusline.lua)
- [../lua/bars/components/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/components/statusline.lua)

## `<module>.lua`

This file holds,

+ A configuration table(`module.config`).
  Typically it would have the following structure,

```lua $TYP: ../lua/bars/types/statusline.lua, from: $TYP, class: statusline.config
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
```

+ Module state(`module.state`).
```lua $SRC: ../lua/bars/statusline.lua, from: $SRC, field: statusline.state
statusline.state = {
    enable = true,
    attached_windows = {}
};
```

+ A renderer(`module.render`). This will be used as the content of the specific bar/line.
```lua $SRC: ../lua/bars/statusline.lua, from: $SRC, field: statusline.render
--- Renders the statusline for a window.
---@return string
statusline.render = function ()
    ---|fS

    local components = require("bars.components.statusline");

    local window = vim.g.statusline_winid;
    local buffer = vim.api.nvim_win_get_buf(window);

    statusline.update_style(window);

    local style = vim.w[window].bars_statusline_style or vim.w[window]._bars_statusline_style or "default";
    local config = statusline.config[style];

    if type(config) ~= "table" then
        return "";
    end

    local _o = "";

    for _, component in ipairs(config.components or {}) do
        _o = _o .. components.get(component.kind, buffer, window, component, _o);
    end

    return _o;

    ---|fE
end
```

+ Helper functions such as,
    + A start function(`module.start()`). Usually called during `VimEnter` or via commands.
    + A window attach function(`module.attach(win: integer)`) for attaching to windows.
    + A window detach function(`module.detach(win: integer)`) for detaching from windows.
    + A style updater(`module.update_style(win: integer)`) to change which style is used. Usually called when setting `filetype` & `buftype`.
    + A setup function(`module.setup(config: table)`).

    And optionally some commands(e.g. `module.Enable()`, the function name should start with a **capital letter**).

## `components/<module>.lua`

This will hold various components

