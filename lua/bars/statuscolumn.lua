---@diagnostic disable: duplicate-set-field
local statuscolumn = require("bars.generic").new();
statuscolumn:set_default_state();

statuscolumn.default = "%!v:lua.require('bars.statuscolumn').render()";
statuscolumn.var_name = "bars_statuscolumn_style";

---@class bars.statusline.state
statuscolumn.state = {
	enable = true,
	window_state = {},
};

local gradient_map = {
	default = "BarsNormal%d",

	["v"] = "BarsVisual%d",
	["V"] = "BarsVisualLine%d",
	[""] = "BarsVisualBlock%d",

	["s"] = "BarsVisual%d",
	["S"] = "BarsVisualLine%d",
	[""] = "BarsVisualBlock%d",

	["i"] = "BarsInsert%d",
	["ic"] = "BarsInsert%d",
	["ix"] = "BarsInsert%d",

	["R"] = "BarsInsert%d",
	["Rc"] = "BarsInsert%d",

	["c"] = "BarsCommand%d",
	["!"] = "BarsCommand%d",
};


---@type statuscolumn.config
statuscolumn.config = {
	force_attach = {},

	ignore_filetypes = { "blink-cmp-menu" },
	ignore_buftypes = { "help", "quickfix" },

	condition = function (buffer)
		local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

		if bt == "nofile" and ft == "query" then
			--- Buffer for `:InspectTree`
			return true;
		elseif bt == "nofile" then
			--- Normal nofile buffer.
			return false;
		else
			return true;
		end
	end,

	default = {
		components = {
			---|fS

			{
				kind = "empty",
				width = 1,

				hl = "LineNr"
			},
			{
				kind = "signs",
				hl = "LineNr",

				filter = function (buffer, namespaces, _, _, _, details)
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local name = namespaces[details.ns_id] or "";

					if package.loaded["markview"] and vim.bo[buffer].ft == "markdown" then
						--- On markdown files when on normal
						--- mode only show markview signs.
						if mode == "n" then
							return string.match(name, "^markview") ~= nil;
						else
							return true;
						end
					elseif package.loaded["helpview"] and vim.bo[buffer].ft == "help" then
						--- On help files when on normal
						--- mode only show helpview signs.
						if mode == "n" then
							return string.match(name, "^helpview") ~= nil;
						else
							return true;
						end
					else
						if vim.list_contains({ "i", "v", "V", "" }, mode) then
							--- On visual mode only show git signs.
							return string.match(name, "^gitsigns") ~= nil;
						end

						return true;
					end
				end
			},
			{
				kind = "folds",

				close_text = { "󱠂" },
				close_hl = { "BarsFoldClose1", "BarsFoldClose2", "BarsFoldClose3", "BarsFoldClose4", "BarsFoldClose5", "BarsFoldClose6", },
				open_text = { "󰌶" },
				open_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },

				scope_text = "│",
				scope_end_text = "╰",
				scope_merge_text = "├",

				fill_text = " ",
				fill_hl = "LineNr",

				scope_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },
				scope_end_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },
				scope_merge_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },
			},
			{
				kind = "empty",
				width = 1,
				hl = "LineNr"
			},
			{
				kind = "lnum",
				mode = 3,

				click = function (_, window)
					return window == vim.api.nvim_get_current_win();
				end,

				wrap_markers = "│",
				virt_markers = "│",

				wrap_hl = {
					"BarsWrap1", "BarsWrap2", "BarsWrap3", "BarsWrap4", "BarsWrap5",
				},
				virt_hl = {
					"BarsVirtual1", "BarsVirtual2", "BarsVirtual3", "BarsVirtual4", "BarsVirtual5",
				},
				hl = function ()
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local USE = gradient_map[mode] or gradient_map.default

					return {
						string.format(USE, 1),
						"LineNr",
					};
				end,
			},
			{
				kind = "border",
				text = "▕",
				hl = function ()
					local _o = {};
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local USE = gradient_map[mode] or gradient_map.default

					for g = 1, 7 do
						table.insert(_o, string.format(USE, g));
					end

					return _o;
				end
			},
			{
				kind = "empty",
				width = 1,
				hl = "Normal"
			},

			---|fE
		}
	},

	inspect_tree = {
		---|fS

		condition = function (buffer, window)
			if vim.b[buffer].dev_base then
				return true;
			elseif vim.w[window].inspecttree_window then
				return true;
			end

			return false;
		end,

		components = {
			{
				kind = "custom",
				value = function (buffer)
					local lnums = vim.b[buffer].injections or {};
					local current = lnums[vim.v.lnum] or "LineNr";

					return "%#" .. current .. "# ";
				end
			},
		}

		---|fE
	},

	terminal = {
		---|fS

		condition = function (buffer)
			return vim.bo[buffer].bt == "terminal";
		end,

		components = {}

		---|fE
	}
};

function statuscolumn:original ()
	return vim.g.bars_cache and {
		statuscolumn = vim.g.bars_cache.statuscolumn,
		number = vim.g.bars_cache.number,
		relativenumber = vim.g.bars_cache.relativenumber,
	} or {
		statuscolumn = "",
		number = false,
		relativenumber = false,
	};
end

function statuscolumn:current (win) return vim.wo[win].statuscolumn; end

function statuscolumn:start ()
	if not statuscolumn.state.enable then
		return;
	end

	vim.api.nvim_set_option_value("statuscolumn", statuscolumn.default, { scope = "global" });

	vim.api.nvim_set_option_value("number", true, { scope = "global" });
	vim.api.nvim_set_option_value("relativenumber", true, { scope = "global" });

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		statuscolumn:handle_new_window(win);
	end
end

--------------------------------------------------------------------------------

---@param win integer
function statuscolumn:set (win)
	vim.api.nvim_set_option_value("statuscolumn", statuscolumn.default, {
		scope = "local",
		win = win
	});
end

---@param win integer
function statuscolumn:remove (win)
	vim.api.nvim_win_call(win, function ()
		vim.schedule(function ()
			local original = statuscolumn:original();

			vim.cmd("set statuscolumn=" .. (original.statuscolumn or ""));

			vim.api.nvim_set_option_value("number", original.number, { scope = "local", win = win });
			vim.api.nvim_set_option_value("relativenumber", original.relativenumber, { scope = "local", win = win });
		end)
	end);
end

function statuscolumn:render ()
	local components = require("bars.components.statuscolumn");
	local win = vim.g.statusline_winid;

	return statuscolumn:get_styled_output(win, components);
end

return statuscolumn;
