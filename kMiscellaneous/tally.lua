local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kMiscellaneous = _G.kMiscellaneous

--[[ Add item to tally
]]
function kMiscellaneous:Tally_AddItem(item, quantity, link)
	if not item then return end
	if not self.db.profile.tally.enabled then return end
	if not (type(quantity) == 'number') or not (type(tonumber(quantity)) == 'number') then return end

	-- Check for valid tally table
	if #self.db.profile.tally.lists == 0 then tinsert(self.db.profile.tally.lists, {}) end
	
	local foundIndex = self:Tally_FindItem(item)
	if foundIndex then -- Found
		self.db.profile.tally.lists[#self.db.profile.tally.lists][foundIndex] = {
			item = item,
			link = link,
			quantity = (self.db.profile.tally.lists[#self.db.profile.tally.lists][foundIndex].quantity or 0) + quantity,
		}
	else
		tinsert(self.db.profile.tally.lists[#self.db.profile.tally.lists], {
			item = item,
			link = link,
			quantity = quantity,
		})
	end
	-- Sort
	table.sort(self.db.profile.tally.lists[#self.db.profile.tally.lists], function(a, b)
		return a.item < b.item
	end)
end

--[[ Update Tally item record
]]
function kMiscellaneous:Tally_FindItem(item)
	if not item then return end
	for i,v in pairs(self.db.profile.tally.lists[#self.db.profile.tally.lists]) do
		if v.item == item then
			return i
		end
	end
end

--[[ Reset and delete all tally data
]]
function kMiscellaneous:Tally_New()
	self:Tally_Report()
	tinsert(kMiscellaneous.db.profile.tally.lists, {})
end

--[[ Process items from cache
]]
function kMiscellaneous:Tally_ProcessCache(item)
	if #self.db.profile.tally.lists == 0 or #self.db.profile.tally.lists[#self.db.profile.tally.lists] == 0 then return end
	local foundIndex = self:Tally_FindItem(item)
	if foundIndex then -- Found
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item)	
		local quantity = self.db.profile.tally.lists[#self.db.profile.tally.lists][foundIndex].quantity
		if itemRarity == 0 or (itemRarity == 2 and (itemType == 'Weapon' or itemType == 'Armor')) then -- Junk or green armor/weapon, add to copper total
			self:Tally_AddItem('Copper', itemSellPrice)
			tremove(self.db.profile.tally.lists[#self.db.profile.tally.lists], foundIndex) -- remove
		else
			self.db.profile.tally.lists[#self.db.profile.tally.lists][foundIndex].link = itemLink
		end
	end
end

--[[ Print out tally report
]]
function kMiscellaneous:Tally_Report()
	if #self.db.profile.tally.lists == 0 or #self.db.profile.tally.lists[#self.db.profile.tally.lists] == 0 then return end
	kMiscellaneous:Print('----- LOOT TALLY REPORT BEGIN -----' )
	for i,v in pairs(self.db.profile.tally.lists[#self.db.profile.tally.lists]) do
		print(('%d - %s'):format(v.quantity, v.link or v.item))
	end
	kMiscellaneous:Print('----- LOOT TALLY REPORT END -----' )
end