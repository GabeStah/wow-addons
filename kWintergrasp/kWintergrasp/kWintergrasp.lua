local L = AceLibrary("AceLocale-2.2"):new("kWintergrasp")
local Aura = nil
local options = { 
    type="group",
    args = {
		arena = {
			type = "group",
			name = "Arena",
			desc = "Arena options.",
			args = {
				announce = {
					type = "group",
					name = "Announce",
					desc = "Announcement options.",
					args = {
						channel = {
							type = 'text',
							name = "Channel",
							desc = "Set announcement channel.",
							get = "GetArenaAnnounceChannel",
							set = "SetArenaAnnounceChannel",
							validate = {["SAY"] = "Say", ["PARTY"] = "Party", ["RAID"] = "Raid", ["WHISPER"] = "Whisper"},
						},
						enabled = {
							type = "toggle",
							name = "Enabled",
							desc = "Toggle end-of-match announcements.",
							get = "IsArenaAnnounce",
							set = "SetArenaAnnounce",
							map = { [false] = "Disabled", [true] = "Enabled" },
							order = 3,
						},	
						player = {
							type = 'text',
							name = "Player Name",
							desc = "Set your announcement whisper name.",
							get = "GetArenaAnnouncePlayer",
							set = "SetArenaAnnouncePlayer",
							usage = "<any string>",
						},			
						header = {
							type = "header",
							name = "Arena Announcements",
							order = 1,
						},				
					},
				},
				enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Toggle if Arena options are active.",
					get = "IsArenaEnabled",
					set = "SetArenaEnabled",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 3,
				},
				teamname = {
					type = 'text',
					name = "Team Name",
					desc = "Set your arena team name.",
					get = "GetArenaTeamName",
					set = "SetArenaTeamName",
					usage = "<any string>",
				},
				header = {
					type = "header",
					name = "Arena Options",
					order = 1,
				},
			},
		},
		battleground = {
			type = "group",
			name = "Battleground",
			desc = "Battleground options.",
			args = {
				announce = {
					type = "group",
					name = "Announce",
					desc = "Announcement options.",
					args = {
						channel = {
							type = 'text',
							name = "Channel",
							desc = "Set announcement channel.",
							get = "GetBattlegroundAnnounceChannel",
							set = "SetBattlegroundAnnounceChannel",
							validate = {["SAY"] = "Say", ["PARTY"] = "Party", ["RAID"] = "Raid", ["WHISPER"] = "Whisper"},
						},
						enabled = {
							type = "toggle",
							name = "Enabled",
							desc = "Toggle end-of-match announcements.",
							get = "IsBattlegroundAnnounce",
							set = "SetBattlegroundAnnounce",
							map = { [false] = "Disabled", [true] = "Enabled" },
							order = 3,
						},
						player = {
							type = 'text',
							name = "Player Name",
							desc = "Set your announcement whisper name.",
							get = "GetBattlegroundAnnouncePlayer",
							set = "SetBattlegroundAnnouncePlayer",
							usage = "<any string>",
						},		
						header = {
							type = "header",
							name = "Battleground Announcements",
							order = 1,
						},				
					},
				},
				autojoin = {
					type = "toggle",
					name = "Autojoin",
					desc = "Toggle start of match auto-joining.",
					get = "IsBattlegroundAutojoin",
					set = "SetBattlegroundAutojoin",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 3,
				},
				autoleave = {
					type = "toggle",
					name = "Autoleave",
					desc = "Toggle start of match auto-leaving.",
					get = "IsBattlegroundAutoleave",
					set = "SetBattlegroundAutoleave",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 4,
				},
				autorepop = {
					type = "toggle",
					name = "Autorepop",
					desc = "Toggle automatic release when dead in battleground.",
					get = "IsBattlegroundAutorepop",
					set = "SetBattlegroundAutorepop",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 5,
				},
				warnings = {
					type = "group",
					name = "Warnings",
					desc = "Warning options.",
					args = {
						afk = {
							type = "toggle",
							name = "Afk",
							desc = "Toggle afk warning.",
							get = "IsBattlegroundWarningAfk",
							set = "SetBattlegroundWarningAfk",
							map = { [false] = "Disabled", [true] = "Enabled" },
						},
						afktimer = {
							name = "Afk Timer",
							type = "range",
							desc = "Change the seconds before an AFK that warning is sent.",
							get = "GetBattlegroundWarningAfkTimer",
							set = "SetBattlegroundWarningAfkTimer",
							min = 5,
							max = 50,
							step = 1, 
							isPercent = false,
						},
						idle = {
							type = "toggle",
							name = "Idle",
							desc = "Toggle idle warning.",
							get = "IsBattlegroundWarningIdle",
							set = "SetBattlegroundWarningIdle",
							map = { [false] = "Disabled", [true] = "Enabled" },
						},
						whisper = {
							type = "toggle",
							name = "Whisper",
							desc = "Toggle whisper warning.",
							get = "IsBattlegroundWarningWhisper",
							set = "SetBattlegroundWarningWhisper",
							map = { [false] = "Disabled", [true] = "Enabled" },
						},
						header = {
							type = "header",
							name = "Warnings",
							order = 1,
						},
					},
				},
				enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Toggle if Battlegrounds options are active.",
					get = "IsBattlegroundEnabled",
					set = "SetBattlegroundEnabled",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 2,
				},
				header = {
					type = "header",
					name = "Battleground Options",
					order = 1,
				},
			},
		},
		bars = {
					type = "group",
					name = "Bars",
					desc = "Bar options.",
					args = {
						enabled = {
							type = "toggle",
							name = "Enabled",
							desc = "Toggle if Battlegrounds options are active.",
							get = "IsBarsEnabled",
							set = "SetBarsEnabled",
							map = { [false] = "Disabled", [true] = "Enabled" },
							order = 1,
						},
					},
		},
		debug = {
			type = "toggle",
			name = "Debug",
			desc = "Toggle debug mode.",
			get = "IsDebug",
			set = "SetDebug",
			map = { [false] = "Disabled", [true] = "Enabled" },
		},
		enabled = {
			type = "toggle",
			name = "Enabled",
			desc = "Toggle the mod.",
			get = "IsEnabled",
			set = "SetEnabled",
			map = { [false] = "Disabled", [true] = "Enabled" },
			order = 3,
		},
		menu = {
			type = "execute",
			name = "Menu",
			desc = "Open dropdown menu.",
			func = "OpenMenu",
		},
		header = {
			type = "header",
			name = "kWintergrasp Menu",
			order = 1,
		},	
    },
}

kWintergrasp = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0")
kWintergrasp:RegisterChatCommand(L["Slash-Commands"], options)
kWintergrasp:RegisterDB("kWintergraspDB", "kWintergraspDBPC")
kWintergrasp:RegisterDefaults("profile", {
    Globals = {
		Arena = {
			Announce = {
				Channel = "PARTY",
				Enabled = true,
				Player = "Wakami",
			},
			Enabled = true,
			TeamName = "One and Nine",
		},
		Battleground = {
			Announce = {
				Channel = "WHISPER",
				Enabled = true,
				Player = "Mohx",
			},
			Autojoin = true,
			Autoleave = true,
			Autorepop = true,
			Debuffs = {
				"Inactive",
			},
			Idle = false,
			Enabled = true,
			Warnings = {
				Afk = true,
				AfkTimer = 10,
				Idle = true,
				Whisper = true,
			},
		},
		Debug = false,
		Enabled = true,
    },
    Bars = {
		Auras = {
			{
				Id = 33786, -- Cyclone
				Duration = 6,
			},
		},
		Enabled = false,
    },
} )

local dewdrop = AceLibrary("Dewdrop-2.0")

dewdrop:Register(Minimap,
    'children', function()
        dewdrop:FeedAceOptionsTable(options)
    end
)

function kWintergrasp:OpenMenu()
	dewdrop:Open(Minimap);
end
function kWintergrasp:IsDebug()
	return self.db.profile.Globals.Debug;
end
function kWintergrasp:SetDebug(v)
	self.db.profile.Globals.Debug = v;
end
function kWintergrasp:IsEnabled()
	return self.db.profile.Globals.Enabled;
end
function kWintergrasp:SetEnabled(v)
	self.db.profile.Globals.Enabled = v;
end

-- ARENA OPTIONS
function kWintergrasp:IsArenaEnabled()
	return self.db.profile.Globals.Arena.Enabled;
end
function kWintergrasp:SetArenaEnabled(v)
	self.db.profile.Globals.Arena.Enabled = v;
end
function kWintergrasp:GetArenaTeamName()
	return self.db.profile.Globals.Arena.TeamName;
end
function kWintergrasp:SetArenaTeamName(v)
	self.db.profile.Globals.Arena.TeamName = v;
end
	--	ARENA ANNOUNCE
	function kWintergrasp:IsArenaAnnounce()
		return self.db.profile.Globals.Arena.Announce.Enabled;
	end
	function kWintergrasp:SetArenaAnnounce(v)
		self.db.profile.Globals.Arena.Announce.Enabled = v;
	end
	function kWintergrasp:GetArenaAnnounceChannel()
		return self.db.profile.Globals.Arena.Announce.Channel;
	end
	function kWintergrasp:SetArenaAnnounceChannel(v)
		self.db.profile.Globals.Arena.Announce.Channel = v;
	end
	function kWintergrasp:GetArenaAnnouncePlayer()
		return self.db.profile.Globals.Arena.Announce.Player;
	end
	function kWintergrasp:SetArenaAnnouncePlayer(v)
		self.db.profile.Globals.Arena.Announce.Player = v;
	end
	-- END ARENA ANNOUNCE
-- END ARENA OPTIONS
-- BARS OPTIONS
function kWintergrasp:IsBarsEnabled()
	return self.db.profile.Bars.Enabled;
end
function kWintergrasp:SetBarsEnabled(v)
	self.db.profile.Bars.Enabled = v;
end
-- END BARS OPTIONS
-- BATTLEGROUND OPTIONS
function kWintergrasp:IsBattlegroundEnabled()
	return self.db.profile.Globals.Battleground.Enabled;
end
function kWintergrasp:SetBattlegroundEnabled(v)
	self.db.profile.Globals.Battleground.Enabled = v;
end
function kWintergrasp:IsBattlegroundAutojoin()
	return self.db.profile.Globals.Battleground.Autojoin;
end
function kWintergrasp:SetBattlegroundAutojoin(v)
	self.db.profile.Globals.Battleground.Autojoin = v;
end
function kWintergrasp:IsBattlegroundAutoleave()
	return self.db.profile.Globals.Battleground.Autoleave;
end
function kWintergrasp:SetBattlegroundAutoleave(v)
	self.db.profile.Globals.Battleground.Autoleave = v;
end
function kWintergrasp:IsBattlegroundAutorepop()
	return self.db.profile.Globals.Battleground.Autorepop;
end
function kWintergrasp:SetBattlegroundAutorepop(v)
	self.db.profile.Globals.Battleground.Autorepop = v;
end
	--	BATTLEGROUND ANNOUNCE
	function kWintergrasp:IsBattlegroundAnnounce()
		return self.db.profile.Globals.Battleground.Announce.Enabled;
	end
	function kWintergrasp:SetBattlegroundAnnounce(v)
		self.db.profile.Globals.Battleground.Announce.Enabled = v;
	end
	function kWintergrasp:GetBattlegroundAnnounceChannel()
		return self.db.profile.Globals.Battleground.Announce.Channel;
	end
	function kWintergrasp:SetBattlegroundAnnounceChannel(v)
		self.db.profile.Globals.Battleground.Announce.Channel = v;
	end
	function kWintergrasp:GetBattlegroundAnnouncePlayer()
		return self.db.profile.Globals.Battleground.Announce.Player;
	end
	function kWintergrasp:SetBattlegroundAnnouncePlayer(v)
		self.db.profile.Globals.Battleground.Announce.Player = v;
	end
	-- END BATTLEGROUND ANNOUNCE
	-- BATTLEGROUND WARNINGS
	function kWintergrasp:IsBattlegroundWarningAfk()
		return self.db.profile.Globals.Battleground.Warnings.Afk;
	end
	function kWintergrasp:SetBattlegroundWarningAfk(v)
		self.db.profile.Globals.Battleground.Warnings.Afk = v;
	end
	function kWintergrasp:GetBattlegroundWarningAfkTimer()
		return self.db.profile.Globals.Battleground.Warnings.AfkTimer;
	end
	function kWintergrasp:SetBattlegroundWarningAfkTimer(v)
		self.db.profile.Globals.Battleground.Warnings.AfkTimer = v;
	end
	function kWintergrasp:IsBattlegroundWarningIdle()
		return self.db.profile.Globals.Battleground.Warnings.Idle;
	end
	function kWintergrasp:SetBattlegroundWarningIdle(v)
		self.db.profile.Globals.Battleground.Warnings.Idle = v;
	end
	function kWintergrasp:IsBattlegroundWarningWhisper()
		return self.db.profile.Globals.Battleground.Warnings.Whisper;
	end
	function kWintergrasp:SetBattlegroundWarningWhisper(v)
		self.db.profile.Globals.Battleground.Warnings.Whisper = v;
	end
	-- END BATTLEGROUND WARNINGS
-- END BATTLEGROUND OPTIONS

function kWintergrasp:OnInitialize()
    -- Called when the addon is loaded
    if kWintergrasp:IsBarsEnabled() then
		kWintergrasp_Bars_DR:Show()
    else
		kWintergrasp_Bars_DR:Hide()
    end
end

function kWintergrasp:OnEnable()
	-- Called when the addon is enabled
    self:RegisterEvent("CHAT_MSG_WHISPER");
    self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("PLAYER_DEAD");
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	self:RegisterEvent("BATTLEFIELDS_SHOW");
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterBucketEvent("UNIT_AURA", 0.2, "DebuffCheck")
	if not Aura then
		Aura = AceLibrary("SpecialEvents-Aura-2.0")
	end
	if not Bars then
		Bars = AceLibrary("CandyBar-2.0")
		Bars:RegisterCandyBarGroup("kWintergrasp_DR");
		Bars:SetCandyBarGroupPoint("kWintergrasp_DR", "BOTTOM", "kWintergrasp_Bars_DR", "TOP", 0, 0);
		--Bars:RegisterCandyBarGroup("kWintergrasp_TIMER");
		--Bars:SetCandyBarGroupPoint("kWintergrasp_DR", "BOTTOM", "kWintergrasp_Bars_DR", "TOP");
	end
	-- Custom events
	self:RegisterEvent("BattlegroundWarningAfk");
	self:RegisterEvent("LeaveBattleground");
	self:RegisterEvent("FlashFrame");
	self:RegisterEvent("AnnounceArenaScores");
	-- Hooks
    hooksecurefunc("JumpOrAscendStart",PlayerJumped);
	-- Vars
	self.ActiveSpells = {};
	-- Set initial Honor
	intHonorStarting = GetHonorCurrency();
	self:RegisterEvent("UpdateHonorStatsGameEnd");
	self:RegisterEvent("UpdateHonorStatsGameStart");
end

function kWintergrasp:OnDisable()
    -- Called when the addon is disabled
end

function kWintergrasp:AnnounceArenaScores()
	for i=0,1 do
		local teamName, oldTeamRating, newTeamRating = GetBattlefieldTeamInfo(i);
		if (oldTeamRating ~= 0 and teamName ~= kWintergrasp:GetArenaTeamName() and (teamName ~= nil or teamName ~= "")) then
			-- If they gained rating
			if (oldTeamRating < newTeamRating) then
				kWintergrasp:SendAnnouncement("Team ["..teamName.."] gained ".. (newTeamRating - oldTeamRating) .. " rating, from " .. oldTeamRating .. " to " .. newTeamRating .. ".", "arena");
			else -- Lost rating
				kWintergrasp:SendAnnouncement("Team ["..teamName.."] lost ".. (oldTeamRating - newTeamRating) .. " rating, from " .. oldTeamRating .. " to " .. newTeamRating .. ".", "arena");
			end
		end			
	end
end

function kWintergrasp:DebuffCheck()
	for k, debuff in ipairs( self.db.profile.Globals.Battleground.Debuffs ) do
		if Aura:UnitHasDebuff("player", debuff) then
			if (self.db.profile.Globals.Battleground.Idle == nil) then
				self.db.profile.Globals.Battleground.Idle = true;
				kWintergrasp:BattlegroundWarningIdle();
			end
		else
			self.db.profile.Globals.Battleground.Idle = nil;
		end
	end
end

function kWintergrasp:UPDATE_BATTLEFIELD_SCORE()
	if (kWintergrasp:IsEnabled() and kWintergrasp:IsInArena() and kWintergrasp:IsArenaEnabled()) then
		kWintergrasp:UnregisterEvent("AnnounceArenaScores");
		kWintergrasp:RegisterEvent("AnnounceArenaScores");
		kWintergrasp:CancelAllScheduledEvents();
		kWintergrasp:ScheduleEvent("AnnounceArenaScores", 2);
	elseif (kWintergrasp:IsEnabled() and kWintergrasp:IsInBattleground() and kWintergrasp:IsBattlegroundAutoleave()) then
		if (GetBattlefieldInstanceExpiration() ~= 0) then
			self:ScheduleEvent("LeaveBattleground", 3);
		end
	end
end
function kWintergrasp:SendAnnouncement(message, type)
	if (type == "arena" and kWintergrasp:IsArenaAnnounce() and kWintergrasp:IsInArena()) then
		SendChatMessage("kWintergrasp [Arena]: " .. message, kWintergrasp:GetArenaAnnounceChannel(), nil, kWintergrasp:GetArenaAnnouncePlayer());
	elseif (type == "battleground" and kWintergrasp:IsBattlegroundAnnounce() and kWintergrasp:IsInBattleground()) then
		SendChatMessage("kWintergrasp [Battleground]: " .. message, kWintergrasp:GetBattlegroundAnnounceChannel(), nil, kWintergrasp:GetBattlegroundAnnouncePlayer());
	end
end
function PlayerJumped()
	-- Check if inside Battleground
	if (kWintergrasp:IsBattlegroundEnabled() and kWintergrasp:IsBattlegroundWarningAfk() and kWintergrasp:IsInBattleground()) then
		kWintergrasp:UnregisterEvent("BattlegroundWarningAfk");
		kWintergrasp:RegisterEvent("BattlegroundWarningAfk");
		kWintergrasp:CancelAllScheduledEvents();
		kWintergrasp:ScheduleEvent("BattlegroundWarningAfk", (300 - kWintergrasp:GetBattlegroundWarningAfkTimer()));
	end
end
function kWintergrasp:IsInDalaran()
	if (GetRealZoneText() == "Dalaran") then
		return true;
	end
	return nil;
end
function kWintergrasp:IsInWintergrasp()
	if (GetRealZoneText() == "Wintergrasp") then
		return true;
	end
	return nil;
end
function kWintergrasp:IsInArena()
	return IsActiveBattlefieldArena();
end
function kWintergrasp:CHAT_MSG_MONSTER_YELL()
	kWintergrasp:BattlegroundWarningWhisper(arg1, arg2);
end
function kWintergrasp:FlashFrame()
	LowHealthFrame:Hide();
	UIFrameFlash(LowHealthFrame, 0.25, 0.75, 2.2, false, 0, 0.1);
end
-- Types: TimeToStart, CurrentBattle
function kWintergrasp:AddBar(type)
	ChatFrame1:AddMessage("Spell added to ActiveSpells: " .. intSpellId .. ", " .. name);
	Bars:RegisterCandyBar(kWintergrasp:GetBarName("DR", intSpellId, strDestGuid), spellTrack.Duration, kWintergrasp:GetBarName("DR", intSpellId, strDestGuid), icon) 
	Bars:RegisterCandyBarWithGroup(kWintergrasp:GetBarName("DR", intSpellId, strDestGuid), "kWintergrasp_DR");
	Bars:StartCandyBar(kWintergrasp:GetBarName("DR", intSpellId, strDestGuid), true);	
	kWintergrasp:ExplodeBarName(kWintergrasp:GetBarName("DR", intSpellId, strDestGuid));
end
function kWintergrasp:GetBarName(type, spellId, destId)
	if spellId and destId and type then
		return (type .. ":" ..spellId .. ":" .. destId);
	else
		return nil;
	end
end
function kWintergrasp:ExplodeBarName(name)
	if name then
		ChatFrame1:AddMessage("name:" ..name);
		local spellType, spellId, destId = kWintergrasp:SplitString(":", name);
		ChatFrame1:AddMessage("spellId: " .. spellId);
		ChatFrame1:AddMessage("destId: " .. destId);
		ChatFrame1:AddMessage("spellType: " .. spellType);
	end
end

function kWintergrasp:SplitString(delimiter, text)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end



--FuBar
kWintergrasp.hasNoText = true
kWintergrasp.defaultPosition = "CENTER"
kWintergrasp.tooltipHiddenWhenEmpty = true
kWintergrasp.hasIcon = "Interface\\Icons\\Spell_Shadow_SummonVoidWalker"
kWintergrasp.defaultMinimapPosition = 285
kWintergrasp.cannotDetachTooltip = true
kWintergrasp.blizzardTooltip = true
kWintergrasp.hasNoColor = true
kWintergrasp.clickableTooltip = false
kWintergrasp.independentProfile = true
kWintergrasp.hideWithoutStandby = true
