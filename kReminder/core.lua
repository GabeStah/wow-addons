local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kReminder = LibStub("AceAddon-3.0"):NewAddon("kReminder", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0",
	"kLib-1.0",
	"kLibColor-1.0",
	"kLibComm-1.0",
	"kLibItem-1.0",
	"kLibOptions-1.0",
	"kLibTimer-1.0",
	"kLibUtility-1.0",
	"kLibView-1.0")
_G.kReminder = kReminder

function kReminder:OnEnable() end
function kReminder:OnDisable() end
function kReminder:OnInitialize()
	-- Load kLib
  -- Load Database
  self.db = LibStub("AceDB-3.0"):New("kReminderDB", self.defaults)
	-- Init Settings
	self:InitializeSettings()	
	-- Create defaults
	self:Options_Default()	
  -- Inject Options Table and Slash Commands
	-- Create options		
	self:Options_Generate()	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kReminder", self.options, {"kreminder", "kr"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.AceGUI = LibStub("AceGUI-3.0")
	-- Init Events
	self:InitializeEvents()
	self.updateFrame = CreateFrame("Frame", "kReminderUpdateFrame", UIParent);
	kReminderUpdateFrame:SetScript("OnUpdate", function(self, elapsed) 
		kReminder:OnUpdate(elapsed)
	end)
	self:InitializeTimers()
end

function kReminder:InitializeSettings()
	-- Version
	self.minRequiredVersion = '0.3.652'
	self.version = '0.3.652'

	self.actors = {}
	self.alpha = {
		disabled = 0.4,
		enabled = 1
	}
	self.color = {
		clear = {r=0, g=0, b=0, a=0},
		red = {r=1, g=0, b=0},
		green = {r=0, g=1, b=0},
		blue = {r=0, g=0, b=1},
		purple = {r=1, g=0, b=1},
		yellow = {r=1, g=1, b=0},
	}
	-- Communication settings for SendAddonMessage send/receive
	self.comm = {
		prefix = 'kReminder',
		validChannels = {'RAID', 'GUILD', 'PARTY'},
		validCommTypes = {'c', 's'}, -- c: client, s: server
	}
	self.outputs = {}	
	-- Roster initialization
	self.roster = {}
	-- Addons for sets/equipment management
	self.setAddons = {
		{
			id = 'outfitter', 
			loaded = function() -- Function to determine if addon properly loaded/is accessible
				if IsAddOnLoaded('Outfitter') and 
					Outfitter and 
					Outfitter.Settings and 
					Outfitter.Settings.Outfits and 
					Outfitter.Settings.Outfits.Complete then
					return true
				else -- Not loaded, check if disabled
					local name, _, _, enabled, _, reason = GetAddOnInfo('Outfitter')
					if name then
						if not enabled and reason == 'DISABLED' then return true end -- Return true since this addon is disabled by player
					end
				end
			end,
			name = 'Outfitter', 
		},
	}
	self.timers = {}
	self.uniqueIdLength = 8 -- Character length of unique ID strings
	self.update = {}
	self.update.core = {} -- House update script for general purpose
	self.versions = {}	
end

function kReminder:InitializeEvents()
	self:RegisterEvent('ZONE_CHANGED', 'Event_OnZoneChanged')
	self:RegisterEvent('ZONE_CHANGED_INDOORS', 'Event_OnZoneChanged')
	self:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'Event_OnZoneChanged')
end

function kReminder:InitializeTimers()

end

--[[ Process comm receiving
]]
function kReminder:OnCommReceived(prefix, serialObject, channel, sender)
	if not self:Comm_ValidatePrefix(prefix) then
		self:Error('OnCommReceived', 'Invalid prefix received, cannot continue: ', prefix)
		return
	end
	if not self:Comm_ValidateChannel(channel) then
		self:Error('OnCommReceived', 'Invalid channel received, cannot continue: ', channel)
		return
	end
	local success, command, data = self:Deserialize(serialObject)
	if success then
		local prefix, commType = self:Comm_GetPrefix(prefix)
		self:Comm_Receive(command, sender, commType, data)
	end
end

--[[ Core onUpdate function for most timer handling
]]
function kReminder:OnUpdate(elapsed)
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