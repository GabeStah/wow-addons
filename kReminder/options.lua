local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kReminder = _G.kReminder

kReminder.defaults = {
	profile = {
		debug = {
			enabled = false,
			enableTimers = true,
			threshold = 1,
		},
		ep = {		
			onlineCutoffPeriod = 3600,
			onlineEP = 1000,			
			punctualCutoffPeriod = 30,
			punctualEP = 200,
		},
		output = {
			enabled = true,
			channel = 'OFFICER',
			target = nil,
		},
		raids = {},
		settings = {
			update = {
				auction = {
					interval = 1,
				},
				core = {
					interval = 1,
				},
			},
			raid = {
				active = nil,
			},
		},
		zones = {
			validZones = {
				"Baradin Hold",
				"Blackrock Mountain: Blackwing Descent",
				"Firelands",
				"The Bastion of Twilight",
				"Throne of the Four Winds",
				"Dragon Soul",
				"Throne of Thunder",
			},
			zoneSelected = 1,
		},
	},
};

-- Create Options Table
kReminder.options = {
  name = "kReminder",
  handler = kReminder,
  type = 'group',
  args = {
		debug = {
			name = 'Debug',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kReminder.db.profile.debug.enabled = value end,
					get = function(info) return kReminder.db.profile.debug.enabled end,
				},
				enableTimers = {
					name = 'Enable Timers',
					type = 'toggle',
					desc = 'Toggle timer enabling',
					set = function(info,value) kReminder.db.profile.debug.enableTimers = value end,
					get = function(info) return kReminder.db.profile.debug.enableTimers end,
				},
				threshold = {
					name = 'Threshold',
					desc = 'Description for Debug Threshold',
					type = 'select',
					values = {
						[1] = 'Low',
						[2] = 'Normal',
						[3] = 'High',
					},
					style = 'dropdown',
					set = function(info,value) kReminder.db.profile.debug.threshold = value end,
					get = function(info) return kReminder.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
		config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kReminder.dialog:Open("kReminder") 
			end,
			guiHidden = true,
        },    
        raid = {
			type = 'execute',
			name = 'raid',
			desc = 'Start or stop a raid - /kl raid [keyword] - start, begin, stop, end, revert, reverse',
			func = function(...) 
				kReminder:Manual_Raid(...)
			end,
			guiHidden = true,			
		},
		ep = {
			name = 'Effort Points',
			type = 'group',
			args = {
				onlineEP = {
					name = 'Online EP',
					type = 'input',
					desc = 'Amount of EP awarded for Online EP bonus',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kReminder.db.profile.ep.onlineEP = value end,
					get = function(info) return tostring(kReminder.db.profile.ep.onlineEP) end,
					order = 1,
				},
				punctualEP = {
					name = 'Punctual EP',
					type = 'input',
					desc = 'Amount of EP awarded for Punctual EP bonus',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kReminder.db.profile.ep.punctualEP = value end,
					get = function(info) return tostring(kReminder.db.profile.ep.punctualEP) end,
					order = 2,
				},
				onlineCutoffPeriod = {
					name = 'Online Cutoff Seconds',
					type = 'input',
					desc = 'Seconds after raid start to earn Online EP',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kReminder.db.profile.ep.onlineCutoffPeriod = value end,
					get = function(info) return tostring(kReminder.db.profile.ep.onlineCutoffPeriod) end,
					order = 5,
				},					
				punctualCutoffPeriod = {
					name = 'Punctual Cutoff Seconds',
					type = 'input',
					desc = 'Seconds after raid start to earn Punctual EP',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kReminder.db.profile.ep.punctualCutoffPeriod = value end,
					get = function(info) return tostring(kReminder.db.profile.ep.punctualCutoffPeriod) end,
					order = 6,
				},				
			},
			cmdHidden = true,
		},
		output = {
			name = 'Output',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle display of Output messages',
					set = function(info,value) kReminder.db.profile.output.enabled = value end,
					get = function(info) return kReminder.db.profile.output.enabled end,
					width = 'full',					
					order = 1,
				},
				channel = {
					name = 'Channel',
					desc = 'Channel to display Output Messages',
					type = 'select',
					values = {
						SAY = 'SAY',
						EMOTE = 'EMOTE',
						YELL = 'YELL',
						PARTY = 'PARTY',
						GUILD = 'GUILD',
						OFFICER = 'OFFICER',
						RAID = 'RAID',
						RAID_WARNING = 'RAID_WARNING',
						INSTANCE_CHAT = 'INSTANCE_CHAT',
						WHISPER = 'WHISPER',
						CHANNEL = 'CHANNEL',
					},
					style = 'dropdown',
					set = function(info,value) kReminder.db.profile.output.channel = value end,
					get = function(info) return kReminder.db.profile.output.channel end,
					order = 3,
				},
				target = {
					name = 'Target',
					desc = 'Whisper Target or Custom Channel Name',
					type = 'input',
					set = function(info,value) kReminder.db.profile.output.target = value end,
					get = function(info) return kReminder.db.profile.output.target end,					
					disabled = function(i) return (kReminder.db.profile.output.channel ~= 'CHANNEL' and kReminder.db.profile.output.channel ~= 'WHISPER') end,
					order = 4,
				},
			},
			cmdHidden = true,
		},
		version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kReminder version',
			func = function() 
				kReminder:Print("Version: |cFF"..kReminder:Color_Get(0,255,0,nil,'hex')..kReminder.version.."|r");
			end,
			guiHidden = true,
    },
	},
};

--[[ Implement default settings
]]
function kReminder:Options_Default()
	-- self:Options_DefaultBidding()
	-- self:Options_DefaultRole()
end

-- --[[ Implement bidding default settings
-- ]]
-- function kReminder:Options_DefaultBidding()
-- 	-- bidTypes
-- 	for i,v in pairs(self.bidTypes) do
-- 		if not self.db.profile.bidding.sets[i] then
-- 			self.db.profile.bidding.sets[i] = {
-- 				bidType = i,
-- 				selected = false,
-- 			}
-- 		end
-- 	end
-- 	self:Options_ResetSelected(self.db.profile.bidding.sets)
-- end

-- --[[ Implement Role default settings
-- ]]
-- function kReminder:Options_DefaultRole()
-- 	local data
-- 	-- bidTypes
-- 	for i,v in pairs(self.db.profile.editors) do
-- 		-- Check if string type
-- 		if type(v) == 'string' then
-- 			data = data or {}
-- 			tinsert(data, {
-- 				player = v,
-- 				selected = false,
-- 			})
-- 		end
-- 	end
-- 	if data then
-- 		self.db.profile.editors = data
-- 		self:Options_ResetSelected(self.db.profile.editors)
-- 	end
-- end

--[[ Generate all custom options tables
]]
function kReminder:Options_Generate()
	
end