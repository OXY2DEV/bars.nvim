--[[
Custom winbar from `bars.nvim`.

## Usage

```lua
require("bars.winbar").Enable();
```
]]
local winbar = {};
local generic = require("bars.generic");

---@type string Expression that creates the winbar when evaluated.
local WBR = "%!v:lua.require('bars.winbar').render()";

---@class winbar.config
winbar.config = {
	force_attach = {},

	ignore_filetypes = { "blink-cmp-menu" },
	ignore_buftypes = { "nofile", "help" },

	default = {
		components = {
			---|fS

			{
				kind = "path",
				condition = function (buffer)
					local check_parsers, parser = pcall(vim.treesitter.get_parser, buffer);

					if check_parsers == false then
						return true;
					elseif parser == nil then
						return true;
					else
						return false;
					end
				end,

				separator = " → ",
				separator_hl = "Comment",

				default = {
					dir_icon = "󰉋 ",
					icon = "󰈔 ",

					hl = "Special"
				}
			},
			{
				kind = "node",
				depth = 3,

				separator = " → ",
				separator_hl = "Comment",

				default = {
					__lookup = {
						padding_left = " ",
						padding_right = " ",

						icon = "󱎓",

						hl = "BarsVisualBlock"
					},

				},

				["^luadoc$"] = {
					---|fS

					documentation = {
						icon = "󱪙 ",
						hl = "Title"
					},

					class_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					type_annotation = {
						icon = "󰐫 ",
						hl = "@keyword.luadoc"
					},

					param_annotation = {
						icon = "󰡱 ",
						hl = "@keyword.luadoc"
					},

					alias_annotation = {
						icon = "󰔌 ",
						hl = "@keyword.luadoc"
					},

					continuation = {
						icon = "󰌑 ",
						hl = "@keyword.luadoc"
					},

					return_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					field_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					qualifier_annotation = {
						icon = "󰙴 ",
						hl = "@keyword.luadoc"
					},

					generic_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					vararg_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					diagnostic_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					deprecated_annotation = {
						icon = " ",
						hl = "@error"
					},

					meta_annotation = {
						icon = "󰐱 ",
						hl = "@keyword.luadoc"
					},

					module_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					source_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					version_annotation = {
						icon = "󰯏 ",
						hl = "@keyword.luadoc"
					},

					package_annotation = {
						icon = "󰏖 ",
						hl = "@keyword.luadoc"
					},

					operator_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					nodiscard_annotation = {
						icon = "󰌾 ",
						hl = "@keyword.luadoc"
					},

					cast_annotation = {
						icon = "󱦈 ",
						hl = "@keyword.luadoc"
					},

					async_annotation = {
						icon = "󰦖 ",
						hl = "@keyword.luadoc"
					},

					overload_annotation = {
						icon = "󱐋 ",
						hl = "@keyword.luadoc"
					},

					enum_annotation = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					language_injection = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					see_reference = {
						icon = "󰈈 ",
						hl = "@keyword.luadoc"
					},

					link_reference = {
						icon = " ",
						hl = "@keyword.luadoc"
					},

					since_annotation = {
						icon = "󰔚 ",
						hl = "@keyword.luadoc"
					},

					as_annotation = {
						icon = "󰤖 ",
						hl = "@keyword.luadoc"
					},

					[".+%_type"] = {
						icon = " ",
						hl = "@type.luadoc"
					},

					identifier = {
						icon = "󰮄 ",
						hl = "Special"
					},

					["^comment$"] = {
						icon = "󱀡 ",
						hl = "@comment.lua"
					},

					comment_content = {
						icon = "󱀢 ",
						hl = "@comment.lua"
					},

					parameter = {
						icon = " ",
						hl = "@variable.parameter.luadoc"
					},

					---|fE
				},

				["^lua$"] = {
					---|fS

					chunk = {
						icon = "󰢱 ",
						hl = "@function.lua"
					},

					variable_declaration = {
						icon = "󰏖 ",
						hl = "@variable"
					},

					function_declaration = {
						icon = "󰡱 ",
						hl = "@function"
					},


					binary_expression = {
						icon = "󱃲 ",
						hl = "Comment"
					},

					["false"] = {
						icon = "󰌶 ",
						hl = "@boolean"
					},

					function_call = {
						icon = "󰡱 ",
						hl = "@function.call.lua"
					},

					function_definition = {
						icon = "󰡱 ",
						hl = "@function.lua"
					},

					["nil"] = {
						icon = "󰆧 ",
						hl = "@constant.builtin.lua"
					},

					number = {
						icon = " ",
						hl = "@number.lua"
					},

					parenthesized_expression = {
						icon = "󰅲 ",
						hl = "Comment"
					},

					["string"] = {
						icon = "󰛓 ",
						hl = "@string.lua"
					},

					string_content = {
						icon = "󰴓 ",
						hl = "@string.lua"
					},

					table_constructor = {
						icon = " ",
						hl = "@constructor.lua"
					},

					["true"] = {
						icon = "󱠂 ",
						hl = "@boolean"
					},

					unary_expression = {
						icon = "󰋙 ",
						hl = "Comment"
					},

					vararg_expression = {
						icon = "󰋘 ",
						hl = "Comment"
					},

					variable = {
						icon = "󰋘 ",
						hl = "@variable.lua"
					},


					assignment_statement = {
						icon = "󰆦 ",
						hl = "@operator.lua"
					},

					break_statement = {
						icon = "󰆋 ",
						hl = "@keyword.lua"
					},

					declaration = {
						icon = "󰆨 ",
						hl = "@keyword.lua"
					},

					do_statement = {
						icon = "󰣖 ",
						hl = "@keyword.lua"
					},

					empty_statement = {
						icon = "󰆧 ",
						hl = "@keyword.lua"
					},

					for_statement = {
						icon = "󰓦 ",
						hl = "@keyword.lua"
					},

					goto_statement = {
						icon = "󱤬 ",
						hl = "@keyword.lua"
					},

					if_statement = {
						icon = "󰘬 ",
						hl = "@keyword.lua"
					},

					elseif_statement = {
						icon = "󰘬 ",
						hl = "@keyword.lua"
					},

					else_statement = {
						icon = "󰘬 ",
						hl = "@keyword.lua"
					},

					label_statement = {
						icon = "󰓽 ",
						hl = "@label.lua"
					},

					repeat_statement = {
						icon = " ",
						hl = "@keyword.lua"
					},

					while_statement = {
						icon = "󰅐 ",
						hl = "@keyword.lua"
					},

					bracket_index_expression = {
						icon = "󰅪 ",
						hl = "@punctuation.bracket.lua"
					},

					dot_index_expression = {
						icon = "󱦜 ",
						hl = "@punctuation.delimiter.lua"
					},

					identifier = {
						icon = "󰮄 ",
						hl = "Special"
					},


					arguments = {
						icon = "󰅲 ",
						hl = "@punctuation.bracket.lua"
					},

					expression = {
						icon = "󱓝 ",
						hl = "@punctuation.bracket.lua"
					},


					expression_list = {
						icon = "󱇂 ",
						hl = "@punctuation.bracket.lua"
					},

					variable_list = {
						icon = "󱇂 ",
						hl = "@punctuation.bracket.lua"
					},


					attribute = {
						icon = "󱈝 ",
						hl = "@attribute.lua"
					},

					block = {
						icon = "󰴓 ",
						hl = "Special"
					},


					return_statement = {
						icon = " ",
						hl = "@keyword.lua"
					},

					hash_bang_line = {
						icon = " ",
						hl = "Comment"
					},


					["^comment$"] = {
						icon = "󱀡 ",
						hl = "@comment.lua"
					},

					comment_content = {
						icon = "󱀢 ",
						hl = "@comment.lua"
					},


					field = {
						icon = "󱏒 ",
						hl = "@property.lua"
					},


					for_numeric_clause = {
						icon = " ",
						hl = "@keyword.lua"
					},

					for_generic_clause = {
						icon = " ",
						hl = "@keyword.lua"
					},


					method_index_expression = {
						icon = " ",
						hl = "@method.lua"
					},


					parameters = {
						icon = " ",
						hl = "@variable.parameter.luadoc"
					},

					---|fE
				},

				["^lua_patterns$"] = {
					chunk = {
						icon = "󰛪 ",
						hl = "@comment"
					},


					start_assertion = {
						icon = "󰾺 ",
						hl = "@keyword"
					},

					end_assertion = {
						icon = "󰾸 ",
						hl = "@keyword"
					},


					zero_or_more = {
						icon = " ",
						hl = "@keyword.operator"
					},

					one_or_more = {
						icon = " ",
						hl = "@keyword.operator"
					},

					lazy = {
						icon = " ",
						hl = "@keyword.operator"
					},

					optional = {
						icon = " ",
						hl = "@keyword.operator"
					},


					literal_character = {
						icon = "󱄽 ",
						hl = "@character"
					},

					character_reference = {
						icon = " ",
						hl = "@constant.builtin"
					},

					any_character = {
						icon = " ",
						hl = "@variable.member"
					},


					character_class = {
						icon = "󰏗 ",
						hl = "@variable.builtin"
					},

					character_range = {
						icon = "󰊱 ",
						hl = "@comment"
					},

					character_set = {
						icon = "󱉓 ",
						hl = "@label"
					},

					character_set_content = {
						icon = "󰆦 ",
						hl = "@comment"
					},

					caprure_group = {
						icon = " ",
						hl = "@label"
					},


					escaped_character = {
						icon = "󰩈 ",
						hl = "@string.escape"
					},

					escape_sequence = {
						icon = "󰩈 ",
						hl = "@character.special"
					},
				}
			}

			---|fE
		}
	}
};

---@class bars.mod.state
winbar.state = {
	enable = true,
	attached_windows = {}
};

--- Renders the winbar for a window.
---@return string
winbar.render = function ()
	---|fS

	local components = require("bars.components.winbar");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	winbar.update_style(window);

	local style = vim.w[window].bars_winbar_style or "default";
	local config = winbar.config[style];

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

--[[ Attaches the `winbar` module. ]]
winbar.start = function ()
	---|fS

	if winbar.state.enable == false then
		return;
	end

	vim.api.nvim_set_option_value("winbar", WBR, { scope = "global" })

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		winbar.attach(win);
	end

	---|fE
end

--[[
Attaches the custom `winbar` to **window**.
]]
---@param window integer
winbar.attach = function (window)
	---|fS

	local current = vim.wo[window].winbar;
	local should_attach = generic.should_attach(
		winbar.state,
		winbar.config,
		current,
		WBR,
		window
	);

	if should_attach then
		winbar.set(window);
		winbar.state.attached_windows[window] = true;

		generic.set_win_state(winbar.state, window, true);
	elseif generic.get_win_state(winbar.state, window) and current ~= WBR then
		winbar.detach(window);
	end

	---|fE
end

--[[
Detaches the custom `winbar` from **window**.

NOTE: This will *reset* the statusline for that window.
]]
---@param window integer
winbar.detach = function (window)
	---|fS

	if generic.get_win_state(winbar.state, window) then
		winbar.remove(window);
		generic.set_win_state(winbar.state, window, false);
	elseif vim.wo[window].winbar == WBR then
		local current = vim.wo[window].winbar;
		local should_attach = generic.should_attach(
			winbar.state,
			winbar.config,
			current,
			WBR,
			window
		);

		if should_attach then
			winbar.set(window);
			generic.set_win_state(winbar.state, window, true);
		else
			winbar.remove(window);
		end
	end

	---|fE
end

--[[ Updates the configuration style for `window`. ]]
---@param window integer
winbar.update_style = function (window)
	---|fS

	if type(window) ~= "number" or vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local current = vim.wo[window].statuscolumn;
	local should_detach = generic.should_detach(
		winbar.state,
		winbar.config,
		current,
		WBR,
		window
	);

	if should_detach then
		winbar.detach(window);
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	---@type string[]
	local keys = vim.tbl_keys(winbar.config);
	---@type string[]
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	local style = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(winbar.config[key]) ~= "table" then
			goto continue;
		end

		---@type winbar.opts
		local tmp = winbar.config[key];

		if tmp.condition == true then
			style = key;
		elseif type(tmp.condition) == "function" then
			---@diagnostic disable-next-line
			local can_eval, val = pcall(tmp.condition, buffer, window);

			if can_eval and val then
				style = key;
			end
		end

		---@diagnostic enable:undefined-field

		::continue::
	end

	vim.w[window].bars_winbar_style = style;

	---|fE
end

--[[
Sets the custom statuscolumn for `window`.
]]
---@param window integer
winbar.set = function (window)
	---|fS

	vim.api.nvim_set_option_value(
		"winbar",
		WBR,
		{
			scope = "local",
			win = window
		}
	);

	---|fE
end

--[[
Removes the custom statuscolumn for `window`.
]]
---@param window integer
winbar.remove = function (window)
	---|fS

	if vim.wo[window].winbar ~= WBR then
		return;
	end

	vim.api.nvim_win_call(window, function ()
		vim.cmd("set winbar=" .. (vim.g.__winbar or ""));
	end);

	---|fE
end

------------------------------------------------------------------------------

winbar.Start = function ()
	---|fS

	winbar.state.enable = true;
	winbar.start();

	winbar.Enable();

	---|fE
end

winbar.Stop = function ()
	---|fS

	winbar.state.enable = false;

	for win, _ in pairs(winbar.state.attached_windows) do
		winbar.detach(win);
	end

	---|fE
end

--[[ Toggles `winbar` for **all** windows. ]]
winbar.Toggle = function ()
	---|fS

	for win, _ in pairs(winbar.state.attached_windows) do
		winbar.toggle(win);
	end

	---|fE
end

--[[ Enables `winbar` for **all** windows. ]]
winbar.Enable = function ()
	---|fS

	winbar.state.enable = true;
	winbar.start();

	for win, state in pairs(winbar.state.attached_windows) do
		if state == false then
			winbar.enable(win);
		end
	end

	---|fE
end

--[[ Disables `winbar` for **all** windows. ]]
winbar.Disable = function ()
	---|fS

	winbar.state.enable = false;

	for win, state in pairs(winbar.state.attached_windows) do
		if state == true then
			winbar.disable(win);
		end
	end

	---|fE
end

--[[ Toggles `winbar` for `window`. ]]
---@param window integer
winbar.toggle = function (window)
	---|fS

	local state = generic.get_win_state(generic.state, window);

	if state == true then
		winbar.disable(window);
	elseif state == false then
		winbar.enable(window);
	end

	---|fE
end

--[[ Enables `winbar` for `window`. ]]
---@param window integer
winbar.enable = function (window)
	generic.set_win_state(winbar.state, window, true);
	winbar.set(window);
end

--[[ Disables `winbar` for `window`. ]]
---@param window integer
winbar.disable = function (window)
	generic.set_win_state(winbar.state, window, false);
	winbar.remove(window);
end

------------------------------------------------------------------------------

--[[ Sets up the `winbar` module. ]]
---@param config winbar.config | boolean | nil
winbar.setup = function (config)
	---|fS

	if type(config) == "table" then
		winbar.config = vim.tbl_extend("force", winbar.config, config);
	elseif type(config) == "boolean" then
		winbar.state.enable = config;
	end

	---|fE
end

return winbar;
