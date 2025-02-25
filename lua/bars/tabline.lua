local tabline = {}
local components = require("bars.components.tabline");

---@class tabline.config
tabline.config = {
	---|fS

	default = {
		parts = {
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
		}
	}

	---|fE
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
		elseif pcall(tmp.condition) and tmp.condition() == true  then
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

	for _, part in ipairs(config.parts or {}) do
		_o = _o .. components.get(part.kind, part, _o);
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

	vim.scheduleefer_fn(function ()
		tabline.state.attached = false;
		vim.o.tabline = vim.o.__tabline or "";

		vim.g.__tlID = nil;
		vim.g.__tabline = nil;
	end);

	---|fE
end

tabline.can_attach = function ()
	if not tabline.config.condition then
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

	vim.g.__tabline = vim.o.tabline;
	vim.o.tabline = "%!v:lua.require('bars.tabline').render()";

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

--- Sets up the tabline module.
---@param config tabline.config | nil
tabline.setup = function (config)
	if type(config) == "table" then
		tabline.config = vim.tbl_extend("force", tabline.config, config);
	end

	tabline.update_id();
end

return tabline;
