local bars = {};

---@type bars.config
bars.config = {
	global = true
};

local function list_modules()
	---@type table[]
	local MODULES = {};

	--- Use `table.insert` to preserve list
	--- structure.
	table.insert(MODULES, package.loaded["bars.statuscolumn"]);
	table.insert(MODULES, package.loaded["bars.statusline"]);
	table.insert(MODULES, package.loaded["bars.tabline"]);
	table.insert(MODULES, package.loaded["bars.winbar"]);

	return MODULES;
end

bars.actions = {
	Toggle = function ()
		local modules = list_modules();

		for _, module in ipairs(modules) do
			pcall(module.Toggle);
		end
	end,

	Enable = nil,
	Disable = nil,

	toggle = nil,
	enable = nil,
	disable = nil,

	eval = nil,
	Eval = nil
}

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
