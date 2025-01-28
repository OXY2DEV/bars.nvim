local statusline = {};
local icons = require("utils.icons");

--- Configuration table.
statusline.config = {
	ignore_filetypes = {},
	ignore_buftypes = {},

	default = {
		parts = {
			{
				kind = "mode",

				---|fS "Mode configuration"

				default = {
					padding_left = " ",
					padding_right = " ",
					-- corner_right = "",

					icon = " ",

					hl = "Palette3",
					-- corner_right_hl = "Palette3R"
				},

				["n"]    = { text = "Normal" },
				["no"]   = { text = "Normal" },
				["nov"]  = { text = "Normal" },
				["noV"]  = { text = "Normal" },
				["no"] = { text = "Normal" },

				["t"]    = { text = "Terminal" },
				["nt"]   = { text = "Terminal" },
				["ntT"]  = { text = "Terminal" },

				["v"]    = {
					icon = "󰸿 ",
					text = "Visual",

					hl = "Palette3",
					corner_right_hl = "Palette3R"
				},
				["V"]    = {
					icon = "󰹀 ",
					text = "Visual",

					hl = "Palette4",
					corner_right_hl = "Palette4R"
				},
				[""]   = {
					icon = "󰸽 ",
					text = "Visual",

					hl = "Palette5",
					corner_right_hl = "Palette5R"
				},

				-- ["vs"]   = { text = "Select" },
				-- ["Vs"]   = { text = "Select" },
				-- ["s"]  = { text = "Select" },

				["s"]    = {
					icon = "󰕠 ",
					text = "Select",

					hl = "Palette3",
					corner_right_hl = "Palette3R"
				},
				["S"]    = {
					icon = "󰕞 ",
					text = "Select",

					hl = "Palette4",
					corner_right_hl = "Palette4R"
				},
				[""]   = {
					icon = " ",
					text = "Select",

					hl = "Palette5",
					corner_right_hl = "Palette5R"
				},

				["i"]    = {
					icon = " ",
					text = "Insert",

					hl = "Palette0",
					corner_right_hl = "Palette0R"
				},
				["ic"]   = {
					icon = " ",
					text = "Completion",

					hl = "Palette0",
					corner_right_hl = "Palette0R"
				},
				["ix"]   = {
					text = "Inser8",

					hl = "Palette0",
					corner_right_hl = "Palette0R"
				},

				["R"]    = {
					icon = " ",
					text = "Replace",

					hl = "Palette2",
					corner_right_hl = "Palette2R"
				},
				["Rc"]   = {
					icon = " ",
					text = "Completion",

					hl = "Palette2",
					corner_right_hl = "Palette2R"

				},

				["c"]    = {
					icon = " ",
					text = "Command",

					hl = "Palette1",
					corner_right_hl = "Palette1R"
				},

				["r"]    = {
					text = "Prompt"
				},
				["rm"]   = {
					text = "Prompt"
				},
				["r?"]   = {
					text = "Prompt"
				},

				["!"] = {
					icon = " ",
					text = "Shell",

					hl = "Palette1I"
				},

				---|fE
			},
			{
				kind = "bufname",

				default = {
					corner_left = "",
					padding_left = " ",
					padding_right = " ",
					corner_right = " ",

					icon = "󰈔 ",

					corner_left_hl = "Normal",
					corner_right_hl = "Normal",
					hl = "Layer1"
				},

				["^$"] = {
					icon = "󰂵 ",
					text = "New file",

					hl = "Layer0"
				},

				["^fish"] = {
					icon = "󰐂 ",
					-- text = "New file",

					hl = "Layer2"
				},
			}
		}
	},
	-- ["lua"] = {
	-- 	condition = function (buffer)
	-- 		local ft = vim.bo[buffer].ft;
	-- 		return ft == "lua";
	-- 	end,
	-- 	parts = {
	-- 		{
	-- 			kind = "mode",
	--
	-- 			default = {
	-- 				padding_left = " ",
	-- 				padding_right = " ",
	-- 				icon = " ",
	--
	-- 				hl = "Special"
	-- 			},
	-- 			n = { text = "Normal" },
	-- 		}
	-- 	}
	-- }
};

statusline.state = {
	enable = true,
	attached_windows = {}
};

statusline.update_id = function (window)
	if type(window) ~= "number" then
		return;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return;
	end

	local buffer = vim.api.nvim_win_get_buf(window);

	local keys = vim.tbl_keys(statusline.config);
	local ignore = { "ignore_filetypes", "ignore_buftypes", "default" };
	table.sort(keys);

	for _, key in ipairs(keys) do
		if vim.list_contains(ignore, key) then
			goto continue;
		elseif type(statusline.config[key]) ~= "table" then
			goto continue;
		end

		local tmp = statusline.config[key];

		if tmp.condition == true then
			return key;
		elseif pcall(tmp.condition, buffer, window) and tmp.condition(buffer, window) == true  then
			return key;
		end

		::continue::
	end

	return "default";
end

statusline.match_config = function (config, text, ignore)
	config = config or {};
	ignore = ignore or {};

	local _c = config.default or {};
	local keys = vim.tbl_keys(config);
	table.sort(keys);

	for _, k in ipairs(keys) do
		if vim.list_contains(ignore, k) == false and string.match(text, k) and type(config[k]) == "table" then
			_c = vim.tbl_extend("force", _c, config[k]);
			break;
		end
	end

	return _c;
end

statusline.set_hl = function (hl)
	if type(hl) ~= "string" then
		return "";
	elseif vim.fn.hlexists(hl) == 0 then
		return "";
	else
		return string.format("%s%s#", "%#", hl);
	end
end

--- Helper module.
local H = {};

H.mode = function (_, _, config)
	config = config or {};

	local mode = vim.api.nvim_get_mode().mode;
	local m_config = config.default or {};

	if type(config[mode]) == "table" then
		m_config = vim.tbl_extend("force", m_config, config[mode]);
	end

	return table.concat({
		string.format("%s%s", statusline.set_hl(m_config.corner_left_hl or m_config.hl), m_config.corner_left or ""),
		string.format("%s%s", statusline.set_hl(m_config.padding_left_hl or m_config.hl), m_config.padding_left or ""),
		string.format("%s%s", statusline.set_hl(m_config.icon_hl or m_config.hl), m_config.icon or ""),

		string.format("%s%s", statusline.set_hl(m_config.hl), m_config.text or mode or ""),

		string.format("%s%s", statusline.set_hl(m_config.padding_right_hl or m_config.hl), m_config.padding_right or ""),
		string.format("%s%s", statusline.set_hl(m_config.corner_right_hl or m_config.hl), m_config.corner_right or ""),
	});
end

H.bufname = function (buffer, _, main_config)
	main_config = main_config or {};

	local bufname = vim.api.nvim_buf_get_name(buffer);
	local ft = {};
	local name = "";

	if bufname == "" then
		name = "";
	elseif bufname:match("^term%:%/%/") then
		local _, _, shell = bufname:match("^term%:%/%/(.-)%/(%d+)%:(.+)$");
		shell = vim.fn.fnamemodify(shell, ":t");

		name = shell;
	elseif bufname:match("%/$") then
		bufname = bufname:gsub("%\\%/", "");
		name = bufname:match("%/?(.-)%/$");
	else
		name = vim.fn.fnamemodify(bufname, ":t");
		-- ft = icons.get(vim.fn.fnamemodify(bufname, ":e"));
	end

	local config = statusline.match_config(main_config, name or "", { "default", "kind" });

	return table.concat({
		string.format("%s%s", statusline.set_hl(config.corner_left_hl or config.hl), config.corner_left or ""),
		string.format("%s%s", statusline.set_hl(config.padding_left_hl or config.hl), config.padding_left or ""),
		string.format("%s%s", statusline.set_hl(config.icon_hl or config.hl), ft.icon or config.icon or ""),

		string.format("%s%s", statusline.set_hl(config.hl), config.text or name or ""),

		string.format("%s%s", statusline.set_hl(config.padding_right_hl or config.hl), config.padding_right or ""),
		string.format("%s%s", statusline.set_hl(config.corner_right_hl or config.hl), config.corner_right or ""),
	});
end

statusline.render = function (buffer, window)
	if vim.list_contains(statusline.state.attached_windows, window) == false then
		return "";
	end

	local slID = vim.w[window].__slID;

	if not slID then
		return;
	end

	local config = statusline.config[slID];

	if type(config) ~= "table" then
		return;
	end

	local _o = "";

	for _, part in ipairs(config.parts or {}) do
		if type(part.kind) == "string" and pcall(H[part.kind], buffer, window, part) then
			_o = _o .. H[part.kind](buffer, window, part);
		end
	end

	return _o;
end

statusline.attach = function (buffer)
	if type(buffer) ~= "number" then
		return;
	elseif vim.api.nvim_buf_is_loaded(buffer) == false then
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return;
	end

	local windows = vim.fn.win_findbuf(buffer);

	for _, win in ipairs(windows) do
		if vim.list_contains(statusline.state.attached_windows) == true then
			goto continue;
		end

		local slID = statusline.update_id(win);
		table.insert(statusline.state.attached_windows, win);

		vim.w[win].__slID = slID;
		vim.wo[win].statusline = "%!v:lua.require('scripts.statusline').render(" .. buffer .. "," .. win ..")";

		::continue::
	end
end


return statusline;
