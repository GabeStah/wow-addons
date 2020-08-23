local _
-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kTiku.minRequiredVersion = '0.0.101';
kTiku.version = '0.0.101';
kTiku.versions = {};

kTiku.const = {};
kTiku.const.chatPrefix = "<kTiku> ";
kTiku.defaults = {
	profile = {
		alerts = {
			{
				id = 1345126,
				type = 'TriggerBase',
				height = 800,
				width = 1000,
				parent = kTikuScrollFrame,
				points = {
					{'CENTER',0,0},
				},
				children = {
					{
						id = 4578124,
						type = 'TriggerGroup',
						children = {
							{
								id = 251224,
								type = 'Trigger',
								children = {
									{
										id = 478412,
										type = 'EventGroup',
									},
								},
							},
						},
					},
					{
						id = 774157,
						type = 'TriggerGroup',
						children = {
							{
								id = 841122,
								type = 'Trigger',
								children = {
									{
										id = 3214567,
										type = 'EventGroup',
									},
								},
							},
						},
					},
				},
			},		
		},
		debug = {
			enabled = false,
			threshold = 1,
		},
	},
};
kTiku.threading = {};
kTiku.threading.timers = {};
kTiku.threading.timerPool = {};
-- Create Options Table
kTiku.options = {
    name = "kTiku",
    handler = kTiku,
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
					set = function(info,value) kTiku.db.profile.debug.enabled = value end,
					get = function(info) return kTiku.db.profile.debug.enabled end,
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
					set = function(info,value) kTiku.db.profile.debug.threshold = value end,
					get = function(info) return kTiku.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},		
		config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kTiku.dialog:Open("kTiku") 
			end,
			guiHidden = true,
        },    
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kTiku version',
			func = function() 
				kTiku:Print(("Version: |cFF%s%s|r"):format(kTiku:RGBToHex(0,255,0), kTiku.version));
			end,
			guiHidden = true,
        },
	},
};


