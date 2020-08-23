-- Author      : Gabe
-- Create Date : 10/12/2009 4:18:07 PM
kNecroticPlague.frame = {};

function kNecroticPlague:Gui_HideFrame()
	if kNecroticPlague.frame then
		kNecroticPlague.frame:Hide();
	end
end
function kNecroticPlague:Gui_ShowFrame()
	if kNecroticPlague.frame then
		kNecroticPlague.frame:Show();
	end
end
function kNecroticPlague:Gui_CreateFrame()
	local elapsed = 0
	local frame = CreateFrame("Frame", "kNecroticPlagueMain", UIParent, "GameTooltipTemplate")
	dropdownFrame = CreateFrame("Frame", "kNecroticPlagueMainDropdown", frame, "UIDropDownMenuTemplate")
	frame:SetFrameStrata("DIALOG")
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetHeight(64)
	frame:SetWidth(64)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetMovable()
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if IsAltKeyDown() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	frame:SetScript("OnUpdate", function(self, e)
		elapsed = elapsed + e
		if elapsed >= 0.5 then
			kNecroticPlague:Gui_OnUpdate(self, elapsed)
			elapsed = 0
		end
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			UIDropDownMenu_Initialize(dropdownFrame, Gui_InitializeDropdown, "MENU")
			ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 5, -10)
		end
	end)
	return frame
end
function kNecroticPlague:Gui_OnUpdate(self, elapsed)
	
	
	self:Show()
end
function Gui_InitializeDropdown(dropdownFrame, level, menu)
	local info
	if level == 1 then
		info = UIDropDownMenu_CreateInfo()
		info.text = "Close"
		info.notCheckable = true
		info.hasArrow = false
		info.func = function() kNecroticPlague:Gui_HideFrame() end
		UIDropDownMenu_AddButton(info, 1)
	end
end
function kNecroticPlague:Gui_RefreshFrame()
	-- Requirements:
	-- In combat, InCombatLockdown()
	-- Enabled, isEnabled
	-- Frame visible, kNecroticPlague.db.profile.frame.enabled
	if kNecroticPlague.isEnabled and kNecroticPlague.db.profile.frame.enabled and InCombatLockdown() then
		kNecroticPlague.frame.st:SetData(kNecroticPlague:GetScrollingTableFromLocalData());
		kNecroticPlague.frame.st:SortData();
	end
end
function kNecroticPlague:Gui_HookFrameRefreshUpdate()
	-- Hook to update frames
end