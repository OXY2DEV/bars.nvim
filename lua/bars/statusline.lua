--- Custom statusline module.
local statusline = {};

--- Custom statusline.
---@type string
local STL = "%!v:lua.require('bars.statusline').render()";

---@type table<string, statusline_component>
local TEMPLATES;

TEMPLATES = {
	---@type statusline.components.mode
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
		---|fS

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
		},

		["^$"] = {
			icon = "󰂵 ",
			text = "New file",

			hl = "BarsFt0"
		},

		["^fish"] = {
			icon = "󰐂 ",
		},

		---|fE
	},
	diagnostics = {
		---|fS

		kind = "diagnostics",
		default_mode = 5,

		padding_left = " ",
		padding_right = " ",

		empty_icon = "󰂓 ",
		empty_hl = "@comment",

		error_icon = "󰅙 ",
		error_hl = "DiagnosticError",

		warn_icon = "󰀦 ",
		warn_hl = "DiagnosticWarn",

		hint_icon = "󰁨 ",
		hint_hl = "DiagnosticHint",

		info_icon = "󰁤 ",
		info_hl = "DiagnosticInfo"

		---|fE
	},
	macro = {
		---|fS

		kind = "macro",

		record_icon = "󰦚 ",
		exec_icon = "󰥠 ",

		record_hl = "@constant",
		exec_hl = "DiagnosticOk",

		---|fE
	},
	progress = {
		---|fS

		kind = "progress",

		check = "lsp_loader_state",
		update_delay = 250,

		start = "󰐌 ",
		progress = { "󰋙 ", "󰫃 ", "󰫄 ", "󰫅 ", "󰫆 ", "󰫇 ", "󰫈 " },
		finish = "󰗠 ",

		start_hl = "@comment",
		progress_hl = {
			"BarsNormal4",
			"BarsNormal3",
			"BarsNormal3",
			"BarsNormal2",
			"BarsNormal2",
			"BarsNormal1",
			"BarsNormal1",
		},
		finish_hl = "DiagnosticOk"

		---|fE
	},
	git_branch = {
		---|fS

		kind = "branch",
		condition = function (_, win)
			return win == vim.api.nvim_get_current_win();
		end,

		default = {
			padding_left = " ",
			padding_right = " ",
			icon = "󰊢 ",

			hl = "@comment"
		}

		---|fE
	},
	lsp = {
		---|fS

		kind = "custom",

		condition = function (_, window)
			if window ~= vim.api.nvim_get_current_win() then
				return true;
			else
				return vim.api.nvim_win_get_width(window) > math.ceil(vim.o.columns * 0.5);
			end
		end,

		value = function (buffer)
			local clients = vim.lsp.get_clients({ bufnr = buffer });

			if #clients == 0 or vim.b[buffer].lsp_loader_state then
				return "";
			end

			local name_maps = {
				default = { icon = "󰒋 ", hl = "BarsFt0" },
				lua_ls = { icon = " ", name = "LuaLS", hl = "BarsFt5" },
				html = { icon = " ", name = "HTML", hl = "BarsFt2" },
				emmet_language_server = { icon = "󱡴 ", name = "Emmet", hl = "BarsFt4" },
			}
			local output = "";

			for c, client in ipairs(clients) do
				local name = client.name or "";

				if name_maps[name] then
					if name_maps[name].hl then
						output = output .. string.format("%%#%s#", name_maps[name].hl);
					end

					output = output .. (c > 1 and "" or " ").. name_maps[name].icon .. name_maps[name].name .. " ";
				else
					if name_maps.default.hl then
						output = output .. string.format("%%#%s#", name_maps.default.hl);
					end

					output = output .. (c > 1 and "" or " ") .. name_maps.default.icon .. name .. " ";
				end
			end

			return output;
		end

		---|fE
	},

	---@type statusline.components.ruler
	ruler = {
		---|fS

		kind = "ruler",
		mode = function ()
			local mode = vim.api.nvim_get_mode().mode;
			local visual_modes = { "v", "V", "" };

			return vim.list_contains(visual_modes, mode) and "visual" or "normal";
		end,

		-- Yes, you can turn most options into
		-- functions, but some may lead to undefined
		-- behavior.
		---@diagnostic disable: assign-type-mismatch
		default = function ()
			---|fS

			local hl = TEMPLATES.mode.default.hl;
			local mode = vim.api.nvim_get_mode().mode;

			local ignore = { "default", "min_width", "kind", "condition", "kind" };
			---@type mode.opts
			local config = require("bars.utils").match(TEMPLATES.mode, mode, ignore);

			hl = config.hl or hl;

			return {
				padding_left = " ",
				padding_right = " ",
				icon = "󰆤 ",

				separator = " 󰇛 ",

				hl = hl or "BarsRuler"
			};

			---|fE
		end,

		visual = function ()
			---|fS

			local hl = TEMPLATES.mode.default.hl;
			local mode = vim.api.nvim_get_mode().mode;

			local ignore = { "default", "min_width", "kind", "condition", "kind" };
			---@type mode.opts
			local config = require("bars.utils").match(TEMPLATES.mode, mode, ignore);

			hl = config.hl or hl;

			return {
				padding_left = " ",
				padding_right = " ",
				icon = "󰆣 ",

				separator = " 󰇛 ",

				hl = hl or "BarsRuler"
			};

			---|fE
		end
		---@diagnostic enable: assign-type-mismatch

		---|fE
	},
};

---@type statusline.config
statusline.config = {
	ignore_filetypes = {},
	ignore_buftypes = {},

	default = {
		---|fS "Default configuration"

		components = {
			TEMPLATES.mode,
			TEMPLATES.bufname,
			{ kind = "section", hl = "StatusLine" },
			TEMPLATES.diagnostics,
			TEMPLATES.macro,
			{ kind = "empty", hl = "StatusLine" },
			TEMPLATES.git_branch,
			TEMPLATES.progress,
			TEMPLATES.lsp,
			TEMPLATES.ruler
		}

		---|fE
	},

	["help"] = {
		---|fS "Help statusline"

		condition = function (buffer)
			return vim.bo[buffer].buftype == "help";
		end,
		components = {
			{ kind = "empty" },
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

					separator = " 󰇛 ",

					hl = "BarsRuler"
				},

				visual = {
					icon = " ",

					hl = "BarsRuler"
				}
			},
			TEMPLATES.bufname,
			{ kind = "empty", hl = "StatusLine" },
		}

		---|fE
	},

	quickfix = {
		---|fS "Help statusline"

		condition = function (buffer)
			return vim.bo[buffer].buftype == "quickfix";
		end,

		components = {
			{
				kind = "custom",
				value = function ()
					local text = "%#BarsQuickfix#";
					text = text .. " 󱌢 Quickfix ";

					for i = 2, 15, 1 do
						text = text .. string.format("%%#BarsQuickfix%d#", i);
						text = text .. "▛";
					end

					return text;
				end
			},
			{ kind = "empty" },
			TEMPLATES.mode,
		}

		---|fE
	},
};

---@type statusline.state
statusline.state = {
	enable = true,
	attached_windows = {}
};

statusline.check_condition = function (buffer, window)
	if not statusline.config.condition then
		return true;
	end

	local can_call, cond = pcall(statusline.config.condition, buffer, window);
	return can_call and cond;
end

--- Renders the statusline for a window.
---@return string
statusline.render = function ()
	---|fS

	local components = require("bars.components.statusline");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(statusline.config.ignore_filetypes, vim.bo[buffer].ft) then
		statusline.detach(window);
		return "";
	elseif vim.list_contains(statusline.config.ignore_buftypes, vim.bo[buffer].bt) then
		statusline.detach(window);
		return "";
	elseif statusline.check_condition(buffer, window) == false then
		statusline.detach(window);
		return "";
	end

	statusline.update_id(window);

	local slID = vim.w[window].__slID or "default";
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

--- Attaches the statusline module.
statusline.start = function ()
	---|fS

	if statusline.state.enable == false then
		return;
	end

	vim.api.nvim_set_option_value("statusline", STL, { scope = "global" })

	---|fE
end

statusline.attach = function (window)
	local _statusline = vim.api.nvim_get_option_value("statusline", { scope = "local", win = window });

	if _statusline == STL then
		return;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(statusline.config.ignore_filetypes, vim.bo[buffer].ft) then
		statusline.detach(window);
		return;
	elseif vim.list_contains(statusline.config.ignore_buftypes, vim.bo[buffer].bt) then
		statusline.detach(window);
		return;
	elseif statusline.check_condition(buffer, window) == false then
		statusline.detach(window);
		return "";
	end

	vim.api.nvim_set_option_value(
		"statusline",
		STL,
		{
			scope = "local",
			win = window
		}
	);
end

statusline.detach = function (window)
	local _statusline = vim.api.nvim_get_option_value("statusline", { scope = "local", win = window });

	if _statusline ~= STL then
		return;
	end

	vim.api.nvim_set_option_value(
		"statusline",
		vim.g.__statusline or "",
		{
			scope = "local",
			win = window
		}
	);
end

--- Updates the configuration ID for {window}.
---@param window integer
statusline.update_id = function (window)
	---|fS

	if type(window) ~= "number" or vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(statusline.config.ignore_filetypes, vim.bo[buffer].ft) then
		statusline.detach(window);
		return true;
	elseif vim.list_contains(statusline.config.ignore_buftypes, vim.bo[buffer].bt) then
		statusline.detach(window);
		return true;
	end

	---@type string[]
	local keys = vim.tbl_keys(statusline.config);
	---@type string[]
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

	vim.w[window].__slID = ID;
	statusline.state.attached_windows[window] = true;

	---|fE
end

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
--- vim:foldmethod=markers:
