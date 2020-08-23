--[[
RAID CREATION
1. /raidstart
2. Check if current active raid exists (db.profile.settings.raid.active)
3. If raid is active, PROMPT to continue existing raid or start new raid
4. If new raid, process closure of active raid (settings.raid.active=nil) and create NEW raid
5. If continue raid, no change.
6. NEW raid: Assign UniqueId to settings.raid.active from db.profile.raids
7. CREATE new db.profile.raids entry {id, startDate, endDate, zone, actors}
]]

local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kReminder = _G.kReminder

--[[
Create: Create instance of object in data
Destroy: Process closure of object methods
Delete: Delete object from data
Get: Retrieve object
Update: Update values of object
]]

--[[ Get actor record from raid data
]]
function kReminder:Raid_Actor(raid, name, realm, isOnline)
  local actor = self:Actor_Get(name, realm)
  raid = self:Raid_Get(raid)
  if not actor or not raid then return end
  for i,v in pairs(raid.actors) do
    if actor.name == v.name and actor.realm == v.realm then
      -- update firstOnline field if necessary
      if not v.firstOnline and isOnline then v.firstOnline = time() end
      return v
    end
  end
end

--[[ Create actor record for raid
]]
function kReminder:Raid_ActorCreate(raid, name, realm)
  if self:Raid_Actor(raid, name, realm) then return end
  local actor = self:Actor_Get(name, realm)
  raid = self:Raid_Get(raid)
  if not actor or not raid then return end
  -- Is online
  raidActor = {
    name = actor.name,
    realm = actor.realm,
    firstOnline = (self:Actor_IsOnline(actor) or self:Actor_IsOnline(actor, true)) and time() or nil
  }
  tinsert(raid.actors, raidActor)
  return raidActor
end

--[[ Create raid
]]
function kReminder:Raid_Create(id, isClient)
  -- Check if raid exists and fail out if so
  if id and self:Raid_Get(id) then return end
  -- No raid, use provided id or new if needed
  id = id or self:Utility_GenerateUniqueId()
  -- Build roster
  GuildRoster()  
  self:Roster_Update()
  -- Create empty raid table
  local raid = {
    actors = {},
    id = id,
    objectType = 'raid',
    startTime = time(),
    startDate = date(), 
  }
  tinsert(self.db.profile.raids, raid)
  -- Bump active raid
  self.db.profile.settings.raid.active = id
  self:Debug('Raid_Create', id, 3)  
  if not isClient then
    self:Comm_RaidCreate(id)  
  end
  -- ProcessEP
  self:ProcessEP()
  -- Create Raid Roster timer
  -- Unnecessary due to GUILD_ROSTER_UPDATE event
  -- self:Timer_ProcessEP()
  self:Output('Raid_Create')
  return id
end

--[[ Delete raid from database
]]
function kReminder:Raid_Delete(raid)
  raid = self:Raid_Get(raid)
  if not raid then
    self:Error('Raid_Delete', 'No valid raid to delete.')
    return
  end
  -- Destroy first
  self:Raid_Destroy(raid, true)
  -- Remove from database
  for i,v in pairs(self.db.profile.raids) do
    if v.id == raid.id then
      tremove(self.db.profile.raids, i)
      break
    end
  end
  self:Debug('Raid_Delete', 'Raid deleted: ', raid.id, 3)
end

--[[ Destroy raid
]]
function kReminder:Raid_Destroy(raid, isClient)
  raid = self:Raid_Get(raid or self.db.profile.settings.raid.active)
  -- Deactivate active
  if not raid then
    self:Error('Raid_Destroy', 'No valid raid to destroy.')
    return
  end
  if raid.id == self.db.profile.settings.raid.active then
    self.db.profile.settings.raid.active = nil
  end
  -- Set raid endTime
  raid.endTime = time()
  self:Debug('Raid_Destroy', raid.id, 3)
  -- Send raid end comm
  if not isClient then
    kReminder:Comm_RaidDestroy(raid.id)
  end
  -- Destroy Raid Roster timer
  self:Timer_Destroy('ProcessEP')
  return raid
end

--[[ Get Raid by id or raid object, most recent if not specified
]]
function kReminder:Raid_Get(raid)
  if not raid then -- assume active raid
    if not self:Raid_IsActive() then return end
    if self:Raid_GetActive() then
      return self:Raid_Get(self:Raid_GetActive())
    else
      return -- No active raid or active does not match any existing
    end
  end
  if type(raid) == 'number' then
    raid = tostring(raid)
  end
  if type(raid) == 'string' then
    --self:Debug('Raid_Get', 'type(raid) == number', raid, 1)
    for i,v in pairs(self.db.profile.raids) do
      if v.id and v.id == raid then
        self:Debug('Raid_Get', 'Raid by id match found:', raid, v, 1)
        return v
      end
    end
  elseif type(raid) == 'table' then
    --self:Debug('Raid_Get', 'type(raid) == table', raid, 1)
    if raid.objectType and raid.objectType == 'raid' then
      --self:Debug('Raid_Get', 'raid.objectType == raid', raid.objectType, 1)
      return raid
    end
  end
end

--[[ Update raid
]]
function kReminder:Raid_Update(id)
  
end

--[[ End process for Raid
]]
function kReminder:Raid_End()
  kReminder:Debug('Raid_End', 3)
  -- Verify role
  if not kReminder:Role_IsAdmin() then
    kReminder:Error('Raid_End', 'Invalid permission to end raid.')
    return
  end
  -- Destroy active raid
  local raid = kReminder:Raid_Destroy()
  kReminder:Output('Raid_End', raid)
end

--[[ Generate the initial raid roster
]]
function kReminder:Raid_GenerateRoster()
  local count, roster, currentTime, name, class, online = self:Utility_GetPlayerCount(), {}, time()
  local realm = GetRealmName()
  if count == 1 then
    roster[UnitName('player')] = self:Actor_Create(UnitName('player'), realm, UnitClass('player'), true, true, currentTime)
  else
    for i=1,count do
      name, _, _, _, class, _, _, online = GetRaidRosterInfo(i)
      if self:Actor_NameHasRealm(name) then realm = self:Actor_NameHasRealm(name) end
      roster[name] = self:Actor_Create(name, realm, class, online and true or false, true, currentTime)
    end 
  end
  return roster
end

--[[ Return the current active raid
]]
function kReminder:Raid_GetActive()
  if not self.db.profile.settings.raid.active then return end
  for i,v in pairs(self.db.profile.raids) do
    if v.id and v.id == self.db.profile.settings.raid.active then
      return v
    end
  end
end

--[[ Check if a raid is currently active
]]
function kReminder:Raid_IsActive()
  return self:Raid_GetActive() and self.db.profile.settings.raid.active
end

--[[ Check if currentzone is valid
-- TODO: verify
]]
function kReminder:Raid_IsValidZone()
  for i,v in pairs(self.db.profile.zones.validZones) do
    if self.currentZone == v then return true end
  end
end

--[[ Rebuild temporary raid roster
]]
function kReminder:Raid_RebuildRoster()
  local roster = self:Raid_GenerateRoster()
  self.roster.raid = self.roster.raid or {}
  for i,v in pairs(roster) do
    self.roster.raid[i] = v
  end
  for i,v in pairs(self.roster.raid) do
    local found = false
    for iRoster,vRoster in pairs(roster) do
      if iRoster == i then found = true end
    end
    if not found then
      self:Debug('Raid_RebuildRoster', 'Not in raid detected:', i, 1)
      self.roster.raid[i].events[#self.roster.raid[i].events].inRaid = false
    end
  end
end

--[[ Resume an active raid
]]
function kReminder:Raid_Resume()
  if self:Raid_IsActive() then
    -- Refresh roster
    local raid = self:Raid_Get()
    self:Roster_Update()
    self:Debug('Raid_Resume', 'Roster updated.', 3)
    self:Debug('Raid_Resume', 'Resume complete.', 3)
  end
end

function kReminder:Raid_Revert()
  -- Verify role
  if not kReminder:Role_IsAdmin() then
    kReminder:Error('Raid_Revert', 'Invalid permission to revert raid.')
    return
  end
  local raid = kReminder:Raid_GetActive()
  -- Is raid already active?
  if not raid then
    kReminder:Error('Raid_Revert', 'No raid is active, reversion cancelled.')
    return
  end

  -- Loop through all actors
  for iActor,actor in pairs(raid.actors) do
    if actor.onlineEP or actor.punctualEP then
      EPGP:IncEPBy(actor.name, ('[Revert] Raid @ %s'):format(raid.startDate), -1 * ((actor.onlineEP or 0) + (actor.punctualEP or 0)), nil, true)
    end
  end
  kReminder:Output('Raid_Revert', raid)
end

function kReminder:Raid_RewardEP(raid, actor, type)
  type = type or 'online'
  if not raid or not actor then return end
  local isOnline = false
  -- Check if online
  if kReminder:Actor_IsOnline(actor) or kReminder:Actor_IsOnline(actor, true) then isOnline = true end  
  -- Find exising raid actor record
  raidActor = kReminder:Raid_Actor(raid, actor.name, actor.realm, isOnline)
  if not raidActor then -- Create
    raidActor = kReminder:Raid_ActorCreate(raid, actor.name, actor.realm)
  end
  if not isOnline then return end
  if type == 'online' and not raidActor.onlineEP then
    -- Check if first online within threshold
    if raidActor.firstOnline and (raidActor.firstOnline <= (raid.startTime + self.db.profile.ep.onlineCutoffPeriod)) then
      local onlineEP, tardySeconds
      -- If firstOnline before or on raid start
      if raidActor.firstOnline <= raid.startTime then
        -- 100% Online EP
        onlineEP = self.db.profile.ep.onlineEP
      else
        onlineEP = self:Utility_Round(self.db.profile.ep.onlineEP * ((self.db.profile.ep.onlineCutoffPeriod - (raidActor.firstOnline - raid.startTime)) / self.db.profile.ep.onlineCutoffPeriod))
        penaltyEP = self.db.profile.ep.onlineEP - onlineEP
        tardySeconds = raidActor.firstOnline - raid.startTime
      end
      raidActor.onlineEP = onlineEP
      self:Debug('Online EP Reward', raidActor.name, raidActor.realm, raidActor.onlineEP, 1)
      return raidActor.onlineEP, tardySeconds, penaltyEP
    end   
  elseif type == 'punctual' and not raidActor.punctualEP then
    -- Check if first online within threshold and after or at raid start
    if raidActor.firstOnline and (raidActor.firstOnline <= (raid.startTime + self.db.profile.ep.punctualCutoffPeriod)) and (raidActor.firstOnline >= raid.startTime) then   
      raidActor.punctualEP = self:Utility_Round(self.db.profile.ep.punctualEP)
      self:Debug('Punctual EP Reward', raidActor.name, raidActor.realm, raidActor.punctualEP, 1)
      return raidActor.punctualEP
    end
  end
end

--[[ Set current zone
-- TODO: verify
]]
function kReminder:Raid_SetZone()
  self.currentZone = GetRealZoneText()  
end

--[[ Start a new raid
]]
function kReminder:Raid_Start()
  -- Verify role
  if not kReminder:Role_IsAdmin() then
    kReminder:Error('Raid_Start', 'Invalid permission to create raid.')
    return
  end 
  -- TODO: Process start of raid events
  -- Is raid already active?
  if kReminder:Raid_IsActive() then
    -- Active raid
    -- Continue existing raid?
    kReminder:View_PromptResumeRaid()
  else
    -- No active raid
    -- Create new raid
    local id = kReminder:Raid_Create()
  end
end

--[[ Update the raid roster
]]
function kReminder:Raid_UpdateRoster(raid)
  local raid = kReminder:Raid_Get(raid)
  if not raid then
    kReminder:Debug('Raid_UpdateRoster', 'No raid found:', raid, 1)
    return
  end
  -- Rebuild roster
  kReminder:Roster_Rebuild()
  -- Loop through full roster, update or add as needed
  for name,actor in pairs(kReminder.roster.full) do
    if raid.actors[name] then
      kReminder:Debug('Raid_UpdateRoster', 'Updating actor:', name, 1)
      kReminder:Actor_Update(
        raid, 
        actor.name, 
        actor.class, 
        actor.events[#actor.events].online, 
        actor.events[#actor.events].inRaid, 
        actor.events[#actor.events].time,
        actor.guildNote) 
    else
      kReminder:Debug('Raid_UpdateRoster', 'Creating actor:', name, 1)
      raid.actors[name] = kReminder:Actor_Create(
        actor.name,
        actor.realm,
        actor.class, 
        actor.events[#actor.events].online, 
        actor.events[#actor.events].inRaid, 
        actor.events[#actor.events].time,
        actor.guildNote)      
    end
  end
end