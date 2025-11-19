# 📖 Statusline

>[!NOTE]
> It is assumed that you have read [the basics]().

To use a lua function for the `statusline`, we can make use of `v:lua` & `:!` like this,

```lua
-- Assuming your statusline function is `_G.my_statusline()`.
vim.o.statusline = "%!v:lua.my_statusline()";
```

Here `my_statusline()` is a **global** lua function which is why ww have to add `v:lua` before it, The `:!` part evaluates the output of `my_statusline()` which allows use of `statusline items` in it's output.

```lua
---@return string Statusline
_G.my_statusline = function ()
    return "Some text";
end
```

In `bars.nvim`, this is used for the statusline.

```lua eval: vim.o.statusline
vim.o.statusline = "%!v:lua.require('bars.statusline').render()"
```

## 🧭 Structure

🛑 WIP

## 🧩 Rendering

The `render()` function returns a string that will be used as the text. It can also contain `statusline item`s in it, which makes things easier for us.

An example function could look something like this,

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
      local style = vim.w[window].bars_statusline_style or vim.w[window]._bars_statusline_style or"default";
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

## 🧩 Components

Components are stored in [lua/bars/components/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/components/statusline.lua).

These components are exposed via the `get()` function.

```lua from: ../lua/bars/components/statusline.lua field: slC.get
--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param component_config table
---@param statusline string
---@return string
slC.get = function (name, buffer, window, component_config, statusline)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(slC[name]) ~= "function" then
		--- Not a valid component.
		return "";
	else
		if component_config.condition ~= nil then
			if component_config.condition == false then
				--- Component is disabled.
				return "";
			else
				local sucess, val = pcall(component_config.condition, buffer, window, statusline);

				if sucess == false then
					return "";
				elseif val == false then
					return "";
				end
			end
		end

		local static_config = vim.deepcopy(component_config);

		for key, value in pairs(static_config) do
			if type(value) ~= "function" then
				goto continue;
			end

			local s_success, s_val = pcall(value, buffer, window, statusline);

			if s_success == false then
				static_config[key] = nil;
			else
				static_config[key] = s_val;
			end

			::continue::
		end

		--- Return component value.
		return slC[name](buffer, window, static_config, statusline) or "";
	end

	---|fE
end
```

