-- Author      : Gabe
-- Create Date : 10/12/2009 4:18:07 PM
kNecroticPlague.frame = {};
function kNecroticPlague:Gui_HideFrame()
	if kNecroticPlague.frame and kNecroticPlague.frame.st and kNecroticPlague.frame.st.frame then
		kNecroticPlague.frame.st.frame:Hide();
	end
end
function kNecroticPlague:Gui_ShowFrame()
	if kNecroticPlague.frame and kNecroticPlague.frame.st and kNecroticPlague.frame.st.frame then
		kNecroticPlague.frame.st.frame:Show();
	end
end
function kNecroticPlague:Gui_InitializeFrames()
	local elapsed = 0;
	-- Create initial frames
	local cols = {
		{
			["name"] = "HP",
			["width"] = 40,
			["align"] = "CENTER",
		},
		{
			["name"] = "Plagued",
			["width"] = 60,
			["align"] = "CENTER",
		},
		{
			["name"] = "Remaining",
			["width"] = 70,
			["align"] = "CENTER",
		},
		{
			["name"] = "Death",
			["width"] = 55,
			["align"] = "CENTER",
		},
		--{
		--	["name"] = "ForNextJumpDeath",
		--	["width"] = 90,
		--	["align"] = "CENTER",
		--},
		{
			["name"] = "13%",
			["width"] = 30,
			["align"] = "CENTER",
		},
	};
	kNecroticPlague.frame.st = kNecroticPlague.st:CreateST(cols, 3, 15, nil, nil);
	kNecroticPlague.frame.st.frame:EnableMouse(true);
	kNecroticPlague.frame.st.frame:SetMovable(true);
	kNecroticPlague.frame.st.frame:RegisterForDrag("LeftButton");
	kNecroticPlague.frame.st.frame:SetScript("OnDragStart", function(self) if IsAltKeyDown() then self:StartMoving(); end end);
	kNecroticPlague.frame.st.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
	kNecroticPlague.frame.st.frame:SetScript("OnUpdate", function(self, e)
		elapsed = elapsed + e
		if elapsed >= 0.05 then
			kNecroticPlague:Gui_OnUpdate(self, elapsed)
			elapsed = 0
		end
	end)
	kNecroticPlague.frame.st.scrollframe:Hide();
	if not kNecroticPlague.db.profile.frame.enabled then
		kNecroticPlague.frame.st.frame:Hide();
	end
end
function kNecroticPlague:Gui_OnUpdate(self, elapsed)
	-- Requirements:
	-- In combat, InCombatLockdown()
	-- Enabled, isEnabled
	-- Frame visible, kNecroticPlague.db.profile.frame.enabled
	kNecroticPlague:CheckForUnit("UPDATE_MOUSEOVER_UNIT");
	kNecroticPlague:CheckForUnit("PLAYER_TARGET_CHANGED");
	kNecroticPlague:CheckForUnit("PLAYER_FOCUS_CHANGED");
	if kNecroticPlague.isEnabled and kNecroticPlague.db.profile.frame.enabled and InCombatLockdown() then
		kNecroticPlague.frame.st:SetData(kNecroticPlague:GetScrollingTableFromLocalData());
		kNecroticPlague.frame.st:SortData();
	end
end
function kNecroticPlague:Gui_HookFrameRefreshUpdate()
	-- Hook to update frames
end