-- Create Mixins
kNecroticPlague = LibStub("AceAddon-3.0"):NewAddon("kNecroticPlague", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
kNecroticPlague.guids = {};
kNecroticPlague.scarabsFound = 0;
local VALID_MOB_NAMES = {"Shambling Horror", "Elder Mottled Boar"};
local VALID_ZONES = {"Icecrown Citadel", "Durotar", "Mulgore"};
local VALID_AURAS = {73786, 73913, 8050, 70337, 70338};
kNecroticPlague.isInValidZone = false;
kNecroticPlague.isEnabled = false;
kNecroticPlague.isWipe = false;
function kNecroticPlague:OnInitialize()
    -- Load Database
    kNecroticPlague.db = LibStub("AceDB-3.0"):New("kNecroticPlagueDB", kNecroticPlague.defaults)
    -- Inject Options Table and Slash Commands
	kNecroticPlague.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kNecroticPlague.db)
	kNecroticPlague.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kNecroticPlague", kNecroticPlague.options, {"knecroticplague", "knp"})
	kNecroticPlague.dialog = LibStub("AceConfigDialog-3.0")
	kNecroticPlague.AceGUI = LibStub("AceGUI-3.0")
	kNecroticPlague.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kNecroticPlague.ae = LibStub("AceEvent-2.0")
	kNecroticPlague.oo = LibStub("AceOO-2.0")
	kNecroticPlague.st = LibStub("ScrollingTable");
	kNecroticPlague.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kNecroticPlague.roster = LibStub("Roster-2.1")
	-- Init Events
	kNecroticPlague:InitializeEvents()
	-- Comm registry
	kNecroticPlague:RegisterComm("kNecroticPlague")
	-- Frames
	kNecroticPlague:Gui_InitializeFrames();
	--kNecroticPlague:Threading_CreateTimer("kNecroticPlague_RefreshFrameTimer", function() kNecroticPlague:Gui_RefreshFrame(); end,0.2,true,nil);
	-- Check for valid zone
	if kNecroticPlague:IsInValidZone() then
		kNecroticPlague.isInValidZone = true;
	end
	if kNecroticPlague.db.profile.enabled and kNecroticPlague.isInValidZone then
		kNecroticPlague.isEnabled = true;
		kNecroticPlague:Enable();
	end
end
function kNecroticPlague:GetScrollingTableFromLocalData()
	--{health = uHealth, plagued = uPlagued, plagueTimeLeft = uPlagueTimeLeft, timeToDeath = uTimeToDeath, diseased = uDiseased};
	local st = {};
	for i,v in pairs(kNecroticPlague.guids) do
		local diseased;
		if v.diseased then
			diseased = "Yes";
		else
			diseased = "No";
		end
		local plagued;
		if v.plagued then
			plagued = "Yes";
		else
			plagued = "No";
		end
		local expirationTime;
		if v.expirationTime and v.plagued and v.expirationTime > 0 and (v.expirationTime - GetTime()) > 0 then
			expirationTime = v.expirationTime - GetTime()
		end
		local deathTime;
		if v.deathTime and v.plagued and v.deathTime > 0 and (v.deathTime - GetTime()) > 0 then
			deathTime = v.deathTime - GetTime()
		end
		tinsert(st, {
			cols = {
				{value = round(v.health * 100, 0) .. "%"},
				{value = plagued},
				{value = round(expirationTime, 2)},
				{value = round(deathTime, 2)},
				--{value = round(deathTime, 2)},
				{value = diseased},
			},
		});
	end
	return st;
end
function round(number, decimals)
	if number and number > 0 then
		return (("%%.%df"):format(decimals)):format(number);
	else
		return;
	end
end
function kNecroticPlague:GetFormattedThreatString(threat)
	if threat >= 100000 then
		return string.format("%2.1fk", threat / 100000);
	else
		return string.format("%d", threat / 100);
	end
end
-- Player
-- 
-- PURPOSE: Initialize the events to monitor and fire
function kNecroticPlague:InitializeEvents()
	-- Add events here
	kNecroticPlague:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "CheckForUnit");
	kNecroticPlague:RegisterEvent("PLAYER_TARGET_CHANGED", "CheckForUnit");
	kNecroticPlague:RegisterEvent("PLAYER_FOCUS_CHANGED", "CheckForUnit");
	kNecroticPlague:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CombatLogEvent");
	kNecroticPlague:RegisterEvent("PLAYER_REGEN_DISABLED", "EnteringCombat");
	kNecroticPlague:RegisterEvent("PLAYER_REGEN_ENABLED", "ExitingCombat");
	-- Zone events
	kNecroticPlague:RegisterEvent("ZONE_CHANGED", "UpdateCurrentZone");
	kNecroticPlague:RegisterEvent("ZONE_CHANGED_INDOORS", "UpdateCurrentZone");
	kNecroticPlague:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateCurrentZone");
end
function kNecroticPlague:EnteringCombat()
	if kNecroticPlague.isEnabled and kNecroticPlague.isInValidZone then
		kNecroticPlague:Debug("FUNC: EnteringCombat, Enabled and Valid zone", 1);
		kNecroticPlague.isWipe = false;
		kNecroticPlague:Enable();
	end
end
function kNecroticPlague:ExitingCombat()
	kNecroticPlague:Disable(); -- Disable refresh frame timer
end
function kNecroticPlague:UpdateCurrentZone()
	-- Check for valid zone
	if kNecroticPlague:IsInValidZone() then
		kNecroticPlague.isInValidZone = true;
	end
	if kNecroticPlague.db.profile.enabled and kNecroticPlague.isInValidZone then
		kNecroticPlague.isEnabled = true;
		kNecroticPlague:Enable();
	end
end
function kNecroticPlague:Enable()
	--kNecroticPlague:Threading_StartTimer("kNecroticPlague_RefreshFrameTimer");
end
function kNecroticPlague:Disable()
	--kNecroticPlague:Threading_StopTimer("kNecroticPlague_RefreshFrameTimer");	
	--getglobal("kNecroticPlague_RefreshFrameTimer"):Hide();
	-- Destroy frame data
	if kNecroticPlague.frame and kNecroticPlague.frame.st and kNecroticPlague.frame.st.frame then
		kNecroticPlague.frame.st:SetData({});
	end
	-- Destroy guid data
	wipe(kNecroticPlague.guids);
	-- Check if server, send WipeData comm if so
	if kNecroticPlague:Client_IsServer() then
		kNecroticPlague:SendCommunication("WipeData");
	end
end
function kNecroticPlague:OnEnable()
	if kNecroticPlague:Client_IsServer() then
		if GetNumRaidMembers() > 0 then
			kNecroticPlague.isInRaid = true;
			kNecroticPlague:SendCommunication("RaidServer");
			kNecroticPlague:Debug("FUNC: OnEnable, ClientIsServer = true, raid exists, enabled = true.", 1)
		else
			kNecroticPlague:Debug("FUNC: OnEnable, ClientIsServer = true, raid doesn't exist, enabled = false.", 1)
		end
	else
		if GetNumRaidMembers() > 0 then
			kNecroticPlague.isInRaid = true;
			kNecroticPlague:SendCommunication("RaidHasServer", nil);
			kNecroticPlague:Debug("FUNC: OnEnable, ClientIsServer = false, raid exists, RaidHasServer comm sent.", 1)
		else
			kNecroticPlague:Debug("FUNC: OnEnable, ClientIsServer = false, raid doesn't exist, enabled = false.", 1)
		end
	end
end
function kNecroticPlague:CheckForUnit(event)
	if not kNecroticPlague.isEnabled then return; end
	local unit;
	if event == "UPDATE_MOUSEOVER_UNIT" then
		unit = "mouseover";
	elseif event == "PLAYER_TARGET_CHANGED" then
		unit = "target";
	elseif event == "PLAYER_FOCUS_CHANGED" then
		unit = "focus";
	end
	local guid = UnitGUID(unit);
	local name = UnitName(unit);
	if not kNecroticPlague:IsValidMobName(name) then return; end
	-- Check if unit is dead, if so, remove from list
	if UnitIsDead(unit) then
		if kNecroticPlague.guids[guid] then
			-- Remove from list
			kNecroticPlague.guids[guid] = nil;
		end
		return;
	end

	-- Add guid to local data
	-- Health(250k) PlagueIcon(IfPlagued) PlagueTimeLeft(15s) TimeToDeath(10s) Disease/NoDisease
	local uHealth, uPlagued, uPlagueTimeLeft, uTimeToDeath, uDiseased, uExpirationTime;
	uHealth = UnitHealth(unit);
	-- Check for proper debuff
	local foundAura = false;
	local durationRemaining;
	local stackCount = 0;
	for i = 1, 40 do
		local _, _, _, count, _, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, i);
		if spellId == 51735 then -- Ebon Plague
			uDiseased = true;
		end
		for iA,vA in pairs(VALID_AURAS) do
			-- Check if valid aura
			if spellId == vA then
				foundAura = spellId;
				uPlagueTimeLeft = expirationTime - GetTime();
				uExpirationTime = expirationTime;
				stackCount = count;
			end
		end
	end
	-- Found Aura?
	if foundAura then
		uPlagued = true;
		local iDamagePerTick = 0;
		local iSecPerTick = 0;
		-- Calc time to death
		if foundAura == 8050 then -- Damage per tick = 7, 6 ticks
			iDamagePerTick = 7;
			iSecPerTick = 3;		
		elseif foundAura == 73786 or foundAura == 73913 then -- Damage per tick = 75000
			-- Modify damage if diseased
			if uDiseased then
				iDamagePerTick = 75000*1.13;
			else
				iDamagePerTick = 75000;
			end
			if stackCount and stackCount > 0 then
				iDamagePerTick = iDamagePerTick * stackCount;
			end
			iSecPerTick = 5;
		elseif foundAura == 70338 or foundAura == 70337 then -- Damage per tick = 50000
			-- Modify damage if diseased
			if uDiseased then
				iDamagePerTick = 50000*1.13;
			else
				iDamagePerTick = 50000;
			end
			if stackCount and stackCount > 0 then
				iDamagePerTick = iDamagePerTick * stackCount;
			end
			iSecPerTick = 5;
		end
		if ceil(uPlagueTimeLeft / iSecPerTick) * iDamagePerTick >= uHealth then
			-- Unit will die
			-- 17hp
			-- 17 / 5 * 3 = 9 + 10 / 3 - floor(10/3)
			-- 9 + 3.333 - 3
			-- 9.333
			uTimeToDeath = (floor(uHealth / iDamagePerTick) * iSecPerTick) + (((uPlagueTimeLeft / iSecPerTick) - floor(uPlagueTimeLeft / iSecPerTick)) * iSecPerTick);
		else
			-- Unit lives
			uTimeToDeath = 0;
		end
		if uTimeToDeath and uTimeToDeath > 0 then
			deathTime = uTimeToDeath + GetTime();
		end
		-- Found, update local data
		kNecroticPlague.guids[guid] = {spellId = foundAura, health = uHealth / UnitHealthMax(unit), plagued = uPlagued, plagueTimeLeft = uPlagueTimeLeft, timeToDeath = uTimeToDeath, diseased = uDiseased, expirationTime = uExpirationTime, deathTime = deathTime};
	else
		uPlagued = false;
		if uTimeToDeath and uTimeToDeath > 0 then
			deathTime = uTimeToDeath + GetTime();
		end
		kNecroticPlague.guids[guid] = {spellId = foundAura, health = uHealth / UnitHealthMax(unit), plagued = uPlagued, plagueTimeLeft = uPlagueTimeLeft, timeToDeath = uTimeToDeath, diseased = uDiseased, expirationTime = uExpirationTime, deathTime = deathTime};
	end
end
function kNecroticPlague:CombatLogEvent(event, ...)
	if (select(2, ...)=="UNIT_DIED") then
		local guid = select(6, ...);
		for i,v in pairs(kNecroticPlague.guids) do
			if guid == i then
				kNecroticPlague:Debug("CombatLogEvent_UNIT_DIED -- Removing Unit", 3);
				-- Match, remove
				kNecroticPlague.guids[guid] = nil;
			end
		end
	end
end
function kNecroticPlague:IsValidMobName(name)
	for i,v in pairs(VALID_MOB_NAMES) do
		if name == v then
			return true;
		end
	end
	return false;
end
function kNecroticPlague:IsInValidZone()
	local currentZone = GetRealZoneText();
	for i,v in pairs(VALID_ZONES) do
		if currentZone == v and GetInstanceDifficulty() == 1 then
			kNecroticPlague:Debug("FUNC: IsInValidZone, OUTPUT: True", 3);
			return true;
		end
	end
	kNecroticPlague:Debug("FUNC: IsInValidZone, OUTPUT: False", 3);
	return false;
end
function kNecroticPlague:SendCommunication(command, data)
	kNecroticPlague:SendCommMessage("kNecroticPlague", kNecroticPlague:Serialize(command, data), "RAID")
end
function kNecroticPlague:OnCommReceived(prefix, serialObject, distribution, sender)
	kNecroticPlague:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kNecroticPlague:Deserialize(serialObject)
	if success then
		if prefix == "kNecroticPlague" and distribution == "RAID" then
			if (command == "Delete") and kNecroticPlague:IsPlayerRaidLeader(sender) then
				if not kNecroticPlague:Client_IsServer() then -- If player is not server, delete
					kNecroticPlague:Client_DeleteGuid(sender, data);
				end
			end
			if (command == "ScarabDied") then
				kNecroticPlague:Server_ScarabDied(sender, data);
			end
			if (command == "DataUpdate") and kNecroticPlague:IsPlayerRaidLeader(sender) then
				if not kNecroticPlague:Client_IsServer() then -- If player is not server, update
					kNecroticPlague:Client_DataUpdateReceived(sender, data);
				end
			end
			if (command == "DataPush") then
				kNecroticPlague:Server_DataPushReceived(sender, data);			
			end
			if (command == "RaidHasServer") then
				kNecroticPlague:Server_RaidHasServerReceived(sender);
			end
			if (command == "RaidServer") then
				kNecroticPlague:Client_RaidServerReceived(sender);
			end
			if (command == "Version") then
				kNecroticPlague:Server_VersionReceived(sender, data);
			end
			if (command == "VersionInvalid") and kNecroticPlague:IsPlayerRaidLeader(sender) then
				kNecroticPlague:Client_VersionInvalidReceived(sender, data);
			end
			if (command == "VersionRequest") and kNecroticPlague:IsPlayerRaidLeader(sender) then
				kNecroticPlague:Client_VersionRequestReceived(sender, data);
			end
			if (command == "WipeData") and kNecroticPlague:IsPlayerRaidLeader(sender) then
				if not kNecroticPlague:Client_IsServer() then -- If player is not server, delete
					kNecroticPlague:Client_WipeData();
				end
			end
		end
	end
end
function kNecroticPlague:IsPlayerRaidLeader(name)
	local objUnit = kNecroticPlague.roster:GetUnitObjectFromName(name)
	if objUnit then
		if objUnit.rank == 2 then -- 0 regular, 1 assistant, 2 raid leader
			return true;
		end
	end
	return false;
end
function kNecroticPlague:Debug(msg, threshold)
	if kNecroticPlague.db.profile.debug.enabled then
		if threshold == nil then
			kNecroticPlague:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kNecroticPlague.db.profile.debug.threshold then
			kNecroticPlague:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kNecroticPlague:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kNecroticPlague:ColorizeSubstringInString(subject, substring, r, g, b)
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
	local sColor = kNecroticPlague:RGBToHex(r*255,g*255,b*255);
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
function kNecroticPlague:SplitString(subject, delimiter)
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