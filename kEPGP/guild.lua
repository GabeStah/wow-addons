local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Generate and return current guild roster
]]
function kEPGP:Guild_GenerateRoster()
  GuildRoster()
  local count = GetNumGuildMembers()
  local roster, currentTime = {}, time()
  local hasStanding
  for i=1,count do
    local name, rank, _, _, class, _, note, officerNote, online = GetGuildRosterInfo(i)   
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(name)
    hasStanding = (ep and (not main)) and true or false
    roster[name] = self:Actor_Create(name, class, online and true or false, false, currentTime, note, officerNote, main, hasStanding, rank)
  end 
  return roster
end

--[[ Build reset roster 
]]
function kEPGP:Guild_GetResetRoster()
  -- Check if reset enabled
  if not self.db.profile.reset.enabled then return end
  -- Get roster
  GuildRoster()
  local count = GetNumGuildMembers()
  local roster, currentTime = {}, time()
  local hasStanding
  local output = {}
  for i=1,count do
    local name, rank, _, _, class, _, note, officerNote, online = GetGuildRosterInfo(i)
    -- Check if hasStanding
    ep, gp, main = EPGP:GetEPGP(name)
    hasStanding = (ep and (not main)) and true or false        
    if hasStanding then
      roster[name] = self:Actor_Create(name, class, online and true or false, false, currentTime, note, officerNote, main, hasStanding, rank, ep, gp)
    end
  end  

  for i,v in pairs(roster) do
    -- By rank or note
    if (v.rank and v.rank == self.db.profile.reset.rank) or (v.guildNote and strfind(strlower(v.guildNote), strlower(self.db.profile.reset.rank))) then
      tinsert(output, v)
    end
  end

  if output and #output > 1 then
    -- Randomize
    output = self:Utility_Shuffle(output)
  end

  return output  
end

--[[ Rebuild temporary guild roster
]]
function kEPGP:Guild_RebuildRoster()
  local roster = self:Guild_GenerateRoster()
  self.roster.guild = self.roster.guild or {}
  for i,v in pairs(roster) do
    self.roster.guild[i] = v
  end
  for i,v in pairs(self.roster.guild) do
    local found = false
    for iRoster,vRoster in pairs(roster) do
      if iRoster == i then found = true end
    end
    if not found then
      self:Debug('Guild_RebuildRoster', 'Offline detected:', i, 1)
      self.roster.guild[i].events[#self.roster.guild[i].events].online = false
    end
  end
end