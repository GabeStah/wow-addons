-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kTraitor:Threading_CreateTimer(name,func,delay,rep,arg)
	kTraitor.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kTraitor:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kTraitor:Threading_IsTimerActive(name)
	for i,j in ipairs(kTraitor.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kTraitor:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kTraitor.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kTraitor.threading.timerPool[name]
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
					kTraitor:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kTraitor:Threading_StartTimer(name,delay)
	if kTraitor.threading.timerPool[name] then
		kTraitor.threading.timerPool[name].elapsed = delay or kTraitor.threading.timerPool[name].delay
		if not kTraitor:Threading_IsTimerActive(name) then
			tinsert(kTraitor.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kTraitor:Threading_StopTimer(name)
	local i = kTraitor:Threading_IsTimerActive(name)
	if i then
		tremove(kTraitor.threading.timers,i)
		if #(kTraitor.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end
function kTraitor:Threading_UpdateThreadingFrame(name)
	local frame = getglobal(name);
	if not frame then -- Create
		if string.find(name, "kTraitorThreadingFrameMain") then
			kTraitor:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kTraitor.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kTraitorThreadingFrameBids") then
			kTraitor:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kTraitor.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end