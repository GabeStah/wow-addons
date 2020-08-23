-- Create Mixins
kHonor = LibStub("AceAddon-3.0"):NewAddon("kHonor", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0", "LibFuBarPlugin-3.0")
local intHonorStarting = 0;
local intHonorCurrent = 0;
local intHonorLastGame = 0;
local intGamesPlayed = 0;
local intTotalTicksPlayed = 0;
local timeStarted = 0;
local intTickGameStarted = 0;
kHonor.cvars = {};
function kHonor:OnInitialize()
    -- Load Database
    kHonor.db = LibStub("AceDB-3.0"):New("kHonorDB", kHonor.defaults)
    -- Inject Options Table and Slash Commands
	kHonor.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kHonor.db)
	kHonor.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kHonor", kHonor.options, {"khonor"})
	kHonor.dialog = LibStub("AceConfigDialog-3.0")
	kHonor.AceGUI = LibStub("AceGUI-3.0")
	kHonor.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kHonor.ae = LibStub("AceEvent-2.0")
	kHonor.oo = LibStub("AceOO-2.0")
	kHonor.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kHonor:RegisterLibSharedMediaObjects();
	-- Init Events
	kHonor:InitializeEvents()
	-- Comm registry
	kHonor:RegisterComm("kHonor")
	-- Set initial Honor
	intHonorCurrent = GetHonorCurrency();
	kHonor:ResetHourlyRateTimer();	
	kHonor:SetFubarOptions()
	kHonor:ScheduleRepeatingTimer("UpdateText", 1);
	kHonor.cvars["Sound_MasterVolume"] = tonumber(GetCVar("Sound_MasterVolume"));
	kHonor.cvars["Sound_MusicVolume"] = tonumber(GetCVar("Sound_MusicVolume"));
	kHonor.cvars["Sound_AmbienceVolume"] = tonumber(GetCVar("Sound_AmbienceVolume"));
	kHonor.cvars["Sound_SFXVolume"] = tonumber(GetCVar("Sound_SFXVolume"));
end
function kHonor:OnEnter()
	GameTooltip:AddLine("kHonor");
	GameTooltip:AddLine(" ");
end
-- PURPOSE: Initialize the events to monitor and fire
function kHonor:InitializeEvents()
	-- Add events here
	kHonor:RegisterEvent("CHAT_MSG_WHISPER");
    kHonor:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	kHonor:RegisterEvent("PLAYER_DEAD");
	kHonor:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	kHonor:RegisterEvent("BATTLEFIELDS_SHOW");
	kHonor:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL");
	kHonor:RegisterEvent("HONOR_CURRENCY_UPDATE");
	kHonor:RegisterEvent("UNIT_AURA")
	-- Hooks
    hooksecurefunc("JumpOrAscendStart",PlayerJumped);
end
function kHonor:SendAnnouncement(message, type)
	if (type == "battleground" and kHonor.db.profile.battleground.announce.enabled and kHonor:IsInBattleground()) then
		SendChatMessage("kHonor [Battleground]: " .. message, kHonor.db.profile.battleground.announce.channel, nil, kHonor.db.profile.battleground.announce.player);
	end
end
function kHonor:UnitHasDebuff(unitType, debuffName)
	for i=1,40 do
		local debuff = UnitDebuff(unitType, i);
		if debuff == debuffName then -- Matching name
			return true;
		end
	end
	return false;
end
function kHonor:CHAT_MSG_WHISPER()
	kHonor:BattlegroundWarningWhisper(arg1, arg2);
end
function kHonor:BATTLEFIELDS_SHOW()
	if (IsBattlefieldArena()) then return end;
	if (kHonor.db.profile.enabled and kHonor.db.profile.battleground.enabled) then
		if (CanJoinBattlefieldAsGroup()) then
		  -- Queue as a group for the first available battleground
		  JoinBattlefield(0, 1);
		else
		  -- Solo queue for the first available battleground
		  JoinBattlefield(0);
		end
		CloseBattlefield();
		DEFAULT_CHAT_FRAME:AddMessage("kHonor: You have joined the queue for 	"..GetBattlefieldInfo()..".", 1, 1, 0);
		kHonor:AnnounceHourlyRate();
	end
end
function kHonor:GetHourlyRate()
	return math.floor((GetHonorCurrency() - intHonorCurrent) / ((GetTime() - timeStarted) / 3600));
end
function kHonor:AnnounceHourlyRate()
	if (kHonor.db.profile.battleground.announce.hourlyRate.enabled) then
		DEFAULT_CHAT_FRAME:AddMessage("kHonor: Current hourly rate: " .. kHonor:GetHourlyRate() .. ".", 1, 1, 0);
	end
end
function kHonor:UPDATE_BATTLEFIELD_STATUS()
	if (kHonor:IsInBattleground() == nil) then
		for i=1, 1 do
			status, map, id = GetBattlefieldStatus(i);
			if (status == "confirm" and kHonor.db.profile.enabled and kHonor.db.profile.battleground.enabled and kHonor.db.profile.battleground.autojoin) then
				kHonor:Debug("UPDATE_BATTLEFIELD_STATUS, join 1");
				kHonor:SendAnnouncement("Now entering ["..map.."]!", "battleground");
				kHonor:ScheduleTimer("JoinBattleground", 5, i);
			end
		end	
	elseif (kHonor:IsInBattleground() and kHonor.db.profile.battleground.joinWhileInActiveBattle) then
		for i=1, 1 do
			status, map, id = GetBattlefieldStatus(i);
			if (status == "confirm" and kHonor.db.profile.enabled and kHonor.db.profile.battleground.enabled and kHonor.db.profile.battleground.autojoin) then
				kHonor:Debug("UPDATE_BATTLEFIELD_STATUS, join 1");
				kHonor:SendAnnouncement("Now entering ["..map.."]!", "battleground");
				kHonor:ScheduleTimer("JoinBattleground", 5, i);
			end
		end	
	end
end
function kHonor:JoinBattleground()
	-- Reduce volume
	kHonor:ReduceVolume();
	kHonor:Debug("JoinBattleground index: ".. i);
	AcceptBattlefieldPort(i, 1);
	--StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
	kHonor:ScheduleTimer("UpdateHonorStatsGameStart", 2);	
end
function kHonor:ReduceVolume()
	if kHonor.db.profile.battleground.lowVolumeMode.enabled then
		for k,v in pairs(kHonor.cvars) do
			SetCVar(k, 0);
		end
	end
end
function kHonor:IncreaseVolume()
	if kHonor.db.profile.battleground.lowVolumeMode.enabled then
		for k,v in pairs(kHonor.cvars) do
			SetCVar(k, 1);
		end
	end
end
function kHonor:NormalizeVolume()
	if kHonor.db.profile.battleground.lowVolumeMode.enabled then
		for k,v in pairs(kHonor.cvars) do
			SetCVar(k, v);
		end
	end
end
function kHonor:UNIT_AURA()
	for k, v in ipairs(kHonor.db.profile.battleground.debuffs) do
		if kHonor:UnitHasDebuff("player", v) then
			if (kHonor.db.profile.battleground.idle == nil) then
				kHonor.db.profile.battleground.idle = true;
				kHonor:BattlegroundWarningIdle();
			end
		else
			kHonor.db.profile.battleground.idle = nil;
		end
	end
end
function PlayerJumped()
	-- Check if inside Battleground
	if (kHonor.db.profile.enabled and kHonor.db.profile.battleground.enabled and kHonor.db.profile.battleground.warnings.afk and kHonor:IsInBattleground()) then
		if kHonor.timerHandles.BattlegroundWarningAfk then
			kHonor:CancelTimer(kHonor.timerHandles.BattlegroundWarningAfk, true);
		end
		kHonor.timerHandles.BattlegroundWarningAfk = kHonor:ScheduleTimer("BattlegroundWarningAfk", (300 - kHonor.db.profile.battleground.warnings.afkTimer));
	end
end
function kHonor:HONOR_CURRENCY_UPDATE()
	kHonor:UpdateText();
end
function kHonor:UPDATE_BATTLEFIELD_SCORE()
	kHonor:Debug("UPDATE_BATTLEFIELD_SCORE event fire.", 3);
	if (kHonor.db.profile.enabled and kHonor:IsInBattleground() and kHonor.db.profile.battleground.autoleave) then
		kHonor:Debug("UPDATE_BATTLEFIELD_SCORE, subs: kHonor:IsEnabled() and kHonor:IsInBattleground() and kHonor:IsBattlegroundAutoleave().", 1, 1, 0);
		if (GetBattlefieldInstanceExpiration() ~= 0) then
			kHonor:Debug("UPDATE_BATTLEFIELD_SCORE, subs: kHonor:IsEnabled() and kHonor:IsInBattleground() and kHonor:IsBattlegroundAutoleave() and GetBattlefieldInstanceExpiration ~= 0.", 1, 1, 0);
			if kHonor.timerHandles.LeaveBattleground then
				kHonor:CancelTimer(kHonor.timerHandles.LeaveBattleground, true);
			end
			kHonor.timerHandles.LeaveBattleground = kHonor:ScheduleTimer("LeaveBattleground", 3);
		end
	end
end
function kHonor:BattlegroundWarningAfk()
	if (kHonor.db.profile.enabled and kHonor:IsInBattleground() and kHonor.db.profile.battleground.enabled and kHonor.db.profile.battleground.warnings.afk) then
		kHonor:SendAnnouncement("Afk Warning - 10 seconds to react! [jump]", "battleground");
		kHonor:ScheduleTimer("FlashFrame", 1);
		kHonor:ScheduleTimer("FlashFrame", 3);
		kHonor:ScheduleTimer("FlashFrame", 5);
		kHonor:ScheduleTimer("FlashFrame", 7);
		kHonor:IncreaseVolume();
		PlaySoundFile("Interface\\AddOns\\kHonor\\Sounds\\victoryLong.mp3");
		kHonor:ScheduleTimer(function() kHonor:ReduceVolume(); end, 5);
	end
end
function kHonor:BattlegroundWarningIdle()
	if (kHonor.db.profile.enabled and kHonor:IsInBattleground() and kHonor.db.profile.battleground.enabled and kHonor.db.profile.battleground.warnings.idle) then
		kHonor:SendAnnouncement("Idle Warning - No honor earnings!", "battleground");
		kHonor:ScheduleTimer("FlashFrame", 1);
		kHonor:ScheduleTimer("FlashFrame", 3);
		kHonor:ScheduleTimer("FlashFrame", 5);
		kHonor:ScheduleTimer("FlashFrame", 7);
		kHonor:IncreaseVolume();
		PlaySoundFile("Interface\\AddOns\\kHonor\\Sounds\\victoryLong.mp3");
		kHonor:ScheduleTimer(function() kHonor:ReduceVolume(); end, 5);
	end
end
function kHonor:BattlegroundWarningWhisper(message, fromPlayer)
	if (kHonor.db.profile.enabled and kHonor:IsInBattleground() and kHonor.db.profile.battleground.enabled and kHonor.db.profile.battleground.warnings.whisper) then
		kHonor:SendAnnouncement("Tell from " .. fromPlayer .. ": " .. message, "battleground");
		kHonor:ScheduleTimer("FlashFrame", 1);
		kHonor:ScheduleTimer("FlashFrame", 3);
		kHonor:ScheduleTimer("FlashFrame", 5);
		kHonor:ScheduleTimer("FlashFrame", 7);
		kHonor:IncreaseVolume();
		PlaySoundFile("Interface\\AddOns\\kHonor\\Sounds\\welcome.wav");
		kHonor:ScheduleTimer(function() kHonor:ReduceVolume(); end, 5);
	end
end
function kHonor:LeaveBattleground()
	if (kHonor.db.profile.enabled and kHonor.db.profile.battleground.enabled) then
		kHonor:SendAnnouncement("Leaving battleground.", "battleground");
		kHonor:ScheduleTimer("FlashFrame", 1);
		kHonor:ScheduleTimer("FlashFrame", 3);
		kHonor:ScheduleTimer("FlashFrame", 5);
		kHonor:ScheduleTimer("FlashFrame", 7);
		PlaySoundFile("Interface\\AddOns\\kHonor\\Sounds\\welcome.wav");
		kHonor:Debug("LeaveBattleground().", 3);
		LeaveBattlefield();
		kHonor:CancelAllTimers();
		kHonor:ScheduleTimer("UpdateHonorStatsGameEnd", 2);
		kHonor:NormalizeVolume();
	end
end
function kHonor:UpdateHonorStatsGameStart()
	-- Update Honor Stats
	intHonorLastGame = 0;
	intHonorCurrent = GetHonorCurrency();
	intTickGameStarted = GetTime();
end
function kHonor:UpdateHonorStatsGameEnd()
	-- Update Honor Stats
	intGamesPlayed = intGamesPlayed + 1; -- Update total games played
	intHonorLastGame = GetHonorCurrency() - intHonorCurrent; -- Calc the honor from previous game
	intHonorCurrent = GetHonorCurrency();
	intTotalTicksPlayed = intTotalTicksPlayed + (GetTime() - intTickGameStarted); -- Add total game ticks to total ticks played
	-- Display Honor Stats
	kHonor:DisplayHonorStats();
end
function kHonor:DisplayHonorStats()
	intHonorGained = intHonorCurrent - intHonorStarting;
	strOutput = "kHonor: STATS - Last Game [" .. intHonorLastGame .. "], Avg Honor Per Game [" .. (intHonorGained / intGamesPlayed) .. "], Avg Honor Per Hour [" .. (intHonorGained / ((intTotalTicksPlayed / 60) / 60)) .. "]."
	DEFAULT_CHAT_FRAME:AddMessage(strOutput, 1, 1, 0);
end
-- Match starts
function kHonor:CHAT_MSG_BG_SYSTEM_NEUTRAL()
	if (arg1 == "The battle for Alterac Valley has begun!") or (arg1 == "Let the battle for Warsong Gulch begin.") or (arg1 == "Let the battle for the Strand of the Ancients begin.") then
		if (kHonor.db.profile.enabled and kHonor.db.profile.battleground.announce.enabled and kHonor:IsInBattleground()) then
			kHonor:SendAnnouncement("The Battleground has begun.", "battleground");
		end
	end
end
-- PURPOSE: Autorelease when player dies in battleground
function kHonor:PLAYER_DEAD()
	if (kHonor.db.profile.enabled and kHonor.db.profile.battleground.autorepop and kHonor:IsInBattleground()) then
		RepopMe();
	end
end
function kHonor:FlashFrame()
	LowHealthFrame:Hide();
	UIFrameFlash(LowHealthFrame, 0.25, 0.75, 2.2, false, 0, 0.1);
end
function kHonor:IsInBattleground()
	if (GetRealZoneText() == "Alterac Valley") or (GetRealZoneText() == "Warsong Gulch") or (GetRealZoneText() == "Arathi Basin") or (GetRealZoneText() == "Eye of the Storm") or (GetRealZoneText() == "Strand of the Ancients") or (GetRealZoneText() == "Isle of Conquest") then
		return true;
	end
	return nil;
end

function kHonor:SendCommunication(command, data)
	kHonor:SendCommMessage("kHonor", kHonor:Serialize(command, data), "RAID")
end
function kHonor:OnCommReceived(prefix, serialObject, distribution, sender)
	kHonor:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kHonor:Deserialize(serialObject)
	if success then
		if prefix == "kHonor" and distribution == "RAID" then
			if command == "SomeCommand" then
				-- Add command
			end
		end
	end
end
function kHonor:Debug(msg, threshold)
	if kHonor.db.profile.debug.enabled then
		if threshold == nil then
			kHonor:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kHonor.db.profile.debug.threshold then
			kHonor:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kHonor:RegisterLibSharedMediaObjects()
	-- Fonts
	kHonor.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kHonor\Fonts\Adventure.ttf]]);
	kHonor.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kHonor\Fonts\albas.ttf]]);
	kHonor.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kHonor\Fonts\CAS_ANTN.TTF]]);
	kHonor.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kHonor\Fonts\Cella.otf]]);
	kHonor.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kHonor\Fonts\chick.ttf]]);
	kHonor.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kHonor\Fonts\Corleone.ttf]]);
	kHonor.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kHonor\Fonts\CorleoneDue.ttf]]);
	kHonor.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kHonor\Fonts\Forte.ttf]]);
	kHonor.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kHonor\Fonts\freshbot.ttf]]);
	kHonor.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kHonor\Fonts\jokewood.ttf]]);
	kHonor.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kHonor\Fonts\Mobsters.ttf]]);
	kHonor.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kHonor\Fonts\weltu.ttf]]);
	kHonor.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kHonor\Fonts\WildRide.ttf]]);
	-- Sounds
	kHonor.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kHonor\Sounds\alarm.mp3]]);
	kHonor.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kHonor\Sounds\alert.mp3]]);
	kHonor.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kHonor\Sounds\info.mp3]]);
	kHonor.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kHonor\Sounds\long.mp3]]);
	kHonor.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kHonor\Sounds\shot.mp3]]);
	kHonor.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kHonor\Sounds\sonar.mp3]]);
	kHonor.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kHonor\Sounds\victory.mp3]]);
	kHonor.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kHonor\Sounds\victoryClassic.mp3]]);
	kHonor.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kHonor\Sounds\victoryLong.mp3]]);
	kHonor.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kHonor\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	kHonor.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kHonor\Sounds\wangryscotscomeonthen.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kHonor\Sounds\wangryscotscoward.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kHonor\Sounds\wangryscotsillgetyou.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kHonor\Sounds\wdrillsargeantfire.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kHonor\Sounds\wdrillsargeantstupid.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kHonor\Sounds\wdrillsargeantwatchthis.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kHonor\Sounds\wgrandpacoward.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kHonor\Sounds\wgrandpauhoh.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kHonor\Sounds\willgetyou.wav]]);
	kHonor.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kHonor\Sounds\wuhoh.wav]]);
	-- Drum
	kHonor.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kHonor\Sounds\snare1.mp3]]);
end

function kHonor:ResetHourlyRateTimer()
	timeStarted = GetTime();
	intHonorCurrent = GetHonorCurrency();
end

function kHonor:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kHonor:ColorizeSubstringInString(subject, substring, r, g, b)
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
	local sColor = kHonor:RGBToHex(r*255,g*255,b*255);
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
function kHonor:SplitString(subject, delimiter)
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

--FuBar
function kHonor:SetFubarOptions()
	kHonor:SetFuBarOption("tooltipType", "Tablet-2.0");
	kHonor:SetFuBarOption("configType", "AceConfigDialog-3.0");
	kHonor:SetFuBarOption("iconPath", "Interface\\Icons\\Spell_Shadow_SummonVoidWalker");
	kHonor:SetFuBarOption("defaultPosition", "CENTER");
end
function kHonor:UpdateText(text)
	if (text == nil) then
		kHonor:SetFuBarText(kHonor:GetHourlyRate() .. " / hr");
	else
		kHonor:SetFuBarText(text);
	end
end
function kHonor:OnClick(button)
	DEFAULT_CHAT_FRAME:AddMessage("kHonor: Session timer reset.", 1, 1, 0);
	kHonor:ResetHourlyRateTimer();
	kHonor:SetFuBarText("0 / hr");
end