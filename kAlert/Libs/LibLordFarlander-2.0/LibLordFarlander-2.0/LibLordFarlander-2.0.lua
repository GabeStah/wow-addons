--[[
    Helper functions
    $Revision: 187 $
]]--

--[[
Copyright (c) 2008, LordFarlander
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

local MAJOR_VERSION = "LibLordFarlander-2.0";
local MINOR_VERSION = tonumber( ("$Revision: 187 $"):match( "(%d+)" ) ) + 90000

local LibLordFarlander, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not LibLordFarlander ) then
    return;
end--if

local gratuity = LibStub( "LibGratuity-3.0", true );
local TR = LibStub( "LibLordFarlander-TableRecycler-1.0", true );
local Z = LibStub( "LibBabble-Zone-3.0", true );

if( Z ) then
    Z = Z:GetLookupTable();
end--if

LibLordFarlander.Kalimdor = 1
LibLordFarlander.EasternKingdoms = 2;
LibLordFarlander.Outland = 3;
LibLordFarlander.Northrend = 4;
LibLordFarlander.FlyableZones = {
    [LibLordFarlander.Outland] = nil,
    [LibLordFarlander.Northrend] = nil,
};
LibLordFarlander.UnderwaterZones = {}; -- Future for 4.0
LibLordFarlander.ColdWeatherFlying = 54197;
LibLordFarlander.FlyableZones_Checks = {
    [LibLordFarlander.Northrend] = function()
              return LibLordFarlander.HasPlayerSpell( LibLordFarlander.ColdWeatherFlying );
          end,
};
LibLordFarlander.NoFlyCheck = {
    [-1] = Z["Dalaran"],
};

-- Notes:
-- Checks if an item is soulbound or quest
-- Arguments:
--     number - bag the item is in
--     number - slot the item is in
-- Returns:
-- * boolean - if the item given is soulbound
function LibLordFarlander.ItemIsSoulbound( bag, slot )
    if( gratuity ) then
        local strings;

        gratuity:SetBagItem( bag, slot );
        strings = gratuity:GetText( 2, 4, false, true );
        if( strings ) then
            for _, text in pairs( strings ) do
                text = text[1];
                if( ( text == ITEM_SOULBOUND ) or ( text == ITEM_BIND_QUEST ) ) then
                    return true;
                end--if
            end--for
        end--if
    end--if
    return false;
end--LibLordFarlander.ItemIsSoulbound( bag, slot )

function LibLordFarlander.PlayerItemCount( item )
    local _, itemLink, _, _, _, _, _, _, _, _ = GetItemInfo( item );

    if( itemLink ~= nil ) then
        return GetItemCount( itemLink );
    end--if
    return 0;
end--LibLordFarlander.PlayerItemCount( item )

-- Notes:
-- Gets an item string from a link
-- Arguments:
--     string - a link, can be any type of link
-- Returns:
-- * string - the item string from the link
function LibLordFarlander.GetItemStringFromLink( itemLink )
    if( type( itemLink ) == "string" ) then
        return itemLink:match( "^|c%x+|H(.+)|h%[.+%]" );
    end--if
    return nil;
end--LibLordFarlander.GetItemStringFromLink( itemLink )

function LibLordFarlander.IsFlyableZone( zone, noRequirementsCheck )
    if( Z ) then
        for i, zonec in pairs( LibLordFarlander.NoFlyCheck ) do
            if( i < 0 ) then
                if( ( zone == zonec ) and ( not noRequirementsCheck ) ) then
                    return false;
                end--if
            else
                if( zone == zonec ) then
                    return false;
                end--if
            end--if
        end--for
    end--if
    if( LibLordFarlander.GetTOCVersion() >= 40000 ) then
        if( not LibLordFarlander.FlyableZones[LibLordFarlander.Kalimdor] ) then
            LibLordFarlander.FlyableZones[LibLordFarlander.Kalimdor] = table.concat( { GetMapZones( LibLordFarlander.Kalimdor ) }, "|" );
        end--if    
        if( not LibLordFarlander.FlyableZones[LibLordFarlander.EasternKingdoms] ) then
            LibLordFarlander.FlyableZones[LibLordFarlander.EasternKingdoms] = table.concat( { GetMapZones( LibLordFarlander.EasternKingdoms ) }, "|" );
        end--if
    end--if
    if( not LibLordFarlander.FlyableZones[LibLordFarlander.Outland] ) then
        LibLordFarlander.FlyableZones[LibLordFarlander.Outland] = table.concat( { GetMapZones( LibLordFarlander.Outland ) }, "|" ) .. "|" .. Z["Twisting Nether"];
    end--if
    if( not LibLordFarlander.FlyableZones[LibLordFarlander.Northrend] ) then
        LibLordFarlander.FlyableZones[LibLordFarlander.Northrend] = table.concat( { GetMapZones( LibLordFarlander.Northrend ) }, "|" ) .. "|" .. Z["The Frozen Sea"];
    end--if
    for i, zones in pairs( LibLordFarlander.FlyableZones ) do
        if( zones:find( zone ) and ( noRequirementsCheck or ( not LibLordFarlander.FlyableZones_Checks[i] ) or LibLordFarlander.FlyableZones_Checks[i]() ) ) then
            return true;
        end--if
    end--if
    return false;
end--LibLordFarlander.IsFlyableZone( zone )

-- Notes:
-- Determines if the player is in a zone where flying is allowed
-- Returns:
-- * boolean - whether or not the player is in a zone where flying is allowed
function LibLordFarlander.IsInFlyableZone()
    return LibLordFarlander.IsFlyableZone( GetRealZoneText() );
end--LibLordFarlander.IsInFlyableZone()

-- Notes:
-- Gets an ID from a string
-- Arguments:
--     string - a string
-- Returns:
-- * number - the ID from the string
function LibLordFarlander.GetItemIDFromString( itemID )
    if( type( itemID ) == "string" ) then
        return tonumber( itemID:match( "(%d+)" ) );
    end--if
    return nil;
end--LibLordFarlander.GetItemIDFromString( itemID )

-- Notes:
-- Gets an ID from a link
-- Arguments:
--     string - a link, can be any type
-- Returns:
-- * number - the ID from the link
function LibLordFarlander.GetItemIDFromLink( itemLink )
    if( type( itemLink ) == "string" ) then
        return LibLordFarlander.GetItemIDFromString( LibLordFarlander.GetItemStringFromLink( itemLink ) );
    end--if
    return nil;
end--LibLordFarlander.GetItemIDFromLink( itemLink )

-- Notes:
-- Gets an item string from an ID
-- Arguments:
--     number - an item ID
-- Returns:
-- * string - the string from the ID
function LibLordFarlander.GetItemString( itemID )
    return LibLordFarlander.GetItemStringFromLink( LibLordFarlander.GetItemLink( itemID ) );
end--LibLordFarlander.GetItemString( itemID )

-- Notes:
-- Gets an item link from and ID
-- Arguments:
--     number - an item ID
-- Returns:
-- * string - the link from the ID
function LibLordFarlander.GetItemLink( itemID )
    return select( 2, GetItemInfo( itemID ) );
end--LibLordFarlander.GetItemLink( itemID )

-- Notes:
-- Checks to see if the player has a spell
-- Arguments:
--     number, string - A spell ID or spell link
-- Returns:
-- * boolean - whether or not the player has the spell
function LibLordFarlander.HasPlayerSpell( spell )
    local spellName = GetSpellInfo( spell );

    if( spellName ) then
        return GetSpellLink( spell ) == GetSpellLink( spellName );
    end
    return false;
end--LibLordFarlander.PlayerHasSpell( spell )

-- Notes:
-- Deep copies a table to another table
-- Arguments:
--     table - Destination table (MUST already be a table)
--     table - Source table
function LibLordFarlander.CopyTable( to, from )
    for i, v in pairs( from ) do
        if( type( v ) == "table" ) then
            to[i] = TR and TR:GetTable() or {};
            LibLordFarlander.CopyTable( to[i], v );
        else
            to[i] = v;
        end--if
    end--for
end--LibLordFarlander.CopyTable( to, from )

function LibLordFarlander.AppendTable( to, from )
    for _, v in pairs( from ) do
        table.insert( to, v );
    end--for
end--LibLordFarlander.AppendTable( to, from )

-- #nodef
function LibLordFarlander.SimpleCompareTables( table1, table2 )
    if( table1 and table2 and ( type( table1 ) == "table" ) and ( type( table2 ) == "table" ) ) then
        for i, v in pairs( table1 ) do
            if( type( v ) == "table" ) then
                if( type( table2[i] ) == "table" ) then
                    if( not LibLordFarlander.SimpleCompareTables( v, table2[i] ) ) then
                        return false;
                    end--if
                else
                    return false;
                end--if
            elseif( table2[i] ~= v ) then
                return false;
            end--if
        end--for
    else
        return false;
    end--if
    return true;
end--LibLordFarlander.SimpleCompareTables( table1, table2 )

function LibLordFarlander.TableCount( t )
    local val = 0;

    for i, _ in pairs( t ) do
        val = val + 1;
    end--for
    return val;
end--LibLordFarlander.TableCount( t )

function LibLordFarlander.HasTableMembers( t )
    for i, _ in pairs( t ) do
        return true;
    end--for
    return false;
end--LibLordFarlander.HasTableMember( t )

-- Notes:
-- Compares two tables to see if they have all the same members and the values are the same
-- Arguments:
--     table - First table to compare
--     table - Second table to compare
-- Returns:
-- * boolean - whether or not the tables are exactly alike
function LibLordFarlander.CompareTables( table1, table2 )
    return LibLordFarlander.SimpleCompareTables( table1, table2 ) and LibLordFarlander.SimpleCompareTables( table2, table1 );
end--LibLordFarlander.CompareTables( table1, table2 )

-- Notes:
-- Debug message printing, suitable for including in your addon's class.
-- Set your addon's DEBUG member to true to print.
-- Arguments:
--     addon - The addon object
--     string - The message to print
function LibLordFarlander.dprint( addon, msg )
    if( addon.DEBUG ) then
        DEFAULT_CHAT_FRAME:AddMessage( msg, 1.0, 0.0, 0.0 );
    end--if
end--LibLordFarlander.dprint( addon, msg )

function LibLordFarlander.round( num, idp )
    local mult = 10 ^ ( idp or 0 );

    return math.floor( num * mult + 0.5 ) / mult;
end--LibLordFarlander.round( num, idp )

function LibLordFarlander.GetTOCVersion()
    return tonumber( select( 4, GetBuildInfo() ) );
end--LibLordFarlander.GetTOCVersion()

function LibLordFarlander.GetMapZonesWithExtra( continent, bMountableOnly )
    local mapzones = { GetMapZones( continent ) };

    if( Z ) then
        if( continent == LibLordFarlander.EasternKingdoms ) then -- Eastern Kingdoms
            tinsert( mapzones, Z["Alterac Valley"] );
            tinsert( mapzones, Z["Arathi Basin"] );
            tinsert( mapzones, Z["Zul'Gurub"] );
            tinsert( mapzones, Z["Ruins of Lordaeron"] );
            if( not bMountableOnly ) then
                tinsert( mapzones, Z["Blackrock Depths"] );
                tinsert( mapzones, Z["Blackrock Spire"] );
                tinsert( mapzones, Z["The Deadmines"] );
                tinsert( mapzones, Z["Deeprun Tram"] );
                tinsert( mapzones, Z["Gnomeregan"] );
                tinsert( mapzones, Z["Lower Blackrock Spire"] );
                tinsert( mapzones, Z["Magisters' Terrace"] );
                tinsert( mapzones, Z["Molten Core"] );
                tinsert( mapzones, Z["Onyxia's Lair"] );
                tinsert( mapzones, Z["Scarlet Monastery"] );
                tinsert( mapzones, Z["Scholomance"] );
                tinsert( mapzones, Z["Shadowfang Keep"] );
                tinsert( mapzones, Z["Stratholme"] );
                tinsert( mapzones, Z["Sunwell Plateau"] );
                tinsert( mapzones, Z["The Stockade"] );
                tinsert( mapzones, Z["The Temple of Atal'Hakkar"] );
                tinsert( mapzones, Z["Uldaman"] );
                tinsert( mapzones, Z["Upper Blackrock Spire"] );
                tinsert( mapzones, Z["Zul'Aman"] );
            end--if
        elseif( continent == LibLordFarlander.Kalimdor ) then -- Kalimdor
            tinsert( mapzones, Z["Hyjal Summit"] );
            tinsert( mapzones, Z["Old Hillsbrad Foothills"] );
            tinsert( mapzones, Z["Ahn'Qiraj"] );
            tinsert( mapzones, Z["The Black Morass"] );
            tinsert( mapzones, Z["The Ring of Valor"] );
            tinsert( mapzones, Z["Warsong Gulch"] );
            tinsert( mapzones, Z["Ruins of Ahn'Qiraj"] );
            tinsert( mapzones, Z["The Culling of Stratholme"] );
            if( not bMountableOnly ) then
                tinsert( mapzones, Z["Blackfathom Deeps"] );
                tinsert( mapzones, Z["Dire Maul"] );
                tinsert( mapzones, Z["Maraudon"] );
                tinsert( mapzones, Z["Ragefire Chasm"] );
                tinsert( mapzones, Z["Razorfen Downs"] );
                tinsert( mapzones, Z["Razorfen Kraul"] );
                tinsert( mapzones, Z["Wailing Caverns"] );
            end--if
        elseif( continent == LibLordFarlander.Outland ) then -- Outland
            tinsert( mapzones, Z["Eye of the Storm"] );
            tinsert( mapzones, Z["Nagrand Arena"] );
            tinsert( mapzones, Z["Twisting Nether"] );
            tinsert( mapzones, Z["Blade's Edge Arena"] );
            if( not bMountableOnly ) then
                tinsert( mapzones, Z["The Arcatraz"] );
                tinsert( mapzones, Z["Auchenai Crypts"] );
                tinsert( mapzones, Z["Black Temple"] );
                tinsert( mapzones, Z["Gruul's Lair"] );
                tinsert( mapzones, Z["Hellfire Ramparts"] );
                tinsert( mapzones, Z["Magtheridon's Lair"] );
                tinsert( mapzones, Z["Mana-Tombs"] );
                tinsert( mapzones, Z["The Mechanar"] );
                tinsert( mapzones, Z["Serpentshrine Cavern"] );
                tinsert( mapzones, Z["Sethekk Halls"] );
                tinsert( mapzones, Z["Shadow Labyrinth"] );
                tinsert( mapzones, Z["The Blood Furnace"] );
                tinsert( mapzones, Z["The Botanica"] );
                tinsert( mapzones, Z["The Eye"] );
                tinsert( mapzones, Z["The Shattered Halls"] );
                tinsert( mapzones, Z["The Slave Pens"] );
                tinsert( mapzones, Z["The Steamvault"] );
                tinsert( mapzones, Z["The Underbog"] );
            end--if
        elseif( continent == LibLordFarlander.Northrend ) then -- Northrend
            tinsert( mapzones, Z["Strand of the Ancients"] );
            tinsert( mapzones, Z["The Frozen Sea"] );
            tinsert( mapzones, Z["Isle of Conquest"] );
            tinsert( mapzones, Z["Dalaran Sewers"] );
            tinsert( mapzones, Z["The Oculus"] );
            tinsert( mapzones, Z["Ulduar"] );
            tinsert( mapzones, Z["Trial of the Champion"] );
            tinsert( mapzones, Z["Trial of the Crusader"] );
            if( not bMountableOnly ) then
                tinsert( mapzones, Z["Ahn'kahet: The Old Kingdom"] );
                tinsert( mapzones, Z["Azjol-Nerub"] );
                tinsert( mapzones, Z["Drak'Tharon Keep"] );
                tinsert( mapzones, Z["Gundrak"] );
                tinsert( mapzones, Z["Halls of Stone"] );
                tinsert( mapzones, Z["Halls of Lightning"] );
                tinsert( mapzones, Z["Icecrown Citadel"] );
                tinsert( mapzones, Z["Naxxramas"] );
                tinsert( mapzones, Z["The Eye of Eternity"] );
                tinsert( mapzones, Z["The Nexus"] );
                tinsert( mapzones, Z["The Obsidian Sanctum"] );
                tinsert( mapzones, Z["Utgarde Keep"] );
                tinsert( mapzones, Z["Utgarde Pinnacle"] );
                tinsert( mapzones, Z["The Violet Hold"] );
                tinsert( mapzones, Z["Vault of Archavon"] );
                tinsert( mapzones, Z["The Forge of Souls"] );
                tinsert( mapzones, Z["Pit of Saron"] );
                tinsert( mapzones, Z["Halls of Reflection"] );
--                tinsert( mapzones, Z["The Ruby Sanctum"] );
            end--if
        end--if
    end--if
    return mapzones;
end--LibLordFarlander.GetMapZonesWithExtra( continent )

function LibLordFarlander.NamifyString( str )
    local returnString = str:gsub( "([%c%s%p])", function( input ) return ("_%03i"):format( strbyte( input ) ) end );

    return returnString;
end--LibLordFarlander.NamifyString( str )

function LibLordFarlander.UnnamifyString( str )
    local returnString = str:gsub( "_(%d%d%d)", function( input ) return strchar( tonumber( input ) ) end );
    
    return returnString;
end--LibLordFarladner.UnnamifyString( str )
