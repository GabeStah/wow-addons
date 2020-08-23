-- Author      : Gabe
-- Create Date : 10/12/2009 4:18:07 PM
kTraitor.frame = {};
function kTraitor:Gui_HideFrame()
	if kTraitor.frame and kTraitor.frame.st and kTraitor.frame.st.frame then
		kTraitor.frame.st.frame:Hide();
	end
end
function kTraitor:Gui_ShowFrame()
	if kTraitor.frame and kTraitor.frame.st and kTraitor.frame.st.frame then
		kTraitor.frame.st.frame:Show();
	end
end
function kTraitor:Gui_InitializeFrames()
	-- Create initial frames
	local cols = {
		{
			["name"] = "Player",
			["width"] = 90,
			["align"] = "CENTER",
		},
		{
			["name"] = "Scarabs",
			["width"] = 70,
			["align"] = "CENTER",
			["defaultsort"] = "asc",
		},
		{
			["name"] = "Threat",
			["width"] = 70,
			["align"] = "CENTER",
		}
	};
	kTraitor.frame.st = kTraitor.st:CreateST(cols, 11, 15, nil, nil);
	kTraitor.frame.st.frame:EnableMouse(true);
	kTraitor.frame.st.frame:SetMovable(true);
	kTraitor.frame.st.frame:RegisterForDrag("LeftButton");
	kTraitor.frame.st.frame:SetScript("OnDragStart", function(self) if IsAltKeyDown() then self:StartMoving(); end end);
	kTraitor.frame.st.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
	kTraitor.frame.st.scrollframe:Hide();
	if not kTraitor.db.profile.frame.enabled then
		kTraitor.frame.st.frame:Hide();
	end
end
function kTraitor:Gui_RefreshFrame()
	-- Requirements:
	-- In combat, InCombatLockdown()
	-- Enabled, isEnabled
	-- Frame visible, kTraitor.db.profile.frame.enabled
	if kTraitor.isEnabled and kTraitor.db.profile.frame.enabled and InCombatLockdown() then
		kTraitor.frame.st:SetData(kTraitor:GetScrollingTableFromLocalData());
		kTraitor.frame.st:SortData();
	end
end
function kTraitor:Gui_HookFrameRefreshUpdate()
	-- Hook to update frames
end