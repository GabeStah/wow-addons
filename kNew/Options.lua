-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kNew.minRequiredVersion = '0.0.100';
kNew.version = '0.0.100';
kNew.versions = {};

kNew.const = {};
kNew.const.items = {};
kNew.const.raid = {};
kNew.const.raid.presenceTick = 60;
kNew.const.items.ItemEquipLocs = {
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
kNew.const.chatPrefix = "<kNew> ";
kNew.const.wishlist = {};
kNew.const.wishlist.autoUpdateFrequency = 10;
kNew.const.wishlist.atlasLootTableName = "AtlasLootWishList";
kNew.defaults = {
	profile = {
		modules = {
		},
		coords = {
		},
		debug = {
			enabled = false,
			threshold = 1,
		},
		bidding = {
			auctionReceivedEffect = 3,
			auctionReceivedSound = "Info",
			auctionReceivedTextAlert = 2,
			auctionWinnerReceivedEffect = 1,
			auctionWinnerReceivedSound = "Sonar",
			auctionWinnerReceivedTextAlert = 2,
			auctionWonEffect = 3,
			auctionWonSound = "Victory",
			auctionWonTextAlert = 2,
			autoPopulateCurrentItem = true,
		},
		gui = {
			frames = {
				bids = {
					font = "ABF",
					fontSize = 12,
					minimized = false,
					visible = true,
					width = 325,
				},
				currentItem = {
					name = 'kNewCurrentItemFrame',
					anchorSide = 'LEFT',
					visible = true,
				},
				itemsWon = {
					name = 'kNewItemsWonFrame',
					anchorSide = 'TOP',
					visible = false,
				},
				main = {
					autoRemoveAuctions = false,
					autoRemoveAuctionsDelay = 20,
					barBackgroundColor = {r = 0.5, g = 0.5, b = 0.5, a = 0.5},
					barColor = {r = 1, g = 0, b = 0, a = 1},
					barTexture = "BantoBar",
					font = "ABF",
					fontSize = 12,
					height = 152,
					itemPopoutDuration = 1,					
					minimized = false,
					name = "kNewMainFrame",
					scale = 1,
					selectedBarBackgroundColor = {r = 0.5, g = 0.5, b = 0.5, a = 0.5},
					selectedBarColor = {r = 0, g = 1, b = 0, a = 0.3},
					selectedBarTexture = "BantoBar",
					visible = true,
					width = 325,
					tabs = {
						selectedColor = {r = 0.1, g = 0, b = 0.9, a = 0.25},
						highlightColor = {r = 0.05, g = 0, b = 0.85, a = 0.15},
						inactiveColor = {r = 0, g = 0, b = 0, a = 0},
					},
				},
			},
		},
		items = {
			blackList = { -- Items
				"Badge of Justice",
				"Emblem of Conquest",
				"Emblem of Heroism",
				"Emblem of Valor",
				"Emblem of Triumph",
			},	
			blackListSelected = 1,
			itemTypeWhiteList = {
				{name = "INVTYPE_BAG", auctionType = 1, pattern = INVTYPE_BAG}, -- Random
				{name = "ITEM_BIND_QUEST", auctionType = false, pattern = ITEM_BIND_QUEST},
				{name = "ITEM_SOULBOUND", auctionType = false, pattern = ITEM_SOULBOUND},
				{name = "ITEM_STARTS_QUEST", auctionType = 1, pattern = ITEM_STARTS_QUEST}, -- Random
			},
			itemTypeWhiteListSelected = 1,
			whiteList = { -- Items		
				--MISC
				{id=67423, auctionType=2, currentItemSlot=5},
				{id=67424, auctionType=2, currentItemSlot=5},
				{id=67425, auctionType=2, currentItemSlot=5},
				{id=65000, auctionType=2, currentItemSlot=1},
				{id=65001, auctionType=2, currentItemSlot=1},
				{id=65002, auctionType=2, currentItemSlot=1},
				{id=66998, auctionType=2, currentItemSlot={1,3,5,7,10}},
				{id=67429, auctionType=2, currentItemSlot=10},
				{id=67430, auctionType=2, currentItemSlot=10},
				{id=67431, auctionType=2, currentItemSlot=10},
				{id=63683, auctionType=2, currentItemSlot=1},
				{id=63684, auctionType=2, currentItemSlot=1},
				{id=63685, auctionType=2, currentItemSlot=1},
				{id=67428, auctionType=2, currentItemSlot=7},
				{id=67427, auctionType=2, currentItemSlot=7},
				{id=67426, auctionType=2, currentItemSlot=7},
				{id=64315, auctionType=2, currentItemSlot=3},
				{id=64314, auctionType=2, currentItemSlot=3},
				{id=64316, auctionType=2, currentItemSlot=3},
				{id=65088, auctionType=2, currentItemSlot=3},
				{id=65087, auctionType=2, currentItemSlot=3},
				{id=65089, auctionType=2, currentItemSlot=3},
				{id=71617, auctionType=2, currentItemSlot={1,3,5,7,10}},
				--[[{name = "Archivum Data Disc", auctionType = 1},
				{name = "Heroic Key to the Focusing Iris", auctionType = 1, currentItemSlot = 2}, -- Random, Neck
				{name = "Key to the Focusing Iris", auctionType = 1, currentItemSlot = 2}, -- Random, Neck
				{name = "Large Satchel of Spoils", auctionType = 1}, -- Random
				{name = "Reins of the Twilight Drake", auctionType = 1}, -- Random
				{name = "Reply-Code Alpha", auctionType = 1}, -- Random
				{name = "Satchel of Spoils", auctionType = 1}, -- Random
				{name = "Trophy of the Crusade", auctionType = 2},]]
			},	
			whiteListConfig = {
				add = {
					auctionTypeSelected = 0,
					itemSlotSelected = 0,
					name = false,
				},
			},			
			whiteListSelected = 1,
		},
		looting = {
			auctionWhisperBidEnabled = false,
			auctionWhisperBidSuppressionEnabled = true,
			auctionWhisperBidSuppressionDelay = 60,
			auctionCloseDelay = 3,
			auctionDuration = 25,
			auctionCloseVoteDuration = 20,
			auctionType = 2, -- 1: Random, 2: Council
			autoAwardRandomAuctions = true,
			autoAssignIfMasterLoot = true,
			councilMembers = {
				"Kulldon",
				"Kulldam",
				"Kilwenn",
				"Kainhighwind",
				"Dougall",
			},
			councilMemberSelected = 1,
			disenchanters = { -- Disenchanters
				"Dougall",
				"Tree",
			},	
			disenchanterSelected = 1,
			displayFirstOpenAuction = false,
			isAutoAuction = true,
			rarityThreshold = 4, -- Epic
			lootManager = nil,
			rollMaximum = 100,
			visiblePublicBidCurrentItems = true,
			visiblePublicBidRolls = true,
			visiblePublicBidVoters = true,
			visiblePublicDetails = true,
		},
		weakauras = {
			settings = {
				selectedIndex = 1,
			},
			configs = {},
		},
		wishlist = {
			enabled = true,
			autoUpdate = true,
			config = {
				selectedSection = 'list',
				searchReturnLimit = 50,
				searchMinRarity = 4,
				searchMinItemLevel = 226,
				searchSortKey = 'name',
				searchSortOrderNormal = true,
				searchThrottleLevel = 10,
				searchThrottleEquipmentLevel = 8,
				spellSearchReturnLimit = 50,
				spellSearchSortKey = 'name',
				spellSearchSortOrderNormal = true,
				listSortKey = 'name',
				listSortOrderNormal = true,
				gemMinRarity = 4,
				gemMinItemLevel = 80,
				font = "Arial Narrow",
				fontSize = 10,
				iconSize = 15,
				searchFilters = {
					
				},
			},
		},
		wishlists = {
		},
		zones = {
			validZones = {
				"Baradin Hold",
				"Blackrock Mountain: Blackwing Descent",
				"Firelands",
				"The Bastion of Twilight",
				"Throne of the Four Winds",
				"Dragon Soul",
			},
			zoneSelected = 1,
		},
		vcp = {
			raiders = {
				"Ansum",
				"Bauser",
				"Deph",
				"Dougall",
				"Galethorn",
				"Harkle",
				"Kainhighwind",
				"Kilwenn",
				"Kulldon",
				"Takaoni",
				"Tree",
			},
		},
	},
};
kNew.guids = {};
kNew.guids.wasAuctioned = {};
kNew.guids.lastObjectOpened = nil;
kNew.threading = {};
kNew.threading.timers = {};
kNew.threading.timerPool = {};
-- Create Options Table
kNew.options = {
    name = "kNew",
    handler = kNew,
    type = 'group',
    args = {
		description = {
			name = '',
			type = 'description',
			order = 0,
			hidden = true,
		},	
		show = {
			name = 'Show',
			type = 'execute',
			desc = 'Show the main kNew frame.',
			guiHidden = true,
			func = function()
				if kNew.auctions and #kNew.auctions > 0 then
					kNewMainFrame:Show()
				else
					kNew:Print("No auction data found on local client system -- hiding kNew frame until valid auction data received.");
				end
			end,
		},
		bidding = {
			name = 'Bidding',
			type = 'group',
			cmdHidden = true,
			args = {
				autoPopulateCurrentItem = {
					name = 'Auto Populate Current Item',
					desc = 'Determines if bidding frame will auto-populate Current Item selection with slot item currently equipped on your character.',
					type = 'toggle',
					set = function(info,value) kNew.db.profile.bidding.autoPopulateCurrentItem = value end,
					get = function(info) return kNew.db.profile.bidding.autoPopulateCurrentItem end,
					width = 'full',
				},				
			},
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
						auctionReceivedEffect = {
							name = 'Auction Received Effect',
							desc = 'Screen alert effect executed when a new auction is detected.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Flash',
								[3] = 'Shake',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.bidding.auctionReceivedEffect = value
								kNew:Gui_TriggerEffectsAuctionReceived()
							end,
							get = function(info) return kNew.db.profile.bidding.auctionReceivedEffect end,
							order = 1,
						},
						auctionReceivedSound = {
							type = 'select',
							dialogControl = 'LSM30_Sound', --Select your widget here
							name = 'Auction Alert Sound',
							desc = 'Sound played when a new auction is detected.',
							values = AceGUIWidgetLSMlists.sound, -- this table needs to be a list of keys found in the sharedmedia type you want
							get = function(info)
								return kNew.db.profile.bidding.auctionReceivedSound -- variable that is my current selection
							end,
							set = function(info,value)
								kNew.db.profile.bidding.auctionReceivedSound = value; -- saves our new selection the the current one
							end,
							order = 2,
						},
						auctionReceivedTextAlert = {
							name = 'Auction Received Text Alert',
							desc = 'Determines if and where a text alert is displayed when a new auction is detected.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Chat Window',
								--[3] = 'Raid Warning',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.bidding.auctionReceivedTextAlert = value
							end,
							get = function(info) return kNew.db.profile.bidding.auctionReceivedTextAlert end,
							order = 3,
						},	
						displayFirstOpenAuction = {
							name = 'Scroll to First Open Auction',
							type = 'toggle',
							desc = 'Determines if kNew will automatically scroll the Auction list to display the first Active auction whenever a new auction is detected.  If unchecked, scrolling will not be automated and new auctions may appear further down the list.  |cFF'..kNew:RGBToHex(200,0,0)..'NOTE: This feature is in alpha and can cause graphical display issues, though functionality is not affected.|r',
							set = function(info,value) kNew.db.profile.looting.displayFirstOpenAuction = value end,
							get = function(info) return kNew.db.profile.looting.displayFirstOpenAuction end,
							width = 'full',
							order = 4,
						},
					},
				},
				framesInline2 = {
					name = 'Auction Winner Received Events',
					type = 'group',
					guiInline = true,
					args = {
						auctionWonEffect = {
							name = 'Auction Winner Received Effect',
							desc = 'Screen alert effect executed when an auction winner is declared.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Flash',
								[3] = 'Shake',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.bidding.auctionWinnerReceivedEffect = value
								kNew:Gui_TriggerEffectsAuctionWinnerReceived()
							end,
							get = function(info) return kNew.db.profile.bidding.auctionWinnerReceivedEffect end,
							order = 1,
						},
						auctionWonSound = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							name = 'Auction Winner Received Sound',
							desc = 'Sound played when an auction winner is declared.',
							values = AceGUIWidgetLSMlists.sound,
							get = function(info)
								return kNew.db.profile.bidding.auctionWinnerReceivedSound;
							end,
							set = function(info,value)
								kNew.db.profile.bidding.auctionWinnerReceivedSound = value;
							end,
							order = 2,
						},
						auctionWonTextAlert = {
							name = 'Auction Winner Received Text Alert',
							desc = 'Determines if and where a text alert is displayed when an auction winner is declared.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Chat Window',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.bidding.auctionWinnerReceivedTextAlert = value
							end,
							get = function(info) return kNew.db.profile.bidding.auctionWinnerReceivedTextAlert end,
							order = 3,
						},
					},
				},
				framesInline3 = {
					name = 'Auction Won Events',
					type = 'group',
					guiInline = true,
					args = {
						auctionWonEffect = {
							name = 'Auction Won Effect',
							desc = 'Screen alert effect executed when you win an auction.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Flash',
								[3] = 'Shake',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.bidding.auctionWonEffect = value
								kNew:Gui_TriggerEffectsAuctionWon()
							end,
							get = function(info) return kNew.db.profile.bidding.auctionWonEffect end,
							order = 1,
						},
						auctionWonSound = {
							type = 'select',
							dialogControl = 'LSM30_Sound', --Select your widget here
							name = 'Auction Won Sound',
							desc = 'Sound played when you win an auction.',
							values = AceGUIWidgetLSMlists.sound, -- this table needs to be a list of keys found in the sharedmedia type you want
							get = function(info)
								return kNew.db.profile.bidding.auctionWonSound -- variable that is my current selection
							end,
							set = function(info,value)
								kNew.db.profile.bidding.auctionWonSound = value; -- saves our new selection the the current one
							end,
							order = 2,
						},
						auctionWonTextAlert = {
							name = 'Auction Won Text Alert',
							desc = 'Determines if and where a text alert is displayed when you win an auction.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Chat Window',
								--[3] = 'Raid Warning',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.bidding.auctionWonTextAlert = value
							end,
							get = function(info) return kNew.db.profile.bidding.auctionWonTextAlert end,
							order = 3,
						},
					},
				},								
			},	
		},	
		admin = {
			name = 'Admin',
			type = 'group',
			cmdHidden = true,
			args = {
				auctions = {
					name = 'Auctions',
					type = 'group',
					cmdHidden = true,
					order = 1,
					args = {
						description = {
							name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
							type = 'description',
							order = 0,
							hidden = true,
						},
						auctionType = {
							name = 'Auction Type',
							desc = 'Type of auction to perform.  Random will auto-generate random rolls for all bidders, whereas Loot Council will let Raid Leader assign drops.',
							type = 'select',
							values = {
								[1] = 'Random',
								[2] = 'Loot Council',
							},
							style = 'dropdown',
							set = function(info,value) kNew.db.profile.looting.auctionType = value end,
							get = function(info) return kNew.db.profile.looting.auctionType end,
							order = 1,
						},			
						auctionDuration = {
							name = 'Auction Duration',
							desc = 'Default auction timeout length.',
							type = 'range',
							min = 5,
							max = 120,
							step = 1,
							set = function(info,value)
								kNew.db.profile.looting.auctionDuration = value
							end,
							get = function(info) return kNew.db.profile.looting.auctionDuration end,
							order = 2,
						},				
						rarityThreshold = {
							name = 'Rarity Threshold',
							desc = 'Description for Rarity Threshold',
							type = 'select',
							values = {
								[0] = 'Poor',
								[1] = 'Common',
								[2] = 'Uncommon',
								[3] = 'Rare',
								[4] = 'Epic',
								[5] = 'Legendary',
							},
							style = 'dropdown',
							set = function(info,value) kNew.db.profile.looting.rarityThreshold = value end,
							get = function(info) return kNew.db.profile.looting.rarityThreshold end,
							order = 3,
						},
						rollMaximum = {
							name = 'Maximum Roll Limit',
							desc = 'Random auction type rolls utilize a random number generated between 1 and the Maximum Roll Limit.',
							type = 'range',
							min = 1,
							max = 200,
							step = 1,
							set = function(info,value) kNew.db.profile.looting.rollMaximum = value end,
							get = function(info) return kNew.db.profile.looting.rollMaximum end,
							order = 4,
						},				
						auctionCloseDelay = {
							name = 'Auction Close Delay',
							desc = 'Seconds to delay auction close announcements.',
							type = 'range',
							min = 0,
							max = 10,
							step = 1,
							set = function(info,value) kNew.db.profile.looting.auctionCloseDelay = value end,
							get = function(info) return kNew.db.profile.looting.auctionCloseDelay end,
							order = 5,
						},
						auctionCloseVoteDuration = {
							name = 'Auction Close Vote Delay',
							desc = 'Seconds after auction closure to allow Loot Council voting.',
							type = 'range',
							min = 0,
							max = 120,
							step = 1,
							set = function(info,value) kNew.db.profile.looting.auctionCloseVoteDuration = value end,
							get = function(info) return kNew.db.profile.looting.auctionCloseVoteDuration end,
							order = 6,
						},													
						isAutoAuction = {
							name = 'Auto Auction',
							desc = 'Auto Auction Desc',
							type = 'toggle',
							set = function(info,value) kNew.db.profile.looting.isAutoAuction = value end,
							get = function(info) return kNew.db.profile.looting.isAutoAuction end,
							width = 'full',
						},	
						autoAssignIfMasterLoot = {
							name = 'Auto Assign Items via Master Loot',
							type = 'toggle',
							desc = 'Auto Assign Items via Master Loot',
							set = function(info,value) kNew.db.profile.looting.autoAssignIfMasterLoot = value end,
							get = function(info) return kNew.db.profile.looting.autoAssignIfMasterLoot end,
							width = 'full',
						},														
						autoAwardRandomAuctions = {
							name = 'Auto Award Random Auctions',
							type = 'toggle',
							desc = 'Auto Award Random Auctions',
							set = function(info,value) kNew.db.profile.looting.autoAwardRandomAuctions = value end,
							get = function(info) return kNew.db.profile.looting.autoAwardRandomAuctions end,
							width = 'full',
						},				
						whisperBidInline = {
							name = 'Whisper Bid System',
							type = 'group',
							guiInline = true,
							args = {
								auctionWhisperBidEnabled = {
									name = 'Whisper Bid Enabled',
									desc = 'Enable/disable the Whisper Bid system.',
									type = 'toggle',
									set = function(info,value) kNew.db.profile.looting.auctionWhisperBidEnabled = value end,
									get = function(info) return kNew.db.profile.looting.auctionWhisperBidEnabled end,
									width = 'full',
									order = 1,
								},	
								auctionWhisperBidSuppressionEnabled = {
									name = 'Whisper Suppression Enabled',
									desc = 'Enable/disable suppression of auction-based whisper messages, which will hide incoming and outgoing messages during and for a brief time after relevant auctions are created.',
									type = 'toggle',
									set = function(info,value) kNew.db.profile.looting.auctionWhisperBidSuppressionEnabled = value end,
									get = function(info) return kNew.db.profile.looting.auctionWhisperBidSuppressionEnabled end,
									width = 'full',
									order = 2,
								},							
								auctionWhisperBidSuppressionDelay = {
									name = 'Auction Whisper Bid Suppression Delay',
									desc = 'Seconds after auction closure to continue suppression of whispers containing auctioned itemlinks.',
									type = 'range',
									min = 0,
									max = 300,
									step = 5,
									set = function(info,value) kNew.db.profile.looting.auctionWhisperBidSuppressionDelay = value end,
									get = function(info) return kNew.db.profile.looting.auctionWhisperBidSuppressionDelay end,
									order = 3,							
								},											
							},
						},						
						bidsInline = {
							name = 'Bid Details Public Visibility',
							type = 'group',
							guiInline = true,
							args = {
								visiblePublicDetails = {
									name = 'Bids Details Visibility',
									type = 'toggle',
									desc = 'Determines if auctions can be selected to display Bids window detail information.',
									set = function(info,value) kNew.db.profile.looting.visiblePublicDetails = value end,
									get = function(info) return kNew.db.profile.looting.visiblePublicDetails end,
									width = 'full',
								},							
								visiblePublicBidCurrentItems = {
									name = 'Current Item Visibility',
									type = 'toggle',
									desc = 'Determines if Bids window displays the Current Item submitted for bidders.',
									set = function(info,value) kNew.db.profile.looting.visiblePublicBidCurrentItems = value end,
									get = function(info) return kNew.db.profile.looting.visiblePublicBidCurrentItems end,
									width = 'full',
								},	
								visiblePublicBidRolls = {
									name = 'Roll Visibility',
									type = 'toggle',
									desc = 'Determines if Bids window displays the Roll produced by kNew for Random Auctions.',
									set = function(info,value) kNew.db.profile.looting.visiblePublicBidRolls = value end,
									get = function(info) return kNew.db.profile.looting.visiblePublicBidRolls end,
									width = 'full',
								},	
								visiblePublicBidVoters = {
									name = 'Voter Visibility',
									type = 'toggle',
									desc = 'Determines if Bids window displays the Loot Council Voter details for bidders.',
									set = function(info,value) kNew.db.profile.looting.visiblePublicBidVoters = value end,
									get = function(info) return kNew.db.profile.looting.visiblePublicBidVoters end,
									width = 'full',
								},		
							},
						},
						--[[			
						lootManager = {
							type = 'input',
							name = 'Loot Manager',
							desc = 'Player assigned to manage loot rights.  If empty, Loot Management assigned to Raid Leader.',
							set = function(info,value) kNew.db.profile.looting.lootManager = value end,
							get = function(info) return kNew.db.profile.looting.lootManager end,
						},	
						]]				
					},
				},
				disenchantment = {
					name = 'Disenchantment',
					type = 'group',
					cmdHidden = true,
					order = 2,
					args = {
						description = {
							name = 'Use these settings to edit a list of valid Disenchanters who may be present at your raids.  To add a new player as a disenchanter, enter the name in the Add box and press Enter.  The current list of Enchanters is found in the Enchanters dropdown.  To remove an Enchanter, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add disenchanter Name to list.',
							get = function(info) return nil end,
							set = function(info,value)
								tinsert(kNew.db.profile.looting.disenchanters, value);
								table.sort(kNew.db.profile.looting.disenchanters);
							end,
							order = 1,
							width = 'full',
						},
						disenchanters = {
							name = 'Disenchanters',
							type = 'select',
							style = 'dropdown',
							desc = 'Current list of Disenchanters.',
							values = function() return kNew.db.profile.looting.disenchanters end,
							get = function(info) return kNew.db.profile.looting.disenchanterSelected end,
							set = function(info,value) kNew.db.profile.looting.disenchanterSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected disenchanter Name from list.',
							func = function()
								tremove(kNew.db.profile.looting.disenchanters, kNew.db.profile.looting.disenchanterSelected);
								table.sort(kNew.db.profile.looting.disenchanters);
								kNew.db.profile.looting.disenchanterSelected = 1;
							end,
							order = 3,
						},
					},
				},
				councilMembersInline = {
					name = 'Loot Council',
					type = 'group',
					cmdHidden = true,
					order = 5,
					args = {
						description = {
							name = 'Use these settings to edit a list of valid Loot Council members who may vote on Loot Council-type Auctions.  To add a new player as a Loot Council member, enter the name in the Add box and press Enter.  The current list of Loot Council members is found in the Members dropdown.  To remove an Member, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add council Member to list.',
							get = function(info) return nil end,
							set = function(info,value)
								tinsert(kNew.db.profile.looting.councilMembers, value);
								table.sort(kNew.db.profile.looting.councilMembers);
							end,
							order = 1,
							width = 'full',
						},
						councilMembers = {
							name = 'Members',
							type = 'select',
							desc = 'Current list of Loot Council members.',
							style = 'dropdown',
							values = function() return kNew.db.profile.looting.councilMembers end,
							get = function(info) return kNew.db.profile.looting.councilMemberSelected end,
							set = function(info,value) kNew.db.profile.looting.councilMemberSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected council Member from list.',
							func = function()
								tremove(kNew.db.profile.looting.councilMembers, kNew.db.profile.looting.councilMemberSelected);
								kNew:Server_InitializeCouncilMemberList();
								kNew.db.profile.looting.councilMemberSelected = 1;
							end,
							order = 3,
						},					
					},
				},
				items = {
					name = 'Item Blacklist',
					type = 'group',
					cmdHidden = true,
					order = 3,
					args = {
						description = {
							name = 'Use these settings to edit a list of Blacklisted Items.  Items in the Blacklist will not be auctioned by kNew.  Useful for high-quality currency items (Emblem of Heroism, Emblem of Valor, etc.).  To add a new item to the Blacklist, enter the exact item name in the Add box and press Enter.  The current list of Blacklisted Items is found in the Items dropdown.  To remove an Item, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add item to blacklist.',
							get = function(info) return nil end,
							set = function(info,value) 
								tinsert(kNew.db.profile.items.blackList, value);
								table.sort(kNew.db.profile.items.blackList);
							end,
							order = 1,
							width = 'full',
						},
						blackList = {
							name = 'Items',
							type = 'select',
							style = 'dropdown',
							desc = 'Current list of Blacklisted Items.',
							values = function() return kNew.db.profile.items.blackList end,
							get = function(info) return kNew.db.profile.items.blackListSelected end,
							set = function(info,value) kNew.db.profile.items.blackListSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected blacklist item.',
							func = function()
								tremove(kNew.db.profile.items.blackList, kNew.db.profile.items.blackListSelected);
								table.sort(kNew.db.profile.items.blackList);
								kNew.db.profile.items.blackListSelected = 1;
							end,
							order = 3,
						},
					},
				},	
				itemWhiteList = {
					name = 'Item Whitelist',
					type = 'group',
					cmdHidden = true,
					order = 4,
					args = {
						description = {
							name = 'Delete an existing Whitelist entry.',
							type = 'description',
							order = 0,
						},
						addInline = {
							name = 'Add New Item',
							type = 'group',
							cmdHidden = true,
							order = 1,
							args = {
								name = {
									name = 'Name',
									type = 'input',
									desc = 'Name of item to add.',
									get = function(info) return kNew.db.profile.items.whiteListConfig.add.name; end,
									set = function(info,value) kNew.db.profile.items.whiteListConfig.add.name= value; end,
									order = 1,
									width = 'full',
								},
								auctionType = {
									name = 'Auction Type',
									type = 'select',
									style = 'dropdown',
									desc = 'Type of Auction to be auto-matically assigned to this item, regardless of Admin setting.',
									values = function()
										local auctionTypes = {};
										auctionTypes[0] = "None";
										auctionTypes[1] = "Random";
										auctionTypes[2] = "Loot Council";
										return auctionTypes;
									end,
									get = function(info) return kNew.db.profile.items.whiteListConfig.add.auctionTypeSelected end,
									set = function(info,value) kNew.db.profile.items.whiteListConfig.add.auctionTypeSelected = value end,
									order = 2,
								},
								itemSlot = {
									name = 'Item Slot',
									type = 'select',
									style = 'dropdown',
									desc = 'Equipment slot to utilize when Clients are selecting a Currently Equipped item via popout.  Good for tokens or quest that have no innate slot type.',
									values = function()
										return kNew:Item_GetItemSlotDropdownValues();
									end,
									get = function(info) return kNew.db.profile.items.whiteListConfig.add.itemSlotSelected end,
									set = function(info,value) kNew.db.profile.items.whiteListConfig.add.itemSlotSelected = value end,
									order = 3,
								},
								add = {
									name = 'Add',
									type = 'execute',
									desc = 'Add item to Whitelist.',
									func = function()
										if kNew.db.profile.items.whiteListConfig.add.name then
											local booExists = false;
											local name,currentItemSlot,auctionType;
											for iItem,vItem in pairs(kNew.db.profile.items.whiteList) do
												if vItem.name == kNew.db.profile.items.whiteListConfig.add.name then
													booExists = true;
												end
											end
											if booExists == false then
												currentItemSlot = kNew:Item_GetItemSlotByDropdownIndex(kNew.db.profile.items.whiteListConfig.add.itemSlotSelected);
												if kNew.db.profile.items.whiteListConfig.add.auctionTypeSelected == 0 then
													auctionType = nil;
												else
													auctionType = kNew.db.profile.items.whiteListConfig.add.auctionTypeSelected;
												end
												tinsert(kNew.db.profile.items.whiteList, {name = kNew.db.profile.items.whiteListConfig.add.name, 
																						  auctionType = auctionType, 
																						  currentItemSlot = currentItemSlot});
												kNew.db.profile.items.whiteListConfig.add.auctionTypeSelected = 0;
												kNew.db.profile.items.whiteListConfig.add.itemSlotSelected = 0;
												kNew.db.profile.items.whiteListConfig.add.name = nil;
											end
										end
									end,
									order = 4,
								},
							},
						},
						list = {
							name = 'Items',
							type = 'select',
							style = 'dropdown',
							desc = 'Current list of Whitelist Items.',
							values = function() return kNew:Item_GetWhitelistDropdownValues(); end,
							get = function(info) return kNew.db.profile.items.whiteListSelected end,
							set = function(info,value) kNew.db.profile.items.whiteListSelected = value end,
							order = 2,
							width = 'full',
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected Whitelist item.',
							func = function()
								tremove(kNew.db.profile.items.whiteList, kNew.db.profile.items.whiteListSelected);
								kNew.db.profile.items.whiteListSelected = 1;
							end,
							order = 3,
						},
					},
				},			
				zonesInline = {
					name = 'Zones',
					type = 'group',
					cmdHidden = true,
					order = 7,
					args = {
						description = {
							name = 'Use these settings to edit a list of valid Raid Zones where kNew will track active raids.  To add a new zone, enter the name in the Add box and press Enter.  The current list of Raid Zones is found in the Zones dropdown.  To remove an Zone, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add Zone to list.',
							get = function(info) return nil end,
							set = function(info,value)
								tinsert(kNew.db.profile.zones.validZones, value);
								table.sort(kNew.db.profile.zones.validZones);
							end,
							order = 1,
							width = 'full',
						},
						councilMembers = {
							name = 'Members',
							type = 'select',
							desc = 'Current list of valid Raid Zones.',
							style = 'dropdown',
							values = function() return kNew.db.profile.zones.validZones end,
							get = function(info) return kNew.db.profile.zones.zoneSelected end,
							set = function(info,value) kNew.db.profile.zones.zoneSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected Zone from list.',
							func = function()
								tremove(kNew.db.profile.zones.validZones, kNew.db.profile.zones.zoneSelected);
								kNew.db.profile.zones.zoneSelected = 1;
							end,
							order = 3,
						},					
					},
				},
				versionChecker = {
					name = 'Version Check',
					type = 'execute',
					desc = 'Check kNew version of raid members.',
					func = function() kNew:Server_VersionCheck(true) end,
				},
				startRaid = {
					name = 'Start Raid Tracker',
					type = 'execute',
					desc = 'Start kNew raid tracking.',
					func = function() kNew:Server_ConfirmStartRaidTracking() end,
				},
				stopRaid = {
					name = 'Stop Raid Tracker',
					type = 'execute',
					desc = 'Stop kNew raid tracking.',
					func = function() kNew:Server_ConfirmStopRaidTracking() end,
				},
				testAuction = {
					name = 'Test Auction',
					type = 'execute',
					desc = 'Create a test auction of a random item.',
					func = function() kNew:Server_CreateTestAuction() end,
				},
				vcpInvite = {
					name = 'VCP Invite',
					type = 'execute',
					desc = 'Invite the raid based on current VCP standings.',
					func = function() end,
				},
				vcpAttendance = {
					name = 'VCP Attendance',
					type = 'execute',
					desc = 'Begin the VCP attendance process.',
					func = function() kNew:Server_StartVcpAttendanceCheck() end,
				},
			},
		},			
		gui = {
			name = 'Interface',
			type = 'group',
			cmdHidden = true,
			args = {
				bids = {
					name = 'Bids Frame',
					type = 'group',
					args = {
						fonts = {
							name = 'Font',
							type = 'group',
							guiInline = true,
							order = 2,
							args = {
								font = {
									type = 'select',
									dialogControl = 'LSM30_Font', --Select your widget here
									name = 'Font',
									desc = 'Font of Bids Frame text.',
									values = AceGUIWidgetLSMlists.font, -- this table needs to be a list of keys found in the sharedmedia type you want
									get = function(info)
										return kNew.db.profile.gui.frames.bids.font -- variable that is my current selection
									end,
									set = function(info,value)
										kNew.db.profile.gui.frames.bids.font = value; -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
								fontSize = {
									name = 'Font Size',
									desc = 'Font Size of Bids Frame text.',
									type = 'range',
									min = 8,
									max = 20,
									step = 1,
									set = function(info,value)
										kNew.db.profile.gui.frames.bids.fontSize = value;
										kNew:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kNew.db.profile.gui.frames.bids.fontSize end,
								},
							},
						},
					},
				},			
				main = {
					name = 'Main Frame',
					type = 'group',
					args = {
						bars = {
							name = 'Bar Settings',
							type = 'group',
							guiInline = true,
							order = 3,
							args = {
								barTexture = {
									 type = 'select',
									 dialogControl = 'LSM30_Statusbar', --Select your widget here
									 name = 'Texture',
									 desc = 'Texture of timerbar for item auctions.',
									 values = AceGUIWidgetLSMlists.statusbar, -- this table needs to be a list of keys found in the sharedmedia type you want
									 get = function(info)
										  return kNew.db.profile.gui.frames.main.barTexture -- variable that is my current selection
									 end,
									 set = function(info,value)
										  kNew.db.profile.gui.frames.main.barTexture = value -- saves our new selection the the current one
										  kNew:Gui_HookFrameRefreshUpdate();
									 end,
								},
								barBackgroundColor = {
									type = 'color',
									name = 'Background Color',
									desc = 'Color of timerbar background for item auctions.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.barBackgroundColor.r, kNew.db.profile.gui.frames.main.barBackgroundColor.g, kNew.db.profile.gui.frames.main.barBackgroundColor.b, kNew.db.profile.gui.frames.main.barBackgroundColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew.db.profile.gui.frames.main.barBackgroundColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
								barColor = {
									type = 'color',
									name = 'Color',
									desc = 'Color of timerbar for item auctions.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.barColor.r, kNew.db.profile.gui.frames.main.barColor.g, kNew.db.profile.gui.frames.main.barColor.b, kNew.db.profile.gui.frames.main.barColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew:Debug("r: " .. r .. ", g: " .. g .. ", b: " .. b .. ", a: " .. a, 3)
										kNew.db.profile.gui.frames.main.barColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
							},
						},
						barsSelected = {
							name = 'Selection Bar Settings',
							type = 'group',
							guiInline = true,
							order = 5,
							args = {
								selectedBarTexture = {
									 type = 'select',
									 dialogControl = 'LSM30_Statusbar', --Select your widget here
									 name = 'Texture',
									 desc = 'Texture of selection bar for item auctions.',
									 values = AceGUIWidgetLSMlists.statusbar, -- this table needs to be a list of keys found in the sharedmedia type you want
									 get = function(info)
										  return kNew.db.profile.gui.frames.main.selectedBarTexture -- variable that is my current selection
									 end,
									 set = function(info,value)
										  kNew.db.profile.gui.frames.main.selectedBarTexture = value -- saves our new selection the the current one
										  kNew:Gui_HookFrameRefreshUpdate();
									 end,
								},
								selectedBarBackgroundColor = {
									type = 'color',
									name = 'Background Color',
									desc = 'Color of selection bar background for item auctions.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.selectedBarBackgroundColor.r, kNew.db.profile.gui.frames.main.selectedBarBackgroundColor.g, kNew.db.profile.gui.frames.main.selectedBarBackgroundColor.b, kNew.db.profile.gui.frames.main.selectedBarBackgroundColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew.db.profile.gui.frames.main.selectedBarBackgroundColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
								selectedBarColor = {
									type = 'color',
									name = 'Color',
									desc = 'Color of selection bar for item auctions.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.selectedBarColor.r, kNew.db.profile.gui.frames.main.selectedBarColor.g, kNew.db.profile.gui.frames.main.selectedBarColor.b, kNew.db.profile.gui.frames.main.selectedBarColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew:Debug("r: " .. r .. ", g: " .. g .. ", b: " .. b .. ", a: " .. a, 3)
										kNew.db.profile.gui.frames.main.selectedBarColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
							},
						},
						autoRemoveAuctions = {
							name = 'Auto-Remove Auctions',
							type = 'toggle',
							desc = 'Determine if Auctions should be auto-removed from the kNew window after they expire.',
							set = function(info,value) kNew.db.profile.gui.frames.main.autoRemoveAuctions = value end,
							get = function(info) return kNew.db.profile.gui.frames.main.autoRemoveAuctions end,
							width = 'full',
							order = 1,
						},
						autoRemoveAuctionsDelay = {
							name = 'Auto-Remove Auction Delay',
							desc = 'If Auto-Remove Auctions is enabled, this determines the delay, in seconds, after an auction ends to remove it.',
							type = 'range',
							min = 0,
							max = 120,
							step = 1,
							set = function(info,value)
								kNew.db.profile.gui.frames.main.autoRemoveAuctionsDelay = value;
							end,
							get = function(info) return kNew.db.profile.gui.frames.main.autoRemoveAuctionsDelay end,
							width = 'full',
							order = 2,
						},
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
										kNew.db.profile.gui.frames.main.height = value
										kNew:Gui_RefreshFrame(_G[kNew.db.profile.gui.frames.main.name])
									end,
									get = function(info) return kNew.db.profile.gui.frames.main.height end,
								},
								width = {
									name = 'Width',
									desc = 'Width of Main Frame.',
									type = 'range',
									min = 240,
									max = 400,
									step = 1,
									set = function(info,value)
										kNew.db.profile.gui.frames.main.width = value
										kNew:Gui_RefreshFrame(_G[kNew.db.profile.gui.frames.main.name])
									end,
									get = function(info) return kNew.db.profile.gui.frames.main.width end,
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
										return kNew.db.profile.gui.frames.main.font -- variable that is my current selection
									end,
									set = function(info,value)
										kNew.db.profile.gui.frames.main.font = value -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
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
										kNew.db.profile.gui.frames.main.fontSize = value
										kNew:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kNew.db.profile.gui.frames.main.fontSize end,
								},
							},
						},
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kNew window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kNew.db.profile.gui.frames.main.scale = value;
								kNew:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kNew.db.profile.gui.frames.main.scale end,
							width = 'full',
						},
						tabs = {
							name = 'Tab Settings',
							type = 'group',
							guiInline = true,
							order = 7,
							args = {
								highlightColor = {
									type = 'color',
									name = 'Highlight Color',
									desc = 'Color of Tab background when mouse hovers.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.tabs.highlightColor.r, kNew.db.profile.gui.frames.main.tabs.highlightColor.g, kNew.db.profile.gui.frames.main.tabs.highlightColor.b, kNew.db.profile.gui.frames.main.tabs.highlightColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew.db.profile.gui.frames.main.tabs.highlightColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},							
								inactiveColor = {
									type = 'color',
									name = 'Inactive Color',
									desc = 'Color of Tab background when not selected or highlighted.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.tabs.inactiveColor.r, kNew.db.profile.gui.frames.main.tabs.inactiveColor.g, kNew.db.profile.gui.frames.main.tabs.inactiveColor.b, kNew.db.profile.gui.frames.main.tabs.inactiveColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew.db.profile.gui.frames.main.tabs.inactiveColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
								selectedColor = {
									type = 'color',
									name = 'Selected Color',
									desc = 'Color of Tab background when tab is selected.',
									hasAlpha = true,
									get = function()
										return kNew.db.profile.gui.frames.main.tabs.selectedColor.r, kNew.db.profile.gui.frames.main.tabs.selectedColor.g, kNew.db.profile.gui.frames.main.tabs.selectedColor.b, kNew.db.profile.gui.frames.main.tabs.selectedColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kNew.db.profile.gui.frames.main.tabs.selectedColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kNew:Gui_HookFrameRefreshUpdate();
									end,
								},
							},
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
					set = function(info,value) kNew.db.profile.debug.enabled = value end,
					get = function(info) return kNew.db.profile.debug.enabled end,
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
					set = function(info,value) kNew.db.profile.debug.threshold = value end,
					get = function(info) return kNew.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
        config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kNew.dialog:Open("kNew") 
			end,
			guiHidden = true,
        },    
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kNew version',
			func = function() 
				kNew:Print("Version: |cFF"..kNew:RGBToHex(0,255,0)..kNew.version.."|r");
			end,
			guiHidden = true,
        },
		weakauras = {
			name = 'WeakAuras',
			type = 'group',
			cmdHidden = true,
			args = nil,
		},
        wishlist = {
			type = 'execute',
			name = 'Wishlist',
			desc = 'Open the Wishlist Interface',
			func = function() 
				kNew:WishlistGui_InitializeFrames();
			end,
			guiHidden = true,
        },
        wishlistConfig = {
			name = 'Wishlist',
			type = 'group',
			cmdHidden = true,
			args = {
				framesInline = {
					name = 'Wishlist Search Settings',
					type = 'group',
					guiInline = true,
					order = 1,
					args = {
						searchReturnLimit = {
							name = 'Results Limit',
							desc = 'Maximum number of search results that will be returned for any given query.  NOTE: Setting this number too high will result in extreme client lag while searching and may even freeze your client.',
							type = 'range',
							min = 10,
							max = 500,
							step = 10,
							set = function(info,value)
								kNew.db.profile.wishlist.config.searchReturnLimit = value
							end,
							get = function(info) return kNew.db.profile.wishlist.config.searchReturnLimit end,
							width = 'full',
						},
						searchMinRarity = {
							name = 'Minimum Rarity',
							desc = 'Determine what rarity items must be equal to or above to be returned in search resuls.',
							type = 'select',
							values = {
								[0] = 'Poor',
								[1] = 'Common',
								[2] = 'Uncommon',
								[3] = 'Rare',
								[4] = 'Epic',
								[5] = 'Legendary',
								[6] = 'Heirloom',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.wishlist.config.searchMinRarity = value;
							end,
							get = function(info) return kNew.db.profile.wishlist.config.searchMinRarity end,
							width = 'full',
						},
						searchMinItemLevel = {
							name = 'Minimum Item Level',
							desc = 'Determines the minumum item level items must be to be returned in search results.',
							type = 'range',
							min = 0,
							max = 400,
							step = 1,
							set = function(info,value)
								kNew.db.profile.wishlist.config.searchMinItemLevel = value;
							end,
							get = function(info) return kNew.db.profile.wishlist.config.searchMinItemLevel end,
							width = 'full',
						},
						searchThrottleLevel = {
							name = 'Search Memory Usage',
							desc = 'Determines the level of memory usage kNew will use when building the item database.  The higher this setting, the more memory used and the slower your system will be during item database updates, but the faster the update time.  If performance is an issue, a lower setting is better, but item database updates will take much longer to complete.',
							type = 'select',	
							values = {
								[1] = 'Minimum',
								[5] = 'Very Low',
								[10] = 'Low',
								[20] = 'Normal',
								[30] = 'High',
								[50] = 'Very High',
								[100] = 'Maximum',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.wishlist.config.searchThrottleLevel = value
							end,
							get = function(info) return kNew.db.profile.wishlist.config.searchThrottleLevel end,
							width = 'full',
						},
						searchThrottleEquipmentLevel = {
							name = 'Search Expansion',
							desc = 'Select the expansion(s) in which you wish to search for equipment results.  This allows you to lower the total quantity of items that must be scanned when updating the item database and limit by items released within certain expansions.',
							type = 'select',	
							values = {
								[1] = 'All Expansions',
								[2] = 'Classic',
								[3] = 'The Burning Crusade',
								[4] = 'Wrath of the Lich King',
								[5] = 'Cataclysm',
								[6] = 'Classic & The Burning Crusade',
								[7] = 'The Burning Crusade & Wrath of the Lich King',
								[8] = 'Wrath of the Lich King & Cataclysm',
							},
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.wishlist.config.searchThrottleEquipmentLevel = value
							end,
							get = function(info) return kNew.db.profile.wishlist.config.searchThrottleEquipmentLevel end,
							width = 'full',
						},
					},
				},
				framesInlineGui = {
					name = 'GUI Settings',
					type = 'group',
					guiInline = true,
					order = 3,
					args = {
						fonts = {
							name = 'Font',
							type = 'group',
							guiInline = true,
							order = 2,
							args = {
								font = {
									type = 'select',
									dialogControl = 'LSM30_Font', --Select your widget here
									name = 'Font',
									desc = 'Font of Wishlist listings.',
									values = AceGUIWidgetLSMlists.font, -- this table needs to be a list of keys found in the sharedmedia type you want
									get = function(info)
										return kNew.db.profile.wishlist.config.font -- variable that is my current selection									
									end,
									set = function(info,value)
										kNew.db.profile.wishlist.config.font = value; -- saves our new selection the the current one
										if kNew.gui.frames.list.main then
											kNew:WishlistGui_RefreshMainFrame();
											if kNew.db.profile.wishlist.config.selectedSection == 'list' then
												kNew:WishlistGui_ShowList(nil, kNew.gui.frames.list.selectedWishlist);									
											end
										end
									end,
								},
								fontSize = {
									name = 'Font Size',
									desc = 'Font Size of Wishlist listings.',
									type = 'range',
									min = 8,
									max = 20,
									step = 1,
									set = function(info,value)
										kNew.db.profile.wishlist.config.fontSize = value;
										if kNew.gui.frames.list.main then
											kNew:WishlistGui_RefreshMainFrame();
											if kNew.db.profile.wishlist.config.selectedSection == 'list' then
												kNew:WishlistGui_ShowList(nil, kNew.gui.frames.list.selectedWishlist);																		
											end
										end
									end,
									get = function(info) return kNew.db.profile.wishlist.config.fontSize end,
								},
							},				
						},
						iconSize = {
							name = 'Icon Size',
							desc = 'Item Icon Size for Wishlist listings.',
							type = 'range',
							min = 8,
							max = 20,
							step = 1,
							set = function(info,value)
								kNew.db.profile.wishlist.config.iconSize = value;
								if kNew.gui.frames.list.main then
									kNew:WishlistGui_RefreshMainFrame();
									if kNew.db.profile.wishlist.config.selectedSection == 'list' then
										kNew:WishlistGui_ShowList(nil, kNew.gui.frames.list.selectedWishlist);																
									end
								end
							end,
							get = function(info) return kNew.db.profile.wishlist.config.iconSize end,
						},								
					},
				},
			},
		},
	},
};

function kNew:Options_CreateCustomOptions()
	self.options.args.weakauras.args = {
		configs = {
			name = 'Custom Event Config',
			type = 'group',
			cmdHidden = true,			
			args = {
				addInline = {
					name = 'Purpose',
					type = 'group',
					guiInline = true,
					order = 1,
					args = {
						addName = {
							name = 'WeakAuras Configurations are used as part of Custom Event displays.  By creating a WeakAuras Configuration here in kNew, the actual configuration settings for a Custom Event display can be modified outside of WeakAuras, and more importantly, can be updated and sent to other raid members easily without requiring manual alterations from every member.\n\nThe name/ID of the WeakAura Configurations seen in this section should be unique and match the ID of the corresponding Custom Event Display found in WeakAuras.',
							type = 'description',
							order = 1,
							width = 'full',
						},
					},
				},
				currentInline = {
					name = 'Setup',
					type = 'group',
					guiInline = true,
					order = 2,		
					args = {
						addName = {
							name = 'Add a New Configuration',
							type = 'input',
							desc = 'Add a new WeakAuras configuration.',
							get = function(info) return nil end,
							set = function(info, id)
								if (id) then
									kNew:WeakAuras_AddConfig(id)
								end
							end,
							order = 0,
							width = 'full',
						},
						select = {
							name = 'Modify an Existing Config',
							desc = 'Select a WeakAuras configuration from the dropdown to edit or delete.',
							type = 'select',
							values = function()
								return kNew:WeakAuras_GetConfigList();
							end,
							style = 'dropdown',
							set = function(info,value)
								kNew.db.profile.weakauras.settings.selectedIndex = value;
								-- Close frame
								local frame
								frame = _G['kNewWeakAuraEditor']
								if frame then frame.texteditor:CancelClose() end
							end,
							get = function(info)
								return kNew.db.profile.weakauras.settings.selectedIndex;
							end,
							order = 1,
							width = "normal",
						},
						edit = {
							name = 'Edit',
							desc = 'Click to edit the configuration code for the selected ID.',
							type = 'execute',
							func = function()
								-- Check if index exists
								if (kNew.db.profile.weakauras.settings.selectedIndex and kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex]) then
									local frame
									frame = _G['kNewWeakAuraEditor']
									if frame then frame.texteditor:Open() end
								end
							end,
							order = 2,
							width = "half",
						},
						delete = {
							name = 'Delete',
							desc = 'Click to delete the configuration for the selected ID.',
							type = 'execute',
							func = function()
								if not kNew.db.profile.weakauras.settings.selectedIndex or not (#kNew.db.profile.weakauras.configs > 0) then return end
								StaticPopupDialogs["kNewPopup_WeakAuraConfigDelete"] = {
									text = "|cFF"..kNew:RGBToHex(0,255,0).."Confirm deletion?|r|n|nConfig ID: |cFF"..kNew:RGBToHex(255,0,0)..kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].id.."|r|n",
									button1 = "Destroy that fool!",
									button2 = "Nevermind...",
									OnAccept = function()
										tremove(kNew.db.profile.weakauras.configs, kNew.db.profile.weakauras.settings.selectedIndex);
										kNew.db.profile.weakauras.settings.selectedIndex = nil;
										-- Close frame
										local frame
										frame = _G['kNewWeakAuraEditor']
										if frame then frame.texteditor:CancelClose() end		
										kNew.dialog:SelectGroup('kNew', "weakauras", "configs")
									end,
									timeout = 0,
									whileDead = 1,
									hideOnEscape = 1,
								};
								StaticPopup_Show("kNewPopup_WeakAuraConfigDelete");						
							end,
							order = 3,
							width = "half",
						},
						send = {
							name = 'Send',
							desc = 'Click to broadcast this configuration to other kNew users.',
							type = 'execute',
							func = function()
								if not kNew.db.profile.weakauras.settings.selectedIndex or not (#kNew.db.profile.weakauras.configs > 0) then return end
								StaticPopupDialogs["kNewPopup_WeakAuraConfigSend"] = {
									text = "|cFF"..kNew:RGBToHex(0,255,0).."Confirm broadcast?|r|n|nConfig ID: |cFF"..kNew:RGBToHex(255,0,0)..kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].id.."|r|n",
									button1 = "Send it!",
									button2 = "Cancel",
									OnAccept = function()
										if kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex] and kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].id and kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].value then
											local config = kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex];
											kNew:SendCommunication("WeakAuraConfigBroadcast", kNew:Serialize(config.id, config.value), 3);
										end
									end,
									timeout = 0,
									whileDead = 1,
									hideOnEscape = 1,
								};
								StaticPopup_Show("kNewPopup_WeakAuraConfigSend");						
							end,
							order = 4,
							width = "half",
						},
						rename = {
							name = 'Rename',
							desc = 'Click to change the ID for this configuration.',
							type = 'execute',
							func = function()
								if not kNew.db.profile.weakauras.settings.selectedIndex or not (#kNew.db.profile.weakauras.configs > 0) then return end
								StaticPopupDialogs["kNewPopup_WeakAuraConfigRename"] = {
									text = "|cFF"..kNew:RGBToHex(0,255,0).."Enter new ID for this config|r|n|nCurrent ID: |cFF"..kNew:RGBToHex(255,0,0)..kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].id.."|r|n",
									OnAccept = function(self)
										if self.editBox:GetText() then
											kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].id = self.editBox:GetText();
											kNew.dialog:SelectGroup('kNew', "weakauras", "configs")
										end
									end,
									OnShow = function(self)
										self.editBox:SetText(kNew.db.profile.weakauras.configs[kNew.db.profile.weakauras.settings.selectedIndex].id)
									end,
									button1 = "Rename",
									button2 = "Cancel",
									timeout = 0,
									whileDead = 1,
									hideOnEscape = 1,
									hasEditBox = 1,
								};	
								StaticPopup_Show("kNewPopup_WeakAuraConfigRename");			
							end,
							order = 5,
							width = "half",
						},
					},
				},		
			},
		},
	}
end

