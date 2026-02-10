local augroup = vim.api.nvim_create_augroup("bars.nvim", {});

---@class vim.var_accessor
---@field bars_update_cache function

-- Updates default *bars & lines* value.
-- > From: `bars.nvim`
vim.g.bars_update_cache = function()
	---|fS

	if not vim.g.bars_cached then vim.g.bars_cached = {}; end

	vim.g.bars_cached.statusline = vim.api.nvim_get_option_value("statusline", { scope = "global" });
	vim.g.bars_cached.statuscolumn = vim.api.nvim_get_option_value("statuscolumn", { scope = "global" });
	vim.g.bars_cached.winbar = vim.api.nvim_get_option_value("winbar", { scope = "global" });

	vim.g.bars_cached.tabline = vim.api.nvim_get_option_value("tabline", { scope = "global" });

	---|fE
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function ()
		vim.schedule(function ()
			vim.g.bars_update_cache();

			require("bars.global");
			require("bars.highlights").setup();

			require("bars.statusline"):start();
			require("bars.statuscolumn"):start();
			require("bars.winbar"):start();
			require("bars.tabline"):start();
		end)
	end
});

vim.api.nvim_create_autocmd("WinNew", {
	group = augroup,
	callback = function ()
		vim.schedule(function ()
			local new_win = vim.api.nvim_get_current_win();

			require("bars.statusline"):handle_new_window(new_win);
			require("bars.statuscolumn"):handle_new_window(new_win);
			require("bars.winbar"):handle_new_window(new_win);
			require("bars.tabline"):handle_new_window(new_win);
		end)
	end
});

vim.api.nvim_create_autocmd("OptionSet", {
	group = augroup,
	callback = function (event)
		local style_change = { "statusline", "statuscolumn", "tabline", "winbar" };
		local state_change = { "filetype", "buftype" };

		vim.schedule(function ()
			local event_win = vim.api.nvim_get_current_win();

			if vim.list_contains(style_change, event.match) then
				require("bars.statusline"):update_style(event_win);
				require("bars.statuscolumn"):update_style(event_win);
				require("bars.winbar"):update_style(event_win);
				require("bars.tabline"):update_style(event_win);
			elseif vim.list_contains(state_change, event.match) then
				require("bars.statusline"):handle_new_window(event_win);
				require("bars.statuscolumn"):handle_new_window(event_win);
				require("bars.winbar"):handle_new_window(event_win);
				require("bars.tabline"):handle_new_window(event_win);
			end
		end)
	end
});

vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup,
	callback = function ()
		require("bars.highlights").setup();
	end
});

vim.api.nvim_create_autocmd("ModeChanged", {
	group = augroup,
	callback = function ()
		pcall(vim.api.nvim__redraw, {
			flush = true,

			statuscolumn = true,
			winbar = true,
			tabline = true,
		});
	end
});

local commands = {
	"Disable",
	"Enable",
	"Start",
	"Stop",
	"Toggle",
	"disable",
	"enable",
	"toggle",
	"update",
};

vim.api.nvim_create_user_command("Bars", function (data)
	local command = data.fargs[1] and data.fargs[1] or "Toggle";

	if not vim.list_contains(commands, command) then
		vim.print("Not a sub-command: " .. command)
		return;
	end

	local target = data.fargs[2] and { data.fargs[2] } or nil;

	if target[1] == "?" then
		vim.ui.input({
			prompt = "Run command on target(s)?",
			default = "",
		}, function (v)
			if not v then
				return;
			end

			target = vim.split(v, " ", { trimempty = true });
			if #target == 0 then target = nil; end
		end);
	end

	local args = {};

	for a, arg in ipairs(data.fargs or {}) do
		if a > 2 then
			if pcall(tonumber, arg) then
				table.insert(args, tonumber(arg));
			else
				table.insert(args, arg);
			end
		end
	end

	if #args == 0 and not vim.list_contains({ "update" }, command) then
		args = { vim.api.nvim_get_current_win() };
	end

	require("bars").exec(command, target, unpack(args));
end, {
	desc = "Command for `bars.nvim`",
	nargs = "*",

	complete = function (leader, cmdline, cursor_pos)
		local function create_completes (list)
			local sorted = {};

			for _, item in ipairs(list or {}) do
				if leader == "" or string.match(tostring(item), "^".. leader) then
					table.insert(sorted, tostring(item));
				end
			end

			return sorted;
		end

		local before_cursor = string.sub(cmdline, 0, cursor_pos);
		local tokens = vim.split(before_cursor, " ", { trimempty = true });

		table.remove(tokens, 1);

		local current_command = tokens[1] or "";

		local targets = {
			"?",
			"all",
			"statuscolumn",
			"statusline",
			"tabline",
			"winbar",
		};

		if string.match(before_cursor, "%s$") then
			if #tokens == 0 then
				return create_completes(commands);
			elseif #tokens == 1 then
				return create_completes(targets);
			elseif #tokens == 2 and not string.match(current_command, "^[A-Z]") then
				return create_completes(vim.api.nvim_list_wins());
			end
		else
			if #tokens == 1 then
				return create_completes(commands);
			elseif #tokens == 2 then
				return create_completes(targets);
			elseif #tokens == 3 and not string.match(current_command, "^[A-Z]") then
				return create_completes(vim.api.nvim_list_wins());
			end
		end
	end,
});

