-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kAlert:Threading_CreateTimer(name,func,delay,rep,arg)
	kAlert.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kAlert:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kAlert:Threading_IsTimerActive(name)
	for i,j in ipairs(kAlert.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kAlert:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kAlert.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kAlert.threading.timerPool[name]
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
					kAlert:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kAlert:Threading_StartTimer(name,delay)
	if kAlert.threading.timerPool[name] then
		kAlert.threading.timerPool[name].elapsed = delay or kAlert.threading.timerPool[name].delay
		if not kAlert:Threading_IsTimerActive(name) then
			tinsert(kAlert.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kAlert:Threading_StopTimer(name)
	local i = kAlert:Threading_IsTimerActive(name)
	if i then
		tremove(kAlert.threading.timers,i)
		if #(kAlert.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end
function kAlert:Threading_UpdateThreadingFrame(name)
	local frame = getglobal(name);
	if not frame then -- Create
		if string.find(name, "kAlertThreadingFrameMain") then
			kAlert:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kAlert.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kAlertThreadingFrameBids") then
			kAlert:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kAlert.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end