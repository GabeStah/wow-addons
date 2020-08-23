-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
kPester.frameList = {};
kPester.nameList = {};
function kPester:Threading_CreateTimer(name,func,delay,rep,arg)
	kPester.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetScript("OnUpdate", function(self, elapsed) kPester:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kPester:Threading_IsTimerActive(name)
	for i,j in ipairs(kPester.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kPester:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kPester.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == strtrim(name) then
			timerPool = kPester.threading.timerPool[name]
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
					kPester:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kPester:Threading_StartTimer(name,delay)
	if kPester.threading.timerPool[name] then
		kPester.threading.timerPool[name].elapsed = delay or kPester.threading.timerPool[name].delay
		if not kPester:Threading_IsTimerActive(name) then
			tinsert(kPester.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kPester:Threading_StopTimer(name)
	local i = kPester:Threading_IsTimerActive(name)
	if i then
		tremove(kPester.threading.timers,i)
		if #(kPester.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end