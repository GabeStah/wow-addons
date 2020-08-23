--[[
Name: LibLordFarlander-SpecialEvents-Aura-4.0
Revision: $Rev: 172 $
Author: LordFarlander
Author: Tekkub Stoutwrithe (tekkub@gmail.com)
Website: http://www.wowace.com/
Description: Special events for Auras, (de)buffs gained, lost etc.
Dependencies: LibStub, CallbackHandler-1.0, AceEvent-3.0, AceBucket-3.0, AceTimer-3.0
]]--

-- I want to rewrite this to use COMBAT_LOG_EVENT instead

--[[
Copyright (c) 2008-2009, LordFarlander
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]--

local vmajor, vminor = "LibLordFarlander-SpecialEvents-Aura-4.0", tonumber( ("$Revision: 172 $"):match( "(%d+)" ) ) + 90000;

if( not LibStub( "LibGratuity-3.0", true ) ) then
    error( vmajor .. " requires LibGratuity-3.0" );
    return;
end--if

local lib, oldMinor = LibStub:NewLibrary( vmajor, vminor );

if( not lib ) then
    return;
end--if

local DEBUG = nil;
local RL;
local pairs = pairs;
local string = string;
local strformat = string.format;
local next = next;
local type = type;
local UnitExists = UnitExists;
local UnitIsUnit = UnitIsUnit;
local GetNumRaidMembers = GetNumRaidMembers;
local UnitBuffLocal = UnitBuff;
local UnitDebuffLocal = UnitDebuff;

----------------------------
--     Initialization     --
----------------------------

local gratuity = LibStub( "LibGratuity-3.0" );

local function debug( txt )
    ChatFrame1:AddMessage( "SEEA: " .. txt );
end--debug( txt )

LibStub( "AceEvent-3.0" ):Embed( lib );
LibStub( "AceBucket-3.0" ):Embed( lib );
LibStub( "AceTimer-3.0" ):Embed( lib );

if( lib.callbacks ) then
    lib:UnregisterAll( lib );
else
    lib.callbacks = LibStub( "CallbackHandler-1.0" ):New( lib, nil, nil, "UnregisterAll" );
end--if

if( not lib.var ) then
    lib.vars = { buffs = {}, debuffs = {} };
end--if

--------------------------------
--      Tracking methods      --
--------------------------------

local player_last_raid_id;

function lib:PLAYER_AURAS_CHANGED()
    self:AuraScan( "player", "PLAYER_AURAS_CHANGED" );

    local id = player_last_raid_id;

    if( id and UnitIsUnit( id, "player" ) ) then
        self:AuraScan( id, "PLAYER_AURAS_CHANGED Raid Player" )
    else
        for i = 1, GetNumRaidMembers() do
            id = "raid" .. i;
            if( UnitIsUnit( id, "player" ) ) then
                player_last_raid_id = id;
                self:AuraScan( id, "PLAYER_AURAS_CHANGED Raid Player" );
                break;
            end--if
        end--for
    end--if
end--lib:PLAYER_AURAS_CHANGED()

function lib:PLAYER_TARGET_CHANGED()
    self:AuraScan( "target", "TARGET_CHANGED" );
    self.callbacks:Fire( "AuraTargetChanged" );
end--lib:PLAYER_TARGET_CHANGED()

function lib:PLAYER_FOCUS_CHANGED()
    self:AuraScan( "focus", "FOCUS_CHANGED" );
    self.callbacks:Fire( "AuraFocusChanged" );
end--lib:PLAYER_FOCUS_CHANGED()

function lib:PARTY_MEMBERS_CHANGED()
    -- TODO: LibRoster support?
    if( UnitExists("pet") ) then
        self:AuraScan( "pet", "PMC Pet" );
    end--if

    for i = 1, 4 do
        if( UnitExists( "party" .. i ) ) then
            self:AuraScan( "party" .. i, "PMC Party" );
        end--if
        if( UnitExists( "partypet" .. i ) ) then
            self:AuraScan( "partypet" .. i, "PMC Party Pet" );
        end--if
    end--for
    self.callbacks:Fire( "AuraPartyMembersChanged" );
end--lib:PARTY_MEMBERS_CHANGED()

function lib:RAID_ROSTER_UPDATE()
    -- TODO: LibRoster support?
    for i = 1, 40 do
        if( UnitExists( "raid" .. i ) ) then
            self:AuraScan( "raid" .. i, "RRU Raid" );
        end--if
        if( UnitExists( "raidpet" .. i ) ) then
            self:AuraScan( "raidpet" .. i, "RRU Raid Pet" );
        end--if
    end--for
    self.callbacks:Fire( "AuraRaidRosterUpdate" );
end--lib:RAID_ROSTER_UPDATE()

function lib:ScanAllAuras()
    if( UnitExists( "player" ) ) then
        self:AuraScan( "player", "ALL Player" );
    end--if
    if( UnitExists( "pet" ) ) then
        self:AuraScan( "pet", "ALL Pet" );
    end--if

    for i = 1, 4 do
        if( UnitExists( "party" .. i ) ) then
            self:AuraScan( "party" .. i, "ALL Party" );
        end--if
        if( UnitExists( "partypet" .. i ) ) then
            self:AuraScan( "partypet" .. i, "ALL Party Pet" );
        end--if
    end

    for i = 1, 40 do
        if( UnitExists( "raid" .. i ) ) then
            self:AuraScan( "raid" .. i, "ALL Raid" );
        end--if
        if( UnitExists( "raidpet" .. i ) ) then
            self:AuraScan( "raidpet" .. i, "ALL Raid Pet" );
        end--if
    end

    if( UnitExists( "target" ) ) then
        self:AuraScan( "target", "ALL Target" );
    end--if
    if( UnitExists( "focus" ) ) then
        self:AuraScan( "focus", "ALL Focus" );
    end--if
end--lib:ScanAllAuras()

-- whee, aura scanning is fun
do
    local seenBuffs, seenDebuffs = {}, {};
    local removedBuffs = {
        name = {},
        rank = {},
        icon = {},
        count = {},
        duration = {},
        timeEnd = {},
    };
    local removedDebuffs = {
        name = {},
        rank = {},
        icon = {},
        count = {},
        dispelType = {},
        duration = {},
        timeEnd = {},
    };

    function lib:AuraScan( unit, reason )
        if( unit == "timer" ) then
            unit, reason = "player", "Periodic for player";
        end--if

        local vars = self.vars;
        local buffs, debuffs = vars.buffs[unit], vars.debuffs[unit];
        local timeNow = GetTime();

        if( not reason ) then
            reason = "UNIT_AURA[STATE]";
        end--if

        -- have we seen this unit before?
        if( not buffs ) then
            buffs = {
                index = {},
                name = {},
                rank = {},
                icon = {},
                count = {},
                duration = {},
                timeEnd = {},
            };
            vars.buffs[unit] = buffs;

            debuffs = {
                index = {},
                name = {},
                rank = {},
                icon = {},
                count = {},
                dispelType = {},
                duration = {},
                timeEnd = {},
            };
            vars.debuffs[unit] = debuffs;
        end--if

        --
        -- Update buffs for unit
        --

        -- check for new buffs
        local i = 1;

        while true do
            local name, rank, icon, count, duration, timeLeft, timeEnd;

            if( unit ) then
                name, rank, icon, count, _, duration, timeLeft = UnitBuffLocal( unit, i, "HELPFUL" );
            end--if
            if( not name ) then
                break;
            end--if

            local timeEnd = ( timeLeft and (timeLeft > 0) and (timeNow + timeLeft) ) or nil;
            
            -- buffs are the same if their name, rank, and icon are the same
            local buffIndex = strformat( "%s_%s_%s", name, rank, icon );

            -- handle multiple instances of the same buff (stacked HoTs)
            while seenBuffs[buffIndex] do
                buffIndex = buffIndex .. "_";
            end--while

            -- this is the only buff field that is allowed to change without dispatching an event
            buffs.index[buffIndex] = i;

            -- new buff?
            if( not buffs.name[buffIndex] ) then
                buffs.name[buffIndex] = name;
                buffs.rank[buffIndex] = rank;
                buffs.icon[buffIndex] = icon;
                buffs.count[buffIndex] = count;
                buffs.duration[buffIndex] = duration;
                buffs.timeEnd[buffIndex] = timeEnd;
                seenBuffs[buffIndex] = "new";
            -- did the count change?
            elseif( buffs.count[buffIndex] ~= count ) then
                buffs.count[buffIndex] = count;
                seenBuffs[buffIndex] = "changed";
            -- was the buff refreshed? only look at significant refreshes i.e. more than a second after the original buff
            elseif( timeEnd and buffs.timeEnd[buffIndex] and ( timeEnd > ( buffs.timeEnd[buffIndex] + 1 ) ) ) then
                buffs.duration[buffIndex] = duration;
                buffs.timeEnd[buffIndex] = timeEnd;
                seenBuffs[buffIndex] = "refreshed";
            -- no changes
            else
                seenBuffs[buffIndex] = true;
            end--if

            i = i + 1;
        end--while

        -- remove old buffs
        for buffIndex in pairs( buffs.index ) do
            if( not seenBuffs[buffIndex] ) then
                -- copy to removed table
                removedBuffs.name[buffIndex] = buffs.name[buffIndex];
                removedBuffs.rank[buffIndex] = buffs.rank[buffIndex];
                removedBuffs.icon[buffIndex] = buffs.icon[buffIndex];
                removedBuffs.count[buffIndex] = buffs.count[buffIndex];
                removedBuffs.duration[buffIndex] = buffs.duration[buffIndex];
                removedBuffs.timeEnd[buffIndex] = buffs.timeEnd[buffIndex];

                -- remove buff from unit
                buffs.index[buffIndex] = nil;
                buffs.name[buffIndex] = nil;
                buffs.rank[buffIndex] = nil;
                buffs.icon[buffIndex] = nil;
                buffs.count[buffIndex] = nil;
                buffs.duration[buffIndex] = nil;
                buffs.timeEnd[buffIndex] = nil;
            end--if
        end--for

        --
        -- Update debuffs for unit
        --

        -- check for new debuffs
        i = 1;
        while true do
            local name, rank, icon, count, dispelType, duration, timeLeft;

            if( unit ) then
                name, rank, icon, count, dispelType, duration, timeLeft = UnitDebuffLocal( unit, i, "HARMFUL" );
            end--if
            if( not name ) then
                break;
            end--if

            local timeEnd = ( timeLeft and (timeLeft > 0) and (timeNow + timeLeft) ) or nil;

            -- debuffs are the same if their name, rank, and icon are the same
            local debuffIndex = strformat( "%s_%s_%s", name, rank, icon );

            -- handle multiple instances of the same debuff
            while seenDebuffs[debuffIndex] do
                debuffIndex = debuffIndex .. "_";
            end--while

            -- these are the only debuff fields that are allowed to change without dispatching an event
            debuffs.index[debuffIndex] = i;
            debuffs.dispelType[debuffIndex] = dispelType or "";

            -- new debuff?
            if( not debuffs.name[debuffIndex] ) then
                debuffs.name[debuffIndex] = name;
                debuffs.rank[debuffIndex] = rank;
                debuffs.icon[debuffIndex] = icon;
                debuffs.count[debuffIndex] = count;
                debuffs.duration[debuffIndex] = duration;
                debuffs.timeEnd[debuffIndex] = timeEnd;
                seenDebuffs[debuffIndex] = "new";
            -- did the count change?
            elseif( debuffs.count[debuffIndex] ~= count ) then
                debuffs.count[debuffIndex] = count;
                seenDebuffs[debuffIndex] = "changed";
                -- was the debuff refreshed? only look at significant refreshes i.e. more than a second after the original debuff
            elseif( timeEnd and debuffs.timeEnd[debuffIndex] and ( timeEnd > ( debuffs.timeEnd[debuffIndex] + 1 ) ) ) then
                debuffs.duration[debuffIndex] = duration;
                debuffs.timeEnd[debuffIndex] = timeEnd;
                seenDebuffs[debuffIndex] = "refreshed";
            -- no changes
            else
                seenDebuffs[debuffIndex] = true;
            end--if

            i = i + 1
        end--while

        -- remove old debuffs
        for debuffIndex in pairs( debuffs.index ) do
            if( not seenDebuffs[debuffIndex] ) then
                -- copy to removed table
                removedDebuffs.name[debuffIndex] = debuffs.name[debuffIndex];
                removedDebuffs.rank[debuffIndex] = debuffs.rank[debuffIndex];
                removedDebuffs.icon[debuffIndex] = debuffs.icon[debuffIndex];
                removedDebuffs.count[debuffIndex] = debuffs.count[debuffIndex];
                removedDebuffs.dispelType[debuffIndex] = debuffs.dispelType[debuffIndex];
                removedDebuffs.duration[debuffIndex] = debuffs.duration[debuffIndex];
                removedDebuffs.timeEnd[debuffIndex] = debuffs.timeEnd[debuffIndex];

                -- remove debuff from unit
                debuffs.index[debuffIndex] = nil;
                debuffs.name[debuffIndex] = nil;
                debuffs.rank[debuffIndex] = nil;
                debuffs.icon[debuffIndex] = nil;
                debuffs.count[debuffIndex] = nil;
                debuffs.dispelType[debuffIndex] = nil;
                debuffs.duration[debuffIndex] = nil;
                debuffs.timeEnd[debuffIndex] = nil;
            end--if
        end--for

        --
        -- Done scanning, it's time to dispatch events!
        --

        -- send events for lost buffs
        for buffIndex in pairs( removedBuffs.name ) do
            local name = removedBuffs.name[buffIndex];
            local count = removedBuffs.count[buffIndex];
            local icon = removedBuffs.icon[buffIndex];
            local rank = removedBuffs.rank[buffIndex];
            local duration = removedBuffs.duration[buffIndex];

            -- unit, name, count, icon, rank
            lib.callbacks:Fire( "UnitBuffLost", unit, name, count, icon, rank, duration );

            if( unit == "player" ) then
                -- name, count, icon, rank
                lib.callbacks:Fire( "PlayerBuffLost", name, count, icon, rank );
            end--if

            if( DEBUG ) then
                debug( "SpecialEvents_UnitBuffLost " .. unit .. ":" .. name .. ", " .. reason )
            end--if

            removedBuffs.name[buffIndex] = nil;
            removedBuffs.rank[buffIndex] = nil;
            removedBuffs.icon[buffIndex] = nil;
            removedBuffs.count[buffIndex] = nil;
        end--if

        -- send events for lost debuffs
        for debuffIndex in pairs( removedDebuffs.name ) do
            local name = removedDebuffs.name[debuffIndex];
            local count = removedDebuffs.count[debuffIndex];
            local dispelType = removedDebuffs.dispelType[debuffIndex];
            local icon = removedDebuffs.icon[debuffIndex];
            local rank = removedDebuffs.rank[debuffIndex];
            local duration = removedDebuffs.duration[debuffIndex];

            -- unit, name, count, dispelType, icon, rank
            lib.callbacks:Fire( "UnitDebuffLost", unit, name, count, dispelType, icon, rank, duration );

            if( unit == "player" ) then
                -- name, count, dispelType, icon, rank
                lib.callbacks:Fire( "PlayerDebuffLost", name, count, dispelType, icon, rank );
            end--if

            if( DEBUG ) then
                debug( "SpecialEvents_UnitDebuffLost " .. unit .. ":" .. name .. ", " .. reason );
            end--if

            removedDebuffs.name[debuffIndex] = nil;
            removedDebuffs.rank[debuffIndex] = nil;
            removedDebuffs.icon[debuffIndex] = nil;
            removedDebuffs.count[debuffIndex] = nil;
            removedDebuffs.dispelType[debuffIndex] = nil;
        end--for

        -- send events for new/changed buffs
        for buffIndex in pairs( buffs.index ) do
            if( seenBuffs[buffIndex] == "new" ) then
                local name = buffs.name[buffIndex];
                local index = buffs.index[buffIndex];
                local count = buffs.count[buffIndex];
                local icon = buffs.icon[buffIndex];
                local rank = buffs.rank[buffIndex];
                local duration = buffs.duration[buffIndex];
                local timeLeft = buffs.timeEnd[buffIndex] and ( buffs.timeEnd[buffIndex] - timeNow ) or nil;

                -- unit, name, index, count, icon, rank
                lib.callbacks:Fire( "UnitBuffGained", unit, name, index, count, icon, rank, duration, timeLeft );

                if( unit == "player" ) then
                    -- name, index, count, icon, rank
                    lib.callbacks:Fire( "PlayerBuffGained", name, index, count, icon, rank, duration, timeLeft );
                end--if

                if( DEBUG ) then
                    debug( "SpecialEvents_UnitBuffGained " .. unit .. ":" .. name .. ", " .. reason .. ", " .. tostring( timeLeft ) .. "/" .. tostring( duration ) )
                end--if
            elseif( seenBuffs[buffIndex] == "changed" ) then
                local name = buffs.name[buffIndex];
                local index = buffs.index[buffIndex];
                local count = buffs.count[buffIndex];
                local icon = buffs.icon[buffIndex];
                local rank = buffs.rank[buffIndex];
                local duration = buffs.duration[buffIndex];
                local timeLeft = buffs.timeEnd[buffIndex] and ( buffs.timeEnd[buffIndex] - timeNow ) or nil;

                -- unit, name, index, count, icon, rank
                lib.callbacks:Fire( "UnitBuffCountChanged", unit, name, index, count, icon, rank, duration, timeLeft );

                if( unit == "player" ) then
                    -- unit, name, index, count, icon, rank
                    lib.callbacks:Fire( "PlayerBuffCountChanged", name, index, count, icon, rank, duration, timeLeft );
                end--if

                if( DEBUG ) then
                    debug( "SpecialEvents_UnitBuffCountChanged " .. unit .. ":" .. name .. ", " .. reason .. ", " .. tostring( timeLeft ) .. "/" .. tostring( duration ) );
                end--if
            elseif( seenBuffs[buffIndex] == "refreshed" ) then
                local name = buffs.name[buffIndex];
                local index = buffs.index[buffIndex];
                local count = buffs.count[buffIndex];
                local icon = buffs.icon[buffIndex];
                local rank = buffs.rank[buffIndex];
                local duration = buffs.duration[buffIndex];
                local timeLeft = buffs.timeEnd[buffIndex] and (buffs.timeEnd[buffIndex] - timeNow) or nil;

                -- unit, name, index, count, icon, rank
                lib.callbacks:Fire( "UnitBuffRefreshed", unit, name, index, count, icon, rank, duration, timeLeft );

                if( unit == "player" ) then
                    -- name, index, count, icon, rank
                    lib.callbacks:Fire( "PlayerBuffRefreshed", name, index, count, icon, rank, duration, timeLeft );
                end--if

                if( DEBUG ) then
                    debug( "SpecialEvents_UnitBuffRefreshed " .. unit .. ":" .. name .. ", " .. reason .. ", " .. tostring( timeLeft ) .. "/" .. tostring( duration ) );
                end--if
            end--if
        end--for

        -- send events for new/changed debuffs
        for debuffIndex in pairs( debuffs.index ) do
            if( seenDebuffs[debuffIndex] == "new" ) then
                local name = debuffs.name[debuffIndex];
                local count = debuffs.count[debuffIndex];
                local dispelType = debuffs.dispelType[debuffIndex];
                local icon = debuffs.icon[debuffIndex];
                local rank = debuffs.rank[debuffIndex];
                local index = debuffs.index[debuffIndex];
                local duration = debuffs.duration[debuffIndex];
                local timeLeft = debuffs.timeEnd[debuffIndex] and ( debuffs.timeEnd[debuffIndex] - timeNow ) or nil;

                -- unit, name, count, dispelType, icon, rank, index
                lib.callbacks:Fire( "UnitDebuffGained", unit, name, count, dispelType, icon, rank, index, duration, timeLeft );

                if( unit == "player" ) then
                    -- name, count, dispelType, icon, rank, index
                    lib.callbacks:Fire( "PlayerDebuffGained", name, count, dispelType, icon, rank, index, duration, timeLeft );
                end--if

                if( DEBUG ) then
                    debug( "SpecialEvents_UnitDebuffGained " .. unit .. ":" .. name .. ", " .. reason .. ", " .. tostring( timeLeft ) .. "/" .. tostring( duration ) );
                end--if
            elseif( seenDebuffs[debuffIndex] == "changed" ) then
                local name = debuffs.name[debuffIndex];
                local count = debuffs.count[debuffIndex];
                local dispelType = debuffs.dispelType[debuffIndex];
                local icon = debuffs.icon[debuffIndex];
                local rank = debuffs.rank[debuffIndex];
                local index = debuffs.index[debuffIndex];
                local duration = debuffs.duration[debuffIndex];
                local timeLeft = debuffs.timeEnd[debuffIndex] and ( debuffs.timeEnd[debuffIndex] - timeNow ) or nil;

                -- unit, name, count, dispelType, icon, rank, index
                lib.callbacks:Fire( "UnitDebuffCountChanged", unit, name, count, dispelType, icon, rank, index, duration, timeLeft );

                if( unit == "player" ) then
                    -- name, count, dispelType, icon, rank, index
                    lib.callbacks:Fire( "PlayerDebuffCountChanged", name, count, dispelType, icon, rank, index, duration, timeLeft );
                end--if

                if( DEBUG ) then
                    debug( "SpecialEvents_UnitDebuffCountChanged " .. unit .. ":" .. name .. ", " .. reason .. ", " .. tostring( timeLeft ) .. "/" .. tostring( duration ) );
                end--if
            elseif( seenDebuffs[debuffIndex] == "refreshed" ) then
                local name = debuffs.name[debuffIndex];
                local count = debuffs.count[debuffIndex];
                local dispelType = debuffs.dispelType[debuffIndex];
                local icon = debuffs.icon[debuffIndex];
                local rank = debuffs.rank[debuffIndex];
                local index = debuffs.index[debuffIndex];
                local duration = debuffs.duration[debuffIndex];
                local timeLeft = debuffs.timeEnd[debuffIndex] and ( debuffs.timeEnd[debuffIndex] - timeNow ) or nil;

                -- unit, name, count, dispelType, icon, rank, index
                lib.callbacks:Fire( "UnitDebuffRefreshed", unit, name, count, dispelType, icon, rank, index, duration, timeLeft );

                if( unit == "player" ) then
                    -- name, count, dispelType, icon, rank, index
                    lib.callbacks:Fire( "PlayerDebuffRefreshed", name, count, dispelType, icon, rank, index, duration, timeLeft );
                end

                if( DEBUG ) then
                    debug( "SpecialEvents_UnitDebuffRefreshed " .. unit .. ":" .. name .. ", " .. reason .. ", " .. tostring( timeLeft ) .. "/" .. tostring( duration ) );
                end
            end
        end

        --
        -- cleanup
        --

        for k in pairs( seenBuffs ) do
            seenBuffs[k] = nil;
        end--for

        for k in pairs( seenDebuffs ) do
            seenDebuffs[k] = nil;
        end--for
    end--lib:AuraScan( unit, reason )
end--do

do
    local function GetItemBuffName( slot )
        gratuity:SetInventoryItem( "player", slot );

        for i = 1, 30 do
            local text = gratuity:GetLine( i );

            if( text ) then
                local buffName = text:match( "^([^%(]+) %(%d+ [^%)]+%)$" );

                if( buffName ) then
                    return buffName;
                end--if
            else
                break;
            end--if
        end--if
    end--function GetItemBuffName( slot )

    function lib:refreshItemBuffs()
        local mainhand, _, _, offhand = GetWeaponEnchantInfo();
        local vars = self.vars;        

        vars.mainhandItemBuff = mainhand and GetItemBuffName( GetInventorySlotInfo( "MainHandSlot" ) );
        vars.offhandItemBuff = offhand and GetItemBuffName( GetInventorySlotInfo( "SecondaryHandSlot" ) );
    end--refreshItemBuffs()
    
    local first = true;

    function lib:PlayerItemBuffScan()
        if( first ) then
            self:refreshItemBuffs();
            first = false;
            return;
        end--if

        local vars = self.vars;
        local oldMainhandItemBuff = vars.mainhandItemBuff;
        local oldOffhandItemBuff = vars.offhandItemBuff;

        self:refreshItemBuffs();
        if( oldMainhandItemBuff ~= vars.mainhandItemBuff ) then
            if( oldMainhandItemBuff ) then -- loss
                -- name, rank, isMainHand
                local name, rank = oldMainhandItemBuff:match( "^(.*) (%d+)$" );

                lib.callbacks:Fire( "PlayerItemBuffLost" , name or oldMainhandItemBuff, rank, true );
            end---if
            if( vars.mainhandItemBuff ) then -- gain
                -- name, rank, isMainHand
                local name, rank = vars.mainhandItemBuff:match( "^(.*) (%d+)$" );

                lib.callbacks:Fire( "PlayerItemBuffGained", name or vars.mainhandItemBuff, rank, true );
            end--if
        end--if
        if( oldOffhandItemBuff ~= vars.offhandItemBuff ) then
            if( oldOffhandItemBuff ) then -- loss
                -- name, rank, isMainHand
                local name, rank = oldOffhandItemBuff:match( "^(.*) (%d+)$" );

                lib.callbacks:Fire( "PlayerItemBuffLost", name or oldOffhandItemBuff, rank, false );
            end--if
            if( vars.offhandItemBuff ) then -- gain
                -- name, rank, isMainHand
                local name, rank = vars.offhandItemBuff:match( "^(.*) (%d+)$" );

                lib.callbacks:Fire( "PlayerItemBuffGained", name or vars.offhandItemBuff, rank, false );
            end--if
        end--if
    end--lib:PlayerItemBuffScan()

    function lib:GetPlayerMainHandItemBuff()
        if( mainhandItemBuff ) then
            local name, rank = vars.mainhandItemBuff:match( "^(.*) (%d+)$" );

            return name or vars.mainhandItemBuff, rank;
        end--if
    end--lib:GetPlayerMainHandItemBuff()

    function lib:GetPlayerOffHandItemBuff()
        if( offhandItemBuff ) then
            local name, rank = vars.offhandItemBuff:match( "^(.*) (%d+)$" );

            return name or vars.offhandItemBuff, rank;
        end--if
    end--lib:GetPlayerOffHandItemBuff()
end--do

-----------------------------
--      Query Methods      --
-----------------------------

function lib:UnitHasBuff( unit, name, rank, icon )
    local unitBuffs = self.vars.buffs[unit];

    if( not unitBuffs ) then
        return;
    end--if

    if( name and rank and icon ) then
        local buffIndex = strformat( "%s_%s_%s", name, rank, icon );

        if( unitBuffs.index[buffIndex] ) then
            -- index; count, icon, rank
            return unitBuffs.index[buffIndex], unitBuffs.count[buffIndex], unitBuffs.icon[buffIndex], unitBuffs.rank[buffIndex];
        else
            return;
        end--if
    end--if

    for buffIndex in pairs( unitBuffs.index ) do
        if( ( ( not name ) or ( name == unitBuffs.name[buffIndex] ) ) and
            ( ( not rank ) or ( rank == unitBuffs.rank[buffIndex] ) ) and
            ( ( not icon ) or ( icon == unitBuffs.icon[buffIndex] ) ) ) then

            -- index; count, icon, rank
            return unitBuffs.index[buffIndex], unitBuffs.count[buffIndex], unitBuffs.icon[buffIndex], unitBuffs.rank[buffIndex];
        end--if
    end--for
end--lib:UnitHasBuff( unit, name, rank, icon )


function lib:UnitHasDebuff( unit, name, rank, icon )
    local unitDebuffs = self.vars.debuffs[unit];

    if( not unitDebuffs ) then
        return;
    end--if

    if( name and rank and icon ) then
        local debuffIndex = strformat( "%s_%s_%s", name, rank, icon );

        if( unitDebuffs.index[debuffIndex] ) then
            -- index; count, icon, rank
            return unitDebuffs.index[debuffIndex], unitDebuffs.count[debuffIndex], unitDebuffs.icon[debuffIndex], unitDebuffs.rank[debuffIndex];
        else
            return;
        end--if
    end--if

    for debuffIndex, debuffName in pairs( unitDebuffs.name ) do
        if( ( ( not name ) or ( name == debuffName ) ) and
            ( ( not rank ) or ( rank == unitDebuffs.rank[debuffIndex] ) ) and
            ( ( not icon ) or ( icon == unitDebuffs.icon[debuffIndex] ) ) ) then

            -- index; count, icon, rank
            return unitDebuffs.index[debuffIndex], unitDebuffs.count[debuffIndex], unitDebuffs.icon[debuffIndex], unitDebuffs.rank[debuffIndex];
        end--if
    end--for
end--lib:UnitHasDebuff( unit, name, rank, icon )

function lib:UnitHasDebuffType( unit, dispelType )
    local unitDebuffs = self.vars.debuffs[unit];

    if( not unitDebuffs ) then
        return;
    end--if

    for debuffIndex, debuffDispelType in pairs( unitDebuffs.dispelType ) do
        if( debuffDispelType == dispelType ) then
            -- index, count, icon, rank
            return unitDebuffs.index[debuffIndex], unitDebuffs.count[debuffIndex], unitDebuffs.icon[debuffIndex], unitDebuffs.rank[debuffIndex];
        end--if
    end--for
end--lib:UnitHasDebuffType( unit, dispelType )

local cache = setmetatable( {}, { __mode = 'k' } );
local function donothing() end;

local function iter( t )
    local unitBuffs, buffIndex = t.unitBuffs, t.buffIndex;
    local index;

    buffIndex, index = next( unitBuffs.index, buffIndex );
    if( buffIndex ) then
        t.buffIndex = buffIndex;
        -- name, index; count, icon, rank
        return unitBuffs.name[buffIndex], index, unitBuffs.count[buffIndex], unitBuffs.icon[buffIndex], unitBuffs.rank[buffIndex], unitBuffs.duration[buffIndex];
    else
        t.unitBuffs = nil;
        t.buffIndex = nil;
        cache[t] = true;
    end--if
end--function iter( t )
function lib:BuffIter( unit )
    local unitBuffs = self.vars.buffs[unit];
    local buffIndex;

    if( not unitBuffs ) then
        return donothing;
    end--if

    local t = next( cache ) or {};

    cache[t] = nil;
    t.unitBuffs = unitBuffs;

    return iter, t;
end--lib:BuffIter( unit )

local function iter( t )
    local unitDebuffs, debuffIndex = t.unitDebuffs, t.debuffIndex;
    local index;

    debuffIndex, index = next( unitDebuffs.index, debuffIndex );
    if( debuffIndex ) then
        t.debuffIndex = debuffIndex;
        -- name, count, , icon; rank, index
        return unitDebuffs.name[debuffIndex], unitDebuffs.count[debuffIndex], unitDebuffs.dispelType[debuffIndex], unitDebuffs.icon[debuffIndex], unitDebuffs.rank[debuffIndex], index, unitDebuffs.duration[debuffIndex];
    else
        t.unitDebuffs = nil;
        t.debuffIndex = nil;
        cache[t] = true;
    end--if
end--function iter( t )
function lib:DebuffIter( unit )
    local unitDebuffs = self.vars.debuffs[unit];
    local debuffIndex, index;

    if( not unitDebuffs ) then
        return donothing;
    end

    local t = next( cache ) or {};

    cache[t] = nil;
    t.unitDebuffs = unitDebuffs;

    return iter, t;
end--lib:DebuffIter( unit )

lib:RegisterEvent( "UNIT_AURA", "AuraScan");
lib:RegisterEvent( "UNIT_AURASTATE", "AuraScan" );
lib:RegisterBucketEvent( "PLAYER_AURAS_CHANGED", 0.2 ); -- bucketed
lib:RegisterEvent( "PLAYER_TARGET_CHANGED" ); 
lib:RegisterEvent( "PLAYER_FOCUS_CHANGED" );
-- scan the player auras every second; there is no event fired when a player's buff is refreshed by another player, so period scan is necessary
lib:ScheduleRepeatingTimer( "AuraScan", 1, "timer" );
-- scan the player item buffs every 0.2 seconds; there is no event that fires when these are added or removed.
lib:ScheduleRepeatingTimer( "PlayerItemBuffScan", 0.2 );
-- TODO: LibRoster support
lib:RegisterBucketEvent( "PARTY_MEMBERS_CHANGED", 0.2 ); -- bucketed
lib:RegisterBucketEvent( "RAID_ROSTER_UPDATE", 0.2 ); -- bucketed

lib:RegisterEvent( "PLAYER_ENTERING_WORLD", "ScanAllAuras" );
