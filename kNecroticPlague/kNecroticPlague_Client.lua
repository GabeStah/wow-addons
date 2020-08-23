-- Author      : Gabe
-- Create Date : 11/3/2009 9:13:15 PM
function kNecroticPlague:Client_DataUpdateReceived(sender, data)
	local success, objData = kNecroticPlague:Deserialize(data);
	-- Check if valid data and enabled and valid zone
	if objData and kNecroticPlague.isEnabled and kNecroticPlague.isInValidZone and not kNecroticPlague.isWipe then
		kNecroticPlague.guids = objData; -- Update local
		kNecroticPlague:Debug("FUNC: Client_DataUpdateReceived, request sender = "..sender, 1);
	end
end
function kNecroticPlague:Client_WipeData()
	kNecroticPlague.isWipe = true;
	-- Destroy guid data
	wipe(kNecroticPlague.guids);
end
function kNecroticPlague:Client_DeleteGuid()
	if kNecroticPlague.guids[guid] then
		kNecroticPlague.guids[guid] = nil;
	end
end
function kNecroticPlague:Client_IsServer()
	-- Verify raid leader
	if GetNumRaidMembers() > 0 and IsRaidLeader() then -- Current Server
		kNecroticPlague.isServer = true;
		return true;
	elseif GetNumRaidMembers() == 0 and kNecroticPlague.isServer then -- Previous Server
		return true;
	end
	return false;
end
function kNecroticPlague:Client_RaidServerReceived(sender)
	kNecroticPlague.server = sender;
	kNecroticPlague.enabled = true;
	-- Run version check
	if not kNecroticPlague.hasRunVersionCheck and not kNecroticPlague:Client_IsServer() then
		kNecroticPlague:SendCommunication("Version", kNecroticPlague.version);
		kNecroticPlague:Debug("FUNC: Client_RaidServerReceived, server = "..kNecroticPlague.server..", enabled = true, running version check.", 1);
	end
end
function kNecroticPlague:Client_VersionInvalidReceived(sender, data)
	if not kNecroticPlague.hasRunVersionCheck then
		local success, name, minRequiredVersion, serverVersion = kNecroticPlague:Deserialize(data);
		kNecroticPlague:Debug("FUNC: Client_VersionInvalidReceived, name, minRequiredVersion, serverVersion " .. name.. minRequiredVersion..serverVersion, 1);
		if name ~= UnitName("player") then
			return;
		end
		StaticPopupDialogs["kNecroticPlaguePopup_VersionInvalid"] = {
			text = "|cFF"..kNecroticPlague:RGBToHex(0,255,0).."kNecroticPlague out of date.|r|n|nYour version: |cFF"..kNecroticPlague:RGBToHex(255,0,0)..kNecroticPlague.version.."|r|nRequired version: |cFF"..kNecroticPlague:RGBToHex(255,255,0)..minRequiredVersion.."|r|nServer version: |cFF"..kNecroticPlague:RGBToHex(0,255,0)..serverVersion.."|r|n|nPlease exit World of Warcraft and update your latest version from:|n|cFF"..kNecroticPlague:RGBToHex(190,0,110).."www.voximmortalis.com/files/addons/knecroticplague.zip|r",
			button1 = "On it!",
			OnAccept = function()
				return;
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		};
		StaticPopup_Show("kNecroticPlaguePopup_VersionInvalid");
		kNecroticPlague.hasRunVersionCheck = true;
	end
end
function kNecroticPlague:Client_VersionRequestReceived(sender, version)
	kNecroticPlague:SendCommunication("Version", kNecroticPlague.version);
end