-- Create Mixins
kPester = LibStub("AceAddon-3.0"):NewAddon("kPester", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
function kPester:OnInitialize()
    -- Load Database
    kPester.db = LibStub("AceDB-3.0"):New("kPesterDB", kPester.defaults)
    -- Inject Options Table and Slash Commands
	kPester.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kPester.db)
	kPester.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kPester", kPester.options, {"kpester", "kp"})
	kPester.dialog = LibStub("AceConfigDialog-3.0")
	kPester.aceGui = LibStub("AceGUI-3.0")
	kPester.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kPester.ae = LibStub("AceEvent-2.0")
	kPester.effects = LibStub("LibEffects-1.0")
	kPester.oo = LibStub("AceOO-2.0")
	kPester.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kPester:RegisterLibSharedMediaObjects();
	-- Init Events
	kPester:InitializeEvents()
	-- Comm registry
	kPester:RegisterComm("kPester")
end
function kPester:InitializeEvents()
	kPester.enabled = false;
	kPester:RegisterEvent("UNIT_SPELLCAST_SENT");
	kPester:RegisterEvent("RAID_ROSTER_UPDATE");
	kPester:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end
function kPester:RegisterLibSharedMediaObjects()
	-- Fonts
	kPester.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kPester\Fonts\Adventure.ttf]]);
	kPester.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kPester\Fonts\albas.ttf]]);
	kPester.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kPester\Fonts\CAS_ANTN.TTF]]);
	kPester.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kPester\Fonts\Cella.otf]]);
	kPester.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kPester\Fonts\chick.ttf]]);
	kPester.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kPester\Fonts\Corleone.ttf]]);
	kPester.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kPester\Fonts\CorleoneDue.ttf]]);
	kPester.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kPester\Fonts\Forte.ttf]]);
	kPester.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kPester\Fonts\freshbot.ttf]]);
	kPester.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kPester\Fonts\jokewood.ttf]]);
	kPester.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kPester\Fonts\Mobsters.ttf]]);
	kPester.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kPester\Fonts\weltu.ttf]]);
	kPester.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kPester\Fonts\WildRide.ttf]]);
	-- Sounds
	kPester.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kPester\Sounds\alarm.mp3]]);
	kPester.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kPester\Sounds\alert.mp3]]);
	kPester.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kPester\Sounds\info.mp3]]);
	kPester.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kPester\Sounds\long.mp3]]);
	kPester.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kPester\Sounds\shot.mp3]]);
	kPester.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kPester\Sounds\sonar.mp3]]);
	kPester.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kPester\Sounds\victory.mp3]]);
	kPester.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kPester\Sounds\victoryClassic.mp3]]);
	kPester.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kPester\Sounds\victoryLong.mp3]]);
	kPester.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kPester\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	kPester.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kPester\Sounds\wangryscotscomeonthen.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kPester\Sounds\wangryscotscoward.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kPester\Sounds\wangryscotsillgetyou.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kPester\Sounds\wdrillsargeantfire.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kPester\Sounds\wdrillsargeantstupid.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kPester\Sounds\wdrillsargeantwatchthis.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kPester\Sounds\wgrandpacoward.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kPester\Sounds\wgrandpauhoh.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kPester\Sounds\willgetyou.wav]]);
	kPester.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kPester\Sounds\wuhoh.wav]]);
	-- Drum
	kPester.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kPester\Sounds\snare1.mp3]]);
end

function kPester:OnEnable()

end
function kPester:OnDisable()
    -- Called when the addon is disabled
end
function kPester:RAID_ROSTER_UPDATE()

end
function kPester:UNIT_SPELLCAST_SENT(blah, unit, spell, rank, target)

end
function kPester:SendCommunication(command, data)
	kPester:SendCommMessage("kPester", kPester:Serialize(command, data), "RAID")
end
function kPester:OnCommReceived(prefix, serialObject, distribution, sender)
	kPester:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kPester:Deserialize(serialObject)
	if success then
		if prefix == "kPester" and distribution == "RAID" then
			if (command == "Bid") then
				
			end
		end
	end
end
function kPester:Debug(msg, threshold)
	if kPester.db.profile.debug.enabled then
		if threshold == nil then
			kPester:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kPester.db.profile.debug.threshold then
			kPester:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kPester:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kPester:ZONE_CHANGED_NEW_AREA()

end