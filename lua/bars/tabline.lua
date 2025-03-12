--- Custom tabline module
local tabline = {}
local components = require("bars.components.tabline");

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
				overflow_hl = "Layer1I",

				nav_left = "   ",
				nav_left_hl = "Color0",

				nav_left_locked = "    ",
				nav_left_locked_hl = "Color1",

				nav_right = "   ",
				nav_right_hl = "Color0",

				nav_right_locked = " 󰌾  ",
				nav_right_locked_hl = "Color1",

				active = {
					padding_left = " ",
					padding_right = " ",

					divider = " ┃ ",

					win_count = "󰨝 %d",
					win_count_hl = nil,

					-- bufname = "󰳽 %s",

					icon = "󰛺 ",

					hl = "Color4R"
				},
				inactive = {
					padding_left = " ",
					padding_right = " ",

					divider = " | ",

					icon = "󰛻 ",

					-- bufname = "󰳽 %s",

					hl = "Color0B"
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
				overflow_hl = "Layer1I",

				nav_left = "   ",
				nav_left_hl = "Color0",

				nav_left_locked = "    ",
				nav_left_locked_hl = "Color1",

				nav_right = "   ",
				nav_right_hl = "Color0",

				nav_right_locked = " 󰌾  ",
				nav_right_locked_hl = "Color1",

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

					hl = "Color0B",
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

--- Updates the configuration ID for the tabline.
---@return string | nil
tabline.update_id = function ()
	---|fS

	local keys = vim.tbl_keys(tabline.config);
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
		elseif pcall(tmp.condition --[[ @as fun():boolean ]]) and tmp.condition() == true  then
			ID = key;
		end

		::continue::
	end

	vim.g.__tlID = ID;
	tabline.state.attached = true;

	---|fE
end

--- Renders the tabline.
---@return string
tabline.render = function ()
	---|fS

	if tabline.state.attached ~= true then
		return "";
	end

	local tlID = vim.g.__tlID;

	if not tlID then
		return "";
	end

	local config = tabline.config[tlID];

	if type(config) ~= "table" then
		return "";
	end

	local _o = "%#Normal#";

	for _, component in ipairs(config.components or {}) do
		_o = _o .. components.get(component.kind, component, _o);
	end

	return _o;

	---|fE
end

tabline.can_detach = function ()
	if not tabline.config.condition then
		return false;
	end

	local checked_condition, result = pcall(tabline.config.condition);

	if checked_condition == false then
		return false;
	elseif result == false then
		return true;
	end
end

tabline.detach = function ()
	---|fS

	vim.schedule(function ()
		tabline.state.attached = false;

		--- Cached tabline.
		---@type string | nil
		local _tl = vim.g.__tabline or "";

		if _tl == "" or _tl == nil then
			--- Reset tabline.
			vim.cmd("set tabline&");
		else
			vim.api.nvim_set_option_value(
				"tabline",
				_tl,
				{
					scope = "global"
				}
			);
		end

		vim.g.__tlID = nil;
		vim.g.__tabline = nil;
	end);

	---|fE
end

tabline.can_attach = function ()
	if tabline.state.enable ~= true then
		return false;
	elseif tabline.state.attached == true then
		return false;
	elseif tabline.config.condition == nil then
		return true;
	end

	local checked_condition, result = pcall(tabline.config.condition);

	if checked_condition == false then
		return true;
	elseif result == false then
		return false;
	end
end

--- Attaches the tabline module.
tabline.attach = function ()
	---|fS

	if tabline.can_attach() == false then
		return;
	end

	tabline.update_id();

	vim.g.__tabline = vim.o.tabline == TBL and "" or vim.o.tabline;
	vim.o.tabline = TBL;

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
tabline.clean = function ()
	vim.schedule(function ()
		if tabline.can_detach() then
			tabline.detach();
		end
	end);
end

----------------------------------------------------------------------

--- Enables *all* attached windows.
tabline.Enable = function ()
	tabline.state.enable = true;

	tabline.attach();
end

--- Disables *all* attached windows.
tabline.Disable = function ()
	tabline.detach();

	tabline.state.enable = false;
end

----------------------------------------------------------------------

--- Toggles tabline.
tabline.Toggle = function ()
	if tabline.state.enable == true then
		tabline.Disable();
	else
		tabline.Enable();
	end
end

----------------------------------------------------------------------

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
