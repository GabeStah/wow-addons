local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Create new Actor entry
]]
function kEPGP:Actor_Create(name, class, online, inRaid, time, guildNote, officerNote, mainCharacter, hasStanding, rank, ep, gp)
  local actor = {
    class = class,          
    events = {
      {
        inRaid = inRaid,
        online = online,
        time = time or time(),
      },
    },
    guildNote = guildNote,
    hasStanding = hasStanding,
    officerNote = officerNote,
    mainCharacter = mainCharacter,
    name = name, 
    objectType = 'actor',
    rank = rank,
    ep = ep or 0,
    gp = gp or 0,
  }
  existing = self:Actor_Get(name)
  if existing then
    -- Update
    return self:Actor_Update(name, online, inRaid, time, guildNote, officerNote, mainCharacter, hasStanding, rank, ep, gp)
  else
    -- Add
    tinsert(self.actors, actor)
  end
  return actor
end

--[[ Get actor object
]]
function kEPGP:Actor_Get(name)
  if not name then return end
  if type(name) == 'string' then
    for i,v in pairs(self.actors) do
      if v.name == name then
        return self.actors[i]
      end
    end
  elseif type(name) == 'table' then
    if name.objectType and name.objectType == 'actor' then return name end
  end
end

function kEPGP:Actor_IsOnline(actor, includeAlts)
  actor = self:Actor_Get(actor)
  if not actor then return end
  -- Find last event, check if online
  local event = actor.events[#actor.events]
  if event.online then return event.online end  
  if includeAlts then
    -- Scan for alts
    name = kEPGP:Actor_Name(actor)
    local altCount = EPGP:GetNumAlts(name)
    if altCount >= 0 then
       for count=1,altCount do
          alt = self:Actor_Get(EPGP:GetAlt(name, count))
          event = alt.events[#alt.events]
          if event.online then return event.online end
       end
    end
  end
  return false
end

function kEPGP:Actor_Name(actor)
  -- actor = self:Actor_Get(actor)
  -- if not actor then return end
  -- if includeRealm then
  --   return ('%s-%s'):format(actor.name, actor.realm)
  -- else
  --   return actor.name
  -- end  
  if not actor then return end
  local actor_object = self:Actor_Get(actor)
  local realm = GetRealmName()
  if self:Actor_NameHasRealm(actor) then
    return actor
  else
    return ('%s-%s'):format(actor, realm) or actor
  end
end

function kEPGP:Actor_NameHasRealm(actor)
  if not actor then return end
  return strmatch(actor, '-(.+)')
end

function kEPGP:Actor_NameOnly(actor)
  if not actor then return end
  return Ambiguate(self:Actor_Name(actor), 'none')
end

--[[ Update actor entry in raid table
]]
function kEPGP:Actor_Update(name, online, inRaid, time, guildNote, officerNote, mainCharacter, hasStanding, rank, ep, gp)
  if not name then 
    self:Debug('Actor_Update', 'No name found.', 1)
    return
  end
  local actor = self:Actor_Get(name)
  if actor then
    --self:Debug('Actor_Update', 'Actor found:', actor, 1)
    -- Check if last event online status does not match current online status
    if actor.events and #actor.events >= 1 then
      --self:Debug('Actor_Update', 'Actor events found:', actor.events, 1)
      if (actor.events[#actor.events].online ~= online) or (actor.events[#actor.events].inRaid ~= inRaid) then
        --self:Debug('Actor_Update', 'Actor online or inRaid mismatch, updating.', 1)
        -- Create new event
        local event = {
          inRaid = inRaid,
          online = online,
          time = time or time(),
        }
        tinsert(actor.events, event)
      end
    end
    -- Update fields
    actor.guildNote 	  = guildNote
    actor.officerNote 	= officerNote
    actor.mainCharacter = mainCharacter
    actor.hasStanding 	= hasStanding
    actor.rank 			    = rank
    actor.ep            = ep or 0
    actor.gp            = gp or 0
    return actor -- Found, return true
  end
end