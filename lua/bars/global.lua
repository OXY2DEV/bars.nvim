--- Goes to clicked line number.
_G.__goto_lnum = function ()
	local mousepos = vim.fn.getmousepos();
	local cursor = vim.api.nvim_win_get_cursor(mousepos.winid);

	pcall(vim.api.nvim_win_set_cursor, mousepos.winid, { mousepos.line, cursor[2] });
end

--- Changes the type of diagnostic
--- that are shown on the statusline.
_G.__change_diagnostic_state = function ()
	local statusline = require("bars.statusline");

	local mousepos = vim.fn.getmousepos();
	local window = mousepos.winid

	if statusline.state.attached_windows[window] ~= true then
		--- Window isn't connected to bars.
		return;
	end

	if type(vim.w[window].__slDiagnostic_mode) ~= "number" then
		vim.w[window].__slDiagnostic_mode = 1;
	elseif vim.w[window].__slDiagnostic_mode < 5 then
		vim.w[window].__slDiagnostic_mode = vim.w[window].__slDiagnostic_mode + 1;
	else
		vim.w[window].__slDiagnostic_mode = 1;
	end

	pcall(vim.api.nvim__redraw, {
		win = window,
		flush = true,
		statusline = true
	});
end


_G.__tab_from_increase = function ()
	if not vim.g.__bars_tabpage_from then
		vim.g.__bars_tabpage_from = 1;
		return;
	end

	---@type integer Number of tabs.
	local tabs = #vim.api.nvim_list_tabpages();

	if vim.g.__bars_tabpage_from + 1 > tabs then
		vim.g.__bars_tabpage_from = 1;
	else
		vim.g.__bars_tabpage_from = vim.g.__bars_tabpage_from + 1;
	end

	pcall(vim.api.nvim__redraw, {
		flush = true,
		tabline = true
	});
end

_G.__tab_from_decrease = function ()
	if not vim.g.__bars_tabpage_from then
		vim.g.__bars_tabpage_from = 1;
		return;
	end

	---@type integer Number of tabs.
	local tabs = #vim.api.nvim_list_tabpages();

	if vim.g.__bars_tabpage_from - 1 < 1 then
		vim.g.__bars_tabpage_from = tabs;
	else
		vim.g.__bars_tabpage_from = vim.g.__bars_tabpage_from - 1;
	end

	pcall(vim.api.nvim__redraw, {
		flush = true,
		tabline = true
	});
end


_G.__buf_from_decrease = function ()
	if not vim.g.__bars_buf_from then
		vim.g.__bars_buf_from = 1;
		return;
	end

	local utils = package.loaded["bars.utils"];

	---@type integer Number of buffers.
	local bufs = #utils.get_valid_bufs();

	if vim.g.__bars_buf_from - 1 < 1 then
		vim.g.__bars_buf_from = bufs;
	else
		vim.g.__bars_buf_from = vim.g.__bars_buf_from - 1;
	end

	pcall(vim.api.nvim__redraw, {
		flush = true,
		tabline = true
	});
end

_G.__buf_from_increase = function ()
	if not vim.g.__bars_buf_from then
		vim.g.__bars_buf_from = 1;
		return;
	end

	local utils = package.loaded["bars.utils"];

	---@type integer Number of buffers.
	local bufs = #utils.get_valid_bufs();

	if vim.g.__bars_buf_from + 1 > bufs then
		vim.g.__bars_buf_from = 1;
	else
		vim.g.__bars_buf_from = vim.g.__bars_buf_from + 1;
	end

	pcall(vim.api.nvim__redraw, {
		flush = true,
		tabline = true
	});
end

_G.__tabline_to_buf = {};

