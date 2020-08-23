-- Create Mixins
local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kStorage = LibStub("AceAddon-3.0"):NewAddon("kStorage", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
_G.kStorage = kStorage
function kStorage:OnEnable() end
function kStorage:OnDisable() end
function kStorage:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kStorageDB", self.defaults)
    -- Inject Options Table and Slash Commands
	-- Create options	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kStorage", self.options, {"kstorage", "kstore"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.AceGUI = LibStub("AceGUI-3.0")
	-- Init Events
	self:InitializeEvents()
	self.updateFrame = CreateFrame("Frame", "kStorageUpdateFrame", UIParent);
	kStorageUpdateFrame:SetScript("OnUpdate", function(frame,elapsed) kStorage:OnUpdate(1, elapsed) end)
end

function kStorage:InitializeEvents()
	--kStorage:RegisterEvent("CHAT_MSG_WHISPER");
	kStorage:RegisterEvent("BANKFRAME_OPENED")
end

function kStorage:AddItemToDatabase(id, storageType, quantity)
	if not id then return end
	storageType = storageType or 'bank'
	quantity = quantity or 1
	if self:DoesItemExistInDatabase(id, storageType) then
		-- Update item stats
		self.db.profile.item[storageType][id].quantity = self.db.profile.item[storageType][id].quantity + quantity
	else
		-- Add new item
		self.db.profile.item[storageType][id] = {
			quantity = quantity,
		}
	end
end

function kStorage:DoesItemExistInDatabase(id, storageType)
	if not id then return end
	storageType = storageType or 'bank'
	if self.db.profile.item[storageType][id] then return true end
end

function kStorage:GetItemValue(id, storageType, dataType)
	if not id then return end
	storageType = storageType or 'bank'
	dataType = dataType or 'quantity'
	if not kStorage:DoesItemExistInDatabase(id, storageType) then return end
	return self.db.profile.item[storageType][id][dataType]
end

function kStorage:BANKFRAME_OPENED()
	kStorage:Debug('Bankframe opened', 2)
	local link, id, quantity
	self.db.profile.item.bank = {}
	for slot = 40, 67 do
		id = GetInventoryItemID('player', slot)
		quantity = GetInventoryItemCount('player', slot)
		self:AddItemToDatabase(id, 'bank', quantity)		
	end
	for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			id = GetContainerItemID(bag, slot)
			_, quantity = GetContainerItemInfo(bag, slot)
			self:AddItemToDatabase(id, 'bank', quantity)
		end
	end	
end

local lineAdded = false
local function OnTooltipSetItem(tooltip, ...)
	if (not lineAdded) and (kStorage.db.profile.tooltip.showItemLocation or kStorage.db.profile.tooltip.showItemQuantity) then
		local _, link = tooltip:GetItem()
		local id = tonumber(link:match('item:(%d+)'))
		local bankQuantity, voidQuantity = kStorage:GetItemValue(id, 'bank', 'quantity'), kStorage:GetItemValue(id, 'void', 'quantity')
		if kStorage.db.profile.tooltip.showItemLocation and kStorage.db.profile.tooltip.showItemQuantity then
			if bankQuantity and voidQuantity then
				tooltip:AddLine(('%s - (%d) in Bank, (%d) in Void'):format('kStorage', bankQuantity, voidQuantity))
			elseif bankQuantity then
				tooltip:AddLine(('%s - (%d) in Bank'):format('kStorage', bankQuantity))
			elseif voidQuantity then
				tooltip:AddLine(('%s - (%d) in Void'):format('kStorage', voidQuantity))
			end
		elseif kStorage.db.profile.tooltip.showItemLocation then
			if bankQuantity and voidQuantity then
				tooltip:AddLine(('%s - Bank and Void'):format('kStorage'))
			elseif bankQuantity then
				tooltip:AddLine(('%s - Bank'):format('kStorage'))
			elseif voidQuantity then
				tooltip:AddLine(('%s - Void'):format('kStorage'))
			end
		elseif kStorage.db.profile.tooltip.showItemQuantity then
			if bankQuantity or voidQuantity then
				tooltip:AddLine(('%s - (%d) found.'):format('kStorage', bankQuantity or 0 + voidQuantity or 0))			
			end
		end
		lineAdded = true
   end
end
 
local function OnTooltipCleared(tooltip, ...)
   lineAdded = false
end
 
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)