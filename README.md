# 🚀 bars.nvim

<div align="center">
    <img alt="Neovim" src="https://img.shields.io/badge/Neovim-000?style=for-the-badge&logo=neovim&logoColor=A6E3A1&color=1E1E2E">
    <img alt="Repo size" src="https://img.shields.io/github/languages/code-size/OXY2DEV/bars.nvim?style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0NDggNTEyIj48IS0tIUZvbnQgQXdlc29tZSBGcmVlIDYuNy4yIGJ5IEBmb250YXdlc29tZSAtIGh0dHBzOi8vZm9udGF3ZXNvbWUuY29tIExpY2Vuc2UgLSBodHRwczovL2ZvbnRhd2Vzb21lLmNvbS9saWNlbnNlL2ZyZWUgQ29weXJpZ2h0IDIwMjUgRm9udGljb25zLCBJbmMuLS0%2BPHBhdGggc3Ryb2tlPSIjQ0JBNkY3IiBmaWxsPSIjQ0JBNkY3IiBkPSJNOTYgMEM0MyAwIDAgNDMgMCA5NkwwIDQxNmMwIDUzIDQzIDk2IDk2IDk2bDI4OCAwIDMyIDBjMTcuNyAwIDMyLTE0LjMgMzItMzJzLTE0LjMtMzItMzItMzJsMC02NGMxNy43IDAgMzItMTQuMyAzMi0zMmwwLTMyMGMwLTE3LjctMTQuMy0zMi0zMi0zMkwzODQgMCA5NiAwem0wIDM4NGwyNTYgMCAwIDY0TDk2IDQ0OGMtMTcuNyAwLTMyLTE0LjMtMzItMzJzMTQuMy0zMiAzMi0zMnptMzItMjQwYzAtOC44IDcuMi0xNiAxNi0xNmwxOTIgMGM4LjggMCAxNiA3LjIgMTYgMTZzLTcuMiAxNi0xNiAxNmwtMTkyIDBjLTguOCAwLTE2LTcuMi0xNi0xNnptMTYgNDhsMTkyIDBjOC44IDAgMTYgNy4yIDE2IDE2cy03LjIgMTYtMTYgMTZsLTE5MiAwYy04LjggMC0xNi03LjItMTYtMTZzNy4yLTE2IDE2LTE2eiIvPjwvc3ZnPg%3D%3D&logoColor=CBA6F7&labelColor=1e1e2e&color=B4BEFE">
    <img alt="GitHub Release" src="https://img.shields.io/github/v/release/OXY2DEV/bars.nvim?include_prereleases&sort=semver&display_name=release&style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA1MTIgNTEyIj48IS0tIUZvbnQgQXdlc29tZSBGcmVlIDYuNy4yIGJ5IEBmb250YXdlc29tZSAtIGh0dHBzOi8vZm9udGF3ZXNvbWUuY29tIExpY2Vuc2UgLSBodHRwczovL2ZvbnRhd2Vzb21lLmNvbS9saWNlbnNlL2ZyZWUgQ29weXJpZ2h0IDIwMjUgRm9udGljb25zLCBJbmMuLS0%2BPHBhdGggZmlsbD0iI0Y1RTBEQyIgc3Ryb2tlPSIjRjVFMERDIiBkPSJNMzQ1IDM5LjFMNDcyLjggMTY4LjRjNTIuNCA1MyA1Mi40IDEzOC4yIDAgMTkxLjJMMzYwLjggNDcyLjljLTkuMyA5LjQtMjQuNSA5LjUtMzMuOSAuMnMtOS41LTI0LjUtLjItMzMuOUw0MzguNiAzMjUuOWMzMy45LTM0LjMgMzMuOS04OS40IDAtMTIzLjdMMzEwLjkgNzIuOWMtOS4zLTkuNC05LjItMjQuNiAuMi0zMy45czI0LjYtOS4yIDMzLjkgLjJ6TTAgMjI5LjVMMCA4MEMwIDUzLjUgMjEuNSAzMiA0OCAzMmwxNDkuNSAwYzE3IDAgMzMuMyA2LjcgNDUuMyAxOC43bDE2OCAxNjhjMjUgMjUgMjUgNjUuNSAwIDkwLjVMMjc3LjMgNDQyLjdjLTI1IDI1LTY1LjUgMjUtOTAuNSAwbC0xNjgtMTY4QzYuNyAyNjIuNyAwIDI0Ni41IDAgMjI5LjV6TTE0NCAxNDRhMzIgMzIgMCAxIDAgLTY0IDAgMzIgMzIgMCAxIDAgNjQgMHoiLz48L3N2Zz4%3D&labelColor=1E1E2E&color=45475A">
</div>

A starting point/guide for creating custom statusline, statuscolumn, tabline & winbar for Neovim.

## 📖 Table of contents

- [✨ Features](#-features)
- [📚 Requirements](#-requirements)
- [📐 Installation](#-installation)
- [🧭 Configuration](#-configuration)

## ✨ Features

- Actually fast,
    - Termux: average: `5ms`, lowest: `2ms`.
    - MacOS: average: `0.5ms`, lowest: `0.2ms`.

- Fully customisable.
- Per-window configuration.
- Ability to toggle various bars/lines via commands.

## 📚 Requirements

- 0.10.4 or higher recommended.

>[!NOTE]
> The version requirement varies for different parts of `bars.nvim`.

- Nerd font >= 3.0.0

## 📐 Installation

### 🧩 Vim-plug

Add this to your plugin list.

```vim
Plug "OXY2DEV/bars.nvim"
```

### 💤 lazy.nvim

>[!NOTE]
> Lazy loading is NOT needed for this plugin!

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

<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v2/repo/bars-mobile.png">
<img src="https://github.com/OXY2DEV/bars.nvim/blob/images/v2/repo/bars-desktop.png">

A starting point for creating custom bars & lines in `Neovim`.

