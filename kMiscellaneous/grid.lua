local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

--[[ Copy settings from Grid
]]
function kMiscellaneous:Grid_CopySettings(raidFormat)
	if not self:Grid_IsLoaded() then return end
	local layout = self:Grid_GetLayout(raidFormat)
	if not layout then return end
	-- Loop through config
	for i,v in pairs(self.grid.config) do
		-- Loop through values
		for iValue,config in pairs(v.values) do
			self:Grid_ConfigBeforeCopy(layout, config)
			self:Grid_ConfigAfterCopy(layout, config)		
		end
	end
end

--[[ Retrieve the layout for the specified format
]]
function kMiscellaneous:Grid_GetLayout(raidFormat)
	if not self:Grid_IsLoaded() then return end
	if not raidFormat or not self.db.profile.grid.layout[raidFormat] then return end
	return self.db.profile.grid.layout[raidFormat]
end

--[[ Retrieve the Grid db profile
]]
function kMiscellaneous:Grid_GetGridProfile(module)
	if not self:Grid_IsLoaded() then return end
	module = module or 'GridLayout'
	return Grid.modules[module].db.profile
end

--[[ Get the raid size as appropriate to the position settings
]]
function kMiscellaneous:Grid_GetRaidFormat()
	local name, instanceType, difficultyID, difficultyName, maxPlayers = GetInstanceInfo()
	local instanceTypes = {
		'scenario',
		'party',
		'raid',
		'arena',
		'pvp',
	}
	local sizes = {
		solo = {
			min = 1,
			max = 1,
		},
		five = {
			min = 2,
			max = 5,
		},
		ten = {
			min = 6,
			max = 10,
		},
		twentyfive = {
			min = 11,
			max = 25,
		},
	}
	if not tContains(instanceTypes, instanceType) then -- Assume none which is solo
		return 'solo'
	end
	-- Check maxplayers for matching sizes entry
	for size,entry in pairs(sizes) do
		if (maxPlayers >= entry.min) and (maxPlayers <= entry.max) then
				-- Size match found, return
			return size
		end
	end
	-- If no maxplayers entry found, check for current players within valid sizes
	local currentPlayers = self:Utility_GetPlayerCount()
	for size,entry in pairs(sizes) do
		if (currentPlayers >= entry.min) and (currentPlayers <= entry.max) then
			-- Size match found, return
			return size
		end
	end
	return 'solo'
end

--[[ Retrieve a saved setting
]]
function kMiscellaneous:Grid_GetSetting(raidFormat, key)
	if not self:Grid_IsLoaded() then return end
	local layout = self:Grid_GetLayout(raidFormat)
	if not layout then return end
	return layout[key]
end

--[[ Check if Grid is loaded
]]
function kMiscellaneous:Grid_IsLoaded()
	if not IsAddOnLoaded('Grid') then return end
	if not Grid or not Grid.modules or not Grid.modules.GridLayout or not Grid.modules.GridFrame then return end
	return true
end

--[[ Retrieve the config data table from settings
]]
function kMiscellaneous:Grid_GetConfig(key)
	if not self:Grid_IsLoaded() then return end	
	for iConfig,vConfig in pairs(self.grid.config) do
		-- Loop through values
		for iValue,data in pairs(vConfig.values) do
			if data.localKey == key then
				return data
			end
		end
	end	
end

--[[ Process afterCopy
]]
function kMiscellaneous:Grid_ConfigAfterCopy(layout, config)
	-- Check if afterCopy exists
	if config.afterCopy then
		if type(config.afterCopy) == 'function' then -- Func
			config.afterCopy(layout[config.localKey])
		elseif type(config.afterCopy) == 'string' and self[config.beforeCopy] then -- Local
			self[config.afterCopy](layout[config.localKey])
		elseif type(config.afterCopy) == 'string' then -- Assume global
			_G[config.afterCopy](layout[config.localKey])
		end
	end	
end

--[[ Process afterSave
]]
function kMiscellaneous:Grid_ConfigAfterSave(config, value)
	if not config or not type(config) == 'table' then return end
	-- Check if afterSave
	if config.afterSave then
		if type(config.afterSave) == 'function' then -- Func
			config.afterSave(value)
		elseif type(config.afterSave) == 'string' and self[config.afterSave] then -- Local
			self[config.afterSave](value)
		elseif type(config.afterSave) == 'string' then -- Assume global
			_G[config.afterSave](value)
		end
	end	
end

--[[ Process afterUpdate
]]
function kMiscellaneous:Grid_ConfigAfterUpdate(config)
	local profile = self:Grid_GetGridProfile(config.module)
	if not config or not type(config) == 'table' or not profile then return end
	-- Check if afterUpdate
	if config.afterUpdate then
		if type(config.afterUpdate) == 'function' then -- Func
			config.afterUpdate(profile[config.remoteKey])
		elseif type(config.afterUpdate) == 'string' and self[config.afterUpdate] then -- Local
			self[config.afterUpdate](profile[config.remoteKey])
		elseif type(config.afterUpdate) == 'string' then -- Assume global
			_G[config.afterUpdate](profile[config.remoteKey])
		end
	end	
end

--[[ Process beforeCopy
]]
function kMiscellaneous:Grid_ConfigBeforeCopy(layout, config)
	local profile = self:Grid_GetGridProfile(config.module)
	if not config or not type(config) == 'table' or not layout or not type(layout) == 'table' or not profile then return end
	if config.beforeCopy then
		if type(config.beforeCopy) == 'function' then -- Func
			layout[config.localKey] = config.beforeCopy(profile[config.remoteKey])
		elseif type(config.beforeCopy) == 'string' and self[config.beforeCopy] then -- Local
			layout[config.localKey] = self[config.beforeCopy](profile[config.remoteKey])
		elseif type(config.beforeCopy) == 'string' then -- Assume global
			layout[config.localKey] = _G[config.beforeCopy](profile[config.remoteKey])
		end
	else
		-- Update localKey from remoteKey
		layout[config.localKey] = profile[config.remoteKey]
	end
end

--[[ Process beforeSave
]]
function kMiscellaneous:Grid_ConfigBeforeSave(layout, config, value)
	if not config or not type(config) == 'table' or not layout or not type(layout) == 'table' or not value then return end
	if config.beforeSave then
		if type(config.beforeSave) == 'function' then -- Func
			layout[config.localKey] = config.beforeSave(value)
		elseif type(config.beforeSave) == 'string' and self[config.beforeSave] then -- Local
			layout[config.localKey] = self[config.beforeSave](value)
		elseif type(config.beforeSave) == 'string' then -- Assume global
			layout[config.localKey] = _G[config.beforeSave](value)
		end
	else
		layout[config.localKey] = value
	end
end

--[[ Process beforeUpdate
]]
function kMiscellaneous:Grid_ConfigBeforeUpdate(config, value)
	local profile = self:Grid_GetGridProfile(config.module)
	if not config or not type(config) == 'table' or not profile then return end
	if config.beforeUpdate then
		if type(config.beforeUpdate) == 'function' then -- Func
			profile[config.remoteKey] = config.beforeUpdate(value)
		elseif type(config.beforeUpdate) == 'string' and self[config.beforeUpdate] then -- Local
			profile[config.remoteKey] = self[config.beforeUpdate](value)
		elseif type(config.beforeUpdate) == 'string' then -- Assume global
			profile[config.remoteKey] = _G[config.beforeUpdate](value)
		end
	else
		profile[config.remoteKey] = value
	end
end

function kMiscellaneous:Grid_SaveSetting(raidFormat, key, value)
	if not self:Grid_IsLoaded() then return end
	local layout = self:Grid_GetLayout(raidFormat)
	local config = self:Grid_GetConfig(key)
	if not layout or not config then return end
	-- Update local database
	self:Grid_ConfigBeforeSave(layout, config, value)
	-- Process afterSave
	self:Grid_ConfigAfterSave(config, value)
	-- Update if necessary
	self:Grid_UpdateSettings()
end

--[[ Update Grid profile settings to match saved values for current layout format
]]
function kMiscellaneous:Grid_UpdateSettings()
	if not self:Grid_IsLoaded() then return end
	if not self.db.profile.grid.layout.enabled then return end
	local layout = self:Grid_GetLayout(self:Grid_GetRaidFormat())
	self:Debug('Grid_UpdateSettings', 'layout: ', layout, 3)
	if not layout then return end
	
	-- Loop through config
	for i,v in pairs(self.grid.config) do
		-- Loop through values
		for iValue,config in pairs(v.values) do
			-- Update Grid database
			self:Grid_ConfigBeforeUpdate(config, layout[config.localKey])
			-- Process afterUpdate
			self:Grid_ConfigAfterUpdate(config)
		end
	end
end