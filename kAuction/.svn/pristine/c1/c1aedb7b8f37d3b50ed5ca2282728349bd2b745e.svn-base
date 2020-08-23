local kAuction, _G, _ = kAuction, _G, _
local table, tinsert, tremove, wipe = table, table.insert, table.remove, wipe
local math, tostring, string, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local FauxScrollFrame_GetOffset, FauxScrollFrame_SetOffset, FauxScrollFrame_Update = FauxScrollFrame_GetOffset, FauxScrollFrame_SetOffset, FauxScrollFrame_Update
local sharedMedia = kAuction.sharedMedia
local frameNames = {"EncounterJournalEncounterFrameInfoLootScrollFrameButton"}
local lootButtonName = "EncounterJournalEncounterFrameInfoLootScrollFrameButton";
local lineAdded = false
local loadedEncounterJournal = false
local EncounterJournal
local EncounterJournalEncounterFrameInfoLootScrollFrame
-- EVENTS
function kAuction:Gui_EncounterJournal_HookScripts()
	EncounterJournalEncounterFrameInfoLootScrollFrame:HookScript("OnUpdate", function (self, ...)
		for i=1,9 do
			local button = _G[self:GetName()..'Button'..i]
			if button.itemID then
				local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(button.itemID);
				if wishlist then
					-- Item exists in wishlist, show icons
					button.bidType:Show()				
					button.bis:Show()
					button.setBonus:Show()
					button.wishlist:Show()
					button.wishlistText:SetText(wishlist.name);
					local bidType = kAuction:Wishlist_GetItemFlag(wishlist.id, button.itemID, "bidType");
					local bis = kAuction:Wishlist_GetItemFlag(wishlist.id, button.itemID, "bestInSlot");
					local setBonus = kAuction:Wishlist_GetItemFlag(wishlist.id, button.itemID, "setBonus");
					if bidType == "normal" then
						button.bidType:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\star2-full]])
					elseif bidType == "offspec" then
						button.bidType:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\star2-half]])
					elseif bidType == "rot" then
						button.bidType:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\star2-empty]])
					end
					if bis then -- Check visibility
						button.bis:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\medal2]])
						button.bis:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\medal2-grey]])
					else
						button.bis:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\medal2-grey]])
						button.bis:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\medal2]])
					end
					if setBonus then
						button.setBonus:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\shield-blue]])
						button.setBonus:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\shield-red]])
					else
						button.setBonus:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\shield-red]])
						button.setBonus:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\shield-blue]])
					end
				else -- Not wishlist, hide
					button.bidType:Hide()
					button.bis:Hide()
					button.setBonus:Hide()				
					button.wishlist:Hide()
				end  
			else -- Not item, hide
				button.bidType:Hide()				
				button.bis:Hide()
				button.setBonus:Hide()	
				button.wishlist:Hide()
			end			
		end
	end);			
end
function kAuction:Gui_EncounterJournal_RegisterFrames()
	local frame;
	EncounterJournalEncounterFrameInfoLootScrollFrame = _G.EncounterJournalEncounterFrameInfoLootScrollFrame
	for i=1,9 do
		frame = _G[lootButtonName..i];
		if frame then
			frame:RegisterForClicks("AnyDown")
			frame:SetScript("OnClick", function (self, button, down)
			--frame:HookScript("OnClick", function (self, button, down)
				kAuction:Debug("FUNC: Gui_EncounterJournal_RegisterFrames() HookScript", 3);
				if button == "LeftButton" then
					if (not HandleModifiedItemClick(self.link)) then
						if EncounterJournal then
							if (EncounterJournal.encounterID ~= self.encounterID) then
								EncounterJournal_DisplayEncounter(self.encounterID);
							end
						end
					end
				elseif self.itemID and button == "RightButton" then
					local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(self.itemID);
					if wishlist then
						if IsAltKeyDown() then -- delete
							kAuction:Wishlist_RemoveItem(wishlist.id, self.itemID);
						else
							local currentIndex = kAuction:Wishlist_GetIndexById(wishlist.id);
							local bidType = kAuction:Wishlist_GetItemFlag(wishlist.id, self.itemID, "bidType")
							local bestInSlot = kAuction:Wishlist_GetItemFlag(wishlist.id, self.itemID, "bestInSlot")
							local setBonus = kAuction:Wishlist_GetItemFlag(wishlist.id, self.itemID, "setBonus")
							-- Check for next index, if exists, change, if not, delete
							if #kAuction:Wishlist_GetLists() > currentIndex then -- Increment
								kAuction:Wishlist_AddItem(kAuction.db.profile.wishlists[currentIndex+1].id, GetItemInfo(self.itemID), self.itemID)
								-- Set previous flags
								kAuction:Wishlist_SetItemFlag(kAuction.db.profile.wishlists[currentIndex+1].id, self.itemID, "bidType", bidType)
								kAuction:Wishlist_SetItemFlag(kAuction.db.profile.wishlists[currentIndex+1].id, self.itemID, "bestInSlot", bestInSlot)
								kAuction:Wishlist_SetItemFlag(kAuction.db.profile.wishlists[currentIndex+1].id, self.itemID, "setBonus", setBonus)
								kAuction:Wishlist_RemoveItem(wishlist.id, self.itemID);
							else -- Delete
								kAuction:Wishlist_RemoveItem(wishlist.id, self.itemID);
							end
						end
					elseif not IsAltKeyDown() then -- Not on wishlist, add
						local lists = kAuction:Wishlist_GetLists();
						if lists and #lists > 0 then
							kAuction:Wishlist_AddItem(kAuction.db.profile.wishlists[1].id, GetItemInfo(self.itemID), self.itemID)							
						end
					end
				end
			end);
			-- Register icon clicks
			if frame.bis then
				frame.bis:SetScript("OnClick", function(self, button, down)
					local parent = self:GetParent();
					if parent.itemID and button == "LeftButton" and not IsModifierKeyDown() then
						-- Change value to opposite
						local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(parent.itemID);
						if wishlist then
							kAuction:Wishlist_SetItemFlag(wishlist.id, parent.itemID, "bestInSlot", not kAuction:Wishlist_GetItemFlag(wishlist.id, parent.itemID, "bestInSlot"))
							kAuction:Gui_EncounterJournal_BestInSlotOnEnter(self);
						end
					end
				end);
				frame.bis:SetScript("OnEnter", function(self)
					kAuction:Gui_EncounterJournal_BestInSlotOnEnter(self)
				end);
				frame.bis:SetScript("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
				end);				
			end
			if frame.setBonus then
				frame.setBonus:SetScript("OnClick", function(self, button, down)
					local parent = self:GetParent();
					if parent.itemID and button == "LeftButton" and not IsModifierKeyDown() then
						-- Change value to opposite
						local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(parent.itemID);
						if wishlist then
							kAuction:Wishlist_SetItemFlag(wishlist.id, parent.itemID, "setBonus", not kAuction:Wishlist_GetItemFlag(wishlist.id, parent.itemID, "setBonus"));
							kAuction:Gui_EncounterJournal_SetBonusOnEnter(self);
						end
					end
				end);
				frame.setBonus:SetScript("OnEnter", function(self)
					kAuction:Gui_EncounterJournal_SetBonusOnEnter(self);
				end);
				frame.setBonus:SetScript("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
				end);
			end
			if frame.bidType then
				frame.bidType:SetScript("OnClick", function(self, button, down)
					local parent = self:GetParent();
					if parent.itemID and button == "LeftButton" and not IsModifierKeyDown() then
						-- Change value to opposite
						local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(parent.itemID);
						if wishlist then
							local bidType = kAuction:Wishlist_GetItemFlag(wishlist.id, parent.itemID, "bidType");
							if bidType == "normal" then
								kAuction:Wishlist_SetItemFlag(wishlist.id, parent.itemID, "bidType", "offspec")
							elseif bidType == "offspec" then
								kAuction:Wishlist_SetItemFlag(wishlist.id, parent.itemID, "bidType", "rot")
							elseif bidType == "rot" then
								kAuction:Wishlist_SetItemFlag(wishlist.id, parent.itemID, "bidType", "normal")
							end
						end
					end
					kAuction:Gui_EncounterJournal_BidTypeOnEnter(self);
				end);
				frame.bidType:SetScript("OnEnter", function(self)
					kAuction:Gui_EncounterJournal_BidTypeOnEnter(self);
				end);
				frame.bidType:SetScript("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
				end);
			end
		end
	end
end
function kAuction:Gui_EncounterJournal_BestInSlotOnEnter(self)
	local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(self:GetParent().itemID);
	if wishlist then
		local currentValue, title = kAuction:Wishlist_GetItemFlag(wishlist.id, self:GetParent().itemID, "bestInSlot");
		if currentValue then
			title = "Best In Slot: Enabled"
		else
			title = "Best In Slot: Disabled"
		end
		local text = "Enable this flag to set this item as Best In Slot for the selected Bid Type.";
		local clickText = "Left-click to toggle";
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:ClearLines();
		GameTooltip:SetPoint("BOTTOMRIGHT", self:GetParent(), "TOPLEFT");
		GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['orange'], title));
		GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['white'], text), _, _, _, true);
		if clickText then
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['gold'], clickText));
		end
		GameTooltip:Show();
	end
end
function kAuction:Gui_EncounterJournal_SetBonusOnEnter(self)
	local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(self:GetParent().itemID);
	if wishlist then
		local currentValue, title = kAuction:Wishlist_GetItemFlag(wishlist.id, self:GetParent().itemID, "setBonus");
		if currentValue then
			title = "Set Bonus: Enabled";
		else
			title = "Set Bonus: Disabled";
		end
		local text = "Enable this flag if obtaining this item will complete a set bonus.";
		local clickText = "Left-click to toggle";
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:ClearLines();
		GameTooltip:SetPoint("BOTTOMRIGHT", self:GetParent(), "TOPLEFT");
		GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['orange'], title));
		GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['white'], text), _, _, _, true);
		if clickText then
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['gold'], clickText));
		end
		GameTooltip:Show();
	end
end
function kAuction:Gui_EncounterJournal_BidTypeOnEnter(self)
	local wishlist = kAuction:Wishlist_GetFirstWishlistWithItem(self:GetParent().itemID);
	if wishlist then
		local title, clickText;
		local bidType = kAuction:Wishlist_GetItemFlag(wishlist.id, self:GetParent().itemID, "bidType");
		if bidType == "normal" then
			title = "Bid Type: Normal";
			clickText = "Left-click to set to 'Offspec'";
		elseif bidType == "offspec" then
			title = "Bid Type: Offspec";
			clickText = "Left-click to set to 'Rot'";
		elseif bidType == "rot" then
			title = "Bid Type: Rot";
			clickText = "Left-click to set to 'Normal'";
		end
		local text = "Determine the type of bid kAuction will use to Auto-Bid for this item.";
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:ClearLines();
		GameTooltip:SetPoint("BOTTOMRIGHT", self:GetParent(), "TOPLEFT");
		GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['orange'], title));
		GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['white'], text), _, _, _, true);
		if clickText then
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine(("|cFF%s%s|r"):format(kAuction.colorHex['gold'], clickText));
		end
		GameTooltip:Show();						
	end
end
local function Gui_EncounterJournal_OnTooltipSetItem(tooltip, ...)
   if not tooltip then return false end
   local owner = tooltip:GetOwner()
   if not owner then return end
   if not lineAdded then
      for i,v in pairs(frameNames) do
         if string.find(tostring(owner:GetName()), v, 1) then
            tooltip:AddLine("")
            tooltip:AddLine("kAuction: Right-Click to Wishlist -- Alt+Right-Click to Remove")
            lineAdded = true            
         end
      end
   end
end
local function Gui_EncounterJournal_OnTooltipCleared(tooltip, ...)
   lineAdded = false
end
function kAuction:Gui_EncounterJournal_CreateFrameInserts()
	local button;
	local frame;
	for i=1,9 do
		button = _G[lootButtonName..i];
		-- Loot BiS
		if button and not button.bis then
			frame = CreateFrame("button", button:GetName().."BestInSlot", button, "kAuctionButtonTemplate");
			frame:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\medal2-grey]])
			frame:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\medal2]])
			frame:ClearAllPoints();
			frame:SetPoint("TOPRIGHT", 0, -3)
			--frame:Hide();
			button.bis = frame;				
		end
		-- Loot setBonus
		if button and not button.setBonus then
			frame = CreateFrame("button", button:GetName().."SetBonus", button, "kAuctionButtonTemplate");
			frame:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\shield-red]])
			frame:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\shield-blue]])
			frame:ClearAllPoints();
			frame:SetPoint("TOPRIGHT", -16, -3)
			--frame:Hide();
			button.setBonus = frame;				
		end
		-- Loot bidType
		if button and not button.bidType then
			frame = CreateFrame("button", button:GetName().."BidType", button, "kAuctionButtonTemplate");
			frame:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\star2-full]])
			frame:ClearAllPoints();
			frame:SetPoint("TOPRIGHT", -32, -3)
			--frame:Hide();
			button.bidType = frame;				
		end
		-- Loot wishlist
		if button and not button.wishlist then
			frame = CreateFrame("frame", button:GetName().."Wishlist", button, "kAuctionEncounterJournalWishlist");
			local text = _G[frame:GetName().."Text"];
			text:SetTextColor(1,1,1,0.6)
			text:SetText("Main Wishlist")
			frame:Show();
			--frame:Hide();
			button.wishlist = frame;	
			button.wishlistText = text;					
		end		
	end
end
function kAuction:Gui_EncounterJournal_Initialize()
	-- Check for EncounterJournal exists
	self:CreateTimer(function()
		if not loadedEncounterJournal then
			EncounterJournal = _G.EncounterJournal
			if EncounterJournal then
				kAuction:Debug("ENCOUNTER JOURNAL INITIALIZE", 1);
				loadedEncounterJournal = true
				GameTooltip:HookScript("OnTooltipSetItem", Gui_EncounterJournal_OnTooltipSetItem)
				GameTooltip:HookScript("OnTooltipCleared", Gui_EncounterJournal_OnTooltipCleared)
				kAuction:Gui_EncounterJournal_CreateFrameInserts()
				kAuction:Gui_EncounterJournal_RegisterFrames()
				kAuction:Gui_EncounterJournal_HookScripts()
			end
		end
	end,2,true)
end