--[[
    $Revision: 1 $
	AUTHOR: Kulldam
    PURPOSE: Utility functions
]]--

local MAJOR_VERSION = "kLibUtility-1.0";
local MINOR_VERSION = tonumber( ("$Revision: 1 $"):match( "(%d+)" ) ) + 90000

local kLibUtility, oldminor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION );
if( not kLibUtility ) then
    return;
end--if

function kLibUtility:ColorizeSubstringInString(subject,substring,r,g,b)
	local t = {};
	for i = 1, strlen(subject) do
		local iStart, iEnd = string.find(strlower(subject), strlower(substring), i, strlen(substring) + i - 1)
		if iStart and iEnd then
			for iTrue = iStart, iEnd do
				t[iTrue] = true;
			end
		else
			if not t[i] then
				t[i] = false;
			end
		end
	end
	local sOut = '';
	local sColor = kLibUtility:RGBToHex(r*255,g*255,b*255);
	for i = 1, strlen(subject) do
		if t[i] == true then
			sOut = sOut .. "|cFF"..sColor..strsub(subject, i, i).."|r";
		else
			sOut = sOut .. strsub(subject, i, i);
		end
	end
	if strlen(sOut) > 0 then
		return sOut;
	else
		return nil;
	end
end
function kLibUtility:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kLibUtility:SplitString(subject,delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( subject, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( subject, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( subject, delimiter, from  )
	end
	table.insert( result, string.sub( subject, from  ) )
	return result
end
function kLibUtility:TOCVersion()
    return tonumber( select( 4, GetBuildInfo() ) );
end

----------------------------------------
-- Base library stuff
----------------------------------------

kLibUtility.embeds = kLibUtility.embeds or {};

local mixins = {
	"ColorizeSubstringInString",
	"RGBToHex",
	"SplitString",
	"TOCVersion",
}

-- Embeds lib into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed lib in
function kLibUtility:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function kLibUtility:OnEmbedDisable(target)

end

-- Update embeds
for target, v in pairs(kLibUtility.embeds) do
	kLibUtility:Embed(target)
end