--[[
    $Revision: 1 $
	AUTHOR: Kulldam
    PURPOSE: Debug functions
]]--

local MAJOR_VERSION = "kLibDebug-1.0";
local MINOR_VERSION = tonumber( ("$Revision: 1 $"):match( "(%d+)" ) ) + 90000

local kLibDebug, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not kLibDebug ) then
    return;
end

function kLibDebug:Debug(msg, threshold)
	if self.db.profile.debug.enabled then
		if threshold == nil then
			self:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= self.db.profile.debug.threshold then
			self:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end

----------------------------------------
-- Base library stuff
----------------------------------------

kLibDebug.embeds = kLibDebug.embeds or {};

local mixins = {
	"Debug",
}

-- Embeds lib into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed lib in
function kLibDebug:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function kLibDebug:OnEmbedDisable(target)

end

-- Update embeds
for target, v in pairs(kLibDebug.embeds) do
	kLibDebug:Embed(target)
end