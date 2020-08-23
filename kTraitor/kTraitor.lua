-- Create Mixins
kTraitor = LibStub("AceAddon-3.0"):NewAddon("kTraitor", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
kTraitor.guids = {};
kTraitor.scarabsFound = 0;
local VALID_MOB_NAMES = {"Swarm Scarab", "Elder Mottled Boar"};
local VALID_ZONES = {"Trial of the Crusader", "Durotar", "Mulgore"};
kTraitor.isInValidZone = false;
kTraitor.isEnabled = false;
kTraitor.isWipe = false;
function kTraitor:OnInitialize()
    -- Load Database
    kTraitor.db = LibStub("AceDB-3.0"):New("kTraitorDB", kTraitor.defaults)
    -- Inject Options Table and Slash Commands
	kTraitor.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kTraitor.db)
	kTraitor.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kTraitor", kTraitor.options, {"ktraitor"})
	kTraitor.dialog = LibStub("AceConfigDialog-3.0")
	kTraitor.AceGUI = LibStub("AceGUI-3.0")
	kTraitor.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kTraitor.ae = LibStub("AceEvent-2.0")
	kTraitor.oo = LibStub("AceOO-2.0")
	kTraitor.st = LibStub("ScrollingTable");
	kTraitor.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kTraitor.roster = LibStub("Roster-2.1")
	-- Init Events
	kTraitor:InitializeEvents()
	-- Comm registry
	kTraitor:RegisterComm("kTraitor")
	-- Frames
	kTraitor:Gui_InitializeFrames();
	-- Create parse thread timer
	kTraitor:Threading_CreateTimer("kTraitor_RefreshFrameTimer", function() kTraitor:Gui_RefreshFrame(); end,2,true,nil);
	-- Check for valid zone
	if kTraitor:IsInValidZone() then
		kTraitor.isInValidZone = true;
	end
	if kTraitor.db.profile.enabled and kTraitor.isInValidZone then
		kTraitor.isEnabled = true;
		kTraitor:Enable();
	end
end
function kTraitor:GetScrollingTableFromLocalData()
	local totalThreat = 0;
	local totalAttacking = 0;
	local objList = {};
	-- First, add each raid member to list
	if UnitInRaid("player") then -- In raid
		for i = 1, GetNumRaidMembers() do
			local playerName = UnitName("raid" .. i);
			objList[playerName] = {attackingCount = 0, totalThreat = 0};
		end
	end	
	-- Next, loop through all unique guid, tally threat for each particular player, and if targetting, increase target count
	for i,v in pairs(kTraitor.guids) do
		-- Tally the target count
		if objList[v.target] then
			totalAttacking = totalAttacking + 1;
			objList[v.target].attackingCount = objList[v.target].attackingCount + 1;
		end
		-- Loop through threat table for guid
		for iTb, vTb in pairs(v.threatTable) do
			if objList[iTb] and vTb.threat then -- Valid threat entry for player, add to list
				totalThreat = totalThreat + vTb.threat;
				objList[iTb].totalThreat = objList[iTb].totalThreat + vTb.threat;
			end
		end
	end
	-- Now loop through player list and create export ST datatable
	local st = {};
	if objList then
		for i,v in pairs(objList) do
			tinsert(st, {
				cols = {
					{value = i},
					{value = v.attackingCount},
					{value = kTraitor:GetFormattedThreatString(v.totalThreat)},
				},
			});
		end
	end
	-- Insert tally row
	tinsert(st, {
		cols = {
			{value = "TOTALS",
				color = {
				r = 1,
				g = 0,
				b = 0,
				a = 1.0,
			}},
			{value = totalAttacking,
				color = {
				r = 1,
				g = 0,
				b = 0,
				a = 1.0,
			}},
			{value = kTraitor:GetFormattedThreatString(totalThreat),
				color = {
				r = 1,
				g = 0,
				b = 0,
				a = 1.0,
			}},
		},
	});
	return st;
	--[[
	if dbBar.ShortNumbers and threat >= 100000 then
		bar.Text2:SetFormattedText("%2.1fk [%d%%]", threat / 100000, tankThreat == 0 and 0 or threat / tankThreat * 100)
	else
		bar.Text2:SetFormattedText("%d [%d%%]", threat / 100, tankThreat == 0 and 0 or threat / tankThreat * 100)
	end
	]]
end
function kTraitor:GetFormattedThreatString(threat)
	if threat >= 100000 then
		return string.format("%2.1fk", threat / 100000);
	else
		return string.format("%d", threat / 100);
	end
end
-- Player
-- 
-- PURPOSE: Initialize the events to monitor and fire
function kTraitor:InitializeEvents()
	-- Add events here
	kTraitor:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "CheckForScarabUnit");
	kTraitor:RegisterEvent("PLAYER_TARGET_CHANGED", "CheckForScarabUnit");
	kTraitor:RegisterEvent("PLAYER_REGEN_DISABLED", "EnteringCombat");
	kTraitor:RegisterEvent("PLAYER_REGEN_ENABLED", "ExitingCombat");
	-- Zone events
	kTraitor:RegisterEvent("ZONE_CHANGED", "UpdateCurrentZone");
	kTraitor:RegisterEvent("ZONE_CHANGED_INDOORS", "UpdateCurrentZone");
	kTraitor:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateCurrentZone");
end
function kTraitor:EnteringCombat()
	if kTraitor.isEnabled and kTraitor.isInValidZone then
		kTraitor:Debug("FUNC: EnteringCombat, Enabled and Valid zone", 1);
		kTraitor.isWipe = false;
		kTraitor:Enable();
	end
end
function kTraitor:ExitingCombat()
	kTraitor:Disable(); -- Disable refresh frame timer
end
function kTraitor:UpdateCurrentZone()
	-- Check for valid zone
	if kTraitor:IsInValidZone() then
		kTraitor.isInValidZone = true;
	end
	if kTraitor.db.profile.enabled and kTraitor.isInValidZone then
		kTraitor.isEnabled = true;
		kTraitor:Enable();
	end
end
function kTraitor:Enable()
	kTraitor:Threading_StartTimer("kTraitor_RefreshFrameTimer");
end
function kTraitor:Disable()
	kTraitor:Threading_StopTimer("kTraitor_RefreshFrameTimer");	
	getglobal("kTraitor_RefreshFrameTimer"):Hide();
	-- Destroy frame data
	if kTraitor.frame and kTraitor.frame.st and kTraitor.frame.st.frame then
		kTraitor.frame.st:SetData({});
	end
	-- Destroy guid data
	wipe(kTraitor.guids);
	-- Check if server, send WipeData comm if so
	if kTraitor:Client_IsServer() then
		kTraitor:SendCommunication("WipeData");
	end
end
function kTraitor:OnEnable()
	if kTraitor:Client_IsServer() then
		if GetNumRaidMembers() > 0 then
			kTraitor.isInRaid = true;
			kTraitor:SendCommunication("RaidServer");
			kTraitor:Debug("FUNC: OnEnable, ClientIsServer = true, raid exists, enabled = true.", 1)
		else
			kTraitor:Debug("FUNC: OnEnable, ClientIsServer = true, raid doesn't exist, enabled = false.", 1)
		end
	else
		if GetNumRaidMembers() > 0 then
			kTraitor.isInRaid = true;
			kTraitor:SendCommunication("RaidHasServer", nil);
			kTraitor:Debug("FUNC: OnEnable, ClientIsServer = false, raid exists, RaidHasServer comm sent.", 1)
		else
			kTraitor:Debug("FUNC: OnEnable, ClientIsServer = false, raid doesn't exist, enabled = false.", 1)
		end
	end
end
function kTraitor:CheckForScarabUnit(event)
	if not kTraitor.isEnabled then return; end
	local unit;
	if event == "UPDATE_MOUSEOVER_UNIT" then
		unit = "mouseover";
	elseif event == "PLAYER_TARGET_CHANGED" then
		unit = "target";
	end
	local guid = UnitGUID(unit);
	local name = UnitName(unit);
	if not kTraitor:IsValidMobName(name) then return; end
	-- Check if scarab is dead, if so, remove from list
	if UnitIsDead(unit) then
		if kTraitor.guids[guid] then
			-- If scarab existed in local data, create comm to have deleted from server
			kTraitor:SendCommunication("ScarabDied", guid);
		end
		return;
	end
	-- Check if guid exists

	-- Add guid to local data
	-- Get threat details
	local objThreatTable = {};
	local currentTarget = nil;
	if UnitInRaid("player") then -- In raid
		for i = 1, GetNumRaidMembers() do
			local playerName = UnitName("raid" .. i);
			isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("raid" .. i, unit);
			objThreatTable[playerName] = {scaledPercent = scaledPercent, rawPercent = rawPercent, threat = threatValue};
			if isTanking then currentTarget = playerName; end
		end
	elseif UnitInParty("player") then -- In party
		if GetNumPartyMembers() > 0 then -- Party
			for i = 1, GetNumPartyMembers() do
				local playerName = UnitName("party" .. i);
				isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("party" .. i, unit);
				objThreatTable[playerName] = {scaledPercent = scaledPercent, rawPercent = rawPercent, threat = threatValue};
				if isTanking then currentTarget = playerName; end
			end		
		else -- Solo
			local playerName = UnitName("player");
			isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", unit);
			objThreatTable[playerName] = {scaledPercent = scaledPercent, rawPercent = rawPercent, threat = threatValue};
			if isTanking then currentTarget = playerName; end		
		end		
	end
	kTraitor.guids[guid] = {target = currentTarget, threatTable = objThreatTable};
	-- Send comm
	kTraitor:SendCommunication("DataPush", kTraitor:Serialize("scarab", guid, kTraitor.guids[guid]));
	kTraitor:Debug("FUNC: NewBeacon -- OUTPUT: " .. guid .. ", name: " .. UnitName(unit), 2);
end
function kTraitor:IsValidMobName(name)
	for i,v in pairs(VALID_MOB_NAMES) do
		if name == v then
			return true;
		end
	end
	return false;
end
function kTraitor:IsInValidZone()
	local currentZone = GetRealZoneText();
	for i,v in pairs(VALID_ZONES) do
		if currentZone == v and GetInstanceDifficulty() == 1 then
			kTraitor:Debug("FUNC: IsInValidZone, OUTPUT: True", 3);
			return true;
		end
	end
	kTraitor:Debug("FUNC: IsInValidZone, OUTPUT: False", 3);
	return false;
end
function kTraitor:SendCommunication(command, data)
	kTraitor:SendCommMessage("kTraitor", kTraitor:Serialize(command, data), "RAID")
end
function kTraitor:OnCommReceived(prefix, serialObject, distribution, sender)
	kTraitor:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kTraitor:Deserialize(serialObject)
	if success then
		if prefix == "kTraitor" and distribution == "RAID" then
			if (command == "Delete") and kTraitor:IsPlayerRaidLeader(sender) then
				if not kTraitor:Client_IsServer() then -- If player is not server, delete
					kTraitor:Client_DeleteGuid(sender, data);
				end
			end
			if (command == "ScarabDied") then
				kTraitor:Server_ScarabDied(sender, data);
			end
			if (command == "DataUpdate") and kTraitor:IsPlayerRaidLeader(sender) then
				if not kTraitor:Client_IsServer() then -- If player is not server, update
					kTraitor:Client_DataUpdateReceived(sender, data);
				end
			end
			if (command == "DataPush") then
				kTraitor:Server_DataPushReceived(sender, data);			
			end
			if (command == "RaidHasServer") then
				kTraitor:Server_RaidHasServerReceived(sender);
			end
			if (command == "RaidServer") then
				kTraitor:Client_RaidServerReceived(sender);
			end
			if (command == "Version") then
				kTraitor:Server_VersionReceived(sender, data);
			end
			if (command == "VersionInvalid") and kTraitor:IsPlayerRaidLeader(sender) then
				kTraitor:Client_VersionInvalidReceived(sender, data);
			end
			if (command == "VersionRequest") and kTraitor:IsPlayerRaidLeader(sender) then
				kTraitor:Client_VersionRequestReceived(sender, data);
			end
			if (command == "WipeData") and kTraitor:IsPlayerRaidLeader(sender) then
				if not kTraitor:Client_IsServer() then -- If player is not server, delete
					kTraitor:Client_WipeData();
				end
			end
		end
	end
end
function kTraitor:IsPlayerRaidLeader(name)
	local objUnit = kTraitor.roster:GetUnitObjectFromName(name)
	if objUnit then
		if objUnit.rank == 2 then -- 0 regular, 1 assistant, 2 raid leader
			return true;
		end
	end
	return false;
end
function kTraitor:Debug(msg, threshold)
	if kTraitor.db.profile.debug.enabled then
		if threshold == nil then
			kTraitor:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kTraitor.db.profile.debug.threshold then
			kTraitor:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kTraitor:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kTraitor:ColorizeSubstringInString(subject, substring, r, g, b)
	local t = {};
	for i = 1, strlen(subject) do
		local iStart, iEnd = string.find(strlower(subject), strlower(substring), i, strlen(substring) + i - 1)
		if iStart and iEnd then
			for iTrue = iStart, iEnd do
				t[iTrue] = true;
			end
		else
			if not t[i] then
				t[i] = false;
			end
		end
	end
	local sOut = '';
	local sColor = kTraitor:RGBToHex(r*255,g*255,b*255);
	for i = 1, strlen(subject) do
		if t[i] == true then
			sOut = sOut .. "|cFF"..sColor..strsub(subject, i, i).."|r";
		else
			sOut = sOut .. strsub(subject, i, i);
		end
	end
	if strlen(sOut) > 0 then
		return sOut;
	else
		return nil;
	end
end
function kTraitor:SplitString(subject, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( subject, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( subject, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( subject, delimiter, from  )
	end
	table.insert( result, string.sub( subject, from  ) )
	return result
end