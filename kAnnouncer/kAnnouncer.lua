-- Create Mixins
kAnnouncer = LibStub("AceAddon-3.0"):NewAddon("kAnnouncer", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
self = kAnnouncer;
function kAnnouncer:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kAnnouncerDB", self.defaults)
    -- Inject Options Table and Slash Commands
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kAnnouncer", self.options, {"kannouncer", "kan"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.aceGui = LibStub("AceGUI-3.0")
	self.ae = LibStub("AceEvent-2.0")
	self.cb = LibStub("CallbackHandler-1.0")
	self.effects = LibStub("LibEffects-1.0")
	self.oo = LibStub("AceOO-2.0")
	self.roster = LibStub("Roster-2.1")
	self.sharedMedia = LibStub("LibSharedMedia-3.0")
	self.timer = LibStub("LibSimpleTimer-1.0")
	-- Shared Media Lib
	self:RegisterLibSharedMediaObjects();
	-- Init Events
	self:InitializeEvents()
	-- Comm registry
	self:RegisterComm("kAnnouncer")
end
function kAnnouncer:InitializeDefaults()
	self.enabled = false;
	self.active = false;
end
function kAnnouncer:InitializeEvents()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("RAID_ROSTER_UPDATE");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end
function kAnnouncer:RegisterLibSharedMediaObjects()
	-- Fonts
	self.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kAnnouncer\Fonts\Adventure.ttf]]);
	self.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kAnnouncer\Fonts\albas.ttf]]);
	self.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAnnouncer\Fonts\CAS_ANTN.TTF]]);
	self.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAnnouncer\Fonts\Cella.otf]]);
	self.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kAnnouncer\Fonts\chick.ttf]]);
	self.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kAnnouncer\Fonts\Corleone.ttf]]);
	self.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kAnnouncer\Fonts\CorleoneDue.ttf]]);
	self.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kAnnouncer\Fonts\Forte.ttf]]);
	self.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kAnnouncer\Fonts\freshbot.ttf]]);
	self.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kAnnouncer\Fonts\jokewood.ttf]]);
	self.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kAnnouncer\Fonts\Mobsters.ttf]]);
	self.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kAnnouncer\Fonts\weltu.ttf]]);
	self.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kAnnouncer\Fonts\WildRide.ttf]]);
	-- Sounds
	self.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kAnnouncer\Sounds\alarm.mp3]]);
	self.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kAnnouncer\Sounds\alert.mp3]]);
	self.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kAnnouncer\Sounds\info.mp3]]);
	self.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kAnnouncer\Sounds\long.mp3]]);
	self.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kAnnouncer\Sounds\shot.mp3]]);
	self.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kAnnouncer\Sounds\sonar.mp3]]);
	self.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kAnnouncer\Sounds\victory.mp3]]);
	self.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kAnnouncer\Sounds\victoryClassic.mp3]]);
	self.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kAnnouncer\Sounds\victoryLong.mp3]]);
	self.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kAnnouncer\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	self.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kAnnouncer\Sounds\wangryscotscomeonthen.wav]]);
	self.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kAnnouncer\Sounds\wangryscotscoward.wav]]);
	self.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kAnnouncer\Sounds\wangryscotsillgetyou.wav]]);
	self.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kAnnouncer\Sounds\wdrillsargeantfire.wav]]);
	self.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kAnnouncer\Sounds\wdrillsargeantstupid.wav]]);
	self.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kAnnouncer\Sounds\wdrillsargeantwatchthis.wav]]);
	self.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kAnnouncer\Sounds\wgrandpacoward.wav]]);
	self.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kAnnouncer\Sounds\wgrandpauhoh.wav]]);
	self.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kAnnouncer\Sounds\willgetyou.wav]]);
	self.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kAnnouncer\Sounds\wuhoh.wav]]);
end

function kAnnouncer:OnEnable()

end
function kAnnouncer:OnDisable()
    -- Called when the addon is disabled
end
function kAnnouncer:COMBAT_LOG_EVENT_UNFILTERED(blah, ...)
	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
	--local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
	-- Note, for this example, you could just use 'local type = select(2, ...)'.  The others are included so that it's clear what's available.
	--self:Debug("type ["..type.."], sourceGUID ["..sourceGUID.."], destGUID ["..destGUID.."], sourceName ["..sourceName.."], destName ["..destName.."]!", 3);
	--[[
	if (type=="SPELL_CAST_START" or type=="SPELL_HEAL") then
		local spellId, spellName, spellSchool = select(9, ...)
		if (spellName=="Cyclone" or spellName=="Entangling Roots") then -- ==true for clarity only.  Not needed.
			if destName then
				self:Debug("type ["..type.."], spell ["..spellName.."], sourceGUID ["..sourceGUID.."], destGUID ["..destGUID.."], sourceName ["..sourceName.."], destName ["..destName.."], destFlags ["..destFlags.."]!", 3);
			else
				self:Debug("type ["..type.."], spell ["..spellName.."], sourceGUID ["..sourceGUID.."], destGUID ["..destGUID.."], sourceName ["..sourceName.."], destFlags ["..destFlags.."]!", 3);
			end
		else
			if destName then
				self:Debug("type ["..type.."], spell ["..spellName.."], sourceGUID ["..sourceGUID.."], destGUID ["..destGUID.."], sourceName ["..sourceName.."], destName ["..destName.."], destFlags ["..destFlags.."]!", 3);
			else
				self:Debug("type ["..type.."], spell ["..spellName.."], sourceGUID ["..sourceGUID.."], destGUID ["..destGUID.."], sourceName ["..sourceName.."], destFlags ["..destFlags.."]!", 3);
			end
		end
	end
	]]
end
function kAnnouncer:RAID_ROSTER_UPDATE()
	
end
function kAnnouncer:ZONE_CHANGED_NEW_AREA()

end
function kAnnouncer:SendCommunication(command, data)
	self:SendCommMessage("kAnnouncer", self:Serialize(command, data), "RAID")
end
function kAnnouncer:OnCommReceived(prefix, serialObject, distribution, sender)
	self:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = self:Deserialize(serialObject)
	if success then
		if prefix == "kAnnouncer" and distribution == "RAID" then
			if (command == "Auction" and self:IsPlayerRaidLeader(sender)) then
				
			end
		end
	end
end
function kAnnouncer:Debug(msg, threshold)
	if self.db.profile.debug.enabled then
		if threshold == nil then
			self:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= self.db.profile.debug.threshold then
			self:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kAnnouncer:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end