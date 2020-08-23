--[[ Point_CreatePoint
PURPOSE: Create a new POINT
ARGS:	name [string] - POINT name
		iconType [number] - Type of POINT to create
		xCoord [number] - x coordinate to place POINT on
		yCoord [number] - y coordinate to place POINT on
		parentFrame [frame] - (optional) Parent frame to attach to
]]
function kFormation:Point_CreatePoint(name, iconType, xCoord, yCoord, parentFrame)
	local point = CreateFrame("Frame", name, parentFrame, "kFormationPointTemplate");
end