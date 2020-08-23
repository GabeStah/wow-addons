local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

--[[ Retrieve color
]]
function kMiscellaneous:Color_Get(r, g, b, a, returnType)
	if not r then return end
  self:Debug("Color_Get - args", r, g, b, a, returnType, 3)
	returnType = returnType or 'table'
	local color
	-- Hex?
	if self:Color_FromHex(r) then
    self:Debug("Color_Get to Color_FromHex - r", r, 3)
		color = self:Color_FromHex(r)
    self:Debug("Color_Get to Color_FromHex - out", color, 3)
	end
	-- Color table?
	if self:Color_FromTable(r) then
    self:Debug("Color_Get to Color_FromTable - r", r, 3)
		color = self:Color_FromTable(r)
    self:Debug("Color_Get to Color_FromTable - out", color, 3)
	end
	if self:Color_FromValues(r, g, b, a) then
    self:Debug("Color_Get to Color_FromValues - rgba", r, g, b, a, 3)
		color = self:Color_FromValues(r, g, b, a)
    self:Debug("Color_Get to Color_FromValues - out", color, 3)
	end
	if color then
		if returnType == 'table' then
			return color
		elseif returnType == 'hex' then
      color = self:Color_ToHex(color)
      self:Debug("Color_Get returnType == 'hex'", color, 3)
			return color
		elseif returnType == 'decimal' or returnType == 'decimals' or returnType == 'dec' then
			return r, g, b, a
		elseif returnType == 'integer' or returnType == 'integers' or returnType == 'int' then
			return self:Utility_Round(r * 255), self:Utility_Round(g * 255), self:Utility_Round(b * 255), self:Utility_Round(a * 255)
		end
	end
end

function kMiscellaneous:Color_FromHex(color)
	if not color or not (type(color) == 'string') or not (color:len() == 8 or color:len() == 6) or not color:find('^%x*$') then return end
  self:Debug("Color_FromHex - color in", color, 3)
	local r, g, b, a
	if color:len() == 8 then
		r, g, b, a = tonumber(color:sub(1, 2), 16) / 255, tonumber(color:sub(3, 4), 16) / 255, tonumber(color:sub(5, 6), 16) / 255, tonumber(color:sub(7, 8), 16) / 255
		if r >= 0.0 and r <= 1.0 and g >= 0.0 and g <= 1.0 and b >= 0.0 and b <= 1.0 and a >= 0.0 and a <= 1.0 then
		
		elseif r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 and a >= 0 and a <= 255 then
			--values are valid 0..255, convert to 0..1
			r = r / 255
			g = g / 255
			b = b / 255
			a = a / 255
		end
	else
		r, g, b, a = tonumber(color:sub(1, 2), 16) / 255, tonumber(color:sub(3, 4), 16) / 255, tonumber(color:sub(5, 6), 16) / 255, 1
		if r >= 0.0 and r <= 1.0 and g >= 0.0 and g <= 1.0 and b >= 0.0 and b <= 1.0 and a >= 0.0 and a <= 1.0 then
		
		elseif r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 and a >= 0 and a <= 255 then
			--values are valid 0..255, convert to 0..1
			r = r / 255
			g = g / 255
			b = b / 255
			a = a / 255
		end		
	end
  local out = {r = r, g = g, b = b, a = a}
  self:Debug("Color_FromHex - color out", out, 3)
	return out
end

--[[ Get color table from color table
]]
function kMiscellaneous:Color_FromTable(color)
	if not color or not (type(color) == 'table') or not color.r or not color.g or not color.b then return end
  self:Debug("Color_FromTable - color", color, 3)
	return {
		r = color.r, 
		g = color.g,
		b = color.b, 
		a = color.a or 1
	}
end

--[[ Get color table from rgba values
]]
function kMiscellaneous:Color_FromValues(r, g, b, a)
  self:Debug("Color_FromValues - Initial rgba", r, g, b, a, 3)
  if not r or not g or not b then return end
	a = tonumber(a) or 1
  local color
  self:Debug("Color_FromValues - Verified rgba", r, g, b, a, 3)
	-- Check if any > 1
	if tonumber(r) > 1 or tonumber(g) > 1 or tonumber(b) > 1 or tonumber(a) > 1 then -- Assumed 255 vals
		if a == 1 then a = 255 end
    color = {
			r = r / 255,
			g = g / 255,
			b = b / 255,
			a = a / 255,
		}
	elseif not self:Utility_IsInteger(r) or not self:Utility_IsInteger(g) or not self:Utility_IsInteger(b) or not self:Utility_IsInteger(a) then -- percentages
		color = {
			r = r,
			g = g,
			b = b,
			a = a,
		}
	else
		color = {
			r = r,
			g = g,
			b = b,
			a = a,
		}
	end
  self:Debug("Color_FromValues - Return color", color, 3)
  return color  
end

--[[ Colorize part of a string
]]
function kMiscellaneous:Color_String(subject, r, g, b, a)
  self:Debug("Color_String - subject rgba", subject, r, g, b, a, 3)
	local color = self:Color_Get(r, g, b, a, 'hex');
  self:Debug("Color_String - hex", color, 3)
  return ('|C%s%s|r'):format(color, subject)
end

--[[ Convert color to hex
]]
function kMiscellaneous:Color_ToHex(r, g, b, a)
  self:Debug("Color_ToHex - rgba", r, g, b, a, 3)
	local color = self:Color_Get(r, g, b, a)
	if not color or not (type(color) == 'table') then
    self:Debug("Color_ToHex", "type(color) invalid, not table", 3)
    return
  end
  self:Debug("Color_ToHex", color.r, color.g, color.b, color.a, 3)
	return string.format("%02x%02x%02x%02x", 
    self:Utility_Round(color.a * 255),
		self:Utility_Round(color.r * 255),
		self:Utility_Round(color.g * 255),
		self:Utility_Round(color.b * 255)
	)
end