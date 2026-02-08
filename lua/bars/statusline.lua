local statusline = {};

statusline.__index = require("bars.generic");
statusline = setmetatable(statusline, statusline);

statusline.default = "%!v:lua.require('bars.statusline').render()";

---@class bars.statusline.state
---
---@field enable boolean
---@field window_state table<integer, boolean|nil>
statusline.state = {
	enable = true,
	window_state = {},
};

---@class bars.statusline.config
---
---@field force_attach string[]
---@field condition? fun(win: integer, buf: integer): boolean
---
---@field filetypes? string[]
---@field buftypes? string[]
---
---@field ignore_filetypes? string[]
---@field ignore_buftypes? string[]
statusline.config = {
	-- force_attach = {},
	-- condition = function () return true; end

	-- filetypes = {},
	-- buftypes = {},

	-- ignore_buftypes = {},
	-- ignore_filetypes = {},
};

function statusline:original ()
	return vim.g.bars_cache and vim.g.bars_cache.self or "";
end

function statusline:current (win) return vim.wo[win].statusline; end

function statusline:start ()
	if not statusline.state.enable then
		return;
	end

	vim.api.nvim_set_option_value("statusline", statusline.default, { scope = "global" });

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		statusline:handle_new_window(win);
	end
end

--------------------------------------------------------------------------------

---@param win integer
function statusline:set (win)
	vim.api.nvim_set_option_value("statusline", statusline.default, {
		scope = "local",
		win = win
	});
end

---@param win integer
function statusline:remove (win)
	vim.api.nvim_win_call(win, function ()
		vim.schedule(function ()
			vim.cmd("set statusline=" .. (statusline:original() or ""));
		end)
	end);
end

statusline.render = function ()
	return "Hi";
end

return statusline;
