-- Author      : Gabe
-- Create Date : 11/3/2009 9:13:47 PM
function kNecroticPlague:Server_DataPushReceived(sender, data)
	local success, type, guid, scarab = kNecroticPlague:Deserialize(data);
	if type == "scarab" then
		kNecroticPlague.guids[guid] = scarab; -- Update local
		-- Send comm to update
		kNecroticPlague:SendCommunication("DataUpdate", kNecroticPlague:Serialize(kNecroticPlague.guids));
		kNecroticPlague:Debug("FUNC: Server_DataPushReceived, request sender = "..sender..", guid = "..guid, 1);
	end
end
function kNecroticPlague:Server_ScarabDied(sender, guid)
	if not kNecroticPlague:Client_IsServer() then
		return;
	end
	if kNecroticPlague.guids[guid] then -- Exists, send comm to delete
		kNecroticPlague.guids[guid] = nil;
		kNecroticPlague:SendCommunication("DataUpdate", kNecroticPlague:Serialize(kNecroticPlague.guids));
		kNecroticPlague:Debug("FUNC: Server_ScarabDied, request sender = "..sender..", guid = "..guid..", sending comm to delete from client.", 1);
	end
end
function kNecroticPlague:Server_RaidHasServerReceived(sender)
	if not kNecroticPlague:Client_IsServer() then
		return;
	end
	kNecroticPlague:Debug("FUNC: Server_RaidHasServerReceived, request sender = "..sender..", SendComm(RaidServer).", 1);
	kNecroticPlague:SendCommunication("RaidServer", nil);
end
function kNecroticPlague:Server_VersionCheck(outputResult)
	if not kNecroticPlague:Client_IsServer() then
		return;
	end
	for i=1,GetNumRaidMembers() do
		kNecroticPlague.versions[GetRaidRosterInfo(i)] = false;
	end
	if outputResult then
		kNecroticPlague:ScheduleTimer("Server_VerifyVersions", 6, outputResult);
	else
		kNecroticPlague:ScheduleTimer("Server_VerifyVersions", 6);
	end
	kNecroticPlague:SendCommunication("VersionRequest", kNecroticPlague.version)
end
function kNecroticPlague:Server_VersionReceived(sender, version)
	if not kNecroticPlague:Client_IsServer() then
		return;
	end
	kNecroticPlague.versions[sender] = version;
	kNecroticPlague:Debug("FUNC: Server_VersionReceived sender: "..sender.. ", version: " .. version,1);
	kNecroticPlague:Server_VerifyVersions();
end
function kNecroticPlague:Server_VerifyVersions(outputResult)
	if not kNecroticPlague:Client_IsServer() then
		return;
	end
	local booIncompatibleFound = false;
	for name,version in pairs(kNecroticPlague.versions) do
		if version == false then
			if outputResult then
				kNecroticPlague:Print("|cFF"..kNecroticPlague:RGBToHex(255,0,0).."No kNecroticPlague Install Found|r: " .. name);
			end
			booIncompatibleFound = true;
		elseif version < kNecroticPlague.version then
			booIncompatibleFound = true;
			if version < kNecroticPlague.minRequiredVersion then
				if outputResult then
					kNecroticPlague:Print("|cFF"..kNecroticPlague:RGBToHex(255,0,0).."Incompatible Version|r: " .. name .. " [" .. version .. "]");
				end
				kNecroticPlague:SendCommunication("VersionInvalid", kNecroticPlague:Serialize(name, kNecroticPlague.minRequiredVersion, kNecroticPlague.version));
			else
				if outputResult then
					kNecroticPlague:Print("|cFF"..kNecroticPlague:RGBToHex(255,255,0).."Out of Date Version|r: " .. name .. " [" .. version .. "]");
				end
			end
		end
	end
	if booIncompatibleFound == false then
		if outputResult then
			kNecroticPlague:Print("|cFF"..kNecroticPlague:RGBToHex(0,255,0).."All Users Compatible|r");
		end
	end
end