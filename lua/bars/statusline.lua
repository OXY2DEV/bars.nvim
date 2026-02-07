local statusline = {};

statusline.default = "%!v:lua.require('bars.statusline').render()";

statusline.start = function ()
	vim.api.nvim_set_option_value("statusline", statusline.default, { scope = "global" });
end

statusline.attach = function (win)
	vim.api.nvim_set_option_value("statusline", statusline.default, { win = win });
end

statusline.detach = function (win)
	local original = vim.g.bars_cache and vim.g.bars_cache.statusline or "";
	vim.api.nvim_set_option_value("statusline", original or "", { win = win });
end

--------------------------------------------------------------------------------

statusline.render = function ()
	return "Hi";
end

return statusline;
