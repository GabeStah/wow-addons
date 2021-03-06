-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kFormation.minRequiredVersion = 0.0002;
kFormation.version = 0.0002;
kFormation.versions = {};

kFormation.const = {};
kFormation.const.gui = {};
kFormation.const.gui.frames = {};
kFormation.const.gui.frames.mapName = "kFormationMap";
kFormation.const.gui.zoomIncrement = 0.3;
kFormation.const.gui.zoomMax = 10;
kFormation.const.gui.zoomMin = 1;

kFormation.defaults = {
	profile = {
		coords = {
		},
		debug = {
			enabled = false,
			threshold = 1,
		},
		gui = {
			frames = {
				map = {
					name = "kFormationMap",
					scale = 1,
					zoom = 1,
					zoomMax = 5,
					zoomMin = 0.1,
				},
			},
		},
		zones = {
			validZones = {
				"Naxxramas",
				"The Eye of Eternity",
				"The Obsidian Sanctum",
				"Ulduar",
			},
			zoneSelected = 1,
		}
	},
};
kFormation.guids = {};
kFormation.guids.wasAuctioned = {};
kFormation.guids.lastObjectOpened = nil;
kFormation.threading = {};
kFormation.threading.timers = {};
kFormation.threading.timerPool = {};
-- Create Options Table
kFormation.options = {
    name = "kFormation",
    handler = kFormation,
    type = 'group',
    args = {
		description = {
			name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
			type = 'description',
			order = 0,
			hidden = true,
		},	
		show = {
			name = 'Show',
			type = 'execute',
			desc = 'Show the main kFormation frame.',
			guiHidden = true,
			func = function()
				if #(kFormation.auctions) > 0 then
					kFormationMainFrame:Show()
				else
					kFormation:Print("No auction data found on local client system -- hiding kFormation frame until valid auction data received.");
				end
			end,
		},		
		gui = {
			name = 'Interface',
			type = 'group',
			cmdHidden = true,
			args = {		
				map = {
					name = 'Map Frame',
					type = 'group',
					args = {
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kFormation map window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kFormation.db.profile.gui.frames.map.scale = value;
								--skFormation:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kFormation.db.profile.gui.frames.map.scale end,
							width = 'full',
						},
						zoom = {
							name = 'Zoom',
							desc = 'Change the zoom value of the kFormation map window.',
							type = 'range',
							min = kFormation.const.gui.zoomMin,
							max = kFormation.const.gui.zoomMax,
							step = kFormation.const.gui.zoomIncrement,
							set = function(info,value)
								kFormation.db.profile.gui.frames.map.zoom = value;
								--kFormation:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kFormation.db.profile.gui.frames.map.zoom end,
							width = 'full',
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
					set = function(info,value) kFormation.db.profile.debug.enabled = value end,
					get = function(info) return kFormation.db.profile.debug.enabled end,
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
					set = function(info,value) kFormation.db.profile.debug.threshold = value end,
					get = function(info) return kFormation.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kFormation.dialog:Open("kFormation") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kFormation version',
			func = function() 
				kFormation:Print("Version: |cFF"..kFormation:RGBToHex(0,255,0)..kFormation.version.."|r");
			end,
			guiHidden = true,
        },
	},
};