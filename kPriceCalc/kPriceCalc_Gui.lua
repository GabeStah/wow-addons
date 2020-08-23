-- Author      : Gabe
-- Create Date : 10/12/2009 4:18:07 PM
kPriceCalc.gui = {};
kPriceCalc.gui.frames = {};
kPriceCalc.gui.frames.main = {};
function kPriceCalc:Gui_InitializeFrames()
	-- Create initial frames
	-- Main frame
	kPriceCalc.gui.frames.main = kPriceCalc.AceGUI:Create("Frame")
	kPriceCalc.gui.frames.main:SetCallback("OnClose",function(widget,event) kPriceCalc.AceGUI:Release(widget) end);
	kPriceCalc.gui.frames.main:SetTitle("kPriceCalc")
	kPriceCalc.gui.frames.main:SetLayout("Fill")
	kPriceCalc.gui.frames.main:SetHeight(kPriceCalc.db.profile.gui.frames.main.height);
	kPriceCalc.gui.frames.main:SetWidth(kPriceCalc.db.profile.gui.frames.main.width);
	-- Create main frame
	kPriceCalc:Gui_RefreshMainFrame(true);
end
function kPriceCalc:Gui_RefreshFrame(frame)
	if kPriceCalc.gui.frames.main then
		kPriceCalc.gui.frames.main:SetHeight(kPriceCalc.db.profile.gui.frames.main.height);
		kPriceCalc.gui.frames.main:SetWidth(kPriceCalc.db.profile.gui.frames.main.width);
	end
end
function kPriceCalc:Gui_RefreshMainFrame(initialLoad)
	kPriceCalc.gui.frames.main:ReleaseChildren();
	kPriceCalc:Gui_CreateWidget_ItemTree(kPriceCalc.gui.frames.main);
	kPriceCalc.gui.frames.main.scroll = kPriceCalc.AceGUI:Create("ScrollFrame");
	kPriceCalc.gui.frames.main.scroll:SetLayout("Flow");
	kPriceCalc.gui.frames.main:AddChild(kPriceCalc.gui.frames.main.scroll);
	kPriceCalc.gui.frames.main:Show()	
end
function kPriceCalc:Gui_HookFrameRefreshUpdate()
	-- Hook to update frames
end
function kPriceCalc:Gui_CreateWidget_ItemTree(parent)
	local list = kPriceCalc.db.profile.items;
	local tree = {};
	for i,v in pairs(list) do
		tinsert(tree, {id = v.id, text = v.name, value = v.id});
	end
	kPriceCalc.gui.frames.main.tree = kPriceCalc.AceGUI:Create("TreeGroup")
	kPriceCalc.gui.frames.main.tree:SetCallback('OnGroupSelected', function(widget,event,value,d,e)
		local s1, s2, s3 = strsplit('_', value);
		if s3 then
			kPriceCalc:Gui_ShowItem(kPriceCalc.gui.frames.main.tree, tonumber(s3));
		else
			kPriceCalc:Gui_ShowItem(kPriceCalc.gui.frames.main.tree, value);
		end
	end);
	kPriceCalc.gui.frames.main.tree:SetLayout("Fill")
	kPriceCalc.gui.frames.main.tree:SetTree(tree)
	parent:AddChild(kPriceCalc.gui.frames.main.tree);	
end
function kPriceCalc:Gui_SetFrameBackdropColor(frame, r, g, b, a)
	frame:SetBackdropColor(r,g,b,a);
end
function kPriceCalc:Gui_ShowItem(parent, id)
	local listId = nil;
	if id then
		listId = id;
	elseif kPriceCalc.gui.frames.main.selectedItem then
		listId = kPriceCalc.gui.frames.main.selectedItem;
	end	
	local list = kPriceCalc:GetItemById(listId);
	-- Check if valid list returned
	if list then
		if kPriceCalc.gui.frames.main.tree then
			kPriceCalc.gui.frames.main.tree:ReleaseChildren();
		end
		local fScroll = kPriceCalc.AceGUI:Create("ScrollFrame")
		fScroll:SetFullWidth(true);
		fScroll:SetLayout("Flow")
		if list.combos and #list.combos > 0 then
			for i,v in pairs(list.combos) do
				local fInline = kPriceCalc.AceGUI:Create("SimpleGroup");
				--fInline:SetHeight(30);
				fInline:SetFullWidth(true);
				fInline:SetLayout("Flow");
				fInline.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
				kPriceCalc:Gui_SetFrameBackdropColor(fInline.frame,0,0,0,0);
				fScroll:AddChild(fInline);		

				local name = kPriceCalc.AceGUI:Create("InteractiveLabel");
				name:SetFont("Fonts\\FRIZQT__.TTF", 13);
				name:SetText(v.name);
				fInline:AddChild(name);
				
				-- Loop through combo mats
				for iMat,vMat in pairs(v.mats) do
					-- Name
					local fName = kPriceCalc.AceGUI:Create("InteractiveLabel");
					local iLink = select(2, GetItemInfo(vMat.id));
					fName:SetFont("Fonts\\FRIZQT__.TTF", 13);
					if iLink then
						local iIcon = select(10, GetItemInfo(vMat.id));
						fName:SetText(iLink);
						fName:SetImage(iIcon);
						fName:SetImageSize(20,20);
						fName:SetCallback("OnEnter", function(widget,event,val)
							GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
							GameTooltip:ClearLines();
							GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
							GameTooltip:SetHyperlink(iLink);
							GameTooltip:Show();
							kPriceCalc:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						end);
						fName:SetCallback("OnLeave", function(widget,event,val)
							GameTooltip:Hide();
							kPriceCalc:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
						end);
					else
						fName:SetText(vMat.name);
						fName:SetCallback("OnEnter", function(widget,event,val)
							GameTooltip:ClearLines();
							GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
							GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
							GameTooltip:AddLine("|cFF"..kPriceCalc:RGBToHex(189,0,0).."Item cannot be located in local cache.|r");
							GameTooltip:AddLine("|cFF"..kPriceCalc:RGBToHex(189,0,0).."Details are currently unavailable.|r");
							GameTooltip:Show();
							kPriceCalc:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						end);
						fName:SetCallback("OnLeave", function(widget,event,val)
							GameTooltip:Hide();
							kPriceCalc:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
						end);
					end
					fInline:AddChild(fName);
																			
					-- NumberPerCombine
					local fNumberPerCombine = kPriceCalc.AceGUI:Create("EditBox");
					fNumberPerCombine:SetLabel("NpC");
					fNumberPerCombine:SetText(vMat.numberPerCombine);
					fNumberPerCombine:SetCallback("OnEnterPressed", function(widget,event,val)
						if type(tonumber(val)) == "number" then
							vMat.numberPerCombine = val;
							kPriceCalc:Gui_ShowItem(parent, listId);
						else
							kPriceCalc:Print("Value must be an integer value.");
							kPriceCalc:Gui_ShowItem(parent, listId);
						end
					end);
					fInline:AddChild(fNumberPerCombine);
					
					-- CostPer
					local fCost = kPriceCalc.AceGUI:Create("EditBox");
					fCost:SetLabel("Cost Per");
					fCost:SetText(vMat.costPer);
					fCost:SetCallback("OnEnterPressed", function(widget,event,val)
						if type(tonumber(val)) == "number" then
							vMat.costPer = val;
							kPriceCalc:Gui_ShowItem(parent, listId);
						else
							kPriceCalc:Print("Value must be an integer value.");
							kPriceCalc:Gui_ShowItem(parent, listId);
						end
					end);
					fInline:AddChild(fCost);
					
					fName:SetRelativeWidth((1 - 0.15 - 0.09) / #v.mats * 0.5);
					fNumberPerCombine:SetRelativeWidth((1 - 0.15 - 0.09) / #v.mats * 0.2);
					fCost:SetRelativeWidth((1 - 0.15 - 0.09) / #v.mats * 0.3);
				end
				
				local fTotal = kPriceCalc.AceGUI:Create("InteractiveLabel");
				fTotal:SetFont("Fonts\\FRIZQT__.TTF", 13);
				fTotal:SetText(GetCoinTextureString(kPriceCalc:CalculateComboPrice(listId, v.id)));
				fInline:AddChild(fTotal);
				
				-- Set Widths
				name:SetRelativeWidth(0.15); -- 1	
				fTotal:SetRelativeWidth(0.09);	
			end  
		end  
		if parent then
			parent:AddChild(fScroll);
		else
			kPriceCalc.gui.frames.main.tree:AddChild(fScroll);
		end
	end
end