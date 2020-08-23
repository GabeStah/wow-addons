kRadius = LibStub("AceAddon-3.0"):NewAddon("kRadius", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
self = kRadius;
function kRadius:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kRadiusDB", self.defaults)
    -- Inject Options Table and Slash Commands
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.candyBar = LibStub("CandyBar-2.0");
	--self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kRadius", self.options, {"kradius", "kr"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.aceGui = LibStub("AceGUI-3.0")
	self.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	self.ae = LibStub("AceEvent-2.0")
	self.effects = LibStub("LibEffects-1.0")
	self.oo = LibStub("AceOO-2.0")
	self.qTip = LibStub("LibQTip-1.0")
	self.roster = LibStub("Roster-2.1")
	self.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	self:RegisterLibSharedMediaObjects();
	self.tablet = LibStub("Tablet-2.0")
	--[[
	-- Init Events
	self:InitializeEvents()
	-- Comm registry
	self:RegisterComm("kRadius")
	-- Frames
	self.selectedAuctionIndex = 0;
	self.auctions = {};
	self.localAuctionData = {};
	self:Gui_InitializePopups();
	self:Gui_InitializeFrames()
	self:Gui_HookFrameRefreshUpdate();
	]]
end

function kRadius:OnInitialize()
    -- Called when the addon is loaded
end

function kRadius:OnEnable()
	-- Called when the addon is enabled
end

function kRadius:OnDisable()
    -- Called when the addon is disabled
end
