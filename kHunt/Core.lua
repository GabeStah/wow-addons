-- Create Mixins
local _G = _G

local kHunt = LibStub("AceAddon-3.0"):NewAddon("kHunt", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
_G.kHunt = kHunt
local L = LibStub("AceLocale-3.0"):GetLocale("kHunt", false)
function kHunt:OnEnable() end
function kHunt:OnDisable() end
function kHunt:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kHuntDB", self.defaults)
    -- Inject Options Table and Slash Commands
	-- Create options	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kHunt", self.options, {"khunt"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.AceGUI = LibStub("AceGUI-3.0")
	-- Init Events
	self:InitializeEvents()
	self.updateFrame = CreateFrame("Frame", "kHuntUpdateFrame", UIParent);
	kHuntUpdateFrame:SetScript("OnUpdate", function(frame,elapsed) kHunt:OnUpdate(1, elapsed) end)
end

function kHunt:InitializeEvents()
	--kHunt:RegisterEvent("CHAT_MSG_WHISPER");
	-- Update
	-- Color Hex codes
	kHunt.colorHex = {};
	kHunt.colorHex['green'] = kHunt:RGBToHex(0,255,0);
	kHunt.colorHex['red'] = kHunt:RGBToHex(255,0,0);
	kHunt.colorHex['yellow'] = kHunt:RGBToHex(255,255,0);
	kHunt.colorHex['white'] = kHunt:RGBToHex(255,255,255,1);
	kHunt.colorHex['grey'] = kHunt:RGBToHex(128,128,128);
	kHunt.colorHex['orange'] = kHunt:RGBToHex(255,165,0);
	kHunt.colorHex['gold'] = kHunt:RGBToHex(175,150,0);
	kHunt.colorHex['test'] = kHunt:RGBToHex(100,255,0);
end
local lists = {
	["list 1"] = {
		id = 1,
		title = "My First List",
		desc = "Lorem ipsum",
		status = "Incomplete", -- Complete, Failed, Unavailable
		active = false,
		version = '0.0.100',
		tasks = {},
	},
	["list 2"] = {
		id = 2,
		title = "My Second list List",
		desc = "Lorem ipsum",
		status = "Incomplete", -- Complete, Failed, Unavailable
		active = true,
		version = '0.0.100',
		tasks = {
			id = 1,
			title = "Balls of Steel",
			desc = "Show those Alliance scum that you aren't one to be messed with.  Enter any one of the listed Alliance zones at the marked entrance location, turn on PVP to show them you aren't afraid, and start walking to the other side!",
			status = "Incomplete", -- Incomplete, Complete, Failed, Skipped
			worth = 5, -- Point value
			requirements = {
				{
					category = 'stealth',
					type = 'status',
					values = {false},
					complete = false,
					events = {
						{
							event = 'UNIT_AURA',
							args = {'player',}
						},
					},
				},
			},
			objectives = {
				{
					childLogic = 'OR',
					children = {
						{
							id = 'zoneCheck',
							desc = "Some description",
							category = 'zone',
							type = 'zone',
							values = {'Dun Morogh', true},
							complete = false,
							events = {
								{
									event = 'CHANGED_ZONE',
								},
							},
							children = {
								{
									id = 'zoneEast',
									desc = "Another desc",
									category = 'location',
									type = 'goto',
									values = {'Dun Morogh', 85, 45, 10}, -- zone or nil for current zone, x, y, yards for margin of error
									status = 'Incomplete', -- Complete, Incomplete
									teamStatus = {},
									order = 1,
									sequential = true,
									events = {
										{
											event = 'CHANGED_ZONE',
										},
										{
											event = 'PLAYER_MOVED',
										},
									},
								},
								{
									id = 'zoneWest',
									desc = "Another desc",
									category = 'location',
									type = 'goto',
									values = {'Dun Morogh', 25, 36, 10}, -- zone or nil for current zone, x, y, yards for margin of error
									status = 'Incomplete', -- Complete, Incomplete
									teamStatus = {},
									order = 2,
									sequential = true,
									events = {
										{
											event = 'CHANGED_ZONE',
										},
										{
											event = 'PLAYER_MOVED',
										},
									},
								},
								{
									id = 'damage',
									desc = "Another desc",
									category = 'mob',
									type = 'attack',
									values = {12345, 10000}, -- mobID, damage requirement
									status = 'Incomplete', -- Complete, Incomplete
									teamStatus = {},
									order = 3,
									sequential = true,
									events = {
										{
											event = 'COMBAT_LOG',
											args = {'DAMAGE_DEALT', 12345},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
}

function kHunt:Test()
	local requirement = kHunt:Requirement_New('stealth', 'status', {false})
	local objective = kHunt:Objective_New('location', 'goto', {'Dun Morogh', 85, 45, 10}, 'zoneEast', 'Another desc', 1, true)
	kHunt:Debug(requirement)
	kHunt:Debug(objective)
end

--[[ 
(
Objective A: Zone: Zone - Enter zone Dun Morogh
1. Location: GoTo - Go to the east entrance of Dun Morogh (85, 45).
2. Location: GoTo - Go to the west area of Dun Morogh near Gnomeregan (25, 36).
3. Mob: Attack - Deal damage to Mob A.
OR
Objective B: Zone: Zone - Enter zone Stormwind
1. Location: GoTo - Go to the southeast entrance of Stormwind (75, 65).
2. Location: GoTo - Go to the auction house area (50, 50).
3. Talk: Interact/talk-to an NPC
)

PROCESS
1. ActivateList().
2. Get active list.
3. Scan through all tasks that are Incomplete.
4. Find requirements with events.
5. Register all EVENTS as necessary.

ON_EVENT
1. Get active list.
2. Scan through all tasks that are incomplete.
3. Scan through requirements looking for matching event.
4. Upon matching event, run requirement function.
5. Set requirement "passed" value appropriately.
6. Run UpdateTasks().

UpdateTasks()
1. Get active list.
2. Scan through all tasks that are incomplete.
3. Run ValidateRequirements()

ValidateRequirements()
1. Scan through Requirements of task.
2. Missing .childLogic assumes 'AND' logic for all .children
2. If requirement.children and .logic = 'AND'
TODO:
]]

