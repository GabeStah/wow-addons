--[[ TODO
Determine who is Administrator (raid leader, group leader, assigned players, etc)
Create .auctions data structure
Create auction methods (ON_LOOT, VIA LINK)


]]



-- Create Mixins
local _G = _G

local kNew = LibStub("AceAddon-3.0"):NewAddon("kNew", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
_G.kNew = kNew
kNew.timers = {};
local sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
kNew.sharedMedia = sharedMedia
function kNew:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kNewDB", self.defaults)
    self.raidDb = LibStub("AceDB-3.0"):New("kNewRaidDB")
    -- Inject Options Table and Slash Commands
	kNew:Options_CreateCustomOptions();	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kNew", self.options, {"knew", "kn"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.gui = LibStub("AceGUI-3.0")
	--self.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	--self.effects = LibStub("LibEffects-1.0")
	--self.oo = LibStub("AceOO-2.0")
	--self.qTip = LibStub("LibQTip-1.0")
	self:RegisterLibSharedMediaObjects();
	--self.tablet = LibStub("Tablet-2.0")
	--self.StatLogic = LibStub("LibStatLogic-1.1")
	self.clientBuild = select(4, GetBuildInfo());
	-- Init Events
	self:InitializeEvents()
	-- Comm registry
	self:RegisterComm("kNew")
	-- Frames
	-- Menu
	self.menu = CreateFrame("Frame", "Test_DropDown", UIParent, "UIDropDownMenuTemplate");
	self.updateFrame = CreateFrame("Frame", "kNewUpdateFrame", UIParent);
	kNewUpdateFrame:SetScript("OnUpdate", function(frame,elapsed) kNew:OnUpdate(1, elapsed) end)
	-- Init council list
	--self:Server_InitializeCouncilMemberList();
end

function kNew:InitializeEvents()
	self.enabled = false;
	self.isActiveRaid = false;
	self.isInRaid = false;
	kNew:RegisterEvent("PLAYER_ENTERING_WORLD");
	kNew:RegisterEvent("LOOT_OPENED");
	kNew:RegisterEvent("LOOT_CLOSED");
	kNew:RegisterEvent("UNIT_SPELLCAST_SENT");
	kNew:RegisterEvent("RAID_ROSTER_UPDATE");
	kNew:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	--kNew:RegisterEvent("CHAT_MSG_WHISPER");
	
	-- Update
	--_G[self.db.profile.gui.frames.main.name]:SetScript("OnUpdate", function(frame,elapsed) kNew:OnUpdate(1, elapsed) end)
	kNew:CreateColorCodes()
end
function kNew:RegisterLibSharedMediaObjects()
	-- Fonts
	sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kNew\Fonts\Adventure.ttf]]);
	sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kNew\Fonts\albas.ttf]]);
	sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kNew\Fonts\CAS_ANTN.TTF]]);
	sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kNew\Fonts\Cella.otf]]);
	sharedMedia:Register("font", "Chick", [[Interface\AddOns\kNew\Fonts\chick.ttf]]);
	sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kNew\Fonts\Corleone.ttf]]);
	sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kNew\Fonts\CorleoneDue.ttf]]);
	sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kNew\Fonts\Forte.ttf]]);
	sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kNew\Fonts\freshbot.ttf]]);
	sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kNew\Fonts\jokewood.ttf]]);
	sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kNew\Fonts\Mobsters.ttf]]);
	sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kNew\Fonts\weltu.ttf]]);
	sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kNew\Fonts\WildRide.ttf]]);
	-- Sounds
	
	sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kNew\Sounds\alarm.mp3]]);
	sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kNew\Sounds\alert.mp3]]);
	sharedMedia:Register("sound", "Info", [[Interface\AddOns\kNew\Sounds\info.mp3]]);
	sharedMedia:Register("sound", "Long", [[Interface\AddOns\kNew\Sounds\long.mp3]]);
	sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kNew\Sounds\shot.mp3]]);
	sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kNew\Sounds\sonar.mp3]]);
	sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kNew\Sounds\victory.mp3]]);
	sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kNew\Sounds\victoryClassic.mp3]]);
	sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kNew\Sounds\victoryLong.mp3]]);
	sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kNew\Sounds\wilhelm.mp3]]);

	-- Sounds, Worms
	sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kNew\Sounds\wangryscotscomeonthen.wav]]);
	sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kNew\Sounds\wangryscotscoward.wav]]);
	sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kNew\Sounds\wangryscotsillgetyou.wav]]);
	sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kNew\Sounds\wdrillsargeantfire.wav]]);
	sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kNew\Sounds\wdrillsargeantstupid.wav]]);
	sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kNew\Sounds\wdrillsargeantwatchthis.wav]]);
	sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kNew\Sounds\wgrandpacoward.wav]]);
	sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kNew\Sounds\wgrandpauhoh.wav]]);
	sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kNew\Sounds\willgetyou.wav]]);
	sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kNew\Sounds\wuhoh.wav]]);
	-- Drum
	sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kNew\Sounds\snare1.mp3]]);
	-- Nyan
	sharedMedia:Register("sound", "Wut", [[Interface\AddOns\kNew\Sounds\wut.mp3]]);
	-- Icons
	sharedMedia:Register("texture", "user-mystery", [[Interface\AddOns\kNew\Images\Textures\user-mystery.tga]]);
	sharedMedia:Register("texture", "user-add", [[Interface\AddOns\kNew\Images\Textures\user-add.tga]]);
	sharedMedia:Register("texture", "user-check", [[Interface\AddOns\kNew\Images\Textures\user-check.tga]]);
	sharedMedia:Register("texture", "user-delete", [[Interface\AddOns\kNew\Images\Textures\user-delete.tga]]);
	sharedMedia:Register("texture", "star", [[Interface\AddOns\kNew\Images\Textures\star.tga]]);
	sharedMedia:Register("texture", "star-half", [[Interface\AddOns\kNew\Images\Textures\star-half.tga]]);
	sharedMedia:Register("texture", "star-none", [[Interface\AddOns\kNew\Images\Textures\star-none.tga]]);
	sharedMedia:Register("texture", "star2-full", [[Interface\AddOns\kNew\Images\Textures\star2-full.tga]]);
	sharedMedia:Register("texture", "star2-half", [[Interface\AddOns\kNew\Images\Textures\star2-half.tga]]);
	sharedMedia:Register("texture", "star2-empty", [[Interface\AddOns\kNew\Images\Textures\star2-empty.tga]]);
	sharedMedia:Register("texture", "clock", [[Interface\AddOns\kNew\Images\Textures\clock.tga]]);
	sharedMedia:Register("texture", "clockdark", [[Interface\AddOns\kNew\Images\Textures\clockdark.tga]]);
	sharedMedia:Register("texture", "x", [[Interface\AddOns\kNew\Images\Textures\x.tga]]);
	sharedMedia:Register("texture", "check", [[Interface\AddOns\kNew\Images\Textures\check.tga]]);
	sharedMedia:Register("texture", "exclaim", [[Interface\AddOns\kNew\Images\Textures\exclaim.tga]]);
	sharedMedia:Register("texture", "xdark", [[Interface\AddOns\kNew\Images\Textures\xdark.tga]]);
	sharedMedia:Register("texture", "shield-red", [[Interface\AddOns\kNew\Images\Textures\shield-red.tga]]);
	sharedMedia:Register("texture", "shield-blue", [[Interface\AddOns\kNew\Images\Textures\shield-blue.tga]]);
	sharedMedia:Register("texture", "medal", [[Interface\AddOns\kNew\Images\Textures\medal.tga]]);
	sharedMedia:Register("texture", "medal-grey", [[Interface\AddOns\kNew\Images\Textures\medal-grey.tga]]);
end

function kNew:OnEnable()
--[[
	if kNew:Client_IsServer() then
		if kNew:GetPlayerCount() > 0 then
			self.isInRaid = true;
			kNew:SendCommunication("RaidServer");
			if kNew:Server_IsInValidRaidZone() then -- Check for valid zone
				StaticPopup_Show("kNewPopup_StartRaidTracking");
			end
			kNew:Debug("FUNC: OnEnable, ClientIsServer = true, raid exists, enabled = true.", 1)
		else
			kNew:Debug("FUNC: OnEnable, ClientIsServer = true, raid doesn't exist, enabled = false.", 1)
		end
	else
		if kNew:GetPlayerCount() > 0 then
			self.isInRaid = true;
			kNew:SendCommunication("RaidHasServer", nil);
			kNew:Debug("FUNC: OnEnable, ClientIsServer = false, raid exists, RaidHasServer comm sent.", 1)
		else
			kNew:Debug("FUNC: OnEnable, ClientIsServer = false, raid doesn't exist, enabled = false.", 1)
		end
	end
	kNew:Gui_EncounterJournal_Initialize()
	]]
end
function kNew:OnDisable()
    -- Called when the addon is disabled
end
function kNew:PLAYER_ENTERING_WORLD()
	RegisterAddonMessagePrefix("kNew")
end
function kNew:LOOT_CLOSED()
	kNew:Debug("EVENT: LOOT_CLOSED", 3)
	self.isLooting = false;
end
function kNew:LOOT_OPENED()
	kNew:Debug("EVENT: LOOT_OPENED", 3)
	self.isLooting = true;
	if self.enabled and self.isActiveRaid and kNew:GetPlayerCount() > 0 and kNew:Client_IsServer() then -- Player in raid and raid leader
		local guid = UnitGUID("target") -- NPC Looted
		local corpseName = UnitName("target");
		if not guid then -- Else Container Looted
			guid = self.guids.lastObjectOpened;
			corpseName = self.guids.lastObjectOpened;
		end			
		if kNew:Server_HasCorpseBeenAuctioned(guid) == false then -- Check if corpse auctioned already.
			kNew:Server_SetCorpseAsAuctioned(guid) -- Mark corpse as auctioned		
			for i = 1, GetNumLootItems() do
				if (LootSlotIsItem(i)) then
					if self.db.profile.looting.isAutoAuction then
						kNew:Server_AuctionItem(GetLootSlotLink(i), guid, corpseName)
					end
				end
			end		
		end		
	end
end
function kNew:RAID_ROSTER_UPDATE()
	-- Client just joined a raid.
	if self.isInRaid == false and kNew:GetPlayerCount() > 0 then
		self.hasRunVersionCheck = false;
		self.isInRaid = true;
		-- Check if Server, and valid zone
		if kNew:Client_IsServer() then
			kNew:SendCommunication("RaidServer");
			if kNew:Server_IsInValidRaidZone() then -- Check for valid zone
				StaticPopup_Show("kNewPopup_StartRaidTracking");
			end
		else
			kNew:SendCommunication("RaidHasServer", nil);
		end
		kNew:Debug("FUNC: RAID_ROSTER_UPDATE - Client just joined a raid.", 1);
	-- Client just left a raid.
	elseif self.isInRaid == true and isActiveRaid == true and kNew:GetPlayerCount() == 0 then
		self.hasRunVersionCheck = false;
		self.isInRaid = false;
		-- Check if Server
		if kNew:Client_IsServer() then
			StaticPopup_Show("kNewPopup_StopRaidTracking");
		end
		kNew:Debug("FUNC: RAID_ROSTER_UPDATE - Client just left a raid.", 1);
	end
end
function kNew:UNIT_SPELLCAST_SENT(blah, unit, spell, rank, target)
	if spell == "Opening" then
		self.guids.lastObjectOpened = target;
		kNew:Debug("FUNC: UNIT_SPELLCAST_SENT, target: " .. target .. ", spell: " .. spell, 3)
	end
end
function kNew:SendCommunication(command, data, priority)
	local prio = 'NORMAL'
	if priority then
		if priority == 1 then
			prio = 'BULK'
		elseif priority == 3 then
			prio = 'ALERT'
		end
	end
	kNew:SendCommMessage("kNew", kNew:Serialize(command, data), "RAID", nil, prio)
end
function kNew:OnCommReceived(prefix, serialObject, distribution, sender)
	kNew:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kNew:Deserialize(serialObject)
	if success then
		if prefix == "kNew" and distribution == "RAID" then
			if (command == "Auction" and kNew:IsPlayerRaidLeader(sender)) then
				kNew:Client_AuctionReceived(data);
			end
			if (command == "AuctionDelete" and kNew:IsPlayerRaidLeader(sender)) then
				kNew:Client_AuctionDeleteReceived(sender, data);
			end
			if (command == "AuctionWinner" and kNew:IsPlayerRaidLeader(sender)) then
				kNew:Client_AuctionWinnerReceived(sender, data);
			end
			if (command == "Bid") then
				kNew:Client_BidReceived(sender, data);
			end
			if (command == "BidCancel") then
				kNew:Client_BidCancelReceived(sender, data);
			end
			if (command == "BidVote") then
				kNew:Client_BidVoteReceived(sender, data);
			end
			if (command == "BidVoteCancel") then
				kNew:Client_BidVoteCancelReceived(sender, data);
			end
			if (command == "DataUpdate") then
				kNew:Client_DataUpdateReceived(sender, data);
				-- Update Raid DB Xml
				if kNew:Client_IsServer() then
					kNew:Server_UpdateRaidDb();
				end				
			end
			if (command == "RaidEnd") and kNew:IsPlayerRaidLeader(sender) then
				self.auctions = {};	
				self.auctionTabs = {};
			end			
			if (command == "RaidHasServer") then
				kNew:Server_RaidHasServerReceived(sender);
			end
			if (command == "RaidServer") then
				kNew:Client_RaidServerReceived(sender);
			end
			if (command == "RequestAuraCancel") then
				kNew:Client_AuraCancelReceived(sender, data);
			end
			if (command == "RequestAuraEnable") then
				kNew:Client_AuraEnableReceived(sender, data);
			end
			if (command == "RequestAuraDisable") then
				kNew:Client_AuraDisableReceived(sender, data);
			end
			if (command == "Version") then
				kNew:Server_VersionReceived(sender, data);
			end
			if (command == "VersionInvalid") and kNew:IsPlayerRaidLeader(sender) then
				kNew:Client_VersionInvalidReceived(sender, data);
			end
			if (command == "VersionRequest") and kNew:IsPlayerRaidLeader(sender) then
				kNew:Client_VersionRequestReceived(sender, data);
			end
			if (command == "WeakAuraConfigBroadcast") then
				kNew:WeakAuras_ConfigRecieved(sender, data);
			end
			-- Refresh frames
			kNew:Gui_HookFrameRefreshUpdate();
		end
	end
end
function kNew:IsPlayerRaidLeader(name)
	local i, n, rank
	for i = 1, kNew:GetPlayerCount() do
		n, rank = GetRaidRosterInfo(i)
		if rank == 2 then
			if n == name then
				return true
			else
				return false
			end
		end
	end
	return false;
end
function kNew:ParseAuctionItemLinkCommString(string)
	local itemLink, id, seedTime, duration, corpseGuid = strsplit("_", string);
	return itemLink, id, seedTime, duration, corpseGuid;
end
--[[ Executes and destroys any elapsed timers
elapsed int: milliseconds elapsed since last OnUpdate
]]
function kNew:OnUpdate(elapsed)
	local time, i = GetTime();
	for i = #self.timers, 1, -1 do 
		-- Check if repeater
		if self.timers[i].rep then
			self.timers[i].elapsed = (self.timers[i].elapsed or 0) + elapsed;
			if self.timers[i].elapsed >= (self.timers[i].interval or 0) then
				local cancelTimer = false;
				-- Check if func is string
				if type(self.timers[i].func) == 'function' then
					if self.timers[i].args then
						cancelTimer = self.timers[i].func(unpack(self.timers[i].args));
					else
						cancelTimer = self.timers[i].func();
					end
				else
					if self.timers[i].args then
						cancelTimer = self[self.timers[i].func](unpack(self.timers[i].args));
					else
						cancelTimer = self[self.timers[i].func]();
					end
				end
				self.timers[i].elapsed = 0;
				-- Check if cancel required
				if cancelTimer then
					kNew:Debug("REMOVE FUNC", 1)
					tremove(self.timers, i)
				end
			end
		else
			if self.timers[i].time then
				if self.timers[i].time <= time then
					-- One-time exec, remove
					if type(self.timers[i].func) == 'function' then
						if self.timers[i].args then
							self.timers[i].func(unpack(self.timers[i].args));
						else
							self.timers[i].func();
						end
					else
						if self.timers[i].args then
							self[self.timers[i].func](unpack(self.timers[i].args));
						else
							self[self.timers[i].func]();
						end
					end
					tremove(self.timers, i)
				end
			end
		end
	end
	--[[
	-- Destroy scheduled timers that have expired
	kNew.updates[2] = kNew.updates[2] + elapsed;
	if (kNew.updates[2] > 1) then
		kNew.updates[2] = 0;
		for i = #self.timers, 1, -1 do
			if self.timers[i].expires + 10 <= time() then
				self:CancelTimer(self.timers[i].timer, true)				
				table.remove(self.timers, i)
			end
		end
	end	
	]]	
end
function kNew:ZONE_CHANGED_NEW_AREA()
	-- Check if entering a valid raid zone
	if self.isInRaid == true and not self.isActiveRaid and kNew:Client_IsServer() then
		if kNew:Server_IsInValidRaidZone() then -- Check for valid zone
			StaticPopup_Show("kNewPopup_StartRaidTracking");
		end
	elseif self.isInRaid == true and self.isActiveRaid == true and self.enabled == true and kNew:Client_IsServer() and not kNew:Server_IsInValidRaidZone() and not UnitIsDeadOrGhost("player") then
		StaticPopup_Show("kNewPopup_StopRaidTracking");
	end
end