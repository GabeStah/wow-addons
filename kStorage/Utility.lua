local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kStorage = _G.kStorage
function kStorage:ColorizeSubstringInString(subject, substring, r, g, b)
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
	local sColor = self:RGBToHex(r*255,g*255,b*255);
	for i = 1, strlen(subject) do
		if t[i] == true then
			sOut = ('%s|CFF%s%s|r'):format(sOut, sColor, strsub(subject, i, i))
		else
			sOut = ('%s%s'):format(sOut, strsub(subject, i, i))
		end
	end
	return strlen(sOut) > 0 and sOut or nil
end
function kStorage:GetPlayerCount(type)
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
function kStorage:CreateTimer(f,t,r,...)
	local v, i;
	if type(f) == 'string' then
		kStorage:Debug("CreateTimer func "..f, 1)
	end
	if r then -- repeater
		v  = {id = self:GetUniqueTimerId(), interval = t, func = f, rep = r, args = ...}
	else
		v  = {id = self:GetUniqueTimerId(), time = GetTime() + t, func = f, rep = r, args = ...}
	end
	table.insert(self.timers, v);
end
function kStorage:Debug(...)
	local isDevLoaded = IsAddOnLoaded('_Dev');
	local prefix ='kStorageDebug: ';
	-- CHECK IF _DEV exists
	if self.db.profile.debug.enabled then
		--if not threshold or threshold <= kStorage.db.profile.debug.threshold then
			if isDevLoaded then
				dump(prefix, ...);
			else
				self:Print(ChatFrame1, ('%s%s'):format(prefix,...))			
			end
		--end
	end
end
function kStorage:OnUpdate(index, elapsed)
	local time, i = GetTime();
	for i = #self.timers, 1, -1 do 
		-- Check if repeater
		if self.timers[i].rep then
			self.timers[i].elapsed = (self.timers[i].elapsed or 0) + elapsed;
			if self.timers[i].elapsed >= (self.timers[i].interval or 0) then
				local cancelTimer = false;
				-- Check if func is string
				if type(self.timers[i].func) == 'function' then
					if self.timers[i].args then
						cancelTimer = self.timers[i].func(unpack(self.timers[i].args));
					else
						cancelTimer = self.timers[i].func();
					end
				else
					if self.timers[i].args then
						cancelTimer = self[self.timers[i].func](unpack(self.timers[i].args));
					else
						cancelTimer = self[self.timers[i].func]();
					end
				end
				self.timers[i].elapsed = 0;
				-- Check if cancel required
				if cancelTimer then
					self:Debug("REMOVE FUNC", 1)
					tremove(self.timers, i)
				end
			end
		else
			if self.timers[i].time then
				if self.timers[i].time <= time then
					-- One-time exec, remove
					if type(self.timers[i].func) == 'function' then
						if self.timers[i].args then
							self.timers[i].func(unpack(self.timers[i].args));
						else
							self.timers[i].func();
						end
					else
						if self.timers[i].args then
							self[self.timers[i].func](unpack(self.timers[i].args));
						else
							self[self.timers[i].func]();
						end
					end
					tremove(self.timers, i)
				end
			end
		end
	end
end
function kStorage:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kStorage:SplitString(subject, delimiter)
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
