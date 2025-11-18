# 📖 Statusline

>[!NOTE]
> It is assumed that you have read [the basics]().

To use a lua function for the `statusline`, we can make use of `v:lua` like this,

```lua eval: vim.o.statusline
vim.o.statusline = "%!v:lua.require('bars.statusline').render()"
```

You can replace it with whatever your function name is,

```lua
-- Assuming your statusline function is `_G.my_statusline()`.
vim.o.statusline = "%!v:lua.my_statusline()";
```

Now the `render()` function returns a string that will be used as the text. It can also contain `statusline item`s in it, which makes things easier for us.

An example function could look something like this,

```lua
---@return string Statusline
_G.my_statusline = function ()
    return "Some text";
end
```

The one `bars.nvim` uses looks something like this,

```lua from: ../lua/bars/statusline.lua field: statusline.render
--- Renders the statusline for a window.
---@return string
statusline.render = function ()
	---|fS

	local components = require("bars.components.statusline");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	statusline.update_style(window);

	local style = vim.w[window].bars_statusline_style or "default";
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

Let's break it down,

- `components` contains a bunch of helpers that can show different stuff in the statusline.

>[!NOTE]
> the difference between `components` & `statusline items` is that components take configuration tables & can render more *complex* things without needing to understand the underlying items(or how they work).

- `vim.g.statusline_winid` is the window number of the window where the statusline is being *drawn*.
  This is useful for per-window configuration support and showing things that are tied to the window.

- `statusline.update_style()` is an internal function that updates the used style.
  This is not relevant for this guide and will therefore be skipped.

- These lines are used to get the current style of the statusline.

  ```lua
  	local style = vim.w[window].bars_statusline_style or "default";
  	local config = statusline.config[style];
  
  	if type(config) ~= "table" then
  		return "";
  	end
  ```

- `_o`(short for `_output`, `_` prefix for internal variable) is the text that will be shown in the statusline.

- The loop part iterates over the components and adds the output to `_o`.
  ```lua
  	for _, component in ipairs(config.components or {}) do
  		_o = _o .. components.get(component.kind, buffer, window, component, _o);
  	end
  ```

