local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

kMiscellaneous.defaults = {
	profile = {
		cvars = {
			matureLanguageFilterEnabled = false,
		},
		tally = {
			enabled = false,
			lists = {},
		},
		debug = {
			enabled = false,
			enableTimers = true,
			threshold = 1,
		},
		grid = {
			layout = {
				enabled = true,
				five = {
					anchor = 'TOPLEFT',				
					x = '512',
					y = '-646',
					width = 75,
					height = 38,
				},
				solo = {
					anchor = 'TOPLEFT',				
					x = '512',
					y = '-646',
					width = 75,
					height = 38,
				},
				ten = {
					anchor = 'TOPLEFT',
					x = '512',
					y = '-646',
					width = 75,
					height = 38,
				},
				twentyfive = {
					anchor = 'TOPLEFT',
					x = '307',
					y = '-374',
					width = 75,
					height = 38,
				},
			},
		},
	},
};
kMiscellaneous.timers = {}
kMiscellaneous.threading = {}
kMiscellaneous.threading.timers = {}
kMiscellaneous.threading.timerPool = {}
-- Create Options Table
kMiscellaneous.options = {
    name = "kMiscellaneous",
    handler = kMiscellaneous,
    type = 'group',
    args = {
		grid = {
			name = 'Grid',
			type = 'group',
			args = {
				layout = {
					name = 'Grid Layout',
					type = 'group',
					args = {
						enabled = {
							name = 'Enable',
							type = 'toggle',
							desc = 'Toggle Grid auto-layout configurations.',
							set = function(info,value) 
								kMiscellaneous.db.profile.grid.layout.enabled = value
								kMiscellaneous:Grid_UpdateSettings()
							end,
							get = function(info) return kMiscellaneous.db.profile.grid.layout.enabled end,
						},
					},
				},
			},
		},
		debug = {
			name = 'Debug',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kMiscellaneous.db.profile.debug.enabled = value end,
					get = function(info) return kMiscellaneous.db.profile.debug.enabled end,
				},
				enableTimers = {
					name = 'Enable Timers',
					type = 'toggle',
					desc = 'Toggle timer enabling',
					set = function(info,value) kMiscellaneous.db.profile.debug.enableTimers = value end,
					get = function(info) return kMiscellaneous.db.profile.debug.enableTimers end,
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
					set = function(info,value) kMiscellaneous.db.profile.debug.threshold = value end,
					get = function(info) return kMiscellaneous.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
		cvars = {
			name = 'Cvars',
			type = 'group',
			args = {
				matureLanguageFilterEnabled = {
					name = 'Mature Language Filter',
					type = 'toggle',
					desc = 'Toggle Mature Language Filter.',
					set = function(info,value)
						kMiscellaneous.db.profile.cvars.matureLanguageFilterEnabled = value
						BNSetMatureLanguageFilter(kMiscellaneous.db.profile.cvars.matureLanguageFilterEnabled)
					end,
					get = function(info) return kMiscellaneous.db.profile.cvars.matureLanguageFilterEnabled end,
				},					
			},
		},		
        config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kMiscellaneous.dialog:Open("kMiscellaneous") 
			end,
			guiHidden = true,
        },
		tally = {
			name = 'Tally',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Loot Tally tracking mode.',
					set = function(info,value) kMiscellaneous.db.profile.tally.enabled = value end,
					get = function(info) return kMiscellaneous.db.profile.tally.enabled end,
					order = 1,
				},
				new = {
					name = 'New',
					type = 'execute',
					desc = function()
						return 'Generate New tally counters.'
					end,
					func = function()
						kMiscellaneous:Tally_New()
						kMiscellaneous:Print('New Tally generated.')						
					end,
					order = 2,
				},
				report = {
					name = 'Report',
					type = 'execute',
					desc = function()
						return 'Report Tally data.'
					end,
					func = function()
						kMiscellaneous:Tally_Report()
					end,
					order = 3,
				},
			},
		},		
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kMiscellaneous version',
			func = function() 
				kMiscellaneous:Print("Version: |cFF"..kMiscellaneous:Color_Get(0,255,0,nil,'hex')..kMiscellaneous.version.."|r");
			end,
			guiHidden = true,
        },
	},
};

--[[ Create Grid options
]]
function kMiscellaneous:Options_GenerateGridOptions()
	for iSize,raidFormat in pairs(self.grid.formats) do
		kMiscellaneous.options.args.grid.args.layout.args[raidFormat.id] = {
			name = raidFormat.name,
			type = 'group',
			args = {},
		}	
		for iConfig,vConfig in pairs(self.grid.config) do
			kMiscellaneous.options.args.grid.args.layout.args[raidFormat.id].args[vConfig.group] = {
				name = vConfig.group,
				type = 'header',
			}
			for iValue,data in pairs(vConfig.values) do
				-- X/Y
				if data.localKey == 'x' or data.localKey == 'y' then
					kMiscellaneous.options.args.grid.args.layout.args[raidFormat.id].args[data.localKey] = {
						name = ('%s coordinate'):format(data.localKey),
						desc = ('Default %s coordinate for %s configuration.'):format(data.localKey, raidFormat.name),
						type = 'input',
						set = function(info,value)
							kMiscellaneous:Grid_SaveSetting(raidFormat.id, data.localKey, value)
						end,
						get = function(info) return kMiscellaneous:Grid_GetSetting(raidFormat.id, data.localKey) end,
						pattern = '^[+-]?%d+$',
						usage = ('Requires a valid integer for the %s coord of Grid.'):format(data.localKey),
					}
				end
				if data.localKey == 'width' or data.localKey == 'height' then
					kMiscellaneous.options.args.grid.args.layout.args[raidFormat.id].args[data.localKey] = {
						name = ('Frame %s'):format(data.localKey),
						desc = ('Default frame %s for %s configuration.'):format(data.localKey, raidFormat.name),
						type = 'range', min = 10, max = 100, step = 1,
						set = function(info,value)
							kMiscellaneous:Grid_SaveSetting(raidFormat.id, data.localKey, value)
						end,
						get = function(info) return kMiscellaneous:Grid_GetSetting(raidFormat.id, data.localKey) end,
					}
				end
				if data.localKey == 'anchor' then
					kMiscellaneous.options.args.grid.args.layout.args[raidFormat.id].args[data.localKey] = {
						name = 'Anchor',
						desc = ('Default anchor point for %s configuration.'):format(raidFormat.name),
						type = 'select',
						values = {
							CENTER = 'CENTER',
							TOP = 'TOP',
							LEFT = 'LEFT',
							RIGHT = 'RIGHT',
							BOTTOM = 'BOTTOM',
							TOPLEFT = 'TOPLEFT',
							TOPRIGHT = 'TOPRIGHT',
							BOTTOMLEFT = 'BOTTOMLEFT',
							BOTTOMRIGHT = 'BOTTOMRIGHT',
						},
						style = 'dropdown',
						set = function(info,value)
							kMiscellaneous:Grid_SaveSetting(raidFormat.id, data.localKey, value)
						end,
						get = function(info) return kMiscellaneous:Grid_GetSetting(raidFormat.id, data.localKey) end,
					}
				end
			end
			-- Addon settings
			kMiscellaneous.options.args.grid.args.layout.args[raidFormat.id].args.copy = {
				type = 'execute',
				name = 'Copy from Grid',
				desc = ('Copy the settings from Grid and save to the %s configuration.'):format(raidFormat.name),
				func = function() 
					kMiscellaneous:Grid_CopySettings(raidFormat.id)
				end,
				order = 1,
				width = 'full',
			}
		end
	end
end

--[[ Generate dynamic options
]]
function kMiscellaneous:Options_Generate()
	self:Options_GenerateGridOptions()
end

--[[ Retrieve the selected key in the data table
]]
function kMiscellaneous:Options_GetSelected(data, selectionType)
	if not data or not type(data) == 'table' then return end
	selectionType = selectionType or 'key'
	for i,v in pairs(data) do
		if type(v) == 'table' then
			if v.selected and v.selected == true then
				if selectionType == 'key' then
					return i
				elseif selectionType == 'value' then
					return v
				elseif v[selectionType] then
					return v[selectionType]
				end
			end
		end
	end
end

--[[ Retrieve the value list for dropdown selection use from table/key
]]
function kMiscellaneous:Options_GetValueList(data, key)
	if not data or not key or not type(data) == 'table' then return end
	local output
	for i,v in pairs(data) do
		if v[key] then
			output = output or {}
			output[i] = v[key]
		end
	end
	return output
end

--[[ Resets the selected for the data table if necessary
]]
function kMiscellaneous:Options_ResetSelected(data)
	if not data or not type(data) == 'table' then return end
	local selectedCount = 0
	for i,v in pairs(data) do
		if type(v) == 'table' then
			if v.selected and v.selected == true then
				selectedCount = selectedCount + 1
			end
		end
	end
	-- If non-one value if selections then select first
	if selectedCount ~= 1 then
		self:Options_SetSelectedFirst(data)
	end
end

--[[ Properly edit specified table to ensure selected key is only selected option
]]
function kMiscellaneous:Options_SetSelected(data, key)
	if not data or not key or not type(data) == 'table' or not data[key] then return end
	for i,v in pairs(data) do
		v.selected = false
	end
	data[key].selected = true
end

--[[ Select the first key option in data table
]]
function kMiscellaneous:Options_SetSelectedFirst(data)
	if not data or not type(data) == 'table' then return end
	for i,v in pairs(data) do
		self:Options_SetSelected(data, i)
		break
	end
end