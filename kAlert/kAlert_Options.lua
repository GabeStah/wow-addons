-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kAlert.minRequiredVersion = 1;
kAlert.version = 1
kAlert.versions = {};

kAlert.const = {};
kAlert.defaults = {
	profile = {
		debug = {
			enabled = false,
			threshold = 1,
		},
		gui = {
			frames = {
				main = {
					barBackgroundColor = {r = 0.5, g = 0.5, b = 0.5, a = 0.5},
					barColor = {r = 1, g = 0, b = 0, a = 1},
					barTexture = "BantoBar",
					font = "ABF",
					fontSize = 12,
					height = 152,			
					minimized = false,
					name = "kAlertMainFrame",
					scale = 1,
					visible = true,
					width = 325,
				},
			},
		},
	},
};
kAlert.threading = {};
kAlert.threading.timers = {};
kAlert.threading.timerPool = {};
-- Create Options Table
kAlert.options = {
    name = "kAlert",
    handler = kAlert,
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
			desc = 'Show the main kAlert frame.',
			guiHidden = true,
			func = function()
				kAlertMainFrame:Show()
			end,
		},	
		gui = {
			name = 'Interface',
			type = 'group',
			cmdHidden = true,
			args = {	
				main = {
					name = 'Main Frame',
					type = 'group',
					args = {
						dimensions = {
							name = 'Dimensions',
							type = 'group',
							guiInline = true,
							order = 4,
							args = {
								height = {
									name = 'Height',
									desc = 'Height of Main Frame.',
									type = 'range',
									min = 152,
									max = 152,
									step = 1,
									set = function(info,value)
										kAlert.db.profile.gui.frames.main.height = value
										kAlert:Gui_RefreshFrame(getglobal(kAlert.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kAlert.db.profile.gui.frames.main.height end,
								},
								width = {
									name = 'Width',
									desc = 'Width of Main Frame.',
									type = 'range',
									min = 240,
									max = 400,
									step = 1,
									set = function(info,value)
										kAlert.db.profile.gui.frames.main.width = value
										kAlert:Gui_RefreshFrame(getglobal(kAlert.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kAlert.db.profile.gui.frames.main.width end,
								},
							},
						},						
						fonts = {
							name = 'Font',
							type = 'group',
							guiInline = true,
							order = 6,
							args = {
								font = {
									type = 'select',
									dialogControl = 'LSM30_Font', --Select your widget here
									name = 'Font',
									desc = 'Font for auction item names.',
									values = AceGUIWidgetLSMlists.font, -- this table needs to be a list of keys found in the sharedmedia type you want
									get = function(info)
										return kAlert.db.profile.gui.frames.main.font -- variable that is my current selection
									end,
									set = function(info,value)
										kAlert.db.profile.gui.frames.main.font = value -- saves our new selection the the current one
										kAlert:Gui_HookFrameRefreshUpdate();
									end,
								},
								fontSize = {
									name = 'Font Size',
									desc = 'Font Size of Main Frame text.',
									type = 'range',
									min = 8,
									max = 20,
									step = 1,
									set = function(info,value)
										kAlert.db.profile.gui.frames.main.fontSize = value
										kAlert:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kAlert.db.profile.gui.frames.main.fontSize end,
								},
							},
						},
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kAlert window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kAlert.db.profile.gui.frames.main.scale = value;
								kAlert:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kAlert.db.profile.gui.frames.main.scale end,
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
					set = function(info,value) kAlert.db.profile.debug.enabled = value end,
					get = function(info) return kAlert.db.profile.debug.enabled end,
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
					set = function(info,value) kAlert.db.profile.debug.threshold = value end,
					get = function(info) return kAlert.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kAlert.dialog:Open("kAlert") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kAlert version',
			func = function() 
				kAlert:Print("Version: |cFF"..kAlert:RGBToHex(0,255,0)..kAlert.version.."|r");
			end,
			guiHidden = true,
        },
	},
};