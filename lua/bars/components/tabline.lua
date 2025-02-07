local tlC = {};
local utils = require("bars.utils");

--- Assuming the length of an array is
--- {max}, gets the relative index from
--- {val}.
---@param max integer
---@param val integer
---@return integer
local function wrapped_index (max, val)
	---+
	if val < 1 then
		if math.abs(val) < max then
			return max + val;
		else
			return 1;
		end
	elseif val > max then
		return (val % max) == 0 and max or (val % max);
	else
		return val;
	end
	---_
end

--- Empty section.
---@param config tabline.parts.empty
---@return string
tlC.empty = function (config)
	---|fS

	return table.concat({
		utils.set_hl(config.hl),
		"%="
	});

	---|fE
end

--- Tab list.
---@param config tabline.parts.tabs
---@return string
tlC.tabs = function (config)
	---|fS

	local tabs = vim.api.nvim_list_tabpages();
	local _o = "";

	if not vim.g.__bars_tabpage_from then
		vim.g.__bars_tabpage_from = 1;
	elseif vim.g.__bars_tabpage_from > #tabs then
		vim.g.__bars_tabpage_from = 1;
	end

	if not vim.g.__bars_tabpage_list_locked then
		vim.g.__bars_tabpage_list_locked = false;
	end

	---@type integer Start index. Must be above 0;
	local from = math.max(vim.g.__bars_tabpage_from, 1);
	---@type integer Number of tabs to show.
	local max = config.max or 5;
	---@type boolean Is the list position locked?
	local locked = vim.g.__bars_tabpage_list_locked;

	--- Maximum number of tabs to show.
	--- Stored to he used by `autocmds`.
	vim.g.__tabline_max_tabs = max;

	if from ~= 1 then
		if locked == true then
			_o = table.concat({
				_o,

				utils.create_segmant(config.nav_left_locked, config.nav_left_locked_hl),
			});
		else
			_o = table.concat({
				_o,

				"%@v:lua.__tab_from_decrease@",
				utils.create_segmant(config.nav_left, config.nav_left_hl),
				"%X"
			});
		end
	end

	local wrapped = false;

	for t = from, from + (max - 1), 1 do
		local tab_index = wrapped_index(#tabs, t);
		local tab = tabs[tab_index];

		if t > #tabs then
			if tab_index == wrapped_index(#tabs, from) and wrapped == true then
				--- Do not wrap around multiple
				--- times.
				break;
			elseif from == 1 and #tabs < max then
				--- If we are showing tabs from
				--- the start and the number of 
				--- tabs are less than the amount
				--- we can show, then don't wrap.
				break;
			elseif tab_index == 1 then
				--- Wrap marker should only be added
				--- to the 1st entry.
				wrapped = true;

				_o = table.concat({
					_o,
					utils.set_hl(config.overflow_hl),
					config.overflow or ""
				});
			else
				_o = table.concat({
					_o,
					utils.create_segmant(config.separator, config.separator_hl)
				});
			end
		elseif tab_index ~= 1 then
			_o = table.concat({
				_o,
				utils.create_segmant(config.separator, config.separator_hl)
			});
		end

		local current = tab == vim.api.nvim_get_current_tabpage();
		local tab_config = current == true and (config.active or {}) or (config.inactive or {});

		_o = table.concat({
			_o,

			current == false and "%" .. tab_index .. "T" or "",

			utils.create_segmant(tab_config.corner_left, tab_config.corner_left_hl or tab_config.hl),
			utils.create_segmant(tab_config.padding_left, tab_config.padding_left_hl or tab_config.hl),

			utils.create_segmant(tab_config.icon, tab_config.icon_hl),
		});

		if type(tab_config.win_count) == "string" then
			local wins = vim.api.nvim_tabpage_list_wins(tab);

			_o = table.concat({
				_o,

				utils.create_segmant(tab, tab_config.hl),
				utils.create_segmant(
					string.format(tab_config.win_count, #wins),
					tab_config.win_count_hl
				),
			});
		else
			_o = table.concat({
				_o,
				utils.create_segmant(tab, tab_config.hl)
			});
		end

		_o = table.concat({
			_o,

			utils.create_segmant(tab_config.padding_right, tab_config.padding_right_hl or tab_config.hl),
			utils.create_segmant(tab_config.corner_right, tab_config.corner_right_hl or tab_config.hl),

			current == false and "%T" or ""
		});
	end

	if max < #tabs then
		if locked == true then
			_o = table.concat({
				_o,

				utils.create_segmant(config.separator, config.separator_hl),
				utils.create_segmant(config.nav_right_locked, config.nav_right_locked_hl),
			});
		else
			_o = table.concat({
				_o,

				utils.create_segmant(config.separator, config.separator_hl),

				"%@v:lua.__tab_from_increase@",
				utils.create_segmant(config.nav_right, config.nav_right_hl),
				"%X"
			});
		end
	end

	return _o;
	---|fE
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
