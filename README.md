# 🚀 bars.nvim

>[!TIP],
> This repository contains guides for both [creating your own bars & lines plugin]() & [customising various bars & lines without external plugins]().
>
> Other than that, this repository acts as a working `example bars & lines plugin`.

<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-demo.png"/>
<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v3/bars.nvim-demo_2.png"/>

A *highly customisable* & *toggle-able* bars & lines plugin for `Neovim`.

## 📖 Table of contents

- [✨ Features](#-features)
- [📚 Requirements](#-requirements)
- [💡 Guide](#-guide)
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

- Built-in support for Tree-sitter node hierarchy for the current node.
- File path segments from.project root.

### 🧩 Tabline

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

+ [📖 Basics]()
+ [📖 Statusline]()
    - [🔖 Buffer name]()
    - [🔖 Diagnostics]()
    - [🔖 Git branch]()
    - [🔖 Ruler]()
+ [📖 Statuscolumn]()
    - [🔖 Folds]()
    - [🔖 Line numbers]()
    - [🔖 Signs]()
+ [📖 Winbar]()
    - [🔖 LSP breadcrumbs]()
    - [🔖 Node hierarchy]()
    - [🔖 Path segments]()
+ [📖 Tabline]()
    - [🔖 Buffers]()
    - [🔖 Tabs]()

