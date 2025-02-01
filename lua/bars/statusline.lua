local statusline = {};
local utils = require("bars.utils");
local components = require("bars.components.statusline");

--- Configuration table.
---@type statusline.config
statusline.config = {
	ignore_filetypes = {},
	ignore_buftypes = {},

	default = {
		parts = {
			{
				kind = "mode",

				---|fS "Mode configuration"

				default = {
					padding_left = " ",
					padding_right = " ",

					icon = " ",

					hl = "Color8R",
				},

				["^n"] = { text = "Normal" },

				["^t"] = { text = "Terminal" },

				["^v$"] = {
					icon = "󰸿 ",
					text = "Visual",

					hl = "Color9R",
				},
				["^V$"]    = {
					icon = "󰹀 ",
					text = "Visual",

					hl = "Color7R",
				},
				["^$"]   = {
					icon = "󰸽 ",
					text = "Visual",

					hl = "Color2R",
				},

				["^s$"]    = {
					icon = "󰕠 ",
					text = "Select",

					hl = "Color9R",
				},
				["^S$"]    = {
					icon = "󰕞 ",
					text = "Select",

					hl = "Color7R",
				},
				["^$"]   = {
					icon = " ",
					text = "Select",

					hl = "Color2R",
				},

				["^i$"]    = {
					icon = " ",
					text = "Insert",

					hl = "Color10R",
				},
				["^ic$"]   = {
					icon = " ",
					text = "Completion",

					hl = "Color10R",
				},
				["^ix$"]   = {
					text = "Inser8",

					hl = "Color10R",
				},

				["^R$"]    = {
					icon = " ",
					text = "Replace",

					hl = "Color8R",
				},
				["^Rc$"]   = {
					icon = " ",
					text = "Completion",

					hl = "Color8R",
				},

				["^c"]    = {
					icon = " ",
					text = "Command",

					hl = "Color4R",
				},

				["^r"] = { text = "Prompt" },

				["^%!"] = {
					icon = " ",
					text = "Shell",

					hl = "Color4R"
				},

				---|fE
			},
			{ kind = "section", hl = "Normal" },
			{
				kind = "bufname",
				condition = function (_, win)
					return vim.api.nvim_win_get_width(win) >= 42;
				end,

				max_len = 25,

				default = {
					padding_left = " ",
					padding_right = " ",

					icon = "",
					nomodifiable_icon_hl = "Color1B",
					nomodifiable_icon = "󰌾 ",
					icon_hl = {
						"Color0B",
						"Color1B", "Color2B", "Color3B",
						"Color4B", "Color5B", "Color6B",
					},

					-- corner_left_hl = "Normal",
					-- corner_right_hl = "Normal",
					hl = "Layer1"
				},

				["^$"] = {
					icon = "󰂵 ",
					text = "New file",

					hl = "Layer0"
				},

				["^fish"] = {
					icon = "󰐂 ",
					-- text = "New file",

					-- hl = "Layer2"
				},
			},
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

					hl = "Color0"
				}
			},
			{
				kind = "ruler",

				default = {
					padding_left = " ",
					padding_right = " ",
					icon = " ",

					separator = "  ",

					hl = "Color1R"
				},

				visual = {
					icon = " ",

					hl = "Color6R"
				}
			}
		}
	},
	["help"] = {
		condition = function (buffer)
			return vim.bo[buffer].buftype == "help";
		end,
		parts = {
			{ kind = "empty", hl = "Normal" },
			{
				kind = "mode",

				---|fS "Mode configuration"

				default = {
					padding_left = " ",
					padding_right = " ",

					icon = " ",

					hl = "Color8R",
				},

				["^n"] = { text = "Normal" },

				["^t"] = { text = "Terminal" },

				["^v$"] = {
					icon = "󰸿 ",
					text = "Visual",

					hl = "Color9R",
				},
				["^V$"]    = {
					icon = "󰹀 ",
					text = "Visual",

					hl = "Color7R",
				},
				["^$"]   = {
					icon = "󰸽 ",
					text = "Visual",

					hl = "Color2R",
				},

				["^s$"]    = {
					icon = "󰕠 ",
					text = "Select",

					hl = "Color9R",
				},
				["^S$"]    = {
					icon = "󰕞 ",
					text = "Select",

					hl = "Color4R",
				},
				["^$"]   = {
					icon = " ",
					text = "Select",

					hl = "Color9R",
				},

				["^i$"]    = {
					icon = " ",
					text = "Insert",

					hl = "Color10R",
				},
				["^ic$"]   = {
					icon = " ",
					text = "Completion",

					hl = "Color10R",
				},
				["^ix$"]   = {
					text = "Inser8",

					hl = "Color10R",
				},

				["^R$"]    = {
					icon = " ",
					text = "Replace",

					hl = "Color8R",
				},
				["^Rc$"]   = {
					icon = " ",
					text = "Completion",

					hl = "Color8R",
				},

				["^c"]    = {
					icon = " ",
					text = "Command",

					hl = "Color4R",
				},

				["^r"] = { text = "Prompt" },

				["^%!"] = {
					icon = " ",
					text = "Shell",

					hl = "Color4R"
				},

				---|fE
			},
			{
				kind = "bufname",
				condition = function (_, win)
					return vim.api.nvim_win_get_width(win) >= 42;
				end,

				default = {
					padding_left = " ",
					padding_right = " ",

					icon = "",
					nomodifiable_icon_hl = "Color1B",
					nomodifiable_icon = "󰌾 ",
					icon_hl = {
						"Color0B",
						"Color1B", "Color2B", "Color3B",
						"Color4B", "Color5B", "Color6B",
					},

					-- corner_left_hl = "Normal",
					-- corner_right_hl = "Normal",
					hl = "Layer1"
				},

				["^$"] = {
					icon = "󰂵 ",
					text = "New file",

					hl = "Layer0"
				},

				["^fish"] = {
					icon = "󰐂 ",
					-- text = "New file",

					-- hl = "Layer2"
				},
			},
			{ kind = "empty", hl = "Normal" },
		}
	}
	-- ["lua"] = {
	-- 	condition = function (buffer)
	-- 		local ft = vim.bo[buffer].ft;
	-- 		return ft == "lua";
	-- 	end,
	-- 	parts = {
	-- 		{
	-- 			kind = "mode",
	--
	-- 			default = {
	-- 				padding_left = " ",
	-- 				padding_right = " ",
	-- 				icon = " ",
	--
	-- 				hl = "Special"
	-- 			},
	-- 			n = { text = "Normal" },
	-- 		}
	-- 	}
	-- }
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

	for _, part in ipairs(config.parts or {}) do
		_o = _o .. components.get(part.kind, buffer, window, part, _o);
	end

	return _o;

	---|fE
end

statusline.can_detach = function (win)
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
end

--- Detaches from {buffer}.
---@param window integer
statusline.detach = function (window)
	---|fS

	vim.defer_fn(function ()
		vim.w[window].__slID = nil;
		vim.api.nvim_set_option_value(
			"statusline",
			utils.get_const(vim.w[window].__statusline)or utils.get_const(vim.g.__statusline) or "",
			{
				scope = "local",
				win = window
			}
		);

		statusline.state.attached_windows[window] = false;
	end, 0);

	---|fE
end

statusline.can_attach = function (win)
	if vim.api.nvim_win_is_valid(win) == false then
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
end

--- Attaches the statusline module to the windows
--- of a buffer.
statusline.attach = function (window)
	---|fS

	if statusline.state.enable == false then
		return;
	elseif statusline.can_attach(window) == false then
		return;
	elseif statusline.state.attached_windows[window] == true then
		if vim.wo[window].statusline == "%!v:lua.require('bars.statusline').render()" then
			return;
		end
	end

	vim.defer_fn(function ()
		statusline.update_id(window);

		vim.w[window].__statusline = utils.constant(vim.wo[window].statusline);
		vim.wo[window].statusline = "%!v:lua.require('bars.statusline').render()";
	end, 0);

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
statusline.clean = function ()
	---|fS

	vim.defer_fn(function ()
		for window, _ in pairs(statusline.state.attached_windows) do
			if statusline.can_detach(window) then
				statusline.detach(window);
			end
		end
	end, 0);

	---|fE
end

--- Sets up the statusline module.
---@param config statusline.config | nil
statusline.setup = function (config)
	if type(config) == "table" then
		statusline.config = vim.tbl_extend("force", statusline.config, config);
	end

	for window, _ in pairs(statusline.state.attached_windows) do
		statusline.update_id(window);
	end
end

return statusline;
