local B, C, L, DB = unpack(select(2, ...))
--------------------------
-- QuickQuest, by P3lim
-- NDui MOD
--------------------------
local mono = CreateFrame("CheckButton", nil, WorldMapTitleButton, "OptionsCheckButtonTemplate")
mono:SetPoint("TOPRIGHT", WorldMapTitleButton, -100, -2)
mono:SetSize(26, 26)
B.CreateCB(mono)
mono.text = B.CreateFS(mono, 14, AUTO_COMPLETE, false, "LEFT", 25, 0)
mono:RegisterEvent("PLAYER_LOGIN")
mono:SetScript("OnEvent", function(self)
	self:SetChecked(NDuiDB["Misc"].AutoQuest)
end)
mono:SetScript("OnClick", function(self)
	NDuiDB["Misc"].AutoQuest = self:GetChecked()
end)

-- Function
local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

local atBank, atMail, atMerchant, choiceQueue, autoCompleteIndex, autoCompleteTicker

function QuickQuest:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		if NDuiDB["Misc"].AutoQuest then
			if(not IsShiftKeyDown()) then
				func(...)
			end
		else
			if(IsShiftKeyDown()) then
				func(...)
			end
		end
	end
end

local function GetNPCID()
	return tonumber(string.match(UnitGUID("npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

local function IsTrackingTrivial()
	for index = 1, GetNumTrackingTypes() do
		local name, _, active = GetTrackingInfo(index)
		if(name == MINIMAP_TRACKING_TRIVIAL_QUESTS) then
			return active
		end
	end
end

local ignoreQuestNPC = {
	[88570] = true, -- Fate-Twister Tiklal
	[87391] = true, -- Fate-Twister Seress
	[111243] = true, -- Archmage Lan'dalock
	[108868] = true, -- Hunter's order hall
}

QuickQuest:Register("QUEST_GREETING", function()
	local npcID = GetNPCID()
	if(ignoreQuestNPC[npcID]) then
		return
	end

	local active = GetNumActiveQuests()
	if(active > 0) then
		for index = 1, active do
			local _, complete = GetActiveTitle(index)
			if(complete) then
				SelectActiveQuest(index)
			end
		end
	end

	local available = GetNumAvailableQuests()
	if(available > 0) then
		for index = 1, available do
			if(not IsAvailableQuestTrivial(index) or IsTrackingTrivial()) then
				SelectAvailableQuest(index)
			end
		end
	end
end)

-- This should be part of the API, really
local function IsGossipQuestCompleted(index)
	return not not select(((index * 5) - 5) + 4, GetGossipActiveQuests())
end

local function IsGossipQuestTrivial(index)
	return not not select(((index * 6) - 6) + 3, GetGossipAvailableQuests())
end

local ignoreGossipNPC = {
	-- Bodyguards
	[86945] = true, -- Aeda Brightdawn (Horde)
	[86933] = true, -- Vivianne (Horde)
	[86927] = true, -- Delvar Ironfist (Alliance)
	[86934] = true, -- Defender Illona (Alliance)
	[86682] = true, -- Tormmok
	[86964] = true, -- Leorajh
	[86946] = true, -- Talonpriest Ishaal

	-- Sassy Imps
	[95139] = true,
	[95141] = true,
	[95142] = true,
	[95143] = true,
	[95144] = true,
	[95145] = true,
	[95146] = true,
	[95200] = true,
	[95201] = true,

	-- Misc NPCs
	[79740] = true, -- Warmaster Zog (Horde)
	[79953] = true, -- Lieutenant Thorn (Alliance)
	[84268] = true, -- Lieutenant Thorn (Alliance)
	[84511] = true, -- Lieutenant Thorn (Alliance)
	[84684] = true, -- Lieutenant Thorn (Alliance)
}

QuickQuest:Register("GOSSIP_SHOW", function()
	local npcID = GetNPCID()
	if(ignoreQuestNPC[npcID]) then
		return
	end

	local active = GetNumGossipActiveQuests()
	if(active > 0) then
		for index = 1, active do
			if(IsGossipQuestCompleted(index)) then
				SelectGossipActiveQuest(index)
			end
		end
	end

	local available = GetNumGossipAvailableQuests()
	if(available > 0) then
		for index = 1, available do
			if(not IsGossipQuestTrivial(index) or IsTrackingTrivial()) then
				SelectGossipAvailableQuest(index)
			end
		end
	end

	if(available == 0 and active == 0 and GetNumGossipOptions() == 1) then
		local npcID = GetNPCID()
		if(npcID == 57850) then
			return SelectGossipOption(1)
		end

		local _, instance = GetInstanceInfo()
		if(instance ~= "raid" and not ignoreGossipNPC[npcID]) then
			local _, type = GetGossipOptions()
			if(type == "gossip") then
				SelectGossipOption(1)
				return
			end
		end
	end
end)

local darkmoonNPC = {
	[57850] = true, -- Teleportologist Fozlebub
	[55382] = true, -- Darkmoon Faire Mystic Mage (Horde)
	[54334] = true, -- Darkmoon Faire Mystic Mage (Alliance)
}

QuickQuest:Register("GOSSIP_CONFIRM", function(index)
	local npcID = GetNPCID()
	if(npcID and darkmoonNPC[npcID]) then
		SelectGossipOption(index, "", true)
		StaticPopup_Hide("GOSSIP_CONFIRM")
	end
end)

QuickQuest:Register("QUEST_DETAIL", function()
	if(not QuestGetAutoAccept()) then
		AcceptQuest()
	end
end)

QuickQuest:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

QuickQuest:Register("QUEST_ACCEPTED", function(id)
	if(QuestFrame:IsShown() and QuestGetAutoAccept()) then
		CloseQuest()
	end
end)

QuickQuest:Register("QUEST_ITEM_UPDATE", function()
	if(choiceQueue and QuickQuest[choiceQueue]) then
		QuickQuest[choiceQueue]()
	end
end)

local itemBlacklist = {
	-- Inscription weapons
	[31690] = 79343, -- Inscribed Tiger Staff
	[31691] = 79340, -- Inscribed Crane Staff
	[31692] = 79341, -- Inscribed Serpent Staff

	-- Darkmoon Faire artifacts
	[29443] = 71635, -- Imbued Crystal
	[29444] = 71636, -- Monstrous Egg
	[29445] = 71637, -- Mysterious Grimoire
	[29446] = 71638, -- Ornate Weapon
	[29451] = 71715, -- A Treatise on Strategy
	[29456] = 71951, -- Banner of the Fallen
	[29457] = 71952, -- Captured Insignia
	[29458] = 71953, -- Fallen Adventurer's Journal
	[29464] = 71716, -- Soothsayer's Runes

	-- Tiller Gifts
	["progress_79264"] = 79264, -- Ruby Shard
	["progress_79265"] = 79265, -- Blue Feather
	["progress_79266"] = 79266, -- Jade Cat
	["progress_79267"] = 79267, -- Lovely Apple
	["progress_79268"] = 79268, -- Marsh Lily

	-- Garrison scouting missives
	["38180"] = 122424, -- Scouting Missive: Broken Precipice
	["38193"] = 122423, -- Scouting Missive: Broken Precipice
	["38182"] = 122418, -- Scouting Missive: Darktide Roost
	["38196"] = 122417, -- Scouting Missive: Darktide Roost
	["38179"] = 122400, -- Scouting Missive: Everbloom Wilds
	["38192"] = 122404, -- Scouting Missive: Everbloom Wilds
	["38194"] = 122420, -- Scouting Missive: Gorian Proving Grounds
	["38202"] = 122419, -- Scouting Missive: Gorian Proving Grounds
	["38178"] = 122402, -- Scouting Missive: Iron Siegeworks
	["38191"] = 122406, -- Scouting Missive: Iron Siegeworks
	["38184"] = 122413, -- Scouting Missive: Lost Veil Anzu
	["38198"] = 122414, -- Scouting Missive: Lost Veil Anzu
	["38177"] = 122403, -- Scouting Missive: Magnarok
	["38190"] = 122399, -- Scouting Missive: Magnarok
	["38181"] = 122421, -- Scouting Missive: Mok'gol Watchpost
	["38195"] = 122422, -- Scouting Missive: Mok'gol Watchpost
	["38185"] = 122411, -- Scouting Missive: Pillars of Fate
	["38199"] = 122409, -- Scouting Missive: Pillars of Fate
	["38187"] = 122412, -- Scouting Missive: Shattrath Harbor
	["38201"] = 122410, -- Scouting Missive: Shattrath Harbor
	["38186"] = 122408, -- Scouting Missive: Skettis
	["38200"] = 122407, -- Scouting Missive: Skettis
	["38183"] = 122416, -- Scouting Missive: Socrethar's Rise
	["38197"] = 122415, -- Scouting Missive: Socrethar's Rise
	["38176"] = 122405, -- Scouting Missive: Stonefury Cliffs
	["38189"] = 122401, -- Scouting Missive: Stonefury Cliffs

	-- Misc
	[31664] = 88604, -- Nat's Fishing Journal
}

QuickQuest:Register("QUEST_PROGRESS", function()
	if(IsQuestCompletable()) then
		local requiredItems = GetNumQuestItems()
		if(requiredItems > 0) then
			for index = 1, requiredItems do
				local link = GetQuestItemLink("required", index)
				if(link) then
					local id = tonumber(string.match(link, "item:(%d+)"))
					for _, itemID in next, itemBlacklist do
						if(itemID == id) then
							return
						end
					end
				else
					choiceQueue = "QUEST_PROGRESS"
					return
				end
			end
		end

		CompleteQuest()
	end
end)

QuickQuest:Register("QUEST_COMPLETE", function()
	local choices = GetNumQuestChoices()
	if(choices <= 1) then
		GetQuestReward(1)
	end
end)

local cashRewards = {
	[45724] = 1e5, -- Champion's Purse
	[64491] = 2e6, -- Royal Reward
}

QuickQuest:Register("QUEST_COMPLETE", function()
	local choices = GetNumQuestChoices()
	if(choices <= 1) then
		GetQuestReward(1)
	elseif(choices > 1) then
		local bestValue, bestIndex = 0

		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if(link) then
				local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
				value = cashRewards[tonumber(string.match(link, "item:(%d+):"))] or value

				if(value > bestValue) then
					bestValue, bestIndex = value, index
				end
			else
				choiceQueue = "QUEST_COMPLETE"
				return GetQuestItemInfo("choice", index)
			end
		end

		if(bestIndex) then
			QuestInfoItem_OnClick(QuestInfoRewardsFrame.RewardButtons[bestIndex])
		end
	end
end)

QuickQuest:Register("QUEST_FINISHED", function()
	choiceQueue = nil
	autoCompleteIndex = nil

	if(autoCompleteTicker) then
		autoCompleteTicker:Cancel()
		autoCompleteTicker = nil
	end

	if(GetNumAutoQuestPopUps() > 0) then
		QuickQuest:QUEST_AUTOCOMPLETE()
	end
end)

local function CompleteAutoComplete(self)
	if(not autoCompleteIndex and GetNumAutoQuestPopUps() > 0) then
		local id, type = GetAutoQuestPopUp(1)
		if(type == "COMPLETE") then
			local index = GetQuestLogIndexByID(id)
			ShowQuestComplete(index)
			autoCompleteIndex = index
		end

		self:Cancel()
	end
end

QuickQuest:Register("QUEST_AUTOCOMPLETE", function(questID)
	autoCompleteTicker = C_Timer.NewTicker(1/4, CompleteAutoComplete, 20)
end)

QuickQuest:Register("BAG_UPDATE_DELAYED", function()
	if(autoCompleteIndex) then
		ShowQuestComplete(autoCompleteIndex)
		autoCompleteIndex = nil
	end
end)

QuickQuest:Register("BANKFRAME_OPENED", function()
	atBank = true
end)

QuickQuest:Register("BANKFRAME_CLOSED", function()
	atBank = false
end)

QuickQuest:Register("GUILDBANKFRAME_OPENED", function()
	atBank = true
end)

QuickQuest:Register("GUILDBANKFRAME_CLOSED", function()
	atBank = false
end)

QuickQuest:Register("MAIL_SHOW", function()
	atMail = true
end)

QuickQuest:Register("MAIL_CLOSED", function()
	atMail = false
end)

QuickQuest:Register("MERCHANT_SHOW", function()
	atMerchant = true
end)

QuickQuest:Register("MERCHANT_CLOSED", function()
	atMerchant = false
end)

local questTip = CreateFrame("GameTooltip", "QuickQuestTip", UIParent, "GameTooltipTemplate")
local questString = string.gsub(ITEM_MIN_LEVEL, "%%d", "(%%d+)")

local function GetContainerItemQuestLevel(bag, slot)
	questTip:SetOwner(UIParent, "ANCHOR_NONE")
	questTip:SetBagItem(bag, slot)

	for index = 1, questTip:NumLines() do
		local level = tonumber(string.match(_G["QuickQuestTipTextLeft" .. index]:GetText(), questString))
		if(level) then
			return level
		end
	end
	return 1
end

local function BagUpdate(bag)
	if(atBank or atMail or atMerchant) then return end

	for slot = 1, GetContainerNumSlots(bag) do
		local _, id, active = GetContainerItemQuestInfo(bag, slot)
		if(id and not active and not IsQuestFlaggedCompleted(id) and not itemBlacklist[id]) then
			local level = GetContainerItemQuestLevel(bag, slot)
			if(level <= UnitLevel("player")) then
				UseContainerItem(bag, slot)
			end
		end
	end
end

QuickQuest:Register("PLAYER_LOGIN", function()
	QuickQuest:Register("BAG_UPDATE", BagUpdate)

	if(GetNumAutoQuestPopUps() > 0) then
		QuickQuest:QUEST_AUTOCOMPLETE()
	end
end)