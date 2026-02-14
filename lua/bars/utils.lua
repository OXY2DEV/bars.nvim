local utils = {};

utils.clamp = function (value, min, max)
	return math.min(math.max(value, min), max);
end

utils.lerp = function (f, t, y)
	return f + ((t - f) * y);
end

--- Aligns text.
---@param alignment "left" | "center" | "right"
---@param text string
---@param width integer
---@return string
utils.align = function (alignment, text, width)
	text = tostring(text);
	width = width or vim.o.columns or 10;
	alignment = alignment or "left";

	local tW = vim.fn.strdisplaywidth(text);

	if alignment == "right" then
		return string.format(
			"%s%s",

			string.rep(" ", width - tW),
			text
		);
	elseif alignment == "center" then
		return string.format(
			"%s%s%s",

			string.rep(" ", math.ceil(width - tW) / 2),
			text,
			string.rep(" ", math.floor(width - tW) / 2)
		);
	else
		return string.format(
			"%s%s",

			text,
			string.rep(" ", width - tW)
		);
	end
end

--- Matches a configuration from the
--- {source}.
---@param source { [string]: any }
---@param text string
---@param ignore string[]
---@return any
utils.match = function (source, text, ignore)
	source = source or {};
	ignore = ignore or {};

	local _c = source.default or {};
	local keys = vim.tbl_keys(source);
	table.sort(keys);

	for _, k in ipairs(keys) do
		if vim.list_contains(ignore, k) then
			goto continue;
		elseif string.match(text, k) == nil or type(source[k]) ~= "table" then
			goto continue;
		else
			_c = vim.tbl_deep_extend("force", _c, source[k]);
			break;
		end

		--- In case we need to update anything

	    ::continue::
	end

	return _c;
end

--- Creates a highlight group
--- applier.
---@param hl string?
---@return string
utils.set_hl = function (hl)
	if type(hl) ~= "string" then
		return "";
	elseif vim.fn.hlexists(hl) == 0 then
		return "";
	else
		return string.format("%s%s#", "%#", hl);
	end
end

--- Creates a statusline/statuscolumn/winbar/table segment.
---@param text string | nil
---@param hl string | nil
---@return string
utils.create_segmant = function (text, hl)
	---|fS

	if not text then
		return "";
	elseif not hl or not utils.set_hl(hl) then
		return text;
	else
		return utils.set_hl(hl) .. text;
	end

	---|fE
end

--- Gets the list of valid buffers
---@return integer[]
utils.get_valid_bufs = function ()
	local bufs = vim.api.nvim_list_bufs();
	local _b = {};

	for _, buf in ipairs(bufs) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].bt == "" then
			table.insert(_b, buf);
		end
	end

	return _b;
end

--- Creates click handler to go to specific buffer.
---@param buffer integer
utils.create_buffer_click_handler = function (buffer)
	if type(_G.bars_tabline_to_buffer) ~= "table" then
		_G.bars_tabline_to_buffer = {};
	end

	_G.bars_tabline_to_buffer["b" .. buffer] = function ()
		if vim.api.nvim_buf_is_valid(buffer) == false then
			return;
		elseif #vim.fn.win_findbuf(buffer) > 0 then
			vim.api.nvim_set_current_win(vim.fn.win_findbuf(buffer)[1]);
		else
			vim.api.nvim_set_current_buf(buffer);
		end
	end
end

--- Component-style path truncation.
---@param path string
---@param opts table
---@return string
utils.truncate_path = function (path, opts)
	local default_opts = {
		existing_paths = {},
		raw_segmants = {},
		rewrite_segmants = {},

		length = 1
	};

	local function match (text)
		local keys = vim.tbl_keys(opts.rewrite_segmants);
		table.sort(keys);

		for _, k in ipairs(keys) do
			if string.match(text, k) ~= nil then
				return opts.rewrite_segmants[k];
			end
		end
	end

	path = path or "";

	if type(opts) == "table" then
		opts = vim.tbl_deep_extend("force", default_opts, opts);
	else
		opts = default_opts;
	end

	--- Break the path into components.
	---@type string[]
	local path_components = vim.split(path, "/", { trimempty = true });
	local _o;

	while _o == nil or vim.tbl_contains(opts.existing_paths, _o) do
		---@type string
		local component = table.remove(path_components);
		local rewrite = match(component);

		if rewrite then
			local is_callable, rename = pcall(rewrite, component);

			if is_callable == true and type(rename) == "string" then
				component = rename;
			elseif type(rewrite) == "string" then
				component = rewrite;
			end
		elseif _o ~= nil and vim.list_contains(opts.raw_segmants, component) == false then
			if string.match(component, "^%.") then
				component = vim.fn.strcharpart(component, 0, opts.length + 1);
			else
				component = vim.fn.strcharpart(component, 0, opts.length);
			end
		end

		_o = table.concat({
			component,
			_o ~= nil and "/" or "",
			_o or ""
		})
	end

	return _o;
end

return utils;
