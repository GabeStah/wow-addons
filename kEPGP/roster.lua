local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Update full roster from raid/guild rosters
]]
function kEPGP:Roster_Update()
  -- from guild
  local count = GetNumGuildMembers()
  local currentTime = time()
  local hasStanding, ep, gp, main
  for i=1,count do
    local name, _, _, _, class, _, note, officerNote, online = GetGuildRosterInfo(i)   
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(name)
    --ep, gp, main = EPGP:GetEPGP(self:Actor_Name(name))
    hasStanding = (ep and (not main)) and true or false
    if hasStanding then
      self:Actor_Create(name, class, online and true or false, false, currentTime, note, officerNote, main, hasStanding)
    end
  end 

  -- From raid
  local count, name, class, online = self:Utility_GetPlayerCount()
  if count == 1 then
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(self:Actor_Name(UnitName('player')))
    hasStanding = (ep and (not main)) and true or false    
    if hasStanding then
      self:Actor_Create(self:Actor_Name(UnitName('player')), UnitClass('player'), true, true, currentTime, nil, nil, main, hasStanding)
    end
  else
    for i=1,count do
      local name, rank, _, _, class, _, _, online = GetRaidRosterInfo(i)
      -- Get EPGP info
      ep, gp, main = EPGP:GetEPGP(name)
      hasStanding = (ep and (not main)) and true or false
      if hasStanding then
        self:Actor_Create(name, class, online and true or false, true, currentTime, nil, nil, main, hasStanding, rank)
      end
    end 
  end
end

--[[ Rebuild full roster from raid/guild rosters
]]
function kEPGP:Roster_Rebuild()
  self:Guild_RebuildRoster()
  self:Raid_RebuildRoster()
  self.roster.full = self:Roster_Generate()
end