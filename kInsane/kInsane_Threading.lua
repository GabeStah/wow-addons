-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kInsane:Threading_CreateTimer(name,func,delay,rep,arg)
	kInsane.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kInsane:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kInsane:Threading_IsTimerActive(name)
	for i,j in ipairs(kInsane.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kInsane:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kInsane.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kInsane.threading.timerPool[name]
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
					kInsane:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kInsane:Threading_StartTimer(name,delay)
	if kInsane.threading.timerPool[name] then
		kInsane.threading.timerPool[name].elapsed = delay or kInsane.threading.timerPool[name].delay
		if not kInsane:Threading_IsTimerActive(name) then
			tinsert(kInsane.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kInsane:Threading_StopTimer(name)
	local i = kInsane:Threading_IsTimerActive(name)
	if i then
		tremove(kInsane.threading.timers,i)
		if #(kInsane.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end
function kInsane:Threading_UpdateThreadingFrame(name)
	local frame = getglobal(name);
	if not frame then -- Create
		if string.find(name, "kInsaneThreadingFrameMain") then
			kInsane:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kInsane.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kInsaneThreadingFrameBids") then
			kInsane:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kInsane.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end