local bars = {};

---@class bars.config
---
--- When true, all options are set
--- globally.
--- Can be used to prevent visible
--- changes to the bars & lines when
--- opening Neovim or new windows.
---@field global boolean
---
---@field statusline statusline.config
---@field statuscolumn statuscolumn.config
---@field winbar winbar.config
---
---@field tabline tabline.config
bars.config = {
	global = true
};

bars.setup = function (config)
	if type(config) == "table" then
		--- Update configuration.
		bars.config = vim.tbl_deep_extend("force", bars.config, config);
	end

	require("bars.statusline").setup(bars.config.statusline);
	require("bars.statuscolumn").setup(bars.config.statuscolumn);
	require("bars.winbar").setup(bars.config.winbar);

	require("bars.tabline").setup(bars.config.tabline);
end

return bars;
