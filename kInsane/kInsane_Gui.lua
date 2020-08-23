-- Author      : Gabe
-- Create Date : 10/12/2009 4:18:07 PM
function kInsane:Gui_InitializeFrames()
	-- Create initial frames
	
end
function kInsane:Gui_RefreshFrame(frame)
	if getglobal(kInsane.db.profile.gui.frames.main.name) == frame then
		frame:SetHeight(kInsane.db.profile.gui.frames.main.height);
		frame:SetWidth(kInsane.db.profile.gui.frames.main.width);
	end
end
function kInsane:Gui_HookFrameRefreshUpdate()
	-- Hook to update frames
end