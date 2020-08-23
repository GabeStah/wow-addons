-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kNecroticPlague.minRequiredVersion = 0.0002;
kNecroticPlague.version = 0.0002;
kNecroticPlague.versions = {};

kNecroticPlague.const = {};
kNecroticPlague.defaults = {
	profile = {
		enabled = true,
		frame = {
			enabled = false,
		},
		debug = {
			enabled = false,
			threshold = 1,
		},
	},
};
kNecroticPlague.threading = {};
kNecroticPlague.threading.timers = {};
kNecroticPlague.threading.timerPool = {};
-- Create Options Table
kNecroticPlague.options = {
    name = "kNecroticPlague",
    handler = kNecroticPlague,
    type = 'group',
    args = {
		settings = {
			name = 'Settings',
			type = 'group',
			order = 1,
			args = {
				description1 = {
					name = 'Checking "Enabled" allows kNecroticPlague to parse your MOUSEOVER, TARGET_CHANGED, and FOCUS_CHANGED events during combat to check for Shambling Horrors in Icecrown Citadel during The Lich King for valid Necrotic Plague stacks.',
					type = 'description',
					order = 0,
				},	
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle if kNecroticPlague is enabled.',
					set = function(info,value)
						kNecroticPlague.db.profile.enabled = value;
						kNecroticPlague.isEnabled = kNecroticPlague.db.profile.enabled;
						if kNecroticPlague.isEnabled then
							kNecroticPlague:EnteringCombat()
						else
							kNecroticPlague:ExitingCombat();
						end
					end,
					get = function(info) return kNecroticPlague.db.profile.enabled end,
					width = "full",
					order = 1,
				},	
				description2 = {
					name = 'Checking "Show Tracking Frame" displays the basic frame for kNecroticPlague.',
					type = 'description',
					order = 2,
				},			
				toggleFrame = {
					name = 'Show Tracking Frame',
					type = 'toggle',
					desc = 'Determine if the Tracking Frame should be displayed.',
					set = function(info,value)
						kNecroticPlague.db.profile.frame.enabled = value
						if kNecroticPlague.db.profile.frame.enabled == true then
							kNecroticPlague:Gui_ShowFrame();
						else
							kNecroticPlague:Gui_HideFrame();
						end
					end,
					get = function(info) return kNecroticPlague.db.profile.frame.enabled end,
					width = "full",
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
					set = function(info,value) kNecroticPlague.db.profile.debug.enabled = value end,
					get = function(info) return kNecroticPlague.db.profile.debug.enabled end,
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
					set = function(info,value) kNecroticPlague.db.profile.debug.threshold = value end,
					get = function(info) return kNecroticPlague.db.profile.debug.threshold end,
				},
			},
		},
		hide = {
			type = 'execute',
			name = 'Hide',
			desc = 'Hide the main frame.',
			func = function() 
				kNecroticPlague:Gui_HideFrame();
			end,
			guiHidden = true,			
		},
		show = {
			type = 'execute',
			name = 'Show',
			desc = 'Show the main frame.',
			func = function() 
				kNecroticPlague:Gui_ShowFrame();
			end,
			guiHidden = true,			
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kNecroticPlague.dialog:Open("kNecroticPlague") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kNecroticPlague version',
			func = function() 
				kNecroticPlague:Print("Version: |cFF"..kNecroticPlague:RGBToHex(0,255,0)..kNecroticPlague.version.."|r");
			end,
			guiHidden = true,
        },
	},
};