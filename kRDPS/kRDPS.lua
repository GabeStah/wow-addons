local KRDPS_SLASH_COMMAND = "/krdps";

local isActive = false;

local colors ={
				["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, a=1 },
				["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, a=1 },
				["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, a=1 },
				["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, a=1 },
				["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, a=1 },
				["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, a=1 },
				["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, a=1 },
				["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0, a=1 },
				["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, a=1 },
				["DEATH KNIGHT"] = { r = 0.77, g = 0.12, b = 0.23, a=1 }
}

local leftFootName = "Left Foot";
local rightFootName = "Right Foot";

local leftCount = 0;
local rightCount = 0;

local leftFootDamage = 0;
local rightFootDamage = 0;

local leftHight = 25;
local rightHight = 25;

local leftStart_X = 60;
local rightStart_X = -60;

local leftStart_Y = -60;
local rightStart_Y = -60;

local playerTargetArray = {};

local testLabel;
local refreshCount = 10;
local CurrentRefreshCount = 10;

function kRDPS_slashCommand(msg)
	--if UnitClass("player") == "Warrior" then
		--LordRhyolithFooters:Show();

    if msg == "" or msg == nil then
        --DEFAULT_CHAT_FRAME:AddMessage("Lord Rhyolith Footers Help Text",1,1,1);
DEFAULT_CHAT_FRAME:AddMessage("----Lord Rhyolith Footers Commands Help----",1,1,1);
DEFAULT_CHAT_FRAME:AddMessage("Lord Rhyolith Footers: Type '/lrf show' To SHOW the monitor",1,1,1);
DEFAULT_CHAT_FRAME:AddMessage("Lord Rhyolith Footers: Type '/lrf hide' To HIDE the monitor",1,1,1);
DEFAULT_CHAT_FRAME:AddMessage("Lord Rhyolith Footers: Type '/lrf lock' To LOCK the frame, allowing clickthrough",1,1,1);
DEFAULT_CHAT_FRAME:AddMessage("Lord Rhyolith Footers: Type '/lrf unlock' To UNLOCK the frame, allowing to move or resize the frame",1,1,1);
DEFAULT_CHAT_FRAME:AddMessage("                      left-click to move the frame, and right-click to resize it",1,1,1);

elseif msg == "show" or msg == "SHOW" then
   LordRhyolithFooters:Show();
elseif msg == "hide" or msg == "HIDE" then
   LordRhyolithFooters:Hide();
elseif msg == "lock" or msg == "LOCK" then
   LordRhyolithFooters:EnableMouse(false);
elseif msg == "unlock" or msg == "UNLOCK" then
   LordRhyolithFooters:EnableMouse(true);
elseif msg == "test" or msg == "TEST" then
    --DEFAULT_CHAT_FRAME:AddMessage("Party "..GetNumPartyMembers(),1,1,1);
    --DEFAULT_CHAT_FRAME:AddMessage("Raid "..GetNumRaidMembers(),1,1,1);
    --DEFAULT_CHAT_FRAME:AddMessage("Raid "..GetRaidRosterInfo(2),1,1,1);
    --DEFAULT_CHAT_FRAME:AddMessage("Raid "..GetUnitName("target"),1,1,1);
    --local lpoint, lrelativeTo, lrelativePoint, lxOffset, lyOffset = FontString1:GetPoint(index);
    --DEFAULT_CHAT_FRAME:AddMessage("point "..lpoint..".X "..lxOffset..".Y "..lyOffset,1,1,1);
elseif msg == "test2" or msg == "TEST2" then
    --local lpoint, lrelativeTo, lrelativePoint, lxOffset, lyOffset = FontString2:GetPoint(index);
    
    --DEFAULT_CHAT_FRAME:AddMessage("point "..lpoint..".X "..lxOffset..".Y "..lyOffset,1,1,1);

for i = 1, GetNumRaidMembers(), 1 do
            --targetName = GetUnitName("raid"..i.."target");
            playerName, playerRank, playerSubgroup, playerLevel, playerClass = GetRaidRosterInfo(i);
            DEFAULT_CHAT_FRAME:AddMessage("class "..playerClass,1,1,1);
end
end
	-- elseif UnitClass("player") == "Death Knight" then
		-- isShown = 1;
		-- DKSummonGargoyle:Show();
	--end
end

function LordRhyolithFootersInit(self)
    DEFAULT_CHAT_FRAME:AddMessage("LordRhyolithFooters loaded",1,1,1);
   --self:RegisterEvent("ADDON_LOADED");
	--self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	SLASH_LORDRHYOLITHFOOTERS1= LORDRHYOLITHFOOTERS_SLASH_COMMAND;
	SLASH_LORDRHYOLITHFOOTERS2= LORDRHYOLITHFOOTERS_SLASH_COMMAND_SHORT;
	SlashCmdList["LORDRHYOLITHFOOTERS"] = LordRhyolithFooters_slashCommand;
end

function checkDamageStatistics()
   
end

function LordRhyolithFooters_Update(self)
CurrentRefreshCount = CurrentRefreshCount-1;

if CurrentRefreshCount > 0 then
    return;
end
    CurrentRefreshCount = refreshCount;

leftCount = 0;
rightCount = 0;

    if GetNumRaidMembers() > 0 then
        targetName = "";
        for i = 1, GetNumRaidMembers(), 1 do
            targetName = GetUnitName("raid"..i.."target");
            playerName, playerRank, playerSubgroup, playerLevel, playerClass = GetRaidRosterInfo(i);

            if targetName ~= nil then
                playerClass = string.upper(playerClass);
                --DEFAULT_CHAT_FRAME:AddMessage("target is: "..targetName,1,1,1);
                if not playerTargetArray[playerName] then
                    playerTargetArray[playerName] = self:CreateFontString("LORDRHYOLITHFOOTERS_"..playerName);
                    playerTargetArray[playerName]:SetFont("Fonts\\FRIZQT__.TTF","14","");
                    --DEFAULT_CHAT_FRAME:AddMessage("player class "..playerClass,1,1,1);
                    playerTargetArray[playerName]:SetText(playerName);
                    playerTargetArray[playerName]:SetTextColor(colors[playerClass].r, colors[playerClass].g, colors[playerClass].b, colors[playerClass].a);
                end

                if targetName == leftFootName then
                    playerTargetArray[playerName]:Show();

                    playerTargetArray[playerName]:SetPoint("BOTTOMLEFT", LordRhyolithFooters, "TOPLEFT",  leftStart_X-40, leftStart_Y-(leftCount * 20)-8);
                    playerTargetArray[playerName]:SetPoint("TOPRIGHT", LordRhyolithFooters, "TOPLEFT", leftStart_X+40, leftStart_Y-(leftCount * 20)+8);

                    leftCount = leftCount + 1;
                elseif targetName == rightFootName then
                    playerTargetArray[playerName]:Show();

                    playerTargetArray[playerName]:SetPoint("BOTTOMLEFT", LordRhyolithFooters, "TOPRIGHT", rightStart_X-40, rightStart_Y-(rightCount * 20)-8);
                    playerTargetArray[playerName]:SetPoint("TOPRIGHT", LordRhyolithFooters, "TOPRIGHT", rightStart_X+40, rightStart_Y-(rightCount * 20)+8);

                    rightCount = rightCount + 1;    
                else
                    playerTargetArray[playerName]:Hide();
                end
            else
                if not playerTargetArray[playerName] then
                    playerClass = string.upper(playerClass);
                    playerTargetArray[playerName] = self:CreateFontString("LORDRHYOLITHFOOTERS_"..playerName);
                    playerTargetArray[playerName]:SetFont("Fonts\\FRIZQT__.TTF","14","");
                    --DEFAULT_CHAT_FRAME:AddMessage("player class "..playerClass,1,1,1);
                    playerTargetArray[playerName]:SetText(playerName);
                    playerTargetArray[playerName]:SetTextColor(colors[playerClass].r, colors[playerClass].g, colors[playerClass].b, colors[playerClass].a);
                end

                playerTargetArray[playerName]:Hide();
            end
        end
    -- else
        -- --return;
-- --personal testing code
        -- if not testLabel then
            -- testLabel = LordRhyolithFooters:CreateFontString("LORDRHYOLITHFOOTERSWaheiba");
            -- testLabel:SetFont("Fonts\\FRIZQT__.TTF","14","");
            -- testLabel:SetText("Waheiba");
            -- testLabel:SetTextColor(colors["WARRIOR"].r, colors["WARRIOR"].g, colors["WARRIOR"].b, colors["WARRIOR"].a);
            -- --testLabel:SetAllPoints();
        -- end
-- 
        -- myTargetName = GetUnitName("playertarget");
-- 
        -- if myTargetName == nil then
            -- testLabel:Hide();
            -- 
        -- elseif myTargetName == "Waheiba" then
             -- testLabel:Show();
             -- testLabel:SetPoint("BOTTOMLEFT", LordRhyolithFooters, "TOPLEFT",  leftStart_X-40, leftStart_Y-8);
             -- --testLabel:SetPoint("TOPLEFT", LordRhyolithFooters, "TOPLEFT",  leftStart_X-40, leftStart_Y+8);
    -- 
             -- testLabel:SetPoint("TOPRIGHT", LordRhyolithFooters, "TOPLEFT", leftStart_X+40, leftStart_Y+8);
             -- --testLabel:SetPoint("BOTTOMRIGHT", LordRhyolithFooters, "TOPLEFT", leftStart_X+40, leftStart_Y-8);
             -- 
        -- else
             -- testLabel:Show();
             -- testLabel:SetPoint("BOTTOMLEFT", LordRhyolithFooters, "TOPRIGHT", rightStart_X-40, rightStart_Y-8);
             -- --testLabel:SetPoint("TOPLEFT", LordRhyolithFooters, "TOPRIGHT", rightStart_X-40, rightStart_Y+8);
-- 
             -- testLabel:SetPoint("TOPRIGHT", LordRhyolithFooters, "TOPRIGHT", rightStart_X+40, rightStart_Y+8);
            -- -- testLabel:SetPoint("BOTTOMRIGHT", LordRhyolithFooters, "TOPRIGHT", rightStart_X+40, rightStart_Y-8);
-- 
        -- end
    
    end
end

-- LordRhyolithFooters


function LordRhyolithFooters_OnEvent(self, event, ...)
	DEFAULT_CHAT_FRAME:AddMessage(event,1,1,1);
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;
	--DEFAULT_CHAT_FRAME:AddMessage(arg1,1,1,1);
	if event=="ADDON_LOADED" and arg1=="LordRhyolithFooters" then
		--if UnitClass("player") == "Warrior" then
			--WarrHSloadup();
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" and LordRhyolithFooters:IsVisible() then
        DEFAULT_CHAT_FRAME:AddMessage(arg4.." | "..arg7,1,1,1);
        checkDamageStatistics();
    end
end