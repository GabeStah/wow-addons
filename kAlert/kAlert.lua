-- Create Mixins
kAlert = LibStub("AceAddon-3.0"):NewAddon("kAlert", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0", "AceBucket-3.0", "kLibDebug-1.0", "kLibUtility-1.0")

function kAlert:OnInitialize()
    -- Load Database
    kAlert.db = LibStub("AceDB-3.0"):New("kAlertDB", kAlert.defaults)
    -- Inject Options Table and Slash Commands
	kAlert.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kAlert.db)
	kAlert.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kAlert", kAlert.options, {"kalert"})
	kAlert.dialog = LibStub("AceConfigDialog-3.0")
	kAlert.AceGUI = LibStub("AceGUI-3.0")
	kAlert.ae = LibStub("AceEvent-2.0")
	kAlert.oo = LibStub("AceOO-2.0")
	kAlert.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kAlert:RegisterLibSharedMediaObjects();
	-- Callbacks
	kAlert:RegisterCallbacks();
	-- Init Events
	kAlert:InitializeEvents()
	-- Comm registry
	kAlert:RegisterComm("kAlert")
	-- Frames
	kAlert:Gui_InitializeFrames()
end
function kAlert:RegisterCallbacks()
	LibStub("LibLordFarlander-SpecialEvents-Aura-4.0").RegisterCallback(kAlert, "AuraTargetChanged");
	LibStub("LibAuraInfo-1.0").RegisterCallback(kAlert, "LibAuraInfo_AURA_REFRESH", "AuraRefresh");
	LibStub("LibAuraInfo-1.0").RegisterCallback(kAlert, "LibAuraInfo_AURA_APPLIED_DOSE", "AuraAppliedDose");
	LibStub("LibAuraInfo-1.0").RegisterCallback(kAlert, "LibAuraInfo_AURA_CLEAR", "AuraClear");
	LibStub("LibAuraInfo-1.0").RegisterCallback(kAlert, "LibAuraInfo_AURA_APPLIED", "AuraApplied");
end
-- PURPOSE: Initialize the events to monitor and fire
function kAlert:InitializeEvents()
	-- Add events here
	-- e.g.: kAlert:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end
function kAlert:AuraRefresh()
	kAlert:Debug("FUNC: AuraRefresh", 3);
end
function kAlert:AuraAppliedDose()
	kAlert:Debug("FUNC: AuraAppliedDose", 3);
end
function kAlert:AuraClear()
	kAlert:Debug("FUNC: AuraClear", 3);
end
function kAlert:AuraApplied()
	kAlert:Debug("FUNC: AuraApplied", 3);
end
function kAlert:AuraTargetChanged()
	kAlert:Debug("FUNC: AuraTargetChanged", 3);
end
function kAlert:SendCommunication(command, data)
	kAlert:SendCommMessage("kAlert", kAlert:Serialize(command, data), "RAID")
end
function kAlert:OnCommReceived(prefix, serialObject, distribution, sender)
	kAlert:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kAlert:Deserialize(serialObject)
	if success then
		if prefix == "kAlert" and distribution == "RAID" then
			if command == "SomeCommand" then
				-- Add command
			end
		end
	end
end
function kAlert:RegisterLibSharedMediaObjects()
	-- Fonts
	kAlert.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kAlert\Fonts\Adventure.ttf]]);
	kAlert.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kAlert\Fonts\albas.ttf]]);
	kAlert.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAlert\Fonts\CAS_ANTN.TTF]]);
	kAlert.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAlert\Fonts\Cella.otf]]);
	kAlert.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kAlert\Fonts\chick.ttf]]);
	kAlert.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kAlert\Fonts\Corleone.ttf]]);
	kAlert.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kAlert\Fonts\CorleoneDue.ttf]]);
	kAlert.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kAlert\Fonts\Forte.ttf]]);
	kAlert.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kAlert\Fonts\freshbot.ttf]]);
	kAlert.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kAlert\Fonts\jokewood.ttf]]);
	kAlert.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kAlert\Fonts\Mobsters.ttf]]);
	kAlert.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kAlert\Fonts\weltu.ttf]]);
	kAlert.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kAlert\Fonts\WildRide.ttf]]);
	-- Sounds
	kAlert.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kAlert\Sounds\alarm.mp3]]);
	kAlert.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kAlert\Sounds\alert.mp3]]);
	kAlert.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kAlert\Sounds\info.mp3]]);
	kAlert.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kAlert\Sounds\long.mp3]]);
	kAlert.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kAlert\Sounds\shot.mp3]]);
	kAlert.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kAlert\Sounds\sonar.mp3]]);
	kAlert.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kAlert\Sounds\victory.mp3]]);
	kAlert.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kAlert\Sounds\victoryClassic.mp3]]);
	kAlert.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kAlert\Sounds\victoryLong.mp3]]);
	kAlert.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kAlert\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	kAlert.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kAlert\Sounds\wangryscotscomeonthen.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kAlert\Sounds\wangryscotscoward.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kAlert\Sounds\wangryscotsillgetyou.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kAlert\Sounds\wdrillsargeantfire.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kAlert\Sounds\wdrillsargeantstupid.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kAlert\Sounds\wdrillsargeantwatchthis.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kAlert\Sounds\wgrandpacoward.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kAlert\Sounds\wgrandpauhoh.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kAlert\Sounds\willgetyou.wav]]);
	kAlert.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kAlert\Sounds\wuhoh.wav]]);
	-- Drum
	kAlert.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kAlert\Sounds\snare1.mp3]]);
end