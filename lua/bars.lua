local bars = {};

---@type bars.config
bars.config = {
	---|fS

	global = true,

	statuscolumn = true,
	statusline = true,
	tabline = true,
	-- winbar = function ()
	-- 	if not _G.is_within_termux then
	-- 		--- The function doesn't
	-- 		--- exist.
	-- 		return true;
	-- 	else
	-- 		--- Winbar should be disabled
	-- 		--- while inside Termux.
	-- 		return _G.is_within_termux() == false;
	-- 	end
	-- end,

	---|fE
};

--- Gets the modules need by `bars.nvim`.
--- Note: This is to prevent loading
---       the modules at start.
---@return table<string, table>
local function get_modules()
	---|fS

	return {
		statuscolumn = package.loaded["bars.statuscolumn"];
		statusline = package.loaded["bars.statusline"];
		tabline = package.loaded["bars.tabline"];
		winbar = package.loaded["bars.winbar"];
	};

	---|fE
end

--- Various actions that exposes the plugin's
--- functionality outside.
---@type table<string, function>
bars.actions = {
	---|fS

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
				pcall(module.disable, window);
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

	---|fE
};

--- Setup function.
--- Should be optional.
---@param config bars.config | nil
bars.setup = function (config)
	---|fS

	--- Update the configuration.
	if type(config) == "table" then
		bars.config = vim.tbl_deep_extend("force", bars.config, config);
	end

	local _config = {};

	for key, value in pairs(bars.config) do
		if type(value) == "function" then
			local can_call, new_value = pcall(value);

			if can_call == true then
				_config[key] = new_value;
			else
				_config[key] = nil;
			end
		else
			_config[key] = value;
		end
	end

	require("bars.statusline").setup(_config.statusline);
	require("bars.statuscolumn").setup(_config.statuscolumn);
	require("bars.winbar").setup(_config.winbar);

	require("bars.tabline").setup(_config.tabline);

	---|fE
end

return bars;
