local kMacro = kMacro
local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strlen, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.len, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error, pcall = loadstring, assert, error, pcall
function kMacro:PLAYER_ENTERING_WORLD()
	RegisterAddonMessagePrefix("kMacro")
	self:Debug('PLAYER_ENTERING_WORLD')
	self:UpdateAllMacros()
	self:Options_BuildMacroOptions()
end
function kMacro:PLAYER_SPECIALIZATION_CHANGED()
	self:Debug('PLAYER_SPECIALIZATION_CHANGED()')
	self:UpdateAllMacros()
	self:Options_BuildMacroOptions()
end
function kMacro:ZONE_CHANGED()
	self:Debug('ZONE_CHANGED()')
	self:UpdateAllMacros()
	self:Options_BuildMacroOptions()
end