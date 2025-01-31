local scC = {};
local utils = require("bars.utils");

local ffi = require("ffi");
local C = {
	"typedef struct {} Error;",
	"typedef struct {} win;",

	"typedef struct {",
	"    int start;",
	"    int level;",
	"    int llevel;",
	"    int lines;",
	"} foldinfo;",

	"win *find_window_by_handle(int window, Error *err);",
	"foldinfo fold_info(win* wp, int lnum);",
};

ffi.cdef(table.concat(C, "\n"));

--- Line number.
---@param buffer integer
---@param window integer
---@param config statuscolumn.lnum
---@return string
scC.lnum = function (buffer, window, config)
	---|fS

	local _o = "";

	local max_width = vim.fn.strdisplaywidth(
		tostring(vim.api.nvim_buf_line_count(buffer))
	);

	local function get (entry, index, ignore)
		if vim.islist(entry) then
			local current = vim.api.nvim_get_current_win() == window;
			local i = utils.clamp(index, 1, #entry);

			if ignore == true then
				return entry[i];
			elseif current == false then
				return entry[#entry];
			else
				return entry[i];
			end
		else
			return entry;
		end
	end

	if vim.v.virtnum ~= 0 then
		if vim.v.virtnum < 0 then
			_o = table.concat({
				_o,
				utils.set_hl(get(config.virt_hl, vim.v.relnum + math.abs(vim.v.virtnum))),
				utils.align(
					"right",
					get(config.virt_markers, vim.v.relnum + math.abs(vim.v.virtnum)),
					max_width
				)
			});
		else
			_o = table.concat({
				_o,
				utils.set_hl(get(config.wrap_hl, vim.v.relnum + vim.v.virtnum)),
				utils.align(
					"right",
					get(config.wrap_markers, vim.v.relnum + vim.v.virtnum),
					max_width
				)
			});
		end
	elseif config.mode == 1 then
		_o = _o
			.. utils.set_hl(get(config.hl, vim.v.relnum + 1))
			.. utils.align("right", vim.v.lnum, max_width)
		;
	elseif config.mode == 2 then
		_o = _o
			.. utils.set_hl(get(config.hl, vim.v.relnum + 1))
			.. utils.align("right", vim.v.relnum, max_width)
		;
	elseif vim.v.relnum == 0 then
		_o = _o
			.. utils.set_hl(get(config.hl, vim.v.relnum + 1, true))
			.. utils.align("right", vim.v.lnum, max_width)
		;
	else
		_o = _o
			.. utils.set_hl(get(config.hl, vim.v.relnum + 1))
			.. utils.align("right", vim.v.relnum, max_width)
		;
	end

	--- FEAT, Maybe Later.
	-- if config.click_support ~= false then
	-- end

	return _o;

	---|fE
end

--- Empty section
---@param config statuscolumn.empty
---@return string
scC.empty = function (_, _, config)
	return table.concat({
		utils.set_hl(config.hl),
		string.rep(" ", config.len or 1)
	});
end

--- Border.
---@param config statuscolumn.border
---@return string
scC.border = function (_, _, config)
	---|fS

	local function get (entry, index)
		if vim.islist(entry) then
			local i = utils.clamp(index, 1, #entry);
			return entry[i];
		else
			return entry;
		end
	end

	local hl = get(config.hl, vim.v.relnum);
	local text = get(config.text, vim.v.relnum);

	return table.concat({
		utils.set_hl(hl),
		text or ""
	});

	---|fE
end

--- Fold column.
---@param buffer integer
---@param window integer
---@param config statuscolumn.folds
---@return string
scC.folds = function (buffer, window, config)
	---|fS

	local function get (entry, index, ignore)
		if vim.islist(entry) then
			local current = vim.api.nvim_get_current_win() == window;
			local i = utils.clamp(index, 1, #entry);

			if ignore == true then
				return entry[i];
			elseif current == false then
				return entry[#entry];
			else
				return entry[i];
			end
		else
			return entry;
		end
	end

	---@type integer
	local window_handle = ffi.C.find_window_by_handle(window, nil);
	---@type integer
	local nlnum = math.min(vim.v.lnum + 1, vim.api.nvim_buf_line_count(buffer));

	---@class fold_info
	---
	---@field start integer Start of the fold.
	---@field level integer Level of the fold.
	---@field llevel integer Highest level inside the fold.
	---@field lines integer Number of lines a closed fold contains.
	local info = ffi.C.fold_info(window_handle, vim.v.lnum);
	---@type fold_info
	local Ninfo = ffi.C.fold_info(window_handle, nlnum);

	local closed_fold = false;

	vim.api.nvim_buf_call(buffer, function ()
		closed_fold = vim.fn.foldclosed(vim.v.lnum) ~= -1;
	end);

	local _o = "";

	if info.start == vim.v.lnum then
		--- Start of a fold.
		if closed_fold == true then
			--- Closed fold.
			_o = table.concat({
				_o,
				utils.set_hl(get(config.close_hl, info.level)),
				get(config.close_text, info.level) or ""
			});
		else
			--- Open fold.
			_o = table.concat({
				_o,
				utils.set_hl(get(config.open_hl, info.level)),
				get(config.open_text, info.level) or ""
			});
		end
	elseif info.start ~= Ninfo.start then
		--- Last line of a fold.
		if Ninfo.level == 0 then
			--- End of the fold.
			_o = table.concat({
				_o,
				utils.set_hl(get(config.scope_end_hl, info.level)),
				get(config.scope_end_text, info.level) or ""
			});
		elseif info.level == Ninfo.level then
			--- End of the fold.
			---
			--- Next line has a fold
			--- whose level is >=
			--- to this one.
			_o = table.concat({
				_o,
				utils.set_hl(get(config.scope_end_hl, info.level)),
				get(config.scope_end_text, info.level) or ""
			});
		elseif info.level > Ninfo.level then
			--- End of the fold.
			---
			--- Next line has a fold
			--- whose level is >=
			--- to this one.
			_o = table.concat({
				_o,
				utils.set_hl(get(config.scope_merge_hl, info.level)),
				get(config.scope_merge_text, info.level) or ""
			});
		elseif info.level > 0 then
			_o = table.concat({
				_o,
				utils.set_hl(get(config.scope_hl, info.level)),
				get(config.scope_text, info.level) or ""
			});
		else
			_o = table.concat({
				_o,
				utils.set_hl(config.fill_hl),
				config.fill_text or ""
			});
		end
	elseif info.level > 0 then
		_o = table.concat({
			_o,
			utils.set_hl(get(config.scope_hl, info.level)),
			get(config.scope_text, info.level) or ""
		});
	else
		_o = table.concat({
			_o,
			utils.set_hl(config.fill_hl),
			config.fill_text or ""
		});
	end

	 return _o;

	 ---|fE
end

--- Sign column.
---@param buffer integer
---@param _ integer
---@param config statuscolumn.signs
---@return string
scC.signs = function (buffer, _, config)
	---|fS

	if vim.v.virtnum ~= 0 then
		return utils.set_hl(config.hl) .. "  ";
	end

	local extmarks = vim.api.nvim_buf_get_extmarks(
		buffer,
		-1,
		{ vim.v.lnum - 1, 0 },
		{ vim.v.lnum - 1, -1 },
		{
			type = "sign",
			details = true
		}
	);

	---@type string
	local _o = "  ";
	local priority = -999;

	for _, sign in ipairs(extmarks) do
		local sPR = sign[4].priority or 0;

		if sPR > priority and sign[4].sign_text then
			_o = utils.set_hl(sign[4].sign_hl_group) .. utils.align("left", sign[4].sign_text, 2);
			priority = sPR;
		end
	end

	return _o;

	---|fE
end

--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param part_config table
---@param statuscolumn string
---@return string
scC.get = function (name, buffer, window, part_config, statuscolumn)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(scC[name]) ~= "function" then
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
		return scC[name](buffer, window, static_config, statuscolumn) or "";
	end

	---|fE
end

return scC;
