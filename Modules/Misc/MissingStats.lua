local B, C, L, DB = unpack(select(2, ...))

--[[
	给角色属性面板添加额外的数据，同时使其支持滚动，防止数据溢出。
]]
local statPanel = CreateFrame("Frame", nil, CharacterFrameInsetRight)
statPanel:SetSize(200, 350)
statPanel:SetPoint("TOP", 0, -5)
local scrollFrame = CreateFrame("ScrollFrame", nil, statPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetAllPoints()
scrollFrame.ScrollBar:Hide()
scrollFrame.ScrollBar.Show = B.Dummy
local stat = CreateFrame("Frame", nil, scrollFrame)
stat:SetSize(200, 1)
scrollFrame:SetScrollChild(stat)
CharacterStatsPane:ClearAllPoints()
CharacterStatsPane:SetParent(stat)
CharacterStatsPane:SetAllPoints(stat)
hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", function()
	if (not _G[PAPERDOLL_SIDEBARS[1].frame]:IsShown()) then
		statPanel:Hide()
	else
		statPanel:Show()
	end	
end)

-- Change default data
PAPERDOLL_STATCATEGORIES = {
	[1] = {
		categoryFrame = "AttributesCategory",
		stats = {
			[1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
			[2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
			[3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
			[4] = { stat = "STAMINA" },
			[5] = { stat = "ARMOR" },
			[6] = { stat = "ATTACK_DAMAGE", primary = LE_UNIT_STAT_STRENGTH, roles =  { "TANK", "DAMAGER" } },
			[7] = { stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH, roles =  { "TANK", "DAMAGER" } },
			[8] = { stat = "ATTACK_ATTACKSPEED", primary = LE_UNIT_STAT_STRENGTH, roles =  { "TANK", "DAMAGER" } },
			[9] = { stat = "ATTACK_DAMAGE", primary = LE_UNIT_STAT_AGILITY, roles =  { "TANK", "DAMAGER" } },
			[10] = { stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_AGILITY, roles =  { "TANK", "DAMAGER" } },
			[11] = { stat = "ATTACK_ATTACKSPEED", primary = LE_UNIT_STAT_AGILITY, roles =  { "TANK", "DAMAGER" } },
			[12] = { stat = "SPELLPOWER", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT },
			[13] = { stat = "MANAREGEN", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT },
			[14] = { stat = "ENERGY_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
			[15] = { stat = "RUNE_REGEN", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH },
			[16] = { stat = "FOCUS_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
		},
	},
	[2] = {
		categoryFrame = "EnhancementsCategory",
		stats = {
			[1] = { stat = "CRITCHANCE", hideAt = 0 },
			[2] = { stat = "HASTE", hideAt = 0 },
			[3] = { stat = "MASTERY", hideAt = 0 },
			[4] = { stat = "VERSATILITY", hideAt = 0 },
			[5] = { stat = "LIFESTEAL", hideAt = 0 },
			[6] = { stat = "AVOIDANCE", hideAt = 0 },
			[7] = { stat = "DODGE", hideAt = 0, roles =  { "TANK" } },
			[8] = { stat = "PARRY", hideAt = 0, roles =  { "TANK" } },
			[9] = { stat = "BLOCK", hideAt = 0, roles =  { "TANK" } },
		},
	},
}

-- Update data, by Oyg123
PAPERDOLL_STATINFO["ENERGY_REGEN"].updateFunc = function(statFrame, unit)
	statFrame.numericValue = 0
	PaperDollFrame_SetEnergyRegen(statFrame, unit)
end

PAPERDOLL_STATINFO["RUNE_REGEN"].updateFunc = function(statFrame, unit)
	statFrame.numericValue = 0
	PaperDollFrame_SetRuneRegen(statFrame, unit)
end

PAPERDOLL_STATINFO["FOCUS_REGEN"].updateFunc = function(statFrame, unit)
	statFrame.numericValue = 0
	PaperDollFrame_SetFocusRegen(statFrame, unit)
end

PAPERDOLL_STATINFO["MOVESPEED"].updateFunc = function(statFrame, unit)
	PaperDollFrame_SetMovementSpeed(statFrame, unit)
end

table.insert(PAPERDOLL_STATCATEGORIES[1].stats,{ stat = "MOVESPEED" }) 
local tempstatFrame
hooksecurefunc("PaperDollFrame_SetMovementSpeed", function(statFrame, unit)
	if(tempstatFrame and tempstatFrame ~= statFrame)then
		tempstatFrame:SetScript("OnUpdate", nil)
	end
	statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate)
	tempstatFrame = statFrame
	statFrame:Show()
end)