--- Utility functions.
local utils = require("bars.utils");

--- Load all the global functions.
require("bars.global");

---|fS "Cache default values."

vim.g.__statusline = utils.constant(vim.o.statusline);

vim.g.__relativenumber = utils.constant(vim.o.relativenumber);
vim.g.__numberwidth = utils.constant(vim.o.numberwidth);
vim.g.__statuscolumn = utils.constant(vim.o.statuscolumn);

vim.g.__winbar = utils.constant(vim.o.winbar);
vim.g.__tabline = utils.constant(vim.o.tabline);

---|fE

--- Attach various bars & lines globally if
--- `global = true`.
if require("bars").config.global == true then
	require("bars.statuscolumn").global_attach();
	require("bars.statusline").global_attach();
	require("bars.winbar").global_attach();

	require("bars.tabline").attach();
else
	require("bars.tabline").attach();
end

--- Attach to new Windows.
---
--- Also rum this when a buffer is displayed
--- in a window as the filetype/buftype may
--- could have changed.
---
--- `VimEnter` is used because the other events
--- don't trigger when entering Neovim.
vim.api.nvim_create_autocmd({
	"VimEnter",

	"WinNew",
	"BufWinEnter"
}, {
	callback = function ()
		---|fS

		require("bars.statusline").clean();
		require("bars.statuscolumn").clean();
		require("bars.winbar").clean();
		require("bars.tabline").clean();

		vim.schedule(function ()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				require("bars.statusline").attach(win);
				require("bars.statuscolumn").attach(win);
				require("bars.winbar").attach(win);
			end

			require("bars.tabline").attach();
		end);

		---|fE
	end
});

--- When the 'filetype' or 'buftype' option is set
--- we must clean up any window that has become invalid
--- and update the configuration of existing windows.
---
--- TODO, Check if this causes performance issues
--- with large amount of windows.
vim.api.nvim_create_autocmd({ "OptionSet" }, {
	callback = function ()
		---|fS

		local option = vim.fn.expand("<amatch>");
		local valid_options = { "filetype", "buftype" };

		if vim.list_contains(valid_options, option) == false then
			return;
		end

		--- Clean up invalid windows.
		require("bars.statusline").clean();
		require("bars.statuscolumn").clean();
		require("bars.winbar").clean();
		require("bars.tabline").clean();

		vim.schedule(function ()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				require("bars.statusline").attach(win);
				require("bars.statuscolumn").attach(win);
				require("bars.winbar").attach(win);
			end

			require("bars.tabline").attach();
		end);

		---|fE
	end
});

--- Update various bars & lines on Vim mode change.
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	callback = function (event)
		---|fS

		--- We wrap this in `vim.schedule()` so
		--- that the update happens after doing
		--- something like,
		--- 
		--- ```vim
		--- :lua vim.g.__bars_tabpage_list_locked = false
		--- ```
		---
		--- We no longer have to redraw the screen
		--- twice!
		vim.schedule(function ()
			--- Unstable API function.
			--- Use `pcall()`
			pcall(vim.api.nvim__redraw, {
				buf = event.buf,
				flush = true,

				statuscolumn = true,
				statusline = true,
				winbar = true,
				tabline = true
			});
		end);

		---|fE
	end
});

--- Update the tab list when opening new windows.
vim.api.nvim_create_autocmd({ "TabNew" }, {
	callback = function ()
		---|fS

		local max = vim.g.__tabline_max_tabs or 5;
		local tabs = #vim.api.nvim_list_tabpages();

		if not package.loaded["bars.tabline"] then
			return;
		elseif vim.g.__bars_tabpage_list_locked == true then
			--- List movement locked.
			return;
		elseif tabs <= max then
			return;
		end

		vim.g.__bars_tabpage_from = math.max(1, tabs - math.floor(max * 0.25));
		---|fE
	end
});
