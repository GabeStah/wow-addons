-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kInsane.minRequiredVersion = 0.0001;
kInsane.version = 0.0001
kInsane.versions = {};

kInsane.const = {};
kInsane.const.zones = {};
kInsane.const.zones.direMaul = {subText = "Dire Maul", outsideSubText = "Broken Commons", isInstance = true};
kInsane.const.items = {};
kInsane.const.items.ItemEquipLocs = {
	{name = "INVTYPE_AMMO", slotName = "AmmoSlot", slotNumber = 0, formattedName = "Ammo",},
	{name = "INVTYPE_HEAD", slotName = "HeadSlot", slotNumber = 1, formattedName = "Head",},
	{name = "INVTYPE_NECK", slotName = "NeckSlot", slotNumber = 2, formattedName = "Neck",},
	{name = "INVTYPE_SHOULDER", slotName = "ShoulderSlot", slotNumber = 3, formattedName = "Shoulder",},
	{name = "INVTYPE_BODY", slotName = "ShirtSlot", slotNumber = 4, formattedName = "Shirt",},
	{name = "INVTYPE_CHEST", slotName = "ChestSlot", slotNumber = 5, formattedName = "Chest",},
	{name = "INVTYPE_ROBE", slotName = "ChestSlot", slotNumber = 5, formattedName = "Chest",},
	{name = "INVTYPE_WAIST", slotName = "WaistSlot", slotNumber = 6, formattedName = "Waist",},
	{name = "INVTYPE_LEGS", slotName = "LegsSlot", slotNumber = 7, formattedName = "Legs",},
	{name = "INVTYPE_FEET", slotName = "FeetSlot", slotNumber = 8, formattedName = "Feet",},
	{name = "INVTYPE_WRIST", slotName = "WristSlot", slotNumber = 9, formattedName = "Wrist",},
	{name = "INVTYPE_HAND", slotName = "HandsSlot", slotNumber = 10, formattedName = "Hands",},
	{name = "INVTYPE_FINGER", slotName = "Finger0Slot", slotNumber = 11, formattedName = "Finger",},
	{name = "INVTYPE_TRINKET", slotName = "Trinket0Slot", slotNumber = 13, formattedName = "Trinket",},
	{name = "INVTYPE_CLOAK", slotName = "BackSlot", slotNumber = 15, formattedName = "Back",},
	{name = "INVTYPE_WEAPON", slotName = "MainHandSlot", slotNumber = 16, formattedName = "Main Hand",},
	{name = "INVTYPE_SHIELD", slotName = "SecondaryHandSlot", slotNumber = 17, formattedName = "Offhand",},
	{name = "INVTYPE_2HWEAPON", slotName = "MainHandSlot", slotNumber = 16, formattedName = "Main Hand",},
	{name = "INVTYPE_WEAPONMAINHAND", slotName = "MainHandSlot", slotNumber = 16, formattedName = "Main Hand",},
	{name = "INVTYPE_WEAPONOFFHAND", slotName = "SecondaryHandSlot", slotNumber = 17, formattedName = "Offhand",},
	{name = "INVTYPE_HOLDABLE", slotName = "SecondaryHandSlot", slotNumber = 17, formattedName = "Offhand",},
	{name = "INVTYPE_RANGED", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_THROWN", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_RANGEDRIGHT", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_RELIC", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_TABARD", slotName = "TabardSlot", slotNumber = 19, formattedName = "Tabard",},
	{name = "INVTYPE_BAG", slotName = "Bag0Slot", slotNumber = 20, formattedName = "Bag",},
	{name = "INVTYPE_QUIVER", slotName = nil, slotNumber = 20, formattedName = "Ammo",},
};
kInsane.defaults = {
	profile = {
		debug = {
			enabled = false,
			threshold = 1,
		},
		modes = {
			direMaul = {
				enabled = true,
			},
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
					name = "kInsaneMainFrame",
					scale = 1,
					visible = true,
					width = 325,
				},
			},
		},
	},
};
kInsane.threading = {};
kInsane.threading.timers = {};
kInsane.threading.timerPool = {};
-- Create Options Table
kInsane.options = {
    name = "kInsane",
    handler = kInsane,
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
			desc = 'Show the main kInsane frame.',
			guiHidden = true,
			func = function()
				kInsaneMainFrame:Show()
			end,
		},	
		modes = {
			name = 'Modes',
			type = 'group',
			args = {
				direMaul = {
					name = 'Dire Maul',
					type = 'group',
					args = {
						enabled = {
							name = 'Enabled',
							type = 'toggle',
							desc = 'Toggle Dire Maul mode',
							set = function(info,value) kInsane.db.profile.modes.direMaul.enabled = value end,
							get = function(info) return kInsane.db.profile.modes.direMaul.enabled end,						
						},
					},
				},
			},
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
										kInsane.db.profile.gui.frames.main.height = value
										kInsane:Gui_RefreshFrame(getglobal(kInsane.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kInsane.db.profile.gui.frames.main.height end,
								},
								width = {
									name = 'Width',
									desc = 'Width of Main Frame.',
									type = 'range',
									min = 240,
									max = 400,
									step = 1,
									set = function(info,value)
										kInsane.db.profile.gui.frames.main.width = value
										kInsane:Gui_RefreshFrame(getglobal(kInsane.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kInsane.db.profile.gui.frames.main.width end,
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
										return kInsane.db.profile.gui.frames.main.font -- variable that is my current selection
									end,
									set = function(info,value)
										kInsane.db.profile.gui.frames.main.font = value -- saves our new selection the the current one
										kInsane:Gui_HookFrameRefreshUpdate();
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
										kInsane.db.profile.gui.frames.main.fontSize = value
										kInsane:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kInsane.db.profile.gui.frames.main.fontSize end,
								},
							},
						},
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kInsane window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kInsane.db.profile.gui.frames.main.scale = value;
								kInsane:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kInsane.db.profile.gui.frames.main.scale end,
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
					set = function(info,value) kInsane.db.profile.debug.enabled = value end,
					get = function(info) return kInsane.db.profile.debug.enabled end,
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
					set = function(info,value) kInsane.db.profile.debug.threshold = value end,
					get = function(info) return kInsane.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kInsane.dialog:Open("kInsane") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kInsane version',
			func = function() 
				kInsane:Print("Version: |cFF"..kInsane:RGBToHex(0,255,0)..kInsane.version.."|r");
			end,
			guiHidden = true,
        },
	},
};