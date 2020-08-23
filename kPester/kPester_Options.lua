-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kPester.minRequiredVersion = 0.0001;
kPester.version = 0.0001;
--[[
triggerType = {
	1 = Timer, -- Repeating or single-comm event
	2 = Ability, -- 
};
eventType = {
	1 = Message,
};
channelType = {
	1 = "Battleground",
	2 = "Chat Channel", 
	3 = "Emote",
	4 = "Guild",
	5 = "Officer",
	6 = "Party",
	7 = "Raid Chat",
	8 = "Raid Warning",
	9 = "Say",
	10 = "Whisper", 
	11 = "Yell",
},
]]
kPester.testToggle = true;
kPester.defaults = {
	profile = {
		debug = {
			enabled = false,
			threshold = 1,
		},
		defaults = {
			event = {
				enabled = true,
				name = "New Event",
				type = 1,
				message = "kPester says hello.",
				target = "Whatfaire",
				channel = 10,
				selectedIndex = 0,
				activeTriggerSelectedIndex = 0,
				inactiveTriggerSelectedIndex = 0,
			},
			trigger = {
				enabled = true,
				name = "New Trigger",
				type = 1,
				interval = 15,
				loop = true,
				selectedIndex = 0,
				activeEventSelectedIndex = 0,
				inactiveEventSelectedIndex = 0,
			},
		},
		enabled = true,
		event = {
			--{enabled=true, id=1, name="Annoy Whatfaire", type=1, message="You suck.", target="Whatfaire", channel=10},
		},
		trigger = {
			--{enabled=true, id=1, name="Default - Repeating 15 sec", interval=15, loop=true, type=1},
		},
		trigger_event = {
			--{triggerId=1, eventId=1},
		},
		zones = {
			enabled = true,
			validZones = {
				"Dalaran",
				"Naxxramas",
				"Orgrimmar",
				"The Eye of Eternity",
				"The Obsidian Sanctum",
				"Ulduar",
			},
			zoneSelected = 1,
		}
	},
};
kPester.threading = {};
kPester.threading.timers = {};
kPester.threading.timerPool = {};
-- Create Options Table
kPester.options = {
    name = "kPester",
    handler = kPester,
    type = 'group',
    childGroups = 'tab',
    args = {
		enabled = {
			name = 'Enabled',
			type = 'toggle',
			desc = 'Enable or disable kPester.',
			set = function(info,value) kPester.db.profile.enabled = value end,
			get = function(info) return kPester.db.profile.enabled end,
			order = 1,
		},
		events = {
			name = 'Event Editor',
			type = 'group',
			cmdHidden = true,
			order = 1,
			childGroups = 'tab',
			args = {
				description = {
					name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
					type = 'description',
					order = 0,
				},				
				current = {
					name = 'Current Event',
					desc = 'Select the event you wish to edit.',
					type = 'select',
					values = function() return kPester:GetEventSelectDropdown() end,
					style = 'dropdown',
					set = function(info,value) 
						kPester.db.profile.defaults.event.selectedIndex = value
						if kPester.db.profile.defaults.event.selectedIndex and kPester.db.profile.defaults.event.selectedIndex > 0 then
							kPester.options.args.events.args.general.guiHidden = false;
							kPester.options.args.events.args.triggers.guiHidden = false;
						else
							kPester.options.args.events.args.general.guiHidden = true;
							kPester.options.args.events.args.triggers.guiHidden = true;
						end
					end,
					get = function(info)
						if kPester.db.profile.defaults.event.selectedIndex > #kPester.db.profile.event then
							if #kPester.db.profile.event > 0 then
								kPester.db.profile.defaults.event.selectedIndex	= #kPester.db.profile.event;
							else
								kPester.db.profile.defaults.event.selectedIndex = 0;
							end
						end
						if kPester.db.profile.defaults.event.selectedIndex and kPester.db.profile.defaults.event.selectedIndex > 0 then
							kPester.options.args.events.args.general.guiHidden = false;
							kPester.options.args.events.args.triggers.guiHidden = false;
						else
							kPester.options.args.events.args.general.guiHidden = true;
							kPester.options.args.events.args.triggers.guiHidden = true;
						end
						return kPester.db.profile.defaults.event.selectedIndex
					end,
					order = 1,
				},		
				new = {
					name = 'New Event',
					type = 'input',
					desc = 'Enter the name for your new event.',
					set = function(info,value)
						kPester.db.profile.defaults.event.name = value;
						kPester:CreateEvent();
						kPester.db.profile.defaults.event.selectedIndex = #kPester.db.profile.event;
						kPester.options.args.events.args.general.guiHidden = false;
						kPester.options.args.events.args.triggers.guiHidden = false;
					end,
					get = function(info) return nil end,
					order = 2,
				},	
				general = {
					name = 'General',
					type = 'group',
					order = 1,
					args = {
						name = {
							name = 'Name',
							type = 'input',
							desc = 'Name this event for easy identification in the future.',
							set = function(info,value)
								kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].name = value
							end,
							get = function(info) return kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].name end,
							width = 'full',
							order = 1,
						},						
						enabled = {
							name = 'Enabled',
							type = 'toggle',
							desc = 'Enable event by default.',
							set = function(info,value) kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].enabled = value end,
							get = function(info) return kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].enabled end,
							order = 2,
						},
						type = {
							name = 'Type',
							desc = 'Select the Event Type',
							type = 'select',
							values = {
								[1] = 'Message',
							},
							style = 'dropdown',
							set = function(info,value) kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].type = value end,
							get = function(info) return kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].type end,
							order = 3,
						},	
						message = {
							name = 'Message',
							type = 'input',
							desc = 'Enter the message you wish to send.',
							set = function(info,value) kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].message = value end,
							get = function(info) return kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].message end,
							width = 'full',
							order = 4,
						},		
						channel = {
							name = 'Channel',
							desc = 'Select the Channel to relay the message.',
							type = 'select',
							values = {
								[1] = "Battleground",
								[2] = "Chat Channel", 
								[3] = "Emote",
								[4] = "Guild",
								[5] = "Officer",
								[6] = "Party",
								[7] = "Raid Chat",
								[8] = "Raid Warning",
								[9] = "Say",
								[10] = "Whisper", 
								[11] = "Yell",
							},
							style = 'dropdown',
							set = function(info,value) 
								kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel = value
								if kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel == 2 or kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel == 10 then
									if kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel == 2 then
										kPester.options.args.events.args.target.name = "Chat Channel";
										kPester.options.args.events.args.target.desc = "Name of the chat channel to send message to.";
									elseif kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel == 10 then
										kPester.options.args.events.args.general.args.target.name = "Whisper Target";
										kPester.options.args.events.args.general.args.target.desc = "Name of the player to send whisper message to.";
									end
									kPester.options.args.events.args.general.args.target.guiHidden = false;
								else
									kPester.options.args.events.args.general.args.target.guiHidden = true;
								end
							end,
							get = function(info)
								if kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel == 2 or kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel == 10 then
									kPester.options.args.events.args.general.args.target.guiHidden = false;
								else
									kPester.options.args.events.args.general.args.target.guiHidden = true;
								end
								return kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].channel
							end,
							order = 5,
						},	
						target = {
							name = 'Whisper Target',
							type = 'input',
							desc = 'Name of the player to send whisper message to.',
							set = function(info,value) kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].target = value end,
							get = function(info) return kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].target end,
							width = 'full',
							order = 6,
						},		
						delete = {
							name = 'Delete Event',
							type = 'execute',
							desc = 'Delete the current event.',
							func = function()
								kPester:DeleteEvent(kPester.db.profile.defaults.event.selectedIndex);
							end,
							order = 7,
						},								
					},	
				},
				triggers = {
					name = 'Edit Triggers',
					type = 'group',
					args = {
						available = {
							name = 'Inactive Triggers',
							type = 'group',
							guiInline = true,
							args = {
								triggers = {
									name = 'Triggers',
									desc = 'Select a trigger you wish to enable for this event.',
									type = 'select',
									values = function() return kPester:GetTriggersAssignedToEvent(kPester.db.profile.defaults.event.selectedIndex, true) end,
									style = 'dropdown',
									set = function(info,value) 
										kPester.db.profile.defaults.event.inactiveTriggerSelectedIndex = value
									end,
									get = function(info)
										return kPester.db.profile.defaults.event.inactiveTriggerSelectedIndex
									end,
									order = 1,
								},
								activate = {
									name = 'Apply Trigger',
									type = 'execute',
									desc = 'Enable the currently selected trigger for this event.',
									func = function()
										kPester:AddEventTrigger(kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].id, kPester.db.profile.defaults.event.inactiveTriggerSelectedIndex);
									end,
									order = 7,
								},											
							},
						},
						active = {
							name = 'Active Triggers',
							type = 'group',
							guiInline = true,
							args = {
								triggers = {
									name = 'Triggers',
									desc = 'Select a trigger you wish to remove from this event.',
									type = 'select',
									values = function() return kPester:GetTriggersAssignedToEvent(kPester.db.profile.defaults.event.selectedIndex) end,
									style = 'dropdown',
									set = function(info,value) 
										kPester.db.profile.defaults.event.activeTriggerSelectedIndex = value
									end,
									get = function(info)
										return kPester.db.profile.defaults.event.activeTriggerSelectedIndex
									end,
									order = 1,
								},
								remove = {
									name = 'Remove Trigger',
									type = 'execute',
									desc = 'Remove the currently selected trigger from this event.',
									func = function()
										kPester:DeleteEventTrigger(kPester.db.profile.event[kPester.db.profile.defaults.event.selectedIndex].id, kPester.db.profile.defaults.event.activeTriggerSelectedIndex);
									end,
									order = 7,
								},
							},
						},							
					},
				},				
			},
		},
		triggers = {
			name = 'Trigger Editor',
			type = 'group',
			cmdHidden = true,
			childGroups = 'tab',
			order = 2,
			args = {
				description = {
					name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
					type = 'description',
					order = 0,
				},				
				current = {
					name = 'Current Trigger',
					desc = 'Select the trigger you wish to edit.',
					type = 'select',
					values = function() return kPester:GetTriggerSelectDropdown() end,
					style = 'dropdown',
					set = function(info,value) 
						kPester.db.profile.defaults.trigger.selectedIndex = value
						if kPester.db.profile.defaults.trigger.selectedIndex and kPester.db.profile.defaults.trigger.selectedIndex > 0 then
							kPester.options.args.triggers.args.general.guiHidden = false;
							kPester.options.args.triggers.args.events.guiHidden = false;
						else
							kPester.options.args.triggers.args.general.guiHidden = true;
							kPester.options.args.triggers.args.events.guiHidden = true;
						end
					end,
					get = function(info)
						if kPester.db.profile.defaults.trigger.selectedIndex > #kPester.db.profile.trigger then
							if #kPester.db.profile.trigger > 0 then
								kPester.db.profile.defaults.trigger.selectedIndex	= #kPester.db.profile.trigger;
							else
								kPester.db.profile.defaults.trigger.selectedIndex = 0;
							end
						end
						if kPester.db.profile.defaults.trigger.selectedIndex and kPester.db.profile.defaults.trigger.selectedIndex > 0 then
							kPester.options.args.triggers.args.general.guiHidden = false;
							kPester.options.args.triggers.args.events.guiHidden = false;
						else
							kPester.options.args.triggers.args.general.guiHidden = true;
							kPester.options.args.triggers.args.events.guiHidden = true;
						end
						return kPester.db.profile.defaults.trigger.selectedIndex
					end,
					order = 1,
				},		
				new = {
					name = 'New Trigger',
					type = 'input',
					desc = 'Enter the name for your new trigger.',
					set = function(info,value)
						kPester.db.profile.defaults.trigger.name = value;
						kPester:CreateTrigger();
						kPester.db.profile.defaults.trigger.selectedIndex = #kPester.db.profile.trigger;
						kPester.options.args.triggers.args.general.guiHidden = false;
						kPester.options.args.triggers.args.events.guiHidden = false;
					end,
					get = function(info) return nil end,
					order = 2,
				},	
				general = {
					name = 'General',
					type = 'group',
					order = 1,
					args = {
						name = {
							name = 'Name',
							type = 'input',
							desc = 'Name this trigger for easy identification in the future.',
							set = function(info,value)
								kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].name = value
							end,
							get = function(info) return kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].name end,
							width = 'full',
							order = 1,
						},						
						enabled = {
							name = 'Enabled',
							type = 'toggle',
							desc = 'Enable trigger by default.',
							set = function(info,value) kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].enabled = value end,
							get = function(info) return kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].enabled end,
							order = 2,
						},
						type = {
							name = 'Type',
							desc = 'Select the Trigger Type',
							type = 'select',
							values = {
								[1] = 'Timer',
								[2] = 'Ability',
							},
							style = 'dropdown',
							set = function(info,value) kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].type = value end,
							get = function(info) return kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].type end,
							order = 3,
						},	
						loop = {
							name = 'Repeat',
							type = 'toggle',
							desc = 'Determine if this trigger automatically repeats.',
							set = function(info,value)
								kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].loop = value
								if value == true then
									kPester.options.args.triggers.args.general.args.interval.guiHidden = false;
								else
									kPester.options.args.triggers.args.general.args.interval.guiHidden = true;
								end							
							end,
							get = function(info)
								if kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].loop == true then
									kPester.options.args.triggers.args.general.args.interval.guiHidden = false;
								else
									kPester.options.args.triggers.args.general.args.interval.guiHidden = true;
								end	
								return kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].loop
							end,
							order = 4,
						},						
						interval = {
							name = 'Repeat Interval',
							desc = 'Seconds to delay repeating of this trigger.',
							type = 'range',
							min = 10,
							max = 1800,
							step = 1,
							set = function(info,value) kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].interval = value end,
							get = function(info) return kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].interval end,
							order = 5,
						},		
						eventsInline = {
							name = 'Enabled Events',
							type = 'group',
							cmdHidden = true,
							guiInline = true,
							guiHidden = true,
							args = {
								triggers = {
									name = 'Active Events',
									desc = 'Select a currently active event you wish to disable.',
									type = 'select',
									values = function() return kPester:GetEventsAssignedToTrigger(kPester.db.profile.defaults.trigger.selectedIndex) end,
									style = 'dropdown',
									set = function(info,value) 
										kPester.db.profile.defaults.trigger.selectedIndex = value
										if kPester.db.profile.defaults.trigger.selectedIndex and kPester.db.profile.defaults.trigger.selectedIndex > 0 then
											kPester.options.args.triggers.args.general.guiHidden = false;
											kPester.options.args.triggers.args.events.guiHidden = false;
										else
											kPester.options.args.triggers.args.general.guiHidden = true;
											kPester.options.args.triggers.args.events.guiHidden = true;
										end
									end,
									get = function(info)
										if kPester.db.profile.defaults.trigger.selectedIndex > #kPester.db.profile.trigger then
											if #kPester.db.profile.trigger > 0 then
												kPester.db.profile.defaults.trigger.selectedIndex	= #kPester.db.profile.trigger;
											else
												kPester.db.profile.defaults.trigger.selectedIndex = 0;
											end
										end
										if kPester.db.profile.defaults.trigger.selectedIndex and kPester.db.profile.defaults.trigger.selectedIndex > 0 then
											kPester.options.args.triggers.args.general.guiHidden = false;
											kPester.options.args.triggers.args.events.guiHidden = false;
										else
											kPester.options.args.triggers.args.general.guiHidden = true;
											kPester.options.args.triggers.args.events.guiHidden = true;
										end
										return kPester.db.profile.defaults.trigger.selectedIndex
									end,
									order = 1,
								},			
							},
						},	
						delete = {
							name = 'Delete Trigger',
							type = 'execute',
							desc = 'Delete the current trigger.',
							func = function()
								kPester:DeleteTrigger(kPester.db.profile.defaults.trigger.selectedIndex);
							end,
							order = 6,
						},					
					},	
				},
				events = {
					name = 'Edit Events',
					type = 'group',
					order = 2,
					args = {
						available = {
							name = 'Inactive Events',
							type = 'group',
							guiInline = true,
							args = {
								triggers = {
									name = 'Events',
									desc = 'Select a event you wish to enable for this trigger.',
									type = 'select',
									values = function() return kPester:GetEventsAssignedToTrigger(kPester.db.profile.defaults.trigger.selectedIndex, true) end,
									style = 'dropdown',
									set = function(info,value) 
										kPester.db.profile.defaults.trigger.inactiveEventSelectedIndex = value
									end,
									get = function(info)
										return kPester.db.profile.defaults.trigger.inactiveEventSelectedIndex
									end,
									order = 1,
								},
								activate = {
									name = 'Apply Event',
									type = 'execute',
									desc = 'Enable the currently selected event for this trigger.',
									func = function()
										kPester:AddEventTrigger(kPester.db.profile.defaults.trigger.inactiveEventSelectedIndex, kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].id);
									end,
									order = 7,
								},											
							},
						},
						active = {
							name = 'Active Events',
							type = 'group',
							guiInline = true,
							args = {
								events = {
									name = 'Events',
									desc = 'Select a event you wish to remove from this trigger.',
									type = 'select',
									values = function() return kPester:GetEventsAssignedToTrigger(kPester.db.profile.defaults.trigger.selectedIndex) end,
									style = 'dropdown',
									set = function(info,value) 
										kPester.db.profile.defaults.trigger.activeEventSelectedIndex = value
									end,
									get = function(info)
										return kPester.db.profile.defaults.trigger.activeEventSelectedIndex
									end,
									order = 1,
								},
								remove = {
									name = 'Remove Event',
									type = 'execute',
									desc = 'Remove the currently selected event from this trigger.',
									func = function()
										kPester:DeleteEventTrigger(kPester.db.profile.defaults.trigger.activeEventSelectedIndex, kPester.db.profile.trigger[kPester.db.profile.defaults.trigger.selectedIndex].id);
									end,
									order = 7,
								},
							},
						},							
					},
				},
			},
		},
		zones = {
			name = 'Zones',
			type = 'group',
			cmdHidden = true,
			order = 3,
			args = {
				description = {
					name = 'Use these settings to edit a list of valid Zones where kPester will fire triggers and events.  To add a new zone, enter the name in the Add box and press Enter.  The current list of Raid Zones is found in the Zones dropdown.  To remove an Zone, select the name in the drop down and press Delete.',
					type = 'description',
					order = 0,
				},
				enabled = {
					name = 'Enable Zone Validation',
					type = 'toggle',
					desc = 'Determine if zone validation will be checked for triggers and events.  If disabled, zone list will be ignored.',
					set = function(info,value) kPester.db.profile.zones.enabled = value end,
					get = function(info) return kPester.db.profile.zones.enabled end,
					order = 1,
				},
				add = {
					name = 'Add',
					type = 'input',
					desc = 'Add Zone to list.',
					get = function(info) return nil end,
					set = function(info,value)
						tinsert(kPester.db.profile.zones.validZones, value);
						table.sort(kPester.db.profile.zones.validZones);
					end,
					order = 2,
					width = 'full',
				},
				list = {
					name = 'Zone List',
					type = 'select',
					desc = 'Current list of valid Zones.',
					style = 'dropdown',
					values = function() return kPester.db.profile.zones.validZones end,
					get = function(info) return kPester.db.profile.zones.zoneSelected end,
					set = function(info,value) kPester.db.profile.zones.zoneSelected = value end,
					order = 3,
				},
				delete = {
					name = 'Delete',
					type = 'execute',
					desc = 'Delete selected Zone from list.',
					func = function()
						tremove(kPester.db.profile.zones.validZones, kPester.db.profile.zones.zoneSelected);
						kPester.db.profile.zones.zoneSelected = 1;
					end,
					order = 4,
				},					
			},
		},
		debug = {
			name = 'Debug',
			type = 'group',
			order = 6,
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kPester.db.profile.debug.enabled = value end,
					get = function(info) return kPester.db.profile.debug.enabled end,
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
					set = function(info,value) kPester.db.profile.debug.threshold = value end,
					get = function(info) return kPester.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kPester.dialog:Open("kPester") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kPester version',
			func = function() 
				kPester:Print("Version: |cFF"..kPester:RGBToHex(0,255,0)..kPester.version.."|r");
			end,
			guiHidden = true,
        },
	},
};
function kPester:AddEventTrigger(eventId, triggerId)
	local booExists = false;
	for i,val in pairs(kPester.db.profile.trigger_event) do
		if val.eventId == eventId and val.triggerId == triggerId then
			booExists = true;
		end
	end
	if booExists == false then
		tinsert(kPester.db.profile.trigger_event, {eventId = eventId, triggerId = triggerId});
	end
end
function kPester:CreateEvent()
	-- First, check if event is a duplicate
	--if not kPester:DoesNewEventExist() then
		local id = kPester:GetUniqueId();
		tinsert(kPester.db.profile.event, 
			{enabled=kPester.db.profile.defaults.event.enabled, 
			id=id, 
			name=kPester.db.profile.defaults.event.name, 
			message=kPester.db.profile.defaults.event.message,
			target=kPester.db.profile.defaults.event.target,
			channel=kPester.db.profile.defaults.event.channel,
			type=kPester.db.profile.defaults.event.type});
		kPester:Print("New event created! [" .. kPester.db.profile.event[#kPester.db.profile.event].name .. "]");
	--end	
end
function kPester:CreateTrigger()
	-- First, check if trigger is a duplicate
	--if not kPester:DoesNewTriggerExist() then
		local id = kPester:GetUniqueId();
		tinsert(kPester.db.profile.trigger, 
			{enabled=kPester.db.profile.defaults.trigger.enabled, 
			id=id, 
			name=kPester.db.profile.defaults.trigger.name, 
			interval=kPester.db.profile.defaults.trigger.interval, 
			loop=kPester.db.profile.defaults.trigger.loop, 
			type=kPester.db.profile.defaults.trigger.type});
		local trigger = kPester.db.profile.trigger[#kPester.db.profile.trigger];
		if trigger.type == 1 and trigger.loop then -- Type: Timer
			-- Create timer
			kPester:Threading_CreateTimer(id, kPester_TimerElapsed, trigger.interval, trigger.loop, id);
			if trigger.enabled then
				kPester:Threading_StartTimer(id);
				-- TODO: Finish enabling timer start and creation code within option toggles
			end		
		end
		kPester:Print("New trigger created! [" .. kPester.db.profile.trigger[#kPester.db.profile.trigger].name .. "]");
	--end	
end
function kPester_TimerElapsed(timerId)
	if kPester.db.profile.enabled then
		if kPester:GetTriggerFromId(timerId) then
			local trigger = kPester:GetTriggerFromId(timerId);
			if trigger.enabled then
				kPester:Debug("FUNC: TimerElapsed, timerId: " .. timerId, 1);
				if kPester:IsInValidZone() then
					kPester:Debug("FUNC: TimerElapsed, Valid Zone", 1);	
				end			
			end
		end
	end
end
function kPester:GetEventFromId(eventId)
	for i,v in pairs(kPester.db.profile.event) do
		if v.id == eventId then
			return v;
		end
	end
	return nil;
end
function kPester:GetTriggerFromId(triggerId)
	for i,v in pairs(kPester.db.profile.trigger) do
		if v.id == triggerId then
			return v;
		end
	end
	return nil;
end
function kPester:DeleteEvent(index)
	if #kPester.db.profile.event >= index then
		if kPester.db.profile.event[index] then
			local eventId = kPester.db.profile.event[index].id;
			for i,v in pairs(kPester.db.profile.trigger_event) do
				if v.eventId == eventId then
					tremove(kPester.db.profile.trigger_event, i);
				end
			end
			tremove(kPester.db.profile.event, index);
		end
	end
end
function kPester:DeleteEventTrigger(eventId, triggerId)
	local booExists = false;
	for i,val in pairs(kPester.db.profile.trigger_event) do
		if val.eventId == eventId and val.triggerId == triggerId then
			tremove(kPester.db.profile.trigger_event, i);
		end
	end
end
function kPester:DeleteTrigger(index)
	if #kPester.db.profile.trigger >= index then
		if kPester.db.profile.trigger[index] then
			local triggerId = kPester.db.profile.trigger[index].id;
			for i,v in pairs(kPester.db.profile.trigger_event) do
				if v.triggerId == triggerId then
					tremove(kPester.db.profile.trigger_event, i);
				end
			end
			tremove(kPester.db.profile.trigger, index);
		end
	end
end
function kPester:DoesNewEventExist()
	--{enabled=true, id=1, name="Annoy Whatfaire", type=1, message="You suck.", target="Whatfaire", channel="WHISPER"},
	for i,v in pairs(kPester.db.profile.event) do
		if kPester.db.profile.defaults.event.type == v.type and 
			kPester.db.profile.defaults.event.message == v.message and 
			kPester.db.profile.defaults.event.target == v.target and 
			kPester.db.profile.defaults.event.channel == v.channel then
				kPester:Print("ERROR - Event exists with matching settings.  Edit the following event: [" .. v.name .. "]");
				return true;
		end
	end	
	return false;
end
function kPester:DoesNewTriggerExist()
	--{enabled=true, id=1, name="Default - Repeating 15 sec", interval=15, loop=true, type=1},
	for i,v in pairs(kPester.db.profile.trigger) do
		if kPester.db.profile.defaults.trigger.interval == v.interval and kPester.db.profile.defaults.trigger.loop == v.loop and kPester.db.profile.defaults.trigger.type == v.type then
			kPester:Print("ERROR - Trigger exists with matching settings.  Edit the following trigger: [" .. v.name .. "]");
			return true;
		end
	end	
	return false;
end
function kPester:GetEventsAssignedToTrigger(triggerIndex, inactive)
	local tblTemp = {};
	local trigger = kPester.db.profile.trigger[triggerIndex];
	-- First, loop through all known event
	for iEvent,vEvent in pairs(kPester.db.profile.event) do
		local booMatch = false;
		-- Now loop through all trigger_event pairs
		for i,v in pairs(kPester.db.profile.trigger_event) do
			-- Find entries with matching event
			if inactive then
				if v.triggerId == trigger.id and v.eventId == vEvent.id then -- Found active event for this event, remove from list
					booMatch = true;
				end
			else
				if v.triggerId == trigger.id and v.eventId == vEvent.id then -- Found active trigger for this event
					tblTemp[vEvent.id] = vEvent.name;
				end
			end
		end		
		if booMatch == false and inactive then
			tblTemp[vEvent.id] = vEvent.name;
		end	
	end
	return tblTemp;
end
function kPester:GetTriggersAssignedToEvent(eventIndex, inactive)
	local tblTemp = {};
	local event = kPester.db.profile.event[eventIndex];
	-- First, loop through all known triggers
	for iTrigger,vTrigger in pairs(kPester.db.profile.trigger) do
		local booMatch = false;
		-- Now loop through all trigger_event pairs
		for i,v in pairs(kPester.db.profile.trigger_event) do
			-- Find entries with matching trigger
			if inactive then
				if v.eventId == event.id and v.triggerId == vTrigger.id then -- Found active trigger for this event, remove from list
					booMatch = true;
				end
			else
				if v.eventId == event.id and v.triggerId == vTrigger.id then -- Found active trigger for this event
					tblTemp[vTrigger.id] = vTrigger.name;
				end
			end
		end			
		if booMatch == false and inactive then
			tblTemp[vTrigger.id] = vTrigger.name;
		end
	end
	return tblTemp;	
end
function kPester:GetEventSelectDropdown()
	local tblTemp = {};
	if #kPester.db.profile.event > 0 then
		for i,v in pairs(kPester.db.profile.event) do
			tblTemp[i] = v.name;
		end
	end
	return tblTemp;
end
function kPester:GetTriggerSelectDropdown()
	local tblTemp = {};
	if #kPester.db.profile.trigger > 0 then
		for i,v in pairs(kPester.db.profile.trigger) do
			tblTemp[i] = v.name;
		end
	end
	return tblTemp;
end
function kPester:GetUniqueId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(kPester.db.profile.event) do
			if val.id == newId then
				matchFound = true;
			end
		end
		for i,val in pairs(kPester.db.profile.trigger) do
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
function kPester:IsInValidZone()
	if not kPester.db.profile.zones.enabled then -- If zone check is disabled, return true
		return true;
	end
	kPester.currentZone = GetRealZoneText();
	for iZone,vZone in pairs(kPester.db.profile.zones.validZones) do
		if kPester.currentZone == vZone then
			return true;
		end
	end
	return false;
end