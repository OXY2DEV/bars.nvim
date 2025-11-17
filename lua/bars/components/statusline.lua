---@diagnostic disable: undefined-field

--- Gets icons & highlight groups for a given filetype.
---@param ft string
---@param icon_hls? string[]
---@return string icon
---@return string? highlight
local function get_icon (ft, icon_hls)
	---|fS

	local _ft = ft;

	if vim.filetype.match({ filename = string.format("example.%s", _ft) }) then
		_ft = vim.filetype.match({ filename = string.format("example.%s", _ft) }) or ft;
	end

	if package.loaded["nvim-web-devicons"] then
		local icon, hl = package.loaded["nvim-web-devicons"].get_icon_by_filetype(
			_ft,
			{ default = true }
		);

		return icon .. " ", hl;
	elseif package.loaded["mini.icons"] then
		--- Attempt to get icon from filetype directly.
		---@type string, string, boolean
		local ft_icon, ft_icon_hl, is_default = package.loaded["mini.icons"].get(
			"filetype",
			_ft
		);

		if is_default == true then
			--- There is no icon for the filetype.
			--- Attempt to get the icon from file path instead.

			ft_icon, ft_icon_hl = package.loaded["mini.icons"].get(
				"file",
				string.format("example.%s", ft)
			);
		end

		ft_icon = ft_icon .. " ";
		return ft_icon, ft_icon_hl;
	elseif package.loaded["icons"] then
		return package.loaded["icons"].get(ft, icon_hls);
	end

	return "", nil;

	---|fE
end

local slC = {};
local utils = require("bars.utils");

--- Shows current git branch.
---@param buffer integer
---@param window integer
---@param main_config statusline.components.branch
---@return string
slC.branch = function (buffer, window, main_config)
	---|fS

	local cwd;
	local ignore = { "default", "condition", "throttle", "kind" };

	vim.api.nvim_win_call(window, function ()
		cwd = vim.fn.getcwd(window);
	end);

	if type(cwd) ~= "string" then
		return "";
	end

	local branch;

	--- Gets the current git branch.
	---@return string
	local function get_branch ()
		---|fS

		if package.loaded["gitsigns"] and type(vim.b[buffer].gitsigns_head) == "string" then
			--[[
				NOTE: In case `gitsigns.nvim` is available, use their information instead.

				Getting the branch data may be expensive, so there should be no reason to do it multiple times.
				And `gitsigns.nvim` should handle Git-related stuff better than we do.

				See `:h b:gitsigns_head`.
			]]
			return vim.b[buffer].gitsigns_head;
		end

		--- Are we in a repo?
		---@type string
		local in_repo = vim.fn.system({
			"git",
			"-C",
			cwd,
			"rev-parse",
			"--is-inside-work-tree"
		});

		if not in_repo or string.match(in_repo, "^true") == nil then
			--- The output doesn't exist or it doesn't
			--- start with "true" then return.
			return "";
		end

		--- First check if we are inside
		--- a branch.
		---@type string | ""
		local _branch = vim.fn.system({
			"git",
			"-C",
			cwd,
			"branch",
			"--show-current"
		});

		if _branch == "" then
			--- We are not in a branch.
			--- Attempt to get commit hash(short).
			---@type string
			_branch = vim.fn.system({
				"git",
				"-C",
				cwd,
				"rev-parse",
				"--short",
				"HEAD"
			});
		end

		return _branch or "";

		---|fE
	end

	if not vim.w[window].bars_cached_git_branch then
		--- Cached branch name not found.
		--- Get current branch name.
		---@type string
		branch = vim.split(get_branch(), "\n", { trimempty = true });

		vim.w[window].bars_cached_git_branch = branch;
		vim.w[window].bars_cached_time_git = vim.uv.hrtime();
	else
		---@type infowhat
		local now = vim.uv.hrtime();
		---@type integer
		local bef = vim.w.bars_cached_time_git or 0;

		--- Branch value update delay.
		---@type integer
		local throttle = main_config.throttle or 2000;

		if now - bef >= (throttle * 1e6) then
			--- We have waited longer than `throttle`.
			---@type string
			branch = vim.split(get_branch(), "\n", { trimempty = true });

			--- Update cached value & update time.
			vim.w[window].bars_cached_git_branch = branch;
			vim.w[window].bars_cached_time_git = vim.uv.hrtime();
		else
			--- Not enough time has passed.
			--- Use cached value.
			branch = vim.w[window].bars_cached_git_branch;
		end
	end

	if not branch or vim.tbl_isempty(branch) then
		return "";
	elseif branch[1]:match("^fatal%:") then
		return "";
	elseif branch[1]:match("^error%:") then
		return "";
	else
		---@type branch.opts
		local config = utils.match(main_config, branch[1], ignore);

		return table.concat({
			utils.set_hl(config.hl),

			string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
			string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),
			string.format("%s%s", utils.set_hl(config.icon_hl), config.icon or ""),

			config.text or branch[1] or "",

			string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
			string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or "")
		});
	end

	---|fE
end

--- Shows the buffer name.
---@param buffer integer
---@param _ integer
---@param main_config statusline.components.bufname
slC.bufname = function (buffer, _, main_config)
	---|fS

	local ignore = { "default", "condition", "max_len", "kind" };

	---@type string Full buffer name.
	local bufname = vim.api.nvim_buf_get_name(buffer);
	---@type bufname.opts
	local config = main_config.default or {};

	local function truncate_fname (fname)
		local name_len = main_config.max_len or 15;

		if vim.fn.strchars(fname) <= name_len then
			return fname;
		else
			local truncate_symbol = main_config.truncate_symbol or "…";

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

	if bufname == "" then
		--- Empty buffer.

		config = utils.match(main_config, "", ignore);
	elseif bufname:match("^term%:%/%/") then
		--- Terminal PID & Shell path
		---@type string, string
		local pid, shell = bufname:match("^term%:%/%/.-%/(%d+)%:(.+)$");
		---@type string Shell name
		local shell_name = vim.fn.fnamemodify(shell, ":t");
		config.text = config.text or string.format("%s[%s]", shell_name, pid);

		config = utils.match(main_config, shell_name, ignore);
	else
		local tail = vim.fn.fnamemodify(bufname, ":t");
		local modifiable = vim.bo[buffer].modifiable;

		local icon_hls;

		if vim.islist(config.icon_hl) then
			icon_hls = config.icon_hl;
			config.icon_hl = nil;
		end

		config = utils.match(main_config, tail, ignore);

		config.text = config.text or truncate_fname(tail);

		--- We don't use if...else because we might only change
		--- the highlight group for the nomodifiable files.
		if modifiable == false and (config.nomodifiable_icon or config.nomodifiable_icon_hl) then
			config.icon = config.nomodifiable_icon or config.icon;
			config.icon_hl = config.nomodifiable_icon_hl or config.icon_hl;
		end

		if config.icon == "" then
			local icon, hl = get_icon(
				vim.fn.fnamemodify(tail, ":e"),
				icon_hls
			);

			config.icon = icon;
			---@type string
			config.icon_hl = config.icon_hl or hl;
		end
	end

	return table.concat({
		utils.set_hl(config.hl or config.icon_hl),

		string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),
		string.format("%s%s", utils.set_hl(config.icon_hl), config.icon or ""),

		string.format("%s", config.text or ""),

		string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or ""),
	});

	---|fE
end

--- Diagnostics section
---@param buffer integer
---@param window integer
---@param config statusline.components.diagnostics
---@return string
slC.diagnostics = function (buffer, window, config)
	---|fS

	config = config or {};

	local diagnostics_count = vim.diagnostic.count(buffer);
	---@diagnostic disable-next-line: deprecated
	local clients = vim.fn.has("nvim-0.11") == 1 and vim.lsp.get_clients({ bufnr = buffer }) or vim.lsp.buf_get_clients(buffer);

	if (#clients == 0 or vim.tbl_isempty(diagnostics_count)) and config.auto_hide == true then
		-- No diagnostics clients or no count available.
		return "";
	end

	---@type
	---| 1 Errors
	---| 2 Warning
	---| 3 Info
	---| 4 Hint
	---| 5 All
	local mode = 5;

	if type(vim.w[window].bars_diagnostic_state) ~= "number" then
		-- NOTE: Default should show all diagnostic types.

		mode = config.default_mode or 5;
		vim.w[window].bars_diagnostic_state = config.default_mode or 5;
	else
		mode = vim.w[window].bars_diagnostic_state;
	end

	local _d = "";
	local severity = vim.diagnostic.severity;

	local types = {
		[1] = {
			utils.set_hl(config.error_hl),
			config.error_icon or "",
			diagnostics_count[severity.ERROR] or "0"
		},
		[2] = {
			utils.set_hl(config.warn_hl),
			config.warn_icon or "",
			diagnostics_count[severity.WARN] or "0"
		},
		[3] = {
			utils.set_hl(config.info_hl),
			config.info_icon or "",
			diagnostics_count[severity.INFO] or "0"
		},
		[4] = {
			utils.set_hl(config.hint_hl),
			config.hint_icon or "",
			diagnostics_count[severity.HINT] or "0"
		},
	};

	if type(mode) == "number" and mode < 5 then
		_d = table.concat(types[mode] or {});
	elseif vim.tbl_isempty(diagnostics_count) then
		_d = table.concat({
			utils.set_hl(config.empty_hl),
			config.empty_icon or "",
			config.empty_text or ""
		});
	elseif config.compact then
		local _k = 0;
		local _m = #vim.tbl_keys(diagnostics_count);

		for _, v in pairs(types) do
			if v[3] ~= "0" then
				_k = _k + 1;
				_d = _d .. table.concat(v);

				if _k < _m then
					_d = _d .. utils.set_hl(config.separator_hl) .. (config.separator or " | ");
				end
			end
		end
	else
		local _k = 0;

		for _, v in pairs(types) do
			_k = _k + 1;
			_d = _d .. table.concat(v);

			if _k < 4 then
				_d = _d .. utils.set_hl(config.separator_hl) .. (config.separator or " | ");
			end
		end
	end

	return table.concat({
		"%@v:lua.bars_change_diagnostic_state@",
		utils.set_hl(config.hl),

		string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),

		_d or "",

		string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or ""),

		"%X"
	});

	---|fE
end

--- Empty section.
---@param config statusline.components.empty
---@return string
slC.empty = function (_, _, config)
	return utils.set_hl(config.hl) .. "%=";
end

--- Shows current mode.
---@param main_config statusline.components.mode
---@return string
slC.mode = function (_, _, main_config)
	---|fS

	local ignore = { "default", "min_width", "kind", "condition", "kind" };

	---@type string Current mode shorthand.
	local mode = vim.api.nvim_get_mode().mode;
	---@type mode.opts
	local config = utils.match(main_config, mode, ignore);

	if main_config.compact then
		return table.concat({
			utils.set_hl(config.hl),

			string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
			string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),

			string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
			string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or ""),
		});
	else
		return table.concat({
			utils.set_hl(config.hl),

			string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
			string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),
			string.format("%s%s", utils.set_hl(config.icon_hl), config.icon or ""),

			string.format("%s", config.text or mode or ""),

			string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
			string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or ""),
		});
	end

	---|fE
end

--- Custom section.
---@param config statusline.components.section
---@return string
slC.section = function (_, _, config, _)
	---|fS

	return table.concat({
		config.click and string.format("%@%s@", config.click) or "",
		utils.set_hl(config.hl),

		string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),
		string.format("%s%s", utils.set_hl(config.icon_hl), config.icon or ""),

		string.format("%s%s", utils.set_hl(config.hl), config.text or ""),

		string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or ""),

		config.click and "%X" or "",
	});

	---|fE
end

--- Ruler.
---@param _ integer
---@param window integer
---@param main_config statusline.components.ruler
---@return string
slC.ruler = function (_, window, main_config)
	---|fS

	---@type ruler.opts
	local config;
	local x, y;

	if main_config.mode == "visual" then
		vim.api.nvim_win_call(window, function ()
			local f, t = vim.fn.getpos("v"), vim.fn.getpos(".");

			x = math.abs(f[2] - t[2]);
			y = math.abs(f[3] - t[3]);
		end)

		config = utils.match(main_config, "visual", {}) or {};
	else
		vim.api.nvim_win_call(window, function ()
			local c = vim.fn.getpos(".");
			x, y = c[2], c[3];
		end)

		config = utils.match(main_config, "default", {}) or {};
	end

	return table.concat({
		utils.set_hl(config.hl),

		string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),
		string.format("%s%s", utils.set_hl(config.icon_hl), config.icon or ""),

		string.format("%s%s%s", x, config.separator or "", y),

		string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or "")
	});

	---|fE
end

--- Macro recording & executing.
---@param config statusline.components.macro
---@return string
slC.macro = function (_, _, config)
	---|fS

	local rec = vim.fn.reg_recording();
	local exe = vim.fn.reg_executing();

	if rec ~= "" then
		return string.format("%s%s%s", utils.set_hl(config.record_hl), config.record_icon or "", rec);
	elseif exe ~= "" then
		return string.format("%s%s%s", utils.set_hl(config.exec_hl), config.exec_icon or "", exe);
	else
		return "";
	end

	---|fE
end

--- Ruler.
---@param buffer integer
---@param window integer
---@param config statusline.components.progress
---@return string?
slC.progress = function (buffer, window, config)
	---|fS

	---@type "start" | "progress" | "finish", "buffer" | "window"
	local state, src;
	local state_var = config.check or "progress_state";

	if vim.w[window][state_var] then
		state = vim.w[window][state_var];
		src = "window";
	elseif vim.b[buffer][state_var] then
		state = vim.b[buffer][state_var];
		src = "buffer";
	else
		return;
	end

	---@type
	---| "buffer"
	---| "finish"
	---| "progress"
	---| "start"
	---| "window"
	local last_frame = src == "buffer" and
		vim.b[buffer].bars_loader_last_frame or
		vim.w[window].bars_loader_last_frame
	;
	last_frame = last_frame or 1;

	---@type integer
	local last_tick = src == "buffer" and
		vim.b[buffer].bars_loader_last_tick or
		vim.w[window].bars_loader_last_tick
	;
	local now = vim.uv.hrtime() / 1e6; ---@diagnostic disable-line

	--- Gets progress-bar state
	---@param from? string[]
	---@return string?
	local function get_state (from)
		---|fS

		if not from or not vim.islist(from) then
			return;
		end

		return from[last_frame] or from[#from] or "";

		---|fE
	end

	--- Updates frame count.
	---@param max integer
	local function update_frame (max)
		---|fS

		if last_tick and now - last_tick < (config.update_delay or 250) then
			-- Not enough time has passed.
			return;
		end

		if src == "buffer" then
			vim.b[buffer].bars_loader_last_tick = now;
			vim.b[buffer].bars_loader_last_frame = last_frame + 1 > max and 1 or last_frame + 1;
		else
			vim.w[window].bars_loader_last_tick = now;
			vim.w[window].bars_loader_last_frame = last_frame + 1 > max and 1 or last_frame + 1;
		end

		---|fE
	end

	local text, hl;

	if state == "start" and config.start then
		text = config.start;
		hl = config.start_hl;

		update_frame(1);
	elseif state == "progress" then
		text = get_state(config.progress);
		hl = get_state(config.progress_hl);

		update_frame(
			vim.islist(config.progress) and #config.progress or 1
		);
	else
		text = config.finish;
		hl = config.finish_hl;

		update_frame(1);
	end

	local output = text or "";

	if type(hl) == "string" then
		output = string.format("%%#%s#", hl) .. output;
	end

	return output;

	---|fE
end

--- Custom section.
---@param config statusline.components.custom
---@return string
slC.custom = function (_, _, config)
	return config.value --[[ @as string ]];
end

-----------------------------------------------------------------------------

--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param component_config table
---@param statusline string
---@return string
slC.get = function (name, buffer, window, component_config, statusline)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(slC[name]) ~= "function" then
		--- Not a valid component.
		return "";
	else
		if component_config.condition ~= nil then
			if component_config.condition == false then
				--- Component is disabled.
				return "";
			else
				local sucess, val = pcall(component_config.condition, buffer, window, statusline);

				if sucess == false then
					return "";
				elseif val == false then
					return "";
				end
			end
		end

		local static_config = vim.deepcopy(component_config);

		for key, value in pairs(static_config) do
			if type(value) ~= "function" then
				goto continue;
			end

			local s_success, s_val = pcall(value, buffer, window, statusline);

			if s_success == false then
				static_config[key] = nil;
			else
				static_config[key] = s_val;
			end

			::continue::
		end

		--- Return component value.
		return slC[name](buffer, window, static_config, statusline) or "";
	end

	---|fE
end

return slC;
