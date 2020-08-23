local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = LibStub("AceAddon-3.0"):NewAddon("kMiscellaneous", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
_G.kMiscellaneous = kMiscellaneous

function kMiscellaneous:OnEnable() end
function kMiscellaneous:OnDisable() end
function kMiscellaneous:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kMiscellaneousDB", self.defaults)
	-- Init Settings
	self:InitializeSettings()	
	-- Create options		
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kMiscellaneous", self.options, {"kmiscellaneous", "kmisc", "km"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	-- Generate options
	self:Options_Generate()
	-- Init events
	self:InitializeEvents()
	self.itemsAwaitingCache = {}
end

function kMiscellaneous:InitializeSettings()
	-- Version
	self.minRequiredVersion = '0.0.100'
	self.version = '0.0.100'	

	self.color = {
		red = {r=1, g=0, b=0},
		green = {r=0, g=1, b=0},
		blue = {r=0, g=0, b=1},
		purple = {r=1, g=0, b=1},
		yellow = {r=1, g=1, b=0},
	}	
	self.grid = {}
	self.grid.config = {
		GridLayout = {
			group = 'Coordinates',
			values = {
				{
					localKey = 'x',
					remoteKey = 'PosX',
					beforeCopy = 'tostring',
					afterSave = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridLayout:RestorePosition()
						end
					end,
					afterUpdate = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridLayout:RestorePosition()
						end
					end,
					module = 'GridLayout',
				},
				{
					localKey = 'y',
					remoteKey = 'PosY',
					beforeCopy = 'tostring',
					afterSave = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridLayout:RestorePosition()
						end
					end,
					afterUpdate = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridLayout:RestorePosition()
						end
					end,
					module = 'GridLayout',
				},
				{
					localKey = 'anchor',
					remoteKey = 'anchorRel',
					beforeCopy = 'tostring',
					afterSave = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridLayout:RestorePosition()
						end
					end,
					afterUpdate = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridLayout:RestorePosition()
						end
					end,
					module = 'GridLayout',
				},
			},
		},
		GridFrame = {
			group = 'Size',
			values = {
				{
					localKey = 'width',
					remoteKey = 'frameWidth',
					afterSave = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridFrame:ResizeAllFrames()
							Grid.modules.GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
					afterUpdate = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridFrame:ResizeAllFrames()
							Grid.modules.GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
					module = 'GridFrame',
				},
				{
					localKey = 'height',
					remoteKey = 'frameHeight',
					afterSave = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridFrame:ResizeAllFrames()
							Grid.modules.GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
					afterUpdate = function()
						if kMiscellaneous:Grid_IsLoaded() then
							Grid.modules.GridFrame:ResizeAllFrames()
							Grid.modules.GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
					module = 'GridFrame',
				},
			},
		},
	}
	self.grid.formats = {
		{
			id = 'solo',
			name = 'Solo',
		},
		{
			id = 'five',
			name = '5-man',
		},
		{
			id = 'ten',
			name = '10-man',
		},
		{
			id = 'twentyfive',
			name = '25-man',
		},
	}	
	self.uniqueIdLength = 8
	self.update = {}
	self.update.core = {} -- House update script for general purpose
	self.versions = {}	
		
	-- Update Grid
	self:Grid_UpdateSettings()
	
	-- Mature language filter
	--BNSetMatureLanguageFilter(self.db.profile.cvars.matureLanguageFilterEnabled)
end

function kMiscellaneous:InitializeEvents()
	self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'Event_OnGetItemInfoReceived')
	self:RegisterEvent('LOOT_OPENED', 'Event_OnLootOpened')
	self:RegisterEvent('RAID_INSTANCE_WELCOME', 'Event_OnRaidInstanceWelcome')	
	self:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'Event_OnZoneChanged')
end

function kMiscellaneous:InitializeTimers()

end

--[[ Create debug messages
]]
function kMiscellaneous:Debug(...)
	local isDevLoaded = IsAddOnLoaded('_Dev')
	local isSpewLoaded = IsAddOnLoaded('Spew')
	local prefix ='kMisc'
	local threshold = select(select('#', ...), ...) or 3
	if type(threshold) ~= 'number' then threshold = 3 end
	if self.db.profile.debug.enabled then
		if (threshold >= kMiscellaneous.db.profile.debug.threshold) then
			if isSpewLoaded then
				Spew(prefix, ...)
			elseif isDevLoaded then
				dump(prefix, ...)
			else
				self:Print(ChatFrame1, ('%s%s'):format(prefix,...))			
			end
		end
	end
end

--[[ Output basic error messages
]]
function kMiscellaneous:Error(...)
	if not ... then return end
	self:Print(ChatFrame1, ('Error: %s'):format(strjoin(' - ', ...)))
end

--[[ Check if debug mode active
]]
function kMiscellaneous:InDebug()
	return self.db.profile.debug.enabled
end

--[[ Core onUpdate function for most timer handling
]]
function kMiscellaneous:OnUpdate(elapsed)
	if not self.db.profile.debug.enableTimers then return end
	local updateType = 'core'
	local time, i = GetTime()
	self.update[updateType].timeSince = (self.update[updateType].timeSince or 0) + elapsed
	if (self.update[updateType].timeSince > self.db.profile.settings.update[updateType].interval) then	
		-- Process timers
		self:Timer_ProcessAll(updateType)
		self.update[updateType].timeSince = 0
	end
end