local EventFrame = CreateFrame("Frame", 'kTestMainFrame')
local destination = "Kulldar"
local AuraStack = function(value, ...) 
	if not select(1, ...) or select(1, ...) ~= 'COMBAT_LOG_EVENT_UNFILTERED' or not value then return end
	local event, comparison = select(3, ...)
	if not event or not string.find(event, '_AURA_') then return end
	if type(value) == 'string' then comparison = select(14, ...)
	elseif type(value) == 'number' then comparison = tonumber(select(13, ...))
	else return end
	if not comparison or not (value == comparison) then return end
	local stack = select(17, ...)return stack
end
local IsDestination = function(value, ...) 
	if not select(1, ...) or select(1, ...) ~= 'COMBAT_LOG_EVENT_UNFILTERED' or not value then return end
	local comparison
	if type(value) == 'string' then comparison = select(10, ...)
	elseif type(value) == 'number' then
		local GUID = select(9, ...)
		if GUID then comparison = tonumber(GUID:sub(6,10), 16) end
	else return end
	if not comparison then return end
	return (value == comparison)
end
local IsSource = function(value, ...) 
	if not select(1, ...) or select(1, ...) ~= 'COMBAT_LOG_EVENT_UNFILTERED' or not value then return end
	local comparison
	if type(value) == 'string' then comparison = select(6, ...)
	elseif type(value) == 'number' then
		local GUID = select(5, ...)
		if GUID then comparison = tonumber(GUID:sub(6,10), 16) end
	else return end
	if not comparison then return end
	return (value == comparison)
end
local IsEventType = function(value, ...)
	if not select(1, ...) or select(1, ...) ~= 'COMBAT_LOG_EVENT_UNFILTERED' or not value or type(value) ~= 'string' then return end
	local event = select(3, ...)
	if not event then return end
	if event == value then return true end
end
local IsSpell = function(value, ...)
	if not select(1, ...) or select(1, ...) ~= 'COMBAT_LOG_EVENT_UNFILTERED' or not value then return end
	local comparison
	if type(value) == 'string' then comparison = select(14, ...)
	elseif type(value) == 'number' then 
	print(select(13,...))
	comparison = tonumber(select(13, ...))
	else return end
	if not comparison then return end
	return (value == comparison)
end
EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EventFrame:SetScript("OnEvent", function(self,...) 
	if IsSource('Kulldar', ...) then
		--print('kTest', ...)
	end
    if IsSpell('Vital Mists', ...) then
		--print(...)
		if (IsEventType('SPELL_AURA_REMOVED', ...) or IsEventType('SPELL_AURA_REMOVED_DOSE', ...)) and     IsDestination(destination, ...) then
			return true
		end
	end
end)