--- Custom tabline module
local tabline = {}

--- Custom tabline.
---@type string
local TBL = "%!v:lua.require('bars.tabline').render()";

---@class tabline.config
tabline.config = {
	default = {
		components = {
			---|fS

			{ kind = "empty", hl = "Normal" },
			{
				kind = "tabs",
				condition = function ()
					return vim.g.__show_bufs ~= true;
				end,


				separator = " ",
				separator_hl = "Normal",

				overflow = " ┇ ",
				overflow_hl = "BarsNavOverflow",

				nav_left = "   ",
				nav_left_hl = "BarsNav",

				nav_left_locked = "    ",
				nav_left_locked_hl = "BarsNavLocked",

				nav_right = "   ",
				nav_right_hl = "BarsNav",

				nav_right_locked = " 󰌾  ",
				nav_right_locked_hl = "BarsNavLocked",

				active = {
					padding_left = " ",
					padding_right = " ",

					divider = " ┃ ",

					win_count = "󰨝 %d",
					win_count_hl = nil,

					-- bufname = "󰳽 %s",

					icon = "󰛺 ",

					hl = "BarsTab"
				},
				inactive = {
					padding_left = " ",
					padding_right = " ",

					divider = " | ",

					icon = "󰛻 ",

					-- bufname = "󰳽 %s",

					hl = "BarsInactive"
				}
			},
			{
				kind = "bufs",
				condition = function ()
					return vim.g.__show_bufs == true;
				end,

				separator = " ",
				separator_hl = "Normal",

				overflow = " ┇ ",
				overflow_hl = "BarsNavOverflow",

				nav_left = "   ",
				nav_left_hl = "BarsNav",

				nav_left_locked = "    ",
				nav_left_locked_hl = "BarsNavLocked",

				nav_right = "   ",
				nav_right_hl = "BarsNav",

				nav_right_locked = " 󰌾  ",
				nav_right_locked_hl = "BarsNavLocked",

				active = {
					padding_left = " ",
					padding_right = " ",

					win_count = " ┃ 󰨝 %d",
					win_count_hl = nil,

					icon = "",

					hl = "Color7R"
				},
				inactive = {
					padding_left = " ",
					padding_right = " ",

					icon = "",

					hl = "BarsInactive",
					max_name_len = 10,
				}
			},
			{ kind = "empty", hl = "Normal" },

			---|fE
		}
	}
};

---@type tabline.state
tabline.state = {
	enable = true,
	attached = false
};

tabline.check_condition = function ()
	if not tabline.config.condition then
		return true;
	end

	local can_call, cond = pcall(tabline.config.condition);
	return can_call and cond;
end

--- Renders the tabline.
---@return string
tabline.render = function ()
	---|fS

	local components = require("bars.components.tabline");

	if tabline.check_condition() == false then
		tabline.detach();
		return "";
	end

	tabline.update_id();

	local tlID = vim.g.__tlID or "default";
	local config = tabline.config[tlID];

	if type(config) ~= "table" then
		return "";
	end

	local _o = "";

	for _, component in ipairs(config.components or {}) do
		_o = _o .. components.get(component.kind, component, _o);
	end

	return _o;

	---|fE
end

--- Attaches the tabline module.
tabline.start = function ()
	---|fS

	if tabline.state.enable == false then
		return;
	end

	vim.api.nvim_set_option_value("tabline", TBL, { scope = "global" })

	---|fE
end

tabline.attach = function ()
	if tabline.state.enable == true then
		return;
	end

	vim.api.nvim_set_option_value("tabline", TBL, { scope = "global" })
	tabline.state.enable = true;
end

tabline.detach = function ()
	---|fS

	if tabline.state.enable ~= true then
		return;
	end

	vim.api.nvim_set_option_value(
		"tabline",
		vim.g.__tabline or "",
		{
			scope = "global"
		}
	);
	tabline.state.enable = false;

	---|fE
end

--- Updates the configuration ID for {window}.
tabline.update_id = function ()
	---|fS

	---@type string[]
	local keys = vim.tbl_keys(tabline.config);
	---@type string[]
	local ignore = { "default" };
	table.sort(keys);

	local ID = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(tabline.config[key]) ~= "table" then
			goto continue;
		end

		---@type tabline.opts
		local tmp = tabline.config[key];

		if tmp.condition == true then
			ID = key;
		elseif type(tmp.condition) == "function" then
			---@diagnostic disable-next-line
			local can_eval, val = pcall(tmp.condition, buffer, window);

			if can_eval and val then
				ID = key;
			end
		end

		---@diagnostic enable:undefined-field

		::continue::
	end

	vim.g.__tlID = ID;
	tabline.state.attached = true;

	---|fE
end

------------------------------------------------------------------------------

--[[ Toggles tabline for **all** windows. ]]
tabline.Toggle = function ()
	---|fS

	if tabline.state.enable == true then
		tabline.detach();
	else
		tabline.attach();
	end

	---|fE
end

--[[ Enables tabline for **all** windows. ]]
tabline.Enable = function ()
	tabline.attach();
end

--[[ Disables tabline for **all** windows. ]]
tabline.Disable = function ()
	tabline.detach();
end

--[[ Toggles tabline. ]]
tabline.toggle = function ()
	---|fS

	if tabline.state.enable == true then
		tabline.detach();
	else
		tabline.attach();
	end

	---|fE
end

--[[ Enables tabline. ]]
tabline.enable = function ()
	tabline.attach();
end

--[[ Disables tabline. ]]
tabline.disable = function ()
	tabline.detach();
end

------------------------------------------------------------------------------

--- Sets up the tabline module.
---@param config tabline.config | boolean | nil
tabline.setup = function (config)
	if type(config) == "table" then
		tabline.config = vim.tbl_extend("force", tabline.config, config);
	elseif type(config) == "boolean" then
		tabline.state.enable = config;
	end
end

return tabline;
