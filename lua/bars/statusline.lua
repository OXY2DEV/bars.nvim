--[[
Custom statusline from `bars.nvim`.

## Usage

```lua
require("bars.statusline").Enable();
```
]]
local statusline = {};
local generic = require("bars.generic");

---@type string Expression that creates the statusline when evaluated.
local STL = "%!v:lua.require('bars.statusline').render()";

--[[ Reusable configuration templates. ]]
---@type table<string, statusline.component>
local TEMPLATES;

TEMPLATES = {
	---|fS

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
	---@type statusline.components.bufname
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

		["^config"] = {
			icon = "󰒓 ",

			hl = "BarsFt6"
		},

		---|fE
	},
	---@type statusline.components.diagnostics
	diagnostics = {
		---|fS

		kind = "diagnostics",
		default_mode = 5,
		compact = true,

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
	---@type statusline.components.macro
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
	---@type statusline.components.branch
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
	---@type statusline.components.custom
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

		-- NOTE: You can turn most component options into functions,
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

	---|fE
};

---@type statusline.config
statusline.config = {
	force_attach = {
		-- `Quickfix` window's statusline.
		"%t%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} %=%-15(%l,%c%V%) %P",
	},

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
			vim.tbl_extend("force", TEMPLATES.mode, {
				compact = true
			}),
			{
				kind = "ruler",

				default = {
					padding_left = " ",
					padding_right = " ",
					icon = " ",

					separator = " 󰇛 ",

					hl = "BarsFt0"
				},
			},
			{ kind = "empty", hl = "StatusLine" },
			{
				kind = "custom",
				value = function ()
					local text = "";

					for i = 15, 2, -1 do
						text = text .. string.format("%%#BarsHelp%d#", i);
						text = text .. "▟";
					end

					return text;
				end
			},
			{
				kind = "bufname",
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
			},
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

---@type bars.mod.state
statusline.state = {
	enable = true,
	attached_windows = {}
};

--- Renders the statusline for a window.
---@return string
statusline.render = function ()
	---|fS

	local components = require("bars.components.statusline");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	statusline.update_style(window);

	local style = vim.w[window].bars_statusline_style or "default";
	local config = statusline.config[style];

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

	-- NOTE: Disable `quickfix` windows statusline.
	vim.g.bars_qf_disable_statusline = vim.g.qf_disable_statusline;
	vim.g.qf_disable_statusline = true;

	vim.api.nvim_set_option_value("statusline", STL, { scope = "global" })

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		statusline.attach(win);
	end

	---|fE
end

--[[
Attaches the custom `statusline` to **window**.
]]
---@param window integer
statusline.attach = function (window)
	---|fS

	local current = vim.wo[window].statusline;
	local should_attach = generic.should_attach(
		statusline.state,
		statusline.config,
		current,
		STL,
		window
	);

	if should_attach then
		statusline.set(window);
		statusline.state.attached_windows[window] = true;

		generic.set_win_state(statusline.state, window, true);
	elseif generic.get_win_state(statusline.state, window) and current ~= STL then
		statusline.detach(window);
	end

	---|fE
end

--[[
Detaches the custom `statusline` from **window**.

NOTE: This will *reset* the statusline for that window.
]]
---@param window integer
statusline.detach = function (window)
	---|fS

	if generic.get_win_state(statusline.state, window) then
		statusline.remove(window);
		generic.set_win_state(statusline.state, window, false);
	elseif vim.wo[window].statusline == STL then
		local current = vim.wo[window].statusline;
		local should_attach = generic.should_attach(
			statusline.state,
			statusline.config,
			current,
			STL,
			window
		);

		if should_attach then
			statusline.set(window);
			generic.set_win_state(statusline.state, window, true);
		else
			statusline.remove(window);
		end
	end

	---|fE
end

------------------------------------------------------------------------------

--[[ Updates the statusline style for `window`. ]]
---@param window integer
statusline.update_style = function (window)
	---|fS

	if type(window) ~= "number" or vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local current = vim.wo[window].statuscolumn;
	local should_detach = generic.should_detach(
		statusline.state,
		statusline.config,
		current,
		STL,
		window
	);

	if should_detach then
		statusline.detach(window);
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	---@type string[]
	local keys = vim.tbl_keys(statusline.config);
	---@type string[]
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	local style = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(statusline.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = statusline.config[key];

		if tmp.condition == true then
			style = key;
		elseif type(tmp.condition) == "function" then
			---@diagnostic disable-next-line
			local can_eval, val = pcall(tmp.condition, buffer, window);

			if can_eval and val then
				style = key;
			end
		end

		---@diagnostic enable:undefined-field

		::continue::
	end

	vim.w[window].bars_statusline_style = style;

	---|fE
end

--[[
Sets the custom statusline for `window`.
]]
---@param window integer
statusline.set = function (window)
	---|fS

	vim.api.nvim_set_option_value(
		"statusline",
		STL,
		{
			scope = "local",
			win = window
		}
	);

	---|fE
end

--[[
Removes the custom statusline for `window`.
]]
---@param window integer
statusline.remove = function (window)
	---|fS

	if vim.wo[window].statusline ~= STL then
		return;
	end

	vim.api.nvim_win_call(window, function ()
		vim.cmd("set statusline=" .. (vim.g.__statusline or ""));
	end);

	---|fE
end

------------------------------------------------------------------------------

statusline.Start = function ()
	---|fS

	statusline.state.enable = true;
	statusline.start();

	statusline.Enable();

	---|fE
end

statusline.Stop = function ()
	---|fS

	statusline.state.enable = false;

	-- NOTE: Restore `quickfix` windows statusline.
	vim.g.qf_disable_statusline = vim.g.bars_qf_disable_statusline;

	for win, _ in pairs(statusline.state.attached_windows) do
		statusline.detach(win);
	end

	---|fE
end

--[[ Toggles `statusline` for **all** windows. ]]
statusline.Toggle = function ()
	---|fS

	for win, _ in pairs(statusline.state.attached_windows) do
		statusline.toggle(win);
	end

	---|fE
end

--[[ Enables `statusline` for **all** windows. ]]
statusline.Enable = function ()
	---|fS

	for win, state in pairs(statusline.state.attached_windows) do
		if state == false then
			statusline.enable(win);
		end
	end

	---|fE
end

--[[ Disables `statusline` for **all** windows. ]]
statusline.Disable = function ()
	---|fS

	for win, state in pairs(statusline.state.attached_windows) do
		if state == true then
			statusline.disable(win);
		end
	end

	---|fE
end

--[[ Toggles `statusline` for *window*. ]]
---@param window integer
statusline.toggle = function (window)
	---|fS

	if statusline.state.attached_windows[window] == true then
		statusline.disable(window);
	else
		statusline.enable(window);
	end

	---|fE
end

--[[ Enables `statusline` for *window*. ]]
---@param window integer
statusline.enable = function (window)
	generic.set_win_state(statusline.state, window, true);
	statusline.set(window);
end

--[[ Disables `statusline` for *window*. ]]
---@param window integer
statusline.disable = function (window)
	generic.set_win_state(statusline.state, window, false);
	statusline.remove(window);
end

------------------------------------------------------------------------------

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
		statusline.update_style(window);
	end

	---|fE
end

return statusline;
