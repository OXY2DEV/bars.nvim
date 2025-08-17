--- Custom winbar module.
local winbar = {};

--- Custom winbar.
---@type string
local WBR = "%!v:lua.require('bars.winbar').render()";

---@class winbar.config
winbar.config = {
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

---@type winbar.state
winbar.state = {
	enable = true,
	attached_windows = {}
};

winbar.check_condition = function (buffer, window)
	if not winbar.config.condition then
		return true;
	end

	local can_call, cond = pcall(winbar.config.condition, buffer, window);
	return can_call and cond;
end

--- Renders the winbar for a window.
---@return string
winbar.render = function ()
	---|fS

	local components = require("bars.components.winbar");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(winbar.config.ignore_filetypes, vim.bo[buffer].ft) then
		winbar.detach(window);
		return "";
	elseif vim.list_contains(winbar.config.ignore_buftypes, vim.bo[buffer].bt) then
		winbar.detach(window);
		return "";
	elseif winbar.check_condition(buffer, window) == false then
		winbar.detach(window);
		return "";
	end

	winbar.update_id(window);

	local wbID = vim.w[window].__wbbID or "default";
	local config = winbar.config[wbID];

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

	local win = vim.api.nvim_get_current_win();
	winbar.attach(win);

	---|fE
end

--[[
Attaches the custom `statusline` to **window**.

Set `ignore_enabled` to **true** to disable module state checker.
]]
---@param window integer
---@param ignore_enabled? boolean
winbar.attach = function (window, ignore_enabled)
	---|fS

	if ignore_enabled ~= true and winbar.state.enable == false then
		-- Do not attach if **this module is disabled**.
		return;
	elseif winbar.state.attached_windows[window] == true then
		-- Do not attach if **already attached to a window**.
		return;
	elseif vim.wo[window].winbar ~= vim.g.__winbar then
		-- Do not attach to windows with `custom winbar`.
		return;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(winbar.config.ignore_filetypes, vim.bo[buffer].ft) then
		-- Do not attach if `filetype` is *ignored*.
		winbar.detach(window);
	elseif vim.list_contains(winbar.config.ignore_buftypes, vim.bo[buffer].bt) then
		-- Do not attach if `buftype` is *ignored*.
		winbar.detach(window);
	elseif winbar.check_condition(buffer, window) == false then
		-- Do not attach if **conditionally ignored**.
		winbar.detach(window);
	else
		winbar.set(window);
		winbar.state.attached_windows[window] = true;
	end

	---|fE
end

--[[
Detaches the custom `statusline` from **window**.

NOTE: This will *reset* the statusline for that window.
]]
---@param window integer
winbar.detach = function (window)
	---|fS

	if winbar.state.attached_windows[window] == false then
		-- Do not detach for unattached windows.
		return;
	end

	winbar.remove(window);
	winbar.state.attached_windows[window] = false;

	---|fE
end

--[[ Updates the configuration ID for `window`. ]]
---@param window integer
winbar.update_id = function (window)
	---|fS

	if type(window) ~= "number" or vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(winbar.config.ignore_filetypes, vim.bo[buffer].ft) then
		winbar.detach(window);
		return true;
	elseif vim.list_contains(winbar.config.ignore_buftypes, vim.bo[buffer].bt) then
		winbar.detach(window);
		return true;
	end

	---@type string[]
	local keys = vim.tbl_keys(winbar.config);
	---@type string[]
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	local ID = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(winbar.config[key]) ~= "table" then
			goto continue;
		end

		---@type winbar.opts
		local tmp = winbar.config[key];

		if tmp.condition == true then
			ID = key;
		elseif type(tmp.condition) == "function" then
			---@diagnostic disable-next-line
			local can_eval, val = pcall(tmp.condition, buffer, window);

			if can_eval and val then
				ID = key;
			end
		end

		---@diagnostic enable:undefined-field

		::continue::
	end

	vim.w[window].__slID = ID;

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

--[[ Toggles `winbar` for **all** windows. ]]
winbar.Toggle = function ()
	---|fS

	if winbar.state.enable == true then
		winbar.Disable();
	else
		winbar.Enable();
	end

	---|fE
end

--[[ Enables `winbar` for **all** windows. ]]
winbar.Enable = function ()
	---|fS

	for win, state in pairs(winbar.state.attached_windows) do
		if state == true then
			winbar.set(win);
		end
	end

	winbar.state.enable = true;

	---|fE
end

--[[ Disables `winbar` for **all** windows. ]]
winbar.Disable = function ()
	---|fS

	for win, state in pairs(winbar.state.attached_windows) do
		if state == true then
			winbar.remove(win);
		end
	end

	winbar.state.enable = false;

	---|fE
end

--[[ Toggles `winbar` for `window`. ]]
---@param window integer
winbar.toggle = function (window)
	---|fS

	if winbar.state.attached_windows[window] == true then
		winbar.detach(window);
	else
		winbar.attach(window);
	end

	---|fE
end

--[[ Enables `winbar` for `window`. ]]
---@param window integer
winbar.enable = function (window)
	winbar.attach(window);
end

--[[ Disables `winbar` for `window`. ]]
---@param window integer
winbar.disable = function (window)
	winbar.detach(window);
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
