--- Custom statuscolumn module.
local statuscolumn = {};

--- Custom statuscolumn.
---@type string
local STC = "%!v:lua.require('bars.statuscolumn').render()";

---@type statuscolumn.config
statuscolumn.config = {
	ignore_filetypes = { "blink-cmp-menu" },
	ignore_buftypes = { "help", "quickfix" },

	condition = function (buffer)
		local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

		if bt == "nofile" and ft == "query" then
			--- Buffer for `:InspectTree`
			return true;
		elseif bt == "nofile" then
			--- Normal nofile buffer.
			return false;
		else
			return true;
		end
	end,

	default = {
		components = {
			---|fS

			{
				kind = "empty",
				width = 1,

				hl = "LineNr"
			},
			{
				kind = "signs",
				width = 1,
				hl = "LineNr",

				filter = function (buffer, namespaces, _, _, _, details)
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local name = namespaces[details.ns_id] or "";

					if package.loaded["markview"] and vim.bo[buffer].ft == "markdown" then
						--- On markdown files when on normal
						--- mode only show markview signs.
						if mode == "n" then
							return string.match(name, "^markview") ~= nil;
						else
							return true;
						end
					elseif package.loaded["helpview"] and vim.bo[buffer].ft == "help" then
						--- On help files when on normal
						--- mode only show helpview signs.
						if mode == "n" then
							return string.match(name, "^helpview") ~= nil;
						else
							return true;
						end
					else
						if mode == "n" then
							--- On normal mode only show LSP signs.
							return string.match(name, "vim%.lsp%.") ~= nil;
						elseif vim.list_contains({ "i", "v", "V", "" }, mode) then
							--- On visual mode only show git signs.
							return string.match(name, "^gitsigns") ~= nil;
						end

						return true;
					end
				end
			},
			{
				kind = "folds",

				close_text = { "󱠂" },
				close_hl = { "BarsFoldClose1", "BarsFoldClose2", "BarsFoldClose3", "BarsFoldClose4", "BarsFoldClose5", "BarsFoldClose6", },
				open_text = { "󰌶" },
				open_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },

				scope_text = "│",
				scope_end_text = "╰",
				scope_merge_text = "├",

				fill_text = " ",
				fill_hl = "LineNr",

				scope_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },
				scope_end_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },
				scope_merge_hl = { "BarsFoldOpen1", "BarsFoldOpen2", "BarsFoldOpen3", "BarsFoldOpen4", "BarsFoldOpen5", "BarsFoldOpen6", },
			},
			{
				kind = "empty",
				width = 1,
				hl = "LineNr"
			},
			{
				kind = "lnum",
				mode = 3,

				click = function (_, window)
					return window == vim.api.nvim_get_current_win();
				end,

				wrap_markers = "│",
				virt_markers = "│",

				wrap_hl = {
					"BarsWrap1", "BarsWrap2", "BarsWrap3", "BarsWrap4", "BarsWrap5",
				},
				virt_hl = {
					"BarsVirtual1", "BarsVirtual2", "BarsVirtual3", "BarsVirtual4", "BarsVirtual5",
				},
				hl = {
					"BarsLineNr",
					"LineNr",
				}
			},
			{
				kind = "border",
				text = "▕",
				hl = function (_, window)
					---|fS "Color matching the mode"

					local _o = {};
					local gr_map = {
						default = "BarsNormal%d",

						["v"] = "BarsVisual%d",
						["V"] = "BarsVisualLine%d",
						[""] = "BarsVisualBlock%d",

						["s"] = "BarsVisual%d",
						["S"] = "BarsVisualLine%d",
						[""] = "BarsVisualBlock%d",

						["i"] = "BarsInsert%d",
						["ic"] = "BarsInsert%d",
						["ix"] = "BarsInsert%d",

						["R"] = "BarsInsert%d",
						["Rc"] = "BarsInsert%d",

						["c"] = "BarsCommand%d",
						["!"] = "BarsCommand%d",
					};

					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local USE = gr_map[mode] or gr_map.default

					if vim.api.nvim_get_current_win() ~= window then
						USE = "BarsNoMode%d";
					end

					for g = 1, 7 do
						table.insert(_o, string.format(USE, g));
					end

					return _o;
					---|fE
				end
			},
			{
				kind = "empty",
				width = 1,
				hl = "Normal"
			},

			---|fE
		}
	},

	query = {
		---|fS

		condition = function (buffer)
			return vim.bo[buffer].ft == "query" and vim.bo[buffer].bt == "nofile";
		end,

		components = {
			{
				kind = "empty",
				width = 1,
				hl = "LineNr"
			},
		}

		---|fE
	}
};

---@type statuscolumn.state
statuscolumn.state = {
	enable = true,
	attached_windows = {}
};

--- Updates the configuration ID for {window}.
---@param window integer
---@return string | nil
statuscolumn.update_id = function (window)
	---|fS

	if type(window) ~= "number" then
		return;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local buffer = vim.api.nvim_win_get_buf(window);

	local keys = vim.tbl_keys(statuscolumn.config);
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	local ID = "default";

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(statuscolumn.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = statuscolumn.config[key];

		if tmp.condition == true then
			ID = key;
			break;
		elseif pcall(tmp.condition --[[ @as function ]], buffer, window) and tmp.condition(buffer, window) == true  then
			ID = key;
			break;
		end

		::continue::
	end

	statuscolumn.state.attached_windows[window] = true;
	vim.w[window].__scID = ID;

	---|fE
end

--- Renders the statuscolumn for a window.
---@return string
statuscolumn.render = function ()
	---|fS

	local components = require("bars.components.statuscolumn");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	if window ~= vim.g.statusline_winid then
		--- Window ID changed while rendering.
		--- Abort rendering.
		---
		--- Something must have caused lag.
		return "";
	elseif statuscolumn.state.attached_windows[window] ~= true then
		--- We aren't attached to this window.
		return "";
	end

	--- Statuscolumn config ID.
	---@type string
	local scID = vim.w[window].__scID or "default";

	if not scID then
		--- ID not found?
		--- User might've manually deleted
		--- the ID.
		return "";
	end

	local config = statuscolumn.config[scID];

	if type(config) ~= "table" then
		return "";
	end

	local _o = "%#Normal#";

	for _, component in ipairs(config.components or {}) do
		_o = _o .. components.get(component.kind, buffer, window, component, _o);
	end

	return _o;

	---|fE
end

--- Can we detach from {win}?
---@param win integer
---@return boolean
statuscolumn.can_detach = function (win)
	---|fS

	if vim.api.nvim_win_is_valid(win) == false then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if vim.list_contains(statuscolumn.config.ignore_filetypes, ft) then
		return true;
	elseif vim.list_contains(statuscolumn.config.ignore_buftypes, bt) then
		return true;
	else
		if not statuscolumn.config.condition then
			return false;
		end

		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(statuscolumn.config.condition, buffer, win);

		if ran_cond == false or stat == false then
			return true;
		else
			return false;
		end
	end

	---|fE
end

--- Detaches from {buffer}.
---@param window integer
statuscolumn.detach = function (window)
	---|fS

	vim.schedule(function ()
		if not window or vim.api.nvim_win_is_valid(window) == false then
			-- Invalid window.
			return;
		elseif vim.wo[window].statuscolumn ~= STC then
			-- Do not attempt to modify window's statuscolumn
			-- if the statuscolumn isn't the one we set.
			return;
		end

		vim.w[window].__scID = nil;

		vim.api.nvim_set_option_value(
			"statuscolumn",
			vim.w[window].__statuscolumn or vim.g.__statuscolumn or "",
			{
				scope = "local",
				win = window
			}
		);
		vim.api.nvim_set_option_value(
			"numberwidth",
			vim.w[window].__numberwidth or vim.g.__numberwidth or 1,
			{
				scope = "local",
				win = window
			}
		);

		--- Cached statuscolumn.
		---@type string | nil
		local _st = vim.w[window].__statuscolumn or vim.g.__statuscolumn or "";

		if _st == "" or _st == nil then
			--- Reset statuscolumn.
			vim.api.nvim_win_call(window, function ()
				vim.cmd("set statuscolumn&");
			end);
		else
			vim.api.nvim_set_option_value(
				"statuscolumn",
				_st,
				{
					scope = "local",
					win = window
				}
			);
		end

		statuscolumn.state.attached_windows[window] = false;
	end);

	---|fE
end

--- Can we attach to {win}
---@param win integer
---@param force? boolean Forcefully attach(for windows with state `false`).
---@return boolean
statuscolumn.can_attach = function (win, force)
	---|fS

	if type(win) ~= "number" or vim.api.nvim_win_is_valid(win) == false then
		return false;
	elseif force ~= true and statuscolumn.state.attached_windows[win] == false then
		return false;
	elseif statuscolumn.state.enable == false then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if vim.list_contains(statuscolumn.config.ignore_filetypes, ft) then
		return false;
	elseif vim.list_contains(statuscolumn.config.ignore_buftypes, bt) then
		return false;
	else
		if not statuscolumn.config.condition then
			return true;
		end

		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(statuscolumn.config.condition, buffer, win);

		if ran_cond == false or stat == false then
			return false;
		else
			return true;
		end
	end

	---|fE
end

--- Attaches the statuscolumn module to the windows
--- of a buffer.
---@param window integer
---@param force? boolean
statuscolumn.attach = function (window, force)
	---|fS

	if statuscolumn.can_attach(window, force) == false then
		return;
	elseif statuscolumn.state.attached_windows[window] == true then
		if vim.wo[window].statuscolumn == STC then
			statuscolumn.update_id(window);
			return;
		end
	end

	statuscolumn.update_id(window);

	vim.w[window].__relativenumber = vim.wo[window].relativenumber;
	vim.w[window].__numberwidth = vim.wo[window].numberwidth;

	vim.wo[window].relativenumber = true;
	vim.wo[window].numberwidth = 1;

	--- If the statuscolumn matches the one we set then
	--- this is most likely due to inheriting window properties.
	---
	--- This window was most likely opened from another window
	--- we had attached to before.
	vim.w[window].__statuscolumn = vim.wo[window].statuscolumn == STC and "" or vim.wo[window].statuscolumn;

	vim.wo[window].statuscolumn = STC;

	---|fE
end

--- Attaches globally.
statuscolumn.global_attach = function ()
	---|fS

	if statuscolumn.state.enable == false then
		return;
	elseif statuscolumn.config.condition then
		---@diagnostic disable-next-line
		local ran_cond, stat = pcall(statuscolumn.config.condition, vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win());

		if ran_cond == false or stat == false then
			return;
		end
	end

	for _, window in ipairs(vim.api.nvim_list_wins()) do
		statuscolumn.update_id(window);
	end

	vim.g.__relativenumber = vim.o.relativenumber;
	vim.g.__numberwidth = vim.o.numberwidth;

	vim.o.relativenumber = true;
	vim.o.numberwidth = 1;

	vim.g.__statuscolumn = vim.o.statuscolumn == STC and "" or vim.o.statuscolumn;
	vim.o.statuscolumn = STC;

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
statuscolumn.clean = function ()
	---|fS

	vim.schedule(function ()
		for window, _ in pairs(statuscolumn.state.attached_windows) do
			if statuscolumn.can_detach(window) then
				statuscolumn.detach(window);
			end
		end
	end);

	---|fE
end

----------------------------------------------------------------------

--- Enables statuscolumn for `window`.
---@param window integer
statuscolumn.enable = function (window)
	---|fS

	if type(window) ~= "number" or statuscolumn.state.attached_windows[window] == nil then
		return;
	end

	statuscolumn.attach(window, true);

	---|fE
end

--- Enables *all* attached windows.
statuscolumn.Enable = function ()
	---|fS

	statuscolumn.state.enable = true;

	for window, state in pairs(statuscolumn.state.attached_windows) do
		if state ~= true then
			statuscolumn.enable(window);
		end
	end

	---|fE
end

--- Disables statuscolumn for `window`.
---@param window integer
statuscolumn.disable = function (window)
	---|fS

	if type(window) ~= "number" or statuscolumn.state.attached_windows[window] == nil then
		return;
	end

	statuscolumn.detach(window);

	---|fE
end

--- Disables *all* attached windows.
statuscolumn.Disable = function ()
	---|fS

	for window, state in pairs(statuscolumn.state.attached_windows) do
		if state ~= false then
			statuscolumn.disable(window);
		end
	end

	statuscolumn.state.enable = false;

	---|fE
end

----------------------------------------------------------------------

--- Toggles state of given window.
---@param window integer
statuscolumn.toggle = function (window)
	---|fS

	if type(window) ~= "number" or statuscolumn.state.attached_windows[window] == nil then
		return;
	elseif statuscolumn.state.attached_windows[window] == true then
		statuscolumn.disable(window);
	else
		statuscolumn.enable(window);
	end

	---|fE
end

--- Toggles statuscolumn **globally**.
statuscolumn.Toggle = function ()
	---|fS

	if statuscolumn.state.enable == true then
		statuscolumn.Disable();
	else
		statuscolumn.Enable();
	end

	---|fE
end

----------------------------------------------------------------------

--- Sets up the statuscolumn module.
---@param config statuscolumn.config | boolean | nil
statuscolumn.setup = function (config)
	---|fS

	if type(config) == "table" then
		statuscolumn.config = vim.tbl_extend("force", statuscolumn.config, config);
	elseif type(config) == "boolean" then
		statuscolumn.state.enable = config;
	end

	for window, _ in pairs(statuscolumn.state.attached_windows) do
		vim.w[window].__scID = statuscolumn.update_id(window);
	end

	---|fE
end

return statuscolumn;
