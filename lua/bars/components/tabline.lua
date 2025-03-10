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
	local from = utils.clamp(vim.g.__bars_tabpage_from, 1, #tabs);
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
	local rendered_paths = {};

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
			utils.create_segmant(tab, tab_config.hl)
		});

		if type(tab_config.win_count) == "string" then
			local wins = vim.api.nvim_tabpage_list_wins(tab);

			_o = table.concat({
				_o,

				utils.create_segmant(tab_config.divider, tab_config.divider_hl),
				utils.create_segmant(
					string.format(tab_config.win_count, #wins),
					tab_config.win_count_hl
				),
			});
		end

		if type(tab_config.bufname) == "string" then
			---@type integer
			local winnr = vim.fn.tabpagewinnr(tab);
			local winid = vim.fn.win_getid(winnr);

			local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winid))
			local path;

			if bufname == "" then
				path = "No name";
			else
				path = utils.truncate_path(
					vim.fn.fnamemodify(bufname, ":~"),
					{
						existing_paths = rendered_paths,
					}
				);
				table.insert(rendered_paths, path);
			end

			_o = table.concat({
				_o,

				utils.create_segmant(tab_config.divider, tab_config.divider_hl),
				utils.create_segmant(
					string.format(tab_config.bufname, path),
					tab_config.bufname_hl
				),
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

--- Buffer list.
---@param config tabline.parts.bufs
---@return string
tlC.bufs = function (config)
	---|fS

	local function truncate_fname (fname, name_len)
		name_len = name_len or 15;

		if vim.fn.strchars(fname) <= name_len then
			return fname;
		else
			local truncate_symbol = config.truncate_symbol or "…";

			local ext  = vim.fn.fnamemodify(fname, ":e");
			local name = vim.fn.fnamemodify(fname, ":t:r");

			local available_len = name_len - vim.fn.strchars(ext .. truncate_symbol .. ".");

			return string.format(
				"%s%s%s%s",
				vim.fn.strcharpart(name, 0, math.max(available_len, 2)),
				truncate_symbol,
				ext ~= "" and "." or "",
				ext ~= "" and ext or ""
			);
		end
	end

	local bufs = utils.get_valid_bufs();
	local _o = "";

	if not vim.g.__bars_buf_from then
		vim.g.__bars_buf_from = 1;
	elseif vim.g.__bars_buf_from > #bufs then
		vim.g.__bars_buf_from = 1;
	end

	if not vim.g.__bars_tabpage_list_locked then
		vim.g.__bars_tabpage_list_locked = false;
	end

	---@type integer Start index. Must be above 0;
	local from = utils.clamp(vim.g.__bars_buf_from, 1, #bufs);
	---@type integer Number of bufs to show.
	local max = config.max or 5;
	---@type boolean Is the list position locked?
	local locked = vim.g.__bars_tabpage_list_locked;

	--- Maximum number of bufs to show.
	--- Stored to he used by `autocmds`.
	vim.g.__tabline_max_bufs = max;

	if from ~= 1 then
		if locked == true then
			_o = table.concat({
				_o,

				utils.create_segmant(config.nav_left_locked, config.nav_left_locked_hl),
			});
		else
			_o = table.concat({
				_o,

				"%@v:lua.__buf_from_decrease@",
				utils.create_segmant(config.nav_left, config.nav_left_hl),
				"%X"
			});
		end
	end

	local wrapped = false;

	for t = from, from + (max - 1), 1 do
		local buf_index = wrapped_index(#bufs, t);
		local buffer = bufs[buf_index];

		if t > #bufs then
			if buf_index == wrapped_index(#bufs, from) and wrapped == true then
				--- Do not wrap around multiple
				--- times.
				break;
			elseif from == 1 and #bufs < max then
				--- If we are showing bufs from
				--- the start and the number of 
				--- bufs are less than the amount
				--- we can show, then don't wrap.
				break;
			elseif buf_index == 1 then
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
		elseif buf_index ~= 1 then
			_o = table.concat({
				_o,
				utils.create_segmant(config.separator, config.separator_hl)
			});
		end

		local current = buffer == vim.api.nvim_get_current_buf();
		local buf_config = current == true and (config.active or {}) or (config.inactive or {});

		if current == false then
			utils.create_to_buf(buffer)
		end

		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":t");

		if name == "" then
			name = "New file";
		end

		if buf_config.ft_icon ~= false and package.loaded["icons"] then
			local icon_config = package.loaded["icons"].get(
				vim.fn.fnamemodify(name, ":e"),
				{
					buf_config.icon_hl, buf_config.icon,
					buf_config.icon_hl, buf_config.icon,
					buf_config.icon_hl, buf_config.icon,
				}
			);

			buf_config.icon = icon_config.icon;
			---@type string
			buf_config.icon_hl = buf_config.icon_hl or icon_config.hl;
		end

		_o = table.concat({
			_o,

			current == false and "%@v:lua.__tabline_to_buf.b" .. buffer .. "@" or "",

			utils.create_segmant(buf_config.corner_left, buf_config.corner_left_hl or buf_config.hl),
			utils.create_segmant(buf_config.padding_left, buf_config.padding_left_hl or buf_config.hl),

			utils.create_segmant(buf_config.icon, buf_config.icon_hl),
		});

		if type(buf_config.win_count) == "string" then
			local wins = vim.fn.win_findbuf(buffer);

			_o = table.concat({
				_o,

				utils.create_segmant(truncate_fname(name), buf_config.hl),
				utils.create_segmant(
					string.format(buf_config.win_count, #wins),
					buf_config.win_count_hl
				),
			});
		else
			_o = table.concat({
				_o,
				utils.create_segmant(truncate_fname(name, buf_config.max_name_len), buf_config.hl)
			});
		end

		_o = table.concat({
			_o,

			utils.create_segmant(buf_config.padding_right, buf_config.padding_right_hl or buf_config.hl),
			utils.create_segmant(buf_config.corner_right, buf_config.corner_right_hl or buf_config.hl),

			current == false and "%T" or ""
		});
	end

	if max < #bufs then
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

				"%@v:lua.__buf_from_increase@",
				utils.create_segmant(config.nav_right, config.nav_right_hl),
				"%X"
			});
		end
	end

	return _o;
	---|fE
end

--- Custom section
---@param config tabline.parts.custom
---@return string
tlC.custom = function (_, _, config)
	return config.value --[[ @as string ]];
end

----------------------------------------------------------------------

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
