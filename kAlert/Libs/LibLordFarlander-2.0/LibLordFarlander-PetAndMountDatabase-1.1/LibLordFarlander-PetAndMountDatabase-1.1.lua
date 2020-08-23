--[[
    Database of all minipets and mounts
    $Revision: 196 $
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

local MAJOR_VERSION = "LibLordFarlander-PetAndMountDatabase-1.1";
local MINOR_VERSION = tonumber( ( "$Revision: 196 $" ):match("(%d+)" ) ) + 90000;

local LibPetAndMountDatabase, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not LibPetAndMountDatabase ) then
    return;
end--if

if( not LibPetAndMountDatabase.FoundSets ) then
    LibPetAndMountDatabase.FoundSets = {};
end--if    
if( not LibPetAndMountDatabase.SubSets ) then
    LibPetAndMountDatabase.SubSets = {};
end--if

local LibPeriodicTable = LibStub( "LibPeriodicTable-3.1", true );
if( not LibPeriodicTable ) then
    error( MAJOR_VERSION .. " requires LibPeriodicTable-3.1" );
end--if

local TR = LibStub( "LibLordFarlander-TableRecycler-1.0", true );
if( not TR ) then
    error( MAJOR_VERSION .. " requires LibLordFarlander-TableRecycler-1.0" );
    return;
end--if

--[[
    Value meanings:
    
    Mounts.*: Maximum speed increase over running in percent, where running is 100%
    MiniPets.Reagented: ItemID of item needed to summon (snowball)
    MiniPets.Quest: QuestID of quest item is used for
    MiniPets.Equipment: SlotName of slot the equipment goes in
    
    Negative number is a SPELL instead of an ITEM
]]--

function LibPetAndMountDatabase.NormalizeSetName( set )
    if( set:find( "PetAndMountDatabase." ) ~= 1 ) then
        set = "PetAndMountDatabase." .. set;
    end--if
    if( set == "PetAndMountDatabase.MiniPets.Holiday" ) then
        set = "PetAndMountDatabase.Critters.Reagented.Snowball";
    end--if
    return set;
end--LibPetAndMountDatabase.NormalizeSetName( set )

function LibPetAndMountDatabase:HasSet( set, normalize )
    local sets = LibPeriodicTable.sets;

    if( ( normalize == true ) or ( normalize == nil ) ) then
        set = self.NormalizeSetName( set );
    end--if
    if( self.FoundSets[set] ) then
        return true;
    end--if
    for setName, _ in pairs( sets ) do
        if( setName:find( set ) == 1 ) then
            self.FoundSets[set] = true;
            return true;
        end--if
    end--if
    return false;
end--LibPetAndMountDatabase:HasSet( set, normalize )

function LibPetAndMountDatabase:GetSubsets( set, normalize )
    local sets = LibPeriodicTable.sets;

    if( ( normalize == true ) or ( normalize == nil ) ) then
        set = self.NormalizeSetName( set );
    end--if
    if( self.SubSets[set] ) then
        return self.SubSets[set];
    end--if
    set = set .. ".";
    for setName, _ in pairs( sets ) do
        local start, ends = setName:find( set );

        if( ( start == 1 ) and ( ends ~= setName:len() ) ) then
            setName = setName:sub( ends + 1 );
            if( setName:find( "." ) ) then
                setName = ("%s%s"):format( set, strsplit( ".", setName ) );
            end--if
            if( self.SubSets[set] == nil ) then
                self.SubSets[set] = {};
            end--if
            self.SubSets[set][setName] = setName;
        end--if
    end--if
    return self.SubSets[set];
end--LibPetAndMountDatabase:GetSubsets( set, normalize )

function LibPetAndMountDatabase:ItemInSet( item, set, normalize )
    if( item == nil ) then
        return false;
    end--if
    if( ( normalize == true ) or ( normalize == nil ) ) then
        set = self.NormalizeSetName( set );
    end--if
    return LibPeriodicTable:ItemInSet( item, set );
end--LibPetAndMountDatabase:ItemInSet( item, set, normalize )

function LibPetAndMountDatabase:SpellInSet( spellID, set, normalize )
    if( spellID == nil ) then
        return false;
    end--if
    if( spellID > 0 ) then
        spellID = spellID * -1;
    end--if
    return self:ItemInSet( spellID, set, normalize );
end--LibPetAndMountDatabase:SpellInSet( item, set )

function LibPetAndMountDatabase:IterateSet( set, normalize )
    if( ( normalize == true ) or ( normalize == nil ) ) then
        set = self.NormalizeSetName( set, normalize );
    end--if
    return LibPeriodicTable:IterateSet( set );
end--LibPetAndMountDatabase:IterateSet( set, normalize )

function LibPetAndMountDatabase:GetMountAttributes( value )
    local groundSpeed, swimSpeed, flySpeed, passengers, skills = strsplit( "|", value );

    if( skills ) then
        local skillString = skills;
        
        skills = {};
        for _, skill in pairs( { strsplit( ";", skillString ) } ) do
            local skillName, value = skill:sub( 1, 1 ), tonumber( skill:sub( 2 ) );
            
            if( skillName == "R" ) then
                skillName = "Riding";
            elseif( skillName == "E" ) then
                skillName = "Engineering";
            elseif( skillName == "T" ) then
                skillName = "Tailoring";
            elseif( skillName == "N" ) then
                skillName = "Enchanting";
            elseif( skillName == "B" ) then
                skillName = "Blacksmithing";
            elseif( skillName == "A" ) then
                skillName = "Alchemy";
            elseif( skillName == "J" ) then
                skillName = "Jewelcrafting";
            elseif( skillName == "M" ) then
                skillName = "Mining";
            elseif( skillName == "H" ) then
                skillName = "Herbalism";
            elseif( skillName == "L" ) then
                skillName = "Leatherworking";
            elseif( skillName == "S" ) then
                skillName = "Skinning";
            elseif( skillName == "I" ) then
                skillName = "Inscription";
            elseif( skillName == "C" ) then
                skillName = "Cooking";
            elseif( skillName == "+" ) then
                skillName = "First Aid";
            elseif( skillName == "F" ) then
                skillName = "Fishing";
            elseif( skillName == "Y" ) then
                skillName = "Archeology";
            end--if
            skills[skillName] = value;
        end--if
    end--if

    return groundSpeed and tonumber( groundSpeed ) or 100, swimSpeed and tonumber( swimSpeed ) or 100, flySpeed and tonumber( flySpeed ) or 0,
        passengers and tonumber( passengers ) or 1, skills;
end--LibPetAndMountDatabase:GetMountAttributes( value )

function LibPetAndMountDatabase:GetPlayersCompanions( ctype )
    local returnList = TR:GetTable();

    for i = 1, GetNumCompanions( ctype ) do
        local creatureID, creatureName, creatureSpellID, creatureIcon, _ = GetCompanionInfo( ctype, i );

        returnList[i] = TR:GetTable( "spellID", creatureSpellID, "icon", creatureIcon, "modelID", creatureID, "name", creatureName );
    end--for
    return returnList;
end--LibPetAndMountDatabase:GetPlayersCompanions( ctype )

function LibPetAndMountDatabase:IsCompanionType( companionName, ctype )
    for i = 1, GetNumCompanions( ctype ) do
        if( select( 2, GetCompanionInfo( ctype, i ) ) == companionName ) then
            return true;
        end--if
    end--for
    return false;
end--LibPetAndMountDatabase:IsCompanionType( companionName, ctype )

function LibPetAndMountDatabase:GetSummonedCompanionIndex( ctype )
    for i = 1, GetNumCompanions( ctype ) do
        if( select( 5, GetCompanionInfo( ctype, i ) ) ) then
            return i;
        end--if
    end--for
    return nil;
end--LibPetAndMountDatabase:GetSummonedCompanionIndex( ctype )

function LibPetAndMountDatabase:FindCompanion( ctype, spellID )
    if( spellID and ( spellID < 0 ) ) then
        spellID = spellID * -1;
    end--if
    if( spellID ) then
        for i = 1, GetNumCompanions( ctype ) do
            if( select( 3, GetCompanionInfo( ctype, i ) ) == spellID ) then
                return i;
            end--if
        end--for
    end--if
    return nil;
end--LibPetAndMountDatabase:FindCompanion( ctype, spellID )
