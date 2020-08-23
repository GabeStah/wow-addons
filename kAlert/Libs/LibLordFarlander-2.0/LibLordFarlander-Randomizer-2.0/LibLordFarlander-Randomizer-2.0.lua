--[[
Copyright (c) 2009, LordFarlander
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

local MAJOR_VERSION = "LibLordFarlander-Randomizer-2.0";
local MINOR_VERSION = tonumber( ( "$Revision: 152 $" ):match("(%d+)" ) ) + 90000;

local Randomizer, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not Randomizer ) then
    return;
end--if

local LibLordFarlander = LibStub( "LibLordFarlander-2.0", true );
if( not LibLordFarlander ) then
    error( L["%s requires %s"]:format( MAJOR_VERSION, "LibLordFarlander-2.0" ) );
    return;
end--if

local LibLordFarlander_UI = LibStub( "LibLordFarlander-UI-2.0", true );
if( not LibLordFarlander_UI ) then
    error( L["%s requires %s"]:format( MAJOR_VERSION, "LibLordFarlander-2.0" ) );
    return;
end--if

local PetAndMountDatabase = LibStub( "LibLordFarlander-PetAndMountDatabase-1.1", true );
if( not PetAndMountDatabase ) then
    error( L["%s requires %s"]:format( MAJOR_VERSION, "LibLordFarlander-PetAndMountDatabase-1.1" ) );
    return;
end--if

local TR = LibStub( "LibLordFarlander-TableRecycler-1.0", true );
if( not TR ) then
    error( L["%s requires %s"]:format( MAJOR_VERSION, "LibLordFarlander-TableRecycler-1.0" ) );
    return;
end--if

local ItemList = LibStub( "LibLordFarlander-ItemList-2.0", true );
if( not ItemList ) then
    error( L["%s requires %s"]:format( MAJOR_VERSION, "LibLordFarlander-ItemList-2.0" ) );
    return;
end--if

Randomizer.mixinTargets = Randomizer.mixinTargets or {};
local mixins = {
    "RegisterModule",
    "GetModule",
    "GetDefaults",
    "GetModuleArgs",
    "GetAdditionalOptionTables",
    "ScanPlayer",
    "GetRandomFromListWithWeighing",
    "DoCustomEvent",
    "DoCustomEventWithReturn",
    "DoCustomEventWithMultiReturn",
    "CallbackEventHandle",
    "EventHandle",
};

function Randomizer:Embed( target )
    for _, name in pairs( mixins ) do
        target[name] = self[name];
    end--for
    self.mixinTargets[target] = true;
end--Randomizer:Embed( target )

--FUTURE:
--Allow mutliple handlers registered to the same name
--As they register, add them to the list
--Pass a handler class to the message handler functions so that what they do gets passed
--on to ALL the registered handlers

Randomizer.handlers = Randomizer.handlers or {};

function Randomizer:RegisterModuleToHandler( target, name, module, dependencies )
    if( self.handlers[target] ) then
        self.handlers[target]:RegisterModule( name, module, dependencies );
    else
        error( ("Handler %s not found for module %s"):format( target, name ) );
    end--if
end--Randomizer:RegisterModuleToHandler( target, name, module, dependencies )

function Randomizer:RegisterHandler( name, target )
    self.handlers[name] = target;
end--Randomizer:RegisterHandler( name, target )

function Randomizer:CallbackEventHandle( library, event, ... )
    self:EventHandle( library .. ":" .. event, ... );
end--Randomizer:CallbackEventHandle( library, event, ... )

function Randomizer:EventHandle( event, ... )
    if( self == Randomizer ) then
        error( "EventHandle only usable when embedded" );
        return;
    end--if

    local eventRegistery = self.modules.byEvent[event];

    if( type( eventRegistery ) == "table" ) then
		if( event:find( ":" ) ) then
			_, event = strsplit( ":", event );
		end--if
		
        local functionName = ("On%s"):format( tostring( event ) );
        
        for _, module in pairs( eventRegistery ) do
            if( type( module[functionName] ) == "function" ) then
                module[functionName]( module, self, ... );
            end--if
        end--for
	else
	    error( ("Event handler for event %s is wrong type %s"):format( event, type( eventRegistery ) ) );
    end--if
end--Randomizer:EventHandle( event ... )

function Randomizer:RegisterModule( name, module, dependencies )
    if( self == Randomizer ) then
        error( "RegisterModule only usable when embedded" );
        return;
    end--if
    if( type( module ) ~= "table" ) then
        error( "RegisterModule arg2 must be table" );
        return;
    end--if
    if( not self.modules ) then
        self.modules = { moduleList = {}, byEvent = {}, };
	else
	    if( not self.modules.moduleList ) then
		    self.modules.moduleList = {};
		end--if
	    if( not self.modules.byEvent ) then
		    self.modules.byEvent = {};
		end--if		
    end--if
    
    local modules = self.modules;
    local moduleList = modules.moduleList;
    local byEvent = modules.byEvent;
    local dependCheck = "";
    
    module.name = name;
    if( dependencies ) then
        if( type( dependencies ) == "table" ) then
            for _, dependency in pairs( dependencies ) do
                if( not moduleList[dependency] ) then
                    return false;
                end--if
                dependCheck = dependCheck .. (";%s;"):format( dependency );
            end--for
        else
            if( not moduleList[dependencies] ) then
                return false;
            end--if
            dependCheck = dependCheck .. (";%s;"):format( dependencies );
        end--if
    end--if
    moduleList[name] = module;
    if( type( module.events ) == "table" ) then
        for _, event in pairs( module.events ) do
            local insertBefore = 0;
            
            if( not byEvent[event] ) then
                local LibraryName = nil;
				local LibraryEvent = nil;
                
				byEvent[event] = {};
                if( event:find( ":" ) ) then
                    LibraryName, LibraryEvent = strsplit( ":", event );
                end--if
                if( LibraryName ) then
                    local Library = LibStub( LibraryName, true );

                    if( Library ) then
                        Library.RegisterCallback( self, LibraryEvent, "CallbackEventHandle", LibraryName );
                        if( not self.RegisteredCallbackLibraries ) then
                            self.RegisteredCallbackLibraries = {};
                        end--if
                        self.RegisteredCallbackLibraries[LibraryName] = true;
                    end--if
                else
                    self:RegisterEvent( event, "EventHandle" );
                end--if                
            end--if
            -- Make sure module is in list BEFORE dependicies
            -- this will allow it to be called before them by
            -- DoCustomEventWithReturn
            for index, check in pairs( byEvent[event] ) do
                if( dependCheck:find( (";%s;"):format( check.name ) ) ) then
                    insertBefore = index;
                    break;
                end--if
            end--for
            table.insert( byEvent[event], insertBefore, module );
        end--if
    end--if
    return true;
end--Randomizer:RegisterModule( name, module, dependencies )

function Randomizer:GetModule( name )
    if( self == Randomizer ) then
        error( "GetModule only usable when embedded" );
        return;
    end--if
    return( self.modules.moduleList[name] );
end--Randomizer:GetModule( name )

function Randomizer:GetDefaults()
    if( self == Randomizer ) then
        error( "GetDefaults only usable when embedded" );
        return;
    end--if
    
    local defaults = {
        char = {
            FirstSeen = {},                
        },
        profile = {
            BoostNewTime = 86400 * 7, -- 1 week
            Favorites = {},
            ZoneFavorites = {},
            Button = LibLordFarlander_UI.GetButtonSettingsDefaults(),
        },
    };
    
    for _, module in pairs( self.modules.moduleList ) do
        if( type( module.settings ) == "table" ) then
            for _, setting in pairs( module.settings ) do
                 if( ( type( setting ) == "table" ) ) then
                     local location;
                     local variable;
                     local default;
                     
                     if( setting.arg and ( type( setting.arg ) == "table" ) ) then
                         location = setting.arg.Location or "profile";
                         variable = setting.arg.VariableName;
                         default = setting.arg.Default;                         
                     else
                         location = setting.location or "profile";
                         variable = setting.variable;
                         default = setting.default;
                     end--if
                     if( location and variable ) then
                         defaults[location][variable] = default;
                     end--if
                 end--if
            end--if
        end--if
    end--for
    return defaults;
end--Randomizer:GetDefaults()

function Randomizer:GetModuleArgs()
    if( self == Randomizer ) then
        error( "GetModuleArgs only usable when embedded" );
        return;
    end--if
    
    local args = {};

    for modulename, module in pairs( self.modules.moduleList ) do
        if( module.displayname and ( type( module.settings ) == "table" ) ) then
            args[modulename] = {
                type = "group",
                name = module.displayname,
                desc = module.description,
                handler = self,
                args = module.settings,
            };
        end--if
    end--for
    return args;
end--Randomizer:GetModuleArgs()

function Randomizer:GetAdditionalOptionTables()
    if( self == Randomizer ) then
        error( "GetAdditionalOptionTables only usable when embedded" );
        return;
    end--if
    
    local args = {};    
    local additionalOptions = self.modules.byEvent["BuildAdditionalOptions"];
    
    if( additionalOptions ) then
        for _, module in pairs( additionalOptions ) do
            if( module.OnBuildAdditionalOptions ) then
                local options = module:OnBuildAdditionalOptions( self );
                
                for name, option in pairs( options ) do
                    args[name] = option;
                end--for
            end--if
        end--for
    end--if
    return args;
end--Randomizer:GetAdditionalOptionTables()

function Randomizer:ScanPlayer()
    if( self == Randomizer ) then
        error( "ScanPlayer only usable when embedded" );
        return;
    end--if
    
    local dirtyBags = self.dirtyBags;
    local itemLink;
    local reagented;
    local equipmentSlot;
    local ItemInSet = PetAndMountDatabase.ItemInSet;
    local GetItemIDFromLink = LibLordFarlander.GetItemIDFromLink;
    local FirstSeen = self.db.char.FirstSeen;
    local curTime = time();
    local changed = false;
    
    local byEvent = self.modules.byEvent;
    local checkModules = byEvent["CheckItem"];
    local scanModules = byEvent["ScanPlayer"];
    local addModules = byEvent["AddBagItem"];
    local finalizeModules = byEvent["FinalizeBag"];
    local afterModules = byEvent["AfterPlayerScan"];
    local startBagScanModules = byEvent["StartBagScan"];
    local useItem = true;
    
    if( type( scanModules ) == "table" ) then
        for name, module in pairs( scanModules ) do
            if( module.OnScanPlayer ) then 
                changed = module:OnScanPlayer( self, dirtyBags, FirstSeen ) or changed;
            end--if
        end--for
    end--if

    for bag = 0, NUM_BAG_SLOTS do
        if( dirtyBags[bag] ) then
            if( type( startBagScanModules ) == "table" ) then
                for _, module in pairs( startBagScanModules ) do
                    if( module.OnStartBagScan ) then
                        module:OnStartBagScan( self, bag );
                    end--if
                end--for
            end--if
            for slot = 1, GetContainerNumSlots( bag ) do
                itemLink = GetContainerItemLink( bag, slot );

                if( itemLink ) then
                    local itemID = GetItemIDFromLink( itemLink );

                    if( itemID ) then
                        useItem = true;
                        if( type( checkModules ) == "table" ) then
                            for _, module in pairs( checkModules ) do
                                if( module.OnCheckItem ) then
                                    if( not module:OnCheckItem( self, itemID ) ) then
                                        useItem = false;
                                        break;
                                    end--if
                                end--if
                            end--for
                        end--if
                        if( useItem ) then
                            if( type( addModules ) == "table" ) then
                                for _, module in pairs( addModules ) do
                                    if( module.OnAddBagItem ) then
                                        module:OnAddBagItem( self, bag, slot );
                                    end--if
                                end--for
                            end--if
                            if( not FirstSeen[itemID] ) then
                                FirstSeen[itemID] = time();
                            end--if
                        end--if
                    end--if
                end--if
            end--for
            if( type( finalizeModules ) == "table" ) then
                for _, module in pairs( finalizeModules ) do
                    if( module.OnFinalizeBag ) then
                        changed = module:OnFinalizeBag( self, bag ) or changed;
                    end--if
                end--for
            end--if
        end--if
    end--for

    self.dirtyBag = table.wipe( self.dirtyBags );
    
    if( type( afterModules ) == "table" ) then
        for _, module in pairs( afterModules ) do
            if( module.OnAfterPlayerScan ) then 
                module:OnAfterPlayerScan( self );
            end--if
        end--for
    end--if

    return changed;
end--Randomizer:ScanPlayer()

function Randomizer.VerifyRandom( parent, moduleList, itemID )
    if( type( moduleList ) == "table" ) then
        for _, module in pairs( moduleList ) do
            if( module.OnVerifyRandom ) then
                if( not module:OnVerifyRandom( parent, itemID ) ) then
                    return false;
                end--if
            end--if
        end--for
    end--if
    return true;
end--Randomizer.VerifyRandom( parent, moduleList, itemID )

function Randomizer.BoostRandom( parent, moduleList, itemID )
    local returnval = 1.0;
    
    if( type( moduleList ) == "table" ) then
        for _, module in pairs( moduleList ) do
            if( module.OnBoostRandom ) then
                returnval = returnval + module:OnBoostRandom( parent, itemID );
            end--if
        end--for
    end--if
    return returnval;
end--Randomizer.BoostRandom( parent, moduleList, itemID )

function Randomizer:DoCustomEvent( event, ... )
    if( self == Randomizer ) then
        error( "DoCustomEvent only usable when embedded" );
        return;
    end--if
    if( event and type( self.modules.byEvent == "table" ) and self.modules.byEvent[event] ) then
        local functionName = ("On%s"):format( tostring( event ) );
        
        for _, module in pairs( self.modules.byEvent[event] ) do
            if( module[functionName] and ( type( module[functionName] ) == "function" ) ) then
                module[functionName]( module, self, ... );
            end--if
        end--for
    end--if
end--Randomizer:DoCustomEvent( event, ... )

function Randomizer:DoCustomEventWithReturn( event, ... )
    if( self == Randomizer ) then
        error( "DoCustomEventWithReturn only usable when embedded" );
        return;
    end--if
    if( event and type( self.modules.byEvent == "table" ) and self.modules.byEvent[event] ) then
        local functionName = ("On%s"):format( tostring( event ) );
        
        for _, module in pairs( self.modules.byEvent[event] ) do
            if( module[functionName] and ( type( module[functionName] ) == "function" ) ) then
                local returnVal = module[functionName]( module, self, ... );
                
                if( type( returnVal ) ~= "nil" ) then
                    return returnVal;
                end--if
            end--if
        end--for
    end--if
end--Randomizer:DoCustomEventWithReturn( event, ... )

function Randomizer:DoCustomEventWithMultiReturn( event, ... )
    if( self == Randomizer ) then
        error( "DoCustomEventWithMultiReturn only usable when embedded" );
        return;
    end--if
    if( event and type( self.modules.byEvent == "table" ) and self.modules.byEvent[event] ) then
        local functionName = ("On%s"):format( tostring( event ) );
        local returnVal = {};
        
        for name, module in pairs( self.modules.byEvent[event] ) do
            if( module[functionName] and ( type( module[functionName] ) == "function" ) ) then
                returnVal[name] = module[functionName]( module, self, ... );
            end--if
        end--for
        return returnVal;
    end--if
end--Randomizer:DoCustomEventWithMultiReturn( event, ... )

function Randomizer:GetRandomFromListWithWeighing( set, favorites, default )
    if( self == Randomizer ) then
        error( "GetRandomFromListWithWeighing only usable when embedded" );
        return;
    end--if
    if( not default ) then
        default = 1.0;
    end--if
    if( set and ( LibLordFarlander.TableCount( set ) > 1 ) ) then
        local PlayerItemCount = LibLordFarlander.PlayerItemCount;
        local VerifyRandom = Randomizer.VerifyRandom;
        local BoostRandom = Randomizer.BoostRandom;        
        local db = self.db;        
        local profile = db.profile;
        local FindInBags = ItemList.FindInBags;
        local total = 0.0;
        local useset = TR:GetTable();
        local randomValue;
        local amountOfItems = 0;
        local index = 0;
        local item = nil;
        local curTime = time();
        local FirstSeen = db.char.FirstSeen;
        local BoostNew = profile.BoostNew;
        local BoostNewTime = profile.BoostNewTime;
        local tempFavorites = TR:GetTable();
        local verifyModules = self.modules.byEvent["VerifyRandom"];
        local boostModules = self.modules.byEvent["BoostRandom"];        

        for _, item in pairs( set ) do
            local itemID = item:GetID();
            local howOften = ( favorites[itemID] or default ) * BoostRandom( self, boostModules, itemID );
            local BagItem = ( itemID > 0 ) and FindInBags( itemID ) or nil;

            if( ( howOften > 0.0 ) and BoostNew and FirstSeen[itemID] and ( curTime - FirstSeen[itemID] <= BoostNewTime ) ) then
                howOften = howOften + 20.0;
            end--if
            if( ( howOften > 0.0 ) and ( ( itemID < 0 ) or ( PlayerItemCount( itemID ) > 0 ) ) and VerifyRandom( self, verifyModules, itemID ) ) then
                tinsert( useset, item );
                total = total + howOften;
                tempFavorites[itemID] = howOften;
                amountOfItems = amountOfItems + 1;
            else
                tempFavorites[itemID] = 0.0;
            end--if
        end--for
        randomValue = ( math.random() + 0.05 ) * total;
        if( randomValue > total ) then
            randomValue = total;
        end--if
        repeat
            index = index + 1;
            item = useset[index];
            if( item ) then
                randomValue = randomValue - tempFavorites[item:GetID()];
            end--if
        until ( not item ) or ( randomValue <= 0 ) or ( index >= amountOfItems );
        table.wipe( useset );
        TR:ReturnTable( useset );
        TR:ReturnTable( tempFavorites );
        return item;
    else
        for _, item in pairs( set ) do
            return item;
        end--if
    end--if
end--Randomizer:GetRandomFromListWithWeighing( set, favorites, default )

--Ace3 style upgrade check
for target, _ in pairs( Randomizer.mixinTargets ) do
    Randomizer:Embed( target );
end--for
