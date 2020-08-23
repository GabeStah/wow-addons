-- Create Mixins
kInsane = LibStub("AceAddon-3.0"):NewAddon("kInsane", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
kInsane.currentZone = {subText = nil, isInInstance = false};
function kInsane:OnInitialize()
    -- Load Database
    kInsane.db = LibStub("AceDB-3.0"):New("kInsaneDB", kInsane.defaults)
    -- Inject Options Table and Slash Commands
	kInsane.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kInsane.db)
	kInsane.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kInsane", kInsane.options, {"kinsane", "ki"})
	kInsane.dialog = LibStub("AceConfigDialog-3.0")
	kInsane.AceGUI = LibStub("AceGUI-3.0")
	kInsane.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kInsane.ae = LibStub("AceEvent-2.0")
	kInsane.oo = LibStub("AceOO-2.0")
	kInsane.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kInsane:RegisterLibSharedMediaObjects();
	-- Init Events
	kInsane:InitializeEvents()
	-- Comm registry
	kInsane:RegisterComm("kInsane")
	-- Frames
	kInsane:Gui_InitializeFrames()
	kInsane:Gui_HookFrameRefreshUpdate();
	-- Update current zone
	kInsane:UpdateCurrentZone();
	mybar = LibStub("LibCandyBar-3.0"):New("Interface\\AddOns\\MyAddOn\\media\\statusbar.tga", 100, 16);
	mybar:SetDuration(60);
	mybar:SetLabel("My Label");
	mybar:Start();
end
-- PURPOSE: Initialize the events to monitor and fire
function kInsane:InitializeEvents()
	-- Add events here
	-- e.g.: kInsane:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	kInsane:RegisterEvent("ZONE_CHANGED");
	kInsane:RegisterEvent("ZONE_CHANGED_INDOORS");
	-- Zone change: Check for entering/leaving Dire Maul
	kInsane:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end
function kInsane:UpdateCurrentZone()
	if GetSubZoneText() ~= "" then
		kInsane.currentZone.subText = GetSubZoneText();
	elseif GetRealZoneText() ~= "" then
		kInsane.currentZone.subText = GetRealZoneText();
	end
	if IsInInstance() then
		kInsane.currentZone.isInInstance = true;
	else
		kInsane.currentZone.isInInstance = false;
	end
end
function kInsane:PlayerZoned()
	kInsane:UpdateCurrentZone();
end
function kInsane:ZONE_CHANGED()
	kInsane:Debug("Zone Changed", 3);
	kInsane:PlayerZoned();
end
function kInsane:ZONE_CHANGED_INDOORS()
	kInsane:Debug("ZONE_CHANGED_INDOORS", 3);
	kInsane:PlayerZoned();
end
function kInsane:ZONE_CHANGED_NEW_AREA()
	kInsane:Debug("Zone Changed New Area", 3);
	kInsane:PlayerZoned();
end
function kInsane:SendCommunication(command, data)
	kInsane:SendCommMessage("kInsane", kInsane:Serialize(command, data), "RAID")
end
function kInsane:OnCommReceived(prefix, serialObject, distribution, sender)
	kInsane:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kInsane:Deserialize(serialObject)
	if success then
		if prefix == "kInsane" and distribution == "RAID" then
			if command == "SomeCommand" then
				-- Add command
			end
			-- Refresh frames
			kInsane:Gui_HookFrameRefreshUpdate();
		end
	end
end
function kInsane:Debug(msg, threshold)
	if kInsane.db.profile.debug.enabled then
		if threshold == nil then
			kInsane:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kInsane.db.profile.debug.threshold then
			kInsane:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kInsane:RegisterLibSharedMediaObjects()
	-- Fonts
	kInsane.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kInsane\Fonts\Adventure.ttf]]);
	kInsane.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kInsane\Fonts\albas.ttf]]);
	kInsane.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kInsane\Fonts\CAS_ANTN.TTF]]);
	kInsane.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kInsane\Fonts\Cella.otf]]);
	kInsane.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kInsane\Fonts\chick.ttf]]);
	kInsane.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kInsane\Fonts\Corleone.ttf]]);
	kInsane.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kInsane\Fonts\CorleoneDue.ttf]]);
	kInsane.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kInsane\Fonts\Forte.ttf]]);
	kInsane.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kInsane\Fonts\freshbot.ttf]]);
	kInsane.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kInsane\Fonts\jokewood.ttf]]);
	kInsane.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kInsane\Fonts\Mobsters.ttf]]);
	kInsane.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kInsane\Fonts\weltu.ttf]]);
	kInsane.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kInsane\Fonts\WildRide.ttf]]);
	-- Sounds
	kInsane.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kInsane\Sounds\alarm.mp3]]);
	kInsane.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kInsane\Sounds\alert.mp3]]);
	kInsane.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kInsane\Sounds\info.mp3]]);
	kInsane.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kInsane\Sounds\long.mp3]]);
	kInsane.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kInsane\Sounds\shot.mp3]]);
	kInsane.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kInsane\Sounds\sonar.mp3]]);
	kInsane.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kInsane\Sounds\victory.mp3]]);
	kInsane.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kInsane\Sounds\victoryClassic.mp3]]);
	kInsane.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kInsane\Sounds\victoryLong.mp3]]);
	kInsane.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kInsane\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	kInsane.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kInsane\Sounds\wangryscotscomeonthen.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kInsane\Sounds\wangryscotscoward.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kInsane\Sounds\wangryscotsillgetyou.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kInsane\Sounds\wdrillsargeantfire.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kInsane\Sounds\wdrillsargeantstupid.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kInsane\Sounds\wdrillsargeantwatchthis.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kInsane\Sounds\wgrandpacoward.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kInsane\Sounds\wgrandpauhoh.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kInsane\Sounds\willgetyou.wav]]);
	kInsane.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kInsane\Sounds\wuhoh.wav]]);
	-- Drum
	kInsane.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kInsane\Sounds\snare1.mp3]]);
end
function kInsane:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kInsane:ColorizeSubstringInString(subject, substring, r, g, b)
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
	local sColor = kInsane:RGBToHex(r*255,g*255,b*255);
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
function kInsane:SplitString(subject, delimiter)
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