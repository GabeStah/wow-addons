local _
-- Create Mixins
kTiku = LibStub("AceAddon-3.0"):NewAddon("kTiku", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
local currDragFrame;

local DEFAULT_TEXTURE = 0.2, 0.2, 0.2;
local DEFAULT_TEXTURE_ALPHA = 0.5;
local FRAME_TYPES = {
	TriggerBase = {
		type = 'TriggerBase',
		draggable = false,		
		accepts = {
			'TriggerGroup',
			'TriggerGroupOperator',
		},
		disregardParent = true,
	},
	TriggerGroupOperator = {
		type = 'TriggerGroupOperator',
		draggable = true,
		accepts = {
			'Pause',
			'TriggerGroup',
			'TriggerGroupOperator',
		},
		targets = {
			'TriggerBase',
			'TriggerGroupOperator',
		},
	},
	TriggerGroup = {
		type = 'TriggerGroup',
		draggable = true,
		accepts = {
			'Pause',
			'Trigger',
			'TriggerOperator',
		},
		targets = {
			'TriggerBase',
			'TriggerGroupOperator',
		},
	},
	TriggerOperator = {
		type = 'TriggerOperator',
		draggable = true,
		accepts = {
			'Trigger',
			'TriggerOperator',
		},
		targets = {
			'TriggerGroup',
			'TriggerOperator',
		},
	},
	Pause = {
		type = 'Pause',
		draggable = true,
		targets = {
			'TriggerGroup',
			'TriggerGroupOperator',
		},
	},
	Trigger = {
		type = 'Trigger',
		draggable = true,
		accepts = {
			'EventGroup',
			'EventGroupOperator',
		},
		targets = {
			'TriggerGroup',
			'TriggerOperator',
		},
	},
	EventGroupOperator = {
		type = 'EventGroupOperator',
		draggable = true,
		accepts = {
			'EventGroup',
			'EventGroupOperator',
		},
		targets = {
			'Trigger',
			'EventGroupOperator',
		},
	},
	EventGroup = {
		type = 'EventGroup',
		draggable = true,
		accepts = {
			'Event',
			'EventOperator',
		},
		targets = {
			'Trigger',
			'EventGroupOperator',
		},
	},
	Event = {
		type = 'Event',
		draggable = true,
		targets = {
			'EventGroup',
			'EventOperator',
		},
	},
}

function kTiku:OnInitialize()
    -- Load Database
    kTiku.db = LibStub("AceDB-3.0"):New("kTikuDB", kTiku.defaults)
    -- Inject Options Table and Slash Commands
	kTiku.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kTiku.db)
	kTiku.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kTiku", kTiku.options, {"ktiku", "kt"})
	kTiku.dialog = LibStub("AceConfigDialog-3.0")
	kTiku.AceGUI = LibStub("AceGUI-3.0")
	kTiku.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kTiku.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	-- Init Events
	kTiku:InitializeEvents()
	-- Comm registry
	kTiku:RegisterComm("kTiku")
	--createFrames()
	--UI_CreateInterface()
	
	
	local f = CreateFrame("ScrollFrame", "kTikuScrollFrame", UIParent);
	f:ClearAllPoints();
	f:SetHeight(800);
	f:SetWidth(1000);
	f:SetPoint("CENTER", 0, 0);
	f:EnableMouse(true);
	f:EnableMouseWheel(true);
	f.scrollValue = 0;
	f:SetScript("OnMouseWheel", function(self, delta)
		local increment = 45;
		local maxRange = self:GetVerticalScrollRange();
		if delta < 0 then -- Increase
			if self.scrollValue and self.scrollValue < maxRange then
				if (self.scrollValue + increment) <= maxRange then
					self.scrollValue = self.scrollValue + increment;
				else
					self.scrollValue = maxRange;
				end
				self:SetVerticalScroll(self.scrollValue);
			end
		elseif delta > 0 then -- decrease
			if self.scrollValue and self.scrollValue > 0 then
				if (self.scrollValue - increment) >= 0 then
					self.scrollValue = self.scrollValue - increment;
				else
					self.scrollValue = 0;
				end
				self:SetVerticalScroll(self.scrollValue);
			end
		end
		
	end)
	local tex = f:CreateTexture("ARTWORK");
	tex:SetAllPoints();
	tex:SetTexture(1, 1, 1); 
	tex:SetAlpha(1);	
	
	kTiku:UI_CreateInterface(self.db.profile.alerts)
end
-- PURPOSE: Initialize the events to monitor and fire
function kTiku:InitializeEvents()
	-- Add events here
	-- e.g.: kTiku:RegisterEvent("ZONE_CHANGED_NEW_qeAREA");
end
function kTiku:SendCommunication(command, data)
	kTiku:SendCommMessage("kTiku", kTiku:Serialize(command, data), "RAID")
end
function kTiku:OnCommReceived(prefix, serialObject, distribution, sender)
	kTiku:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kTiku:Deserialize(serialObject)
	if success then
		if prefix == "kTiku" and distribution == "RAID" then
			if command == "SomeCommand" then
				-- Add command
			end
		end
	end
end

function kTiku:GetCursorFrameCoords(frame)
	if not MouseIsOver(frame) then return nil end
	-- Get cursor position
	local xc,yc = GetCursorPosition();
	return xc/UIParent:GetScale()-frame:GetLeft(), frame:GetTop()-yc/UIParent:GetScale();	
end

function kTiku:UI_CreateInterface(data, parent)
	if not data or type(data) ~= 'table' then return end
	-- Loop through 
	for i,v in pairs(data) do
		local frame = UI_CreateFrame(v, v.parent or parent or UIParent, v.type);
		kTiku:UI_DrawFrame(frame);
		-- Check if children
		if v.children and type(v.children == 'table') then
			kTiku:UI_CreateInterface(v.children, frame);
		end
	end
end

function kTiku:UI_RedrawFrames(parentFrame)
	local children = kTiku:UI_FrameGetChildren(parentFrame);
	if not children then return end
	-- Loop through all frames
	for _,v in ipairs(children) do
		kTiku:UI_DrawFrame(v);
		if UI_FrameGetNumChildren(v) then
			-- Draw children
			kTiku:UI_RedrawFrames(v);
		end
	end
	kTikuScrollFrame.scrollValue = 0
	kTikuScrollFrame:SetVerticalScroll(kTikuScrollFrame.scrollValue)
end


function kTiku:UI_FrameSetScript(frame, script)
	if script == 'OnUpdate' then
		frame:SetScript(script, function(self, elapsed)
			if not self.accepts or not (#self.accepts > 0) then return end;
			-- Check if dragging
			if currDragFrame and currDragFrame.isMoving and MouseIsOver(self) then
				-- Check if current accepts dragframe
				if tContains(self.accepts, currDragFrame.type) then
					-- Highlight frame
					self:SetAlpha(0.9)
					-- Set as current drop frame
					self.isDropped = true;
					return
				end
				-- Check if orderable frame
				--[[
				if currDragFrame.order then
					-- Check for position within parent frame
					local x,y = GetCursorFrameCoords(self);
					-- Check y position compared to number of children in order
					local position = floor(y/(self:GetHeight()/self:GetNumChildren()))+1;
					-- Reorder based on current frame and new position
					currDragFrame.position = position;
				end]]
			end
			self.isDropped = false;
			self:SetAlpha(DEFAULT_TEXTURE_ALPHA)
	   end)	
	elseif script == 'OnMouseDown' then
		frame:SetScript(script, function(self, button)
			if button == 'LeftButton' and not self.isMoving then
				self:StartMoving();
				self.isMoving = true;
				currDragFrame = self;
			end
		end)	
	elseif script == 'OnMouseUp' then
		frame:SetScript(script, function(self, button)
			if button == 'LeftButton' and self.isMoving and self.draggable then
				self:StopMovingOrSizing();
				self.isMoving = false;
				kTiku:UI_RedrawFrames(kTikuScrollFrame)				
				-- Find if a frame .isDropped and is valid target
				local dropTarget = UI_GetDroppedFrame(kTikuScrollFrame);
				if dropTarget then
					print('Drop target: ' .. dropTarget:GetName());
					-- Check if valid parent frame
					local validParent = UI_IsValidParentFrame(self, dropTarget);
					if validParent then
						print('valid parent drop')
						print(('parent drop alertid: %s'):format(kTiku:Alert_GetIdFromFrame(dropTarget)));
					end
				else
					print('Dropped, no target.');
				end
				
				
				--[[
				local oChildren = UI_FrameGetChildren(self:GetParent());
				-- Check for position adjustment
				if self.position and self.position ~= self.order then
					-- Alter position
					-- If position > order, adjust every other frame > order down one order
					if self.position > self.order then
						-- Loop children of parent
						for _, v in ipairs(oChildren) do
							-- If sibling order > self.a.order and <=self.position then drop it down
							if v.order > self.order and v.order <= self.position then
								v.order = v.order - 1;
							end
						end
					elseif self.position < self.order then
						-- Loop children of parent
						for _, v in ipairs(oChildren) do
							if v.order < self.order and v.order >= self.position then
								v.order = v.order + 1;
							end
						end
					end
					-- Update self.a.order = position
					self.order = self.position;
					self.position = nil;
					table.sort(self:GetParent():GetChildren(), function(a,b) return a.order<b.order end)					
				end
				-- Now recreate frame positions
				for _,v in ipairs(oChildren) do
					v:ClearAllPoints();
					v:SetPoint("TOPLEFT", 0, -1*((v:GetParent():GetHeight()/v:GetParent():GetNumChildren())*v.order - v:GetParent():GetHeight()/v:GetParent():GetNumChildren()))
				end				
				]]
				currDragFrame = nil;
			end
		end)	
	end
end

function UI_CreateFrame(data, parentFrame, type)
	-- Valid type
	if not UI_IsValidFrameType(type) then 
		error(("Cannot create frame: %s is invalid frame type."):format(type));
		return 
	end
	-- Valid parent
	if not UI_IsValidParentFrameType(parentFrame, type) then 
		if parentFrame.type then
			error(("Cannot create frame: Parent Frame (%s) of type %s is invalid Parent Frame for frame type %s."):format(parentFrame:GetName(), parentFrame.type, type));
		else
			error(("Cannot create frame: Parent Frame (%s) is invalid Parent Frame for frame type %s."):format(parentFrame:GetName(),type));
		end
		return 
	end
	-- Check for Baseframe
	local frame = CreateFrame("Frame", ("%s_%s"):format(type, data.id), parentFrame);
	if type == 'TriggerBase' then
		kTiku:Debug("TriggerBase, creating scroll frame", 2);
		kTikuScrollFrame:SetScrollChild(frame)	
	end
	if not frame then return end
	for i,v in pairs(FRAME_TYPES[type]) do
		frame[i] = v;
	end
	if data.id then frame.id = data.id end -- Add id to frame
	UI_CreateFrameTexture(frame);		
	-- Draggable
	if frame.draggable then
		frame:SetMovable(true);
		frame:EnableMouse(true);		
		kTiku:UI_FrameSetScript(frame, 'OnMouseDown');
		kTiku:UI_FrameSetScript(frame, 'OnMouseUp');
	end
	if frame.accepts and #frame.accepts > 0 then
		kTiku:UI_FrameSetScript(frame, 'OnUpdate');
	end
	-- If debug, add title names
	if kTiku.db.profile.debug then
		frame.debugTitle = frame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont");
		frame.debugTitle:SetWidth(frame:GetWidth());
		frame.debugTitle:SetHeight(30);
		frame.debugTitle:SetPoint("TOPLEFT", 0, 0)
		frame.debugTitle:SetText(frame:GetName());
	end
	return frame;
end

function kTiku:Alert_GetIdFromFrame(frame)
	local frameName = type(frame) == 'string' and frame or frame:GetName();
	print('FrameName: ' .. frameName or "no frame passed");
	-- split name by seperator
	local id = select(2,strsplit('_', frameName));
	return id;
end

function kTiku:Alert_Shift(child, parent)
	if not child or not parent then return end
	local cID,pID = child,parent;
	-- convert from string id to number id
	if type(cID) == 'string' and tonumber(cID) then
		cID = tonumber(cID)
	elseif type(cID) == 'string' then -- frame
		cID = kTiku:Alert_GetIdFromFrame(cID)
	end
	if type(pID) == 'string' and tonumber(pID) then 
		pID = tonumber(pID) 
	elseif type(pID) == 'string' then -- frame
		pID = kTiku:Alert_GetIdFromFrame(pID)	
	end
	-- TODO: Complete
end
function kTiku:Alert_Delete(alert)
	if not alert then return nil end
	local index, parent = kTiku:Alert_GetIndex(alert), kTiku:Alert_GetParent(alert);
	if not index or not parent then return end
	tremove(parent.children, index);
	return true;
end

function kTiku:Alert_Insert(alert, parent)
	if not alert then return nil end
	parent = parent or self.db.profile.alerts;
	--alert = 
end

function kTiku:Alert_GetIndex(alert)
	local childID = type(alert) == 'table' and alert.id or alert;
	local parent = type(alert) == 'table' and kTiku:Alert_GetParent(alert) or kTiku:Alert_GetParent(kTiku:Alert_GetAlert(alert))
	if not parent then return end
	for k,v in pairs(parent.children) do
		if v.id == childID then return k end
	end
	return nil
end

function kTiku:UI_GetFrameNameFromAlert(alert)
	-- Check if actual alert passed
	if type(alert) == 'table' and alert.id and alert.type then
		return ("%s_%s"):format(alert.type, alert.id);
	end
	local id = type(alert) == 'number' and alert or type(alert) == 'string' and alert;
	local name;
	if id then
		-- Get alert
		alert = kTiku:Alert_GetAlert(id)
		if alert then return ("%s_%s"):format(alert.type, id) end
	end
	return nil;
end

function kTiku:UI_DrawFrame(frame)
	-- Loop through frames
	local alert = kTiku:Alert_GetAlert(frame.id);
	local xOffset = 20;
	local yOffset = 30;
	local height = alert and alert.height or 300;
	local width = alert and alert.width or 300;
	--local iSiblingCount = UI_FrameGetNumChildren(frame:GetParent());
	frame:ClearAllPoints();
	-- Check if height
	frame:SetHeight(height);
	frame:SetWidth(width);
	if alert and alert.points then
		for i,v in pairs(alert.points) do	
			frame:SetPoint(v[1],v[2],v[3],v[4],v[5]);
		end
	else
		-- Get previous sibling name
		local parentAlert = kTiku:Alert_GetParent(frame.id);
		local parentFrame = getglobal(kTiku:UI_GetFrameNameById(parentAlert.id))	
		-- Check if siblings
		local previousSibling = kTiku:Alert_GetPreviousSibling(alert)
		if previousSibling then
			local prevsib = kTiku:UI_GetFrameNameById(previousSibling.id);
			frame:SetPoint("TOPLEFT", getglobal(prevsib), "BOTTOMLEFT", 0, 0)
			frame:SetPoint("TOPRIGHT", getglobal(prevsib), "BOTTOMRIGHT", 0, 0)
		else
			frame:SetPoint("TOPLEFT", xOffset, -yOffset)
			frame:SetPoint("BOTTOMRIGHT", -xOffset, yOffset)
		end
	end
end
function kTiku:Alert_GetPreviousSibling(child)
	local alert;
	if type(child) == 'number' then
		alert = kTiku:Alert_GetAlert(child);
	end
	if type(child) == 'table' and child.id then
		alert = kTiku:Alert_GetAlert(child.id);
	end
	if not alert then return end
	-- Get parent
	local parent = kTiku:Alert_GetParent(alert);
	if parent.children and #parent.children > 0 then
		for i = 1,#parent.children do
			-- Check if next child is search child
			if i ~= #parent.children and parent.children[i+1].id == alert.id then
				return parent.children[i];
			end
		end
	end
end
function kTiku:Alert_GetNextSibling(child)
	local alert;
	if type(child) == 'number' then
		alert = kTiku:Alert_GetAlert(child);
	end
	if type(child) == 'table' and child.id then
		alert = kTiku:Alert_GetAlert(child.id);
	end
	if not alert then return end
	-- Get parent
	local parent = kTiku:Alert_GetParent(alert);
	if parent.children and #parent.children > 0 then
		for i = 1,#parent.children do
			-- Check if next child is search child
			if i+1 <= #parent.children and parent.children[i].id == alert.id then
				return parent.children[i+1];
			end
		end
	end
end
function kTiku:Alert_IterateForParent(childId, data)
	if not data then data = self.db.profile.alerts end
	for i,v in pairs(data) do
		-- Check for children
		if v.children and #v.children > 0 then
			for ic,vc in pairs(v.children) do -- Iterate Children for match
				if vc.id == childId then return v end -- Parent of child id found
			end
		end
		if v.children then 
			local parent = kTiku:Alert_IterateForParent(childId,v.children)
			if parent then return parent end
		end
	end
	return nil;	
end
function kTiku:UI_GetFrameNameById(id)
	local alert = kTiku:Alert_GetAlert(id)
	if alert and alert.id and alert.type then return alert.type .. '_' .. alert.id end
end
function kTiku:Alert_GetParent(child)
	local alert;
	if type(child) == 'number' then
		alert = kTiku:Alert_GetAlert(child);
	end
	if type(child) == 'table' and child.id then
		alert = kTiku:Alert_GetAlert(child.id);
	end
	if not alert then return end
	-- Loop through alerts until child matches id
	return kTiku:Alert_IterateForParent(alert.id);
end
function UI_IsValidFrameType(type)
	for i,v in pairs(FRAME_TYPES) do
		if type == i then return true end
	end
	return false
end
function UI_IsValidParentFrameType(parentFrame, type)
	for i,v in pairs(FRAME_TYPES) do
		-- Check for typematch and parentDisregard
		if type == i and v.disregardParent then return true end
		-- Check for .accepts match
		if parentFrame.type and parentFrame.type == v.type and tContains(v.accepts, type) then return true end
	end
	return false
end
function UI_IsValidParentFrame(child, parent)
	if (not child.type) or (not parent.type) then return false end
	for i,v in pairs(FRAME_TYPES) do
		-- Check for typematch and parentDisregard
		if child.type == i and v.disregardParent then return true end
		-- Check for .accepts match
		if parent.type and parent.type == v.type and tContains(v.accepts, child.type) then return true end
	end
	return false
end
function UI_GetDroppedFrame(topLevel)
	local oChildren = {topLevel:GetChildren()};
	if oChildren and #oChildren > 0 then
		for _,v in ipairs(oChildren) do
			if v.isDropped then return v end
			local oSubChildren = {v:GetChildren()};
			if oSubChildren and #oSubChildren > 0 then
				local subDrop = UI_GetDroppedFrame(v);
				if subDrop then return subDrop end
			end
		end
	end
	return nil;
end

function UI_CreateFrameTexture(frame)
	if not frame then return end
	local tex = frame:CreateTexture("ARTWORK");
	tex:SetAllPoints();
	-- Check if texture data exists, else default
	if frame.texture then
		tex:SetTexture(frame.texture);
	else
		-- Debug, create random colors
		if kTiku.db.profile.debug then
			tex:SetTexture(math.random(0,1), math.random(0,1), math.random(0,1))
		else
			tex:SetTexture(DEFAULT_TEXTURE);
		end
	end
	if frame.textureAlpha then
		tex:SetAlpha(frame.textureAlpha);
	else
		tex:SetAlpha(DEFAULT_TEXTURE_ALPHA);
	end
end

function kTiku:UI_FrameGetChildren(frame, type)
	local oChildren = {frame:GetChildren()};
	local oReturn;
	-- Check for valid types
	if oChildren and #oChildren > 0 then
		if type then
			for _,v in ipairs(oChildren) do
				if v.type and lower(type) == lower(v.type) then
					tinsert(oReturn, v);
				end
			end
		else
			-- No type, return all
			return oChildren;
		end
	end
	return oReturn;
end
function UI_FrameGetNumChildren(frame, type)
	local oChildren = {frame:GetChildren()};
	local count = 0;
	-- Check for valid types
	if oChildren and #oChildren > 0 then
		if type then
			for _,v in ipairs(oChildren) do
				if v.type and lower(type) == lower(v.type) then
					count = count+1;
				end
			end
		else
			-- No type, return all
			return #oChildren;
		end
	end
	return count;	
end
function kTiku:Alert_GetAlert(id,data)
	if not data then data = self.db.profile.alerts end
	if not type(id) == 'number' and kTiku:Alert_IsAlert(id) then return id end
	for i,v in pairs(data) do
		if v.id == id then return v end
		if v.children then 
			local alert = kTiku:Alert_GetAlert(id,v.children);
			if alert then return alert end
		end
	end
	return nil;
end
function kTiku:Alert_IsAlert(alert)
	if not alert then return end
	if type(alert) == 'table' and alert.id and alert.type and UI_IsValidFrameType(alert.type) then return true end
	return false
end
function kTiku:Alert_GetUniqueId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = kTiku:Utility_GenerateHex(20);
		-- Find matching id
		if kTiku:Alert_GetAlert(newId) then matchFound = true end
		if matchFound == false then	isValidId = true end
	end
	return newId;
end

function kTiku:Utility_GenerateHex(length)
	local len = length and length/2 or 10;
	local out = "";
	for i=1,len do
		local upper = math.floor(math.random(0,1))
		if upper == 1 then out = ('%s%X'):format(out, math.random(10,255)) else out = ('%s%x'):format(out, math.random(10,255)) end
	end
end