# 📖 Bars & lines basics

This page explains the basics for modifying the `statusline`, `statuscolumn`, `tabline` and/or `winbar`.

It explains,
- [💡 The syntax]()
- [💡 Item groups]()
- [💡 Spacing]()
- [💡 Highlighting]()
- [💡 Dynamic values]()
- [💡 Click handlers]()
- [💡 Using lua instead of format expressions]()
- [💡 Getting info withing the lua function]()

## 💡 The syntax

The various bars & lines in Neovim can be configured by using a `format string` as their option.

> For example, you can set `vim.o.statusline` to some format string to change what is shown in the statusline.

### 🧩 Format strings

If you have never heard of `format strings` before or need a refresher they are basically some string(text) starting with `%`(percentage) followed by some specific characters.

In `C`, this is used by functions such as `printf()` & `scanf()`,

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

Vim's/Neovim's bars & lines works similarly. You define **what** to show **where** in the option(s.g. `vim.o.statusline`) and the editor fills those spots with the correct information.

>[!NOTE]
> In the help files these are referred to as `item`s.

The most commonly used format strings are,


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

Item groups are a way of structuring a number of `format string`s together. Typically this is done to add stuff like [click handlers](#-click-handlers) and/or apply spacing/alignment. But this may also he used to increase readability.

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

To solve that Vim/Neovim has a special `%=` format string. We can use it like this,

```
%(%{mode()}%)%=%(%f%)%=%(%l,%c%)
```

## 💡 Click handlers


