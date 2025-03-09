local bars = {};

---@type bars.config
bars.config = {
	global = true
};

---@return table<string, table>
local function get_modules()
	return {
		statuscolumn = package.loaded["bars.statuscolumn"];
		statusline = package.loaded["bars.statusline"];
		tabline = package.loaded["bars.tabline"];
		winbar = package.loaded["bars.winbar"];
	};
end

bars.actions = {
	Toggle = function (affect)
		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) then
				pcall(module.Toggle);
			end
		end
	end,

	Enable = function (affect)
		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) then
				pcall(module.Enable);
			end
		end
	end,
	Disable = function (affect)
		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) then
				pcall(module.Disable);
			end
		end
	end,

	toggle = function (affect, windows)
		windows = windows or { vim.api.nvim_get_current_win() };

		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) == false then
				goto continue
			end

			for _, window in ipairs(windows) do
				pcall(module.toggle, window);
			end

		    ::continue::
		end
	end,
	enable = function (affect, windows)
		windows = windows or { vim.api.nvim_get_current_win() };

		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) == false then
				goto continue
			end

			for _, window in ipairs(windows) do
				pcall(module.enable, window);
			end

		    ::continue::
		end
	end,
	disable = function (affect, windows)
		windows = windows or { vim.api.nvim_get_current_win() };

		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) == false then
				goto continue
			end

			for _, window in ipairs(windows) do
				pcall(module.enable, window);
			end

		    ::continue::
		end
	end,

	clean = function (affect)
		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) == false then
				goto continue
			end

			pcall(module.clean);

		    ::continue::
		end
	end,
	update = function (affect, windows)
		windows = windows or { vim.api.nvim_get_current_win() };

		local modules = get_modules();
		affect = affect or vim.tbl_keys(modules);

		for name, module in pairs(modules) do
			if vim.list_contains(affect, name) == false then
				goto continue
			end

			for _, window in ipairs(windows) do
				pcall(module.enable, window);
			end

		    ::continue::
		end
	end
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
