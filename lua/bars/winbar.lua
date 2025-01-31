local winbar = {};
local utils = require("bars.utils");
local components = require("bars.components.winbar");

---@class winbar.config
winbar.config = {
	---|fS

	ignore_filetypes = {},
	ignore_buftypes = { "nofile", "help" },

	condition = function (buffer)
		local check_parsers, parsers = pcall(vim.treesitter.get_parser, buffer);

		if check_parsers == false then
			return false;
		elseif parsers == nil then
			return false;
		end
	end,

	default = {
		parts = {
			{
				kind = "node",
				lookup = 3,

				separator = " → ",
				separator_hl = "Comment",

				default = {
					__lookup = {
						padding_left = " ",
						padding_right = " ",

						icon = "",

						hl = "Color4R"
					},

				},

				["^luadoc$"] = {
					---|fS

					__lookup = {
						padding_left = " ",
						padding_right = " ",

						icon = "",

						hl = "Color4R"
					},

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

					__lookup = {
						padding_left = " ",
						padding_right = " ",

						icon = "",

						hl = "Color4R"
					},

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
				}
			}
		}
	}

	---|fE
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

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(winbar.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = winbar.config[key];

		if tmp.condition == true then
			return key;
		elseif pcall(tmp.condition --[[ @as function ]], buffer, window) and tmp.condition(buffer, window) == true  then
			return key;
		end

		::continue::
	end

	return "default";

	---|fE
end

--- Renders the winbar for a window.
---@param buffer integer
---@param window integer
---@return string
winbar.render = function (buffer, window)
	---|fS

	if window ~= vim.g.statusline_winid then
		return "";
	elseif winbar.state.attached_windows[window] ~= true then
		return "";
	end

	local wbID = vim.w[window].__scID;

	if not wbID then
		return "";
	end

	local config = winbar.config[wbID];

	if type(config) ~= "table" then
		return "";
	end

	local _o = "%#Normal#";

	for _, part in ipairs(config.parts or {}) do
		_o = _o .. components.get(part.kind, buffer, window, part, _o);
	end

	return _o;

	---|fE
end

winbar.detach = function (buffer)
	---|fS

	if type(buffer) ~= "number" then
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return;
	end

	local windows = vim.fn.win_findbuf(buffer)

	for _, win in ipairs(windows) do
		vim.defer_fn(function ()
			winbar.state.attached_windows[win] = false;
			vim.wo[win].winbar = vim.w[win].__winbar and vim.w[win].__winbar[1] or "";

			vim.w[win].__wbID = nil;
			vim.w[win].__winbar = nil;
		end, 0);
	end

	---|fE
end

--- Attaches the winbar module to the windows
--- of a buffer.
---@param buffer integer
winbar.attach = function (buffer)
	---|fS

	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if type(buffer) ~= "number" then
		winbar.detach(buffer);
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		winbar.detach(buffer);
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		winbar.detach(buffer);
		return;
	elseif vim.list_contains(winbar.config.ignore_filetypes, ft) then
		winbar.detach(buffer);
		return;
	elseif vim.list_contains(winbar.config.ignore_buftypes, bt) then
		winbar.detach(buffer);
		return;
	elseif winbar.config.condition then
		local checked_condition, result = pcall(winbar.config.condition, buffer);

		if checked_condition == false then
			winbar.detach(buffer);
			return;
		elseif result == false then
			winbar.detach(buffer);
			return;
		end
	end

	local windows = vim.fn.win_findbuf(buffer);

	for _, win in ipairs(windows) do
		if winbar.state.attached_windows[win] == true then
			goto continue;
		end

		vim.defer_fn(function ()
			local wbID = winbar.update_id(win);
			winbar.state.attached_windows[win] = true;

			vim.w[win].__wbID = wbID;

			vim.w[win].__winbar = utils.to_constant(vim.wo[win].winbar);
			vim.wo[win].winbar = "%!v:lua.require('bars.winbar').render(" .. buffer .."," .. win ..")";
		end, 0);

		::continue::
	end

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
winbar.clean = function ()
	for window, _ in pairs(winbar.state.attached_windows) do
		if vim.api.nvim_win_is_valid(window) == false then
			winbar.state.attached_windows[window] = false;
			goto continue;
		end

		local buffer = vim.api.nvim_win_get_buf(window);

		local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

		if type(buffer) ~= "number" then
			winbar.detach(buffer);
			return;
		elseif vim.api.nvim_buf_is_loaded(buffer) == false then
			winbar.detach(buffer);
			return;
		elseif vim.api.nvim_buf_is_valid(buffer) == false then
			winbar.detach(buffer);
			return;
		elseif vim.list_contains(winbar.config.ignore_filetypes, ft) then
			winbar.detach(buffer);
			return;
		elseif vim.list_contains(winbar.config.ignore_buftypes, bt) then
			winbar.detach(buffer);
			return;
		elseif winbar.config.condition then
			local checked_condition, result = pcall(winbar.config.condition, buffer);

			if checked_condition == false then
				winbar.detach(buffer);
				return;
			elseif result == false then
				winbar.detach(buffer);
				return;
			end
		end

		::continue::
	end
end

--- Sets up the winbar module.
---@param config winbar.config | nil
winbar.setup = function (config)
	if type(config) == "table" then
		winbar.config = vim.tbl_extend("force", winbar.config, config);
	end

	for window, _ in pairs(winbar.state.attached_windows) do
		vim.w[window].__wbID = winbar.update_id(window);
	end
end

return winbar;
