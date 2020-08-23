function kHunt:Requirement_AddEvent(event, args, requirement)
	-- Check for existing
	if requirement then
		if requirement.events then
			for i,v in pairs(requirement.events) do
				if v.event == event and v.args == args then return end
			end
		end
		tinsert(requirement.events, {event = event, args = args})
	else
		-- Create and return table
		return {event = event, args = args};
	end
end

function kHunt:Requirement_GenerateRequirements()
	local requirement = kHunt:Requirement_New('stealth', 'status', {false})
	kHunt:Debug(requirement, 2)
	--[[ OR ]]--
	-- kHunt:Requirement_AddEvent('UNIT_AURA', 'player', requirement);
	kHunt:Debug(eventData, 2)
end

function kHunt:Requirement_GetEvents(category, type)
	category = strlower(category)
	type = strlower(type)
	local events = {};
	if category == 'stealth' then
		if type == 'status' then
			tinsert(events, kHunt:Requirement_AddEvent('UNIT_AURA', 'player'))
		end
	end
	return events;
end

function kHunt:Requirement_New(category, type, values)
	local requirement = {
		category = strlower(category),
		type = strlower(type),
		values = values or {},
		complete = false,
		events = kHunt:Requirement_GetEvents(category, type) or {},
	}
	return requirement;
end

function kHunt:Requirement_SetFlagValue(flag, value)
	
end

local eventData = {
	stealth = {
		status = {
			kHunt:Requirement_AddEvent('UNIT_AURA', 'player'),
			kHunt:Requirement_AddEvent('UNIT_AURA', 'player'),
		},
	},
};