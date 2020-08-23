--[[
    Helper functions
    $Revision: 177 $
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

local MAJOR_VERSION = "LibLordFarlander-UI-2.0";
local MINOR_VERSION = tonumber(("$Revision: 177 $"):match("(%d+)")) + 90000

if( not LibStub( "LibKeyBound-1.0", true ) ) then
    error( MAJOR_VERSION .. " requires LibKeyBound-1.0" );
    return;
end--if

if( not LibStub( "LibStickyFrames-2.0", true ) ) then
    error( MAJOR_VERSION .. " requires LibStickyFrames-2.0" );
    return;
end--if

local LibLordFarlander_UI, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not LibLordFarlander_UI ) then
    return;
end--if

function LibLordFarlander_UI.SetupForUI( class )
    local LibKeyBound = LibStub( "LibKeyBound-1.0" );

    -- LibKeyBound support
    LibKeyBound.RegisterCallback( class, "LIBKEYBOUND_ENABLED", LibLordFarlander_UI.LIBKEYBOUND_ENABLED, class );
    LibKeyBound.RegisterCallback( class, "LIBKEYBOUND_DISABLED", LibLordFarlander_UI.LIBKEYBOUND_DISABLED, class );
    LibKeyBound.RegisterCallback( class, "LIBKEYBOUND_MODE_COLOR_CHANGED", LibLordFarlander_UI.LIBKEYBOUND_MODE_COLOR_CHANGED, class );
    class.keyBoundMode = false;
end--LibLordFarlander_UI.SetupUI( class )

function LibLordFarlander_UI.GetButtonSettingsDefaults()
    return {
            AutoHideButton = true,
            LockButton = false,
            ButtonGroup = {
                SkinID = "Blizzard",
                Gloss = nil,
                Backdrop = nil,
                Colors = {},
            },
            FadeOptions = {
                fadeOut = false,
                fadeInsteadHide = false,
                fadeOutUpdateTime = 0.1,
                fadeOutCancelInCombat = true,
                fadeOutCancelOnShift = false,
                fadeOutCancelOnCtrl = false,
                fadeOutCancelOnAlt = false,
                alpha = 1.0,
                fadeOutDelay = 0.5,
                fadeOutAlpha = 0.2,
                fadeOutTime = 0.5,
            },
            posX = GetScreenWidth() / 2.0,
            posY = GetScreenHeight() / 2.0,
            showButton = true,
            buttonScale = 1.0,
        };
end--LibLordFarlander_UI.GetButtonSettingsDefaults()

function LibLordFarlander_UI.GetButtonOptionGroup( class, strings, startindex )
    if( startindex == nil ) then
        startindex = 1;
    end--if
    if( not class.ui ) then
        class.ui = {};
    end--if
    if( not class.ui.yes ) then
        class.ui.yes = strings.yes or "yes";    
    end--if
    if( not class.ui.no ) then
        class.ui.no = strings.no or "no";        
    end--if        
    return {
        type = "group",
        handler = class,
        name = strings.name or "Button",
        desc = strings.desc or "Options relating to the button.",
        args = {
            [strings.toggleButton or "toggleButton"] = {
                type = "toggle",
                order = startindex,
                name = strings.toggleButton_name or "Show button",
                arg = {
                    DescriptionString = strings.toggleButton_desc or "Show/hide the button.",
                    VariableName = "showButton",
                    Location = "profile.Button",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,                  
                set = function( info, val )
                          local LibButtonFacade = LibStub( "LibButtonFacade", true );
                          local button = info.handler.button;
                          local border = _G[button:GetName() .. "Border"];
                          local normal = button:GetNormalTexture();
                          local pushed = button:GetPushedTexture();

                          info.handler.db.profile.Button.showButton = val;
                          button:ClearAllPoints();

                          if( val ) then
                              local s = button:GetEffectiveScale();

                              button:SetHeight( 36 );
                              button:SetWidth( 36 );
                              if( button.icon ) then
                                  button.icon:SetHeight( 36 );
                                  button.icon:SetWidth( 36 );
                                  button.icon:Show();
                              end--if
                              border:SetTexture( "Interface\Buttons\UI-ActionButton-Border" );
                              normal:SetTexture( "Interface\Buttons\UI-Quickslot2" );
                              pushed:SetTexture( "Interface\Buttons\UI-Quickslot-Depress" );
                              if( LibButtonFacade ) then
                                  LibButtonFacade:Group( info.handler.name ):AddButton( button );
                              end--if
                              button:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", info.handler.db.profile.Button.posX / s, info.handler.db.profile.Button.posY / s );
                          else
                              if( LibButtonFacade ) then
                                  LibButtonFacade:Group( info.handler.name ):RemoveButton( button );
                              end--if
                              button:SetHeight( 1 );
                              button:SetWidth( 1 );
                              if( button.icon ) then
                                  button.icon:SetHeight( 1 );
                                  button.icon:SetWidth( 1 );
                                  button.icon:Hide();
                              end--if
                              border:SetTexture( "" );
                              normal:SetTexture( "" );
                              pushed:SetTexture( "" );
                          end--if
                      end,
            },
            [strings.autoHideButton or "autoHideButton"] = {
                type = "toggle",
                order = startindex + 1,
                name = strings.autoHideButton_name or "Automatically hide button",
                arg = {
                    DescriptionString = strings.autoHideButton_desc or "Hide the button automatically?",
                    VariableName = "AutoHideButton",
                    Location = "profile.Button",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,   
                set = function( info, val )
                          info.handler.db.profile.Button.AutoHideButton = val;
                          if( info.handler.AutoHideChange ) then
                              info.handler:AutoHideChange();
                          end--if
                      end,
            },
            [strings.lockButton or "lockButton"] = {
                type = "toggle",
                order = startindex + 2,
                name = strings.lockButton_name or "Lock button position",               
                arg = {
                    DescriptionString = strings.lockButton_desc or "Lock/unlock the position of the button.",
                    VariableName = "LockButton",
                    Location = "profile.Button",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,                
                set = function( info, val )
                          info.handler.db.profile.Button.LockButton = val;
                          info.handler.button:SetMovable( not info.handler.db.profile.Button.LockButton );
                      end,
            },
            [strings.buttonScale or "buttonScale"] = {
                type = "range",
                order = startindex + 3,
                name = strings.buttonScale_name or "Scale of button",
                min = 0.1,
                max = 3.0,                           
                arg = {
                    DescriptionString = strings.buttonScale_desc or "Sets the scaling value for the button to make it bigger or smaller.",
                    VariableName = "buttonScale",
                    Location = "profile.Button",
                },
                desc = LibLordFarlander_UI.IntegerOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,                      
                set = function( info, val )
                          local ButtonSettings = info.handler.db.profile.Button;
                          local button = info.handler.button;

                          ButtonSettings.buttonScale = val;
                          
                          button:SetScale( val );

                          local x, y, s = ButtonSettings.posX, ButtonSettings.posY, button:GetEffectiveScale();

                          button:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / s, y / s );
                      end,
            },
            [strings.alpha or "alpha"] = {
                type = "range",
                order = startindex + 4,
                name = strings.alpha_name or "Alpha of button",
                min = 0.1,
                max = 1.0,
                arg = {
                    DescriptionString = strings.alpha_desc or "Sets the alpha value that the button has normally.",
                    VariableName = "alpha",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.IntegerOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = function( info, val )
                          local ButtonSettings = info.handler.db.profile.Button;

                          info.handler.db.profile.Button.FadeOptions.alpha = val; 
                          info.handler.button:SetAlpha( val )
                      end,                       
            },
            [strings.fadeOut or "fadeOut"] = {
                type = "toggle",
                order = startindex + 5,
                name = strings.fadeOut_name or "Fade out",                   
                arg = {
                    DescriptionString = strings.fadeOut_desc or "Should the button fade out when the cursor is not over it?",
                    VariableName = "fadeOut",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                        
            },
            [strings.fadeOutInsteadHide or "fadeOutInsteadHide"] = {
                type = "toggle",
                order = startindex + 6,
                name = strings.fadeOutInsteadHide_name or "Fade out instead of hiding",                     
                arg = {
                    DescriptionString = strings.fadeOutInsteadHide_desc or "Should the button fade out instead of hide?",
                    VariableName = "fadeInsteadHide",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                      
            },
            [strings.fadeOutCancelInCombat or "fadeOutCancelInCombat"] = {
                type = "toggle",
                order = startindex + 7,
                name = strings.fadeOutCancelInCombat_name or "Cancel fade out if in combat",
                arg = {
                    DescriptionString = strings.fadeOutCancelInCombat_desc or "Should the button not fade out if you're in combat?",
                    VariableName = "fadeOutCancelInCombat",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                        
            },
            [strings.fadeOutCancelOnShift or "fadeOutCancelOnShift"] = {
                type = "toggle",
                order = startindex + 8,
                name = strings.fadeOutCancelOnShift_name or "Cancel fade out if holding Shift",                     
                arg = {
                    DescriptionString = strings.fadeOutCancelOnShift_desc or "Should the button not fade out if you're holding Shift?",
                    VariableName = "fadeOutCancelOnShift",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                      
            },
            [strings.fadeOutCancelOnCtrl or "fadeOutCancelOnCtrl"] = {
                type = "toggle",
                order = startindex + 9,
                name = strings.fadeOutCancelOnCtrl_name or "Cancel fade out if holding Ctrl",
                arg = {
                    DescriptionString = strings.fadeOutCancelOnCtrl_desc or "Should the button not fade out if you're holding Ctrl?",
                    VariableName = "fadeOutCancelOnCtrl",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                      
            },
            [strings.fadeOutCancelOnAlt or "fadeOutCancelOnAlt"] = {
                type = "toggle",
                order = startindex + 10,
                name = strings.fadeOutCancelOnAlt_name or "Cancel fade out if holding Alt",
                arg = {
                    DescriptionString = strings.fadeOutCancelOnAlt_desc or "Should the button not fade out if you're holding Alt?",
                    VariableName = "fadeOutCancelOnAlt",
                    Location = "profile.Button.FadeOptions",
                },
                desc = LibLordFarlander_UI.BooleanOptionDescription,
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,
            },
            [strings.fadeOutTime or "fadeOutTime"] = {
                type = "range",
                order = startindex + 11,
                name = strings.fadeOutTime_name or "Fade out time",
                min = 0.1,
                max = 3.0,                    
                arg = {
                    DescriptionString = strings.fadeOutTime_desc or "Sets how long the button takes to fade out.",
                    VariableName = "fadeOutTime",
                    Location = "profile.Button.FadeOptions",
                },                
                desc = LibLordFarlander_UI.IntegerOptionDescription,                
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                      
            },
            [strings.fadeOutDelay or "fadeOutDelay"] = {
                type = "range",
                order = startindex + 12,
                name = strings.fadeOutDelay_name or "Fade out delay",
                min = 0.1,
                max = 1.0,
                arg = {
                    DescriptionString = strings.fadeOutDelay_desc or "Sets the delay before the button starts to fade.",
                    VariableName = "fadeOutDelay",
                    Location = "profile.Button.FadeOptions",
                },                
                desc = LibLordFarlander_UI.IntegerOptionDescription,                
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,                      
            },
            [strings.fadeOutAlpha or "fadeOutAlpha"] = {
                type = "range",
                order = startindex + 13,
                name = strings.fadeOutAlpha_name or "Alpha after fadeout",
                min = 0.1,
                max = 1.0,                
                arg = {
                    DescriptionString = strings.fadeOutAlpha_desc or "Sets the alpha value that the button has after faded out.",
                    VariableName = "fadeOutAlpha",
                    Location = "profile.Button.FadeOptions",
                },                
                desc = LibLordFarlander_UI.IntegerOptionDescription,                
                get = LibLordFarlander_UI.GetGenericOption,
                set = LibLordFarlander_UI.SetGenericOption,
            },
        },
    };
end--LibLordFarlander_UI.GetButtonOptionGroup( class, strings, startindex )

function LibLordFarlander_UI.CreateButton( class, groupName, defaultImage, ButtonFacadeGroup )
    local button = CreateFrame( "Button", groupName .. "_Button", UIParent, "SecureActionButtonTemplate, ActionButtonTemplate" );
    local ButtonSettings = class.db.profile.Button;
    local LibStickyFrames = LibStub( "LibStickyFrames-2.0" );
    local LibButtonFacade = LibStub( "LibButtonFacade", true );

    if( button == nil ) then
        return nil;
    end--if
    button:EnableMouse( true );
    button:SetMovable( true );
    button:RegisterForDrag( "LeftButton" );
    button:RegisterForClicks( "AnyUp" );
    button:SetScale( ButtonSettings.buttonScale );

    local x, y, s = ButtonSettings.posX, ButtonSettings.posY, button:GetEffectiveScale();

    button:ClearAllPoints();
    button:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / s, y / s );

    button.class = class;
    button.tooltip = GameTooltip;
    button.cooldown = _G[button:GetName() .. "Cooldown"];
    button.GetHotkey = function( self ) return GetBindingKey( "BINDING_NAME_CLICK " .. self:GetName() .. ":LeftButton" ) end;
    button.ActionName = groupName;
    button.GetActionName = function( self ) return self.ActionName end;
    button.HideEx = LibLordFarlander_UI.HideEx;
    button.ShowEx = LibLordFarlander_UI.ShowEx;
    button.SetImage = LibLordFarlander_UI.SetButtonImage;
    button.OutOfCombatReset = LibLordFarlander_UI.OutOfCombatButtonReset;
    button.icon = _G[button:GetName() .. "Icon"];
    button:SetAlpha( ButtonSettings.FadeOptions.alpha );
    if( not ButtonSettings.showButton ) then
        button:SetHeight( 1 );
        button:SetWidth( 1 );
        if( button.icon ) then
            button.icon:SetHeight( 1 );
            button.icon:SetWidth( 1 );
        end--if
        _G[button:GetName() .. "Border"]:SetTexture( "" );
        button:GetPushedTexture():SetTexture( "" );
        button:GetNormalTexture():SetTexture( "" );
    end--if
    button:SetScript( "OnEnter",
        function( button )
            if( button.class ) then
                button:SetAlpha( button.class.db.profile.Button.FadeOptions.alpha );
                if( button.class.SetGameTooltips ) then
                    button.class:SetGameTooltips();
                end--if
            end--if
        end );
    button:SetScript( "OnLeave",
        function( button )
            if( button.tooltip ) then
                button.tooltip:Hide();
            end--if
            if( button.class ) then
                local fadingOptions = button.class.db.profile.Button.FadeOptions;

                if( fadingOptions.fadeOut or ( button.hiddenFade and fadingOptions.fadeInsteadHide ) ) then
                    button.faded = false;
                    button.fadeOutDelay = fadingOptions.fadeOutDelay;
                    button.fadeOut = true;
                end--if
            end--if
        end );
    button:SetScript( "OnUpdate",
        function( button, elapsed )
            if( button.FadeOnUpdate ) then
                button:FadeOnUpdate( elapsed );
            end--if
            if( button.class and button.class.OnUpdate ) then
                button.class:OnUpdate( elapsed );
            end--if
        end );
    button:SetScript( "OnDragStart", LibLordFarlander_UI.OnDragStart );
    button:SetScript( "OnDragStop", LibLordFarlander_UI.OnDragStop );

    button.FadeOnUpdate = LibLordFarlander_UI.OnUpdate_FadeButton;
	button.OnStickToFrame = LibLordFarlander_UI.OnStickToFrame;
	button.OnStopFrameMoving = LibLordFarlander_UI.OnStickToFrame;
    LibStickyFrames:SetFrameGroup( button, true );
    LibStickyFrames:SetFrameEnabled( button, true );
    LibStickyFrames:SetFrameText( button, groupName );
    LibStickyFrames.RegisterCallback( button, "OnStickToFrame" );
    LibStickyFrames.RegisterCallback( button, "OnStopFrameMoving" );
    if( ButtonSettings.StickToFrame and _G[ButtonSettings.StickToFrame] ) then
        LibStickyFrames:SetFramePoints( button, ButtonSettings.StickPoint, _G[ButtonSettings.StickToFrame], ButtonSettings.StickToPoint, ButtonSettings.StickToX, ButtonSettings.StickToY );
    end--if
    if( LibButtonFacade ) then
        local ButtonFacadeGroup = ButtonSettings.ButtonGroup;

        if( ButtonSettings.showButton ) then
            LibButtonFacade:Group( groupName ):AddButton( button );
        end
        LibButtonFacade:Group( groupName ):Skin( ButtonFacadeGroup.SkinID, ButtonFacadeGroup.Gloss, ButtonFacadeGroup.Backdrop, ButtonFacadeGroup.Colors );
        LibButtonFacade:RegisterSkinCallback( groupName, LibLordFarlander_UI.SkinChanged, class );
    end--if
    button:SetImage( defaultImage );
    return button;
end

function LibLordFarlander_UI.OutOfCombatButtonReset( button )
    if( button.NeedToShow ) then
        button.NeedToShow = false;
        button:ShowEx();
    end--if
    if( button.NeedToHide ) then
        button.NeedToHide = false;
        button:HideEx();
    end--if
end--LibLordFarlander_UI.OnDragStop( button )

function LibLordFarlander_UI.OnProfileChanged( self )
    local LibStickyFrames = LibStub( "LibStickyFrames-2.0" );
    local LibButtonFacade = LibStub( "LibButtonFacade", true );
    local button = self.button;
    local ButtonSettings = self.db.profile.Button;
    local x, y, s = ButtonSettings.posX, ButtonSettings.posY, button:GetEffectiveScale();

    button:ClearAllPoints()
    button:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / s, y / s );
    if( ButtonSettings.StickToFrame and _G[ButtonSettings.StickToFrame] ) then
        LibStickyFrames:SetFramePoints( button, ButtonSettings.StickPoint, _G[ButtonSettings.StickToFrame], ButtonSettings.StickToPoint, ButtonSettings.StickToX, ButtonSettings.StickToY );
    end--if
    if( LibButtonFacade ) then
        local ButtonFacadeGroup = ButtonSettings.ButtonGroup;

        LibButtonFacade:Group( button.ActionName ):Skin( ButtonFacadeGroup.SkinID, ButtonFacadeGroup.Gloss, ButtonFacadeGroup.Backdrop, ButtonFacadeGroup.Colors );
    end--if
end--LibLordFarlander_UI.OnProfileChanged( self )

function LibLordFarlander_UI.OnDragStart( button )
    if( not button.class.db.profile.Button.LockButton ) then
        LibStub( "LibStickyFrames-2.0" ):StartFrameMoving( button );
    end--if
end--LibLordFarlander_UI.OnDragStart( button )

function LibLordFarlander_UI.OnDragStop( button )
    if( not button.class.db.profile.Button.LockButton ) then
        local x, y = button:GetLeft(), button:GetBottom()
        local s = button:GetEffectiveScale()
        local Button = button.class.db.profile.Button;
    
        Button.posX = x * s;
        Button.posY = y * s;
        LibStub( "LibStickyFrames-2.0" ):StopFrameMoving( button );
    end--if
end--LibLordFarlander_UI.OnDragStop( button )

--For LibStickyFrames support
function LibLordFarlander_UI.OnStickToFrame( self, event, frame, point, stickToFrame, stickToPoint, stickToX, stickToY )
    local Button = self.class.db.profile.Button;
    local x, y = self:GetLeft(), self:GetBottom()
    local s = frame:GetEffectiveScale()

    Button.posX = x * s;
    Button.posY = y * s;
    Button.StickToX = stickToX;
    Button.StickToY = stickToY;
    LibStub( "LibStickyFrames-2.0" ):SetFramePoints( frame, point, stickToFrame, stickToPoint, stickToX, stickToY );
    if( frame ) then
        Button.StickPoint = point;
        Button.StickToFrame = stickToFrame and stickToFrame:GetName() or nil;
        Button.StickToPoint = stickToPoint;
        Button.StickToX = stickToX;
        Button.StickToY = stickToY;
    end--if
end--LibLordFarlander_UI.OnStickToFrame( self, event, frame, point, stickToFrame, stickToPoint, stickToX, stickToY )

--For ButtonFacade support
function LibLordFarlander_UI.SkinChanged( self, SkinID, Gloss, Backdrop, barKey, buttonKey, Colors )
    local ButtonFacadeGroup = self.db.profile.Button.ButtonGroup;

    ButtonFacadeGroup.SkinID = SkinID;
    ButtonFacadeGroup.Gloss = Gloss;
    ButtonFacadeGroup.Backdrop = Backdrop;
    ButtonFacadeGroup.Colors = Colors;
end--LibLordFarlander_UI.SkinChanged( SkinID, Gloss, Backdrop, barKey, buttonKey, Colors )

function LibLordFarlander_UI.HideEx( self )
    if( InCombatLockdown() ) then
        self.NeedToShow = false;
        self.NeedToHide = true;
    else
        if( self.class.db.profile.Button.FadeOptions.fadeInsteadHide ) then
            self.fadeOut = true;
            self.hiddenFade = true;
        else
            self:Hide();
        end--if
        LibStub( "LibStickyFrames-2.0" ):SetFrameHidden( self, true );
    end--if
end--LibLordFarlander_UI.HideEx( self )

function LibLordFarlander_UI.ShowEx( self )
    if( InCombatLockdown() ) then
        self.NeedToShow = true;
        self.NeedToHide = false;
    else
        local fadingOptions = self.class.db.profile.Button.FadeOptions;

        self:Show();
        self.hiddenFade = false;        
        if( fadingOptions.fadeInsteadHide ) then
            self:SetAlpha( fadingOptions.alpha );
            self.faded = false;
            self.fadeOutDelay = fadingOptions.fadeOutDelay;
            self.fadeOut = false;
        end--if
        LibStub( "LibStickyFrames-2.0" ):SetFrameHidden( self, false );
    end--if
end--LibLordFarlander_UI.ShowEx( self )

--For LibKeyBound support
function LibLordFarlander_UI.ColorButton( self )
    if( self.keyBoundMode ) then
        self.button:SetBackdropColor( LibStub( "LibKeyBound-1.0" ):GetColorKeyBoundMode() );
    end--if
end--LibLordFarlander_UI.ColorButton( self )

--For LibKeyBound support
function LibLordFarlander_UI.LIBKEYBOUND_ENABLED( self )
    self.keyBoundMode = true;
    LibLordFarlander_UI.ColorButton( self );
end--LibLordFarlander_UI.LIBKEYBOUND_ENABLED( self )

--For LibKeyBound support
function LibLordFarlander_UI.LIBKEYBOUND_DISABLED( self )
    self.keyBoundMode = false;
    LibLordFarlander_UI.ColorButton( self );
end--LibLordFarlander_UI.LIBKEYBOUND_DISABLED( self )

--For LibKeyBound support
function LibLordFarlander_UI.LIBKEYBOUND_MODE_COLOR_CHANGED( self )
    LibLordFarlander_UI.ColorButton( self )
end--LibLordFarlander_UI.LIBKEYBOUND_MODE_COLOR_CHANGED( self )

--For LibKeyBound support
function LibLordFarlander_UI.AfterSetTooltip( button )
    if( button.class.GetHotkey ) then
       LibStub( "LibKeyBound-1.0" ):Set( button );
    end--if
end--LibLordFarlander_UI.AfterSetTooltip( button )

-- Notes:
-- Sets the image for a button.
-- To set the image of the button's icon, make sure the button has an icon member set to its icon.
-- Arguments:
--     button - The button
--     string - Path to the image to set the button to
function LibLordFarlander_UI.SetButtonImage( button, img )
    if( button.icon ) then
        button.icon:SetTexture( img );
    else
        button:SetNormalTexture( img );
        button:SetHighlightTexture( img );
    end--if
end--LibLordFarlander_UI.SetButtonImage( button, img )

function LibLordFarlander_UI.UpdateFadeOut( button )
    local fadingOptions = button.class.db.profile.Button.FadeOptions;

    local cancelFade = ( InCombatLockdown() and fadingOptions.fadeOutCancelInCombat ) or
        MouseIsOver( button ) or
        ( IsShiftKeyDown() and fadingOptions.fadeOutCancelOnShift ) or
        ( IsControlKeyDown() and fadingOptions.fadeOutCancelOnCtrl ) or
        ( IsAltKeyDown() and fadingOptions.fadeOutCancelOnAlt );

    if( cancelFade ) then
        button:SetAlpha( fadingOptions.alpha );
        button.faded = false;
        button.fadeOutDelay = fadingOptions.fadeOutDelay;
        button.fadeOut = false;
    elseif( not button.faded ) then
        local startAlpha = fadingOptions.alpha;
        local fadeOutAlpha = fadingOptions.fadeOutAlpha or 0;
        local fadeOutChunks = ( fadingOptions.fadeOutTime or 10 ) / fadingOptions.fadeOutUpdateTime;
        local decrement = ( startAlpha - fadeOutAlpha ) / fadeOutChunks;
        local alpha = button:GetAlpha() - decrement;

        if( alpha < fadeOutAlpha ) then
            alpha = fadeOutAlpha;
        end
        if( alpha > fadeOutAlpha ) then
            button:SetAlpha( alpha );
        else
            button:SetAlpha( fadeOutAlpha );
            button.faded = true;
            button.fadeOut = false;
        end--if
    end--if
end--LibLordFarlander_UI.UpdateFadeOut( button, fadingOptions )

function LibLordFarlander_UI.OnUpdate_FadeButton( button, elapsed )
    local fadingOptions = button.class.db.profile.Button.FadeOptions;

    if( button.fadeOut ) then
        if( not button.elapsed ) then
            button.elapsed = 0;
        end--if
        button.elapsed = button.elapsed + elapsed;
        if( button.fadeOutDelay ) then
           if( button.elapsed < button.fadeOutDelay ) then
              return;
           else
               button.elapsed = button.elapsed - button.fadeOutDelay;
               button.fadeOutDelay = nil;
           end--if
        end--if
        if( button.elapsed > fadingOptions.fadeOutUpdateTime ) then
           LibLordFarlander_UI.UpdateFadeOut( button, fadingOptions )
           button.elapsed = 0;
        end--if
    end--if
end--LibLordFarlander_UI.ButtonFadeOnUpdate( button, elapsed, fadingOptions )

function LibLordFarlander_UI.IsModifierDown( modname )
    return ( modname ~= "Disabled" ) and _G[("Is%sKeyDown"):format( modname )]();
end--LibLordFarlander_UI.IsModifierDown( modname )

local function GetInfoBase( info )
    local handler = info.handler;
    local location = info.arg.Location or "profile";
    local returnVal;
    
    if( type( location ) == "string" ) then
        if( location == "base" ) then
            return handler;
        elseif( location:find( "%." ) ) then
            info.arg.Location = { strsplit( ".", location ) };            
            location = info.arg.Location;
        else
            return handler.db[location];
        end--if        
    end--if
    if( not returnVal ) then
        local start = 1;
        
        if( location[1] == "base" ) then
            start = 2;
            returnVal = handler;
        else
            returnVal = handler.db;
        end--if        
        for i = start, #location do
            returnVal = returnVal[location[i]];
        end--for
    end--if
    return returnVal;
end--GetInfoBase( info )

function LibLordFarlander_UI.IntegerOptionDescription( info )
    local arg = info.arg;
    local returnString = arg.DescriptionString;

    if( info.uiType == "cmd" ) then
        returnString = ("%s |cFFFF0000[%i]|r"):format( returnString, GetInfoBase( info )[arg.VariableName] );
    end--if
    return returnString;
end--LibLordFarlander_UI.IntegerOptionDescription( info )

function LibLordFarlander_UI.BooleanOptionDescription( info )
    local arg = info.arg;
    local returnString = arg.DescriptionString;

    if( info.uiType == "cmd" ) then
        returnString = ("%s |cFFFF0000[%s]|r"):format( returnString, GetInfoBase( info )[arg.VariableName] and info.handler.ui.yes or info.handler.ui.no );
    end--if
    return returnString;   
end--LibLordFarlander_UI.BooleanOptionDescription( info )

function LibLordFarlander_UI.SetGenericOption( info, val )
    GetInfoBase( info )[info.arg.VarableName or info.arg.VariableName] = val;
end--LibLordFarlander_UI.SetGenericOption( info, val )

function LibLordFarlander_UI.GetGenericOption( info )
    return GetInfoBase( info )[info.arg.VarableName or info.arg.VariableName];
end--LibLordFarlander_UI.GetGenericOption( info )

                       