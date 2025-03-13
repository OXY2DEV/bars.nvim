local highlights = {};

--- Turns dynamic values into
--- static values.
---@param val any | fun(): any
---@return any
local to_static = function (val)
	---|fS

	if type(val) ~= "function" then
		return val;
	end

	local can_eval, eval = pcall(val);
	return can_eval and eval or nil;

	---|fE
end

--- Gets highlight attribute.
---@param groups string[]
---@param attr string
---@return boolean | integer | nil
highlights.get_attr = function (groups, attr)
	---|fS

	for _, group in ipairs(groups) do
		local hl = vim.api.nvim_get_hl(0, {
			name = group,

			link = false,
			create = false
		});

		if type(attr) == "string" and hl[attr] then
			return hl[attr];
		end
	end

	---|fE
end

--- Gets value based on background.
---@param light any
---@param dark any
---@return any
highlights.theme_value = function (light, dark)
	return vim.o.background ~= "dark" and light or dark;
end

---|fS

---@param num integer
---@return integer, integer, integer
highlights.num_to_rgb = function (num)
	local hex = string.format("%06x", num);
	local xR, xG, xB = string.match(hex, "(%x%x)(%x%x)(%x%x)");

	return tonumber(xR, 16), tonumber(xG, 16), tonumber(xB, 16);
end

---@param r integer
---@param g integer
---@param b integer
---@return number
highlights.rgb_to_lumen = function (r, g, b)
	return (math.min(r, g, b) + math.max(r, g, b)) / 2;
end

---@param r integer
---@param g integer
---@param b integer
---@return string
highlights.rgb_to_hex = function (r, g, b)
	return string.format("#%02x%02x%02x", r, g, b);
end

---@param r number
---@param g number
---@param b number
---@return number
---@return number
---@return number
highlights.rgb_to_lab = function (r, g, b)
	---|fS

	---@param _r number
	---@param _g number
	---@param _b number
	---@return number
	---@return number
	---@return number
	local function rgb_to_xyz(_r, _g, _b)
		---|fS

		local RGB = {};

		for c, channel in ipairs({ _r, _g, _b }) do
			RGB[c] = channel / 255;

			if RGB[c] <= 0.04045 then
				RGB[c] = RGB[c] / 12.92;
			else
				RGB[c] = ((RGB[c] + 0.055) / 1.055) ^ 2.4;
			end
		end

		--- Transformation matrix.
		---@type number[]
		local matrix = {
			0.4124504, 0.3575761, 0.1804375,
			0.2126729, 0.7151522, 0.0721750,
			0.0193339, 0.1191920, 0.9503041
		};

		return
			( RGB[1] * matrix[1] +  RGB[2] * matrix[2] +  RGB[3] * matrix[3] ) * 100,
			( RGB[1] * matrix[4] +  RGB[2] * matrix[5] +  RGB[3] * matrix[6] ) * 100,
			( RGB[1] * matrix[7] +  RGB[2] * matrix[8] +  RGB[3] * matrix[9] ) * 100
		;

		---|fE
	end

	---@param x number
	---@param y number
	---@param z number
	---@return number
	---@return number
	---@return number
	local function xyz_to_lab(x, y, z)
		---|fS

		--- Reference white point.
		---@type number[]
		local ref = { 95.047, 100, 108.883 };

		---@param val number
		---@param index integer
		---@return number
		local function formula(val, index)
			local t = val / ref[index];

			if t > (6 / 29) ^ 3 then
				return t ^ (1 / 3);
			else
				return ( (1 / 3) * t * ((6 / 29) ^ -2) ) + (4 / 29);
			end
		end

		return
			-16 + ( 116 * formula(y, 2) ),
			500 * ( formula(x, 1) - formula(y, 2) ),
			200 * ( formula(y, 2) - formula(z, 3) )
		;

		---|fE
	end

	return xyz_to_lab(rgb_to_xyz(r, g, b));

	---|fE
end

---@param l number
---@param a number
---@param b number
---@return number
---@return number
---@return number
highlights.lab_to_rgb = function (l, a, b)
	---|fS

	---@param _l number
	---@param _a number
	---@param _b number
	---@return number
	---@return number
	---@return number
	local function lab_to_xyz(_l, _a, _b)
		---|fS

		--- Reference white point.
		---@type number[]
		local ref = { 95.047, 100, 108.883 };

		---@param val number
		---@return number
		local function rformula(val)
			if val > (6 / 29) then
				return val ^ 3;
			else
				return 3 * ( (6 / 29) ^ 2 ) * ( val - (4 / 29) );
			end
		end

		local TMP = (_l + 16) / 116;

		return
			ref[1] * rformula(TMP + (_a / 500)),
			ref[2] * rformula(TMP),
			ref[3] * rformula(TMP - (_b / 200))
		;

		---|fE
	end

	---@param x number
	---@param y number
	---@param z number
	---@return number
	---@return number
	---@return number
	local function xyz_to_rgb(x, y, z)
		---|fS

		local XYZ = { x / 100, y / 100, z / 100 };
		local matrix = {
			3.2404542, -1.5371385, -0.4985314,
			-0.9692660, 1.8760108, 0.0415560,
			0.0556434, -0.2040259, 1.0572252
		};

		local RGB = {
			XYZ[1] * matrix[1] + XYZ[2] * matrix[2] + XYZ[3] * matrix[3],
			XYZ[1] * matrix[4] + XYZ[2] * matrix[5] + XYZ[3] * matrix[6],
			XYZ[1] * matrix[7] + XYZ[2] * matrix[8] + XYZ[3] * matrix[9],
		};

		for c, channel in ipairs(RGB) do
			if channel <= 0.0031308 then
				channel = channel * 12.92;
			else
				channel = ( 1.055 * ( channel ^ (1 / 2.4) ) ) - 0.055;
			end

			RGB[c] = math.min(math.max(channel * 255, 0), 255);
		end

		return RGB[1], RGB[2], RGB[3];

		---|fE
	end

	return xyz_to_rgb(lab_to_xyz(l, a, b));

	---|fE
end

---|fE

---@param lumen number
---@return number
---@return number
---@return number
highlights.get_nfg = function (lumen)
	---|fS

	if lumen > 1 then
		lumen = lumen / 255;
	end

	---@type integer, integer, integer
	local fR, fG, fB = highlights.num_to_rgb(
		highlights.get_attr({ "Normal" }, "fg") or
		highlights.get_attr({ "Cursor" }, "bg") or
		highlights.theme_value(
			tonumber("1e1e2e", 16),
			tonumber("1e1e2e", 16)
		)
	);

	---@type integer, integer, integer
	local bR, bG, bB = highlights.num_to_rgb(
		highlights.get_attr({ "Normal" }, "fg") or
		highlights.get_attr({ "Cursor" }, "bg") or
		highlights.theme_value(
			tonumber("1e1e2e", 16),
			tonumber("1e1e2e", 16)
		)
	);

	if lumen > 0.5 then
		return bR, bG, bB;
	else
		return fR, fG, fB;
	end

	---|fE
end

---@param r1 number
---@param g1 number
---@param b1 number
---@param r2 number
---@param g2 number
---@param b2 number
---@param y number
---@return number
---@return number
---@return number
highlights.mix = function (r1, g1, b1, r2, g2, b2, y)
	y = y > 1 and y / 100 or y;

	return
		r1 + ( (r2 - r1) * y),
		g1 + ( (g2 - g1) * y),
		b1 + ( (b2 - b1) * y)
	;
end

highlights.groups = {
	c1 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color1", "@markup.heading.1.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("D20F39", 16),
					tonumber("F38BA8", 16)
				)
			);

			---@type integer, integer, integer
			local bR, bG, bB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			---@type integer, integer, integer
			local mR, mG, mB = highlights.mix(
				bR, bG, bB,
				fR, fG, fB,
				0.5
			);

			return {
				{
					group = "BarsFoldClose1",
					value = {
						fg = highlights.rgb_to_hex(fR, fG, fB)
					}
				},
				{
					group = "BarsFoldOpen1",
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				},
			};

			---|fE
		end
	},
	c2 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color2", "@markup.heading.2.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("FE640B", 16),
					tonumber("FAB387", 16)
				)
			);

			---@type integer, integer, integer
			local bR, bG, bB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			---@type integer, integer, integer
			local mR, mG, mB = highlights.mix(
				bR, bG, bB,
				fR, fG, fB,
				0.5
			);

			return {
				{
					group = "BarsFoldClose2",
					value = {
						fg = highlights.rgb_to_hex(fR, fG, fB)
					}
				},
				{
					group = "BarsFoldOpen2",
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				},
			};

			---|fE
		end
	},
	c3 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color3", "@markup.heading.3.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("DF8E1D", 16),
					tonumber("F9E2AF", 16)
				)
			);

			---@type integer, integer, integer
			local bR, bG, bB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			---@type integer, integer, integer
			local mR, mG, mB = highlights.mix(
				bR, bG, bB,
				fR, fG, fB,
				0.5
			);

			return {
				{
					group = "BarsFoldClose3",
					value = {
						fg = highlights.rgb_to_hex(fR, fG, fB)
					}
				},
				{
					group = "BarsFoldOpen3",
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				},
			};

			---|fE
		end
	},
	c4 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color4", "@markup.heading.4.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("40A02B", 16),
					tonumber("A6E3A1", 16)
				)
			);

			---@type integer, integer, integer
			local bR, bG, bB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			---@type integer, integer, integer
			local mR, mG, mB = highlights.mix(
				bR, bG, bB,
				fR, fG, fB,
				0.5
			);

			return {
				{
					group = "BarsFoldClose4",
					value = {
						fg = highlights.rgb_to_hex(fR, fG, fB)
					}
				},
				{
					group = "BarsFoldOpen4",
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				},
			};

			---|fE
		end
	},
	c5 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color5", "@markup.heading.5.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("209FB5", 16),
					tonumber("74C7EC", 16)
				)
			);

			---@type integer, integer, integer
			local bR, bG, bB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			---@type integer, integer, integer
			local mR, mG, mB = highlights.mix(
				bR, bG, bB,
				fR, fG, fB,
				0.5
			);

			return {
				{
					group = "BarsFoldClose5",
					value = {
						fg = highlights.rgb_to_hex(fR, fG, fB)
					}
				},
				{
					group = "BarsFoldOpen5",
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				},
			};

			---|fE
		end
	},
	c6 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color5", "@markup.heading.6.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("7287FD", 16),
					tonumber("B4BEFE", 16)
				)
			);

			---@type integer, integer, integer
			local bR, bG, bB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			---@type integer, integer, integer
			local mR, mG, mB = highlights.mix(
				bR, bG, bB,
				fR, fG, fB,
				0.5
			);

			return {
				{
					group = "BarsFoldClose6",
					value = {
						fg = highlights.rgb_to_hex(fR, fG, fB)
					}
				},
				{
					group = "BarsFoldOpen6",
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				},
			};

			---|fE
		end
	},

	g1 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color1", "@markup.heading.1.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("D20F39", 16),
					tonumber("F38BA8", 16)
				)
			);

			---@type integer, integer, integer
			local tR, tG, tB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			local GRADIENT = {};
			local MAX = 10;

			for i = 0, MAX - 1 do
				---@type integer, integer, integer
				local mR, mG, mB = highlights.mix(
					fR, fG, fB,
					tR, tG, tB,
					i / (MAX - 1)
				);

				table.insert(GRADIENT, {
					group = string.format("BarsGradient1_%d", i + 1),
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				});
			end

			return GRADIENT;

			---|fE
		end
	},
	g2 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color2", "@markup.heading.2.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("FE640B", 16),
					tonumber("FAB387", 16)
				)
			);

			---@type integer, integer, integer
			local tR, tG, tB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			local GRADIENT = {};
			local MAX = 10;

			for i = 0, MAX - 1 do
				---@type integer, integer, integer
				local mR, mG, mB = highlights.mix(
					fR, fG, fB,
					tR, tG, tB,
					i / (MAX - 1)
				);

				table.insert(GRADIENT, {
					group = string.format("BarsGradient2_%d", i + 1),
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				});
			end

			return GRADIENT;

			---|fE
		end
	},
	g3 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color3", "@markup.heading.3.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("DF8E1D", 16),
					tonumber("F9E2AF", 16)
				)
			);

			---@type integer, integer, integer
			local tR, tG, tB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			local GRADIENT = {};
			local MAX = 10;

			for i = 0, MAX - 1 do
				---@type integer, integer, integer
				local mR, mG, mB = highlights.mix(
					fR, fG, fB,
					tR, tG, tB,
					i / (MAX - 1)
				);

				table.insert(GRADIENT, {
					group = string.format("BarsGradient3_%d", i + 1),
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				});
			end

			return GRADIENT;

			---|fE
		end
	},
	g4 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color4", "@markup.heading.4.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("40A02B", 16),
					tonumber("A6E3A1", 16)
				)
			);

			---@type integer, integer, integer
			local tR, tG, tB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			local GRADIENT = {};
			local MAX = 10;

			for i = 0, MAX - 1 do
				---@type integer, integer, integer
				local mR, mG, mB = highlights.mix(
					fR, fG, fB,
					tR, tG, tB,
					i / (MAX - 1)
				);

				table.insert(GRADIENT, {
					group = string.format("BarsGradient4_%d", i + 1),
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				});
			end

			return GRADIENT;

			---|fE
		end
	},
	g5 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color5", "@markup.heading.5.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("209FB5", 16),
					tonumber("74C7EC", 16)
				)
			);

			---@type integer, integer, integer
			local tR, tG, tB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			local GRADIENT = {};
			local MAX = 10;

			for i = 0, MAX - 1 do
				---@type integer, integer, integer
				local mR, mG, mB = highlights.mix(
					fR, fG, fB,
					tR, tG, tB,
					i / (MAX - 1)
				);

				table.insert(GRADIENT, {
					group = string.format("BarsGradient5_%d", i + 1),
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				});
			end

			return GRADIENT;

			---|fE
		end
	},
	g6 = {
		value = function ()
			---|fS

			---@type integer, integer, integer
			local fR, fG, fB = highlights.num_to_rgb(
				highlights.get_attr({ "Color5", "@markup.heading.6.markdown" }, "fg") or
				highlights.theme_value(
					tonumber("7287FD", 16),
					tonumber("B4BEFE", 16)
				)
			);

			---@type integer, integer, integer
			local tR, tG, tB = highlights.num_to_rgb(
				highlights.get_attr({ "LineNr" }, "bg") or
				highlights.theme_value(
					tonumber("CDD6F4", 16),
					tonumber("1E1E2E", 16)
				)
			);

			local GRADIENT = {};
			local MAX = 10;

			for i = 0, MAX - 1 do
				---@type integer, integer, integer
				local mR, mG, mB = highlights.mix(
					fR, fG, fB,
					tR, tG, tB,
					i / (MAX - 1)
				);

				table.insert(GRADIENT, {
					group = string.format("BarsGradient6_%d", i + 1),
					value = {
						fg = highlights.rgb_to_hex(mR, mG, mB)
					}
				});
			end

			return GRADIENT;

			---|fE
		end
	},
};

--- Applies highlight groups.
highlights.apply = function ()
	---|fS

	local keys = vim.tbl_keys(highlights.groups);
	table.sort(keys)

	for _, key in ipairs(keys) do
		local hl = highlights.groups[key];

		if hl.group and hl.value then
			vim.api.nvim_set_hl(
				0,
				hl.group,
				to_static(hl.value)
			);
		elseif hl.value then
			local value = to_static(hl.value);

			if vim.islist(value) then
				for _, entry in ipairs(value) do
					vim.api.nvim_set_hl(0, entry.group, entry.value);
				end
			elseif type(value) == "table" then
				vim.api.nvim_set_hl(0, value.group, value.value);
			end
		end
	end

	---|fE
end

return highlights;
