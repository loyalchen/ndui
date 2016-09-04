local B, C, L, DB = unpack(select(2, ...))

--[[
	一个工具条用来替代系统的经验条、声望条、神器经验等等
]]
local Exp = CreateFrame("StatusBar", nil, Minimap)
Exp:SetPoint("TOP", Minimap, "BOTTOM", 0, -5)
Exp:SetSize(Minimap:GetWidth() - 10, 4)
Exp:SetHitRectInsets(0, 0, 0, -10)
B.CreateSB(Exp)

Exp.Spark = Exp:CreateTexture(nil, "OVERLAY")
Exp.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
Exp.Spark:SetBlendMode("ADD")
Exp.Spark:SetAlpha(.8)
Exp.Spark:SetPoint("TOPLEFT", Exp:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
Exp.Spark:SetPoint("BOTTOMRIGHT", Exp:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

local Rest = CreateFrame("StatusBar", nil, Exp)
Rest:SetAllPoints()
Rest:SetStatusBarTexture(DB.normTex)
Rest:SetStatusBarColor(0, .4, 1, .6)
Rest:SetFrameLevel(Exp:GetFrameLevel() - 1)

local newPoint = Exp:CreateTexture(nil, "OVERLAY")
newPoint:SetTexture("Interface\\COMMON\\ReputationStar")
newPoint:SetTexCoord(.5, 1, .5, 1)
newPoint:SetSize(20, 20)
newPoint:SetPoint("CENTER", 0, -2)

local function UpdateData(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	newPoint:SetAlpha(0)
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		self:SetStatusBarColor(0, .7, 1)
		self:SetMinMaxValues(0, mxp)
		self:SetValue(xp)
		self:Show()
		if rxp then
			Rest:SetMinMaxValues(0, mxp)
			Rest:SetValue(math.min(xp + rxp, mxp))
			Rest:Show()
		else
			Rest:Hide()
		end
	elseif GetWatchedFactionInfo() then
		local _, standing, min, max, value, factionID = GetWatchedFactionInfo()
		local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
		if friendID then
			if nextFriendThreshold then
				min, max, value = friendThreshold, nextFriendThreshold, friendRep
			else
				min, max, value = 0, 1, 1
			end
			standing = 5
		end
		self:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 0.85)
		self:SetMinMaxValues(min, max)
		self:SetValue(value)
		self:Show()
		Rest:Hide()
	elseif HasArtifactEquipped() then
		local _, _, _, _, totalXP, pointsSpent = C_ArtifactUI.GetEquippedArtifactInfo()
		local _, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)
		self:SetStatusBarColor(.9, .8, .6)
		self:SetMinMaxValues(0, xpForNextPoint)
		self:SetValue(xp)
		self:Show()
		Rest:Hide()
	else
		self:Hide()
		Rest:Hide()
	end

	-- Available ArtfactPoint
	if HasArtifactEquipped() then
		local _, _, _, _, totalXP, pointsSpent = C_ArtifactUI.GetEquippedArtifactInfo()
		local num = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)
		if num > 0 then newPoint:SetAlpha(1) end
	end

	if not NDuiDB["Misc"]["ExpRep"] then
		self:Hide()
		Rest:Hide()
		self:UnregisterAllEvents()
	end
end

local function SetTooltip(self)
	GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	GameTooltip:ClearLines()
	GameTooltip:AddLine(LEVEL.." "..UnitLevel("player"), 0,.6,1)

	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		GameTooltip:AddDoubleLine(XP..":", xp.."/"..mxp.." ("..floor(xp/mxp*100).."%)", .6,.8,1, 1,1,1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26..":", "+"..rxp.." ("..floor(rxp/mxp*100).."%)", .6,.8,1, 1,1,1)
		end
		if IsXPUserDisabled() then GameTooltip:AddLine("|cffff0000"..XP..LOCKED) end
	end

	if GetWatchedFactionInfo() then
		local name, standing, min, max, value, factionID = GetWatchedFactionInfo()
		local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
		local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
		local standingtext
		if friendID then
			if maxRank > 0 then
				name = name.." ("..currentRank.." / "..maxRank..")"
			end
			if not nextFriendThreshold then
				value = max - 1
			end
			standingtext = friendTextLevel
		else
			standingtext = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(name, 0,.6,1)
		GameTooltip:AddDoubleLine(standingtext, value - min.."/"..max - min.." ("..floor((value - min)/(max - min)*100).."%)", .6,.8,1, 1,1,1)
	end

	if IsWatchingHonorAsXP() then
		local current, max = UnitHonor("player"), UnitHonorMax("player")
		local level, levelmax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()
		local text
		if CanPrestige() then
			text = PVP_HONOR_PRESTIGE_AVAILABLE
		elseif level == levelmax then
			text = MAX_HONOR_LEVEL
		else
			text = current.."/"..max
		end
		GameTooltip:AddLine(" ")
		if UnitPrestige("player") > 0 then
			GameTooltip:AddLine(select(2, GetPrestigeInfo(UnitPrestige("player"))), .0,.6,1)
		else
			GameTooltip:AddLine(PVP_PRESTIGE_RANK_UP_TITLE..LEVEL.."0", .0,.6,1)
		end
		GameTooltip:AddDoubleLine(HONOR_POINTS..LEVEL..level, text, .6,.8,1, 1,1,1)
	end

	if HasArtifactEquipped() then
		local _, _, name, _, totalXP, pointsSpent = C_ArtifactUI.GetEquippedArtifactInfo()
		local num, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(name, 0,.6,1)
		GameTooltip:AddDoubleLine(ARTIFACT_POWER, totalXP.." ("..num..")", .6,.8,1, 1,1,1)
		GameTooltip:AddDoubleLine(NEXT_TRAIT, xp.."/"..xpForNextPoint, .6,.8,1, 1,1,1)
	end
	GameTooltip:Show()
end

Exp:RegisterEvent("PLAYER_XP_UPDATE")
Exp:RegisterEvent("PLAYER_LEVEL_UP")
Exp:RegisterEvent("UPDATE_EXHAUSTION")
Exp:RegisterEvent("PLAYER_ENTERING_WORLD")
Exp:RegisterEvent("UPDATE_FACTION")
Exp:RegisterEvent("ARTIFACT_XP_UPDATE")
Exp:RegisterEvent("UNIT_INVENTORY_CHANGED")
Exp:SetScript("OnEvent", UpdateData)
Exp:SetScript("OnEnter", SetTooltip)
Exp:SetScript("OnLeave", GameTooltip_Hide)