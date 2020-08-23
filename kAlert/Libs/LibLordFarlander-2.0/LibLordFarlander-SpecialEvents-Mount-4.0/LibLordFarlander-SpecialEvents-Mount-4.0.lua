--[[
Name: LibLordFarlander-SpecialEvents-Mount-4.0
Revision: $Revision: 204 $
Author: LordFarlander
Original Author: Tekkub Stoutwrithe (tekkub@gmail.com)
Website: http://www.wowace.com/
Description: Special events for mounting
Dependencies: LibStub, CallbackHandler-1.0, LibLordFarlander-SpecialEvents-Aura-4.0
]]--

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

local vmajor, vminor = "LibLordFarlander-SpecialEvents-Mount-4.0", tonumber( ("$Revision: 204 $"):match( "(%d+)" ) ) + 90000;

if( not LibStub( "LibLordFarlander-SpecialEvents-Aura-4.0", true ) ) then
    error( vmajor .. " requires LibLordFarlander-SpecialEvents-Aura-4.0" );
    return;
end--if

if( not LibStub( "LibGratuity-3.0", true ) ) then
    error( vmajor .. " requires LibGratuity-3.0" );
    return;
end--if

local lib, oldMinor = LibStub:NewLibrary( vmajor, vminor );
if( not lib ) then
    return;
end--if

local gratuity = LibStub( "LibGratuity-3.0" );

local DEBUG = nil;

local function debug( txt )
    ChatFrame1:AddMessage( "SEEM: " .. txt );
end--debug( txt )

if( not lib.vars ) then
    lib.vars = {};
end--if

if( not lib.strings ) then
    lib.strings = {};
end--if

do
    local locale = GetLocale();
    
    lib.strings.variableMount =
        ( ( locale == "deDE" ) and "Erhöht das Tempo entsprechend Eurer Reitfertigkeit%." ) or
        ( ( locale == "esES" ) and "Aumenta la velocidad según tu habilidad de equitación%." ) or
        ( ( locale == "frFR" ) and "Augmente la vitesse en fonction de votre compétence de monte%." ) or
        ( ( locale == "ruRU" ) and "Скорость повышается в соответствии с навыком верховой езды%." ) or
        "Increases speed according to your Riding skill%."
    
    lib.strings.walkingMount =
        ( ( locale == "deDE" ) and "Langsam und bedächtig%.%.%." ) or
        ( ( locale == "esES" ) and "Lenta pero segura%.%.%." ) or
        ( ( locale == "frFR" ) and "Lentement mais sûrement%.%.%." ) or
        ( ( locale == "ruRU" ) and "Медленно, но верно%.%.%." ) or
        "Slow and steady%.%.%.";
    
    lib.strings.mountSpeed =
        ( ( locale == "deDE" ) and "Erhöht Tempo um (.+)%%" ) or
        ( ( locale == "esES" ) and "Aumenta la velocidad en un (%d+)%%" ) or
        ( ( locale == "frFR" ) and "Augmente la vitesse de (%d+)%%" ) or
        ( ( locale == "koKR" ) and "이동 속도 (%d+)%%만큼 증가" ) or
        ( ( locale == "ruRU" ) and "Скорость увеличена на (%d+)%%" ) or
        ( ( locale == "zhCN" ) and "^速度提高(%d+)%%" ) or
        ( ( locale == "zhTW" ) and "速度提高(%d+)%%" ) or
        "Increases speed by (%d+)%%";
        
    lib.strings.mountSpeed2 =
        ( ( locale == "deDE" ) and "Fluggeschwindigkeit um (%d+)%% erhöht" ) or
        ( ( locale == "esES" ) and "Velocidad de vuelo aumentada un (%d%d%d+)%%" ) or
        ( ( locale == "frFR" ) and "Vitesse de vol augmentée de (%d+)%%" ) or
        ( ( locale == "ruRU" ) and "Скорость полета увеличена на (%d+)%%" ) or
        "Increases ground speed by (%d+)%%";

    lib.strings.mountSpeedPassenger =
        ( ( locale == "deDE" ) and "Bewegungstempo um (%d%d%d+)%% erhöht" ) or
        ( ( locale == "esES" ) and "Aumenta la velocidad de movimiento un (%d+)%%" ) or
        ( ( locale == "frFR" ) and "Augmente la vitesse de déplacement de (%d+)%%" ) or
        ( ( locale == "ruRU" ) and "Скорость передвижения повышена на (%d%d%d+)%%" ) or
        "Increases movement speed by (%d+)%%";
        
    lib.strings.flightSpeed =
        ( ( locale == "deDE" ) and "Fluggeschwindigkeit um (%d+)%% erhöht" ) or
        ( ( locale == "esES" ) and "Aumenta la velocidad de vuelo en un (%d+)%%" ) or
        ( ( locale == "frFR" ) and "Augmente la vitesse de vol de (%d+)%%" ) or
        ( ( locale == "koKR" ) and "비행 속도 (%d+)%%만큼 증가" ) or
        ( ( locale == "ruRU" ) and "Скорость полета увеличена на (%d+)%%" ) or
        ( ( locale == "zhCN" ) and "^飞行速度提高(%d+)%%" ) or
        ( ( locale == "zhTW" ) and "飛行速度提高(%d+)%%" ) or
        "Increases flight speed by (%d+)%%";
        
    lib.strings.flightSpeed2 =
        ( ( locale == "esES" ) and "Velocidad de vuelo aumentada un (%d+)%%" ) or
        ( ( locale == "deDE" ) and "Fluggeschwindigkeit um (%d+)%% erhöht" ) or
        ( ( locale == "frFR" ) and "Vitesse de vol augmentée de (%d+)%%" ) or
        ( ( locale == "ruRU" ) and "Скорость полета увеличена на (%d+)%%" ) or
        "Flight speed increased by (%d+)%%";
        
    lib.strings.flightSpeed3 =
        ( ( locale == "esES" ) and "Velocidad de vuelo aumentada un (%d+)%%" ) or
        ( ( locale == "deDE" ) and "Fluggeschwindigkeit um (%d+)%% erhöht" ) or
        ( ( locale == "frFR" ) and "Vitesse de vol augmentée de (%d+)%%" ) or
        ( ( locale == "ruRU" ) and "Скорость полета увеличена на (%d+)%%" ) or
        "Increases flying speed by (%d+)%%";

    lib.strings.aquaticSpeed =
        ( ( locale == "esES" ) and "Velocidad de nado aumentada un (%d+)%%" ) or
        ( ( locale == "deDE" ) and "Schwimmtempo um (%d+)%% erhöht" ) or
        ( ( locale == "frFR" ) and "Vitesse de nage augmentée de (%d+)%%" ) or
        ( ( locale == "ruRU" ) and "Скорость плавания увеличена на (%d+)%%" ) or
	    "Swim speed increased by (%d+)%%";        
end--do

for buff, i in LibStub( "LibLordFarlander-SpecialEvents-Aura-4.0" ):BuffIter( "player" ) do
    lib:PlayerBuffGained( nil, buff, i );
end--for

if( lib.callbacks ) then
    lib:UnregisterAll( lib );
else
    lib.callbacks = LibStub( "CallbackHandler-1.0" ):New( lib, nil, nil, "UnregisterAll" );
end--if

function lib:PlayerBuffGained( _, buff, i )
    local strings = self.strings;
    local vars = self.vars;
  
    gratuity:SetUnitBuff( "player", i );

    local txt = gratuity:GetLine( 2 );

    if( not txt ) then
        return;
    end--if

    local speed = txt:match( strings.mountSpeed ) or txt:match( strings.mountSpeedPassenger ) or txt:match( strings.mountSpeed2 );
    local mounted = false;

    if( speed ) then
        vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = buff, tonumber( speed ), false, false;
        mounted = true;
    else
        speed = txt:match( strings.flightSpeed ) or txt:match( strings.flightSpeed2 ) or txt:match( strings.flightSpeed3 );
        if( speed ) then
            vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = buff, tonumber( speed ), true, false;
            mounted = true;
        else
            speed = txt:match( strings.aquaticSpeed );
            if( speed ) then
                vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = buff, tonumber( speed ), false, true;
                mounted = true;
            elseif( txt:find( strings.variableMount ) ) then
                vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = buff, -1, false, false;
                mounted = true;
            elseif( txt:find( strings.walkingMount ) ) then
                vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = buff, 0, false, false;
                mounted = true;
            -- this will cause more than one callback sometimes if more than one buff appears at a time
            -- however it will take care of instances where the buff scanning isn't working
            -- also fired when getting off taxi?  need to research this more
            -- elseif( ( not vars.mounted ) and ( IsMounted() ) ) then
                -- vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = true, nil, nil, nil;
                -- mounted = true;
            end--if
        end--if
    end--if
    if( mounted ) then
        lib.callbacks:Fire( "Mounted", vars.mounted, vars.mountspeed, i, vars.flying, vars.aquatic );
        if( DEBUG ) then
            debug( "SpecialEvents_Mounted " .. tostring( vars.mounted ) ..  ", " .. tostring( vars.mountspeed ) ..  ", " .. i ..  ", " .. tostring( vars.flying ) ..  ", " .. tostring( vars.aquatic ) );
        end--if
    end--if
end--lib:PlayerBuffGained( _, buff, i )


function lib:PlayerBuffLost( _, buff )
    local vars = self.vars;

    if( ( type( vars.mounted ) == "number" ) or ( type( vars.mounted ) == "string" ) ) then
        if( buff == vars.mounted ) then
            lib.callbacks:Fire( "Dismounted", vars.mounted, vars.mountspeed, vars.flying, vars.aquatic );
            if( DEBUG ) then
                debug( "SpecialEvents_Dismounted " ..  tostring( vars.mounted ) ..  ", " .. tostring( vars.mountspeed ) ..  ", " .. tostring( vars.flying ) ..  ", " .. tostring( vars.aquatic ) );
            end--if        
            vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = nil, nil, nil, nil;
        end--if
    elseif( type( vars.mounted ) == "boolean" ) then
        if( vars.mounted and ( not IsMounted() ) ) then
            lib.callbacks:Fire( "Dismounted", vars.mounted, vars.mountspeed, vars.flying, vars.aquatic );
            if( DEBUG ) then
                debug( "SpecialEvents_Dismounted " ..  tostring( vars.mounted ) ..  ", " .. tostring( vars.mountspeed ) ..  ", " .. tostring( vars.flying ) ..  ", " .. tostring( vars.aquatic ) );
            end--if        
            vars.mounted, vars.mountspeed, vars.flying, vars.aquatic = nil, nil, nil, nil;
        end--if
    end--if
end--lib:PlayerBuffLost( _, buff )


-----------------------------
--      Query Methods      --
-----------------------------

function lib:PlayerMounted()
    local vars = self.vars;
    
    return vars.mounted, vars.mountspeed, vars.flying, vars.aquatic;
end--lib:PlayerMounted()

function lib:PlayerFlying()
    return self.vars.flying;
end--lib:PlayerFlying()

LibStub( "LibLordFarlander-SpecialEvents-Aura-4.0" ).RegisterCallback( lib, "PlayerBuffGained" );
LibStub( "LibLordFarlander-SpecialEvents-Aura-4.0" ).RegisterCallback( lib, "PlayerBuffLost" );
