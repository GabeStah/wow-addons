-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kPriceCalc.minRequiredVersion = 0.0001;
kPriceCalc.version = 0.0001
kPriceCalc.versions = {};

kPriceCalc.const = {};
kPriceCalc.const.items = {};
kPriceCalc.const.items.ItemEquipLocs = {
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
kPriceCalc.defaults = {
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
					name = "kPriceCalcMainFrame",
					scale = 1,
					visible = true,
					width = 325,
				},
			},
		},
		items = {
			{id = 49632, name = "Runescroll of Fortitude", numberPerCombine = 5, 
				combos = {
					{
						id = 1,
						name = "Snowfall Ink",
						mats = {
							{id = 43127, name = "Snowfall Ink", numberPerCombine = 1, costPer = 160000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 2,
						name = "Icy Pigment",
						mats = {
							{id = 43109, name = "Icy Pigment", numberPerCombine = 2, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},					
					{
						id = 3,
						name = "Adder's Tongue",
						mats = {
							{id = 36903, name = "Adder's Tongue", numberPerCombine = 20, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 4,
						name = "Icethorn",
						mats = {
							{id = 36906, name = "Icethorn", numberPerCombine = 20, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 5,
						name = "Lichbloom",
						mats = {
							{id = 36905, name = "Lichbloom", numberPerCombine = 20, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 6,
						name = "Fire Seed",
						mats = {
							{id = 39969, name = "Fire Seed", numberPerCombine = 40, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 7,
						name = "Talandra's Rose",
						mats = {
							{id = 36907, name = "Talandra's Rose", numberPerCombine = 40, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 8,
						name = "Goldclover",
						mats = {
							{id = 36901, name = "Goldclover", numberPerCombine = 40, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 9,
						name = "Deadnettle",
						mats = {
							{id = 37921, name = "Deadnettle", numberPerCombine = 40, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 10,
						name = "Tiger Lily",
						mats = {
							{id = 36904, name = "Tiger Lily", numberPerCombine = 40, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
					{
						id = 11,
						name = "Fire Leaf",
						mats = {
							{id = 39970, name = "Fire Leaf", numberPerCombine = 40, costPer = 17000},
							{id = 39502, name = "Resilient Parchment", numberPerCombine = 5, costPer = 5000},
						},
					},
				},
			},
			{id = 67438, name = "Flask of Flowing Water", numberPerCombine = 1, 
				combos = {
					{
						id = 1,
						name = "Basic Flask",
						mats = {
							{id = 52329, name = "Volatile Life", numberPerCombine = 6, costPer = 160000},
							{id = 52984, name = "Stormvine", numberPerCombine = 12, costPer = 5000},
							{id = 52986, name = "Heartblossom", numberPerCombine = 12, costPer = 5000},
							{id = 3371, name = "Crystal Vial", numberPerCombine = 1, costPer = 1000},
						},
					},
				},
			},
			{id = 58085, name = "Flask of Steelskin", numberPerCombine = 1, 
				combos = {
					{
						id = 1,
						name = "Basic Flask",
						mats = {
							{id = 52329, name = "Volatile Life", numberPerCombine = 6, costPer = 160000},
							{id = 52983, name = "Cinderbloom", numberPerCombine = 12, costPer = 5000},
							{id = 52987, name = "Twilight Jasmine", numberPerCombine = 12, costPer = 5000},
							{id = 3371, name = "Crystal Vial", numberPerCombine = 1, costPer = 1000},
						},
					},
				},
			},			
			{id = 58088, name = "Flask of Titanic Strength", numberPerCombine = 1, 
				combos = {
					{
						id = 1,
						name = "Basic Flask",
						mats = {
							{id = 52329, name = "Volatile Life", numberPerCombine = 6, costPer = 160000},
							{id = 52983, name = "Cinderbloom", numberPerCombine = 12, costPer = 5000},
							{id = 52988, name = "Whiptail", numberPerCombine = 12, costPer = 5000},
							{id = 3371, name = "Crystal Vial", numberPerCombine = 1, costPer = 1000},
						},
					},
				},
			},	
			{id = 58086, name = "Flask of Draconic Mind", numberPerCombine = 1, 
				combos = {
					{
						id = 1,
						name = "Basic Flask",
						mats = {
							{id = 52329, name = "Volatile Life", numberPerCombine = 6, costPer = 160000},
							{id = 52985, name = "Azshara's Veil", numberPerCombine = 12, costPer = 5000},
							{id = 52987, name = "Twilight Jasmine", numberPerCombine = 12, costPer = 5000},
							{id = 3371, name = "Crystal Vial", numberPerCombine = 1, costPer = 1000},
						},
					},
				},
			},
			{id = 58087, name = "Flask of the Winds", numberPerCombine = 1, 
				combos = {
					{
						id = 1,
						name = "Basic Flask",
						mats = {
							{id = 52329, name = "Volatile Life", numberPerCombine = 6, costPer = 160000},
							{id = 52985, name = "Azshara's Veil", numberPerCombine = 12, costPer = 5000},
							{id = 52988, name = "Whiptail", numberPerCombine = 12, costPer = 5000},
							{id = 3371, name = "Crystal Vial", numberPerCombine = 1, costPer = 1000},
						},
					},
				},
			},			
		},
	},
};
kPriceCalc.threading = {};
kPriceCalc.threading.timers = {};
kPriceCalc.threading.timerPool = {};
-- Create Options Table
kPriceCalc.options = {
    name = "kPriceCalc",
    handler = kPriceCalc,
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
			desc = 'Show the main kPriceCalc frame.',
			guiHidden = true,
			func = function()
				kPriceCalc:Gui_InitializeFrames();
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
										kPriceCalc.db.profile.gui.frames.main.height = value
										kPriceCalc:Gui_RefreshFrame(getglobal(kPriceCalc.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kPriceCalc.db.profile.gui.frames.main.height end,
								},
								width = {
									name = 'Width',
									desc = 'Width of Main Frame.',
									type = 'range',
									min = 240,
									max = 400,
									step = 1,
									set = function(info,value)
										kPriceCalc.db.profile.gui.frames.main.width = value
										kPriceCalc:Gui_RefreshFrame(getglobal(kPriceCalc.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kPriceCalc.db.profile.gui.frames.main.width end,
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
										return kPriceCalc.db.profile.gui.frames.main.font -- variable that is my current selection
									end,
									set = function(info,value)
										kPriceCalc.db.profile.gui.frames.main.font = value -- saves our new selection the the current one
										kPriceCalc:Gui_HookFrameRefreshUpdate();
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
										kPriceCalc.db.profile.gui.frames.main.fontSize = value
										kPriceCalc:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kPriceCalc.db.profile.gui.frames.main.fontSize end,
								},
							},
						},
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kPriceCalc window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kPriceCalc.db.profile.gui.frames.main.scale = value;
								kPriceCalc:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kPriceCalc.db.profile.gui.frames.main.scale end,
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
					set = function(info,value) kPriceCalc.db.profile.debug.enabled = value end,
					get = function(info) return kPriceCalc.db.profile.debug.enabled end,
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
					set = function(info,value) kPriceCalc.db.profile.debug.threshold = value end,
					get = function(info) return kPriceCalc.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kPriceCalc.dialog:Open("kPriceCalc") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kPriceCalc version',
			func = function() 
				kPriceCalc:Print("Version: |cFF"..kPriceCalc:RGBToHex(0,255,0)..kPriceCalc.version.."|r");
			end,
			guiHidden = true,
        },
	},
};