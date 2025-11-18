# 📖 Bars & lines basics

This page explains the basics for modifying the `statusline`, `statuscolumn`, `tabline` and/or `winbar`.

It explains,
- [💡 Syntax](#-syntax)
- [💡 Item groups](#-item-groups)
- [💡 Spacing](#-spacing)
- [💡 Highlighting](#-hugglighting)
- [💡 Dynamic values](#-dynamic-values)
- [💡 Click handlers](#-click-handlers)
- [💡 Using Lua](#-using-lua)
- [💡 Getting info withing the lua function]()

## 💡 Syntax

The various bars & lines in Vim/Neovim can be configured by using a string with `statusline item`s inside them.

### 🧩 Items

If you have never heard of `statusline items` before or need a refresher they are basically strings/text starting with `%`(percentage) followed by some *special* characters.

In `C`, something similar is used by functions such as `printf()` & `scanf()`,

```c
int C = 10;
printf("C: %d", C);
```

Similarly in `Lua`, we can see it being used by `string.format()`.

```lua
local C = 10;
print(string.format("C: %d", C));
```

------

As you can see, `%d` gets replaced with the value of `C` in the output. 

> `%d` stands for **Decimal value**.

Similarly, in various bars & lines you specify where to show different things and Vim/Neovim fills those spots with the correct information.

The most commonly used statusline items are,


| Item | Description         |
|------|---------------------|
| `%f` | Relative file path. |
| `%F` | Absolute file path. |
| `%t` | File name.          |
| `%l` | Line number.        |
| `%c` | Column number.      |
| `%=` | Spacing/Separator.  |


You can find a longer list of these in `:h 'statusline'`.

### 🧩 Specifying width & alignment

The format string style syntax allows setting a specific *minimum* & *maximum* width of the item. This is useful if something can be really long(e.g. file name) and you don't want it to push everything else outside of the screen.

This is similar to format options for format strings in `C`/`Lua` such as `%06x`(for showing 6 digit hexadecimal number).

You will generally see something like this,

```vim
" Syntax: %0{min_width}.{max_width}{item} **or** %-{min_width}.{max_width}{item}
%-5.20F
```

The modifier(s) can be broken down like this,

- The `%` creates a new item/item group using the next character.
  E.g. `%f` creates a new item with the special character `f` which shows the relative file path.
- A `0` or `-` can be used to change the alignment of the text.
  `0` right aligns the text.
  `-` left aligns the text.
- A minimum width(here `5`).
- A `.` followed by the maximum width(here `20`).

Together they will look something like this,

```vim
" Right aligned file path with a specific mimimum width.
%20f

" Right aligned(specified) file path with a specific mimimum width.
%020f

" Left aligned file path with a specific mimimum width.
%-20f


" Right aligned file path with a specific maximum width.
%.20f

" Right aligned(specified) file path with a specific maximum width.
%0.20f

" Left aligned file path with a specific maximum width.
%-.20f


" Left aligned file path with a specific mimimum & macimum width.
%-5.20f

" Right aligned file path with a specific maximum width.
%5.20f

" Right aligned(specified) file path with a specific maximum width.
%05.20f
```

------

## 💡 Item groups

Item groups are a way of structuring a number of `statusline item`s together. Typically this is done to add stuff like [click handlers](#-click-handlers) and/or apply spacing/alignment. But this may also he used to increase readability.

You can define an item group by using `%(` & `%)`. So, an item group showing the **line number** & **column number** will look something like,

>[!TIP]
> Similar to items you can use modifiers on item groups for controlling the width & alignment of the text.

```
%(%l,%c%)
```

Let's create 3 item groups that will show the,
- Current mode.
- Relative file path.
- Current line & column.

It will look something like this,

```
%(%{mode()}%)%(%f%)%(%l,%c%)
```

Let's break it down,

The first group contains `%{mode()}` which gets the value of `mode()`(this gets the current mode) and shows it in the statusline.

>[!NOTE]
> Use of `%{}` will be discussed in detail in the [Dynamic values](#-dynamic-values) section.

The second group contains `%f` which shows the current file's relative path.

The final group contains `%l,%c` which shows the current line number & the current column number separated by a `,`.

## 💡 Spacing

So, far everything we put in the `statusline` is getting jumbled together. So, we should add some spacing between them.

Now, we can manually add spacing like so,

```
%(%{mode()}%)  %(%f%)  %(%l,%c%)
```

But not only does it make the string unnecessarily long it also doesn't work on all screen sizes.

To solve that Vim/Neovim has a special `%=` item. We can use it like this,

```
%(%{mode()}%)%=%(%f%)%=%(%l,%c%)
```

## 💡 Highlighting

So, far everything has been looking the same color. So it's time to *color* them.

For highlighting texts we use `%#{group_name}#` where `group_name` is the highlight group's name.

>[!NOTE]
> By default, the statusline will use the `StatusLine`!

However, you can't directly specify which part gets what highlight group(like you can with `virtual text`). So, highlights can *bleed* outside of where they should be if you aren't careful.

So, let's try making the **file name** a different color.

```
%(%{mode()}%)%=%(%#Question#%f%%*%)%=%(%l,%c%)
```
>[!TIP]
> You can reset the highlight group to whatever the statusline is using as default via `%*`.

## 💡 Dynamic values

You can show some dynamic value using the `%{...}` and `%{%...}` where the `...` returns some value.

You can also specify what type of variable you want to use by using one of these prefixes,


| Prefix | Description                    |
|--------|--------------------------------|
|  `b:`  | Local to the current buffer.   |
|  `w:`  | Local to the current window.   |
|  `t:`  | Local to the current tab page. |
|  `g:`  | Global.                        |
|  `v:`  | Global, predefined by Vim.     |


## 💡 Click handlers

Vim/Neovim provides the `%@{handler}@` and `%X`/`%T` items for defining clickable regions.

The `{handler}` can be a `Vim` function or a **global** lua function.

> As this guide solely focuses on **Lua**, I won't be discussing about Vimscript functions.

Let's say, you have a click handler like this that goes to

```lua
_G.somefunc = function ()
	vim.print("hi");
end
```

We can use it on some text `Click me` like this,

```
%@v:lua.somefunc@Click me%X
```

## 💡 Using Lua

From the help files,

```help
							*stl-%!*
	When the option starts with "%!" then it is used as an expression,
	evaluated and the result is used as the option value.  Example: >vim
		set statusline=%!MyStatusLine()
<	The *g:statusline_winid* variable will be set to the |window-ID| of the
	window that the status line belongs to.
	The result can contain %{} items that will be evaluated too.
	Note that the "%!" expression is evaluated in the context of the
	current window and buffer, while %{} items are evaluated in the
	context of the window that the statusline belongs to.

	When there is error while evaluating the option then it will be made
	empty to avoid further errors.  Otherwise screen updating would loop.
	When the result contains unprintable characters the result is
	unpredictable.
```

For using Lua functions, we can make use of `v:lua`. For example,

```lua eval: vim.o.statusline
vim.o.statusline = "%!v:lua.require('bars.statusline').render()"
```

Here, `require('bars.statusline').render()` returns a string containing `items`(or a literal string, if you want).

## 💡 Getting info withing the lua function

If you wish to change how different bars & lines look based on the `buffer` and/or `window` then you will need to get these values.

Functions such as these,

```lua
vim.api.nvim_get_current_buf();
vim.api.nvim_get_current_win();
```

Will not work for windows that aren't the current one. Luckily there are some variables to get these informations.

Some of the more important ones are,

- `vim.g.statusline_winid`, for getting the window where the bars/lines is being rendered.

>[!TIP]
> Use `vim.api.nvim_win_get_buf()` to get the buffer being shown in `vim.g.statusline_winid`.

For `statuscolumn` we have access to,

- `vim.v.lnum`, for the line number of the line being rendered.
- `vim.v.relnum`, for the relative line number of the line being rendered.
- `vim.v.virtnum`, for detecting **wrapped** & **virtual** lines.
    + It is `0` for regular lines.
    + It is `<0` for virtual lines.
    + It is `>0` for wrapped lines.

