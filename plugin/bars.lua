-- local bars = require("bars");
require("bars.global");

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "WinEnter" }, {
	callback = function (ev)
		require("bars.statusline").attach(ev.buf);
		require("bars.statuscolumn").attach(ev.buf);
		require("bars.winbar").attach(ev.buf);
	end
});

vim.api.nvim_create_autocmd({ "OptionSet" }, {
	callback = function (ev)
		local buffer = ev.buf;

		local option = vim.fn.expand("<amatch>");
		local valid_options = { "filetype", "buftype" };

		if vim.list_contains(valid_options, option) == false then
			return;
		elseif buffer == 0 then
			buffer = vim.api.nvim_get_current_buf();
		end

		require("bars.statusline").clean();
		require("bars.statuscolumn").clean();
		require("bars.winbar").clean();

		-- require("bars.statusline").attach(ev.buf);
		-- require("bars.statuscolumn").attach(ev.buf);
		-- require("bars.winbar").attach(ev.buf);
	end
});
