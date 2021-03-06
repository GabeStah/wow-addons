local kMacro = kMacro
local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strlen, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.len, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local INSERT_LOGIC_MACRO_SEPARATOR = '?'

function kMacro:Insert_ChangeIndex(macro, current, new)
	if not macro or not macro.inserts or current == new or new <= 0 or type(new) ~= 'number' then return end
	local storage = macro.inserts[current]
	table.remove(macro.inserts, current)
	if new > #macro.inserts then 
		table.insert(macro.inserts, storage)
	else
		table.insert(macro.inserts, new, storage)
	end
	return true
end

function kMacro:Insert_Delete(macro, index)
	if not macro.inserts then return end
	tremove(macro.inserts, index)
end

function kMacro:Insert_GetIndex(macro, index)
	if not macro.inserts then return end
	if macro.inserts[index] then return index end
	return nil
end

function kMacro:Insert_GetValue(macro, index)
	if not macro.inserts then return end
	if macro.inserts[index] then return macro.inserts[index].value end
	return nil
end

function kMacro:Insert_New(macro, value)
	if not macro.inserts then macro.inserts = {} end	
	macro.inserts[#macro.inserts+1] = {
		value = value,
	}
	return true
end

function kMacro:Insert_UpdateValue(macro, value, index)
	if not macro.inserts then return end
	if value then value = strtrim(value) end
	-- Check if value empty, delete
	if not value or strtrim(value) == '' then
		if not macro.inserts[index] then return end
		self:Insert_Delete(macro, index)
		return 'delete'
	end
	-- Check if exists
	if macro.inserts[index] then
		-- Value diff
		local currentValue = self:Insert_GetValue(macro, index)
		if currentValue and currentValue == value then
			return 'match' -- No change
		elseif currentValue and currentValue ~= value then
			macro.inserts[index].value = value
			return 'update'
		else -- No current
			macro.inserts[index].value = value
			return 'add'
		end
	else -- New
		self:Insert_New(macro, value)
		return 'new'
	end
end

function kMacro:Insert_Validate(insert)
	-- Seperator
	if not string.find(insert, INSERT_LOGIC_MACRO_SEPARATOR, 1, true) then 
		return false, 'Missing Logic-to-Macro separator question mark [?].'
	end
	-- Exists
	local data = self:GetDataTable(insert)
	if not data then return false, 'nodata' end
	-- Default
	if not self:DoesDefaultLogicExist(data) then
		return false, 'Missing Default logic indicator [d].'
	end
	-- Invalid Spec/Talent
	if self:ContainsInvalidSpecOrTalent(data) then
		return false, 'Reference to invalid Talent or Specialization index.'
	end
	-- Check for matching number Logic vs Macro
	if not (self:GetLogicCountFromData(data) == self:GetMacroCountFromData(data)) then
		return false, 'Logic:Macro ratio does not match.'
	end
	-- Invalid code
	for i,v in pairs(data) do
		local validate = self:ValidateCode(v.code)
		if type(validate) == 'string' then
			return false, 'Logic error.'
		end
	end
	return true, 'VALID INSERTION'
end