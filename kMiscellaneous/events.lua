local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

function kMiscellaneous:PLAYER_ENTERING_WORLD()
	RegisterAddonMessagePrefix("kMiscellaneous")
end

function kMiscellaneous:Event_OnGetItemInfoReceived()
	--print('Event_OnGetItemInfoReceived')
	--[[
	if #self.itemsAwaitingCache == 0 then return end
	for i=#self.itemsAwaitingCache, 1, -1 do
		--print(self.itemsAwaitingCache[i].item)
		-- Process
		self:Tally_ProcessCache(self.itemsAwaitingCache[i].item)
		if GetItemInfo(self.itemsAwaitingCache[i].item) then
			tremove(self.itemsAwaitingCache, i)
		end
	end
	]]
end

function kMiscellaneous:Event_OnLootOpened()
	self:Debug('Event_OnBagOpen', 2)
	if self.db.profile.tally.enabled then -- Tally
		local slots = GetNumLootItems()
		if not slots or not (slots >= 1) then return end
		for i=1, slots do
			local lootIcon, lootName, lootQuantity = GetLootSlotInfo(i)
			local coins = self:Utility_GetCoinsFromLootString(lootName, lootQuantity)
			if coins then
				self:Tally_AddItem('Copper', coins)
			else
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(lootName)
				if not itemLink then
					tinsert(self.itemsAwaitingCache, {item = lootName})
				end
				if itemRarity == 0 or (itemRarity == 2 and (itemType == 'Weapon' or itemType == 'Armor')) then -- Junk or green armor/weapon, add to copper total
					self:Tally_AddItem('Copper', itemSellPrice)
				else
					self:Tally_AddItem(lootName, lootQuantity, itemLink)
				end
			end
		end
	end
end

function kMiscellaneous:Event_OnRaidInstanceWelcome()
	self:Debug('Event_OnRaidInstanceWelcome', GetRealZoneText(), 1)
	-- Update Grid
	self:Grid_UpdateSettings()
end

function kMiscellaneous:Event_OnZoneChanged()
	self:Debug('Event_OnZoneChanged', GetRealZoneText(), 1)
	-- Update Grid
	self:Grid_UpdateSettings()
end