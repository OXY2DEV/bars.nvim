--- Custom winbar module.
local winbar = {};
local components = require("bars.components.winbar");

--- Custom winbar.
---@type string
local WBR = "%!v:lua.require('bars.winbar').render()";

---@class winbar.config
winbar.config = {
	ignore_filetypes = { "blink-cmp-menu" },
	ignore_buftypes = { "nofile", "help" },

	condition = function ()
		---|fS

		if _G.is_within_termux then
			--- Do NOT use this inside Termux.
			--- Screen space is too precious.
			return not _G.is_within_termux();
		end

		return true;

		---|fE
	end,

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

--- Updates the configuration ID for {window}.
---@param window integer
---@return string | nil
winbar.update_id = function (window)
	---|fS

	if type(window) ~= "number" then
		return;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local buffer = vim.api.nvim_win_get_buf(window);

	local keys = vim.tbl_keys(winbar.config);
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	local ID = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(winbar.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = winbar.config[key];

		if tmp.condition == true then
			ID = key;
		elseif pcall(tmp.condition --[[ @as function ]], buffer, window) and tmp.condition(buffer, window) == true  then
			ID = key;
		end

		::continue::
	end

	vim.w[window].__wbID = ID;
	winbar.state.attached_windows[window] = true;

	---|fE
end

--- Renders the winbar for a window.
---@return string
winbar.render = function ()
	---|fS

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	local wbID = vim.w[window].__wbID;

	if not wbID then
		return "";
	end

	local config = winbar.config[wbID];

	if type(config) ~= "table" then
		return "";
	end

	local _o = "%#Normal#";

	for _, component in ipairs(config.components or {}) do
		_o = _o .. components.get(component.kind, buffer, window, component, _o);
	end

	return _o;

	---|fE
end

--- Can we detach from {win}?
---@param win integer
---@return boolean
winbar.can_detach = function (win)
	---|fS

	if vim.api.nvim_win_is_valid(win) == false then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if vim.list_contains(winbar.config.ignore_filetypes, ft) then
		return true;
	elseif vim.list_contains(winbar.config.ignore_buftypes, bt) then
		return true;
	else
		if not winbar.config.condition then
			return false;
		end

		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(winbar.config.condition, buffer, win);

		if ran_cond == false or stat == false then
			return true;
		else
			return false;
		end
	end

	---|fE
end

--- Detaches from {window}.
---@param window integer
winbar.detach = function (window)
	---|fS

	vim.schedule(function ()
		pcall(function ()
			vim.w[window].__wbID = nil;

			--- Cached winbar.
			---@type string | nil
			local _wb = vim.w[window].__winbar or vim.g.__winbar or "";

			if _wb == "" or _wb == nil then
				--- Reset winbar.
				vim.api.nvim_win_call(window, function ()
					pcall(function ()
						vim.cmd("set winbar&");
					end);
				end);
			else
				pcall(vim.api.nvim_set_option_value,
					"winbar",
					_wb,
					{
						scope = "local",
						win = window
					}
				);
			end

			winbar.state.attached_windows[window] = false;
		end)
	end);

	---|fE
end

--- Can we attach to {win}
---@param win integer
---@param force? boolean Forcefully attaches to a window whose state is `false`.
---@return boolean
winbar.can_attach = function (win, force)
	---|fS

	if vim.api.nvim_win_is_valid(win) == false then
		return false;
	elseif force ~= true and winbar.state.attached_windows[win] == false then
		return false;
	elseif winbar.state.enable == false then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if vim.list_contains(winbar.config.ignore_filetypes, ft) then
		return false;
	elseif vim.list_contains(winbar.config.ignore_buftypes, bt) then
		return false;
	else
		if not winbar.config.condition then
			return true;
		end

		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(winbar.config.condition, buffer, win);

		if ran_cond == false or stat == false then
			return false;
		else
			return true;
		end
	end

	---|fE
end

--- Attaches the winbar module to the windows
--- of a buffer.
---@param window integer
---@param force? boolean Forcefully attaches to a window whose state is `false`.
winbar.attach = function (window, force)
	---|fS

	if winbar.can_attach(window, force) == false then
		return;
	elseif winbar.state.attached_windows[window] == true then
		if vim.wo[window].winbar == WBR then
			winbar.update_id(window);
			return;
		end
	end

	winbar.update_id(window);

	vim.w[window].__winbar = vim.wo[window].winbar == WBR and "" or vim.wo[window].winbar;
	vim.wo[window].winbar = WBR;

	---|fE
end

--- Attaches globally.
winbar.global_attach = function ()
	---|fS

	if winbar.state.enable == false then
		return;
	elseif winbar.config.condition then
		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(winbar.config.condition, vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win());

		if ran_cond == false or stat == false then
			return;
		end
	end

	for _, window in ipairs(vim.api.nvim_list_wins()) do
		winbar.update_id(window);
	end

	vim.g.__winbar = vim.o.winbar == WBR and "" or vim.o.winbar;
	vim.o.winbar = WBR;

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
winbar.clean = function ()
	---|fS

	vim.schedule(function ()
		for window, _ in pairs(winbar.state.attached_windows) do
			if winbar.can_detach(window) then
				winbar.detach(window);
			end
		end
	end);

	---|fE
end

----------------------------------------------------------------------

--- Enables winbar for `window`.
---@param window integer
winbar.enable = function (window)
	---|fS

	if type(window) ~= "number" or winbar.state.attached_windows[window] == nil then
		return;
	end

	winbar.attach(window, true);

	---|fE
end

--- Enables *all* attached windows.
winbar.Enable = function ()
	---|fS

	winbar.state.enable = true;

	for window, state in pairs(winbar.state.attached_windows) do
		if state ~= true then
			winbar.enable(window);
		end
	end

	---|fE
end

--- Disables winbar for `window`.
---@param window integer
winbar.disable = function (window)
	---|fS

	if type(window) ~= "number" or winbar.state.attached_windows[window] == nil then
		return;
	end

	winbar.detach(window);

	---|fE
end

--- Disables *all* attached windows.
winbar.Disable = function ()
	---|fS

	for window, state in pairs(winbar.state.attached_windows) do
		if state ~= false then
			winbar.disable(window);
		end
	end

	winbar.state.enable = false;

	---|fE
end

----------------------------------------------------------------------

--- Toggles state of given window.
---@param window integer
winbar.toggle = function (window)
	---|fS

	if type(window) ~= "number" or winbar.state.attached_windows[window] == nil then
		return;
	elseif winbar.state.attached_windows[window] == true then
		winbar.disable(window);
	else
		winbar.enable(window);
	end

	---|fE
end

--- Toggles winbar **globally**.
winbar.Toggle = function ()
	---|fS

	if winbar.state.enable == true then
		winbar.Disable();
	else
		winbar.Enable();
	end

	---|fE
end

----------------------------------------------------------------------

--- Sets up the winbar module.
---@param config winbar.config | boolean | nil
winbar.setup = function (config)
	---|fS

	if type(config) == "table" then
		winbar.config = vim.tbl_extend("force", winbar.config, config);
	elseif type(config) == "boolean" then
		winbar.state.enable = config;
	end

	for window, _ in pairs(winbar.state.attached_windows) do
		vim.w[window].__wbID = winbar.update_id(window);
	end

	---|fE
end

return winbar;
