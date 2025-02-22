local bars = {};

---@type bars.config
bars.config = {
	global = true
};

--- Setup function.
--- Should be optional.
---@param config bars.config | nil
bars.setup = function (config)
	--- Update the configuration.
	if type(config) == "table" then
		bars.config = vim.tbl_deep_extend("force", bars.config, config);
	end

	require("bars.statusline").setup(bars.config.statusline);
	require("bars.statuscolumn").setup(bars.config.statuscolumn);
	require("bars.winbar").setup(bars.config.winbar);

	require("bars.tabline").setup(bars.config.tabline);
end

return bars;
