# 📐 Architecture

This document describes how the various modules are structured & how they interact with each other under the hood.

<!-- GRAPH -->

Each module is composed of 2 files,

1. A `<module>.lua` which holds all the commands & set/reset functions.
2. A `components/<module>.lua` which holds all the components.

For example, the `statusline` module uses the following files,

- [../lua/bars/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/statusline.lua)
- [../lua/bars/components/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/components/statusline.lua)

# `<module>.lua`

This file holds,

+ A configuration table(`module.config`).
+ Module state(`module.state`).
+ A renderer(`module.render`). This will be used as the content of the specific bar/line.
+ Helper functions such as,
    + A start function(`module.start()`). Usually called during `VimEnter` or via commands.
    + A window attach function(`module.attach(win: integer)`) for attaching to windows.
    + A window detach function(`module.detach(win: integer)`) for detaching from windows.
    + A style updater(`module.update_style(win: integer)`) to change which style is used. Usually called when setting `filetype` & `buftype`.
    + A setup function(`module.setup(config: table)`).

    And optionally some commands(e.g. `module.Enable()`, the function name should start with a **capital letter**).

