local slC = {};
local utils = require("bars.utils");

--- Shows current mode.
---@param _ integer Buffer ID.
---@param window integer Window ID.
---@param main_config statusline.parts.mode
---@return string
slC.mode = function (_, window, main_config)
	---|fS

	local ignore = { "default", "min_width", "kind", "condition", "kind" };

	---@type string Current mode shorthand.
	local mode = vim.api.nvim_get_mode().mode;
	local config = utils.match(main_config, mode, ignore);

	local min_width = main_config.min_width or 42;

	local w = vim.api.nvim_win_get_width(window)

	if window ~= vim.api.nvim_get_current_win() or w <= min_width then
		return table.concat({
			string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
			string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),

			string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
			string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or ""),
		});
	else
		return table.concat({
			string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
			string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),
			string.format("%s%s", utils.set_hl(config.icon_hl         or config.hl), config.icon         or ""),

			string.format("%s%s", utils.set_hl(config.hl), config.text or mode or ""),

			string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
			string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or ""),
		});
	end

	---|fE
end

--- New section.
---@param config statusline.parts.section Configuration.
---@return string
slC.section = function (_, _, config, _)
	---|fS

	return table.concat({
		string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),
		string.format("%s%s", utils.set_hl(config.icon_hl         or config.hl), config.icon         or ""),

		string.format("%s%s", utils.set_hl(config.hl), config.text or ""),

		string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or ""),
	});

	---|fE
end

--- Shows the buffer name.
---@param buffer any
---@param _ any
---@param main_config statusline.parts.bufname
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
			local truncate_symbol = main_config.truncate_symbol or ">";

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

		if config.icon == "" and pcall(require, "icons") then
			local icon_config = require("icons").get(
				vim.fn.fnamemodify(tail, ":e"),
				icon_hls
			);

			config.icon = icon_config.icon;
			---@type string
			config.icon_hl = config.icon_hl or icon_config.hl;
		end
	end

	return table.concat({
		string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),
		string.format("%s%s", utils.set_hl(config.icon_hl         or config.hl), config.icon         or ""),

		string.format("%s%s", utils.set_hl(config.hl), config.text or ""),

		string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or ""),
	});

	---|fE
end

--- Empty section.
---@param config statusline.parts.empty
---@return string
slC.empty = function (_, _, config)
	return utils.set_hl(config.hl) .. "%=";
end

--- Diagnostics section
---@param buffer integer
---@param window integer
---@param config statusline.parts.diagnostics
---@return string
slC.diagnostics = function (buffer, window, config)
	---|fS

	config = config or {};

	local diagnostics_count = vim.diagnostic.count(buffer);
	local clients = vim.lsp.buf_get_clients(buffer);

	if #clients == 0 and config.auto_hide == true then
		return "";
	end

	if not diagnostics_count then
		return "";
	end

	---@type
	---| 1 Errors
	---| 2 Warning
	---| 3 Info
	---| 4 Hint
	---| 5 All
	local mode;

	if type(vim.w[window].__slDiagnostic_mode) ~= "number" then
		mode = config.default_mode or 1;
		vim.w[window].__slDiagnostic_mode = config.default_mode or 1;
	else
		mode = vim.w[window].__slDiagnostic_mode;
	end

	local _d;
	local severity = vim.diagnostic.severity;

	if mode == 1 then
		_d = table.concat({
			utils.set_hl(config.error_hl),
			config.error_icon or "",
			diagnostics_count[severity.ERROR] or "0"
		});
	elseif mode == 2 then
		_d = table.concat({
			utils.set_hl(config.warn_hl),
			config.warn_icon or "",
			diagnostics_count[severity.WARN] or "0"
		});
	elseif mode == 3 then
		_d = table.concat({
			utils.set_hl(config.info_hl),
			config.info_icon or "",
			diagnostics_count[severity.INFO] or "0"
		});
	elseif mode == 4 then
		_d = table.concat({
			utils.set_hl(config.hint_hl),
			config.hint_icon or "",
			diagnostics_count[severity.HINT] or "0"
		});
	else
		if vim.tbl_isempty(diagnostics_count) then
			_d = table.concat({
				utils.set_hl(config.empty_hl),
				config.empty_icon or "",
				config.empty_text or ""
			});
		else
			_d = table.concat({
				utils.set_hl(config.error_hl),
				config.error_icon or "",
				diagnostics_count[severity.ERROR] or "0",

				utils.set_hl(config.separator_hl),
				config.separator or " | ",

				utils.set_hl(config.warn_hl),
				config.warn_icon or "",
				diagnostics_count[severity.WARN] or "0",

				utils.set_hl(config.separator_hl),
				config.separator or " | ",

				utils.set_hl(config.info_hl),
				config.info_icon or "",
				diagnostics_count[severity.INFO] or "0",

				utils.set_hl(config.separator_hl),
				config.separator or " | ",

				utils.set_hl(config.hint_hl),
				config.hint_icon or "",
				diagnostics_count[severity.HINT] or "0"
			});
		end
	end

	return table.concat({
		"%@v:lua.__change_diagnostic_state@",

		string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),

		_d or "",

		string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or ""),

		"%X"
	});

	---|fE
end

--- Shows current git branch.
---@param _ any
---@param window any
---@param main_config statusline.parts.branch
---@return string
slC.branch = function (_, window, main_config)
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

	if not vim.w[window].__git_branch then
		branch = vim.split(vim.fn.system({
			"git",
			"-C",
			cwd,
			"branch",
			"--show-current"
		}), "\n", { trimempty = true });

		vim.w[window].__git_branch = branch;
		vim.w[window].__branch_time = vim.uv.hrtime();
	else
		local now = vim.uv.hrtime();
		local bef = vim.w.__branch_time or 0;

		local throttle = main_config.throttle or 2000;

		if now - bef >= (throttle * 1e6) then
			branch = vim.split(vim.fn.system({
				"git",
				"-C",
				cwd,
				"branch",
				"--show-current"
			}), "\n", { trimempty = true });

			vim.w[window].__git_branch = branch;
			vim.w[window].__branch_time = vim.uv.hrtime();
		else
			branch = vim.w[window].__git_branch;
		end
	end

	if branch[1]:match("^fatal%:") then
		return "";
	elseif branch[1]:match("^error%:") then
		return "";
	else
		local config = utils.match(main_config, branch[1], ignore);

		return table.concat({
			string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
			string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),
			string.format("%s%s", utils.set_hl(config.icon_hl         or config.hl), config.icon or ""),

			config.text or branch[1] or "",

			string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
			string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or "")
		});
	end

	---|fE
end

--- Custom ruler
---@param _ integer
---@param window integer
---@param main_config statusline.parts.ruler
---@return string
slC.ruler = function (_, window, main_config)
	---|fS

	local mode = vim.api.nvim_get_mode().mode;

	---@type ruler.opts
	local config;
	local x, y;

	if vim.list_contains({ "v", "V", "" }, mode) then
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
		string.format("%s%s", utils.set_hl(config.corner_left_hl  or config.hl), config.corner_left  or ""),
		string.format("%s%s", utils.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),
		string.format("%s%s", utils.set_hl(config.icon_hl         or config.hl), config.icon or ""),

		string.format("%s%s%s", x, config.separator or "", y),

		string.format("%s%s", utils.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
		string.format("%s%s", utils.set_hl(config.corner_right_hl  or config.hl), config.corner_right  or "")
	});

	---|fE
end

--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param part_config table
---@param statusline string
---@return string
slC.get = function (name, buffer, window, part_config, statusline)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(slC[name]) ~= "function" then
		--- Attempting to get internal property.
		return "";
	else
		if part_config.condition ~= nil then
			if part_config.condition == false then
				--- Part is disabled.
				return "";
			else
				local sucess, val = pcall(part_config.condition, buffer, window, statusline);

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
