local utils = {};

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
			_c = vim.tbl_extend("force", _c, source[k]);
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

return utils;
