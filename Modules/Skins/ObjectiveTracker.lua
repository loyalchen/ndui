local B, C, L, DB = unpack(select(2, ...))
local r, g, b = DB.cc.r, DB.cc.g, DB.cc.b

-- Move quest tracker
local parent = CreateFrame("Frame", nil, Minimap)
local Mover = CreateFrame("Button", "NDuiQuestMover", parent)
Mover:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", -30, -25)
Mover:SetSize(20, 20)
Mover.Icon = Mover:CreateTexture(nil, "ARTWORK")
Mover.Icon:SetAllPoints()
Mover.Icon:SetTexture("Interface\\WorldMap\\Gear_64")
Mover.Icon:SetTexCoord(0, .5, 0, .5)
Mover:SetHighlightTexture("Interface\\WorldMap\\Gear_64")
Mover:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)
B.CreateGT(Mover, TOGGLE, true)
B.CreateMF(Mover)

local otf = ObjectiveTrackerFrame
hooksecurefunc(otf, "SetPoint", function(_, _, parent)
	if parent ~= Mover then
		otf:ClearAllPoints()
		otf:SetPoint("TOPRIGHT", Mover, "TOPLEFT", -5, 0)
		otf:SetHeight(GetScreenHeight() - 400)
	end
end)

hooksecurefunc("ObjectiveTracker_CheckAndHideHeader", function()
	if otf.HeaderMenu:IsShown() then
		Mover:Show()
	else
		Mover:Hide()
	end
end)

-- Autocollapse the watchframe when in Dungeons
local f = CreateFrame("Frame")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if IsInInstance() and not ScenarioBlocksFrame:IsVisible() then
		ObjectiveTracker_Collapse()
	else
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

-- Reskin elements
hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	local itemButton = block.itemButton
	if itemButton and not itemButton.styled then
		itemButton:SetNormalTexture("")
		itemButton:SetPushedTexture("")
		itemButton:SetHighlightTexture("")
		itemButton.icon:SetTexCoord(unpack(DB.TexCoord))
		itemButton.HL = itemButton:CreateTexture(nil, "HIGHLIGHT")
		itemButton.HL:SetColorTexture(1, 1, 1, .3)
		itemButton.HL:SetAllPoints(itemButton.icon)
		B.CreateSD(itemButton, 3, 3)
		itemButton.styled = true
	end
end)

local function reskinHeader(header)
	header.Text:SetTextColor(r, g, b)
	header.Background:Hide()
	local bg = header:CreateTexture(nil, "ARTWORK")
	bg:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
	bg:SetTexCoord(0, .66, 0, .31)
	bg:SetVertexColor(r, g, b, .8)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(250, 30)
end

local headers = {
	ObjectiveTrackerBlocksFrame.QuestHeader,
	ObjectiveTrackerBlocksFrame.AchievementHeader,
	ObjectiveTrackerBlocksFrame.ScenarioHeader,
	BONUS_OBJECTIVE_TRACKER_MODULE.Header,
	WORLD_QUEST_TRACKER_MODULE.Header,
}
for _, head in pairs(headers) do
	reskinHeader(head)
end

if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	local minimize = otf.HeaderMenu.MinimizeButton
	F.ReskinExpandOrCollapse(minimize)
	minimize:SetSize(16, 16)
	minimize.plus:Hide()
	hooksecurefunc("ObjectiveTracker_Collapse", function()
		minimize.plus:Show()
	end)
	hooksecurefunc("ObjectiveTracker_Expand", function()
		minimize.plus:Hide()
	end)
end

-- WorldQuestTracker Reskin
local event = CreateFrame("Frame")
event:RegisterEvent("ADDON_LOADED")
event:SetScript("OnEvent", function(self, event, addon)
	if addon == "WorldQuestTracker" then
		self:UnregisterAllEvents()
		reskinHeader(WorldQuestTrackerQuestsHeader)

		if IsAddOnLoaded("Aurora") then
			local F = unpack(Aurora)
			local minimize = WorldQuestTrackerQuestsHeaderMinimizeButton
			F.ReskinExpandOrCollapse(minimize)
			minimize:SetSize(16, 16)
			minimize.plus:Hide()
			minimize:SetScript("OnMouseUp", function()
				if WorldQuestTrackerScreenPanel.collapsed then
					minimize.plus:Hide()
				else
					minimize.plus:Show()
				end
			end)
		end
	end
end)