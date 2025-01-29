local statusline = require("bars.statusline");

--- Changes the type of diagnostic
--- that are shown on the statusline.
_G.__change_diagnostic_state = function ()
	local mousepos = vim.fn.getmousepos();
	local window = mousepos.winid

	if vim.list_contains(statusline.state.attached_windows, window) == false then
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

