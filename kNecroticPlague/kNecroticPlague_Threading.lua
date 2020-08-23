-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kNecroticPlague:Threading_CreateTimer(name,func,delay,rep,arg)
	kNecroticPlague.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kNecroticPlague:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kNecroticPlague:Threading_IsTimerActive(name)
	for i,j in ipairs(kNecroticPlague.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kNecroticPlague:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kNecroticPlague.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kNecroticPlague.threading.timerPool[name]
			timerPool.elapsed = timerPool.elapsed - elapsed
			if timerPool.elapsed < 0 then
				if timerPool.arg then
					timerPool.func(timerPool.arg)
				else
					timerPool.func()
				end
				if timerPool.rep then
					timerPool.elapsed = timerPool.delay
				else
					kNecroticPlague:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kNecroticPlague:Threading_StartTimer(name,delay)
	if kNecroticPlague.threading.timerPool[name] then
		kNecroticPlague.threading.timerPool[name].elapsed = delay or kNecroticPlague.threading.timerPool[name].delay
		if not kNecroticPlague:Threading_IsTimerActive(name) then
			tinsert(kNecroticPlague.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kNecroticPlague:Threading_StopTimer(name)
	local i = kNecroticPlague:Threading_IsTimerActive(name)
	if i then
		tremove(kNecroticPlague.threading.timers,i)
		if #(kNecroticPlague.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end
function kNecroticPlague:Threading_UpdateThreadingFrame(name)
	local frame = getglobal(name);
	if not frame then -- Create
		if string.find(name, "kNecroticPlagueThreadingFrameMain") then
			kNecroticPlague:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kNecroticPlague.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kNecroticPlagueThreadingFrameBids") then
			kNecroticPlague:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kNecroticPlague.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end