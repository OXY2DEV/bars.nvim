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

utils.constant = function (val)
	return setmetatable({}, {
		__index = function ()
			return val;
		end,
		__newindex = function () end,

		__metatable = false
	});
end

utils.get_const = function (val)
	if type(val) ~= "table" then
		return val;
	else
		return val.value;
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

return utils;
