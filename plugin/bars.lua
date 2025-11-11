---@diagnostic disable: undefined-field

---|fS "chore: Cache default values"

vim.g.__statusline = vim.api.nvim_get_option_value("statusline", { scope = "global" });
vim.g.__statuscolumn = vim.o.statuscolumn;
vim.g.__winbar = vim.api.nvim_get_option_value("winbar", { scope = "global" });

vim.g.__tabline = vim.o.tabline;

---|fE

--- Update the tab list when opening new windows.
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function ()
		require("bars").setup();

		require("bars.global");
		require("bars.highlights").setup();

		require("bars.statuscolumn").start();
		require("bars.statusline").start();
		require("bars.winbar").start();

		require("bars.tabline").start();
	end
});

---@type table Timer for the update task.
local timer = vim.uv.new_timer();

---@type table Timer for the update task.
local update_timer = vim.uv.new_timer();

---@type integer Debounce delay.
local DELAY = 100;

local function task ()
	---|fS

	local function callback ()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			require("bars.statusline").attach(win);
			require("bars.statuscolumn").attach(win);
			require("bars.winbar").attach(win);
		end

		--- Unstable API function.
		--- Use `pcall()`
		pcall(vim.api.nvim__redraw, {
			statuscolumn = true,
		});
	end

	if vim.in_fast_event() then
		vim.schedule(callback);
	else
		callback();
	end

	---|fE
end

local function update_task ()
	---|fS

	local function callback ()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			require("bars.statuscolumn").update_style(win);
			require("bars.statusline").update_style(win);
			require("bars.winbar").update_style(win);
		end

		--- Unstable API function.
		--- Use `pcall()`
		pcall(vim.api.nvim__redraw, {
			statuscolumn = true,
		});
	end

	if vim.in_fast_event() then
		vim.schedule(callback);
	else
		callback();
	end

	---|fE
end

--- Attach to new Windows.
---
--- Also rum this when a buffer is displayed
--- in a window as the filetype/buftype may
--- could have changed.
vim.api.nvim_create_autocmd({
	"WinNew"
}, {
	callback = function ()
		timer:stop();
		timer:start(DELAY, 0, vim.schedule_wrap(task));
	end
});

vim.api.nvim_create_autocmd({
	"OptionSet"
}, {
	callback = function (event)
		local valid = { "statusline", "statuscolumn", "tabline", "winbar" };
		local update = { "filetype", "buftype" };

		if vim.list_contains(valid, event.match) then
			timer:stop();
			timer:start(DELAY, 0, vim.schedule_wrap(task));
		elseif vim.list_contains(update, event.match) then
			update_timer:stop();
			update_timer:start(DELAY, 0, vim.schedule_wrap(update_task));
		end
	end
});

local mode_timer = vim.uv.new_timer();

--- Update various bars & lines on Vim mode change.
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	callback = function ()
		mode_timer:stop();
		mode_timer:start(DELAY, 0, vim.schedule_wrap(function ()
			pcall(vim.api.nvim__redraw, {
				statuscolumn = true,
				winbar = true,
				tabline = true
			});
		end));
	end
});

--- Update the tab list when opening new tabs.
vim.api.nvim_create_autocmd({ "TabNew" }, {
	callback = function ()
		local max = vim.g.bars_tabline_visible_tabs or 5;
		local tabs = #vim.api.nvim_list_tabpages();

		if not package.loaded["bars.tabline"] then
			return;
		elseif vim.g.__bars_tabpage_list_locked == true then
			--- List movement locked.
			return;
		elseif tabs <= max then
			return;
		end

		vim.g.bars_tablist_start = math.max(1, (tabs + 1) - max);
	end
});

--- Update the tab list when opening new windows.
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	callback = function ()
		require("bars.highlights").setup();
	end
});

----------------------------------------------------------------------

--- Custom completion for the `?` operator.
---@param before string
---@return string[]
_G.__bars_comp = function (before)
	---|fS

	local tokens = vim.split(before, " ", { trimempty = true });
	local modules = { "statusline", "statuscolumn", "tabline", "winbar" };
	local _c = {};

	if #tokens == 0 then
		return modules;
	end

	for _, item in ipairs(modules) do
		if string.match(before, "%s$") and vim.list_contains(tokens, item) == false then
			if #tokens == 0 then
				table.insert(_c, table.concat(tokens, " ") .. item);
			else
				table.insert(_c, table.concat(tokens, " ") .. " " .. item);
			end
		elseif string.match(item, tokens[#tokens]) and vim.list_contains(tokens, item) == false then
			if #tokens == 1 then
				table.insert(_c, table.concat(vim.list_slice(tokens, 1, #tokens - 1), " ") .. item);
			else
				table.insert(_c, table.concat(vim.list_slice(tokens, 1, #tokens - 1), " ") .. " " .. item);
			end
		end
	end

	table.sort(_c);
	return _c;

	---|fE
end

--- `:Bars` command implementation.
--- Usage `:Bars <action>? <operator> <window> ...`
vim.api.nvim_create_user_command("Bars", function (data)
	---|fS

	local bars = require("bars");

	local command = data.fargs[1];
	local actions = vim.tbl_keys(bars.actions);
	local windows = {};

	if #data.fargs > 2 then
		for w = 3, #data.fargs do
			local _w = vim.fn.str2nr(data.fargs[w]);

			table.insert(windows, _w ~= 0 and _w or nil);
		end
	else
		table.insert(windows, vim.api.nvim_get_current_win());
	end

	if vim.list_contains(actions, command) == false then
		--- Action not found.
		bars.actions.Toggle();
	elseif #data.fargs == 1 or data.fargs[2] == "all" then
		--- Action without arguments or with "all" operator.
		bars.actions[command](nil, windows);
	elseif data.fargs[2] == "?" then
		--- Actions with "?" operator.
		vim.ui.input({
			prompt = "Run command on module(s)?",
			default = "",

			completion = "customlist,v:lua.__bars_comp"
		}, function (input)
			local tokens = vim.split(input or "", " ", { trimempty = true });

			if #tokens == 0 then
				bars.actions[command](nil, windows);
			else
				bars.actions[command](tokens, windows);
			end
		end);
	else
		bars.actions[command]({ data.fargs[2] }, windows);
	end

	---|fE
end, {
	desc = "User command for bars.nvim",
	nargs = "*",

	complete = function (arg_lead, cmdline, cursor_pos)
		---|fS

		local bars = require("bars");

		---@type string Text before the cursor.
		local before = string.sub(cmdline, 0, cursor_pos);
		---@type string[] Tokenized version of @before.
		local tokens = vim.split(before, " ", { trimempty = true });

		if #tokens == 1 or (#tokens == 2 and arg_lead ~= "") then
			--- Sub-command/action.

			local _c = vim.tbl_filter(function (val)
				return string.match(val, arg_lead) ~= nil;
			end, vim.tbl_keys(bars.actions));

			table.sort(_c);
			return _c;
		elseif (#tokens == 2 and arg_lead == "") or (#tokens == 3 and arg_lead ~= "") then
			--- Operator.

			local _c = vim.tbl_filter(function (val)
				return string.match(val, arg_lead) ~= nil;
			end, { "all", "?", "statuscolumn", "statusline", "tabline", "winbar" });

			table.sort(_c);
			return _c;
		elseif (#tokens >= 3 and arg_lead == "") or (#tokens == 4 and arg_lead ~= "") then
			--- Window(s).

			if vim.list_contains({ "all", "?" }, tokens[3]) then
				return;
			end

			local module = package.loaded["bars." .. tokens[3]];

			if module == nil then
				return;
			end

			local _c = vim.tbl_filter(function (val)
				return vim.list_contains(tokens, tostring(val)) == false and string.match(tostring(val), arg_lead) ~= nil;
			end, vim.tbl_keys(module.state.attached_windows));

			for k, v in pairs(_c) do
				_c[k] = tostring(v);
			end

			table.sort(_c);
			return _c;
		end

		---|fE
	end
});

----------------------------------------------------------------------

