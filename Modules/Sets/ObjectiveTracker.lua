local B, C, L, DB = unpack(select(2, ...))

-- Move quest tracker
local wf = ObjectiveTrackerFrame
wf:SetClampedToScreen(true)
wf:SetMovable(true)
wf:SetUserPlaced(true)
wf:ClearAllPoints()
wf.ClearAllPoints = function() end
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -100, -250)
wf.SetPoint = function() end
wf:SetHeight(450)
local function Moveit(f)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetHitRectInsets(-15, -15, -5, -5)
	f:HookScript("OnDragStart", function(s)
		wf:StartMoving()
	end)
	f:HookScript("OnDragStop", function(s)
		wf:StopMovingOrSizing()
	end)
	B.CreateGT(f, TOGGLE, true)
end
Moveit(ObjectiveTrackerBlocksFrame.QuestHeader)
Moveit(ObjectiveTrackerBlocksFrame.ScenarioHeader)
Moveit(ObjectiveTrackerBlocksFrame.AchievementHeader)

-- Autocollapse the watchframe when in Dungeons
local wfclps = CreateFrame("Frame")
wfclps:RegisterEvent("ZONE_CHANGED_NEW_AREA")
wfclps:RegisterEvent("PLAYER_ENTERING_WORLD")
wfclps:SetScript("OnEvent", function()
	if IsInInstance() and not ScenarioBlocksFrame:IsVisible() then
		ObjectiveTrackerFrame.collapsed = true
		ObjectiveTracker_Collapse()
	else
		ObjectiveTrackerFrame.collapsed = nil
		ObjectiveTracker_Expand()
	end
end)

-- Questblock click enhant
hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderClick", function(block)
	local questLogIndex = block.questLogIndex
	if IsControlKeyDown() then
		local items = GetAbandonQuestItems()
		if items then
			StaticPopup_Hide("ABANDON_QUEST")
			StaticPopup_Show("ABANDON_QUEST_WITH_ITEMS", GetAbandonQuestName(), items)
		else
			StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")
			StaticPopup_Show("ABANDON_QUEST", GetAbandonQuestName())
		end
	elseif IsAltKeyDown() and GetQuestLogPushable(questLogIndex) then
		QuestLogPushQuest(questLogIndex)
	end
end)

hooksecurefunc("QuestMapLogTitleButton_OnClick", function(self)
	local questLogIndex = GetQuestLogIndexByID(self.questID)
	if IsControlKeyDown() then
		QuestMapQuestOptions_AbandonQuest(self.questID)
	elseif IsAltKeyDown() and GetQuestLogPushable(questLogIndex) then
		QuestMapQuestOptions_ShareQuest(self.questID)
	end
end)

-- Show quest color and level
local function Showlevel()
	if ENABLE_COLORBLIND_MODE == "1" then return end
	local numEntries = GetNumQuestLogEntries()
	local titleIndex = 1
	for i = 1, numEntries do
		local title, level, _, isHeader, _, isComplete, frequency, questID = GetQuestLogTitle(i)
		local titleButton = QuestLogQuests_GetTitleButton(titleIndex)
		if title and (not isHeader) and titleButton.questID == questID then
			titleButton.Check:SetPoint("LEFT", titleButton.Text, titleButton.Text:GetWrappedWidth() + 2, 0)
			titleIndex = titleIndex + 1
			local text = "["..level.."] "..title
			if isComplete then
				text = "|cffff78ff"..text
			elseif frequency == LE_QUEST_FREQUENCY_DAILY then
				text = "|cff3399ff"..text
			end
			titleButton.Text:SetText(text)
		end
	end
end
hooksecurefunc("QuestLogQuests_Update", Showlevel)

-- Reskin the collapse button
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	local minimize = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	F.ReskinExpandOrCollapse(minimize)
	minimize:SetSize(18, 18)
	minimize.plus:Hide()
	hooksecurefunc("ObjectiveTracker_Collapse", function()
		minimize.plus:Show()
	end)
	hooksecurefunc("ObjectiveTracker_Expand", function()
		minimize.plus:Hide()
	end)
end