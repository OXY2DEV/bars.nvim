-- local bars = require("bars");
require("bars.global");

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "WinEnter" }, {
	callback = function (ev)
		require("bars.statusline").attach(ev.buf);
		require("bars.statuscolumn").attach(ev.buf);
	end
});
