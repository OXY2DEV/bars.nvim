--- Custom statusline module.
local statusline = {};

--- Custom statusline.
---@type string
local STL = "%!v:lua.require('bars.statusline').render()";

---@type table<string, statusline_component>
local TEMPLATES = {
	mode = {
		---|fS "Mode configuration"

		kind = "mode",

		compact = function (_, window)
			if window ~= vim.api.nvim_get_current_win() then
				return true;
			else
				return vim.api.nvim_win_get_width(window) < math.ceil(vim.o.columns * 0.5);
			end
		end,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "BarsNormal",
		},

		["^n"] = { text = "Normal" },

		["^t"] = { text = "Terminal" },

		["^v$"] = {
			icon = "󰸿 ",
			text = "Visual",

			hl = "BarsVisual",
		},
		["^V$"]    = {
			icon = "󰹀 ",
			text = "Visual",

			hl = "BarsVisualLine",
		},
		["^$"]   = {
			icon = "󰸽 ",
			text = "Visual",

			hl = "BarsVisualBlock",
		},

		["^s$"]    = {
			icon = "󰕠 ",
			text = "Select",

			hl = "BarsVisual",
		},
		["^S$"]    = {
			icon = "󰕞 ",
			text = "Select",

			hl = "BarsVisualLine",
		},
		["^$"]   = {
			icon = " ",
			text = "Select",

			hl = "BarsVisualBlock",
		},

		["^i$"]    = {
			icon = " ",
			text = "Insert",

			hl = "BarsInsert",
		},
		["^ic$"]   = {
			icon = " ",
			text = "Completion",

			hl = "BarsInsert",
		},
		["^ix$"]   = {
			text = "Inser8",

			hl = "BarsInsert",
		},

		["^R$"]    = {
			icon = " ",
			text = "Replace",

			hl = "BarsInsert",
		},
		["^Rc$"]   = {
			icon = " ",
			text = "Completion",

			hl = "BarsInsert",
		},

		["^c"]    = {
			icon = " ",
			text = "Command",

			hl = "BarsCommand",
		},

		["^r"] = { text = "Prompt" },

		["^%!"] = {
			icon = " ",
			text = "Shell",

			hl = "BarsCommand"
		},

		---|fE
	},
	bufname = {
		kind = "bufname",
		condition = function (_, win)
			return vim.api.nvim_win_get_width(win) >= 42;
		end,

		max_len = 25,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "",
			nomodifiable_icon_hl = "BarsFt1",
			nomodifiable_icon = "󰌾 ",
			icon_hl = {
				"BarsFt0", "BarsFt1", "BarsFt2", "BarsFt3", "BarsFt4", "BarsFt5", "BarsFt6"
			},

			hl = "BarsFt"
		},

		["^$"] = {
			icon = "󰂵 ",
			text = "New file",

			hl = "BarsFt"
		},

		["^fish"] = {
			icon = "󰐂 ",
		},
	}
};

---@type statusline.config
statusline.config = {
	ignore_filetypes = {},
	ignore_buftypes = {},

	default = {
		---|fS "Default configuration"

		components = {
			TEMPLATES.mode,
			{ kind = "section", hl = "Normal" },
			TEMPLATES.bufname,
			{ kind = "section", hl = "Normal" },
			{
				kind = "diagnostics",
				default_mode = 5,

				padding_left = " ",
				padding_right = " ",

				empty_icon = "󰂓 ",
				empty_hl = "Comment",

				error_icon = "󰅙 ",
				error_hl = "DiagnosticError",

				warn_icon = "󰀦 ",
				warn_hl = "DiagnosticWarn",

				hint_icon = "󰁨 ",
				hint_hl = "DiagnosticHint",

				info_icon = "󰁤 ",
				info_hl = "DiagnosticInfo"

			},
			{
				kind = "macro",

				record_icon = "󰦚 ",
				exec_icon = "󰥠 "
			},
			{ kind = "empty", hl = "Normal" },
			{
				kind = "branch",
				condition = function (_, win)
					return win == vim.api.nvim_get_current_win();
				end,

				default = {
					padding_left = " ",
					padding_right = " ",
					icon = "󰊢 ",

					hl = "BarsGit"
				}
			},
			{
				kind = "ruler",
				mode = function ()
					local mode = vim.api.nvim_get_mode().mode;
					local visual_modes = { "v", "V", "" };

					return vim.list_contains(visual_modes, mode) and "visual" or "normal";
				end,

				default = {
					padding_left = " ",
					padding_right = " ",
					icon = " ",

					separator = "  ",

					hl = "BarsRuler"
				},

				visual = {
					icon = " ",

					hl = "BarsRulerVisual"
				}
			}
		}

		---|fE
	},
	["help"] = {
		---|fS "Help statusline"

		condition = function (buffer)
			return vim.bo[buffer].buftype == "help";
		end,
		components = {
			{ kind = "empty", hl = "Normal" },
			TEMPLATES.mode,
			{
				kind = "ruler",
				condition = function ()
					local mode = vim.api.nvim_get_mode().mode;
					local visual_modes = { "v", "V", "" };

					return vim.list_contains(visual_modes, mode);
				end,

				default = {
					padding_left = " ",
					padding_right = " ",
					icon = " ",

					separator = "  ",

					hl = "BarsRuler"
				},

				visual = {
					icon = " ",

					hl = "Color6R"
				}
			},
			TEMPLATES.bufname,
			{ kind = "empty", hl = "Normal" },
		}

		---|fE
	}
};

---@type statusline.state
statusline.state = {
	enable = true,
	attached_windows = {}
};

--- Updates the configuration ID for {window}.
---@param window integer
---@return string | nil
statusline.update_id = function (window)
	---|fS

	if type(window) ~= "number" then
		return;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local buffer = vim.api.nvim_win_get_buf(window);

	local keys = vim.tbl_keys(statusline.config);
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	local ID = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(statusline.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = statusline.config[key];

		if tmp.condition == true then
			ID = key;
		elseif pcall(tmp.condition --[[ @as function ]], buffer, window) and tmp.condition(buffer, window) == true  then
			ID = key;
		end

		::continue::
	end

	vim.w[window].__slID = ID;
	statusline.state.attached_windows[window] = true;

	---|fE
end

--- Renders the statusline for a window.
---@return string
statusline.render = function ()
	---|fS

	local components = require("bars.components.statusline");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	local slID = vim.w[window].__slID;

	if not slID then
		return "";
	end

	local config = statusline.config[slID];

	if type(config) ~= "table" then
		return "";
	end

	local _o = "";

	for _, component in ipairs(config.components or {}) do
		_o = _o .. components.get(component.kind, buffer, window, component, _o);
	end

	return _o;

	---|fE
end

--- Can we detach from {win}?
---@param win integer
---@return boolean
statusline.can_detach = function (win)
	---|fS

	if vim.api.nvim_win_is_valid(win) == false then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if vim.list_contains(statusline.config.ignore_filetypes, ft) then
		return true;
	elseif vim.list_contains(statusline.config.ignore_buftypes, bt) then
		return true;
	else
		if not statusline.config.condition then
			return false;
		end

		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(statusline.config.condition, buffer, win);

		if ran_cond == true and stat == false then
			return true;
		else
			return false;
		end
	end

	---|fE
end

--- Detaches from {buffer}.
---@param window integer
statusline.detach = function (window)
	---|fS

	vim.schedule(function ()
		if not window or vim.api.nvim_win_is_valid(window) == false then
			return;
		end

		vim.w[window].__slID = nil;

		--- Cached statusline.
		---@type string | nil
		local _sl = vim.w[window].__statusline or vim.g.__statusline or "";

		if _sl == "" or _sl == nil then
			--- Reset statusline.
			vim.api.nvim_win_call(window, function ()
				vim.cmd("set statusline&");
			end);
		else
			vim.api.nvim_set_option_value(
				"statusline",
				_sl,
				{
					scope = "local",
					win = window
				}
			);
		end

		statusline.state.attached_windows[window] = false;

		if _sl == "" or _sl == nil then
			--- BUG, `set statusline&` resets the statusline
			--- globally.
			---
			--- So, we reattach to all the other windows.
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				statusline.attach(win);
			end
		end
	end);

	---|fE
end

--- Can we attach to {win}?
---@param win integer
---@param force boolean Forcefully attach window whose state is `false`.
---@return boolean
statusline.can_attach = function (win, force)
	---|fS

	if type(win) ~= "number" or vim.api.nvim_win_is_valid(win) == false then
		return false;
	elseif force ~= true and statusline.state.attached_windows[win] == false then
		return false;
	elseif statusline.state.enable == false then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if vim.list_contains(statusline.config.ignore_filetypes, ft) then
		return false;
	elseif vim.list_contains(statusline.config.ignore_buftypes, bt) then
		return false;
	else
		if not statusline.config.condition then
			return true;
		end

		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(statusline.config.condition, buffer, win);

		if ran_cond == false or stat == false then
			return false;
		else
			return true;
		end
	end

	---|fE
end

--- Attaches the statusline module to the windows
--- of a buffer.
---@param window integer
---@param force? boolean
statusline.attach = function (window, force)
	---|fS

	if statusline.can_attach(window, force) == false then
		return;
	elseif statusline.state.attached_windows[window] == true then
		if vim.wo[window].statusline == STL then
			statusline.update_id(window);
			return;
		end
	end

	statusline.update_id(window);

	--- Do NOT cache if previous statusline 
	--- is the same as the custom statusline.
	vim.w[window].__statusline = vim.wo[window].statusline == STL and "" or vim.wo[window].statusline;

	vim.wo[window].statusline = STL;

	---|fE
end

--- Attaches globally.
statusline.global_attach = function ()
	---|fS

	if statusline.state.enable == false then
		return;
	elseif statusline.config.condition then
		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(statusline.config.condition, vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win());

		if ran_cond == false or stat == false then
			return;
		end
	end

	for _, window in ipairs(vim.api.nvim_list_wins()) do
		statusline.update_id(window);
	end

	vim.g.__statusline = vim.o.statusline == STL and "" or vim.o.statusline;
	vim.o.statusline = STL;

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
statusline.clean = function ()
	---|fS

	vim.schedule(function ()
		for window, _ in pairs(statusline.state.attached_windows) do
			if statusline.can_detach(window) then
				statusline.detach(window);
			end
		end
	end);

	---|fE
end

----------------------------------------------------------------------

--- Enables statusline for `window`.
---@param window integer
statusline.enable = function (window)
	---|fS

	if type(window) ~= "number" or statusline.state.attached_windows[window] == nil then
		return;
	end

	statusline.attach(window, true);

	---|fE
end

--- Enables *all* attached windows.
statusline.Enable = function ()
	---|fS

	statusline.state.enable = true;

	for window, state in pairs(statusline.state.attached_windows) do
		if state ~= true then
			statusline.enable(window);
		end
	end

	---|fE
end

--- Disables statusline for `window`.
---@param window integer
statusline.disable = function (window)
	---|fS

	if type(window) ~= "number" or statusline.state.attached_windows[window] == nil then
		return;
	end

	statusline.detach(window);

	---|fE
end

--- Disables *all* attached windows.
statusline.Disable = function ()
	---|fS

	for window, state in pairs(statusline.state.attached_windows) do
		if state ~= false then
			statusline.disable(window);
		end
	end

	statusline.state.enable = false;

	---|fE
end

----------------------------------------------------------------------

--- Toggles state of given window.
---@param window integer
statusline.toggle = function (window)
	---|fS

	if type(window) ~= "number" or statusline.state.attached_windows[window] == nil then
		return;
	elseif statusline.state.attached_windows[window] == true then
		statusline.disable(window);
	else
		statusline.enable(window);
	end

	---|fE
end

--- Toggles statusline **globally**.
statusline.Toggle = function ()
	---|fS

	if statusline.state.enable == true then
		statusline.Disable();
	else
		statusline.Enable();
	end

	---|fE
end

----------------------------------------------------------------------

--- Sets up the statusline module.
---@param config statusline.config | boolean | nil
statusline.setup = function (config)
	---|fS

	if type(config) == "table" then
		statusline.config = vim.tbl_extend("force", statusline.config, config);
	elseif type(config) == "boolean" then
		statusline.state.enable = config;
	end

	for window, _ in pairs(statusline.state.attached_windows) do
		statusline.update_id(window);
	end

	---|fE
end

return statusline;
