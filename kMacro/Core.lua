--[[
TODO
('/cast [spec:1,mod:shift]%s;[mod:ctrl]Dampen Harm;[mod:alt]Transcendence;Blackout Kick'):format(
'{d\s1+t15|s2\s3?Clash\Soothing Mist\Fists of Fury}')
d\s1+t15|s2\s3?Clash\Soothing Mist\Fists of Fury
d?Clash\s1+t15|s2?Soothing Mist\s3?Fists of Fury
t9+(s1|s4)\s4\s2|s3|d?[mod:shift,@mouseover]Innervate\[mod:shift,@focus]Cyclone\[mod:ctrl,harm,stance:1/3]Swipe

t9+(s1|s4)?[mod:shift,@mouseover]Innervate\s4?[mod:shift,@focus]Cyclone\s2|s3|d?[mod:ctrl,harm,stance:1/3]Swipe

Syntax highlighting???

]]

--[[
Detect possible combos for each macro and give "test" dropdown to select them and see how macro looks.
]]

-- Create Mixins
local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strlen, strjoin, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.len, string.join, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error, pcall = loadstring, assert, error, pcall
local kMacro = LibStub("AceAddon-3.0"):NewAddon("kMacro", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
_G.kMacro = kMacro
kMacro.gui = {};
kMacro.gui.frames = {};
local INSERT_LOGIC_MACRO_SEPARATOR = '?'
local INSERT_POINT_TEXT = '%s'
local INSERTIONS_GENERATION_SEPARATOR = '&'
local NUMBER_LOGIC_MATCH_PATTERN = '[stg](%d+)'
local GENERAL_MACRO_COUNT = select(4, GetBuildInfo()) >= 60000 and 120 or 36
local CHARACTER_MACRO_COUNT = 18
function kMacro:OnEnable() end
function kMacro:OnDisable() end
function kMacro:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kMacroDB", self.defaults)
    -- Inject Options Table and Slash Commands
	-- Create options	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kMacro", self.options, {"kmacro", "kmac"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.AceGUI = LibStub("AceGUI-3.0")
	-- Init Events
	self:InitializeEvents()
	self.updateFrame = CreateFrame("Frame", "kMacroUpdateFrame", UIParent)
	kMacroUpdateFrame:SetScript("OnUpdate", function(frame,elapsed) kMacro:OnUpdate(1, elapsed) end)
end

function kMacro:InitializeEvents()
	kMacro:RegisterEvent('PLAYER_ENTERING_WORLD')
	kMacro:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
	kMacro:RegisterEvent('ZONE_CHANGED')
	kMacro:Options_BuildMacroOptions();
	-- Update
	-- Color Hex codes
	kMacro.colorHex = {};
	kMacro.colorHex['green'] = kMacro:RGBToHex(0,255,0);
	kMacro.colorHex['red'] = kMacro:RGBToHex(255,0,0);
	kMacro.colorHex['yellow'] = kMacro:RGBToHex(255,255,0);
	kMacro.colorHex['white'] = kMacro:RGBToHex(255,255,255,1);
	kMacro.colorHex['grey'] = kMacro:RGBToHex(128,128,128);
	kMacro.colorHex['orange'] = kMacro:RGBToHex(255,165,0);
	kMacro.colorHex['gold'] = kMacro:RGBToHex(175,150,0);
	kMacro.colorHex['test'] = kMacro:RGBToHex(100,255,0);
end

function kMacro:AddMacro(name, isGeneral, instanceName)
	local lowIndex = isGeneral and 1 or (GENERAL_MACRO_COUNT + 1)
	local highIndex = isGeneral and GENERAL_MACRO_COUNT or (GENERAL_MACRO_COUNT + CHARACTER_MACRO_COUNT + 1)
	local currentName, currentTexture, currentBody
	local matchFound = false;
	-- Check if macro exists with name in appropriate location
	for iMacro=lowIndex,highIndex do
		currentName, currentTexture, currentBody = GetMacroInfo(iMacro)
		--self:Debug(currentName)
		if name == currentName then 
			matchFound = iMacro
			break
		end
	end
	if not matchFound then 
		print('No matching macro exists to overwrite');
		return
	end
	local macro = {
		body = currentBody,
		id = kMacro:GetUniqueMacroId(),
		isGeneral = isGeneral,
		instanceName = instanceName,
		name = name,		
		visible = true,
	}	
	tinsert(self.db.profile.macros.list, macro);
end

function kMacro:CreateCodeString(cat, num, properName)
	if not cat then return end
	local code
	if cat == 't' and num then
		code = properName and ('%s'):format((kMacro:GetTalentInfoFromNum(num) and select(2, kMacro:GetTalentInfoFromNum(num))) or 'INVALID_TALENT') or ('select(5,kMacro:GetTalentInfoFromNum(%s))'):format(num)
	elseif cat == 's' and num then
		code = properName and ('%s'):format((GetSpecializationInfo(num) and select(2, GetSpecializationInfo(num))) or 'INVALID_SPEC') or ('GetSpecialization() == %s'):format(num)	
	elseif cat == 'g' and num then
		self:Debug('NUM: ' .. num, 3)
		code = properName and ('%s'):format((GetSpellInfo(num) and GetSpellInfo(num)) or 'INVALID_GLYPH_SPELL') or ('kMacro:IsGlyphActive(%s)'):format(num)
	elseif cat == 'g' then
		self:Debug('cat: ' .. cat, 3)
		if num then
			self:Debug('num: ' .. num, 3)		
		else
			self:Debug('num: NO_NUM', 3)		
		end
	elseif cat == 'd' then
		code = properName and 'Default' or 'true'
	elseif cat == '+' then
		code = 'and'
	elseif cat == '/' then
		code = 'or'      
	else
		code = cat
	end
	return code and ('%s '):format(code)
end

function kMacro:ContainsInvalidSpecOrTalent(data)
	for i,v in pairs(data) do
		if v.readable and (string.find(v.readable, 'INVALID_SPEC', 1, true) or string.find(v.readable, 'INVALID_TALENT', 1, true)) then
			return true
		end
	end
	return false
end

function kMacro:DeleteMacro(id)
	-- Check not in combat
	if InCombatLockdown() then return end
	for i,v in pairs(self.db.profile.macros.list) do
		-- find match
		if v.id == id then
			--self:Debug('delete:'..v.id)
			self.db.profile.macros.list[i] = nil;
		end
	end
end

function kMacro:DoesDefaultLogicExist(data)
	for i,v in pairs(data) do
		if v.raw == 'd' then return true end
	end
	return false
end

function kMacro:EnableMacro(macro)
	local lowIndex = macro.isGeneral and 1 or (GENERAL_MACRO_COUNT + 1)
	local highIndex = macro.isGeneral and GENERAL_MACRO_COUNT or (GENERAL_MACRO_COUNT + CHARACTER_MACRO_COUNT + 1)
	local currentName, currentTexture, currentBody;
	local index = 0;	
	for iMacro=lowIndex,highIndex do
		currentName, currentTexture, currentBody = GetMacroInfo(iMacro)
		if macro.name == currentName then 
			local insertions, count = self:GetMacroInsertions(macro)	
			if not InCombatLockdown() then 
				if insertions then
					EditMacro(iMacro, nil, nil, self:GetMacroBodyFinal(macro, insertions))
					self:Debug('Enable '..iMacro..': '..macro.name)
					return true
				else
					EditMacro(iMacro, nil, nil, self:GetMacroBodyFinal(macro))
					self:Debug('Enable '..iMacro..': '..macro.name)
					return true
				end
			end
		end
	end
end

function kMacro:GetCodeString(val, s, e, properName)
	if not val then return end
	local iStart = s or strlen(val)
	local iEnd = e or strlen(val)
	local fType, fStart, fEnd, fNum = self:GetLogicValue(val, iStart, iEnd)
	local code = self:CreateCodeString(fType, fNum, properName)
	if code then
		return code, iEnd
	end		
end

function kMacro:GetDataTable(val)
	local tabLogic, tabMacro;
	if type(val) ~= 'string' then return end
	if not string.find(val, '?', 1, true) then return end
	local oSplit = {strsplit(INSERT_LOGIC_MACRO_SEPARATOR, val)}
	tabLogic, tabMacro = {strsplit('.', oSplit[1])}, {strsplit('.', oSplit[2])}
	if not tabLogic and not tabMacro then return end
	local objReturn
	for i,v in pairs(tabLogic) do
		v = v and strtrim(v)
		local raw, code = v, self:GetFullCodeString(v)
		if code then
			if not objReturn then objReturn = {} end
			if not objReturn[i] then objReturn[i] = {} end
			objReturn[i].raw = raw
			objReturn[i].code = code
		end
	end   
	for i,v in pairs(tabLogic) do
		v = v and strtrim(v)
		local raw, code = v, self:GetFullCodeString(v, true)
		if code then
			if not objReturn then objReturn = {} end
			if not objReturn[i] then objReturn[i] = {} end
			objReturn[i].readable = code
		end
	end
	for i,macro in pairs(tabMacro) do
		macro = macro and strtrim(macro)
		if not objReturn then objReturn = {} end
		if not objReturn[i] then objReturn[i] = {} end
		objReturn[i].macro = macro
	end
	return objReturn
end

function kMacro:GetFullCodeString(val, properName)
	local iIterator = 1;
	local saved 
	while iIterator <= strlen(val) do
		local code, iEnd = self:IterateOverString(val, iIterator, properName)
		if code then 
			saved = saved and saved .. code or code
		end
		if iEnd and iIterator < iEnd then 
			iIterator = iEnd+1 
		else
			iIterator = iIterator + 1
		end
	end
	--self:Debug(saved and strtrim(saved) or saved, 1)
	return saved and strtrim(saved) or saved
end

function kMacro:GetLogicCountFromData(data)
	local count
	for i,v in pairs(data) do
		if v.raw then count = count and count + 1 or 1 end
	end
	return count
end

function kMacro:GetLogicValue(val, startIndex, endIndex)
	local types = {'s', 'd', 't', 'g', '+', '/', '(', ')'}
	local sub;
	for i,v in pairs(types) do
		local pattern = v
		local searchPlain = true
		local s,e
		local sub
		if v == 's' or v == 't' or v == 'g' then
			pattern = v..'%d+'
			searchPlain = false
		end
		sub = string.sub(val, startIndex, endIndex)
		s,e = string.find(sub, pattern, 1, searchPlain)
		local number 
		if s and e then
			number = tonumber(self:GetNumberLogicValue(val, startIndex, endIndex))
			return v, s, e, number
		end
	end
end

function kMacro:GetMacroBodyFinal(macro, insertions)
	local body = string.gsub(macro.body, '%$', '%%s')
	if insertions then
		return body:format(strsplit(INSERTIONS_GENERATION_SEPARATOR, insertions))
	else
		return body
	end
end

function kMacro:GetMacroCountByName(name, isGeneral)
	local lowIndex = isGeneral and 1 or 37
	local highIndex = isGeneral and 36 or (GENERAL_MACRO_COUNT + CHARACTER_MACRO_COUNT + 1) 
	local currentName, currentTexture, currentBody
	local matchCount = 0
	for iMacro=lowIndex,highIndex do
		currentName, currentTexture, currentBody = GetMacroInfo(iMacro)
		if name == currentName then 
			matchCount = matchCount + 1
		end
	end
	return matchCount;
end

function kMacro:GetMacroCountFromData(data)
	local count
	for i,v in pairs(data) do
		if v.macro then count = count and count + 1 or 1 end
	end
	return count
end

function kMacro:GetMacroInsertions(macro)
	local macroStrings
	if not macro.inserts then return end
	-- Loop inserts
	for index,v in pairs(macro.inserts) do
		-- Get first valid non-default insert
		local insertValue = self:Insert_GetValue(macro, index)
		-- Check if Insert is valid
		if self:Insert_Validate(insertValue) then
			local macroString = self:GetValidMacroString(self:GetDataTable(insertValue))
			if macroString then
				if not macroStrings then macroStrings = {} end
				macroStrings[index] = macroString
			end
		end
	end
	if macroStrings then
		local insert = ''
		for i,v in pairs(macroStrings) do
			insert = ('%s%s%s'):format(insert, INSERTIONS_GENERATION_SEPARATOR, v)
		end
		insert = string.sub(insert, 2)
		return insert, #macroStrings
	end
end

function kMacro:GetMacroMaxLength(macro)
	local total
	local insertCount
	-- Loop inserts
	for index,v in pairs(macro.inserts) do
		-- Get first valid non-default insert
		local insertValue = self:Insert_GetValue(macro, index)
		-- Check if Insert is valid
		local maxLength		
		if self:Insert_Validate(insertValue) then
			local data = self:GetDataTable(insertValue)
			-- Loop lengths
			for iData,vData in pairs(data) do
				if not maxLength then
					maxLength = vData.macro and strlen(vData.macro) or 0
				else
					if vData.macro and strlen(vData.macro) > maxLength then maxLength = strlen(vData.macro) end
				end	
			end
		end
		if maxLength then insertCount = insertCount and (insertCount + 1) or 1 end
		if maxLength then total = total and (total + maxLength) or maxLength end
	end	
	local subtractor = insertCount and (insertCount * strlen(INSERT_POINT_TEXT)) or 0
	return (strlen(macro.body) or 0) + (total or 0) - subtractor
end

function kMacro:GetNumberLogicValue(val, startIndex, endIndex)
	return string.match(string.sub(val, startIndex, endIndex+1), NUMBER_LOGIC_MATCH_PATTERN)
end

function  kMacro:GetTalentInfoFromNum(num)
   tier = math.floor((num-1)/3) + 1
   column = (num % 3) == 0 and 3 or num % 3
   groupIndex = 1
   return GetTalentInfo(tier, column, GetActiveSpecGroup())
end

function kMacro:GetUniqueMacroId()
	local newId
	local isValidId = false;
	while isValidId == false do
		local matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(self.db.profile.macros.list) do
			if val.id == newId then
				matchFound = true;
			end
		end
		if matchFound == false then
			isValidId = true;
		end
	end
	return newId;
end

function kMacro:GetValidMacroString(data)
	if not data then return end
	local default
	for i,v in pairs(data) do
		if v.raw and v.raw == 'd' and v.macro then 
			default = v.macro 
		else
			-- Check for non-default code
			local valid = self:ValidateCode(v.code)
			if valid and type(valid) ~= 'string' and v.macro then return v.macro end		
		end
	end
	return default
end

function kMacro:IsGlyphActive(spellId)
	local numGlyphs = GetNumGlyphSockets()
	for i=0,numGlyphs do
		local enabled, glyphType, glyphTooltipIndex, glyphSpellID, icon = GetGlyphSocketInfo(i)
		if enabled and glyphSpellID == spellId then return true end
	end
	return false
end

function kMacro:IsMacroValid(macro)
	if not macro.body or macro.body == '' then return false, 'No macro body text.' end
	-- check insertion point count
	local insertions, count = self:GetMacroInsertions(macro)
	-- Check if insert points exceed valid insertions
	local success, msg
	if insertions then
		success, msg = pcall(function() self:GetMacroBodyFinal(macro, insertions) end)
	else
		msg = macro.body:format('INSERTION_POINT_ERROR', '', '', '', '', '', '', '', '', '', '', '')
	end
	if (msg and string.find(msg, "to 'format'", 1, true)) or (msg and string.find(msg, 'INSERTION_POINT_ERROR', 1, true)) then
		return false, 'Contains too many insertion points (%s).'
	end
	if not macro.inserts then return false, 'No inserts found.' end
	-- validate insertions
	for i,v in pairs(macro.inserts) do
		local valid, message = self:Insert_Validate(v.value)
		if not valid then
			return false, ('Invalid insertion [#%s].'):format(i)
		end
	end
	-- Validate length
	local length = self:GetMacroMaxLength(macro)
	if length and length > 255 then return false, ('Max length [%s] exceeds 255 character limit.'):format(length) end
	return true, 'Valid Macro'
end
--[[
function kMacro:IterateOverString(val, s, properName)
	for i=strlen(val),s,-1 do
		local code, iEnd = self:GetCodeString(val, s, i, properName)
		if code and iEnd then return code, iEnd end
	end
end
]]

function kMacro:IterateOverString(val, s, properName)
	for i=s,strlen(val) do
		local code, iEnd = self:GetCodeString(val, s, i, properName)
		if code and iEnd then return code, iEnd end
	end
end

function kMacro:SaveMacro(id)
	-- Check not in combat
	if InCombatLockdown() then return end
	for i,v in pairs(self.db.profile.macros.list) do
		-- find match
		if v.id == id then
			self:Debug(v.id)
			-- Verify activation
			if self:IsMacroValid(v) then
        self:Debug('Macro is valid')
				-- Check that macro matches in system
				local lowIndex = v.isGeneral and 1 or (GENERAL_MACRO_COUNT + 1);
				local highIndex = v.isGeneral and GENERAL_MACRO_COUNT or (GENERAL_MACRO_COUNT + CHARACTER_MACRO_COUNT + 1);
				local currentName, currentTexture, currentBody;
				local matchIndex = false;
				-- Check if macro exists with name in appropriate location
				for iMacro=lowIndex,highIndex do
					currentName, currentTexture, currentBody = GetMacroInfo(iMacro)
					if v.name == currentName then 
						matchIndex = iMacro
						self:Debug(matchIndex)											
						break
					end
				end
				if matchIndex then 
					local insertions, count = self:GetMacroInsertions(v)
					if insertions then
						EditMacro(matchIndex, nil, nil, self:GetMacroBodyFinal(v, insertions))
						return true;
					else
						EditMacro(matchIndex, nil, nil, self:GetMacroBodyFinal(v))
						return true;
					end
				end
			end
		end
	end
end

function kMacro:UpdateAllMacros()
	for iMacro,vMacro in pairs(self.db.profile.macros.list) do
		-- Check if identical name exists in same category (general or char) by checking name and diffIndex
		local matchCount = self:GetMacroCountByName(vMacro.name, vMacro.isGeneral);
		if matchCount > 1 then
			self:Print('Cannot have 2 or more standard macros with the same name in the same category.')
		elseif not matchCount then
			self:Print(("Standard macro doesn't exist to match the auto-macro with the name: %s."):format(vMacro.name))
		elseif matchCount == 1 then
			-- Good, continue
			if self:IsMacroValid(vMacro) then
				-- Enable macro
				self:EnableMacro(vMacro);
			end
		end
	end
	-- Force GUI refresh
	LibStub("AceConfigRegistry-3.0"):NotifyChange("kMacro")	
end

function kMacro:ValidateCode(code)
	local loadedFunction, errorString = loadstring('return '..tostring(code))
	if errorString then
		return errorString
	else
		local func = assert(loadedFunction)()
		return func
	end	
end

function kMacro:VerifyMacroActivation(code)
	local loadedFunction, errorString = loadstring('return '..tostring(code))
	if errorString then
		return errorString
	else
		local func = assert(loadedFunction)()	
		return func;
	end
end