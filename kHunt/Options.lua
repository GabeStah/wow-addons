-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kHunt.minRequiredVersion = '0.0.100';
kHunt.version = '0.0.100';
kHunt.versions = {};

kHunt.defaults = {
	profile = {
		debug = {
			enabled = false,
			threshold = 1,
		},
		macros = {
			enabled = false,
			list = {
				
			},
			temp = {},
		},
	},
};
kHunt.timers = {};
kHunt.threading = {};
kHunt.threading.timers = {};
kHunt.threading.timerPool = {};
-- Create Options Table
kHunt.options = {
    name = "kHunt",
    handler = kHunt,
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
					set = function(info,value) kHunt.db.profile.debug.enabled = value end,
					get = function(info) return kHunt.db.profile.debug.enabled end,
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
					set = function(info,value) kHunt.db.profile.debug.threshold = value end,
					get = function(info) return kHunt.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
        config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kHunt.dialog:Open("kHunt") 
			end,
			guiHidden = true,
        },    
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kHunt version',
			func = function() 
				kHunt:Print("Version: |cFF"..kHunt:RGBToHex(0,255,0)..kHunt.version.."|r");
			end,
			guiHidden = true,
        },
	},
};

