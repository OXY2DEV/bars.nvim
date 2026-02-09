local augroup = vim.api.nvim_create_augroup("bars.nvim", {});

---@class vim.var_accessor
---@field bars_update_cache function

-- Updates default *bars & lines* value.
-- > From: `bars.nvim`
vim.g.bars_update_cache = function()
	---|fS

	if not vim.g.bars_cached then vim.g.bars_cached = {}; end

	vim.g.bars_cached.statusline = vim.api.nvim_get_option_value("statusline", { scope = "global" });
	vim.g.bars_cached.statuscolumn = vim.api.nvim_get_option_value("statuscolumn", { scope = "global" });
	vim.g.bars_cached.winbar = vim.api.nvim_get_option_value("winbar", { scope = "global" });

	vim.g.bars_cached.tabline = vim.api.nvim_get_option_value("tabline", { scope = "global" });

	---|fE
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function ()
		vim.schedule(function ()
			vim.g.bars_update_cache();

			require("bars.statusline"):start();
			require("bars.statuscolumn"):start();
			require("bars.winbar"):start();
			require("bars.tabline"):start();
		end)
	end
});

vim.api.nvim_create_autocmd("WinNew", {
	group = augroup,
	callback = function ()
		vim.schedule(function ()
			local new_win = vim.api.nvim_get_current_win();

			require("bars.statusline"):handle_new_window(new_win);
			require("bars.statuscolumn"):handle_new_window(new_win);
			require("bars.winbar"):handle_new_window(new_win);
			require("bars.tabline"):handle_new_window(new_win);
		end)
	end
});

vim.api.nvim_create_autocmd("OptionSet", {
	group = augroup,
	callback = function (event)
		local style_change = { "statusline", "statuscolumn", "tabline", "winbar" };
		local state_change = { "filetype", "buftype" };

		vim.schedule(function ()
			local event_win = vim.api.nvim_get_current_win();

			if vim.list_contains(style_change, event.match) then
				require("bars.statusline"):update_style(event_win);
				require("bars.statuscolumn"):update_style(event_win);
				require("bars.winbar"):update_style(event_win);
				require("bars.tabline"):update_style(event_win);
			elseif vim.list_contains(state_change, event.match) then
				require("bars.statusline"):handle_new_window(event_win);
				require("bars.statuscolumn"):handle_new_window(event_win);
				require("bars.winbar"):handle_new_window(event_win);
				require("bars.tabline"):handle_new_window(event_win);
			end
		end)
	end
});

