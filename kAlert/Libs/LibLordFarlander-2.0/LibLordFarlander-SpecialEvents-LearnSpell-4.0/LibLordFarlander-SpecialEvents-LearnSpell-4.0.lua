--[[
Name: LibLordFarlander-SpecialEvents-LearnSpell-4.0
Revision: $Rev: 166 $
Author: LordFarlander
Original Author: Tekkub Stoutwrithe (tekkub@gmail.com)
Website: http://www.wowace.com/
Description: Special events for learning spells and companions
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

local vmajor, vminor = "LibLordFarlander-SpecialEvents-LearnSpell-4.0", tonumber( ("$Revision: 166 $"):match( "(%d+)" ) ) + 90000;

local lib, oldMinor = LibStub:NewLibrary( vmajor, vminor );

if( not lib ) then
    return;
end--if

local SPECIALEVENTS_LEARN_COMPANION_S = ERR_LEARN_COMPANION_S:gsub( "%%s", "(.-)" ) or nil;
local frame;

if( lib.frame ) then
    frame = lib.frame;
    frame:UnregisterAllEvents();
    frame:SetScript( "OnEvent", nil );
else
    frame = CreateFrame( "Frame", vmajor .. "_Frame" );
    lib.frame = frame;
end--if

frame:RegisterEvent( "SPELLS_CHANGED" );
frame:RegisterEvent( "CHAT_MSG_SYSTEM" );

frame:SetScript( "OnEvent", function( self, event, ... )
        lib[event]( lib, ... );
    end );

if( lib.callbacks ) then
    lib:UnregisterAll( lib );
else
    lib.callbacks = LibStub( "CallbackHandler-1.0" ):New( lib, nil, nil, "UnregisterAll" );
end--if

if( not lib.vars ) then
    lib.vars = {};
end--if

--------------------------------
--      Tracking methods      --
--------------------------------

function lib:CHAT_MSG_SYSTEM( message )
    --Figure out WHICH chat message was just fired and get some useful info about it
    local companionName = message:match( SPECIALEVENTS_LEARN_COMPANION_S );

    if( companionName ) then
        self.callbacks:Fire( "LearnedCompanion", companionName );
    end--if
end--lib:CHAT_MSG_SYSTEM( message )

function lib:SPELLS_CHANGED()
    local newsp, oldsp = self:GetSpellList(), self.vars.spells;

    for spell, rank in pairs( newsp ) do
        if( oldsp[spell] ~= rank ) then
            self.callbacks:Fire( "LearnedSpell", spell, rank );
        end--if
    end--for

    for i in pairs( oldsp ) do
        oldsp[i] = nil;
    end--for
    self.vars.empty = oldsp;
    self.vars.spells = newsp;
end--lib:SPELLS_CHANGED()

function lib:GetSpellList()
    local i, rt = 1, self.vars.empty or {};

    self.vars.empty = nil;

    repeat
        local sname, srank = GetSpellName( i, BOOKTYPE_SPELL );

        if( sname ) then
            rt[sname] = srank;
        end--if
        i = i + 1;
        if( sname ) then
            self.vars.allspells[ sname .. srank ] = true;
        end--if
    until not GetSpellName( i, BOOKTYPE_SPELL );

    return rt;
end--lib:GetSpellList()

-----------------------------
--      Query methods      --
-----------------------------

function lib:GetSpells()
    return self.vars.spells;
end--lib:GetSpells()

function lib:SpellKnown( spell, rank )
    if( not rank ) then
        return self.vars.spells[spell];
    end--if
    return self.vars.allspells[spell .. rank];
end--lib:SpellKnown( spell, rank )

if( not lib.vars.allspells ) then
    lib.vars.allspells = {};
    lib.vars.spells = lib:GetSpellList();
end--if
