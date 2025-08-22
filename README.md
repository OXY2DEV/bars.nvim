# 🚀 bars.nvim

<!-- Images -->

<p align="center">
    <a href="">📚 Wiki</a> | <a href="#-commands">🧰 Commands</a>
</p>

A bare-bones custom `statusline`, `statuscolumn`, `winbar`, `tabline` implementation for `Neovim`.

This repository is meant to teach you how to set up your `statusline`, `statuscolumn`, `winbar`, `tabline` without needing to rely on *external plugins*.

## 💡 Core features

- Easy to configure bars & lines.
- Dynamic configuration capable of being changed on the fly.
- Ability to have different bars & lines per window.
- Ability to toggle various bars & lines through command(`:Bars`) either globally or per window.
- Respects custom bars & lines values(e.g. from plugins, from `quickfix` etc.).
- Usable on vertical screens(e.g. in `Termux`).

## 📂 Project structure

The project is structured as followed,

- `plugin/`, to avoid relying on `setup()` and for *caching* certain values.
- `lua/`
    + `bars.lua`, contains internal functions, setup function etc.
    * `definition/`, type definitions.
        * `statuscolumn.lua`, statuscolumn type definitions.
        * `statusline.lua`, statusline type definitions.
        * `tabline.lua`, custom tabline type definitions.
        * `winbar.lua`, winbar type definitions.
    + `bars/`
        * `components/`, reusable sections for various bars & lines.
            * `statuscolumn.lua`, statuscolumn components.
            * `statusline.lua`, statusline components.
            * `tabline.lua`, tabline components.
            * `winbar.lua`, winbar components.
        * `global.lua`, click handlers & related functions used in bars & lines.
        * `highlights.lua`, highlight group definitions.
        * `statuscolumn.lua`, custom statuscolumn.
        * `statusline.lua`, custom statusline.
        * `tabline.lua`, custom tabline.
        * `winbar.lua`, custom winbar.
        * `utils.lua`, utility functions.

## 📚 Requirements

- Neovim: `>=0.10.3`
- Nerd font: `>= 3.0.0`
- Git(for showing `branch` in statusline)
- Tree-sitter parser(for showing current `TSNode` in winbar)

## 📦 Installation

You can install it locally to test it out via your favourite favourite package manager!

### 🧩 Vim-plug

Add this to your plugin list.

```vim
Plug "OXY2DEV/bars.nvim"
```

### 💤 lazy.nvim

>[!NOTE]
> Lazy loading is NOT needed for this!

For `plugins.lua` users,

```lua
{
    "OXY2DEV/bars.nvim",
},
```

For `plugins/bars.lua` users,

```lua
return {
    "OXY2DEV/bars.nvim",
};
```

## 🦠 mini.deps

```lua
local MiniDeps = require("mini.deps");

MiniDeps.add({
    source = "OXY2DEV/bars.nvim"
});
```

### 🌒 Rocks.nvim

>[!WARNING]
> `luarocks package` may sometimes be a bit behind `main`.

```vim
:Rocks install bars.nvim
```

### 📥 GitHub release

Tagged releases can be found in the [release page](https://github.com/OXY2DEV/bars.nvim/releases).

>[!NOTE]
> `Github releases` may sometimes be slightly behind `main`.

## 🧭 Configuration

You can call `require("bars").setup()` with your configuration table. It can also be used to disable certain `modules`,

```lua
require("bars").setup({
    -- Disables the `winbar`.
    winbar = false
});
```

You can also configure modules *individually*,

```lua
require("bars.statusline").setup({
    ignore_filetypes = { "query" },
});
```

## 🧰 Commands

This plugin provides a single command `:Bars` with various sub-commands.

>[!TIP]
> Completions are also provided for the `sub-commands`.

Usage,

```vim
:Bars                                  "Runs,    :Bars Toggle
:Bars <sub_command> <act_on>           "Example, :Bars toggle winbar
:Bars <sub_command> <act_on> <windows> "Example, :Bars toggle all 1000
```

The available `sub-commands` are,

| Name    | Description                                                                           |
|---------|---------------------------------------------------------------------------------------|
| Toggle  | Toggles different bars & lines globally(toggles all of them when not specified).      |
| Enable  | Enables different bars & lines globally(enables all of them when not specified).      |
| Disable | Disables different bars & lines globally(disables all of them when not specified).    |
| toggle  | Toggles different bars & lines for windows(toggles all of them when not specified).   |
| enable  | Enables different bars & lines for windows(enables all of them when not specified).   |
| disable | Disables different bars & lines for windows(disables all of them when not specified). |

All the sub-commands allows specifying what(e.g. `statusline`, `statuscolumn` etc.) the command should act on. These can be any of the following,

| Act on       | Description                                          |
|--------------|------------------------------------------------------|
| ?            | Prompt the user what to act on(supports completion). |
| all          | Act on **all** modules.                              |
| statuscolumn | Only act on the `statuscolumn` module.               |
| statusline   | Only act on the `statusline` module.                 |
| tabline      | Only act on the `tabline` module.                    |
| winbar       | Only act on the `winbar` module.                     |

Lastly, you can add any number of window IDs afterwards to specify which window(s) to run the command on.

>[!NOTE]
> Global commands such as `Toggle`, `Enable`, `Disable` don't allow specifying window IDs!

