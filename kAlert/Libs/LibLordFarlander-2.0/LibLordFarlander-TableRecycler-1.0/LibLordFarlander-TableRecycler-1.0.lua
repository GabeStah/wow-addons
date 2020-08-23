--[[
    Table recycling
    $Revision: 141 $
]]--

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

local vmajor, vminor = "LibLordFarlander-TableRecycler-1.0", tonumber( ( "$Revision: 141 $" ):match( "(%d+)" ) ) + 90000;

local lib, oldMinor = LibStub:NewLibrary( vmajor, vminor );

if( not lib ) then
    return;
end--if

if( not lib.tablelist ) then
    lib.tablelist = {};
end--if

function lib:GetTable( ... )
    local usetable = table.remove( self.tablelist );

    if( not usetable ) then
        usetable = {};
    end--if
    for i = 1, select( "#", ... ), 2 do
        usetable[select( i, ... )] = select( i + 1, ... );
    end--for
    return usetable;
end--lib:GetTable()

function lib:ReturnTable( tableret )
    if( tableret ) then
        for i, v in pairs( tableret ) do
            if( type( v ) == "table" ) then
                self:ReturnTable( v );
            end--if
        end--for
        table.insert( self.tablelist, table.wipe( tableret ) );
    end--if
end--lib:ReturnTable( tableret )

function lib.ClearTable( tableret )
    for i, v in pairs( tableret ) do
        if( type( v ) == "table" ) then
            lib.ClearTable( v );
        else
            tableret[i] = nil;
        end--if
    end--for
end--lib:ReturnTable( tableret )

