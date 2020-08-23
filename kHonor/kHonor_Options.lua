-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kHonor.minRequiredVersion = 0.0001;
kHonor.version = 0.0001
kHonor.versions = {};
kHonor.timerHandles = {};
kHonor.const = {};
kHonor.const.items = {};
kHonor.const.items.ItemEquipLocs = {
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
kHonor.defaults = {
	profile = {
		enabled = true,	
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
					name = "kHonorMainFrame",
					scale = 1,
					visible = true,
					width = 325,
				},
			},
		},
		battleground = {
			announce = {
				channel = "WHISPER",
				enabled = true,
				hourlyRate = {
					enabled = true,
				},
				player = "Kulldon",
			},
			autojoin = true,
			autoleave = true,
			autorepop = true,
			debuffs = {
				"Inactive",
			},
			idle = false,
			joinWhileInActiveBattle = true,
			enabled = true,
			warnings = {
				afk = true,
				afkTimer = 10,
				idle = true,
				whisper = true,
			},
			lowVolumeMode = {
				enabled = true,
			},
		},
	},
};
kHonor.threading = {};
kHonor.threading.timers = {};
kHonor.threading.timerPool = {};
-- Create Options Table
kHonor.options = {
    name = "kHonor",
    handler = kHonor,
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
			desc = 'Show the main kHonor frame.',
			guiHidden = true,
			func = function()
				kHonorMainFrame:Show()
			end,
		},	
		battleground = {
			type = "group",
			name = "Battleground",
			desc = "Battleground options.",
			args = {
				announce = {
					type = "group",
					name = "Announce",
					desc = "Announcement options.",
					args = {
						channel = {
							type = 'select',
							name = "Channel",
							desc = "Set announcement channel.",
							get = function(info)
								return kHonor.db.profile.battleground.announce.channel;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.announce.channel = value;
							end,
							values = {["SAY"] = "Say", ["PARTY"] = "Party", ["RAID"] = "Raid", ["WHISPER"] = "Whisper"},
						},
						enabled = {
							type = "toggle",
							name = "Enabled",
							desc = "Toggle end-of-match announcements.",
							get = function(info)
								return kHonor.db.profile.battleground.announce.enabled;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.announce.enabled = value;
							end,
							handler = { [false] = "Disabled", [true] = "Enabled" },
							order = 3,
						},
						player = {
							type = 'input',
							name = "Player Name",
							desc = "Set your announcement whisper name.",
							get = function(info)
								return kHonor.db.profile.battleground.announce.player;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.announce.player = value;
							end,
							usage = "<any string>",
						},	
						hourlyrate = {
							type = "group",
							name = "Hourly Rate",
							desc = "Announce hourly Honor rate.",
							args = {	
								enabled = {
									type = "toggle",
									name = "Enabled",
									desc = "Toggle end-of-match announcements.",
									get = function(info)
										return kHonor.db.profile.battleground.announce.hourlyRate.enabled;
									end,
									set = function(info,value)
										kHonor.db.profile.battleground.announce.hourlyRate.enabled = value;
									end,
									handler = { [false] = "Disabled", [true] = "Enabled" },
								},
								reset = {
									type = "execute",
									name = "Reset",
									desc = "Reset hourly timer.",
									func = function()
										kHonor:ResetHourlyRateTimer();
									end,
								},
							},
						},
						header = {
							type = "header",
							name = "Battleground Announcements",
							order = 1,
						},				
					},
				},
				lowVolumeMode = {
					type = "toggle",
					name = "Low Volume Mode",
					desc = "Toggle low volume mode (turns off all sound in battleground except when warnings occur and increases volume for warning sounds).",
					get = function(info)
						return kHonor.db.profile.battleground.lowVolumeMode.enabled;
					end,
					set = function(info,value)
						kHonor.db.profile.battleground.lowVolumeMode.enabled = value;
					end,
					handler = { [false] = "Disabled", [true] = "Enabled" },
					order = 3,
				},
				autojoin = {
					type = "toggle",
					name = "Autojoin",
					desc = "Toggle start of match auto-joining.",
					get = function(info)
						return kHonor.db.profile.battleground.autojoin;
					end,
					set = function(info,value)
						kHonor.db.profile.battleground.autojoin = value;
					end,
					handler = { [false] = "Disabled", [true] = "Enabled" },
					order = 3,
				},
				autojoinwhileinbattle = {
					type = "toggle",
					name = "Autojoininbattle",
					desc = "Toggle start of match auto-joining while already in a battleground.",
					get = function(info)
						return kHonor.db.profile.battleground.joinWhileInActiveBattle;
					end,
					set = function(info,value)
						kHonor.db.profile.battleground.joinWhileInActiveBattle = value;
					end,
					handler = { [false] = "Disabled", [true] = "Enabled" },
					order = 4,
				},				
				autoleave = {
					type = "toggle",
					name = "Autoleave",
					desc = "Toggle start of match auto-leaving.",
					get = function(info)
						return kHonor.db.profile.battleground.autoleave;
					end,
					set = function(info,value)
						kHonor.db.profile.battleground.autoleave = value;
					end,
					handler = { [false] = "Disabled", [true] = "Enabled" },
					order = 5,
				},
				autorepop = {
					type = "toggle",
					name = "Autorepop",
					desc = "Toggle automatic release when dead in battleground.",
					get = function(info)
						return kHonor.db.profile.battleground.autorepop;
					end,
					set = function(info,value)
						kHonor.db.profile.battleground.autorepop = value;
					end,
					handler = { [false] = "Disabled", [true] = "Enabled" },
					order = 6,
				},
				warnings = {
					type = "group",
					name = "Warnings",
					desc = "Warning options.",
					args = {
						afk = {
							type = "toggle",
							name = "Afk",
							desc = "Toggle afk warning.",
							get = function(info)
								return kHonor.db.profile.battleground.warnings.afk;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.warnings.afk = value;
							end,
							handler = { [false] = "Disabled", [true] = "Enabled" },
						},
						afktimer = {
							name = "Afk Timer",
							type = "range",
							desc = "Change the seconds before an AFK that warning is sent.",
							get = function(info)
								return kHonor.db.profile.battleground.warnings.afkTimer;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.warnings.afkTimer = value;
							end,
							min = 5,
							max = 50,
							step = 1, 
							isPercent = false,
						},
						idle = {
							type = "toggle",
							name = "Idle",
							desc = "Toggle idle warning.",
							get = function(info)
								return kHonor.db.profile.battleground.warnings.idle;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.warnings.idle = value;
							end,
							handler = { [false] = "Disabled", [true] = "Enabled" },
						},
						whisper = {
							type = "toggle",
							name = "Whisper",
							desc = "Toggle whisper warning.",
							get = function(info)
								return kHonor.db.profile.battleground.warnings.whisper;
							end,
							set = function(info,value)
								kHonor.db.profile.battleground.warnings.whisper = value;
							end,
							handler = { [false] = "Disabled", [true] = "Enabled" },
						},
						header = {
							type = "header",
							name = "Warnings",
							order = 1,
						},
					},
				},
				enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Toggle if Battlegrounds options are active.",
					get = function(info)
						return kHonor.db.profile.battleground.enabled;
					end,
					set = function(info,value)
						kHonor.db.profile.battleground.enabled = value;
					end,
					handler = { [false] = "Disabled", [true] = "Enabled" },
					order = 2,
				},
				header = {
					type = "header",
					name = "Battleground Options",
					order = 1,
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
										kHonor.db.profile.gui.frames.main.height = value
										kHonor:Gui_RefreshFrame(getglobal(kHonor.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kHonor.db.profile.gui.frames.main.height end,
								},
								width = {
									name = 'Width',
									desc = 'Width of Main Frame.',
									type = 'range',
									min = 240,
									max = 400,
									step = 1,
									set = function(info,value)
										kHonor.db.profile.gui.frames.main.width = value
										kHonor:Gui_RefreshFrame(getglobal(kHonor.db.profile.gui.frames.main.name))
									end,
									get = function(info) return kHonor.db.profile.gui.frames.main.width end,
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
										return kHonor.db.profile.gui.frames.main.font -- variable that is my current selection
									end,
									set = function(info,value)
										kHonor.db.profile.gui.frames.main.font = value -- saves our new selection the the current one
										kHonor:Gui_HookFrameRefreshUpdate();
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
										kHonor.db.profile.gui.frames.main.fontSize = value
										kHonor:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kHonor.db.profile.gui.frames.main.fontSize end,
								},
							},
						},
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kHonor window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kHonor.db.profile.gui.frames.main.scale = value;
								kHonor:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kHonor.db.profile.gui.frames.main.scale end,
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
					set = function(info,value) kHonor.db.profile.debug.enabled = value end,
					get = function(info) return kHonor.db.profile.debug.enabled end,
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
					set = function(info,value) kHonor.db.profile.debug.threshold = value end,
					get = function(info) return kHonor.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kHonor.dialog:Open("kHonor") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kHonor version',
			func = function() 
				kHonor:Print("Version: |cFF"..kHonor:RGBToHex(0,255,0)..kHonor.version.."|r");
			end,
			guiHidden = true,
        },
	},
};