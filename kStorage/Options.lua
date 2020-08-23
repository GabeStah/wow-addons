local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kStorage = _G.kStorage
kStorage.minRequiredVersion = '0.0.100';
kStorage.version = '0.0.100';
kStorage.versions = {};

kStorage.defaults = {
	profile = {
		debug = {
			enabled = false,
			threshold = 1,
		},
		item = {
			bank = {},
			void = {},
		},
		tooltip = {
			showItemLocation = true,
			showItemQuantity = false,
		},
	},
};
kStorage.timers = {};
kStorage.threading = {};
kStorage.threading.timers = {};
kStorage.threading.timerPool = {};
-- Create Options Table
kStorage.options = {
    name = "kStorage",
    handler = kStorage,
    type = 'group',
    args = {
		description = {
			name = '',
			type = 'description',
			order = 0,
			hidden = true,
		},	
		debug = {
			name = 'Debug',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kStorage.db.profile.debug.enabled = value end,
					get = function(info) return kStorage.db.profile.debug.enabled end,
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
					set = function(info,value) kStorage.db.profile.debug.threshold = value end,
					get = function(info) return kStorage.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
		tooltip = {
			name = 'Tooltip',
			type = 'group',
			args = {
				showItemLocation = {
					name = 'Location in Tooltip',
					type = 'toggle',
					desc = 'Toggle if tooltips will show a matching item and the location (bank or void storage).',
					set = function(info,value) kStorage.db.profile.tooltip.showItemLocation = value end,
					get = function(info) return kStorage.db.profile.tooltip.showItemLocation end,
				},
				showItemQuantity = {
					name = 'Count in Tooltip',
					type = 'toggle',
					desc = 'Toggle if tooltips will show a matching item quantity..',
					set = function(info,value) kStorage.db.profile.tooltip.showItemQuantity = value end,
					get = function(info) return kStorage.db.profile.tooltip.showItemQuantity end,
				},
			},
		},
        config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kStorage.dialog:Open("kStorage") 
			end,
			guiHidden = true,
        },    
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kStorage version',
			func = function() 
				kStorage:Print("Version: |cFF"..kStorage:RGBToHex(0,255,0)..kStorage.version.."|r");
			end,
			guiHidden = true,
        },
	},
};

