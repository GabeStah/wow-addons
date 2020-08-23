--[[ Gui_CenterMapFrameOnCoords
PURPOSE: Center the map frame to the passed coordinates
ARGS:	xPosition [number] - X coord to center on
		yPosition [number] - Y coord to center on
		mapFrame [frame] - (optional) Map frame to center
RETURN:	
]]
function kFormation:Gui_CenterMapFrameOnCoords(xCoord, yCoord, mapFrame)
	local fMap = getglobal(kFormation.const.gui.frames.mapName);
	if mapFrame then
		fMap = mapFrame;
	end
	local xPosition = xCoord * fMap:GetWidth();
	local yPosition = yCoord * fMap:GetHeight();
	local w = fMap:GetParent():GetWidth() / 2;
	local h = fMap:GetParent():GetHeight() / 2;
	fMap:GetParent():SetHorizontalScroll(-(xPosition - w));
	fMap:GetParent():SetVerticalScroll(yPosition - h);
	return true;
end
--[[ Gui_CenterMapFrameOnCursor
PURPOSE: Center the map frame to the cursor location
ARGS:	mapFrame [frame] - (optional) Map fram to center
RETURN:	
]]
function kFormation:Gui_CenterMapFrameOnCursor(mapFrame)
	local fMap = getglobal(kFormation.const.gui.frames.mapName);
	if mapFrame then
		fMap = mapFrame;
	end
	local x, y = kFormation:Nav_GetMapEffectivePositionAtCursor();
	local w = fMap:GetParent():GetWidth() / 2;
	local h = fMap:GetParent():GetHeight() / 2;
	fMap:GetParent():SetHorizontalScroll(-(x - w));
	fMap:GetParent():SetVerticalScroll(y - h);
	return true;
end
--[[ Gui_CenterMapFrameOnPosition
PURPOSE: Center the map frame to the passed location
ARGS:	xPosition [number] - X position to center on
		yPosition [number] - Y position to center on
		mapFrame [frame] - (optional) Map frame to center
RETURN:	
]]
function kFormation:Gui_CenterMapFrameOnPosition(xPosition, yPosition, mapFrame)
	local fMap = getglobal(kFormation.const.gui.frames.mapName);
	if mapFrame then
		fMap = mapFrame;
	end
	local w = fMap:GetParent():GetWidth() / 2;
	local h = fMap:GetParent():GetHeight() / 2;
	fMap:GetParent():SetHorizontalScroll(-(xPosition - w));
	fMap:GetParent():SetVerticalScroll(yPosition - h);
	return true;
end
--[[ Gui_CreateDebugInfoFrame
PURPOSE: Create the debug info frame for assigned parent frame
ARGS:	parentFrame [frame] - Parent frame to attach
RETURN:	debugFrame [frame] - Created frame
]]
function kFormation:Gui_CreateDebugInfoFrame(parentFrame)
	local fInfo = CreateFrame("Frame", parentFrame:GetName().."DebugInfo", parentFrame);
	fInfo:SetWidth(fInfo:GetParent():GetWidth());
	fInfo:SetHeight(100);
	fInfo:SetPoint("BOTTOM", parentFrame, "TOP", 0, 5);
	fInfo:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
	fInfo:SetBackdropColor(0,0,0,1);
	local fEffCoords = kFormation:Gui_CreateDebugInfoFrameDetail("EffectiveCoords", fInfo, fInfo);
	local fLocalCoords = kFormation:Gui_CreateDebugInfoFrameDetail("LocalCoords", fEffCoords, fInfo, "BOTTOMLEFT", "TOPLEFT");
	local fPlayerCoords = kFormation:Gui_CreateDebugInfoFrameDetail("PlayerCoords", fLocalCoords, fInfo, "BOTTOMLEFT", "TOPLEFT");
	local fZoom = kFormation:Gui_CreateDebugInfoFrameDetail("Zoom", fPlayerCoords, fInfo, "BOTTOMLEFT", "TOPLEFT");
	local fScroll = kFormation:Gui_CreateDebugInfoFrameDetail("Scroll", fZoom, fInfo, "BOTTOMLEFT", "TOPLEFT");
	return fInfo;
end
--[[ Gui_CreateDebugInfoFrame
PURPOSE: Create the debug info frame for assigned parent frame
ARGS:	parentFrame [frame] - Parent frame to attach
RETURN:	debugFrame [frame] - Created frame
]]
function kFormation:Gui_CreateDebugInfoFrameDetail(name, attachToFrame, parentFrame, attachPoint, attachToPoint)
	local f = CreateFrame("Frame", parentFrame:GetName().."_"..name, parentFrame);
	f:SetWidth(parentFrame:GetWidth());
	f:SetHeight(parentFrame:GetHeight() * 0.15);
	if attachPoint and attachToPoint then
		f:SetPoint(attachPoint, attachToFrame, attachToPoint);
	elseif attachPoint then
		f:SetPoint(attachPoint, attachToFrame);
	else
		f:SetPoint("BOTTOMLEFT", attachToFrame);
	end
	local fText = f:CreateFontString(f:GetName().."Text");
	fText:SetFont("Fonts\\FRIZQT__.TTF", 11)
	fText:SetTextColor(1,1,1,1);
	fText:SetText(name);
	fText:SetAllPoints();
	fText:SetJustifyH("LEFT");
	return f;
end
--[[ Gui_CreateMapFrame
PURPOSE: Creates main map frame
ARGS:	parentFrame [frame] - Parent frame with which to attach map frame
RETURN:	frame [frame] - Generated map frame
]]
function kFormation:Gui_CreateMapFrame(parentFrame)
	local strMapName = GetMapInfo();
	local intCurrentLevel = GetCurrentMapDungeonLevel();
	local f = CreateFrame("Frame", kFormation.const.gui.frames.mapName,parentFrame)
	parentFrame:SetScrollChild(f);
	f:SetFrameStrata("LOW")
	f:SetFrameLevel(1);
	f:EnableMouse(true);
	f:SetWidth(700 * kFormation.db.profile.gui.frames.map.zoom) -- Set these to whatever height/width is needed 
	f:SetHeight(f:GetWidth() * 2/3) -- for your Texture
	
	-- DEFAULT TILE WIDTH: 250.5
	-- DEFAULT TILE HEIGHT: 167
	for i = 1, 12 do
		local tile = f:CreateTexture(f:GetName().."Texture"..i, "BACKGROUND")
		local tileWidth = 256/1002 * f:GetWidth();
		local tileHeight = 256/1002 * f:GetWidth();
		local xOffsetTopLeft = (i-1)%4 * tileWidth;
		local yOffsetTopLeft = math.floor((i-1)/4) * tileHeight * -1;
		local xOffsetBottomRight = (((i-1)%4)+1) * tileWidth;
		local yOffsetBottomRight = math.floor((i-1)/4 + 1) * tileHeight * -1;
		if intCurrentLevel > 0 then
			tile:SetTexture(([=[Interface\WorldMap\%s\%s%d_%d]=]):format(strMapName, strMapName, intCurrentLevel, i))		
		else
			tile:SetTexture(([=[Interface\WorldMap\%s\%s%d]=]):format(strMapName, strMapName, i))		
		end		
		tile:SetPoint("TOPLEFT", f, "TOPLEFT", xOffsetTopLeft, yOffsetTopLeft);
		tile:SetPoint("BOTTOMRIGHT", f, "TOPLEFT", xOffsetBottomRight, yOffsetBottomRight);
	end
	local player = f:CreateTexture(nil, "FOREGROUND");
	local xP, yP = GetPlayerMapPosition("player");
	player:SetWidth(10);
	player:SetHeight(10);
	player:SetPoint("TOPLEFT", f, "TOPLEFT", f:GetWidth() * xP - (player:GetWidth() / 2), -1 * f:GetHeight() * yP + (player:GetHeight() / 2));
	player:SetTexture([=[Interface\Icons\INV_Misc_QuestionMark]=]);

	f:SetPoint("CENTER", 0, 0);
	f:Show();
	
	return f;
end
--[[ Gui_RedrawMapFrame
PURPOSE: Redraws the map frame with any updated parameters
ARGS:	
RETURN:	
]]
function kFormation:Gui_RedrawMapFrame()
	local f = getglobal(kFormation.const.gui.frames.mapName)
	if f then
		f:SetWidth(700 * kFormation.db.profile.gui.frames.map.zoom)
		f:SetHeight(f:GetWidth() * 2/3);
		for i = 1, 12 do
			local tile = getglobal(f:GetName().."Texture"..i);
			if tile then
				local tileWidth = 256/1002 * f:GetWidth();
				local tileHeight = 256/1002 * f:GetWidth();
				local xOffsetTopLeft = (i-1)%4 * tileWidth;
				local yOffsetTopLeft = math.floor((i-1)/4) * tileHeight * -1;
				local xOffsetBottomRight = (((i-1)%4)+1) * tileWidth;
				local yOffsetBottomRight = math.floor((i-1)/4 + 1) * tileHeight * -1;
				tile:SetPoint("TOPLEFT", f, "TOPLEFT", xOffsetTopLeft, yOffsetTopLeft);
				tile:SetPoint("BOTTOMRIGHT", f, "TOPLEFT", xOffsetBottomRight, yOffsetBottomRight);
			end
		end
		f:SetPoint("CENTER", 0, 0);
	end
end
--[[ Gui_UpdateMapZoomValue
PURPOSE: Update the Map frame zoom value
ARGS:	delta [number] - Delta (-1 or 1) to determine if zoom in or out value
RETURN:	value [float] - Updated zoom value
]]
function kFormation:Gui_UpdateMapZoomValue(delta)
	if delta == 1 then
		if not ((kFormation.db.profile.gui.frames.map.zoom + kFormation.const.gui.zoomIncrement) > kFormation.const.gui.zoomMax) then
			kFormation.db.profile.gui.frames.map.zoom = kFormation.db.profile.gui.frames.map.zoom + kFormation.const.gui.zoomIncrement;	
		end 
	else
		if not ((kFormation.db.profile.gui.frames.map.zoom - kFormation.const.gui.zoomIncrement) < kFormation.const.gui.zoomMin) then
			kFormation.db.profile.gui.frames.map.zoom = kFormation.db.profile.gui.frames.map.zoom - kFormation.const.gui.zoomIncrement;	
		end
	end
	return kFormation.db.profile.gui.frames.map.zoom;
end