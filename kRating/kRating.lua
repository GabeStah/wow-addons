local L = AceLibrary("AceLocale-2.2"):new("kRating")
local Aura = nil
local intHonorStarting = 0;
local intHonorCurrent = 0;
local intHonorLastGame = 0;
local intGamesPlayed = 0;
local intTotalTicksPlayed = 0;
local timeStarted = nil;
local intTickGameStarted = 0;
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
						hourlyrate = {
							type = "group",
							name = "Hourly Rate",
							desc = "Announce hourly Honor rate.",
							args = {	
								enabled = {
									type = "toggle",
									name = "Enabled",
									desc = "Toggle end-of-match announcements.",
									get = "IsHourlyRateAnnounce",
									set = "SetHourlyRateAnnounce",
									map = { [false] = "Disabled", [true] = "Enabled" },
								},
								reset = {
									type = "execute",
									name = "Reset",
									desc = "Reset hourly timer.",
									func = "ResetHourlyRateTimer",
								},
							},
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
				autojoinwhileinbattle = {
					type = "toggle",
					name = "Autojoininbattle",
					desc = "Toggle start of match auto-joining while already in a battleground.",
					get = "IsJoinWhileInActiveBattle",
					set = "SetIsJoinWhileInActiveBattle",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 4,
				},				
				autoleave = {
					type = "toggle",
					name = "Autoleave",
					desc = "Toggle start of match auto-leaving.",
					get = "IsBattlegroundAutoleave",
					set = "SetBattlegroundAutoleave",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 5,
				},
				autorepop = {
					type = "toggle",
					name = "Autorepop",
					desc = "Toggle automatic release when dead in battleground.",
					get = "IsBattlegroundAutorepop",
					set = "SetBattlegroundAutorepop",
					map = { [false] = "Disabled", [true] = "Enabled" },
					order = 6,
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
			name = "kRating Menu",
			order = 1,
		},	
    },
}
if not kRating then kRating = {} end
kRating = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
kRating:RegisterChatCommand(L["Slash-Commands"], options)
kRating:RegisterDB("kRatingDB", "kRatingDBPC")
kRating:RegisterDefaults("profile", {
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
				HourlyRate = {
					Enabled = true,
				},
				Player = "Mohx",
			},
			Autojoin = true,
			Autoleave = true,
			Autorepop = true,
			Debuffs = {
				"Inactive",
			},
			Idle = false,
			JoinWhileInActiveBattle = true,
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

function kRating:OpenMenu()
	dewdrop:Open(Minimap);
end
function kRating:IsDebug()
	return self.db.profile.Globals.Debug;
end
function kRating:SetDebug(v)
	self.db.profile.Globals.Debug = v;
end
function kRating:IsEnabled()
	return self.db.profile.Globals.Enabled;
end
function kRating:SetEnabled(v)
	self.db.profile.Globals.Enabled = v;
end

-- ARENA OPTIONS
function kRating:IsArenaEnabled()
	return self.db.profile.Globals.Arena.Enabled;
end
function kRating:SetArenaEnabled(v)
	self.db.profile.Globals.Arena.Enabled = v;
end
function kRating:GetArenaTeamName()
	return self.db.profile.Globals.Arena.TeamName;
end
function kRating:SetArenaTeamName(v)
	self.db.profile.Globals.Arena.TeamName = v;
end
	--	ARENA ANNOUNCE
	function kRating:IsArenaAnnounce()
		return self.db.profile.Globals.Arena.Announce.Enabled;
	end
	function kRating:SetArenaAnnounce(v)
		self.db.profile.Globals.Arena.Announce.Enabled = v;
	end
	function kRating:GetArenaAnnounceChannel()
		return self.db.profile.Globals.Arena.Announce.Channel;
	end
	function kRating:SetArenaAnnounceChannel(v)
		self.db.profile.Globals.Arena.Announce.Channel = v;
	end
	function kRating:GetArenaAnnouncePlayer()
		return self.db.profile.Globals.Arena.Announce.Player;
	end
	function kRating:SetArenaAnnouncePlayer(v)
		self.db.profile.Globals.Arena.Announce.Player = v;
	end
	-- END ARENA ANNOUNCE
-- END ARENA OPTIONS
-- BARS OPTIONS
function kRating:IsBarsEnabled()
	return self.db.profile.Bars.Enabled;
end
function kRating:SetBarsEnabled(v)
	self.db.profile.Bars.Enabled = v;
end
-- END BARS OPTIONS
-- BATTLEGROUND OPTIONS
function kRating:IsBattlegroundEnabled()
	return self.db.profile.Globals.Battleground.Enabled;
end
function kRating:SetBattlegroundEnabled(v)
	self.db.profile.Globals.Battleground.Enabled = v;
end
function kRating:IsBattlegroundAutojoin()
	return self.db.profile.Globals.Battleground.Autojoin;
end
function kRating:SetBattlegroundAutojoin(v)
	self.db.profile.Globals.Battleground.Autojoin = v;
end
function kRating:IsBattlegroundAutoleave()
	return self.db.profile.Globals.Battleground.Autoleave;
end
function kRating:SetBattlegroundAutoleave(v)
	self.db.profile.Globals.Battleground.Autoleave = v;
end
function kRating:IsBattlegroundAutorepop()
	return self.db.profile.Globals.Battleground.Autorepop;
end
function kRating:SetBattlegroundAutorepop(v)
	self.db.profile.Globals.Battleground.Autorepop = v;
end
function kRating:SetIsJoinWhileInActiveBattle(v)
	self.db.profile.Globals.Battleground.JoinWhileInActiveBattle = v;
end
function kRating:IsJoinWhileInActiveBattle()
	return self.db.profile.Globals.Battleground.JoinWhileInActiveBattle;
end
	--	BATTLEGROUND ANNOUNCE
	function kRating:IsBattlegroundAnnounce()
		return self.db.profile.Globals.Battleground.Announce.Enabled;
	end
	function kRating:SetBattlegroundAnnounce(v)
		self.db.profile.Globals.Battleground.Announce.Enabled = v;
	end
	function kRating:GetBattlegroundAnnounceChannel()
		return self.db.profile.Globals.Battleground.Announce.Channel;
	end
	function kRating:SetBattlegroundAnnounceChannel(v)
		self.db.profile.Globals.Battleground.Announce.Channel = v;
	end
	function kRating:GetBattlegroundAnnouncePlayer()
		return self.db.profile.Globals.Battleground.Announce.Player;
	end
	function kRating:SetBattlegroundAnnouncePlayer(v)
		self.db.profile.Globals.Battleground.Announce.Player = v;
	end
	function kRating:IsHourlyRateAnnounce()
		return self.db.profile.Globals.Battleground.Announce.HourlyRate.Enabled;
	end
	function kRating:SetHourlyRateAnnounce(v)
		self.db.profile.Globals.Battleground.Announce.HourlyRate.Enabled = v;
	end
	function kRating:ResetHourlyRateTimer()
		timeStarted = GetTime();
		honorCurrent = GetHonorCurrency();
	end
	-- END BATTLEGROUND ANNOUNCE
	-- BATTLEGROUND WARNINGS
	function kRating:IsBattlegroundWarningAfk()
		return self.db.profile.Globals.Battleground.Warnings.Afk;
	end
	function kRating:SetBattlegroundWarningAfk(v)
		self.db.profile.Globals.Battleground.Warnings.Afk = v;
	end
	function kRating:GetBattlegroundWarningAfkTimer()
		return self.db.profile.Globals.Battleground.Warnings.AfkTimer;
	end
	function kRating:SetBattlegroundWarningAfkTimer(v)
		self.db.profile.Globals.Battleground.Warnings.AfkTimer = v;
	end
	function kRating:IsBattlegroundWarningIdle()
		return self.db.profile.Globals.Battleground.Warnings.Idle;
	end
	function kRating:SetBattlegroundWarningIdle(v)
		self.db.profile.Globals.Battleground.Warnings.Idle = v;
	end
	function kRating:IsBattlegroundWarningWhisper()
		return self.db.profile.Globals.Battleground.Warnings.Whisper;
	end
	function kRating:SetBattlegroundWarningWhisper(v)
		self.db.profile.Globals.Battleground.Warnings.Whisper = v;
	end
	-- END BATTLEGROUND WARNINGS
-- END BATTLEGROUND OPTIONS

function kRating:OnInitialize()
    -- Called when the addon is loaded
    if kRating:IsBarsEnabled() then
		kRating_Bars_DR:Show()
    else
		kRating_Bars_DR:Hide()
    end
end

function kRating:OnEnable()
	-- Called when the addon is enabled
    self:RegisterEvent("CHAT_MSG_WHISPER");
    self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("PLAYER_DEAD");
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	self:RegisterEvent("BATTLEFIELDS_SHOW");
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("HONOR_CURRENCY_UPDATE");
	self:RegisterEvent("UNIT_AURA")
	if not Aura then
		Aura = AceLibrary("SpecialEvents-Aura-2.0")
	end
	if not Bars then
		Bars = AceLibrary("CandyBar-2.0")
		Bars:RegisterCandyBarGroup("kRating_DR");
		Bars:SetCandyBarGroupPoint("kRating_DR", "BOTTOM", "kRating_Bars_DR", "TOP", 0, 0);
		--Bars:RegisterCandyBarGroup("kRating_TIMER");
		--Bars:SetCandyBarGroupPoint("kRating_DR", "BOTTOM", "kRating_Bars_DR", "TOP");
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
	honorCurrent = GetHonorCurrency();
	self:RegisterEvent("UpdateHonorStatsGameEnd");
	self:RegisterEvent("UpdateHonorStatsGameStart");
	kRating:ResetHourlyRateTimer();
	self:ScheduleRepeatingEvent("UpdateText", 1)
end

function kRating:OnDisable()
    -- Called when the addon is disabled
end

function kRating:OnEnter()
	GameTooltip:AddLine("kRating");
	GameTooltip:AddLine(" ");
	GameTooltip:AddLine(L["tooltip.leftClickDesc"]);
end

function kRating:AnnounceArenaScores()
	for i=0,1 do
		local teamName, oldTeamRating, newTeamRating = GetBattlefieldTeamInfo(i);
		if (oldTeamRating ~= 0 and teamName ~= kRating:GetArenaTeamName() and (teamName ~= nil or teamName ~= "")) then
			-- If they gained rating
			if (oldTeamRating < newTeamRating) then
				kRating:SendAnnouncement("Team ["..teamName.."] gained ".. (newTeamRating - oldTeamRating) .. " rating, from " .. oldTeamRating .. " to " .. newTeamRating .. ".", "arena");
			else -- Lost rating
				kRating:SendAnnouncement("Team ["..teamName.."] lost ".. (oldTeamRating - newTeamRating) .. " rating, from " .. oldTeamRating .. " to " .. newTeamRating .. ".", "arena");
			end
		end			
	end
end

function kRating:DebuffCheck()
	for k, debuff in ipairs( self.db.profile.Globals.Battleground.Debuffs ) do
		if Aura:UnitHasDebuff("player", debuff) then
			if (self.db.profile.Globals.Battleground.Idle == nil) then
				self.db.profile.Globals.Battleground.Idle = true;
				kRating:BattlegroundWarningIdle();
			end
		else
			self.db.profile.Globals.Battleground.Idle = nil;
		end
	end
end

function kRating:HONOR_CURRENCY_UPDATE()
	self:UpdateText();
end
function kRating:Debug(msg, r, g, b)
	if self.db.profile.Globals.Debug then
		if r and g and b then
			DEFAULT_CHAT_FRAME:AddMessage("kRating: Debug: " .. msg, r, g, b);
		else
			DEFAULT_CHAT_FRAME:AddMessage("kRating: Debug: " .. msg, 1, 1, 0);
		end
	end
end
function kRating:UPDATE_BATTLEFIELD_SCORE()
	kRating:Debug("UPDATE_BATTLEFIELD_SCORE event fire.", 1, 1, 0);
	if (kRating:IsEnabled() and kRating:IsInArena() and kRating:IsArenaEnabled()) then
		kRating:UnregisterEvent("AnnounceArenaScores");
		kRating:RegisterEvent("AnnounceArenaScores");
		kRating:CancelAllScheduledEvents();
		kRating:ScheduleEvent("AnnounceArenaScores", 2);
	elseif (kRating:IsEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundAutoleave()) then
		kRating:Debug("UPDATE_BATTLEFIELD_SCORE, subs: kRating:IsEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundAutoleave().", 1, 1, 0);
		if (GetBattlefieldInstanceExpiration() ~= 0) then
			kRating:Debug("UPDATE_BATTLEFIELD_SCORE, subs: kRating:IsEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundAutoleave() and GetBattlefieldInstanceExpiration ~= 0.", 1, 1, 0);
			kRating:LeaveBattleground();
			self:ScheduleEvent("LeaveBattleground", 3);
		end
	end
end
function kRating:SendAnnouncement(message, type)
	if (type == "arena" and kRating:IsArenaAnnounce() and kRating:IsInArena()) then
		SendChatMessage("kRating [Arena]: " .. message, kRating:GetArenaAnnounceChannel(), nil, kRating:GetArenaAnnouncePlayer());
	elseif (type == "battleground" and kRating:IsBattlegroundAnnounce() and kRating:IsInBattleground()) then
		SendChatMessage("kRating [Battleground]: " .. message, kRating:GetBattlegroundAnnounceChannel(), nil, kRating:GetBattlegroundAnnouncePlayer());
	end
end
function PlayerJumped()
	-- Check if inside Battleground
	if (kRating:IsBattlegroundEnabled() and kRating:IsBattlegroundWarningAfk() and kRating:IsInBattleground()) then
		kRating:UnregisterEvent("BattlegroundWarningAfk");
		kRating:RegisterEvent("BattlegroundWarningAfk");
		kRating:CancelAllScheduledEvents();
		kRating:ScheduleEvent("BattlegroundWarningAfk", (300 - kRating:GetBattlegroundWarningAfkTimer()));
	end
end
function kRating:IsInBattleground()
	if (GetRealZoneText() == "Alterac Valley") or (GetRealZoneText() == "Warsong Gulch") or (GetRealZoneText() == "Arathi Basin") or (GetRealZoneText() == "Eye of the Storm") or (GetRealZoneText() == "Strand of the Ancients") or (GetRealZoneText() == "Isle of Conquest") then
		return true;
	end
	return nil;
end
function kRating:IsInArena()
	return IsActiveBattlefieldArena();
end
function kRating:CHAT_MSG_WHISPER()
	kRating:BattlegroundWarningWhisper(arg1, arg2);
end
function kRating:BATTLEFIELDS_SHOW()
	if (IsBattlefieldArena()) then return end;
	if (kRating:IsEnabled() and kRating:IsBattlegroundEnabled()) then
		if (CanJoinBattlefieldAsGroup()) then
		  -- Queue as a group for the first available battleground
		  JoinBattlefield(0, 1);
		else
		  -- Solo queue for the first available battleground
		  JoinBattlefield(0);
		end
		CloseBattlefield();
		DEFAULT_CHAT_FRAME:AddMessage("kRating: You have joined the queue for 	"..GetBattlefieldInfo()..".", 1, 1, 0);
		kRating:AnnounceHourlyRate();
	end
end
function kRating:GetHourlyRate()
	return math.floor((GetHonorCurrency() - honorCurrent) / ((GetTime() - timeStarted) / 3600));
end
function kRating:AnnounceHourlyRate()
	if (kRating:IsHourlyRateAnnounce()) then
		DEFAULT_CHAT_FRAME:AddMessage("kRating: Current hourly rate: " .. kRating:GetHourlyRate() .. ".", 1, 1, 0);
	end
end
function kRating:UPDATE_BATTLEFIELD_STATUS()
	if (kRating:IsInBattleground() == nil) then
		for i=1, MAX_BATTLEFIELD_QUEUES do
			status, map, id = GetBattlefieldStatus(i);
			if (status == "confirm" and kRating:IsEnabled() and kRating:IsBattlegroundEnabled() and kRating:IsBattlegroundAutojoin()) then
				kRating:Debug("UPDATE_BATTLEFIELD_STATUS, join 1");
				kRating:SendAnnouncement("Now entering ["..map.."]!", "battleground");
				kRating:ScheduleEvent("JoinBattleground", 5, i);
			end
		end	
	elseif (kRating:IsInBattleground() and kRating:IsJoinWhileInActiveBattle()) then
		for i=1, MAX_BATTLEFIELD_QUEUES do
			status, map, id = GetBattlefieldStatus(i);
			if (status == "confirm" and kRating:IsEnabled() and kRating:IsBattlegroundEnabled() and kRating:IsBattlegroundAutojoin()) then
				kRating:Debug("UPDATE_BATTLEFIELD_STATUS, join 1");
				kRating:SendAnnouncement("Now entering ["..map.."]!", "battleground");
				kRating:ScheduleEvent("JoinBattleground", 5, i);
			end
		end	
	end
end
function kRating:JoinBattleground(i)
	kRating:Debug("JoinBattleground index: ".. i);
	AcceptBattlefieldPort(i, 1);
	StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
	self:CancelAllScheduledEvents();
	self:ScheduleEvent("UpdateHonorStatsGameStart", 2);	
end
function kRating:UpdateHonorStatsGameStart()
	-- Update Honor Stats
	intHonorLastGame = 0;
	intHonorCurrent = GetHonorCurrency();
	intTickGameStarted = GetTime();
end
function kRating:UpdateHonorStatsGameEnd()
	-- Update Honor Stats
	intGamesPlayed = intGamesPlayed + 1; -- Update total games played
	intHonorLastGame = GetHonorCurrency() - intHonorCurrent; -- Calc the honor from previous game
	intHonorCurrent = GetHonorCurrency();
	intTotalTicksPlayed = intTotalTicksPlayed + (GetTime() - intTickGameStarted); -- Add total game ticks to total ticks played
	-- Display Honor Stats
	kRating:DisplayHonorStats();
end
function kRating:DisplayHonorStats()
	intHonorGained = intHonorCurrent - intHonorStarting;
	strOutput = "kRating: STATS - Last Game [" .. intHonorLastGame .. "], Avg Honor Per Game [" .. (intHonorGained / intGamesPlayed) .. "], Avg Honor Per Hour [" .. (intHonorGained / ((intTotalTicksPlayed / 60) / 60)) .. "]."
	DEFAULT_CHAT_FRAME:AddMessage(strOutput, 1, 1, 0);
end
-- Match starts
function kRating:CHAT_MSG_BG_SYSTEM_NEUTRAL()
	if (arg1 == "The battle for Alterac Valley has begun!") or (arg1 == "Let the battle for Warsong Gulch begin.") or (arg1 == "Let the battle for the Strand of the Ancients begin.") then
		if (kRating:IsBattlegroundEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundAnnounce()) then
			kRating:SendAnnouncement("The Battleground has begun.", "battleground");
		end
	end
end
-- PURPOSE: Autorelease when player dies in battleground
function kRating:PLAYER_DEAD()
	if (kRating:IsEnabled() and kRating:IsBattlegroundAutorepop() and kRating:IsInBattleground()) then
		RepopMe();
	end
end
function kRating:FlashFrame()
	LowHealthFrame:Hide();
	UIFrameFlash(LowHealthFrame, 0.25, 0.75, 2.2, false, 0, 0.1);
end
function kRating:BattlegroundWarningAfk()
	if (kRating:IsEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundEnabled() and kRating:IsBattlegroundWarningAfk()) then
		kRating:SendAnnouncement("Afk Warning - 10 seconds to react! [jump]", "battleground");
		self:ScheduleEvent("FlashFrame", 1);
		self:ScheduleEvent("FlashFrame", 3);
		self:ScheduleEvent("FlashFrame", 5);
		self:ScheduleEvent("FlashFrame", 7);
		PlaySoundFile("Interface\\AddOns\\kRating\\Sounds\\startup.wav");
	end
end
function kRating:BattlegroundWarningIdle()
	if (kRating:IsEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundEnabled() and kRating:IsBattlegroundWarningIdle()) then
		kRating:SendAnnouncement("Idle Warning - No honor earnings!", "battleground");
		self:ScheduleEvent("FlashFrame", 1);
		self:ScheduleEvent("FlashFrame", 3);
		self:ScheduleEvent("FlashFrame", 5);
		self:ScheduleEvent("FlashFrame", 7);
		PlaySoundFile("Interface\\AddOns\\kRating\\Sounds\\startup.wav");
	end
end
function kRating:BattlegroundWarningWhisper(message, fromPlayer)
	if (kRating:IsEnabled() and kRating:IsInBattleground() and kRating:IsBattlegroundEnabled() and kRating:IsBattlegroundWarningWhisper()) then
		kRating:SendAnnouncement("Tell from " .. fromPlayer .. ": " .. message, "battleground");
		self:ScheduleEvent("FlashFrame", 1);
		self:ScheduleEvent("FlashFrame", 3);
		self:ScheduleEvent("FlashFrame", 5);
		self:ScheduleEvent("FlashFrame", 7);
		PlaySoundFile("Interface\\AddOns\\kRating\\Sounds\\welcome.wav");
	end
end
function kRating:LeaveBattleground()
	if (kRating:IsEnabled() and kRating:IsBattlegroundEnabled()) then
		kRating:SendAnnouncement("Leaving battleground.", "battleground");
		self:ScheduleEvent("FlashFrame", 1);
		self:ScheduleEvent("FlashFrame", 3);
		self:ScheduleEvent("FlashFrame", 5);
		self:ScheduleEvent("FlashFrame", 7);
		PlaySoundFile("Interface\\AddOns\\kRating\\Sounds\\welcome.wav");
		kRating:Debug("LeaveBattleground().", 1, 1, 0);
		LeaveBattlefield();
		self:CancelAllScheduledEvents();
		self:ScheduleEvent("UpdateHonorStatsGameEnd", 2);
	end
end
function kRating:UnregisterActiveSpell(spellId)
end
function kRating:COMBAT_LOG_EVENT_UNFILTERED(tstamp,event,srcGUID,srcName,srcFlags,destGUID,destName,destFlags,...)
	if self.db.profile.Bars.Enabled == false then return nil; end
	local fromPlayer, toPlayer = false, false;
	local me = UnitName("player");
	if srcName and srcName == me then 
		fromPlayer = true;
	end
	if destName and destName == me then
		toPlayer = true;
	end
	
	local intSpellId = select(1,...);
	local strDestGuid = strsub(tostring(destGUID),3);	
	local isSourceEnemy = (bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE);
	local isDestEnemy = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE);
	local isDestTarget = (bit.band(destFlags, COMBATLOG_OBJECT_TARGET) == COMBATLOG_OBJECT_TARGET);
	
	if event == "SPELL_AURA_APPLIED" then
		if isDestEnemy then
			-- Check if spell is tracking
			for iTrack, spellTrack in pairs(self.db.profile.Bars.Auras) do
				if spellTrack.Id == intSpellId then -- Match found, proceed
					local booActiveSpellMatch = false;
					for i, spell in pairs(self.ActiveSpells) do
						-- Check for matching active spell
						if spell.Id == intSpellId and spell.DestGuid == strDestGuid then 
							booActiveSpellMatch = true;
							local intCastCount = self.ActiveSpells[i].CastCount;
							intCastCount = intCastCount + 1;
							if intCastCount >= 4 then -- Should've hit DR by now, assuming new DR counter
								self.ActiveSpells[i].CastCount = 1;
							else
								self.ActiveSpells[i].CastCount = intCastCount; -- Increment cast Count
								self.ActiveSpells[i].Duration = spellTrack.Duration; -- Set default duration before DR
								-- For each DR, divide duration by half
								for i=1,intCastCount do
									self.ActiveSpells[i].Duration = (self.ActiveSpells[i].Duration / 2);
								end
							end
						end
					end	
					-- No active, new spell/target
					if not booActiveSpellMatch then
						local name, rank, icon = GetSpellInfo(intSpellId);
						self.ActiveSpells[#self.ActiveSpells-1] = {Id = intSpellId, DestGuid = strDestGuid, CastCount = 1, Duration = spellTrack.Duration};
						ChatFrame1:AddMessage("Spell added to ActiveSpells: " .. intSpellId .. ", " .. name);
						Bars:RegisterCandyBar(kRating:GetBarName("DR", intSpellId, strDestGuid), spellTrack.Duration, kRating:GetBarName("DR", intSpellId, strDestGuid), icon) 
						Bars:RegisterCandyBarWithGroup(kRating:GetBarName("DR", intSpellId, strDestGuid), "kRating_DR");
						Bars:StartCandyBar(kRating:GetBarName("DR", intSpellId, strDestGuid), true);	
						kRating:ExplodeBarName(kRating:GetBarName("DR", intSpellId, strDestGuid));
					end				
				end
			end
			ChatFrame1:AddMessage("Aura Applied to " .. destName .. " of guid " .. strsub(tostring(destGUID),3) .. ": " .. select(4,...) .. ", id: " .. select(1,...));
			--[[
			local unit = destName;
			local aura = select(4,...);
			if unit and aura == "BUFF" then
				local guidstr = strsub(tostring(destGUID),3);
				if guidstr then
					unit = unit..":"..guidstr;
				end
				local buff = select(2,...);
				if buff and self.enemySkills[buff] then
					if not self.units[unit] then self.units[unit] = new(); end
					self.units[unit][buff] = "enem";
					local buffid = select(1,...);
					local bufficon = nil;
					if buffid and type(buffid) == "number" then
						bufficon = select(3, GetSpellInfo(buffid));
					end				
					self:UpdateBar(unit, buff, bufficon, nil, self.enemySkills[buff].duration, self.enemySkills[buff].duration, false, "enem"); --- Driizt
				end
			end
			]]
		end
	end
end

function kRating:GetBarName(type, spellId, destId)
	if spellId and destId and type then
		return (type .. ":" ..spellId .. ":" .. destId);
	else
		return nil;
	end
end
function kRating:ExplodeBarName(name)
	if name then
		ChatFrame1:AddMessage("name:" ..name);
		local spellType, spellId, destId = kRating:SplitString(":", name);
		ChatFrame1:AddMessage("spellId: " .. spellId);
		ChatFrame1:AddMessage("destId: " .. destId);
		ChatFrame1:AddMessage("spellType: " .. spellType);
	end
end

function kRating:SplitString(delimiter, text)
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
kRating.blizzardTooltip = true;
kRating.cannotDetachTooltip = true;
kRating.clickableTooltip = false;
kRating.defaultMinimapPosition = 285;
kRating.defaultPosition = "CENTER";
kRating.hasIcon = "Interface\\Icons\\Spell_Shadow_SummonVoidWalker";
kRating.hasNoColor = true;
kRating.hasNoText = false;
kRating.tooltipHiddenWhenEmpty = true;

function kRating:UpdateText(text)
	if (text == nil) then
		self:SetText(kRating:GetHourlyRate() .. " / hr");
	else
		self:SetText(text);
	end
end
function kRating:OnClick(button)
	DEFAULT_CHAT_FRAME:AddMessage("kRating: Session timer reset.", 1, 1, 0);
	kRating:ResetHourlyRateTimer();
	self:UpdateText("0 / hr");
end


