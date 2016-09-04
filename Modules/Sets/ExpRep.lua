local B, C, L, DB = unpack(select(2, ...))

local Exp = CreateFrame("StatusBar", nil, UIParent)
Exp:SetPoint("TOP", Minimap, "BOTTOM", 1, -5)
Exp:SetSize(140, 5)
B.CreateSB(Exp)

Exp.Spark = Exp:CreateTexture(nil, "OVERLAY")
Exp.Spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
Exp.Spark:SetBlendMode("ADD")
Exp.Spark:SetAlpha(.8)
Exp.Spark:SetPoint("TOPLEFT", Exp:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
Exp.Spark:SetPoint("BOTTOMRIGHT", Exp:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

local Rest = CreateFrame("StatusBar", nil, Exp)
Rest:SetAllPoints()
Rest:SetStatusBarTexture(DB.normTex)
Rest:SetStatusBarColor(0, 0.4, 1, 0.6)
Rest:SetFrameLevel(Exp:GetFrameLevel() - 1)

local function UpdateData(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
	local name, standing, min, max, value, factionID = GetWatchedFactionInfo()
	local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		self:SetStatusBarColor(0, 0.7, 1)
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
	elseif name then
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
	else
		self:Hide()
		Rest:Hide()
	end
end

local function SetTooltip(self)
	local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
	local name, standing, min, max, value, factionID = GetWatchedFactionInfo()
	local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID)
	local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
	local nametext, standingtext
	GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	GameTooltip:ClearLines()
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		GameTooltip:AddLine(LEVEL.." "..UnitLevel("player"),0,.6,1)
		GameTooltip:AddDoubleLine(XP..":", xp.."/"..mxp.." ("..floor(xp/mxp*100).."%)",.6,.8,1,1,1,1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26..":", "+"..rxp.." ("..floor(rxp/mxp*100).."%)",.6,.8,1,1,1,1)
		end
		if IsXPUserDisabled() then GameTooltip:AddLine("|cffff0000"..XP..LOCKED) end
		if name then GameTooltip:AddLine(" ") end
	end
	if name then
		if friendID then
			nametext = name.." ("..currentRank.." / "..maxRank..")"
			standingtext = friendTextLevel
		else
			nametext = name
			standingtext = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
		end
		GameTooltip:AddLine(nametext,0,.6,1)
		GameTooltip:AddDoubleLine(standingtext, value - min.."/"..max - min.." ("..floor((value - min)/(max - min)*100).."%)",.6,.8,1,1,1,1)
	end
	GameTooltip:Show()
end

Exp:RegisterEvent("PLAYER_XP_UPDATE")
Exp:RegisterEvent("PLAYER_LEVEL_UP")
Exp:RegisterEvent("UPDATE_EXHAUSTION")
Exp:RegisterEvent("PLAYER_ENTERING_WORLD")
Exp:RegisterEvent("UPDATE_FACTION")
Exp:SetScript("OnEvent", UpdateData)
Exp:SetScript("OnEnter", SetTooltip)
Exp:SetScript("OnLeave", GameTooltip_Hide)