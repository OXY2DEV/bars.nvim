local statusline = {};
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

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(statusline.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = statusline.config[key];

		if tmp.condition == true then
			return key;
		elseif pcall(tmp.condition --[[ @as function ]], buffer, window) and tmp.condition(buffer, window) == true  then
			return key;
		end

		::continue::
	end

	return "default";

	---|fE
end

--- Renders the statusline for a window.
---@param buffer integer
---@param window integer
---@return string
statusline.render = function (buffer, window)
	---|fS

	if window ~= vim.g.statusline_winid then
		return "";
	elseif statusline.state.attached_windows[window] == false then
		return "";
	end

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

--- Detaches from {buffer}.
---@param buffer integer
statusline.detach = function (buffer)
	---|fS

	if type(buffer) ~= "number" then
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return;
	end

	for win, _ in pairs(statusline.state.attached_windows) do
		if vim.api.nvim_win_get_buf(win) ~= buffer then
			goto continue;
		end

		vim.w[win].__slID = nil;
		vim.wo[win].statusline = "";

		statusline.state.attached_windows[win] = false;
	    ::continue::
	end

	---|fE
end

--- Attaches the statusline module to the windows
--- of a buffer.
---@param buffer integer
statusline.attach = function (buffer)
	---|fS

	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if type(buffer) ~= "number" then
		statusline.detach(buffer);
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		statusline.detach(buffer);
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		statusline.detach(buffer);
		return;
	elseif vim.list_contains(statusline.config.ignore_filetypes, ft) then
		statusline.detach(buffer);
		return;
	elseif vim.list_contains(statusline.config.ignore_buftypes, bt) then
		statusline.detach(buffer);
		return;
	end

	local windows = vim.fn.win_findbuf(buffer);

	for _, win in ipairs(windows) do
		if statusline.state.attached_windows[win] == true then
			goto continue;
		end

		local slID = statusline.update_id(win);
		statusline.state.attached_windows[win] = true;

		vim.w[win].__slID = slID;
		vim.wo[win].statusline = "%!v:lua.require('bars.statusline').render(" .. buffer .."," .. win ..")";

		::continue::
	end

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
statusline.clean = function ()
	---|fS

	for window, _ in pairs(statusline.state.attached_windows) do
		if vim.api.nvim_win_is_valid(window) == false then
			statusline.state.attached_windows[window] = false;
			goto continue;
		end

		local buffer = vim.api.nvim_win_get_buf(window);

		local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

		if type(buffer) ~= "number" then
			statusline.detach(buffer);
			return;
		elseif vim.api.nvim_buf_is_loaded(buffer) == false then
			statusline.detach(buffer);
			return;
		elseif vim.api.nvim_buf_is_valid(buffer) == false then
			statusline.detach(buffer);
			return;
		elseif vim.list_contains(statusline.config.ignore_filetypes, ft) then
			statusline.detach(buffer);
			return;
		elseif vim.list_contains(statusline.config.ignore_buftypes, bt) then
			statusline.detach(buffer);
			return;
		elseif statusline.config.condition then
			local checked_condition, result = pcall(statusline.config.condition, buffer);

			if checked_condition == false then
				statusline.detach(buffer);
				return;
			elseif result == false then
				statusline.detach(buffer);
				return;
			end
		end

		::continue::
	end

	---|fE
end

--- Sets up the statusline module.
---@param config statusline.config | nil
statusline.setup = function (config)
	if type(config) == "table" then
		statusline.config = vim.tbl_extend("force", statusline.config, config);
	end

	for window, _ in pairs(statusline.state.attached_windows) do
		vim.w[window].__slID = statusline.update_id(window);
	end
end

return statusline;
