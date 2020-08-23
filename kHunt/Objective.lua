--[[
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
]]

local objectiveEvents = {
	location = {
		goto = {
			'CHANGED_ZONE',
			'PLAYER_MOVED',
		},
	},
}

function kHunt:Objective_AddEvent(event, args, objective)
	-- Check for existing
	if objective then
		if objective.events then
			for i,v in pairs(objective.events) do
				if v.event == event and v.args == args then return end
			end
		end
		tinsert(objective.events, {event = event, args = args})
	else
		-- Create and return table
		return {event = event, args = args};
	end
end

function kHunt:Objective_GetEvents(category, type)
	category = strlower(category)
	type = strlower(type)
	local events = {};
	if category and type and objectiveEvents[category][type] then
		for i,v in pairs(objectiveEvents[category][type]) do
			tinsert(events, kHunt:Objective_AddEvent(v))
		end
	end
	return events;
end

function kHunt:Objective_New(category, type, values, id, desc, order, sequential)
	local objective = {
		category = strlower(category),
		complete = false,
		desc = desc,
		events = kHunt:Objective_GetEvents(category, type) or {},
		id = id,
		order = order or 1,
		sequential = sequential,
		status = 'Incomplete',
		teamStatus = {},
		type = strlower(type),
		values = values or {},
	}
	return objective;
end