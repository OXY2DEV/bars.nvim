local statuscolumn = {};
local utils = require("bars.utils");
local components = require("bars.components.statuscolumn");

---@type statuscolumn.config
statuscolumn.config = {
	ignore_filetypes = { "query" },
	ignore_buftypes = { "nofile", "help" },

	default = {
		parts = {
			{
				kind = "empty",
				len = 1,
				hl = "Normal"
			},
			{
				kind = "signs",
				len = 1,
				hl = "Normal"
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
				len = 1,
				hl = "Normal"
			},
			{
				kind = "lnum",

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
				len = 1,
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
			return vim.bo[buffer].ft == "query";
		end,
		parts = {
			{
				kind = "empty",
				len = 1,
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

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(statuscolumn.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = statuscolumn.config[key];

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

--- Renders the statuscolumn for a window.
---@param buffer integer
---@param window integer
---@return string
statuscolumn.render = function (buffer, window)
	---|fS

	if window ~= vim.g.statusline_winid then
		return "";
	elseif statuscolumn.state.attached_windows[window] ~= true then
		return "";
	end

	local scID = vim.w[window].__scID;

	if not scID then
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

--- Detaches from {buffer}.
---@param buffer integer
statuscolumn.detach = function (buffer)
	---|fS

	if type(buffer) ~= "number" then
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return;
	end

	local windows = vim.fn.win_findbuf(buffer)

	for _, win in ipairs(windows) do
		statuscolumn.state.attached_windows[win] = false;

		vim.defer_fn(function ()
			if vim.w[win].__statuscolumn then
				vim.wo[win].statuscolumn = vim.w[win].__statuscolumn[1];
				vim.w[win].__statuscolumn = nil;
			else
					vim.wo[win].statuscolumn = "";
			end

			vim.w[win].__scID = nil;
		end, 1)
	end

	---|fE
end

--- Attaches the statuscolumn module to the windows
--- of a buffer.
---@param buffer integer
statuscolumn.attach = function (buffer)
	---|fS

	local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

	if type(buffer) ~= "number" then
		statuscolumn.detach(buffer);
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		statuscolumn.detach(buffer);
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		statuscolumn.detach(buffer);
		return;
	elseif vim.list_contains(statuscolumn.config.ignore_filetypes, ft) then
		statuscolumn.detach(buffer);
		return;
	elseif vim.list_contains(statuscolumn.config.ignore_buftypes, bt) then
		statuscolumn.detach(buffer);
		return;
	elseif statuscolumn.config.condition then
		local checked_condition, result = pcall(statuscolumn.config.condition, buffer);

		if checked_condition == false then
			statuscolumn.detach(buffer);
			return;
		elseif result == false then
			statuscolumn.detach(buffer);
			return;
		end
	end

	local windows = vim.fn.win_findbuf(buffer);

	for _, win in ipairs(windows) do
		if statuscolumn.state.attached_windows[win] == true then
			goto continue;
		end

		local scID = statuscolumn.update_id(win);
		statuscolumn.state.attached_windows[win] = true;

		vim.w[win].__scID = scID;

		vim.w[win].__numberwidth = utils.to_constant(vim.wo[win].numberwidth);
		vim.w[win].__statuscolumn = utils.to_constant(vim.wo[win].statuscolumn);

		vim.wo[win].numberwidth = 1;
		vim.wo[win].statuscolumn = "%!v:lua.require('bars.statuscolumn').render(" .. buffer .."," .. win ..")";

		::continue::
	end

	---|fE
end

--- Cleans up invalid buffers and recalculates
--- valid buffers config ID.
statuscolumn.clean = function ()
	for window, _ in pairs(statuscolumn.state.attached_windows) do
		if vim.api.nvim_win_is_valid(window) == false then
			statuscolumn.state.attached_windows[window] = false;
			goto continue;
		end

		local buffer = vim.api.nvim_win_get_buf(window);

		local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

		if type(buffer) ~= "number" then
			statuscolumn.detach(buffer);
			return;
		elseif vim.api.nvim_buf_is_loaded(buffer) == false then
			statuscolumn.detach(buffer);
			return;
		elseif vim.api.nvim_buf_is_valid(buffer) == false then
			statuscolumn.detach(buffer);
			return;
		elseif vim.list_contains(statuscolumn.config.ignore_filetypes, ft) then
			statuscolumn.detach(buffer);
			return;
		elseif vim.list_contains(statuscolumn.config.ignore_buftypes, bt) then
			statuscolumn.detach(buffer);
			return;
		elseif statuscolumn.config.condition then
			local checked_condition, result = pcall(statuscolumn.config.condition, buffer);

			if checked_condition == false then
				statuscolumn.detach(buffer);
				return;
			elseif result == false then
				statuscolumn.detach(buffer);
				return;
			end
		end

		::continue::
	end
end

--- Sets up the statuscolumn module.
---@param config statuscolumn.config | nil
statuscolumn.setup = function (config)
	if type(config) == "table" then
		statuscolumn.config = vim.tbl_extend("force", statuscolumn.config, config);
	end

	for _, window in ipairs(statuscolumn.state.attached_windows) do
		vim.w[window].__scID = statuscolumn.update_id(window);
	end
end

return statuscolumn;
