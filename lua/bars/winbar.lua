---@diagnostic disable: duplicate-set-field
local winbar = require("bars.generic").new();
winbar:set_default_state();

winbar.default = "%!v:lua.require('bars.winbar').render()";
winbar.var_name = "bars_winbar_style";

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
					_ellipsis = {
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

function winbar:original ()
	return vim.g.bars_cache and vim.g.bars_cache.winbar or "";
end

function winbar:current (win) return vim.wo[win].winbar; end

function winbar:start ()
	if not winbar.state.enable then
		return;
	end

	vim.api.nvim_set_option_value("winbar", winbar.default, { scope = "global" });

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		winbar:handle_new_window(win);
	end
end

--------------------------------------------------------------------------------

---@param win integer
function winbar:set (win)
	vim.api.nvim_set_option_value("winbar", winbar.default, {
		scope = "local",
		win = win
	});
end

---@param win integer
function winbar:remove (win)
	vim.api.nvim_win_call(win, function ()
		vim.schedule(function ()
			vim.cmd("set winbar=" .. (winbar:original() or ""));
		end)
	end);
end

function winbar:render ()
	local components = require("bars.components.winbar");
	local win = vim.g.statusline_winid;

	return winbar:get_styled_output(win, components);
end

function winbar.setup (config)
	if type(config) == "boolean" then
		winbar.state.enable = config;
	elseif type(config) == "table" then
		winbar.config = vim.tbl_extend("force", winbar.config, config);
	end
end

return winbar;
