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
		vim.g.bars_update_cache();

		require("bars.statusline").start();
	end
});

