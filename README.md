<!--markdoc
    {
        "generic": {
            "filename": "doc/bars.nvim.txt",
            "force_write": true,
            "header": {
                "desc": "A toggle-able bars & lines plugin for `Neovim`.",
                "tag": "bars.nvim.txt"
            },
            "toc": {
                "entries": [
                    { "text": "📚 Requirements", "tag": "bars.nvim-requirements" },
                    { "text": "🎇 Commands", "tag": "bars.nvim-commands" },
                    { "text": "💡 Configuration", "tag": "bars.nvim-config" },
                    { "text": "🧰 Commands", "tag": "bars.nvim-commands" },
                    { "text": "📚 Guides", "tag": "bars.nvim-guides" }
                ]
            }
        },
        "markdown": {
            "link_url_modifiers": [
            ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "Features$": [ "bars.nvim-features" ],
                "Requirements$": [ "bars.nvim-requirements" ],
                "Commands$": [ "bars.nvim-commands" ],
                "Autocmds$": [ "bars.nvim-autocmds" ]
            },
            "tables": { "max_col_size": 60 }
        }
    }
-->
<!--markdoc_ignore_start-->

# 🚀 bars.nvim

<!--markdoc_ignore_end-->

>[!TIP]
> This repository contains guides for both [creating your own bars & lines plugin](https://github.com/OXY2DEV/bars.nvim/guides) & [customising various bars & lines without external plugins](https://github.com/OXY2DEV/bars.nvim/wiki/Home).
>
> Other than that, this repository acts as a working `example bars & lines plugin`.

<TOC/>

<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-demo.png">
<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-demo_2.png">

A *highly customisable* & *toggle-able* bars & lines plugin for `Neovim`.

## 📖 Table of contents

- [✨ Features](#-features)
- [📚 Requirements](#-requirements)
- [📐 Installation](#-installation)
- [🧭 Configuration](#-configuration)
- [🧰 Commands](#-commands)
- [📚 Guides](#-guides)

## ✨ Features

- Ability to toggle various bars & lines either *globally* or on *specific window*.
- Component-style configuration to keep things *clean* & *readable*.
- Per window configuration, allowing users to change how things look on each window.
- Conditional rendering to disable certain components based on conditions.
- Enable or disable various bars via `:Bars`.

More specific features are as follows,

### 🧩 Statusline

<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-statusline_help.png">
<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-statusline_qf.png">

- Built-in support for showing current `Git branch` & `diagnostics count`
- Customisable `ruler`.
- Custom `statusline` for,
    - Help files
    - Quickfix

### 🧩 Statuscolumn

- Filtering of `Signs`.
- Built-in support for mixed line numbers(`relative` for normal lines & `absolute` for current line).
- Fancy `virtual lines` & `wrapped lines` indicators.

### 🧩 Winbar

<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-winbar_node.png">
<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-winbar_path.png">

- Built-in support for Tree-sitter node hierarchy for the current node.
- File path segments from.project root.

### 🧩 Tabline

<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-tabline_tabs.png">

- Buffer list(tab list similar to IDEs) support.
- Mouse-support.

## 📐 Installation

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

For `plugins/bars.lua`,

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

`bars.nvim` can be configured in 2 ways,

1. Via the `setup()` function.

```lua
require("bars").setup({
    global = false
});
```

2. Via each module's setup function.

```lua
require("bars.statusline").setup({
    ignore_filwtypes = { "help" }
});
```

Check the [wiki](https://github.com/OXY2DEV/bars.nvim/wiki/Home) to learn about all the configuration options!

## 🧭 Configuration

Configuration guides are available in the [wiki](https://github.com/OXY2DEV/bars.nvim/wiki).

- [Statusline](https://github.com/OXY2DEV/bars.nvim/wiki/Statusline)
- [Statuscolumn](https://github.com/OXY2DEV/bars.nvim/wiki/Statuscolumn)
- [Tabline](https://github.com/OXY2DEV/bars.nvim/wiki/Tabline)
- [Winbar](https://github.com/OXY2DEV/bars.nvim/wiki/Winbar)

## 🧰 Commands

`bars.nvim` provides a single command `:Bars` which has **sub-commands** that can be used to do different things.

The sub-commands are given below,


| Sub-command | Description                                                       |
|-------------|-------------------------------------------------------------------|
| Disable     | Used to disable statusline, statuscolumn etc. **globally**.       |
| Enable      | Used to enable statusline, statuscolumn etc. **globally**.        |
| Start       | Signals the module(s) to attach to new windows.                   |
| Stop        | Stops the module(s) from attaching to nee windows.                |
| Toggle      | Used to toggle statusline, statuscolumn etc. **globally**.        |
| clean       | Cleans up cached values of deleted windows.                       |
| disable     | Used to disable statusline, statuscolumn etc. of given window(s). |
| enable      | Used to enable statusline, statuscolumn etc. of given window(s).  |
| toggle      | Used to toggle statusline, statuscolumn etc. of given window(s).  |
| update      | Updates the module's configuration ID of given window.            |


All the sub-commands support **modifier** to specify which modules should be affected by the command.

>[!TIP]
> If you want to run a sub-command on the current window then you can ignore the modifier.
>
> ```vim
> " Toggles all bars & lines for the current window.
> :Bars toggle
> ```

Modifiers are given below,

| Modifier     | Description                       |
|--------------|-----------------------------------|
| ?            | Prompt which module(s) to affect. |
| all          | Affects all modules.              |
| statuscolumn | Self-explanatory.                 |
| statusline   | Self-explanatory.                 |
| tabline      | Self-explanatory.                 |
| winbar       | Self-explanatory.                 |

You can add any number of windows after the modifier to specify which windows to run the command on.

>[!TIP]
> Cmdline completion are provided for all sub-commands/modifiers/windows!

## 📚 Guides

>[!NOTE]
> These are work in progress!

+ [📖 Basics](https://github.com/OXY2DEV/bars.nvim/blob/main/guides/Basics.md)
+ [📖 Statusline](https://github.com/OXY2DEV/bars.nvim/blob/main/guides/Statusline.md)
<!--     - [🔖 Buffer name]() -->
<!--     - [🔖 Diagnostics]() -->
<!--     - [🔖 Git branch]() -->
<!--     - [🔖 Ruler]() -->
<!-- + [📖 Statuscolumn]() -->
<!--     - [🔖 Folds]() -->
<!--     - [🔖 Line numbers]() -->
<!--     - [🔖 Signs]() -->
<!-- + [📖 Winbar]() -->
<!--     - [🔖 LSP breadcrumbs]() -->
<!--     - [🔖 Node hierarchy]() -->
<!--     - [🔖 Path segments]() -->
<!-- + [📖 Tabline]() -->
<!--     - [🔖 Buffers]() -->
<!--     - [🔖 Tabs]() -->

