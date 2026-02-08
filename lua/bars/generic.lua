local generic = {};

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

--------------------------------------------------------------------------------

---@param _ integer
function generic:get_current (_) return ""; end

---@param win integer
---@return boolean
function generic:should_attach (win)
	if not self.state.enable then
		return false
	elseif self.state.window_state[win] then
		return false;
	end

	local buffer = vim.api.nvim_win_get_buf(win);
	local ft, bt = vim.bo.filetype, vim.bo.buftype;

	local current = self:get_current(win) or "";

	if self.config.condition then
		local could_exec, value = pcall(self.config.condition, win, buffer);
		return (could_exec and value) and true or false;
	elseif list_contains(self.config.force_attach, current, false) then
		return true;
	elseif self.config.ignore_buftypes or self.config.ignore_filetypes then
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

	return true;
end

---@param _ integer
function generic:current (_) return ""; end

---@param win integer
---@return boolean
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

	if self.config.condition then
		local could_exec, value = pcall(self.config.condition, win, buffer);
		return (could_exec and value) and false or true;
	elseif list_contains(self.config.force_attach, current, false) then
		return false;
	elseif self.config.ignore_buftypes or self.config.ignore_filetypes then
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
	end

	return false;
end

--------------------------------------------------------------------------------

---@param _ integer
function generic:set (_) end
---@param _ integer
function generic:remove (_) end

---@param win integer
function generic:attach (win)
	if self.state.window_state[win] == true then return; end
	self.state.window_state[win] = true;

	self:set(win);
end

---@param win integer
function generic:detach (win)
	if self.state.window_state[win] == false then return; end
	self.state.window_state[win] = nil;

	self:remove(win);
end

---@param win integer
function generic:enable (win)
	if not self.state.enable then
		return;
	elseif self.state.window_state[win] == true then
		return;
	end

	self.state.window_state[win] = true;
	self:set(win);
end

---@param win integer
function generic:disable (win)
	if not self.state.enable then
		return;
	elseif self.state.window_state[win] == false then
		return;
	end

	self.state.window_state[win] = false;
	self:remove(win);
end

---@param win integer
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

return generic;
