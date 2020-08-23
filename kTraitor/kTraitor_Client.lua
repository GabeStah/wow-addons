-- Author      : Gabe
-- Create Date : 11/3/2009 9:13:15 PM
function kTraitor:Client_DataUpdateReceived(sender, data)
	local success, objData = kTraitor:Deserialize(data);
	-- Check if valid data and enabled and valid zone
	if objData and kTraitor.isEnabled and kTraitor.isInValidZone and not kTraitor.isWipe then
		kTraitor.guids = objData; -- Update local
		kTraitor:Debug("FUNC: Client_DataUpdateReceived, request sender = "..sender, 1);
	end
end
function kTraitor:Client_WipeData()
	kTraitor.isWipe = true;
	-- Destroy guid data
	wipe(kTraitor.guids);
end
function kTraitor:Client_DeleteGuid()
	if kTraitor.guids[guid] then
		kTraitor.guids[guid] = nil;
	end
end
function kTraitor:Client_IsServer()
	-- Verify raid leader
	if GetNumRaidMembers() > 0 and IsRaidLeader() then -- Current Server
		kTraitor.isServer = true;
		return true;
	elseif GetNumRaidMembers() == 0 and kTraitor.isServer then -- Previous Server
		return true;
	end
	return false;
end
function kTraitor:Client_RaidServerReceived(sender)
	kTraitor.server = sender;
	kTraitor.enabled = true;
	-- Run version check
	if not kTraitor.hasRunVersionCheck and not kTraitor:Client_IsServer() then
		kTraitor:SendCommunication("Version", kTraitor.version);
		kTraitor:Debug("FUNC: Client_RaidServerReceived, server = "..kTraitor.server..", enabled = true, running version check.", 1);
	end
end
function kTraitor:Client_VersionInvalidReceived(sender, data)
	if not kTraitor.hasRunVersionCheck then
		local success, name, minRequiredVersion, serverVersion = kTraitor:Deserialize(data);
		kTraitor:Debug("FUNC: Client_VersionInvalidReceived, name, minRequiredVersion, serverVersion " .. name.. minRequiredVersion..serverVersion, 1);
		if name ~= UnitName("player") then
			return;
		end
		StaticPopupDialogs["kTraitorPopup_VersionInvalid"] = {
			text = "|cFF"..kTraitor:RGBToHex(0,255,0).."kTraitor out of date.|r|n|nYour version: |cFF"..kTraitor:RGBToHex(255,0,0)..kTraitor.version.."|r|nRequired version: |cFF"..kTraitor:RGBToHex(255,255,0)..minRequiredVersion.."|r|nServer version: |cFF"..kTraitor:RGBToHex(0,255,0)..serverVersion.."|r|n|nPlease exit World of Warcraft and update your latest version from:|n|cFF"..kTraitor:RGBToHex(190,0,110).."www.voximmortalis.com/files/addons/ktraitor.zip|r",
			button1 = "On it!",
			OnAccept = function()
				return;
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		};
		StaticPopup_Show("kTraitorPopup_VersionInvalid");
		kTraitor.hasRunVersionCheck = true;
	end
end
function kTraitor:Client_VersionRequestReceived(sender, version)
	kTraitor:SendCommunication("Version", kTraitor.version);
end