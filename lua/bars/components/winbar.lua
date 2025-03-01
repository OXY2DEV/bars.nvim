local wbC = {};
local utils = require("bars.utils");

wbC.path = function (buffer, window, main_config)
	---@type string | ""
	local name = vim.api.nvim_buf_get_name(buffer);

	if name == "" then
		return;
	else
		name = vim.fn.fnamemodify(name, ":~:.");
	end

	---@type integer
	local throttle = main_config.throttle or 50;

	---@type integer
	local before = vim.w[window].__path_time or 0;
	---@type string
	local old = vim.w[window].__path_data;
	---@type integer
	local now = vim.uv.hrtime();

	if old and (now - before) < (throttle * 1e6) then
		return old;
	end

	local sep = string.sub(package.config or "", 1, 1);

	if sep == "\\" then
		name = string.gsub(name, "^%u:", "");
	end

	---@type string[]
	local parts = vim.split(name, "/", { trimempty = true });
	local _o = "";

	while #parts > 0 do
		local part = parts[#parts];

		local part_config = utils.match(main_config, part, {});
		local is_dir = false;

		if _o ~= "" and vim.fn.fnamemodify(part, ":e") == "" then
			is_dir = true;
		end

		_o = table.concat({

			utils.create_segmant(part_config.corner_left, part_config.corner_left_hl or part_config.hl),
			utils.create_segmant(part_config.padding_left, part_config.padding_left_hl or part_config.hl),
			utils.create_segmant(is_dir == true and part_config.dir_icon or part_config.icon, (is_dir == true and part_config.dir_icon_hl or part_config.icon_hl) or part_config.hl),

			utils.create_segmant(part_config.text or part, part_config.hl),

			utils.create_segmant(part_config.padding_right, part_config.padding_right_hl or part_config.hl),
			utils.create_segmant(part_config.corner_right, part_config.corner_right_hl or part_config.hl),

			utils.create_segmant(_o ~= "" and main_config.separator or "", main_config.separator_hl),

			_o,
		});

		table.remove(parts, #parts);
	end

	vim.w[window].__path_data = _o;
	vim.w[window].__path_time = now;

	return _o;
end

--- Node under cursor
---@param buffer integer
---@param window integer
---@param main_config winbar.node
---@return string
wbC.node = function (buffer, window, main_config)
	---|fS

	local check_parsers, parser = pcall(vim.treesitter.get_parser, buffer);

	if check_parsers == false then
		return "";
	elseif parser == nil then
		return "";
	end

	local throttle = main_config.throttle or 50;

	local before = vim.w[window].__node_time or 0;
	local old = vim.w[window].__node_data;
	local now = vim.uv.hrtime();

	if old and (now - before) < (throttle * 1e6) then
		return old;
	end

    local lang_trees = parser:children();

	--- Gets the language of a Node
	---@param TSNode table
	---@return string
	local function get_language (TSNode)
		---|fS

		local row_start, _, row_end, _ = TSNode:range();

		for lang, lang_tree in pairs(lang_trees) do
			for _, tree in ipairs(lang_tree:trees()) do
				local root = tree:root()
				local root_start, _, root_end, _ = root:range();

				if row_start >= root_start and row_end <= root_end then
					return lang;
				end
			end
		end

		return parser:lang();

		---|fE
	end

	local found_node, node;

	--- BUG, When called normally `get_node()` will try
	--- to get the node of the **current window** which
	--- may not have a parser attached.
	---
	--- So, this must be called inside the window where
	--- the winbar is being drawn.
	vim.api.nvim_win_call(window, function ()
		local cursor = vim.api.nvim_win_get_cursor(window);

		found_node, node = pcall(vim.treesitter.get_node, {
			buffer = buffer,
			pos = { cursor[1] - 1, cursor[2] },

			ignore_injections = false;
		});
	end)

	if found_node == false then
		return node;
	end

	local lookup = main_config.lookup or 9;
	local _o = "";

	while node do
		---|fS

		if lookup <= 0 then
			break;
		end

		local lanuage = get_language(node);
		local lang_config = utils.match(main_config, lanuage or "default", {});

		local item_config = utils.match(lang_config, node:type(), {});
		local has_sep = true;

		if lookup == 1 then
			has_sep = false;
		elseif not node:parent() then
			has_sep = false;
		end

		local text = node:type()

		if item_config.text == "raw" then
			text = vim.treesitter.get_node_text(node, buffer);
		elseif type(item_config.text) == "string" then
			text = item_config.text;
		end

		if item_config.ignore == true then
			goto ignore;
		end

		_o = table.concat({
			has_sep == true and utils.set_hl(main_config.separator_hl) or "",
			has_sep == true and (main_config.separator or "") or "",

			utils.create_segmant(item_config.corner_left, item_config.corner_left_hl or item_config.hl),
			utils.create_segmant(item_config.padding_left, item_config.padding_left_hl or item_config.hl),
			utils.create_segmant(item_config.icon, item_config.icon_hl or item_config.hl),

			utils.create_segmant(text, item_config.hl),

			utils.create_segmant(item_config.padding_right, item_config.padding_right_hl or item_config.hl),
			utils.create_segmant(item_config.corner_right, item_config.corner_right_hl or item_config.hl),

			_o,
		});
		lookup = lookup - 1;

		::ignore::

		node = node:parent();

		---|fE
	end

	if lookup <= 0 and node then
		local lanuage = get_language(node);
		local lang_config = utils.match(main_config, lanuage or "default", {});

		local item_config = utils.match(lang_config, "__lookup", {});

		_o = table.concat({

			utils.create_segmant(item_config.corner_left, item_config.corner_left_hl or item_config.hl),
			utils.create_segmant(item_config.padding_left, item_config.padding_left_hl or item_config.hl),
			utils.create_segmant(item_config.icon, item_config.icon_hl or item_config.hl),

			utils.create_segmant(item_config.text, item_config.hl),

			utils.create_segmant(item_config.padding_right, item_config.padding_right_hl or item_config.hl),
			utils.create_segmant(item_config.corner_right, item_config.corner_right_hl or item_config.hl),

			utils.create_segmant(main_config.separator, main_config.separator_hl),

			_o,
		});
	end

	if type(main_config.max_width) == "number" then
		_o = table.concat({
			"%",
			0,
			".",
			main_config.max_width,
			"(",
			" ",
			_o,
			"%)"
		});
	end

	vim.w[window].__node_data = _o;
	vim.w[window].__node_time = now;

	return _o;

	---|fE
end

--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param part_config table
---@param winbar string
---@return string
wbC.get = function (name, buffer, window, part_config, winbar)
	---|fS

	if type(name) ~= "string" then
		--- Component doesn't exist.
		return "";
	elseif type(wbC[name]) ~= "function" then
		--- Attempting to get internal property.
		return "";
	else
		if part_config.condition ~= nil then
			if part_config.condition == false then
				--- Part is disabled.
				return "";
			else
				local sucess, val = pcall(part_config.condition, buffer, window, winbar);

				if sucess == false then
					return "";
				elseif val == false then
					return "";
				end
			end
		end

		local static_config = vim.deepcopy(part_config);

		for key, value in pairs(static_config) do
			if type(value) ~= "function" then
				goto continue;
			end

			local s_success, s_val = pcall(value, buffer, window, winbar);

			if s_success == false then
				static_config[key] = nil;
			else
				static_config[key] = s_val;
			end

			::continue::
		end

		--- Return component value.
		return wbC[name](buffer, window, static_config, winbar) or "";
	end

	---|fE
end

return wbC
