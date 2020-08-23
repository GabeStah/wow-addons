-- Create Mixins
kFormation = LibStub("AceAddon-3.0"):NewAddon("kFormation", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
kFormation.menu = {};
kFormation.currentZone = false;
function kFormation:OnInitialize()
    -- Load Database
    kFormation.db = LibStub("AceDB-3.0"):New("kFormationDB", kFormation.defaults)
    -- Inject Options Table and Slash Commands
	kFormation.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kFormation.db)
	kFormation.candyBar = LibStub("CandyBar-2.0");
	kFormation.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kFormation", kFormation.options, {"kformation", "kf"})
	kFormation.dialog = LibStub("AceConfigDialog-3.0")
	kFormation.aceGui = LibStub("AceGUI-3.0")
	kFormation.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kFormation.ae = LibStub("AceEvent-2.0")
	kFormation.effects = LibStub("LibEffects-1.0")
	kFormation.oo = LibStub("AceOO-2.0")
	kFormation.qTip = LibStub("LibQTip-1.0")
	kFormation.roster = LibStub("Roster-2.1")
	kFormation.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kFormation:RegisterLibSharedMediaObjects();
	kFormation.tablet = LibStub("Tablet-2.0")
	kFormation.tourist = LibStub("LibTourist-3.0");
	--kFormation.ring = LibStub("kRotaryLib-1.0")
	--kFormation:Threading_CreateTimer("createTestRing",InitializeTestRing,5,false,nil);
	--kFormation:Threading_StartTimer("createTestRing");
	--kFormation:Ring_InitalizeTestRing();
	-- Init Events
	--kFormation:InitializeEvents()
	-- Comm registry
	kFormation:RegisterComm("kFormation")
	--kFormation:Gui_InitializePopups();
	--kFormation:Gui_InitializeFrames()
	--kFormation:Gui_HookFrameRefreshUpdate();
	-- Menu
	--kFormation.menu = CreateFrame("Frame", "Test_DropDown", UIParent, "UIDropDownMenuTemplate");
	-- Init council list
	--kFormation:Server_InitializeCouncilMemberList();
	kFormation:CreateCurrentDungeonMapTexture(50, 50, 1);
end
function kFormation:CreateCurrentDungeonMapTexture(centerX, centerY, zoom)
	SetMapToCurrentZone();
	local f1 = CreateFrame("ScrollFrame","kFormationMain",UIParent)
	f1:SetFrameStrata("LOW")
	f1:SetFrameLevel(1);
	f1:EnableMouse(true);
	f1:SetWidth(500);
	f1:SetHeight(500);
	f1:SetPoint("CENTER", 500,0);
	f1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
	f1:SetBackdropColor(1,0,0,1);
	
	local fInfo = kFormation:Gui_CreateDebugInfoFrame(f1);	
	local fMap = kFormation:Gui_CreateMapFrame(f1);

	f1:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			kFormation:Print("Right Click");
		end
		if button == "MiddleButton" then
			kFormation:Gui_CenterMapFrameOnCursor();
		end
	end);
	f1:IsMovable(true);
	f1:RegisterForDrag("LeftButton");
	f1:EnableMouseWheel(true);
	f1.zoom = 1;
	f1:SetScript("OnUpdate", function(self, button)
		if (self.isDragging and self.xStartDrag and self.yStartDrag) then
			local x, y = kFormation:Nav_GetEffectiveCursorPosition(); 
			if (self.xStartDrag > x) then
				self:SetHorizontalScroll(self:GetHorizontalScroll() - ((self.xStartDrag - x) / fMap:GetScale()));
				self.xStartDrag = x;
			else
				self:SetHorizontalScroll(self:GetHorizontalScroll() - ((self.xStartDrag - x) / fMap:GetScale()));
				self.xStartDrag = x;
			end	
			if (self.yStartDrag > y) then
				self:SetVerticalScroll(self:GetVerticalScroll() - ((self.yStartDrag - y) / fMap:GetScale()));
				self.yStartDrag = y;				
			else
				self:SetVerticalScroll(self:GetVerticalScroll() - ((self.yStartDrag - y) / fMap:GetScale()));
				self.yStartDrag = y;
			end
		end
		-- Update mouse coords
		if MouseIsOver(self) and MouseIsOver(fMap) then
			local x, y = kFormation:Nav_GetMapCoordinatesAtCursor();
			local xPlayer, yPlayer = GetPlayerMapPosition("player");
			local xLocal, yLocal = kFormation:Nav_GetMapEffectivePositionAtCursor();
			getglobal(self:GetName().."DebugInfo_EffectiveCoordsText"):SetText("Effective - x: " .. x .. ", y: " .. y);
			getglobal(self:GetName().."DebugInfo_PlayerCoordsText"):SetText("Player - x: " .. xPlayer .. ", y: " .. yPlayer);
			getglobal(self:GetName().."DebugInfo_LocalCoordsText"):SetText("Local - x: " .. xLocal .. ", y: " .. yLocal);
			getglobal(self:GetName().."DebugInfo_ZoomText"):SetText("Zoom - " .. kFormation.db.profile.gui.frames.map.zoom);
			getglobal(self:GetName().."DebugInfo_ScrollText"):SetText("Scroll - horizontal: " .. self:GetHorizontalScroll() .. ", vertical: " .. self:GetVerticalScroll());
		end
	end);
	f1:SetScript("OnDragStart", function(self,button)
		self.isDragging = true;
		self.xStartDrag, self.yStartDrag = kFormation:Nav_GetEffectiveCursorPosition(); 
	end);
	f1:SetScript("OnDragStop", function(self,button)
		if (self.isDragging) then
			self.isDragging = false;
			self.xStartDrag = nil;
			self.yStartDrag = nil;
		end
	end);
	f1:SetScript("OnMouseWheel", function(self,delta)
		local x, y = kFormation:Nav_GetMapCoordinatesAtCursor();
		self.zoom = kFormation:Gui_UpdateMapZoomValue(delta);
		kFormation:Gui_RedrawMapFrame();
		kFormation:Gui_CenterMapFrameOnCoords(x, y);
	end);	
	f1:Show();
end
function kFormation:InitializeEvents()
	kFormation.enabled = false;
	kFormation.isActiveRaid = false;
	kFormation.isInRaid = false;
end
function kFormation:UI_ERROR_MESSAGE(arg1, arg2)
	local xPlayer,yPlayer = GetPlayerMapPosition("player");
	local xOther,yOther = GetPlayerMapPosition("raid1");
	local distance = math.sqrt((yOther - yPlayer) * (yOther - yPlayer) + (xOther - xPlayer) * (xOther - xPlayer));
	if arg2 then
		if arg2 == "Out of range." then
			if kFormation.db.profile.coords.minOutOfRange2 then
				if distance < kFormation.db.profile.coords.minOutOfRange2 then
					kFormation:Print("UPDATE outrange dist UPDATE: " .. distance .. ", old: " .. kFormation.db.profile.coords.minOutOfRange2);					
					kFormation.db.profile.coords.minOutOfRange2 = distance;	
				else
					kFormation:Debug("outrange dist: " .. distance, 3);					
				end
			else
				kFormation.db.profile.coords.minOutOfRange2 = distance;				
			end
		elseif arg2 == "You can't do that yet" then
			if kFormation.db.profile.coords.maxInRange2 then
				
				if distance > kFormation.db.profile.coords.maxInRange2 then
					kFormation:Print("UPDATE inrange dist UPDATE: " .. distance .. ", old: " .. kFormation.db.profile.coords.maxInRange2);					
					kFormation.db.profile.coords.maxInRange2 = distance;
				else
					kFormation:Debug("inrange dist: " .. distance, 3);					
				end
			else
				kFormation.db.profile.coords.maxInRange2 = distance;				
			end
		end
	end
end
function kFormation:RegisterLibSharedMediaObjects()
	-- Fonts
	kFormation.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kFormation\Fonts\Adventure.ttf]]);
	kFormation.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kFormation\Fonts\albas.ttf]]);
	kFormation.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kFormation\Fonts\CAS_ANTN.TTF]]);
	kFormation.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kFormation\Fonts\Cella.otf]]);
	kFormation.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kFormation\Fonts\chick.ttf]]);
	kFormation.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kFormation\Fonts\Corleone.ttf]]);
	kFormation.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kFormation\Fonts\CorleoneDue.ttf]]);
	kFormation.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kFormation\Fonts\Forte.ttf]]);
	kFormation.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kFormation\Fonts\freshbot.ttf]]);
	kFormation.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kFormation\Fonts\jokewood.ttf]]);
	kFormation.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kFormation\Fonts\Mobsters.ttf]]);
	kFormation.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kFormation\Fonts\weltu.ttf]]);
	kFormation.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kFormation\Fonts\WildRide.ttf]]);
	-- Sounds
	kFormation.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kFormation\Sounds\alarm.mp3]]);
	kFormation.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kFormation\Sounds\alert.mp3]]);
	kFormation.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kFormation\Sounds\info.mp3]]);
	kFormation.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kFormation\Sounds\long.mp3]]);
	kFormation.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kFormation\Sounds\shot.mp3]]);
	kFormation.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kFormation\Sounds\sonar.mp3]]);
	kFormation.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kFormation\Sounds\victory.mp3]]);
	kFormation.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kFormation\Sounds\victoryClassic.mp3]]);
	kFormation.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kFormation\Sounds\victoryLong.mp3]]);
	kFormation.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kFormation\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	kFormation.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kFormation\Sounds\wangryscotscomeonthen.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kFormation\Sounds\wangryscotscoward.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kFormation\Sounds\wangryscotsillgetyou.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kFormation\Sounds\wdrillsargeantfire.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kFormation\Sounds\wdrillsargeantstupid.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kFormation\Sounds\wdrillsargeantwatchthis.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kFormation\Sounds\wgrandpacoward.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kFormation\Sounds\wgrandpauhoh.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kFormation\Sounds\willgetyou.wav]]);
	kFormation.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kFormation\Sounds\wuhoh.wav]]);
	-- Drum
	kFormation.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kFormation\Sounds\snare1.mp3]]);
end

function kFormation:OnEnable()

end
function kFormation:OnDisable()
    -- Called when the addon is disabled
end
function kFormation:SendCommunication(command, data)
	kFormation:SendCommMessage("kFormation", kFormation:Serialize(command, data), "RAID")
end
function kFormation:OnCommReceived(prefix, serialObject, distribution, sender)
	kFormation:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kFormation:Deserialize(serialObject)
	if success then
		if prefix == "kFormation" and distribution == "RAID" then
			if (command == "Auction" and kFormation:IsPlayerRaidLeader(sender)) then
				kFormation:Client_AuctionReceived(data);
			end
			if (command == "AuctionDelete" and kFormation:IsPlayerRaidLeader(sender)) then
				kFormation:Client_AuctionDeleteReceived(sender, data);
			end
			if (command == "AuctionWinner" and kFormation:IsPlayerRaidLeader(sender)) then
				kFormation:Client_AuctionWinnerReceived(sender, data);
			end
			if (command == "Bid") then
				kFormation:Client_BidReceived(sender, data);
			end
			if (command == "BidCancel") then
				kFormation:Client_BidCancelReceived(sender, data);
			end
			if (command == "BidVote") then
				kFormation:Client_BidVoteReceived(sender, data);
			end
			if (command == "BidVoteCancel") then
				kFormation:Client_BidVoteCancelReceived(sender, data);
			end
			if (command == "DataUpdate") then
				kFormation:Client_DataUpdateReceived(sender, data);
			end
			if (command == "RaidEnd") and kFormation:IsPlayerRaidLeader(sender) then
				kFormation.auctions = {};	
				kFormation.auctionTabs = {};
			end			
			if (command == "RaidHasServer") then
				kFormation:Server_RaidHasServerReceived(sender);
			end
			if (command == "RaidServer") then
				kFormation:Client_RaidServerReceived(sender);
			end
			if (command == "Version") then
				kFormation:Server_VersionReceived(sender, data);
			end
			if (command == "VersionInvalid") and kFormation:IsPlayerRaidLeader(sender) then
				kFormation:Client_VersionInvalidReceived(sender, data);
			end
			if (command == "VersionRequest") and kFormation:IsPlayerRaidLeader(sender) then
				kFormation:Client_VersionRequestReceived(sender, data);
			end
			-- Refresh frames
			kFormation:Gui_HookFrameRefreshUpdate();
		end
	end
end
function kFormation:IsPlayerRaidLeader(name)
	local objUnit = kFormation.roster:GetUnitObjectFromName(name)
	if objUnit then
		if objUnit.rank == 2 then -- 0 regular, 1 assistant, 2 raid leader
			return true;
		end
	end
	return false;
end
function kFormation:Debug(msg, threshold)
	if kFormation.db.profile.debug.enabled then
		if threshold == nil then
			kFormation:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kFormation.db.profile.debug.threshold then
			kFormation:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kFormation:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kFormation:ZONE_CHANGED_NEW_AREA()
	-- Check if entering a valid raid zone
	if kFormation.isInRaid == true and not kFormation.isActiveRaid and kFormation:Client_IsServer() then
		if kFormation:Server_IsInValidRaidZone() then -- Check for valid zone
			StaticPopup_Show("kFormationPopup_StartRaidTracking");
		end
	elseif kFormation.isInRaid == true and kFormation.isActiveRaid == true and kFormation.enabled == true and kFormation:Client_IsServer() and not kFormation:Server_IsInValidRaidZone() and not UnitIsDeadOrGhost("player") then
		StaticPopup_Show("kFormationPopup_StopRaidTracking");
	end
end