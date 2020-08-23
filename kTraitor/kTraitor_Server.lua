-- Author      : Gabe
-- Create Date : 11/3/2009 9:13:47 PM
function kTraitor:Server_DataPushReceived(sender, data)
	local success, type, guid, scarab = kTraitor:Deserialize(data);
	if type == "scarab" then
		kTraitor.guids[guid] = scarab; -- Update local
		-- Send comm to update
		kTraitor:SendCommunication("DataUpdate", kTraitor:Serialize(kTraitor.guids));
		kTraitor:Debug("FUNC: Server_DataPushReceived, request sender = "..sender..", guid = "..guid, 1);
	end
end
function kTraitor:Server_ScarabDied(sender, guid)
	if not kTraitor:Client_IsServer() then
		return;
	end
	if kTraitor.guids[guid] then -- Exists, send comm to delete
		kTraitor.guids[guid] = nil;
		kTraitor:SendCommunication("DataUpdate", kTraitor:Serialize(kTraitor.guids));
		kTraitor:Debug("FUNC: Server_ScarabDied, request sender = "..sender..", guid = "..guid..", sending comm to delete from client.", 1);
	end
end
function kTraitor:Server_RaidHasServerReceived(sender)
	if not kTraitor:Client_IsServer() then
		return;
	end
	kTraitor:Debug("FUNC: Server_RaidHasServerReceived, request sender = "..sender..", SendComm(RaidServer).", 1);
	kTraitor:SendCommunication("RaidServer", nil);
end
function kTraitor:Server_VersionCheck(outputResult)
	if not kTraitor:Client_IsServer() then
		return;
	end
	for i=1,GetNumRaidMembers() do
		kTraitor.versions[GetRaidRosterInfo(i)] = false;
	end
	if outputResult then
		kTraitor:ScheduleTimer("Server_VerifyVersions", 6, outputResult);
	else
		kTraitor:ScheduleTimer("Server_VerifyVersions", 6);
	end
	kTraitor:SendCommunication("VersionRequest", kTraitor.version)
end
function kTraitor:Server_VersionReceived(sender, version)
	if not kTraitor:Client_IsServer() then
		return;
	end
	kTraitor.versions[sender] = version;
	kTraitor:Debug("FUNC: Server_VersionReceived sender: "..sender.. ", version: " .. version,1);
	kTraitor:Server_VerifyVersions();
end
function kTraitor:Server_VerifyVersions(outputResult)
	if not kTraitor:Client_IsServer() then
		return;
	end
	local booIncompatibleFound = false;
	for name,version in pairs(kTraitor.versions) do
		if version == false then
			if outputResult then
				kTraitor:Print("|cFF"..kTraitor:RGBToHex(255,0,0).."No kTraitor Install Found|r: " .. name);
			end
			booIncompatibleFound = true;
		elseif version < kTraitor.version then
			booIncompatibleFound = true;
			if version < kTraitor.minRequiredVersion then
				if outputResult then
					kTraitor:Print("|cFF"..kTraitor:RGBToHex(255,0,0).."Incompatible Version|r: " .. name .. " [" .. version .. "]");
				end
				kTraitor:SendCommunication("VersionInvalid", kTraitor:Serialize(name, kTraitor.minRequiredVersion, kTraitor.version));
			else
				if outputResult then
					kTraitor:Print("|cFF"..kTraitor:RGBToHex(255,255,0).."Out of Date Version|r: " .. name .. " [" .. version .. "]");
				end
			end
		end
	end
	if booIncompatibleFound == false then
		if outputResult then
			kTraitor:Print("|cFF"..kTraitor:RGBToHex(0,255,0).."All Users Compatible|r");
		end
	end
end