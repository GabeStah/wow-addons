local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

--[[ Check if timer should be cancelled
]]
function kMiscellaneous:Timer_Cancel(timer)
	timer = self:Timer_Get(timer)
	if not timer then
		self:Error('Timer_Cancel', 'Invalid timer, cancellation ignored.')
		return
	end	
	if timer.cancel then
		if type(timer.cancel) == 'function' then
			if timer.cancel() then
				if timer.fireOnCancel then
					self:Timer_Execute(timer)
				end
				self:Timer_Destroy(timer)
			end
		elseif type(timer.cancel) == 'string' then
			if self[timer.cancel] and self[timer.cancel]() then
				if timer.fireOnCancel then
					self:Debug('Timer_Cancel', 'FireOnCancel = true', timer.cancel, 2)
					self:Timer_Execute(timer)
				end
				self:Timer_Destroy(timer)
			end
		end
	end
end

--[[ Create and initialize a new timer
]]
function kMiscellaneous:Timer_Create(func,time,loop,cancel,fireOnCancel,...)
	if not func then return end
	-- Check if timer exists
	if self:Timer_Get(func) then return end
	if type(func) == 'string' then
		self:Debug('Timer_Create', 'New timer function: ', func, 1)
	end
	table.insert(self.timers, {
		args = ...,
		cancel = cancel,
		fireOnCancel = (type(fireOnCancel) == 'nil') and true or fireOnCancel,		
		func = func, 
		id = self:Utility_GenerateUniqueId(),
		loop = loop,
		objectType = 'timer',
		time = loop and (time or 0) or (GetTime() + time)})
end

--[[ Destroy a timer
]]
function kMiscellaneous:Timer_Destroy(timer)
	timer = self:Timer_Get(timer)
	if not timer then
		self:Error('Timer_Destroy', 'Invalid timer, destroy cancelled.')
		return
	end
	for i,v in pairs(self.timers) do
		if v.id == timer.id then
			tremove(self.timers, i)
			self:Debug('Timer_Destroy', type(timer.func) == 'string' and timer.func or '', timer.id, 3)
		end
	end
end

--[[ Execute the timer function
]]
function kMiscellaneous:Timer_Execute(timer)
	timer = self:Timer_Get(timer)
	if not timer then
		self:Error('Timer_Execute', 'Invalid timer, execution halted.')
		return
	end
	-- Check if func is string
	if type(timer.func) == 'function' then
		timer.func(unpack(timer.args) or {})
	elseif type(timer.func) == 'string' and self[timer.func] then
		if type(self[timer.func]) == 'function' then
			self:Debug('Timer_Execute', 'Executing function: ', timer.func, 1)
			self[timer.func](unpack(timer.args or {}))
		end
	end
	-- Reset elapsed if looping timer
	if timer.loop then timer.elapsed = 0 end
end

--[[ Get Timer by func name
]]
function kMiscellaneous:Timer_Get(timer)
	if not timer then return end
	if type(timer) == 'string' then
		for i,v in pairs(self.timers) do
			if v.func and v.func == timer then
				return v
			end
		end
	elseif type(timer) == 'table' and timer.objectType == 'timer' then
		return timer
	end
end

--[[ Process all timers
]]
function kMiscellaneous:Timer_ProcessAll(updateType)
	updateType = updateType or 'core'
	for i = #self.timers, 1, -1 do 
		-- Check if repeater
		if self.timers[i].loop then
			self.timers[i].elapsed = (self.timers[i].elapsed or 0) + self.update[updateType].timeSince
			if self.timers[i].elapsed >= (self.timers[i].time or 0) then
				-- Execute timer
				self:Timer_Execute(self.timers[i])
				self:Timer_Cancel(self.timers[i])
			end
		else
			if self.timers[i].time then
				if self.timers[i].time <= time then
					-- One-time exec, remove
					self:Timer_Execute(self.timers[i])
					self:Timer_Destroy(self.timers[i])
				end
			end
		end
	end
end