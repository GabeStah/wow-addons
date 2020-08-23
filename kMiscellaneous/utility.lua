local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

--[[ Colorize part of a string
]]
function kMiscellaneous:Utility_ColorizeSubstringInString(subject, substring, r, g, b)
	local t = {};
	for i = 1, strlen(subject) do
		local iStart, iEnd = string.find(strlower(subject), strlower(substring), i, strlen(substring) + i - 1)
		if iStart and iEnd then
			for iTrue = iStart, iEnd do
				t[iTrue] = true;
			end
		else
			if not t[i] then
				t[i] = false;
			end
		end
	end
	local sOut = '';
	local sColor = self:Color_Get(r*255,g*255,b*255, nil, 'hex');
	for i = 1, strlen(subject) do
		if t[i] == true then
			sOut = ('%s|CFF%s%s|r'):format(sOut, sColor, strsub(subject, i, i))
		else
			sOut = ('%s%s'):format(sOut, strsub(subject, i, i))
		end
	end
	return strlen(sOut) > 0 and sOut or nil
end

--[[ Destroy all entries in a table, preserving table memory slot
]]
function kMiscellaneous:Utility_DestroyTable(table)
	for i,v in pairs(table) do table[i] = nil end
end

--[[ Generate a unique identifier
]]
function kMiscellaneous:Utility_GenerateUniqueId()
	local id = {}
	local characters = {
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 
		'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 
		's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', 
		'1', '2', '3', '4', '5', '6', '7', '8', '9'
	}
	local singlet
	for i=1,self.uniqueIdLength or 8 do
		case = math.random(1,2)
		char = math.random(1,#characters)
		if case == 1 then
			singlet = string.upper(characters[char])
		else
			singlet = characters[char]
		end
		table.insert(id, case == 1 and string.upper(characters[char]) or characters[char])
	end
	return(table.concat(id))
end	

--[[ Calculate copper from looting slot
]]
function kMiscellaneous:Utility_GetCoinsFromLootString(name, quantity, returnType)
	if not name or (quantity and type(quantity) == 'number' and quantity > 0) then return end
	returnType = returnType or 'copper'
	local coinTypes = {'Gold', 'Silver', 'Copper'}
	local coinTypeValues = {
		Gold = 10000,
		Silver = 100,
		Copper = 1,
	}
	local totalCopper
	if quantity == 0 and (string.find(name,'Gold') or string.find(name,'Silver') or string.find(name,'Copper')) then
		-- Coins
		local coinage = {}
		local coin1, coin2, coin3 = strsplit('\n', name)
		if coin1 then tinsert(coinage, coin1) end
		if coin2 then tinsert(coinage, coin2) end
		if coin3 then tinsert(coinage, coin3) end
		for _, coinString in ipairs(coinage) do
			for _, denomination in ipairs(coinTypes) do
				if string.find(coinString, denomination) then					
					local startPos, endPos = string.find(coinString, '(%d+)')
					if startPos then
						totalCopper = (totalCopper or 0) + (coinTypeValues[denomination] * tonumber(string.sub(coinString, startPos, endPos)))
					end
				end
			end
		end
	end
	if returnType == 'gold' then
		return self:Utility_Round(totalCopper / 10000, 2)
	elseif returnType == 'silver' then
		return self:Utility_Round(totalCopper / 100, 2)
	else -- copper
		return totalCopper
	end
end

--[[ Retrieve the player count in the party
]]
function kMiscellaneous:Utility_GetPlayerCount()
	return (GetNumGroupMembers() > 0) and GetNumGroupMembers() or 1
end

--[[ Retrieve specialization list for player
]]
function kMiscellaneous:Utility_GetSpecializations()
	local specs
	for i=1,GetNumSpecializations() do
		local id, name, description, icon, background, role = GetSpecializationInfo(i)
		specs = specs or {}
		if name then
			tinsert(specs, {
				name = name,
				icon = icon,
				role = role,
			})
		end
	end
	return specs
end

--[[ Retrieve the X entry of a non-indexed table
]]
function kMiscellaneous:Utility_GetTableEntry(data, num, getIndex)
	if not data or not type(data) == 'table' then return end
	num = num or 1
	local count = 0
	for i,v in pairs(data) do
		count = count + 1
		if num == count then
			if getIndex then return i else return v end
		end
	end
end

--[[ Determine if number if integer (whole)
]]
function kMiscellaneous:Utility_IsInteger(value)
	return math.floor(value) == value
end

--[[ Determine if player name is current player
]]
function kMiscellaneous:Utility_IsSelf(player)
	return (UnitName(player) == UnitName('player'))
end

--[[ Round a number
]]
function kMiscellaneous:Utility_Round(value, decimal)
	if (decimal) then
		return math.floor((value * 10^decimal) + 0.5) / (10^decimal)
	else
		return math.floor(value+0.5)
	end
end

--[[ Split a string into a table
]]
function kMiscellaneous:Utility_SplitString(subject, delimiter)
	local result
	local from  = 1
	local delim_from, delim_to = string.find( subject, delimiter, from  )
	while delim_from do
		result = result or {}
		table.insert( result, string.sub( subject, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( subject, delimiter, from  )
	end
	table.insert( result, string.sub( subject, from  ) )
	return result
end

--[[ Get difference in timestamps
]]
function kMiscellaneous:Utility_TimestampDiff(time1, time2, interval)
	if not time1 then return end
	interval = interval or 'second'	
	time2 = time2 or time()
	if not (type(time1) == 'number') then time1 = tonumber(time1) end	
	if not (type(time2) == 'number') then time2 = tonumber(time2) end	
	local diff = time2 - time1
	if interval == 'second' then
		return diff
	elseif interval == 'minute' then
		return diff / 60
	elseif interval == 'hour' then
		return diff / (60*60)
	elseif interval == 'day' then
		return diff / (60*60*24)
	end
end