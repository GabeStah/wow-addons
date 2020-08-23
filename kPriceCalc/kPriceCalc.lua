-- Create Mixins
kPriceCalc = LibStub("AceAddon-3.0"):NewAddon("kPriceCalc", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")

function kPriceCalc:OnInitialize()
    -- Load Database
    kPriceCalc.db = LibStub("AceDB-3.0"):New("kPriceCalcDB", kPriceCalc.defaults)
    -- Inject Options Table and Slash Commands
	kPriceCalc.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kPriceCalc.db)
	kPriceCalc.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kPriceCalc", kPriceCalc.options, {"kpricecalc", "kpc"})
	kPriceCalc.dialog = LibStub("AceConfigDialog-3.0")
	kPriceCalc.AceGUI = LibStub("AceGUI-3.0")
	kPriceCalc.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kPriceCalc.ae = LibStub("AceEvent-2.0")
	kPriceCalc.oo = LibStub("AceOO-2.0")
	kPriceCalc.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kPriceCalc:RegisterLibSharedMediaObjects();
	-- Init Events
	kPriceCalc:InitializeEvents()
	-- Comm registry
	kPriceCalc:RegisterComm("kPriceCalc")
end
-- PURPOSE: Initialize the events to monitor and fire
function kPriceCalc:InitializeEvents()
	-- Add events here
	-- e.g.: kPriceCalc:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end
function kPriceCalc:SendCommunication(command, data)
	kPriceCalc:SendCommMessage("kPriceCalc", kPriceCalc:Serialize(command, data), "RAID")
end
function kPriceCalc:OnCommReceived(prefix, serialObject, distribution, sender)
	kPriceCalc:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kPriceCalc:Deserialize(serialObject)
	if success then
		if prefix == "kPriceCalc" and distribution == "RAID" then
			if command == "SomeCommand" then
				-- Add command
			end
			-- Refresh frames
			kPriceCalc:Gui_HookFrameRefreshUpdate();
		end
	end
end
function kPriceCalc:Debug(msg, threshold)
	if kPriceCalc.db.profile.debug.enabled then
		if threshold == nil then
			kPriceCalc:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kPriceCalc.db.profile.debug.threshold then
			kPriceCalc:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kPriceCalc:RegisterLibSharedMediaObjects()
	-- Fonts
	kPriceCalc.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kPriceCalc\Fonts\Adventure.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kPriceCalc\Fonts\albas.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kPriceCalc\Fonts\CAS_ANTN.TTF]]);
	kPriceCalc.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kPriceCalc\Fonts\Cella.otf]]);
	kPriceCalc.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kPriceCalc\Fonts\chick.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kPriceCalc\Fonts\Corleone.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kPriceCalc\Fonts\CorleoneDue.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kPriceCalc\Fonts\Forte.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kPriceCalc\Fonts\freshbot.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kPriceCalc\Fonts\jokewood.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kPriceCalc\Fonts\Mobsters.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kPriceCalc\Fonts\weltu.ttf]]);
	kPriceCalc.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kPriceCalc\Fonts\WildRide.ttf]]);
	-- Sounds
	kPriceCalc.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kPriceCalc\Sounds\alarm.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kPriceCalc\Sounds\alert.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kPriceCalc\Sounds\info.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kPriceCalc\Sounds\long.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kPriceCalc\Sounds\shot.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kPriceCalc\Sounds\sonar.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kPriceCalc\Sounds\victory.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kPriceCalc\Sounds\victoryClassic.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kPriceCalc\Sounds\victoryLong.mp3]]);
	kPriceCalc.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kPriceCalc\Sounds\wilhelm.mp3]]);
	-- Sounds, Worms
	kPriceCalc.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kPriceCalc\Sounds\wangryscotscomeonthen.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kPriceCalc\Sounds\wangryscotscoward.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kPriceCalc\Sounds\wangryscotsillgetyou.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kPriceCalc\Sounds\wdrillsargeantfire.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kPriceCalc\Sounds\wdrillsargeantstupid.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kPriceCalc\Sounds\wdrillsargeantwatchthis.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kPriceCalc\Sounds\wgrandpacoward.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kPriceCalc\Sounds\wgrandpauhoh.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kPriceCalc\Sounds\willgetyou.wav]]);
	kPriceCalc.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kPriceCalc\Sounds\wuhoh.wav]]);
	-- Drum
	kPriceCalc.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kPriceCalc\Sounds\snare1.mp3]]);
end
function kPriceCalc:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kPriceCalc:ColorizeSubstringInString(subject, substring, r, g, b)
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
	local sColor = kPriceCalc:RGBToHex(r*255,g*255,b*255);
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
function kPriceCalc:SplitString(subject, delimiter)
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
function kPriceCalc:GetItemById(id)
	if kPriceCalc.db.profile.items and id then
		for i,v in pairs(kPriceCalc.db.profile.items) do
			if id == v.id then
				return v;
			end
		end
	end
	return nil;
end
function kPriceCalc:CalculateComboPrices(getByCombinePrice)
	local numberPerCombine = 1;
	for i,v in pairs(kPriceCalc.db.profile.items) do
		-- Set number of items created per combine
		numberPerCombine = v.numberPerCombine;
		local matCost = 0;
		for iCombo,vCombo in pairs(v.combos) do
			-- Loop mats
			for iMat,vMat in pairs(vCombo.mats) do
				matCost = matCost + (vMat.costPer * vMat.numberPerCombine);
			end
			-- return value
			if getByCombinePrice then
				return matCost;
			else
				return matCost / numberPerCombine;
			end
		end
	end
end
function kPriceCalc:CalculateComboPrice(itemId, comboId, getByCombinePrice)
	local numberPerCombine = 1;
	for i,v in pairs(kPriceCalc.db.profile.items) do
		if v.id == itemId then
			-- Set number of items created per combine
			numberPerCombine = v.numberPerCombine;
			local matCost = 0;
			for iCombo,vCombo in pairs(v.combos) do
				if vCombo.id == comboId then
					-- Loop mats
					for iMat,vMat in pairs(vCombo.mats) do
						matCost = matCost + (vMat.costPer * vMat.numberPerCombine);
					end
					-- return value
					if getByCombinePrice then
						return matCost;
					else
						return matCost / numberPerCombine;
					end
				end
			end
		end
	end
end
function kPriceCalc:GetCurrencyStringFromPrice(price)
	
end