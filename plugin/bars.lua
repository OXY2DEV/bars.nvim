local utils = require("bars.utils");
require("bars.global");

vim.g.__statusline = utils.constant(vim.o.statusline);

vim.g.__relativenumber = utils.constant(vim.o.relativenumber);
vim.g.__numberwidth = utils.constant(vim.o.numberwidth);
vim.g.__statuscolumn = utils.constant(vim.o.statuscolumn);

vim.g.__winbar = utils.constant(vim.o.winbar);
vim.g.__tabline = utils.constant(vim.o.tabline);

vim.api.nvim_create_autocmd({
	"VimEnter",

	"WinNew",
	"BufWinEnter"
}, {
	callback = function ()
		require("bars.statusline").clean();
		require("bars.statuscolumn").clean();
		require("bars.winbar").clean();
		require("bars.tabline").clean();

		for _, win in ipairs(vim.api.nvim_list_wins()) do
			require("bars.statusline").attach(win);
			require("bars.statuscolumn").attach(win);
			require("bars.winbar").attach(win);
		end
	end
});

vim.api.nvim_create_autocmd({ "OptionSet" }, {
	callback = function ()
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

		--- Attach new windows.
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			require("bars.statusline").attach(win);
			require("bars.statuscolumn").attach(win);
			require("bars.winbar").attach(win);
			require("bars.tabline").attach();
		end
	end
});
