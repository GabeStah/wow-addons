--[[ TODO
ring/trinket slots aren't getting rating selections properly
]]

local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local BEST_ARMOR_TYPES2 = {
	DEATHKNIGHT = 'Plate',
	DRUID = 'Leather',
	HUNTER = {'Mail', 'Leather'},
	MAGE = 'Cloth',
	MONK = 'Leather',
	PALADIN = {'Plate', 'Mail'},
	PRIEST = 'Cloth',
	ROGUE = 'Leather',
	SHAMAN = {'Mail', 'Leather'},
	WARRIOR = {'Plate', 'Mail'},
	WARLOCK = 'Cloth',
};
local BEST_ARMOR_TYPES = {
	DEATHKNIGHT = 'Plate',
	DRUID = 'Leather',
	HUNTER = {'Mail', 'Leather'},
	MAGE = 'Cloth',
	MONK = 'Leather',
	PALADIN = {'Plate', 'Mail'},
	PRIEST = 'Cloth',
	ROGUE = 'Leather',
	SHAMAN = {'Mail', 'Leather'},
	WARRIOR = {'Plate', 'Mail'},
	WARLOCK = 'Cloth',
};
local QUEST_FADING_DEFAULT_VALUE = 9999;
local ARMOR_TYPE_SLOTS = {1,3,5,6,7,8,9,10,};
local HEIRLOOM_EXP_SLOTS = {1,3,5,11,12,15,};
local TOOLTIP_COLOR_RED = {r=1,g=0.1255,b=0.1255,a=1}
local ITEM_EQUIP_LOCS = {
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
	{name = "INVTYPE_FINGER", slotName = "Finger0Slot", slotNumber = {11,12}, formattedName = "Finger",},
	{name = "INVTYPE_TRINKET", slotName = "Trinket0Slot", slotNumber = {13,14}, formattedName = "Trinket",},
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
local kAutoQuest = LibStub("AceAddon-3.0"):NewAddon("kAutoQuest", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
kAutoQuest.completed_quests = {}
kAutoQuest.uncompleted_quests = {}
kAutoQuest.TIMERS = {};
kAutoQuest.THREADING_REPEAT_LIMIT = 10;
kAutoQuest.THREADING_UPDATE_TICK = 0.5;

kAutoQuest.defaults = {
	profile = {
		autoSell = {},
		autoSellMaxQuality = 2,
		debug = {
			enabled = false,
			threshold = 1,
		},
		itemsToBeSold = {},		
		merchant = {
			autoSellHighValue = false,
			autoSellJunk = false,
		},
		rewardAutomation = {
			defaultSelectTrinket = true,
			enabled = true,
			equipUpgrades = false,	
			heirloomIgnoreLevels = 2,
			minLevel = 1,
			maxLevel = 85,
			pawnScaleSelected = 'None',
			percentUpgradeThreshold = 0.05,
			retainHeirlooms = true,
			suppressOutput = false,			
		},
    quest = {
      enabled = true,
    },
		trackerVisible = true,
		whitelist = {},
	},
};

function kAutoQuest:OnInitialize()
	-- Load Database
    self.db = LibStub("AceDB-3.0"):New("kAutoQuestDB", self.defaults)
    -- Inject Options Table and Slash Commands
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0")
	self.config:RegisterOptionsTable("kAutoQuestDB", self.options)
	self.config:RegisterOptionsTable("kAutoQuestAutomation", self.questRewardAutomation)
	self.config:RegisterOptionsTable("kAutoQuestMerchant", self.merchant)
  self.config:RegisterOptionsTable("kAutoQuestQuest", self.quest)
	self.config:RegisterOptionsTable("kAutoQuestWhitelist", self.whitelist)
	self.config:RegisterOptionsTable("kAutoQuestAutoSell", self.autoSell)
	self.optParent = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("kAutoQuestDB", "kAutoQuest");
	self.opt1 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("kAutoQuestAutomation", "Reward Automation", "kAutoQuest");
	self.opt2 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("kAutoQuestMerchant", "Merchant Settings", "kAutoQuest");
	self.opt3 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("kAutoQuestAutoSell", "Auto-Sell Items", "kAutoQuest");
  self.opt2 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("kAutoQuestQuest", "Quest Automation", "kAutoQuest");
	self.opt4 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("kAutoQuestWhitelist", "Whitelist Items", "kAutoQuest");
	
	self.frame = CreateFrame("Frame", "kAutoQuestFrame")
	self.frame:SetScript('OnEvent', self.OnEvent)
	self.frame:SetScript('OnUpdate', function(self, elapsed) kAutoQuest:Threading_OnUpdate(elapsed) end);
	
	self:RegisterEvent('GOSSIP_SHOW')
	self:RegisterEvent('QUEST_COMPLETE')
	self:RegisterEvent('QUEST_DETAIL')
	self:RegisterEvent('QUEST_GREETING')
	self:RegisterEvent('QUEST_LOG_UPDATE')
	self:RegisterEvent('QUEST_PROGRESS')	
	self:RegisterEvent('MERCHANT_SHOW')
	self:RegisterChatCommand('kautoquest', 'OpenOptions')
	self:RegisterChatCommand('kaq', 'OpenOptions')
	
	-- Tracker
	self:SetTrackerVisibility()
end

function kAutoQuest:OnEnable() end
function kAutoQuest.OnEvent(self, event, ...) if self[event] then self[event](self, ...) end end
function kAutoQuest:OnDisable() end

-- **** EVENTS ****
function kAutoQuest:GOSSIP_SHOW()
	self:Debug('GOSSIP_SHOW', 3)
	if not self:CanAutomate() then return end
  if not self:ShouldAutomate() then return end
	local button, text
	for i = 1, 32 do
		button = _G['GossipTitleButton' .. i]
		if button:IsVisible() then
			text = self:StripText(button:GetText())
			if button.type == 'Available' then
				button:Click()
			elseif button.type == 'Active' then
				if self.completed_quests[text] then
					button:Click()
				end
			end
		end
	end
	self:FixQuestDetailFading()
end

function kAutoQuest:MERCHANT_SHOW()
	local itemLink, quality, itemID;
	local earnings, sellPrice = 0, 0;
	for bagID=0,4 do
		for bagSlotID=1,GetContainerNumSlots(bagID) do
			itemLink = GetContainerItemLink(bagID,bagSlotID)			
			if itemLink then
				_,_,quality,_,_,_,_,_,_,_,sellPrice = GetItemInfo(itemLink)
					if sellPrice and sellPrice > 0 then
					itemID = self:GetItemIdFromItemLink(itemLink)
					if quality == 0 and self.db.profile.merchant.autoSellJunk then -- Sell junk
						UseContainerItem(bagID,bagSlotID)
						earnings = earnings + sellPrice
						self:Debug(('Selling junk item %s for %s'):format(itemLink, GetCoinTextureString(sellPrice)), 3)
					elseif self.db.profile.itemsToBeSold[itemID] and self.db.profile.merchant.autoSellHighValue and quality <= 3 then -- never sell epic or higher items to be safe
						self.db.profile.itemsToBeSold[itemID] = nil
						UseContainerItem(bagID,bagSlotID)
						earnings = earnings + sellPrice
						self:Debug(('Selling high-value item %s for %s'):format(itemLink, GetCoinTextureString(sellPrice)), 3)
					elseif self:DoesAutoSellItemExist(itemID) then
						-- Check quality
						if quality <= self.db.profile.autoSellMaxQuality then
							UseContainerItem(bagID,bagSlotID)
							earnings = earnings + sellPrice
							self:Debug(('Selling Auto-Sell item %s for %s'):format(itemLink, GetCoinTextureString(sellPrice)), 3)
						end
					end
				end
			end
		end
	end
	if earnings > 0 then self:Output(('Auto-sold items for %s'):format(GetCoinTextureString(earnings))) end
	wipe(self.db.profile.itemsToBeSold) -- wipe auto-sell table for safety
end

function kAutoQuest:QUEST_COMPLETE(event)
  if not self:CanAutomate() then return end
	if not self:ShouldAutomate() then return end
end

function kAutoQuest:QUEST_DETAIL()
	self:Debug('QUEST_DETAIL', 3)
	if not self:CanAutomate() then return end
  if not self:ShouldAutomate() then return end
	AcceptQuest()
	self:FixQuestDetailFading()	
end

function kAutoQuest:QUEST_GREETING(...)
	self:Debug('QUEST_GREETING', 3)
	if not self:CanAutomate() then return end
  if not self:ShouldAutomate() then return end
	local button, text
	for i = 1, 32 do
		button = _G['QuestTitleButton' .. i]
		if button:IsVisible() then
			text = self:StripText(button:GetText())
			if self.completed_quests[text] then
				button:Click()
			elseif not self.uncompleted_quests[text] then
				button:Click()
			end
		end
	end
	self:FixQuestDetailFading()
end

function kAutoQuest:QUEST_LOG_UPDATE()
	self:Debug('QUEST_LOG_UPDATE', 3)
	if not self:CanAutomate() then return end
  if not self:ShouldAutomate() then return end
	local start_entry = GetQuestLogSelection()
	local num_entries = GetNumQuestLogEntries()
	local title, is_complete, no_objectives
	self.completed_quests = {}
	self.uncompleted_quests = {}
	if num_entries > 0 then
		for i = 1, num_entries do
			SelectQuestLogEntry(i)
			title, _, _, _, _, _, is_complete = GetQuestLogTitle(i)
			no_objectives = GetNumQuestLeaderBoards(i) == 0
			if title and (is_complete or no_objectives) then
				self.completed_quests[title] = true
			else
				self.uncompleted_quests[title] = true
			end
		end
	end
	SelectQuestLogEntry(start_entry)
	self:FixQuestDetailFading()
end

function kAutoQuest:QUEST_PROGRESS()
	self:Debug('QUEST_PROGRESS', 3)
	if not self:CanAutomate() then return end
  if not self:ShouldAutomate() then return end
	if IsQuestCompletable() then
		self:Debug('IsQuestCompletable() = true', 3)
		CompleteQuest()
		self:FixQuestDetailFading()
	end
end
-- **** EVENTS END ****

function kAutoQuest:CanAutomate() if IsShiftKeyDown() then return false else return true end end

function kAutoQuest:CancelTimerByItem(item)
	-- Cancel direct
	if self.TIMERS[item] then self:CancelTimer(self.TIMERS[item].timer, true) end
	-- Loop through and check item ids
	for i,v in pairs(self.TIMERS) do
		if v.id == item then
			self:CancelTimer(self.TIMERS[i].timer, true);
			self.TIMERS[i] = nil;
		end
	end
	-- While
	while self.TIMERS[item] do
		self:CancelTimer(self.TIMERS[item].timer, true);
		self.TIMERS[item] = nil;
	end
end

function kAutoQuest:DoesItemReplaceExpHeirloom(item)
	-- Get inventory slot
	local tContains = _G.tContains
	local slot = self:GetItemEquipSlot(item)
	local slots = type(slot) == 'table' and slot or {slot};
	for i,v in pairs(slots) do
		local isHeirloom = false
		local itemID = GetInventoryItemID('player', v)
		-- Check that current item isn't heirloom
		local rarity = itemID and select(3, GetItemInfo(itemID));
		local heirloom = itemID and PawnGetItemData(('item:%s'):format(itemID))
		if heirloom and rarity == 7 then
			local heirMaxLevel = PawnGetMaxLevelItemIsUsefulHeirloom(heirloom);
			if heirMaxLevel then
				-- Heirloom found
				if (tContains(HEIRLOOM_EXP_SLOTS, v) and UnitLevel('player') <= heirMaxLevel) then
					isHeirloom = true;
				end
			end
		end
		if not isHeirloom then return false end
	end
	return true;
end

function kAutoQuest:DoesItemReplaceHeirloom(item)
	if not self:GetOptionValue('rewardAutomation', 'retainHeirlooms') then return false end	
	-- Get inventory slot
	local slot = self:GetItemEquipSlot(item)
	local slots = type(slot) == 'table' and slot or {slot};
	for i,v in pairs(slots) do
		local isHeirloom = false
		local itemID = GetInventoryItemID('player', v)
		-- Check that current item isn't heirloom
		local rarity = itemID and select(3, GetItemInfo(itemID));
		local heirloom = itemID and PawnGetItemData(('item:%s'):format(itemID))
		if heirloom and rarity == 7 then
			local heirMaxLevel = PawnGetMaxLevelItemIsUsefulHeirloom(heirloom);
			if heirMaxLevel then
				-- Heirloom found
				if ((UnitLevel('player') + self.db.profile.rewardAutomation.heirloomIgnoreLevels) <= heirMaxLevel) then
					isHeirloom = true;
				end
			end
		end
		if not isHeirloom then return false end
	end
	return true;
end

function kAutoQuest:EquipItem(args)
	local item, slotID, suppressOutput;
	if type(args) == 'table' then item = args[1]; slotID = args[2]; suppressOutput = args[3] end
	if not item then return end
	if not GetItemInfo(item) then return end
	-- Check for combat lock
	if not InCombatLockdown() and not UnitIsDeadOrGhost('player') then
		-- If not locked, equip item and cancel timer
		if not suppressOutput then self:Output(('%s %s'):format('Auto-equipping upgrade item', select(2,GetItemInfo(item)))) end
		EquipItemByName(item, slotID)
		self:Threading_StopTimer(item)
	end
end

function kAutoQuest:FixQuestDetailFading() if QuestInfoDescriptionText then QuestInfoDescriptionText:SetAlphaGradient(0, QUEST_FADING_DEFAULT_VALUE) end end

function kAutoQuest:GetEmptyInventorySlot(slot)
	if type(slot) == 'table' then
		for i,v in pairs(slot) do
			if not (v == 16) and not (v == 17) then -- Exclude potential weapons
				if not GetInventoryItemID('player', v) then return v end
			end
		end
	elseif not GetInventoryItemID('player', slot) then
		if not (slot == 16) and not (slot == 17) then
			return slot
		end
	end
	return false;
end

function kAutoQuest:GetExistingItemSlot(reward)
	if reward.currentItemID then return self:GetSlotOfEquippedItem(reward.currentItemID) else return reward.slot end
end

function kAutoQuest:GetItemEquipSlot(item, returnType)
	local _
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then -- common case first
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	-- Check if item is in local cache
	local name, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(item);
	if not name then return end
	for i,loc in pairs(ITEM_EQUIP_LOCS) do
		if loc.name == itemEquipLoc then
			if returnType then
				return loc[returnType];
			else
				return loc.slotNumber;
			end
		end
	end
	return nil;
end

function kAutoQuest:GetItemIdFromItemLink(link)
	if link then
		local found, _, itemString = string.find(link, "^|c%x+|H(.+)|h%[.*%]")
		local _, itemId = strsplit(":", itemString)	
		if itemId then return itemId end
	end
	return nil
end

function kAutoQuest:GetItemRating(item)
	if not self:IsItemEquippable(item) then return 0 end
	local percentUpgrade = self:GetPawnPercentUpgrade(item);
	return percentUpgrade;
end

function kAutoQuest:GetItemVendorValue(item)
	local itemSellPrice = select(11, GetItemInfo(item))
	return itemSellPrice
end

function kAutoQuest:GetPawnCurrentItem(itemID)
	local results = PawnIsItemIDAnUpgrade(itemID);
	-- Check for selected scale
	if results and #results > 0 then
		for iResult,vResult in pairs(results) do
			if vResult.ScaleName == self.db.profile.rewardAutomation.pawnScaleSelected then
				return vResult.ExistingItemID
			end
		end
	end
end

function kAutoQuest:GetPawnPercentUpgrade(itemID)
	local results = PawnIsItemIDAnUpgrade(itemID);
	-- Check for selected scale
	if results and #results > 0 then
		for iResult,vResult in pairs(results) do
			if vResult.ScaleName == self.db.profile.rewardAutomation.pawnScaleSelected then
				return vResult.PercentUpgrade
			end
		end
	end
end

function kAutoQuest:GetScaleListValues()
	local scales;
	if kAutoQuest:IsPawnLoaded() then scales = PawnGetAllScalesEx() end
	local out = {};
	out['None'] = 'None';
	if scales then for i,v in pairs(scales) do if v.IsVisible then out[v.Name] = v.Name end end end
	-- 	{ Name, LocalizedName, Header, IsVisible }
	return out;	
end

function kAutoQuest:GetSlotOfEquippedItem(ID)
	if not ID then return end
	for i=0,19 do
		if ID == GetInventoryItemID('player', i) then return i end
	end
	return;
end

function kAutoQuest:HasMultipleTrinkets(data)
	if not self:GetOptionValue('rewardAutomation', 'defaultSelectTrinket') then return false end
	if self:KeyValueCount(data, 'isTrinket', true) >= 2 then return true else return false end
end

function kAutoQuest:HasSingleTrinket(data)
	if not self:GetOptionValue('rewardAutomation', 'defaultSelectTrinket') then return false end
	if self:KeyValueCount(data, 'isTrinket', true) == 1 then return true else return false end
end

function kAutoQuest:IsItemEquippable(item)
	local _,link = GetItemInfo(item)
	if not link then return false end
	if not IsEquippableItem(item) then return false end
	local tip = kAutoQuestTooltip or CreateFrame('GameTooltip', 'kAutoQuestTooltip', WorldFrame, 'GameTooltipTemplate')
	if not tip then return false end
	tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
	self:ResetTooltip(tip)
	tip:SetHyperlink(link)
	local tipName = tip:GetName();
	for i=1,tip:NumLines() do
		local lineLeft = _G[('%s%s%s'):format(tipName,'TextLeft',i)]
		local lineRight = _G[('%s%s%s'):format(tipName,'TextRight',i)]
		if lineLeft and lineLeft:GetText() then
			local r,g,b,a = lineLeft:GetTextColor();
			local color = {r=self:Round(r,4),g=self:Round(g,4),b=self:Round(b,4),a=self:Round(a,4)}
			if self:DoTablesMatch(color, TOOLTIP_COLOR_RED) then self:Debug({'Red color', {r,g,b,a}, GetItemInfo(item), lineLeft:GetText(), lineLeft}, 3) return false end
		end
		if lineRight and lineRight:GetText() then
			local r,g,b,a = lineRight:GetTextColor();
			local color = {r=self:Round(r,4),g=self:Round(g,4),b=self:Round(b,4),a=self:Round(a,4)}			
			if self:DoTablesMatch(color, TOOLTIP_COLOR_RED) then self:Debug({'Red color', {r,g,b,a}, GetItemInfo(item), lineRight:GetText(), lineRight}, 3) return false end
		end
	end
	return true
end

function kAutoQuest:IsItemTrinket(item)
	local slot = self:GetItemEquipSlot(item)
	local slots = type(slot) == 'table' and slot or {slot};
	for i,v in pairs(slots) do
		if v == 13 or v == 14 then return true end
	end
	return false
end

function kAutoQuest:IsPawnLoaded() return IsAddOnLoaded('Pawn') end

function kAutoQuest:IsPerfectWeaponUpgrade(reward)
	local slot = self:GetExistingItemSlot(reward);
	if type(slot) == 'table' then slot = slot[1] end
	if (slot == 16 or slot == 17) and reward.rating == 100 then return true end
	return false
end

function kAutoQuest:IsValidCharacterLevel()
	if not self:GetOptionValue('rewardAutomation', 'enabled') then return false end
	local playerLevel = UnitLevel("player")
	if self:GetOptionValue('rewardAutomation', 'minLevel') > playerLevel then return false end
	if self:GetOptionValue('rewardAutomation', 'maxLevel') < playerLevel then return false end	
	return true
end

function kAutoQuest:OpenOptions(input) 
	if not input or input == "" then
		InterfaceOptionsFrame_OpenToCategory(self.opt1)
	elseif strlower(input) == "t" or strlower(input) == "tracker" then
		self.db.profile.trackerVisible = not self.db.profile.trackerVisible
		self:SetTrackerVisibility()
	end
end

function kAutoQuest:ProcessAutoEquip(reward, category)
	if category and category == 'value' then return end
	if self:GetOptionValue('rewardAutomation', 'equipUpgrades') then
		if reward.equippable and (not reward.replacesHeirloom) and (not reward.replacesExpHeirloom) then
			local slot = self:GetExistingItemSlot(reward);
			if type(reward.slot) == 'table' then slot = slot[1] end
			if self:IsPerfectWeaponUpgrade(reward) then -- Perfect upgrade and weapon/offhand slot, don't auto-equip
				self:Debug(('%s weapon/offhand upgrade detected, unable to auto-equip %s.'):format('100%',reward.link), 3)		
				self:Output(('%s weapon/offhand upgrade detected, unable to auto-equip %s. Please manually review item as possible upgrade.'):format('100%',reward.link))	
				return				
			end
			if category == 'emptyslot' then slot = self:GetEmptyInventorySlot(reward.slot) end			
			self:Threading_CreateTimer(reward.ID, 'equipitem', 5, true, {reward.ID, slot})
		end
	end		
end

function kAutoQuest:ProcessQuestCompletion()
	if not self:CanAutomate() then return end
	local iQuestChoices, rewards = GetNumQuestChoices();
	if ((not iQuestChoices or iQuestChoices == 0) or (iQuestChoices == 1 and ((not self:IsPawnLoaded()) or (not self:GetOptionValue('rewardAutomation', 'enabled'))))) and self.db.profile.quest.enabled then
		GetQuestReward(1) 
		return 
	end
	if not self:GetOptionValue('rewardAutomation', 'enabled') then return end -- Check if enabled
	if not self:IsValidCharacterLevel() then return end -- Check character level
	if not self:IsPawnLoaded() then return end -- Check if Pawn is loaded
	for iQuestChoice=1,iQuestChoices do
		local itemLink = GetQuestItemLink('choice', iQuestChoice);
		local itemID = self:GetItemIdFromItemLink(itemLink);
		if itemID then 
			rewards = rewards or {};
			tinsert(rewards, {
				currentItemID = self:GetPawnCurrentItem(itemID),
				equippable = self:IsItemEquippable(itemID),
				ID = itemID,
				index = iQuestChoice,
				isTrinket = self:IsItemTrinket(itemID),
				link = itemLink,
				rating = self:GetItemRating(itemID),
				replacesHeirloom = self:DoesItemReplaceHeirloom(itemID),
				replacesExpHeirloom = self:DoesItemReplaceExpHeirloom(itemID),
				slot = self:GetItemEquipSlot(itemID),	
				value =  self:GetItemVendorValue(itemID),
			})
		end
	end
	if rewards then
		-- Special scenarios
		-- Whitelist
		for i,v in pairs(rewards) do
			if self:DoesWhitelistItemExist(v.ID) or self:DoesWhitelistItemExist(GetItemInfo(v.ID)) then
				self:SelectQuestReward(v, 'whitelist')
				return
			end			
		end
		-- Multi-trinkets
		if self:HasMultipleTrinkets(rewards) then
			self:Debug('Multiple trinkets -- Manual selection required!', 2)
			self:Output('Multiple trinkets -- Manual selection required!')
			return;
		end
		-- Single-trinket
		if self:HasSingleTrinket(rewards) then
			self:Debug('Trinket selection.', 2)	
			for i,v in pairs(rewards) do if v.isTrinket then self:SelectQuestReward(v, 'singletrinket') end end
			return;
		end
		-- Fills empty slot
		for i,v in pairs(rewards) do
			if v.equippable and (not v.replacesHeirloom) and (not v.replacesExpHeirloom) then
				self:Debug(v.slot, self:GetEmptyInventorySlot(v.slot), 3)
				if self:GetEmptyInventorySlot(v.slot) then 
					self:SelectQuestReward(v, 'emptyslot');
					return;
				end
			end
		end
		self:Debug(rewards, 3)		
		rewards = self:SortTableByKey(rewards, 'rating'); -- Sort by rating
		-- Check for highest rated equippable
		for i,v in pairs(rewards) do
			if v.rating and v.rating >= self:GetOptionValue('rewardAutomation', 'percentUpgradeThreshold') and v.equippable and (not v.replacesHeirloom) and (not v.replacesExpHeirloom) then
				-- Select item
				self:SelectQuestReward(v, 'normal');
				return;
			end
		end
		rewards = self:SortTableByKey(rewards, 'value'); -- Sort by value
		-- Check for highest vendor value
		for i,v in pairs(rewards) do
			if v.value then
				self:SelectQuestReward(v, 'value');
				-- Check if auto-sell list
				if self:GetOptionValue('merchant', 'autoSellHighValue') then
					self.db.profile.itemsToBeSold[v.ID] = true
				end
				return;
			end
		end
	end
end

function kAutoQuest:SelectQuestReward(reward, category)
	if (not type(reward) == 'table') or (not reward.index) then return end
	category = category or 'normal';
	local choiceString = '';
	if category == 'normal' then
		local percent = reward.rating == 100 and reward.rating or self:Round(reward.rating*100, 1)
		choiceString = ('Best equippable item with upgrade rating of %s.'):format(self:ColorizeText(percent, 0, 210, 0)..'%')
	elseif category == 'whitelist' then
		choiceString = ('%s item.'):format(self:ColorizeText('Whitelisted', 255, 255, 255))
	elseif category == 'singletrinket' then
		choiceString = ('Trinket selected due to %s option.'):format(self:ColorizeText('[Always Select Trinket]', 0, 100, 150))
	elseif category == 'value' then
		if reward.value and reward.value > 0 then
			choiceString = ('Highest vendor value item worth %s.'):format(GetCoinTextureString(reward.value))
		end
	elseif category == 'emptyslot' then
		choiceString = 'Upgrades empty equipment slot.'
	end
	self:Debug('Select reward' .. reward.link, 2)
	if not self:GetOptionValue('debug', 'enabled') then GetQuestReward(reward.index) end
	self:Output(('%s %s %s'):format(self:ColorizeText('Auto-Selection:', 240, 120, 0), reward.link, choiceString))
	self:ProcessAutoEquip(reward, category)
end

function kAutoQuest:SetTrackerVisibility()
	if not _G['WatchFrame'] then return end
	if self.db.profile.trackerVisible and not _G['WatchFrame']:IsVisible() then
		_G['WatchFrame']:Show()
	elseif not self.db.profile.trackerVisible and _G['WatchFrame']:IsVisible() then
		_G['WatchFrame']:Hide()
	end
end

function kAutoQuest:ShouldAutomate()
  val = self:GetOptionValue('quest', 'enabled')
  self:Debug(('ShouldAutomate() = %s'):format(val and 'true' or 'false'))
  return self:GetOptionValue('quest', 'enabled')
end

-- **** AUTOSELL ****
function kAutoQuest:AddAutoSellItem(item)
	if not self:ValidateAutoSellItem(item) then return end
	if self:DoesAutoSellItemExist(item) then 
		self:Debug(('Auto-Sell item %s already exists.'):format(item), 3)
		self:Output(('Auto-Sell item %s already exists.'):format(item))
		return
	end
	local name, link = GetItemInfo(item)
	if name then
		local id = self:GetItemIdFromItemLink(link)
		self:Debug(('Adding Auto-Sell item name %s id %s'):format(name, id), 3)
		self:Output(('Adding Auto-Sell item name %s id %s'):format(name, id))
		tinsert(self.db.profile.autoSell, {id = tonumber(id), name = name})
	elseif tonumber(item) ~= nil then
		self:Debug(('Adding Auto-Sell item id %s'):format(item), 3)
		self:Output(('Adding Auto-Sell item id %s'):format(item))
		tinsert(self.db.profile.autoSell, {id = tonumber(tonumber(item))})
	elseif type(item) == 'string' and item ~= "" then
		self:Debug(('Adding Auto-Sell item name %s'):format(item), 3)
		self:Output(('Adding Auto-Sell item name %s'):format(item))
		tinsert(self.db.profile.autoSell, {name = item})
	end
end

function kAutoQuest:DeleteAutoSellItem(index)
	if self.db.profile.autoSell[index] then tremove(self.db.profile.autoSell, index) end
end

function kAutoQuest:DoesAutoSellItemExist(item)
	local name, id = type(item) == 'string' and item, item and tonumber(item);
	for i,v in pairs(self.db.profile.autoSell) do
		if id and tonumber(v.id) == id then return i end
		if name and v.name == name then return i end
	end
end

function kAutoQuest:GetSelectedAutoSellItemLabel()
	local index = self.autoSellSelection or 1;
	if tonumber(#self.db.profile.autoSell) ~= 0 then
		local id, name = self.db.profile.autoSell[index].id, self.db.profile.autoSell[index].name
		if id and name then
			return ('%s [%s]'):format(name, id)
		elseif id then
			return ('%s'):format(id)
		elseif name then
			return ('%s'):format(name)
		end
	end
end

function kAutoQuest:GetAutoSellValues()
	local scales;
	local out = {};
	for i,v in pairs(self.db.profile.autoSell) do
		out[i] = v.id and v.name and ('%s [%s]'):format(v.name, v.id) or v.id and v.id or v.name and v.name
	end
	return out;	
end

function kAutoQuest:ValidateAutoSellItem(item)
	if not item then return false end
	if 	GetItemInfo(item) or 
		tonumber(item) ~= nil or 
		(type(item) == 'string' and item ~= "") then return true end
end
-- **** AUTOSELL END ****


-- **** WHITELIST ****
function kAutoQuest:AddWhitelistItem(item)
	if not self:ValidateWhitelistItem(item) then return end
	if self:DoesWhitelistItemExist(item) then 
		self:Debug(('Whitelist item %s already exists.'):format(item), 3)
		self:Output(('Whitelist item %s already exists.'):format(item))
		return
	end
	local name, link = GetItemInfo(item)
	if name then
		local id = self:GetItemIdFromItemLink(link)
		self:Debug(('Adding whitelist item name %s id %s'):format(name, id), 3)
		tinsert(self.db.profile.whitelist, {id = tonumber(id), name = name})
	elseif tonumber(item) ~= nil then
		self:Debug(('Adding whitelist item id %s'):format(item), 3)
		tinsert(self.db.profile.whitelist, {id = tonumber(tonumber(item))})
	elseif type(item) == 'string' and item ~= "" then
		self:Debug(('Adding whitelist item name %s'):format(item), 3)
		tinsert(self.db.profile.whitelist, {name = item})
	end
end

function kAutoQuest:DeleteWhitelistItem(index)
	if self.db.profile.whitelist[index] then tremove(self.db.profile.whitelist, index) end
end

function kAutoQuest:DoesWhitelistItemExist(item)
	local name, id = type(item) == 'string' and item, item and tonumber(item);
	for i,v in pairs(self.db.profile.whitelist) do
		if id and tonumber(v.id) == id then return i end
		if name and v.name == name then return i end
	end
end

function kAutoQuest:GetSelectedWhitelistItemLabel()
	local index = self.whitelistSelection or 1;
	if tonumber(#self.db.profile.whitelist) ~= 0 then
		local id, name = self.db.profile.whitelist[index].id, self.db.profile.whitelist[index].name
		if id and name then
			return ('%s [%s]'):format(name, id)
		elseif id then
			return ('%s'):format(id)
		elseif name then
			return ('%s'):format(name)
		end
	end
end

function kAutoQuest:GetWhitelistValues()
	local scales;
	local out = {};
	for i,v in pairs(self.db.profile.whitelist) do
		out[i] = v.id and v.name and ('%s [%s]'):format(v.name, v.id) or v.id and v.id or v.name and v.name
	end
	return out;	
end

function kAutoQuest:ValidateWhitelistItem(item)
	if not item then return false end
	if 	GetItemInfo(item) or 
		tonumber(item) ~= nil or 
		(type(item) == 'string' and item ~= "") then return true end
end
-- **** WHITELIST END ****

-- **** THREADING ****
function kAutoQuest:Threading_CreateTimer(ID, type, duration, loop,  args)
	self.TIMERS[ID] = { type=type, duration=duration, loop=loop, args=args, start=GetTime(), }
end

function kAutoQuest:Threading_OnUpdate(elapsed)
	self.threadingLastUpdate = self.threadingLastUpdate and self.threadingLastUpdate + elapsed or elapsed;
	if self.threadingLastUpdate < self.THREADING_UPDATE_TICK then return end
	local currentTime = GetTime();
	for ID,timer in pairs(self.TIMERS) do
		if not timer.expired then 
			if currentTime >= timer.start + timer.duration then timer.expired = true end -- Expired
			if timer.expired then
				self:Threading_ExecuteTimer(timer)
				if timer.loop then
					timer.count = timer.count and timer.count + 1 or 1;
					if timer.count <= self.THREADING_REPEAT_LIMIT then -- Check loop limit
						timer.expired = false
						timer.start = currentTime;
					end
				end
			end		
		end
		if timer.expired then self:Threading_StopTimer(ID) end
	end	
end

function kAutoQuest:Threading_ExecuteTimer(timer)
	if timer.type == 'equipitem' then
		self:EquipItem(timer.args)
	end
end

function kAutoQuest:Threading_ResetTimer(ID,duration)
	if self.TIMERS[ID] then
		self.TIMERS[ID].duration = duration or self.TIMERS[ID].duration;
		self.TIMERS[ID].start = GetTime();
		self.TIMERS[ID].expired = false;
		self.TIMERS[ID].count = 0;
	end
end

function kAutoQuest:Threading_StopTimer(ID)
	if self.TIMERS[ID] then self.TIMERS[ID] = nil end
end
-- **** THREADING END ****

-- **** UTILITY ****
function kAutoQuest:ColorizeText(text, r, g, b)
	return ('%s%s%s'):format(self:RGBToHex(r,g,b), text, '|r');
end

function kAutoQuest:Debug(value, threshold, label)
	local isDevLoaded = IsAddOnLoaded('_Dev');
	local prefix = label and 'kAutoQuest ' .. label .. ': ' or 'kAutoQuest: ';
	local dump = _G.dump
	-- CHECK IF _DEV exists
	if self.db.profile.debug.enabled then
		if not threshold or threshold <= self.db.profile.debug.threshold then
			if isDevLoaded then
				dump(prefix, value);
			else
				if type(value) == 'table' then print(prefix,value) else
					self:Print(ChatFrame1, ('%s%s'):format(prefix,value))			
				end
			end
		end
	end
end

function kAutoQuest:DoTablesMatch(table1,table2)
	for i1,v1 in pairs(table1) do
		if not (table1[i1] == table2[i1]) then return false end
	end
	for i2,v2 in pairs(table2) do
		if not (table2[i2] == table1[i2]) then return false end
	end
	return true
end

function kAutoQuest:GetOptionValue(primary, secondary)
	if primary and secondary then
		return self.db.profile[primary][secondary];
	elseif primary then
		return self.db.profile[primary];
	end
end

function kAutoQuest:KeyValueCount(data, key, value)
	if not data then return end
	local count = 0;
	for i,v in pairs(data) do if data[key] == value then count = count + 1 end end
	return count;
end

function kAutoQuest:Output(msg)
	if not self.db.profile.rewardAutomation.suppressOutput then
		print(('%s %s'):format(self:ColorizeText('kAutoQuest',0,200,0), self:ColorizeText(msg,255,255,255)));
	end
end

function kAutoQuest:ResetTooltip(tip)
	tip:ClearLines()
	local tipName = _G.tipName
	for i=1,tip:NumLines() do
		local lineLeft = _G[('%s%s%s'):format(tipName,'TextLeft',i)]
		local lineRight = _G[('%s%s%s'):format(tipName,'TextRight',i)]
		if lineRight then
			lineRight:Hide()
			lineRight:SetText(nil)
			lineRight:SetTextColor(1,1,1)
		end
		if lineLeft then
			lineRight:SetTextColor(1,1,1)
		end
	end
end

function kAutoQuest:RGBToHex(r, g, b, suppressPrefix)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	if suppressPrefix then
		return string.format("%02x%02x%02x", r, g, b)
	else
		return string.format("|cff%02x%02x%02x", r, g, b)	
	end
end

function kAutoQuest:Round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num * mult + 0.5) / mult
end

function kAutoQuest:SortTableByKey(data, key)
	if (not data) or (not type(data) == 'table') then return end
	self:Debug('Sorting table', 3)
	table.sort(data, function(a,b) 
		if (a[key] and b[key] and a[key] > b[key]) or (a[key] and not b[key]) then
			return true
		elseif (a[key] and b[key] and a[key] < b[key]) or (b[key] and not a[key]) then
			return false
		end
		return false
	end);
	return data;
end

function kAutoQuest:StripText(text)
	if not text then return end
	text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r','%1')
	text = text:gsub('%[.*%]%s*','')
	text = text:gsub('(.+) %(.+%)', '%1')
	text = text:trim()
	return text
end
-- **** UTILITY END ****

kAutoQuest.options = {
    name = "kAutoQuest",
    handler = kAutoQuest,
    type = 'group',
    args = {
		debug = {
			name = 'Debug',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kAutoQuest.db.profile.debug.enabled = value end,
					get = function(info) return kAutoQuest.db.profile.debug.enabled end,
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
					set = function(info,value) kAutoQuest.db.profile.debug.threshold = value end,
					get = function(info) return kAutoQuest.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
	},
};

kAutoQuest.merchant = {
	name = 'Merchant Settings',
	type = 'group',
	args = {
		autoselljunk = {
			name = 'Sell Junk',
			type = 'toggle',
			desc = 'Toggle auto-selling of junk items when visiting a merchant.',
			set = function(info,value) kAutoQuest.db.profile.merchant.autoSellJunk = value end,
			get = function(info) return kAutoQuest.db.profile.merchant.autoSellJunk end,
			width = 'full',
			order = 3,
		},
		autosellvendorrewards = {
			name = 'Sell High Vendor Value Rewards',
			type = 'toggle',
			desc = 'Toggle auto-selling of items auto-selected by kAutoQuest for high vendor value (and therefore not upgrades to the current spec).',
			set = function(info,value) kAutoQuest.db.profile.merchant.autoSellHighValue = value end,
			get = function(info) return kAutoQuest.db.profile.merchant.autoSellHighValue end,
			disabled = function() if not kAutoQuest.db.profile.rewardAutomation.enabled then return true else return false end end,	
			width = 'full',			
			order = 6,
		},
	},
};

kAutoQuest.quest = {
	name = 'Quest Automation',
	type = 'group',
	args = {
		enabled = {
			name = 'Enable Quest Automation',
			type = 'toggle',
			desc = 'Toggle quest reward automation (selecting/accepting/turning in quests).',
			set = function(info,value) kAutoQuest.db.profile.quest.enabled = value end,
			get = function(info) 
				return kAutoQuest.db.profile.quest.enabled
			end,
			order = 1,
		},
	},
};

kAutoQuest.questRewardAutomation = {
	name = 'Quest Reward Automation',
	type = 'group',
	args = {
		errorheader = {
			name = 'WARNING: The Pawn addon is required to utilize Reward Automation.  Please install and/or enable Pawn.',
			type = 'description',
			hidden = function() return kAutoQuest:IsPawnLoaded() end,
			width = 'full',
			fontSize = 'large',
			order = 1,
		},
		enabled = {
			name = 'Enable Auto-Selection',
			type = 'toggle',
			desc = 'Toggle quest reward automated selection process.',
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.enabled = value end,
			get = function(info) 
				if not kAutoQuest:IsPawnLoaded() then
					return false
				end
				return kAutoQuest.db.profile.rewardAutomation.enabled
			end,
			disabled = function()
				return not kAutoQuest:IsPawnLoaded()
			end,
			order = 2,
		},
		suppressoutput = {
			name = 'Suppress Output',
			type = 'toggle',
			desc = 'Toggle message indication of common events from kAutoQuest.',
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.suppressOutput = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.suppressOutput end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then return true else return false end 
			end,			
			order = 4,			
		},			
		selectdropdown = {
			name = 'Select Active Scale',
			type = 'select',
			desc = 'Pawn Scale to use when determining whether quest reward items are upgrades',
			values = function() return kAutoQuest:GetScaleListValues() end,
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.pawnScaleSelected = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.pawnScaleSelected end,
			width = 'double',
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then return true else return false end
			end,			
			order = 5,
		},
		percentupgradethreshold = {
			name = 'Upgrade Percentage Threshold',
			type = 'range',
			desc = 'Percentage upgrade as determined by Pawn an item must meet or exceed in order to be auto-selected.',
			min = 0.01,
			max = 3,
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.percentUpgradeThreshold = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.percentUpgradeThreshold end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then return true	else return false end
			end,
			isPercent = true,
			order = 6,
		},		
		defaulttrinketselect = {
			name = 'Always Select Trinket',
			type = 'toggle',
			desc = ('%s\n\n%s'):format('Given the difficulty of determining upgrade values of trinkets, enabling this option always forces kAutoQuest to select a trinket if available as a reward.', kAutoQuest:ColorizeText('If more than one trinket is available, kAutoQuest will request a user decision instead.', 145, 145, 0)),
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.defaultSelectTrinket = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.defaultSelectTrinket end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then	return true	else return false end
			end,			
			order = 7,
		},		
		autoequipsettings = {
			name = 'Auto-Equip Settings',
			type = 'header',
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then	return true else return false end
			end,
			order = 8,
		},		
		autoequipupgrades = {
			name = 'Enable Auto-Equip',
			type = 'toggle',
			desc = 'Automatically equip upgrades received from quest rewards if the item beats your current item in the matching slot for the selected Pawn Scale.',
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.equipUpgrades = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.equipUpgrades end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then	return true	else return false end
			end,			
			order = 9,
		},	
		retainheirlooms = {
			name = 'Retain Heirlooms',
			type = 'toggle',
			desc = ('%s\n\n%s'):format('Determines if Heirloom items will remain equipped even if a better upgrade is found.', kAutoQuest:ColorizeText('Heirlooms that grant exp bonus will never be replaced until the character has surpassed their max growth level, regardless of this option.', 145, 145, 0)),
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.retainHeirlooms = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.retainHeirlooms end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() or not kAutoQuest.db.profile.rewardAutomation.equipUpgrades then	return true	else return false end
			end,			
			order = 10,			
		},	
		heirloomignorelevels = {
			name = 'Heirloom Ignore Threshold',
			type = 'range',
			desc = ('%s\n\n%s'):format('Determines how many levels your character must be within the maximum heirloom growth level to ignore the Retain Heirlooms setting and instead select a viable upgrade for that heirloom-equipped slot.  (e.g. If value of "2" and item has a max heirloom growth level of 80, if character is 79+, possible upgrades will be selected from rewards).', kAutoQuest:ColorizeText('Heirlooms that grant exp bonus will never be replaced until the character has surpassed their max growth level, regardless of this option.', 145, 145, 0)),
			min = 0,
			max = 90,		
			step = 1,
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.heirloomIgnoreLevels = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.heirloomIgnoreLevels end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest.db.profile.rewardAutomation.retainHeirlooms or not kAutoQuest:IsPawnLoaded() or not kAutoQuest.db.profile.rewardAutomation.equipUpgrades then return true else return false end
			end,			
			order = 11,			
		},				
		levelsettings = {
			name = 'Character Level Settings',
			type = 'header',
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then	return true	else return false end
			end,
			order = 13,
		},
		minimumlevel = {
			name = 'Minimum Level',
			type = 'range',
			desc = 'Minimum character level at which to automate quest reward selection.',
			min = 1,
			max = 90,
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.minLevel = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.minLevel end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then	return true	else return false end
			end,
			order = 14,
		},
		maximumlevel = {
			name = 'Maximum Level',
			type = 'range',
			desc = 'Maximum character level at which to automate quest reward selection.',
			min = 1,
			max = 90,
			set = function(info,value) kAutoQuest.db.profile.rewardAutomation.maxLevel = value end,
			get = function(info) return kAutoQuest.db.profile.rewardAutomation.maxLevel end,
			disabled = function()
				if not kAutoQuest.db.profile.rewardAutomation.enabled or not kAutoQuest:IsPawnLoaded() then	return true	else return false end
			end,
			order = 15,
		},				
	},
};

kAutoQuest.whitelist = {
	name = 'Whitelist Items',
	type = 'group',
	args = {
		add = {
			name = 'Add Whitelist Item',
			type = 'input',
			desc = 'Add a new item to the whitelist, which will be automatically selected when available as a quest reward.',
			set = function(info,value)
				kAutoQuest:AddWhitelistItem(value)
			end,	
			validate = function(info,value) return kAutoQuest:ValidateWhitelistItem(value) end,
			usage = '<ItemName or ItemID>',
			width = 'full',
			order = 5,
		},		
		items = {
			name = 'Whitelist Items',
			type = 'select',
			desc = 'Current whitelisted items.',
			values = function() return kAutoQuest:GetWhitelistValues() end,
			set = function(info,value) kAutoQuest.whitelistSelection = value end,
			get = function(info)
				if tonumber(#kAutoQuest.db.profile.whitelist) ~= 0 and #kAutoQuest.db.profile.whitelist < (kAutoQuest.whitelistSelection or 1) then kAutoQuest.whitelistSelection = #kAutoQuest.db.profile.whitelist end
				if not #kAutoQuest.db.profile.whitelist then kAutoQuest.whitelistSelection = 1 end
				return kAutoQuest.whitelistSelection or 1
			end,
			width = 'double',			
			order = 10,
		},
		delete = {
			name = 'Delete',
			type = 'execute',
			desc = function(info,value) 
				if #kAutoQuest.db.profile.whitelist > 0 then
					return ('Delete %s from the whitelist?'):format(kAutoQuest:GetSelectedWhitelistItemLabel())
				else
					return 'Delete selected item from the whitelist.'
				end
			end,
			disabled = function()
				return not kAutoQuest:GetSelectedWhitelistItemLabel()
			end,
			func = function()
				kAutoQuest:DeleteWhitelistItem(kAutoQuest.whitelistSelection or 1)
			end,
			order = 15,
		},
	},
};

kAutoQuest.autoSell = {
	name = 'Auto-Sell Items',
	type = 'group',
	args = {
		desc = {
			name = 'These items will be automatically sold when found in your bags while visiting a vendor.  Be careful of the items you specify here, and if possible, always utilize Item IDs rather than Item Names when adding a new entry.',
			type = 'description',
			width = 'full',
			order = 1,
		},
		maxSellQuality = {
			name = 'Maximum Sell Quality',
			desc = 'Determine what quality items must be below or equal to for Auto-Selling.  Any item with a quality higher than this setting will not be sold regardless of an entry in the Auto-Sell list.',
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
				kAutoQuest.db.profile.autoSellMaxQuality = value;
			end,
			get = function(info) return kAutoQuest.db.profile.autoSellMaxQuality end,
			width = 'full',
			order = 3,
		},
		add = {
			name = 'Add Auto-Sell Item',
			type = 'input',
			desc = 'Add a new item to the Auto-Sell list, which will be automatically sold to a vendor when found in your bags.',
			set = function(info,value)
				kAutoQuest:AddAutoSellItem(value)
			end,	
			validate = function(info,value) return kAutoQuest:ValidateAutoSellItem(value) end,
			usage = '<ItemName or ItemID>',
			width = 'full',
			order = 5,
		},		
		items = {
			name = 'Auto-Sell Items',
			type = 'select',
			desc = 'Current Auto-Sell items.',
			values = function() return kAutoQuest:GetAutoSellValues() end,
			set = function(info,value) kAutoQuest.autoSellSelection = value end,
			get = function(info)
				if tonumber(#kAutoQuest.db.profile.autoSell) ~= 0 and #kAutoQuest.db.profile.autoSell < (kAutoQuest.autoSellSelection or 1) then kAutoQuest.autoSellSelection = #kAutoQuest.db.profile.autoSell end
				if not #kAutoQuest.db.profile.autoSell then kAutoQuest.autoSellSelection = 1 end
				return kAutoQuest.autoSellSelection or 1
			end,
			width = 'double',			
			order = 10,
		},
		delete = {
			name = 'Delete',
			type = 'execute',
			desc = function(info,value) 
				if #kAutoQuest.db.profile.autoSell > 0 then
					return ('Delete %s from the Auto-Sell list?'):format(kAutoQuest:GetSelectedAutoSellItemLabel())
				else
					return 'Delete selected item from the Auto-Sell list.'
				end
			end,
			disabled = function()
				return not kAutoQuest:GetSelectedAutoSellItemLabel()
			end,
			func = function()
				kAutoQuest:DeleteAutoSellItem(kAutoQuest.autoSellSelection or 1)
			end,
			order = 15,
		},
	},
};

_G.kAutoQuest = kAutoQuest

