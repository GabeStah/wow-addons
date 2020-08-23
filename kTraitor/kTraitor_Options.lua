-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kTraitor.minRequiredVersion = 0.0002;
kTraitor.version = 0.0002;
kTraitor.versions = {};

kTraitor.const = {};
kTraitor.const.items = {};
kTraitor.const.items.ItemEquipLocs = {
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
kTraitor.defaults = {
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
kTraitor.threading = {};
kTraitor.threading.timers = {};
kTraitor.threading.timerPool = {};
-- Create Options Table
kTraitor.options = {
    name = "kTraitor",
    handler = kTraitor,
    type = 'group',
    args = {
		settings = {
			name = 'Settings',
			type = 'group',
			order = 1,
			args = {
				description1 = {
					name = 'Checking "Enabled" allows kTraitor to parse your MOUSEOVER and TARGET_CHANGED events during combat to find all valid, *unique* Swarm Scarabs for the Traitor King achievement.  These events will not be parsed when you are not in Trial of the Crusade nor when the NPCs you are hovering over/targetting are invalid name matches.',
					type = 'description',
					order = 0,
				},	
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle if kTraitor is enabled.',
					set = function(info,value)
						kTraitor.db.profile.enabled = value;
						kTraitor.isEnabled = kTraitor.db.profile.enabled;
						if kTraitor.isEnabled then
							kTraitor:EnteringCombat()
						else
							kTraitor:ExitingCombat();
						end
					end,
					get = function(info) return kTraitor.db.profile.enabled end,
					width = "full",
					order = 1,
				},	
				description2 = {
					name = 'Checking "Show Scarab Tracking Frame" displays the basic tracking frame for Scarab spawns during the Anub encounter.  The frame displays each player in the raid, the total number of unique Scarabs currently agroed on that player, and the total threat value that player has generated on all Scarabs.  It also displays a TOTALS row to quickly view the overall Scarab count during the fight.|n|nThis frame is very basic and thus cannot be resized.  However, you may move the frame by holding down ALT and dragging to another location.  In addition, you may sort the table by clicking the header names when valid data exists.|n|nIn the event you do not wish to view the tracking frame, uncheck this box, but leave "Enabled" above checked.  This will allow your game-client to continue sending updates to the rest of the raid without forcing you to add the tracking window.',
					type = 'description',
					order = 2,
				},			
				toggleFrame = {
					name = 'Show Scarab Tracking Frame',
					type = 'toggle',
					desc = 'Determine if the Tracking Frame should be displayed.',
					set = function(info,value)
						kTraitor.db.profile.frame.enabled = value
						if kTraitor.db.profile.frame.enabled == true then
							kTraitor:Gui_ShowFrame();
						else
							kTraitor:Gui_HideFrame();
						end
					end,
					get = function(info) return kTraitor.db.profile.frame.enabled end,
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
					set = function(info,value) kTraitor.db.profile.debug.enabled = value end,
					get = function(info) return kTraitor.db.profile.debug.enabled end,
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
					set = function(info,value) kTraitor.db.profile.debug.threshold = value end,
					get = function(info) return kTraitor.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kTraitor.dialog:Open("kTraitor") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kTraitor version',
			func = function() 
				kTraitor:Print("Version: |cFF"..kTraitor:RGBToHex(0,255,0)..kTraitor.version.."|r");
			end,
			guiHidden = true,
        },
	},
};