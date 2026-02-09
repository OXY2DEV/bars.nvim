---@diagnostic disable: duplicate-set-field
local tabline = require("bars.generic").new();

tabline.default = "%!v:lua.require('bars.tabline').render()";
tabline.var_name = "bars_tabline_style";

---@class tabline.config
tabline.config = {
	default = {
		components = {
			---|fS

			{ kind = "empty", hl = "Normal" },
			{
				kind = "tabs",
				condition = function ()
					return vim.g.bars_tabline_show_buflist ~= true;
				end,

				separator = " ",
				separator_hl = "Normal",

				overflow = " ┇ ",
				overflow_hl = "BarsNavOverflow",

				nav_left = "   ",
				nav_left_hl = "BarsNav",

				nav_left_locked = "    ",
				nav_left_locked_hl = "BarsNavLocked",

				nav_right = "   ",
				nav_right_hl = "BarsNav",

				nav_right_locked = " 󰌾  ",
				nav_right_locked_hl = "BarsNavLocked",

				active = {
					padding_left = " ",
					padding_right = " ",

					divider = " ┃ ",

					win_count = "󰨝 %d",
					win_count_hl = nil,

					-- bufname = "󰳽 %s",

					icon = "󰛺 ",

					hl = "BarsTab"
				},
				inactive = {
					padding_left = " ",
					padding_right = " ",

					divider = " | ",

					icon = "󰛻 ",

					-- bufname = "󰳽 %s",

					hl = "BarsInactive"
				}
			},
			{
				kind = "bufs",
				condition = function ()
					return vim.g.bars_tabline_show_buflist == true;
				end,

				separator = " ",
				separator_hl = "Normal",

				overflow = " ┇ ",
				overflow_hl = "BarsNavOverflow",

				nav_left = "   ",
				nav_left_hl = "BarsNav",

				nav_left_locked = "    ",
				nav_left_locked_hl = "BarsNavLocked",

				nav_right = "   ",
				nav_right_hl = "BarsNav",

				nav_right_locked = " 󰌾  ",
				nav_right_locked_hl = "BarsNavLocked",

				active = {
					padding_left = " ",
					padding_right = " ",

					win_count = " ┃ 󰨝 %d",
					win_count_hl = nil,

					icon = "",

					hl = "Color7R"
				},
				inactive = {
					padding_left = " ",
					padding_right = " ",

					icon = "",

					hl = "BarsInactive",
					max_name_len = 10,
				}
			},
			{ kind = "empty", hl = "Normal" },

			---|fE
		}
	}
};

function tabline:original ()
	return vim.g.bars_cache and vim.g.bars_cache.tabline or "";
end

function tabline:current (_) return vim.o.tabline; end

function tabline:start ()
	if not tabline.state.enable then
		return;
	end

	vim.api.nvim_set_option_value("tabline", tabline.default, { scope = "global" });

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		tabline:handle_new_window(win);
	end
end

--------------------------------------------------------------------------------

---@param _ integer
function tabline:set (_)
	vim.api.nvim_set_option_value("tabline", tabline.default, {
		scope = "global",
	});
end

---@param _ integer
function tabline:remove (_)
	vim.schedule(function ()
		vim.cmd("set tabline=" .. (tabline:original() or ""));
	end)
end

function tabline:render ()
	local components = require("bars.components.tabline");
	local win = vim.g.statusline_winid;

	return tabline:get_styled_output(win, components);
end

return tabline;
