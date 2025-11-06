---- Generic methods.
local generic = {};

--- Gets a window's state from a state variable
---@param state table
---@param window integer
---@return boolean
generic.get_win_state = function (state, window)
	return state.attached_windows[window];
end

--- Sets a window's state in a state variable.
---@param state table
---@param window integer
---@param win_state boolean
generic.set_win_state = function (state, window, win_state)
	state.attached_windows[window] = win_state;
end

--- Checks if a condition is `true`.
---@param config table
---@param buffer integer
---@param window integer
---@return boolean
generic.check_condition = function (config, buffer, window)
	if not config.condition then
		return true;
	end

	local can_call, cond = pcall(config.condition, buffer, window);
	return can_call and cond;
end

---@param config table
---@param current string
---@return boolean
generic.force_attach = function (config, current)
	return vim.list_contains(config.force_attach or {}, current);
end

--- Should we attach to `window`?
---@param state table
---@param config table
---@param current string
---@param to string
---@param window integer
---@return boolean
---@return boolean?
generic.should_attach = function (state, config, current, to, window)
	---|fS

	---@type boolean? State for `window`.
	local win_state = generic.get_win_state(state, window);

	if state.enable == false then
		-- Module disabled.
		return false;
	elseif win_state ~= nil then
		-- Already attached.
		return false;
	elseif current ~= to and current ~= "" and generic.force_attach(config, current) == false then
		return false;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(config.ignore_filetypes, vim.bo[buffer].ft) then
		return false;
	elseif vim.list_contains(config.ignore_buftypes, vim.bo[buffer].bt) then
		return false;
	else
		return generic.check_condition(config, buffer, window);
	end

	---|fE
end

--- Should we detach to `window`?
---@param state table
---@param config table
---@param current string
---@param to string
---@param window integer
---@return boolean
generic.should_detach = function (state, config, current, to, window)
	---|fS

	---@type boolean? State for `window`.
	local win_state = generic.get_win_state(state, window);

	if win_state ~= nil then
		-- Already attached.
		return false;
	elseif current ~= to then
		return true;
	end

	---@type integer
	local buffer = vim.api.nvim_win_get_buf(window);

	if vim.list_contains(config.ignore_filetypes, vim.bo[buffer].ft) then
		return true;
	elseif vim.list_contains(config.ignore_buftypes, vim.bo[buffer].bt) then
		return true;
	else
		return not generic.check_condition(config, buffer, window);
	end

	---|fE
end

return generic;
