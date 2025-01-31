local swC = {};
local utils = require("bars.utils");

--- Node under cursor
---@param buffer integer
---@param window integer
---@param main_config winbar.node
---@return string
swC.node = function (buffer, window, main_config)
	local check_parsers, parsers = pcall(vim.treesitter.get_parser, buffer);

	if check_parsers == false then
		return "";
	elseif parsers == nil then
		return "";
	end

	local ft = vim.bo[buffer].ft;
	local throttle = main_config.throttle or 50;

	local before = vim.w[window].__node_time or 0;
	local old = vim.w[window].__node_data;
	local now = vim.uv.hrtime();

	if old and (now - before) < (throttle * 1e6) then
		return old;
	end

	local cursor = vim.api.nvim_win_get_cursor(window);
	local node = vim.treesitter.get_node({
		buffer = buffer,
		pos = { cursor[1] - 1, cursor[2] },

		ignore_injections = false;
	});

	local lang_config = utils.match(main_config, ft, {});

	local lookup = main_config.lookup or 9;
	local _o = "";

	while node do
		if lookup <= 0 then
			break;
		end

		local item_config = utils.match(lang_config, node:type(), {});
		local has_sep = true;

		if lookup == 1 then
			has_sep = false;
		elseif not node:parent() then
			has_sep = false;
		end

		if item_config.ignore == true then
			goto ignore;
		end

		_o = table.concat({
			has_sep == true and utils.set_hl(main_config.separator_hl) or "",
			has_sep == true and (main_config.separator or " > ") or "",

			utils.set_hl(item_config.corner_left_hl or item_config.hl),
			item_config.corner_left or "",

			utils.set_hl(item_config.padding_left_hl or item_config.hl),
			item_config.padding_left or "",

			utils.set_hl(item_config.icon_hl or item_config.hl),
			item_config.icon or "",

			utils.set_hl(item_config.hl),
			item_config.text or node:type() or "",

			utils.set_hl(item_config.padding_right_hl or item_config.hl),
			item_config.padding_right or "",

			utils.set_hl(item_config.corner_right_hl or item_config.hl),
			item_config.corner_right or "",

			_o,
		});
		lookup = lookup - 1;

		::ignore::

		node = node:parent();
	end

	if lookup <= 0 and node then
		local item_config = utils.match(lang_config, "__lookup", {});

		_o = table.concat({

			utils.set_hl(item_config.corner_left_hl or item_config.hl),
			item_config.corner_left or "",

			utils.set_hl(item_config.padding_left_hl or item_config.hl),
			item_config.padding_left or "",

			utils.set_hl(item_config.icon_hl or item_config.hl),
			item_config.icon or "",

			utils.set_hl(item_config.hl),
			item_config.text or "",

			utils.set_hl(item_config.padding_right_hl or item_config.hl),
			item_config.padding_right or "",

			utils.set_hl(item_config.corner_right_hl or item_config.hl),
			item_config.corner_right or "",

			utils.set_hl(main_config.separator_hl) or "",
			main_config.separator or " > ",

			_o,
		});
	end

	if type(main_config.max_width) == "number" then
		_o = table.concat({
			"%",
			0,
			".",
			main_config.max_width,
			"(",
			" ",
			_o,
			"%)"
		});
	else
		_o = " " .. _o;
	end

	vim.w[window].__node_data = _o;
	vim.w[window].__node_time = now;

	return _o;
end

--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param part_config table
---@param statuscolumn string
---@return string
swC.get = function (name, buffer, window, part_config, statuscolumn)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(swC[name]) ~= "function" then
		--- Attempting to get internal property.
		return "";
	else
		if part_config.condition ~= nil then
			if part_config.condition == false then
				--- Part is disabled.
				return "";
			else
				local sucess, val = pcall(part_config.condition, buffer, window, statuscolumn);

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

			local s_success, s_val = pcall(value, buffer, window, statuscolumn);

			if s_success == false then
				static_config[key] = nil;
			else
				static_config[key] = s_val;
			end

			::continue::
		end

		--- Return component value.
		return swC[name](buffer, window, static_config, statuscolumn) or "";
	end

	---|fE
end

return swC
