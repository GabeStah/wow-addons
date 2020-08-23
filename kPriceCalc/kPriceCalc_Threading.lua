-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kPriceCalc:Threading_CreateTimer(name,func,delay,rep,arg)
	kPriceCalc.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kPriceCalc:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kPriceCalc:Threading_IsTimerActive(name)
	for i,j in ipairs(kPriceCalc.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kPriceCalc:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kPriceCalc.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kPriceCalc.threading.timerPool[name]
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
					kPriceCalc:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kPriceCalc:Threading_StartTimer(name,delay)
	if kPriceCalc.threading.timerPool[name] then
		kPriceCalc.threading.timerPool[name].elapsed = delay or kPriceCalc.threading.timerPool[name].delay
		if not kPriceCalc:Threading_IsTimerActive(name) then
			tinsert(kPriceCalc.threading.timers, name);
			getglobal(name):Show();
		end
	end
end
function kPriceCalc:Threading_StopTimer(name)
	local i = kPriceCalc:Threading_IsTimerActive(name)
	if i then
		tremove(kPriceCalc.threading.timers,i)
		if #(kPriceCalc.threading.timers) < 1 then
			getglobal(name):Hide();
		end
	end
end
function kPriceCalc:Threading_UpdateThreadingFrame(name)
	local frame = getglobal(name);
	if not frame then -- Create
		if string.find(name, "kPriceCalcThreadingFrameMain") then
			kPriceCalc:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kPriceCalc.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kPriceCalcThreadingFrameBids") then
			kPriceCalc:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kPriceCalc.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end