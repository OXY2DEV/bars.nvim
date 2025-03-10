local statuscolumn = {};
local components = require("bars.components.statuscolumn");

--- Custom statuscolumn.
---@type string
local STC = "%!v:lua.require('bars.statuscolumn').render()";

---@type statuscolumn.config
statuscolumn.config = {
	ignore_filetypes = { "blink-cmp-menu" },
	ignore_buftypes = { "nofile", "help" },

	default = {
		parts = {
			{
				kind = "empty",
				width = 1,
				hl = "Normal"
			},
			{
				kind = "signs",
				width = 1,
				hl = "Normal",

				filter = function (buffer, namespaces, _, _, _, details)
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local name = namespaces[details.ns_id] or "";

					if package.loaded["markview"] and vim.bo[buffer] == "markdown" then
						--- On markdown files when on normal
						--- mode only show markview signs.
						if mode == "n" then
							return string.match(name, "^markview");
						else
							return true;
						end
					elseif package.loaded["helpview"] and vim.bo[buffer].ft == "help" then
						--- On help files when on normal
						--- mode only show helpview signs.
						if mode == "n" then
							return string.match(name, "^helpview");
						else
							return true;
						end
					else
						if mode == "n" then
							--- On normal mode only show LSP signs.
							return string.match(name, "^vim[%._]lsp") ~= nil;
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

				close_text = { "󰌶" },
				close_hl = "Color0",
				open_text = { "󱠂" },
				open_hl = { "Color1", "Color2", "Color3", "Color4", "Color5", "Color6", "Color7" },

				scope_text = "│",
				scope_end_text = "╰",
				scope_merge_text = "├",

				fill_text = " ",

				scope_hl = { "Gradient1N2", "Gradient2N2", "Gradient3N2", "Gradient4N2", "Gradient5N2", "Gradient6N2", "Gradient7" },
				scope_end_hl = { "Gradient1N2", "Gradient2N2", "Gradient3N2", "Gradient4N2", "Gradient5N2", "Gradient6N2", "Gradient7" },
				scope_merge_hl = { "Gradient1N2", "Gradient2N2", "Gradient3N2", "Gradient4N2", "Gradient5N2", "Gradient6N2", "Gradient7" },
			},
			{
				kind = "empty",
				width = 1,
				hl = "Normal"
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
					"Gradient4N0", "Gradient4N0", "Gradient4N1", "Gradient4N1",
					"Gradient4N2", "Gradient4N2", "Gradient4N3", "Gradient4N3",
					"Gradient4N4", "Gradient4N4"
				},
				virt_hl = {
					"Gradient5N0", "Gradient5N0", "Gradient5N1", "Gradient5N1",
					"Gradient5N2", "Gradient5N2", "Gradient5N3", "Gradient5N3",
					"Gradient5N4", "Gradient5N4"
				},
				hl = {
					"Lnum",
					"Shadow5", "Shadow4", "Shadow3",
					"Shadow2", "Shadow1", "Shadow0"
				}
			},
			{
				kind = "empty",
				width = 1,
				hl = "Normal"
			},
			{
				kind = "border",
				text = "▎",
				hl = function (_, window)
					---|fS "Color matching the mode"
					if vim.api.nvim_get_current_win() ~= window then
						return "Layer2I";
					end

					local _o = {};
					local gr_map = {
						default = "Gradient8N%d",

						["v"] = "Gradient9N%d",
						["V"] = "Gradient7N%d",
						[""] = "Gradient2N%d",

						["s"] = "Gradient9N%d",
						["S"] = "Gradient7N%d",
						[""] = "Gradient2N%d",

						["i"] = "Gradient10N%d",
						["ic"] = "Gradient10N%d",
						["ix"] = "Gradient10N%d",

						["R"] = "Gradient8N%d",
						["Rc"] = "Gradient8N%d",

						["c"] = "Gradient4N%d",
						["!"] = "Gradient4N%d",
					};

					---@type string
					local mode = vim.api.nvim_get_mode().mode;

					for g = 0, 4 do
						---@type string
						local hl = gr_map[mode] or gr_map.default;

						table.insert(_o, string.format(hl, g));
					end

					return _o;
					---|fE
				end
			},
		}
	},

	query = {
		condition = function (buffer)
			return vim.bo[buffer].ft == "query" and vim.bo[buffer].bt == "nofile";
		end,

		parts = {
			{
				kind = "empty",
				width = 1,
				hl = "Normal"
			},
		}
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

	for _, part in ipairs(config.parts or {}) do
		_o = _o .. components.get(part.kind, buffer, window, part, _o);
	end

	return _o;

	---|fE
end

statuscolumn.can_detach = function (win)
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
end

--- Detaches from {buffer}.
---@param window integer
statuscolumn.detach = function (window)
	---|fS

	vim.schedule(function ()
		if not window or vim.api.nvim_win_is_valid(window) == false then
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

statuscolumn.can_attach = function (win, force)
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
	if statuscolumn.state.enable == false then
		return;
	end

	for _, window in ipairs(vim.api.nvim_list_wins()) do
		statuscolumn.update_id(window);
	end

	vim.g.__statuscolumn = vim.o.statuscolumn == STC and "" or vim.o.statuscolumn;
	vim.o.statuscolumn = STC;
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
	if type(window) ~= "number" or statuscolumn.state.attached_windows[window] == nil then
		return;
	end

	statuscolumn.attach(window, true);
end

--- Enables *all* attached windows.
statuscolumn.Enable = function ()
	statuscolumn.state.enable = true;

	for window, state in pairs(statuscolumn.state.attached_windows) do
		if state ~= true then
			statuscolumn.enable(window);
		end
	end
end

--- Disables statuscolumn for `window`.
---@param window integer
statuscolumn.disable = function (window)
	if type(window) ~= "number" or statuscolumn.state.attached_windows[window] == nil then
		return;
	end

	statuscolumn.detach(window);
end

--- Disables *all* attached windows.
statuscolumn.Disable = function ()
	for window, state in pairs(statuscolumn.state.attached_windows) do
		if state ~= false then
			statuscolumn.disable(window);
		end
	end

	statuscolumn.state.enable = false;
end

----------------------------------------------------------------------

--- Toggles state of given window.
---@param window integer
statuscolumn.toggle = function (window)
	if type(window) ~= "number" or statuscolumn.state.attached_windows[window] == nil then
		return;
	elseif statuscolumn.state.attached_windows[window] == true then
		statuscolumn.disable(window);
	else
		statuscolumn.enable(window);
	end
end

--- Toggles statuscolumn **globally**.
statuscolumn.Toggle = function ()
	if statuscolumn.state.enable == true then
		statuscolumn.Disable();
	else
		statuscolumn.Enable();
	end
end

----------------------------------------------------------------------

--- Sets up the statuscolumn module.
---@param config statuscolumn.config | boolean | nil
statuscolumn.setup = function (config)
	if type(config) == "table" then
		statuscolumn.config = vim.tbl_extend("force", statuscolumn.config, config);
	elseif type(config) == "boolean" then
		statuscolumn.state.enable = config;
	end

	for window, _ in pairs(statuscolumn.state.attached_windows) do
		vim.w[window].__scID = statuscolumn.update_id(window);
	end
end

return statuscolumn;
