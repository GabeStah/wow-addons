--[[
    Helper functions
    $Revision: 180 $
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

local MAJOR_VERSION = "LibLordFarlander-ItemList-2.0";
local MINOR_VERSION = tonumber( ("$Revision: 180 $"):match( "(%d+)" ) ) + 90000;

local LibLordFarlander = LibStub( "LibLordFarlander-2.0", true );
if( not LibLordFarlander ) then
    error( MAJOR_VERSION .. " requires LibLordFarlander-2.0" );
    return;
end--if

local TR = LibStub( "LibLordFarlander-TableRecycler-1.0", true );
if( not TR ) then
    error( MAJOR_VERSION .. " requires LibLordFarlander-TableRecycler-1.0" );
    return;
end--if

local LibLordFarlander_UI = LibStub( "LibLordFarlander-UI-2.0", true );

local LibLordFarlander_ItemList, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not LibLordFarlander_ItemList ) then
    return;
end--if

local function GetName_Spell( item )
    return select( 1, GetSpellInfo( item.spellID ) );
end--GetName_Spell( item )

local function GetName_InventoryItem( item )
    return select( 1, GetItemInfo( GetInventoryItemLink( "player", item.invslot ) ) );
end--GetName_Spell( item )

local function GetName_Item( item )
    return select( 1, GetItemInfo( GetItemInfo( item.itemID ) ) );
end--GetName_Spell( item )

local function GetName_BagItem( item )
    return select( 1, GetItemInfo( GetContainerItemLink( item.bag, item.slot ) ) );
end--GetName_BagItem( item )

local function GetLink_Spell( item )
    return GetSpellLink( item.spellID );
end--GetLink_Spell( item )

local function GetLink_InventoryItem( item )
    return GetInventoryItemLink( "player", item.invslot );
end--GetLink_Spell( item )

local function GetLink_Item( item )
    return LibLordFarlander.GetItemLink( item.itemID );
end--GetLink_Spell( item )

local function GetLink_BagItem( item )
    return GetContainerItemLink( item.bag, item.slot );
end--GetLink_Spell( item )

function LibLordFarlander_ItemList.BuildBasicItem()
    return TR:GetTable( "GetName", LibLordFarlander_ItemList.GetNameFromListEntry, "GetType", LibLordFarlander_ItemList.GetListEntryType, "GetLink", LibLordFarlander_ItemList.GetLinkFromListEntry, "GetTexture", LibLordFarlander_ItemList.GetTextureFromListEntry, "GetID", LibLordFarlander_ItemList.GetNormalizedIDFromListEntry );
end--LibLordFarlander_ItemList.BuildBasicItem()

function LibLordFarlander_ItemList.BuildBagItem( bag, slot )
    local returnVal = LibLordFarlander_ItemList.BuildBasicItem();

    returnVal.bag = bag;
    returnVal.slot = slot;
    returnVal.GetLink = GetLink_BagItem;
    returnVal.GetName = GetName_BagItem;
    return returnVal;
end--LibLordFarlander_ItemList.BuildBagItem( bag, slot )

function LibLordFarlander_ItemList.BuildInventoryItem( invslot )
    local returnVal = LibLordFarlander_ItemList.BuildBasicItem();

    if( type( invslot ) == string ) then
        invslot = GetInventorySlotInfo( invslot );
    end--if
    returnVal.invslot = invslot;
    returnVal.GetLink = GetLink_InventoryItem;
    returnVal.GetName = GetName_InventoryItem;
    return returnVal;
end--LibLordFarlander_ItemList.BuildInventoryItem( bag, slot )

function LibLordFarlander_ItemList.BuildSpell( spellID )
    local returnVal = LibLordFarlander_ItemList.BuildBasicItem();

    if( spellID < 0 ) then
        spellID = spellID * -1;
    end--if
    returnVal.spellID = spellID;
    returnVal.GetLink = GetLink_Spell;
    returnVal.GetName = GetName_Spell;
    return returnVal;
end--LibLordFarlander_ItemList.BuildSpell( bag, slot )

function LibLordFarlander_ItemList.BuildItem( itemID )
    local returnVal = LibLordFarlander_ItemList.BuildBasicItem();

    if( type( itemID ) == "string" ) then
        itemID = LibLordFarlander.GetItemIDFromLink( LibLordFarlander.GetItemLink( itemID ) );
    end--if
    if( itemID < 0 ) then
        return LibLordFarlander_ItemList.BuildSpell( itemID * -1 );
    end--if
    returnVal.itemID = itemID;
    returnVal.GetLink = GetLink_Item;
    returnVal.GetName = GetName_Item;
    return returnVal;
end--LibLordFarlander_ItemList.BuildItem( bag, slot )

function LibLordFarlander_ItemList.AddBagItemToList( list, bag, slot )
    local item = LibLordFarlander_ItemList.BuildBagItem( bag, slot )

    table.insert( list, item );
    return item;    
end--LibLordFarlanderLibLordFarlander_ItemList.AddBagItemToList( list, bag, slot )

function LibLordFarlander_ItemList.AddInventoryItemToList( list, invslot )
    local item = LibLordFarlander_ItemList.BuildInventoryItem( invslot )

    table.insert( list, item );
    return item;
end--LibLordFarlander_ItemList.AddBagItemToList( list, bag, slot )

function LibLordFarlander_ItemList.AddSpellToList( list, spellID )
    local item = LibLordFarlander_ItemList.BuildSpell( spellID )

    table.insert( list, item );
    return item;
end--LibLordFarlander_ItemList.AddSpellToList( list, spellID )

function LibLordFarlander_ItemList.AddItemToList( list, itemID )
    if( itemID < 0 ) then
        return LibLordFarlander_ItemList.AddSpellToList( list, itemID * -1 )
    else
        local item = LibLordFarlander_ItemList.BuildItem( itemID )

        table.insert( list, item );
        return item;
    end--if
end--LibLordFarlander_ItemList.AddSpellToList( list, spellID )

function LibLordFarlander_ItemList.GetListEntryType( item )
    if( item.spellID ) then
        --spell
        return "spell";
    elseif( item.invslot ) then
        --inventory
        return "inventoryslot";
    elseif( item.itemID ) then
        --item
        return "item";
    elseif( item.bag and item.slot ) then
        --bag slot
        return "bageditem";
    end--if
    return nil;
end--LibLordFarlander_ItemList.GetListEntryType( item )

function LibLordFarlander_ItemList.FindInBags( itemID )
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots( bag ) do
            itemLink = GetContainerItemLink( bag, slot );
            if( itemLink ) then
                if( itemID == LibLordFarlander.GetItemIDFromLink( itemLink ) ) then
                    return LibLordFarlander_ItemList.BuildBagItem( bag, slot );
                end--if
            end--if
        end--for
    end--for
    return nil;
end--LibLordFarlander_ItemList.FindInBags( itemID )

function LibLordFarlander_ItemList.GetNameFromListEntry( item )
    if( item.spellID ) then
        --spell
        return GetName_Spell( item );
    elseif( item.invslot ) then
        --inventory
        return GetName_InventoryItem( item );
    elseif( item.itemID ) then
        --item
        return GetName_Item( item );
    elseif( item.bag and item.slot ) then
        --bag slot
        return GetName_BagItem( item );
    end--if
    return nil;
end--LibLordFarlander_ItemList.GetNameFromListEntry( item )

function LibLordFarlander_ItemList.GetLinkFromListEntry( item )
    if( item.spellID ) then
        --spell
        return GetLink_Spell( item );
    elseif( item.invslot ) then
        --inventory
        return GetLink_InventoryItem( item );
    elseif( item.itemID ) then
        --item
        return GetLink_Item( item );
    elseif( item.bag and item.slot ) then
        --bag slot
        return GetLink_BagItem( item );
    end--if
    return nil;
end--LibLordFarlander_ItemList.GetNameFromListEntry( item )

function LibLordFarlander_ItemList.GetNormalizedIDFromListEntry( item )
    if( item.spellID ) then
        --spell
        return item.spellID * -1;
    elseif( item.invslot ) then
        --inventory
        return LibLordFarlander.GetItemIDFromLink( GetInventoryItemLink( "player", item.invslot ) );
    elseif( item.itemID ) then
        --item
        return item.itemID;
    elseif( item.bag and item.slot ) then
        --bag slot
        return LibLordFarlander.GetItemIDFromLink( GetContainerItemLink( item.bag, item.slot ) );
    end--if
    return nil;
end--LibLordFarlander_ItemList.GetNameFromListEntry( item )

function LibLordFarlander_ItemList.GetTextureFromListEntry( item )
    local sTexture = nil;
    
    if( item.spellID ) then
        --spell
        sTexture = select( 3, GetSpellInfo( item.spellID ) );
    elseif( item.invslot ) then
        --inventory
        sTexture = GetInventoryItemTexture( "player", item.invslot );
    elseif( item.itemID ) then
        --item
        sTexture = select( 10, GetItemInfo( item.itemID ) );
    elseif( item.bag and item.slot ) then
        --bag slot
        sTexture = select( 10, GetItemInfo( GetContainerItemLink( item.bag, item.slot ) ) );
    end--if
    return sTexture;
end--LibLordFarlander_ItemList.GetTextureFromListEntry( item )

function LibLordFarlander_ItemList.GetRandomItemFromList( list )
    if( type( list ) == "table" ) then
        local amountOfItems = #list;

        if( amountOfItems > 0 ) then
            --math.random( upper ) generates integer numbers between 1 and upper.
            local randomItemIndex = math.random( amountOfItems );

            if( amountOfItems > 1 ) then --Lets make sure the player gets a different item if he has more then one, the quick and dirty way.
                while( LibLordFarlander.CompareTables( list[randomItemIndex], currentItem ) ) do
                    randomItemIndex = math.random( amountOfItems );
                end--while
            end--if
            return list[randomItemIndex];
        end--if
    end--if
    return nil;
end--LibLordFarlander_ItemList.GetRandomItemFromList( list, currentItem )

function LibLordFarlander_ItemList.SetTooltipFromListEntry( tooltip, item )
    if( item.spellID ) then
        --spell
        tooltip:SetHyperlink( LibLordFarlander_ItemList.GetLinkFromListEntry( item ) );
    elseif( item.invslot ) then
        --inventory
        tooltip:SetInventoryItem( "player", item.invslot );
    elseif( item.itemID ) then
        --item
        tooltip:SetHyperlink( LibLordFarlander_ItemList.GetLinkFromListEntry( item ) );
    elseif( item.bag and item.slot ) then
        --bag slot
        tooltip:SetBagItem( item.bag, item.slot );
    end--if
end--LibLordFarlander_ItemList.SetTooltipFromListEntry( item )

function LibLordFarlander_ItemList.SetButtonFromListEntry( button, item, setCooldown, cooldownIndicator )
    local sName, itemLink, sItemTexture;
    local startTime, duration, enable;

    if( not cooldownIndicator ) then
        cooldownIndicator = button.cooldown;
    end--if
    if( item.spellID ) then
        --spell
        sName, _, sItemTexture, _, _, _, _, _, _ = GetSpellInfo( item.spellID );
        startTime, duration, enable = GetSpellCooldown( sName, BOOKTYPE_SPELL );

        button:SetAttribute( "*type1", "spell" );
        button:SetAttribute( "*spell1", sName );
    elseif( item.invslot ) then
        --inventory
        itemLink = GetInventoryItemLink( "player", item.invslot );
        if( itemLink ) then
            sName, _, _, _, _, _, _, _, _, sItemTexture = GetItemInfo( itemLink );
            startTime, duration, enable = GetItemCooldown( itemLink );
        end--if

        button:SetAttribute( "*type1", "item" );
        button:SetAttribute( "*bag1", nil );
        button:SetAttribute( "*slot1", item.invslot );
        button:SetAttribute( "*item1", nil );
    elseif( item.itemID ) then
        --item
        sName, _, _, _, _, _, _, _, _, sItemTexture = GetItemInfo( item.itemID );
        startTime, duration, enable = GetItemCooldown( item.itemID );

        button:SetAttribute( "*type1", "item" );
        button:SetAttribute( "*bag1", nil );
        button:SetAttribute( "*slot1", nil );
        button:SetAttribute( "*item1", sName );
    elseif( item.bag and item.slot ) then
        --bag slot
        itemLink = GetContainerItemLink( item.bag, item.slot );
        if( itemLink ) then
            sName, _, _, _, _, _, _, _, _, sItemTexture = GetItemInfo( itemLink );
            startTime, duration, enable = GetItemCooldown( itemLink );
        end--if

        button:SetAttribute( "*type1", "item" );
        button:SetAttribute( "*bag1", item.bag );
        button:SetAttribute( "*slot1", item.slot );
        button:SetAttribute( "*item1", nil );
    end--if
    if( button.SetImage ) then
        button:SetImage( sItemTexture );
    elseif( LibLordFarlander_UI ) then
        LibLordFarlander_UI.SetButtonImage( button, sItemTexture );
    end--if
    if( cooldownIndicator and enable and setCooldown and ( startTime > 0 ) and ( duration > 0 ) ) then
        cooldownIndicator:Show();
        cooldownIndicator:SetCooldown( startTime, duration );
    else
        cooldownIndicator:Hide();
    end--if
    if( button.class and button.class.ldbobj ) then
        button.class.ldbobj.icon = sItemTexture or "";
        button.class.ldbobj.text = sName or "";
    end--if
end--LibLordFarlander_ItemList.SetButtonFromListEntry( item, button )

function LibLordFarlander_ItemList.AttachToButton( button )
    button.tooltip.SetFromListEntry = LibLordFarlander_ItemList.SetTooltipFromListEntry;
    button.SetFromListEntry = LibLordFarlander_ItemList.SetButtonFromListEntry;
end--LibLordFarlander_ItemList.AttachToButton( button )
