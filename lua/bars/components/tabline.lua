local tlC = {};
local utils = require("bars.utils");

tlC.tabs = function (config)
	local tabs = vim.api.nvim_list_tabpages();
	local _o = "";

	for t, tab in ipairs(tabs) do
		local current = tab == vim.api.nvim_get_current_tabpage();
		local tab_config = utils.match(config, current == true and "active" or "inactive", {});

		_o = table.concat({
			_o,

			"%" .. t .. "T",

			utils.set_hl(tab_config.corner_left_hl or tab_config.hl),
			tab_config.corner_left or "",

			utils.set_hl(tab_config.padding_left_hl or tab_config.hl),
			tab_config.padding_left or "",

			utils.set_hl(tab_config.icon_hl or tab_config.hl),
			tab_config.icon or "",

			utils.set_hl(tab_config.hl),
			tab,

			utils.set_hl(tab_config.padding_right_hl or tab_config.hl),
			tab_config.padding_right or "",

			utils.set_hl(tab_config.corner_right_hl or tab_config.hl),
			tab_config.corner_right or "",

			"%X"
		});
	end

	return _o;
end

--- Returns the output of the section {name}.
---@param part_config table
---@param tabline string
---@return string
tlC.get = function (name, part_config, tabline)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(tlC[name]) ~= "function" then
		--- Attempting to get internal property.
		return "";
	else
		if part_config.condition ~= nil then
			if part_config.condition == false then
				--- Part is disabled.
				return "";
			else
				local sucess, val = pcall(part_config.condition, tabline);

				if sucess == false then
					return "";
				elseif val == false then
					return "";
				end
			end
		end

		local static_config = vim.deepcopy(part_config);

		for key, value in pairs(static_config) do
			if type(value) ~= "function" then
				goto continue;
			end

			local s_success, s_val = pcall(value, tabline);

			if s_success == false then
				static_config[key] = nil;
			else
				static_config[key] = s_val;
			end

			::continue::
		end

		--- Return component value.
		return tlC[name](static_config, tabline) or "";
	end

	---|fE
end

return tlC;
