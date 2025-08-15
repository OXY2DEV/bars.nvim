--- Custom statuscolumn module.
local statuscolumn = {};

--- Custom statuscolumn.
---@type string
local STC = "%!v:lua.require('bars.statuscolumn').render()";

local gradient_map = {
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
				hl = function ()
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local USE = gradient_map[mode] or gradient_map.default

					return {
						string.format(USE, 1),
						"LineNr",
					};
				end,
			},
			{
				kind = "border",
				text = "▕",
				hl = function ()
					local _o = {};
					---@type string
					local mode = vim.api.nvim_get_mode().mode;
					local USE = gradient_map[mode] or gradient_map.default

					for g = 1, 7 do
						table.insert(_o, string.format(USE, g));
					end

					return _o;
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

	inspect_tree = {
		---|fS

		condition = function (buffer, window)
			if vim.b[buffer].dev_base then
				return true;
			elseif vim.w[window].inspecttree_window then
				return true;
			end

			return false;
		end,

		components = {
			{
				kind = "custom",
				value = function (buffer)
					local lnums = vim.b[buffer].injections or {};
					local current = lnums[vim.v.lnum] or "LineNr";

					return "%#" .. current .. "# ";
				end
			},
		}

		---|fE
	},

	terminal = {
		---|fS

		condition = function (buffer)
			return vim.bo[buffer].bt == "terminal";
		end,

		components = {}

		---|fE
	}
};

---@type statuscolumn.state
statuscolumn.state = {
	enable = true,
	attached_windows = {}
};

statuscolumn.check_condition = function (buffer, window)
	if not statuscolumn.config.condition then
		return true;
	end

	local can_call, cond = pcall(statuscolumn.config.condition, buffer, window);
	return can_call and cond;
end

--- Renders the statuscolumn for a window.
---@return string
statuscolumn.render = function ()
	---|fS

	local components = require("bars.components.statuscolumn");

	local window = vim.g.statusline_winid;
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(statuscolumn.config.ignore_filetypes, vim.bo[buffer].ft) then
		statuscolumn.detach(window);
		return "";
	elseif vim.list_contains(statuscolumn.config.ignore_buftypes, vim.bo[buffer].bt) then
		statuscolumn.detach(window);
		return "";
	elseif statuscolumn.check_condition(buffer, window) == false then
		statuscolumn.detach(window);
		return "";
	end

	statuscolumn.update_id(window);

	--- Statuscolumn config ID.
	---@type string
	local scID = vim.w[window].__scID or "default";

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

--- Attaches the statuscolumn module to the windows
--- of a buffer.
statuscolumn.start = function ()
	---|fS

	if statuscolumn.state.enable == false then
		return;
	end

	vim.g.__relativenumber = vim.api.nvim_get_option_value("relativenumber", { scope = "global" });
	vim.g.__numberwidth = vim.api.nvim_get_option_value("numberwidth", { scope = "global" });

	-- Doesn't work.
	--- vim.g.__statuscolumn = vim.api.nvim_get_option_value("statuscolumn", { scope = "global" });

	vim.api.nvim_set_option_value("relativenumber", true, { scope = "global" });
	vim.api.nvim_set_option_value("numberwidth", 1, { scope = "global" });
	vim.o.statuscolumn = STC;

	local win = vim.api.nvim_get_current_win();
	statuscolumn.attach(win);

	---|fE
end

--[[
Attaches the custom `statuscolumn` to **window**.

Set `ignore_enabled` to **true** to disable module state checker.
]]
---@param window integer
---@param ignore_enabled? boolean
statuscolumn.attach = function (window, ignore_enabled)
	---|fS

	if ignore_enabled ~= true and statuscolumn.state.enable == false then
		-- Do not attach if **this module is disabled**.
		-- Unless we *explicitly* ignore it.
		return;
	elseif statuscolumn.state.attached_windows[window] == true then
		-- Do not attach if **already attached to a window**.
		return;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(statuscolumn.config.ignore_filetypes, vim.bo[buffer].ft) then
		-- Do not attach if `filetype` is *ignored*.
		statuscolumn.detach(window);
	elseif vim.list_contains(statuscolumn.config.ignore_buftypes, vim.bo[buffer].bt) then
		-- Do not attach if `buftype` is *ignored*.
		statuscolumn.detach(window);
	elseif statuscolumn.check_condition(buffer, window) == false then
		-- Do not attach if **conditionally ignored**.
		statuscolumn.detach(window);
	else
		statuscolumn.set(window);
		statuscolumn.state.attached_windows[window] = true;
	end

	---|fE
end

--[[
Detaches the custom `statuscolumn` from **window**.

NOTE: This will *reset* the statuscolumn for that window.
]]
---@param window integer
statuscolumn.detach = function (window)
	---|fS

	if statuscolumn.state.attached_windows[window] == false then
		-- Do not detach from windows whose `state` is **false** as
		-- they may have a different statuscolumn.
		return;
	end

	statuscolumn.remove(window);
	statuscolumn.state.attached_windows[window] = false;

	---|fE
end

--- Updates the configuration ID for {window}.
---@param window integer
statuscolumn.update_id = function (window)
	---|fS

	if type(window) ~= "number" or vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(statuscolumn.config.ignore_filetypes, vim.bo[buffer].ft) then
		statuscolumn.detach(window);
		return true;
	elseif vim.list_contains(statuscolumn.config.ignore_buftypes, vim.bo[buffer].bt) then
		statuscolumn.detach(window);
		return true;
	end

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

	vim.w[window].__scID = ID;

	---|fE
end

--[[
Sets the custom statuscolumn for `window`.
]]
---@param window integer
statuscolumn.set = function (window)
	---|fS

	vim.api.nvim_set_option_value(
		"statuscolumn",
		STC,
		{
			scope = "local",
			win = window
		}
	);

	---|fE
end

--[[
Removes the custom statuscolumn for `window`.
]]
---@param window integer
statuscolumn.remove = function (window)
	---|fS

	if vim.wo[window].statuscolumn ~= STC then
		return;
	end

	vim.api.nvim_win_call(window, function ()
		vim.cmd("set statuscolumn=" .. (vim.g.__statuscolumn or ""));

		-- NOTE(@OXY2DEV): We need a better way to restore `numberwidth` & `relativenumber`.
		-- vim.wo[window].numberwidth = vim.g.__numberwidth;
		-- vim.wo[window].relativenumber = vim.g.__relativenumber;

		pcall(vim.api.nvim__redraw, {
			win = window,
			flush = true,

			statuscolumn = true,
		});
	end);

	---|fE
end

------------------------------------------------------------------------------

--[[ Toggles statuscolumn for **all** windows. ]]
statuscolumn.Toggle = function ()
	---|fS

	if statuscolumn.state.enable == true then
		statuscolumn.Disable();
	else
		statuscolumn.Enable();
	end

	---|fE
end

--[[ Enables statuscolumn for **all** windows. ]]
statuscolumn.Enable = function ()
	---|fS

	for win, state in pairs(statuscolumn.state.attached_windows) do
		if state == true then
			statuscolumn.set(win);
		end
	end

	statuscolumn.state.enable = true;

	---|fE
end

--[[ Disables statuscolumn for **all** windows. ]]
statuscolumn.Disable = function ()
	---|fS

	for win, state in pairs(statuscolumn.state.attached_windows) do
		if state == true then
			statuscolumn.remove(win);
		end
	end

	statuscolumn.state.enable = false;

	---|fE
end

--[[ Toggles statuscolumn for `window`. ]]
---@param window integer
statuscolumn.toggle = function (window)
	---|fS

	if statuscolumn.state.attached_windows[window] == true then
		statuscolumn.detach(window);
	else
		statuscolumn.attach(window);
	end

	---|fE
end

--[[ Enables statuscolumn for `window`. ]]
---@param window integer
statuscolumn.enable = function (window)
	statuscolumn.attach(window);
end

--[[ Disables statuscolumn for `window`. ]]
---@param window integer
statuscolumn.disable = function (window)
	statuscolumn.detach(window);
end

------------------------------------------------------------------------------

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
