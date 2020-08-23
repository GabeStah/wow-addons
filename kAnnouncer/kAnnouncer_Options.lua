-- Author      : Kulldam
-- Create Date : 2/15/2009 7:20:42 PM
self = kAnnouncer;

self.minRequiredVersion = 0.001;
self.version = 0.001;
self.versions = {};

self.const = {};
self.defaults = {
	profile = {
		debug = {
			enabled = false,
			threshold = 1,
		},
		zones = {
			validZones = {
				"Dalaran",
			},
			zoneSelected = 1,
		}
	},
};
-- Create Options Table
self.options = {
    name = "kAnnouncer",
    handler = kAnnouncer,
    type = 'group',
    args = {
		description = {
			name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
			type = 'description',
			order = 0,
			hidden = true,
		},	
		events = {
			name = 'Events',
			type = 'group',
			cmdHidden = true,
			args = {
				framesInline = {
					name = 'Auction Received Events',
					type = 'group',
					guiInline = true,
					args = {
					},
				},
			},	
		},	
		zonesInline = {
			name = 'Zones',
			type = 'group',
			cmdHidden = true,
			order = 6,
			args = {
				description = {
					name = 'Use these settings to edit a list of valid Zones where kAnnouncer will track filtered events.  To add a new zone, enter the name in the Add box and press Enter.  The current list of Zones is found in the Zones dropdown.  To remove an Zone, select the name in the drop down and press Delete.',
					type = 'description',
					order = 0,
				},
				add = {
					name = 'Add',
					type = 'input',
					desc = 'Add Zone to list.',
					get = function(info) return nil end,
					set = function(info,value)
						tinsert(self.db.profile.zones.validZones, value);
						table.sort(self.db.profile.zones.validZones);
					end,
					order = 1,
					width = 'full',
				},
				councilMembers = {
					name = 'Members',
					type = 'select',
					desc = 'Current list of valid Zones.',
					style = 'dropdown',
					values = function() return self.db.profile.zones.validZones end,
					get = function(info) return self.db.profile.zones.zoneSelected end,
					set = function(info,value) self.db.profile.zones.zoneSelected = value end,
					order = 2,
				},
				delete = {
					name = 'Delete',
					type = 'execute',
					desc = 'Delete selected Zone from list.',
					func = function()
						tremove(self.db.profile.zones.validZones, self.db.profile.zones.zoneSelected);
						self.db.profile.zones.zoneSelected = 1;
					end,
					order = 3,
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
					set = function(info,value) self.db.profile.debug.enabled = value end,
					get = function(info) return self.db.profile.debug.enabled end,
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
					set = function(info,value) self.db.profile.debug.threshold = value end,
					get = function(info) return self.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				self.dialog:Open("kAnnouncer") 
			end,
			guiHidden = true,
        },
	},
};