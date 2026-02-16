---@type bars.generic
---@diagnostic disable-next-line: missing-fields
local generic = {};

function generic:set_default_state ()
	self.state = {
		enable = true,
		window_state = {},
	};

	self.config = {};
	self.use_blank_output = false;
end

---@param src any
---@param element any
---@param fallback any
---@return boolean
local function list_contains (src, element, fallback)
	if not src or not vim.islist(src) then
		return fallback;
	end

	return vim.list_contains(src, element)
end

generic.var_name = "bars_style";

--------------------------------------------------------------------------------

function generic:current (_) return ""; end

function generic:should_attach (win)
	if not self.state.enable then
		return false
	elseif self.state.window_state[win] ~= nil then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo.filetype, vim.bo.buftype;

	local current = self:current(win) or "";

	if self.config.ignore_buftypes or self.config.ignore_filetypes then
		if list_contains(self.config.ignore_filetypes, ft, false) then
			return false;
		elseif list_contains(self.config.ignore_buftypes, bt, false) then
			return false;
		end
	elseif self.config.buftypes or self.config.filetypes then
		if not list_contains(self.config.filetypes, ft, true) then
			return false;
		elseif not list_contains(self.config.buftypes, bt, true) then
			return false;
		end
	end

	if list_contains(self.config.force_attach, current, false) then
		return true;
	elseif self.config.condition then
		local could_exec, value = pcall(self.config.condition, buffer, win);
		return (could_exec and value) and true or false;
	end

	return true;
end

function generic:should_detach (win)
	if not self.state.enable then
		return false
	end

	local current = self:current(win) or "";

	if current ~= self.default then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo.filetype, vim.bo.buftype;

	if self.config.ignore_buftypes or self.config.ignore_filetypes then
		if list_contains(self.config.ignore_filetypes, ft, false) then
			return true;
		elseif list_contains(self.config.ignore_buftypes, bt, false) then
			return true;
		end
	elseif self.config.buftypes or self.config.filetypes then
		if not list_contains(self.config.filetypes, ft, true) then
			return true;
		elseif not list_contains(self.config.buftypes, bt, true) then
			return true;
		end
	elseif list_contains(self.config.force_attach, current, false) then
		return false;
	elseif self.config.condition then
		local could_exec, value = pcall(self.config.condition, win, buffer);
		return (could_exec and value) and false or true;
	end

	return false;
end

--------------------------------------------------------------------------------

function generic:set (_) end
function generic:remove (_) end

function generic:attach (win)
	if self.state.window_state[win] == true then return; end
	self.state.window_state[win] = true;

	self:update_style(win);
	self:set(win);
end

function generic:detach (win)
	if self.state.window_state[win] == false then return; end
	self.state.window_state[win] = nil;

	self:remove(win);
end

function generic:enable (win)
	if not self.state.enable then
		return;
	elseif self.state.window_state[win] == true then
		return;
	end

	self.state.window_state[win] = true;

	self:update_style(win);
	self:set(win);
end

function generic:disable (win)
	if not self.state.enable then
		return;
	elseif self.state.window_state[win] == false then
		return;
	end

	self.state.window_state[win] = false;
	self:remove(win);
end

function generic:toggle (win)
	if self.state.window_state[win] then
		self:disable(win);
	elseif self.state.window_state[win] == false then
		self:enable(win);
	end
end

function generic:update (win)
	self:update_style(win);
end

function generic:Toggle ()
	self:Enable();
	self:Disable();
end

function generic:Enable ()
	if self.state.enable then
		return;
	end

	self.state.enable = true;

	for win, state in pairs(self.state.window_state) do
		if state == false then
			self:enable(win);
		end
	end
end

function generic:Disable ()
	if not self.state.enable then
		return;
	end

	for win, state in pairs(self.state.window_state) do
		if state then
			self:disable(win);
		end
	end

	self.state.enable = false;
end

function generic:handle_new_window (win)
	if not self.state.enable then
		return;
	end

	if self:should_detach(win) then
		self:detach(win);
	elseif self:should_attach(win) then
		self:attach(win);
	end
end

function generic:update_style(win)
	local buf = vim.api.nvim_win_get_buf(win);

	local keys = vim.tbl_keys(self.config or {});
	table.sort(keys);

	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	local style = "default";

	for _, k in ipairs(keys) do
		local v = self.config[k];

		if not vim.list_contains(ignore, k) and type(v) == "table" then
			if v.condition == true then
				style = k;
				break;
			elseif type(v.condition) == "function" then
				local can_eval, val = pcall(v.condition, buf, win);

				if can_eval and val then
					style = k;
					break;
				end
			end
		end
	end

	vim.api.nvim_win_set_var(win, "_" .. self.var_name, style);
end

function generic:styled_component (win, buf, components, entry, last)
	if entry.condition then
		if entry.condition == false then
			return "";
		else
			local could_exec, value = pcall(entry.condition, buf, win, last);

			if could_exec and not value then
				return "";
			end
		end
	elseif
		type(entry.kind) ~= "string" or
		type(components[entry.kind]) ~= "function"
	then
		return "!" .. entry.kind;
	end

	local static_config = vim.deepcopy(entry);

	for key, value in pairs(static_config) do
		if type(value) == "function" then
			local s_success, s_val = pcall(value, buf, win, last);

			if s_success == false then
				static_config[key] = nil;
			else
				static_config[key] = s_val;
			end
		end
	end

	local could_exec, part = pcall(components[entry.kind], buf, win, static_config, last);

	if could_exec and type(part) == "string" then
		return part;
	else
		return "?" .. entry.kind;
	end
end

function generic:get_styled_output (win, components)
	local buf = vim.api.nvim_win_get_buf(win);

	local function get_var (key)
		local could_get, value = pcall(vim.api.nvim_win_get_var, win, key);
		return could_get and value or nil;
	end

	if not get_var("_" .. self.var_name) then
		if self.use_blank_output then
			return "";
		else
			self:update_style(win);
		end
	end

	local style = get_var(self.var_name) or
		get_var("_" .. self.var_name) or
		"default"
	;
	local items ={};
	local output = "";

	if self.config[style] and self.config[style].components then
		items = self.config[style].components;
	elseif self.config.default and self.config.default.components then
		items = self.config.default.components;
	end

	for _, entry in ipairs(items) do
		output = output .. self:styled_component(win, buf, components, entry, output);
	end

	return output;
end

generic.__index = generic;

--------------------------------------------------------------------------------

local builder = {};

--[[ Creates a new `bar`. ]]
---@return bars.generic
builder.new = function ()
	---@type bars.generic
	local out = setmetatable({}, generic);
	out:set_default_state();

	return out;
end

return builder;
