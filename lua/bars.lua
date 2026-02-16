--[[
# 🍫 bars.nvim

A *fancy* `bars & lines` plugin for `Neovim`.

[Github](https://github.com/OXY2DEV/bars.nvim)
[Usage](https://github.com/OXY2DEV/bars.nvim/wiki)
]]
local bars = {};

--[[ Executes an `action`. ]]
---@param action bars.command
---@param on bars.target[]
---@param ... any
bars.exec = function (action, on, ...)
	local modules = { "statusline", "statuscolumn", "winbar", "tabline" };
	on = on or modules;

	for _, mod_name in ipairs(modules) do
		if vim.list_contains(on, mod_name) then
			local could_load, module = pcall(require, "bars." .. mod_name);

			if could_load and module then
				pcall(module[action], module, ...)
			end
		end
	end
end

---@param config? bars.config
bars.setup = function (config)
	---@diagnostic disable-next-line: param-type-mismatch
	for k, v in pairs(config) do
		local could_load, submodule = pcall(require, "bars." .. k);

		if could_load and submodule then
			pcall(submodule.setup, v);
		end
	end
end

return bars;
