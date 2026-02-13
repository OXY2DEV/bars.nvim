--- Dynamic highlight groups.
--- Maintainer: MD. Mouinul Hossain
local hl = {};

local function clamp (val, min, max)
	return math.max(math.min(val, max), min);
end

--- Gets attribute from highlight groups.
---@param attr string
---@param from string[]
---@return number | boolean | string | nil
hl.get_attr = function (attr, from)
	attr = attr or "bg";
	from = from or { "Normal" };

	for _, group in ipairs(from) do
		---@type table
		local _hl = vim.api.nvim_get_hl(0, {
			name = group,
			link = false, create = false
		});

		if _hl[attr] then
			return _hl[attr];
		end
	end
end

--- Chooses a color based on 'background'.
---@param light any
---@param dark any
---@return any
hl.choice = function (light, dark)
	return vim.o.background == "dark" and dark or light;
end

--- Linear-interpolation.
---@param a number
---@param b number
---@param x number
---@return number
hl.lerp = function (a, b, x)
	x = x or 0;
	return a + ((b - a) * x);
end

hl.interpolate = function (f1, f2, f3, t1, t2, t3, y)
	return hl.lerp(f1, t1, y), hl.lerp(f2, t2, y), hl.lerp(f3, t3, y);
end

------------------------------------------------------------------------------

--- Turns numeric color code to RGB
---@param num number
---@return integer
---@return integer
---@return integer
hl.num_to_rgb = function(num)
	local hex = string.format("%06x", num)
	local r, g, b = string.match(hex, "^(%x%x)(%x%x)(%x%x)");

	return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16);
end

--- Gamma correction.
---@param c number
---@return number
hl.gamma_to_linear = function (c)
	return c >= 0.04045 and math.pow((c + 0.055) / 1.055, 2.4) or c / 12.92;
end

--- Reverse gamma correction.
---@param c number
---@return number
hl.linear_to_gamma = function (c)
	return c >= 0.0031308 and 1.055 * math.pow(c, 1 / 2.4) - 0.055 or 12.92 * c;
end

--- RGB to OKLab.
---@param r number
---@param g number
---@param b number
---@return number
---@return number
---@return number
hl.rgb_to_oklab = function (r, g, b)
	local R, G, B = hl.gamma_to_linear(r / 255), hl.gamma_to_linear(g / 255), hl.gamma_to_linear(b / 255);

	local L = math.pow(0.4122214708 * R + 0.5363325363 * G + 0.0514459929 * B, 1 / 3);
	local M = math.pow(0.2119034982 * R + 0.6806995451 * G + 0.1073969566 * B, 1 / 3);
	local S = math.pow(0.0883024619 * R + 0.2817188376 * G + 0.6299787005 * B, 1 / 3);

	return
		L *  0.2119034982 + M *  0.7936177850 + S * -0.0040720468,
		L *  1.9779984951 + M * -2.4285922050 + S *  0.4505937099,
		L *  0.0259040371 + M *  0.7827717662 + S * -0.8086757660
	;
end

--- OKLab to RGB.
---@param l number
---@param a number
---@param b number
---@return number
---@return number
---@return number
hl.oklab_to_rgb = function (l, a, b)
	local L = math.pow(l + a *  0.3963377774 + b *  0.2158037573, 3);
	local M = math.pow(l + a * -0.1055613458 + b * -0.0638541728, 3);
	local S = math.pow(l + a * -0.0894841775 + b * -1.2914855480, 3);

	local R = L *  4.0767416621 + M * -3.3077115913 + S *  0.2309699292;
	local G = L * -1.2684380046 + M *  2.6097574011 + S * -0.3413193965;
	local B = L * -0.0041960863 + M * -0.7034186147 + S *  1.7076147010;

	R = clamp(255 * hl.linear_to_gamma(R), 0, 255);
	G = clamp(255 * hl.linear_to_gamma(G), 0, 255);
	B = clamp(255 * hl.linear_to_gamma(B), 0, 255);

  return R, G, B;
end

------------------------------------------------------------------------------

hl.visible_fg = function (lumen)
	local BL, BA, BB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("bg", { "Normal" }) or hl.choice(15725045, 1973806)
		)
	);

	local FL, FA, FB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("fg", { "Normal" }) or hl.choice(5001065, 13489908)
		)
	);

	if lumen < 0.5 then
		if BL > FL then
			return BL, BA, BB;
		else
			return FL, FA, FB;
		end
	else
		if BL < FL then
			return BL, BA, BB;
		else
			return FL, FA, FB;
		end
	end
end

local mode_steps = 10;
local fold_blend = 0.5;

hl.fold_level_hl = function (level, src, light, dark)
	---@type number, number, number Main color.
	local ML, MA, MB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("fg", src) or hl.choice(light, dark)
		)
	);
	---@type number, number, number Background color.
	local BL, BA, BB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("bg", { "LineNr", "Normal" }) or hl.choice(15725045, 1973806)
		)
	);

	local RL, RA, RB = hl.lerp(ML, BL, fold_blend), hl.lerp(MA, BA, fold_blend), hl.lerp(MB, BB, fold_blend);

	return {
		{
			group_name = string.format("BarsFoldClose%d", level),
			value = {
				fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(ML, MA, MB)),
			}
		},
		{
			group_name = string.format("BarsFoldOpen%d", level),
			value = {
				fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(RL, RA, RB)),
			}
		},
	};
end

hl.mode_hl = function (mode, src, light, dark)
	---@type number, number, number Main color.
	local ML, MA, MB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("fg", src) or hl.choice(light, dark)
		)
	);
	---@type number, number, number Background color.
	local BL, BA, BB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("bg", { "StatusLine", "Normal" }) or hl.choice(15725045, 1973806)
		)
	);

	local colors = {
		{
			group_name = string.format("Bars%s", mode),
			value = {
				bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(ML, MA, MB)),
				fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(
					hl.visible_fg(ML)
				)),
			}
		},
	};

	for i = 0, mode_steps - 1, 1 do
		---@type integer, integer, integer
		local gL, gA, gB = hl.interpolate(
			ML, MA, MB,
			BL, BA, BB,
			i / (mode_steps - 1)
		);

		table.insert(colors, {
			group_name = string.format("Bars%s%d", mode, i + 1),
			value = {
				fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(gL, gA, gB)),
			}
		});
	end

	return colors;
end

hl.gradient = function (prefix, src_type, from, light, dark, factor)
	---@type number, number, number Main color.
	local ML, MA, MB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr(src_type, from) or hl.choice(light, dark)
		)
	);
	---@type number, number, number Background color.
	local BL, BA, BB = hl.rgb_to_oklab(
		hl.num_to_rgb(
			hl.get_attr("bg", { "StatusLine", "Normal" }) or hl.choice(15725045, 1973806)
		)
	);

	if factor then
		ML = ML * factor;
		MA = MA * factor;
		MB = MB * factor;
	end

	local gradient = {};
	local qf_steps = 15;

	for s = 0, qf_steps - 1, 1 do
		local GL, GA, GB = hl.interpolate(
			ML, MA, MB,
			BL, BA, BB,
			s / (qf_steps - 1)
		);

		local NL, NA, NB;

		if s ~= 0 then
			NL, NA, NB = hl.interpolate(
				ML, MA, MB,
				BL, BA, BB,
				(s - 1) / (qf_steps - 1)
			);
		else
			NL, NA, NB = GL, GA, GB;
		end

		table.insert(gradient, {
			group_name = string.format("Bars%s%d", prefix, s + 1),
			value = {
				bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(GL, GA, GB)),
				fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(NL, NA, NB)),
			}
		});
	end

	table.insert(gradient, {
		group_name = string.format("Bars%s", prefix),
		value = {
			bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(ML, MA, MB)),
			fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(
				hl.visible_fg(ML)
			)),

			bold = true
		}
	});

	return gradient;
end

---@type table<string, fun(): table[]>
hl.groups = {
	fold_1 = function ()
		return hl.fold_level_hl(1, { "DiagnosticError", "Error" }, 13766457, 15961000);
	end,

	fold_2 = function ()
		return hl.fold_level_hl(2, { "@function", "Function" }, 1992437, 9024762);
	end,

	fold_3 = function ()
		return hl.fold_level_hl(3, { "DiagnosticWarn" }, 14650909, 16376495);
	end,

	fold_4 = function ()
		return hl.fold_level_hl(4, { "DiagnosticOk" }, 4235307, 10937249);
	end,

	fold_5 = function ()
		return hl.fold_level_hl(5, { "@constant", "Constant" }, 16671755, 16429959);
	end,

	fold_6 = function ()
		return hl.fold_level_hl(6, { "@module", "@property" }, 7505917, 11845374);
	end,


	special = function ()
		return {
			{
				group_name = "BarsWrap",
				value = { link = "BarsFoldClose5" }
			},
			{
				group_name = "BarsVirtual",
				value = { link = "BarsFoldClose4" }
			}
		};
	end,

	ruler = function ()
		---@type number, number, number Main color.
		local ML, MA, MB = hl.rgb_to_oklab(
			hl.num_to_rgb(
				hl.get_attr("fg", { "@function", "Function" }) or hl.choice(1992437, 9024762)
			)
		);

		return {
			{
				group_name = "BarsRuler",
				value = {
					bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(ML, MA, MB)),
					fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(hl.visible_fg(ML))),
				}
			}
		};
	end,


	normal = function ()
		return hl.mode_hl("Normal", { "@function", "Function" }, 1992437, 9024762);
	end,

	insert = function ()
		return hl.mode_hl("Insert", { "StatusLine", "Normal" }, 5001065, 13489908);
	end,

	visual = function ()
		return hl.mode_hl("Visual", { "Special" }, 15365835, 16106215);
	end,

	visual_line = function ()
		return hl.mode_hl("VisualLine", { "@conditional" }, 8927727, 13346551);
	end,

	visual_block = function ()
		return hl.mode_hl("VisualBlock", { "@constant", "Constant" }, 16671755, 16429959);
	end,

	command = function ()
		return hl.mode_hl("Command", { "DiagnosticOk" }, 4235307, 10937249);
	end,


	icons = function ()
		---@type number, number, number Background color.
		local BL, BA, BB = hl.rgb_to_oklab(
			hl.num_to_rgb(
				hl.get_attr("bg", { "StatusLine", "Normal" }) or hl.choice(15725045, 1973806)
			)
		);

		BL = BL * 1.5;
		BA = BA * 1.5;
		BB = BB * 1.5;

		local output = {};
		local map = { 1, 5, 3, 4, 2 };

		for n = 0, 6, 1 do
			local fg;

			if n == 0 then
				fg = string.format("#%02x%02x%02x", hl.num_to_rgb(
					hl.get_attr("fg", { "@comment" }) or hl.choice(8159123, 9673138)
				));
			elseif n == 6 then
				fg = string.format("#%02x%02x%02x", hl.num_to_rgb(
					hl.get_attr("fg", { "@markup.link" }) or hl.choice(7505917, 11845374)
				));
			else
				fg = string.format("#%02x%02x%02x", hl.num_to_rgb(
					hl.get_attr("fg", { string.format("BarsFoldClose%d", map[n]) }) or hl.choice(8159123, 9673138)
				));
			end

			table.insert(output, {
				group_name = string.format("BarsFt%d", n),
				value = {
					fg = fg,
					bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(BL, BA, BB)),
				}
			});
		end

		return output;
	end,

	tabline_tabs = function ()
		---@type number, number, number Main color.
		local FL, FA, FB = hl.rgb_to_oklab(
			hl.num_to_rgb(
				hl.get_attr("fg", { "StatusLine", "Normal" }) or hl.choice(5001065, 13489908)
			)
		);
		---@type number, number, number Background color.
		local BL, BA, BB = hl.rgb_to_oklab(
			hl.num_to_rgb(
				hl.get_attr("bg", { "StatusLine", "Normal" }) or hl.choice(15725045, 1973806)
			)
		);

		---@type number, number, number Tab background color.
		local TL, TA, TB = hl.interpolate(
			BL, BA, BB,
			FL, FA, FB,
			0.15
		);

		return {
			{
				group_name = "BarsNav",
				value = {
					fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(TL, TA, TB)),
				}
			},
			{
				group_name = "BarsNavLocked",
				value = {
					fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(BL, BA, BB)),
				}
			},
			{
				group_name = "BarsNavOverflow",
				value = {
					link = "BarsNav",
				}
			},
			{
				group_name = "BarsInactive",
				value = {
					bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(TL, TA, TB)),
					fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(
						hl.visible_fg(TL)
					)),
				}
			},
		};
	end,

	tabline_current = function ()
		---@type number, number, number Main color.
		local BL, BA, BB = hl.rgb_to_oklab(
			hl.num_to_rgb(
				hl.get_attr("fg", { "DiagnosticOk" }) or hl.choice(4235307, 10937249)
			)
		);

		return {
			{
				group_name = "BarsTab",
				value = {
					bg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(BL, BA, BB)),
					fg = string.format("#%02x%02x%02x", hl.oklab_to_rgb(
						hl.visible_fg(BL)
					)),
				}
			},
		};
	end,


	qf_gradient = function ()
		return hl.gradient("Quickfix", "fg", { "@constant", "Constant" }, 16671755, 16429959);
	end,

	help_gradient = function ()
		return hl.gradient("Help", "bg", { "StatusLine", "Normal" }, 15725045, 1973806, 1.5);
	end,
};

hl.setup = function ()
	local keys = vim.tbl_keys(hl.groups);
	table.sort(keys);

	for _, key in ipairs(keys) do
		local entry = hl.groups[key];

		---@type boolean, table[]?
		local can_call, val = pcall(entry);

		if can_call and val then
			for _, _hl in ipairs(val) do
				local can_set, err = pcall(vim.api.nvim_set_hl, 0, _hl.group_name, _hl.value);

				if err then
					vim.print(_hl);
				end
			end
		elseif val then
			vim.print(val);
		end
	end
end

return hl;
