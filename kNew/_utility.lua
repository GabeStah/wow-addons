--[[
subject string: Parent string
substring string: Child string to colorize
r int: red value
g int: green value
b int: blue value
@string: colorized substring within parent string
]]
function kNew:ColorizeSubstring(subject, substring, r, g, b)
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
	local sColor = kNew:RGBToHex(r*255,g*255,b*255);
	for i = 1, strlen(subject) do
		if t[i] == true then
			sOut = sOut .. "|cFF"..sColor..strsub(subject, i, i).."|r";
		else
			sOut = sOut .. strsub(subject, i, i);
		end
	end
	if strlen(sOut) > 0 then
		return sOut;
	else
		return nil;
	end
end
function kNew:CreateColorCodes()
	if not kNew.colorHex then kNew.colorHex = {} end
	-- Color Hex codes
	kNew.colorHex['green'] = kNew:RGBToHex(0,255,0);
	kNew.colorHex['red'] = kNew:RGBToHex(255,0,0);
	kNew.colorHex['yellow'] = kNew:RGBToHex(255,255,0);
	kNew.colorHex['white'] = kNew:RGBToHex(255,255,255,1);
	kNew.colorHex['grey'] = kNew:RGBToHex(128,128,128);
	kNew.colorHex['orange'] = kNew:RGBToHex(255,165,0);
	kNew.colorHex['gold'] = kNew:RGBToHex(175,150,0);
	kNew.colorHex['test'] = kNew:RGBToHex(100,255,0);
end
--[[ Create new timer for precise timing
@param string/func f Function to execute when timer ends
@param integer t Milliseconds after which to execute timer
@param boolean [r] Indicates if timer should repeat
@param object [...] Args to pass to executing function
]]
function kNew:CreateTimer(f,t,r,...)
	local v, i;
	if type(f) == 'string' then
		kNew:Debug("CreateTimer func "..f, 1)
	end
	if r then -- repeater
		v  = {id = kNew:GetUniqueTimerId(), interval = t, func = f, rep = r, args = ...}
	else
		v  = {id = kNew:GetUniqueTimerId(), time = GetTime() + t, func = f, rep = r, args = ...}
	end
	table.insert(self.timers, v);
end
--[[

]]
function kNew:Debug(value, label, threshold)
	local isDevLoaded = IsAddOnLoaded('_Dev');
	local prefix = label and 'kNewDebug ' .. label .. ': ' or 'kNewDebug: ';
	-- CHECK IF _DEV exists
	if kNew.db.profile.debug.enabled then
		if not threshold or threshold <= kNew.db.profile.debug.threshold then
			if isDevLoaded then
				dump(prefix, value);
			else
				kNew:Print(ChatFrame1, ('%s%s'):format(prefix,value))			
			end
		end
	end
end
function kNew:GetUniqueTimerId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(self.timers) do
			if val.id == newId then
				matchFound = true;
			end
		end
		if matchFound == false then
			isValidId = true;
		end
	end
	return newId;
end
--[[
[type] string: 'raid' or other group type
@int: total group members
]]
function kNew:GetPlayerCount(type)
	type = type or 'raid';
	-- Check if post-MoP
	if self.clientBuild > 50000 then
		if type == 'raid' then
			return GetNumGroupMembers() - 1;
		else
			return GetNumSubgroupMembers() - 1;
		end
	else
		if type == 'raid' then
			return GetNumRaidMembers()
		else
			return GetNumPartyMembers()
		end	
	end
end
--[[
r int: red value
g int: green value
b int: blue value
@string: hex color string
]]
function kNew:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
--[[
subject string: target string
[delimeter] string: seperator string
@string: Split value
]]
function kNew:SplitString(subject, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( subject, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( subject, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( subject, delimiter, from  )
	end
	table.insert( result, string.sub( subject, from  ) )
	return result
end