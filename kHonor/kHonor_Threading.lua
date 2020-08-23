-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kHonor:Threading_CreateTimer(name,func,delay,rep,arg)
	kHonor.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kHonor:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kHonor:Threading_IsTimerActive(name)
	for i,j in ipairs(kHonor.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kHonor:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kHonor.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kHonor.threading.timerPool[name]
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
					kHonor:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kHonor:Threading_StartTimer(name,delay)
	if kHonor.threading.timerPool[name] then
		kHonor.threading.timerPool[name].elapsed = delay or kHonor.threading.timerPool[name].delay
		if not kHonor:Threading_IsTimerActive(name) then
			tinsert(kHonor.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kHonor:Threading_StopTimer(name)
	local i = kHonor:Threading_IsTimerActive(name)
	if i then
		tremove(kHonor.threading.timers,i)
		if #(kHonor.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end
function kHonor:Threading_UpdateThreadingFrame(name)
	local frame = getglobal(name);
	if not frame then -- Create
		if string.find(name, "kHonorThreadingFrameMain") then
			kHonor:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kHonor.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kHonorThreadingFrameBids") then
			kHonor:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kHonor.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end