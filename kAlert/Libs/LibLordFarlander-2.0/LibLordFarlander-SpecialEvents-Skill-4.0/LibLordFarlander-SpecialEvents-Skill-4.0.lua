--[[
Name: LibLordFarlander-SpecialEvents-Skill-4.0
Revision: $Rev: 166 $
Author: LordFarlander
Original Author: Tekkub Stoutwrithe (tekkub@gmail.com)
Website: http://www.wowace.com/
Description: Special events for skills (learned, leveled, unlearned)
Dependencies: LibStub, CallbackHandler-1.0
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

local vmajor, vminor = "LibLordFarlander-SpecialEvents-Skill-4.0", tonumber( ("$Revision: 166 $"):match( "(%d+)" ) ) + 90000;

local lib, oldMinor = LibStub:NewLibrary( vmajor, vminor );
if( not lib ) then
    return;
end

local frame;

if lib.frame then
    frame = lib.frame;
    frame:UnregisterAllEvents();
    frame:SetScript( "OnEvent", nil );
else
    frame = CreateFrame( "Frame", vmajor .. "_Frame" );
    lib.frame = frame;
end

frame:RegisterEvent( "CHAT_MSG_SKILL" );
frame:RegisterEvent( "CHAT_MSG_SYSTEM" );

frame:SetScript("OnEvent",
    function( self, event, ... )
        lib[event]( lib, ... );
    end );

if lib.callbacks then
    lib:UnregisterAll( lib );
else
    lib.callbacks = LibStub( "CallbackHandler-1.0" ):New( lib, nil, nil, "UnregisterAll" );
end

if( not lib.vars ) then
    lib.vars = {};
end

--Create versions of the chat messages that we can use to scan
local SPECIALEVENTS_ERR_SKILL_GAINED_S = ERR_SKILL_GAINED_S:gsub( "%%s", "(.-)" );
local SPECIALEVENTS_ERR_SKILL_UP_SI = ERR_SKILL_UP_SI:gsub( "%%s", "(.-)" ):gsub( "%%1$s", "(.-)" ):gsub( "%%d", "(%%d+)" ):gsub( "%%2$d", "(%%d+)" );
local SPECIALEVENTS_ERR_SPELL_UNLEARNED_S = ERR_SPELL_UNLEARNED_S:gsub( "%%s", "(.-) %%(.-%%)" );

--------------------------------
--      Tracking methods      --
--------------------------------

function lib:CHAT_MSG_SYSTEM( message )
    --Figure out WHICH chat message was just fired and get some useful info about it
    local skillName = message:match( SPECIALEVENTS_ERR_SPELL_UNLEARNED_S );

    if( skillName ) then
        self.callbacks:Fire( "UnlearnedSkill", skillName );
        self.callbacks:Fire( "UnlearnedSkill_" .. skillName );
    end--if
end

function lib:CHAT_MSG_SKILL( message )
    --Figure out WHICH chat message was just fired and get some useful info about it
    local skillName, level;

    skillName = message:match( SPECIALEVENTS_ERR_SKILL_GAINED_S );
    if( skillName ) then
        local skills = self.GetSkillList();

        self.callbacks:Fire( "LearnedSkill", skillName, skills[skillName] );
        self.callbacks:Fire( "LearnedSkill_" .. skillName, skills[skillName] );
    else
        skillName, level = message:match( SPECIALEVENTS_ERR_SKILL_UP_SI );

        if( skillName and level ) then
            level = tonumber( level );
            self.callbacks:Fire( "SkillLeveled", skillName, level );
            self.callbacks:Fire( "SkillLeveled_" .. skillName, level );
        end--if
    end--if
end

function lib.GetSkillList()
    local expandedHeaders = {};
    local skills = {};
    local returnValue = 0;

    for i = 0, GetNumSkillLines(), 1 do
        local skillName, header, isExpanded, _ = GetSkillLineInfo( i );

        if ( header and not isExpanded ) then
            expandedHeaders[i] = skillName;
        end--if
    end--for
    ExpandSkillHeader( 0 );
    for i = 1, GetNumSkillLines(), 1 do
        local skillName, header, _, skillRank = GetSkillLineInfo( i );

        if( skillName and ( not header ) ) then
            skills[skillName] = skillRank;
        end--if
    end--for
    for i = 0, GetNumSkillLines() do
        local skillName, header, isExpanded = GetSkillLineInfo( i );

        for j, name in pairs( expandedHeaders ) do
            if( header and ( skillName == name ) ) then
                CollapseSkillHeader( i );
                expandedHeaders[j] = nil;
            end--if
        end--for
    end--for
    return skills;
end--lib.GetSkillList()

-----------------------------
--      Query methods      --
-----------------------------

function lib:GetSkills()
    return self.GetSkillList();
end--lib:GetSkills()

function lib:GetSkillLevel( skill )
    local skills = self.GetSkillList();

    return skills[skill];
end--lib:GetSkillLevel( skill )
