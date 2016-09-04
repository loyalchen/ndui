local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

-- main
local classification = {
    elite = " |cffcc8800"..ELITE.."|r",
    rare = " |cffff99cc"..RARE.."|r",
    rareelite = " |cffff99cc"..RARE.."|r ".."|cffcc8800"..ELITE.."|r",
	worldboss = " |cffff0000"..BOSS.."|r",
}

local find = string.find
local format = string.format
local COALESCED_REALM_TOOLTIP1 = string.split(FOREIGN_SERVER_LABEL, COALESCED_REALM_TOOLTIP)
local INTERACTIVE_REALM_TOOLTIP1 = string.split(INTERACTIVE_SERVER_LABEL, INTERACTIVE_REALM_TOOLTIP)

local nilcolor = { r = 1, g = 1, b = 1 }
local tapped = { r = .6, g = .6, b = .6}
local function unitColor(unit)
	if not unit then unit = "mouseover" end
	local color
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		color = RAID_CLASS_COLORS[class]
	elseif(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		color = tapped
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			color = FACTION_BAR_COLORS[reaction]
		end
	end
	return (color or nilcolor)
end

local function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
	if color then return color.r, color.g, color.b end
end

local function getUnit(self)
	local _, unit = self and self:GetUnit()
	if(not unit) then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or mFocus:GetAttribute("unit"))	or "mouseover"
	end
	return unit
end

local function hideLines(self)
    for i = 3, self:NumLines() do
        local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext then
			if (NDuiDB["Tooltip"]["HidePVP"] and linetext:find(PVP)) then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif (linetext:find(COALESCED_REALM_TOOLTIP1) or linetext:find(INTERACTIVE_REALM_TOOLTIP1)) then
				tiptext:SetText(nil)
				tiptext:Hide()
				local pretiptext = _G["GameTooltipTextLeft"..i-1]
				pretiptext:SetText(nil)
				pretiptext:Hide()
				self:Show()
			elseif (linetext:find(FACTION_HORDE)) then
				if NDuiDB["Tooltip"]["HideFaction"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040"..linetext.."|r")
				end
			elseif (linetext:find(FACTION_ALLIANCE)) then
				if NDuiDB["Tooltip"]["HideFaction"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff"..linetext.."|r")
				end
			end
		end
    end
end

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(">"..string.upper(YOU).."<")
    else
        return B.HexRGB(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if (NDuiDB["Tooltip"]["CombatHide"] and InCombatLockdown()) then
		return self:Hide()
	end
	hideLines(self)

	local unit = getUnit(self)
    if UnitExists(unit) then
        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)
        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."18|t", text)
        end

        if UnitIsPlayer(unit) then
			local unitName
			if NDuiDB["Tooltip"]["HideTitle"] and NDuiDB["Tooltip"]["HideRealm"] then
				unitName = UnitName(unit)
			elseif NDuiDB["Tooltip"]["HideTitle"] then
				unitName = GetUnitName(unit, true)
			elseif NDuiDB["Tooltip"]["HideRealm"] then
				unitName = UnitPVPName(unit) or UnitName(unit)
			end
			if unitName then GameTooltipTextLeft1:SetText(unitName) end
			
			local relationship = UnitRealmRelationship(unit)
			if(relationship == LE_REALM_RELATION_VIRTUAL) then
				self:AppendText(("|cffcccccc%s|r"):format(INTERACTIVE_SERVER_LABEL))
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				self:AppendText((" |cff00cc00<%s>|r"):format(status))
			end

			if NDuiDB["Tooltip"]["FactionIcon"] then
				if UnitFactionGroup(unit) and UnitFactionGroup(unit) ~= "Neutral" then
					GameTooltipTextLeft1:SetText("|TInterface\\TARGETINGFRAME\\UI-PVP-"..UnitFactionGroup(unit)..":16:16:0:0:64:64:5:40:0:35|t "..GameTooltipTextLeft1:GetText())
				end
			end

			local unitGuild, tmp, tmp2 = GetGuildInfo(unit)
			local text = GameTooltipTextLeft2:GetText()
			if tmp then
				tmp2 = tmp2 + 1
				if NDuiDB["Tooltip"]["HideRank"] then
					GameTooltipTextLeft2:SetText("<"..text..">")
				else
					GameTooltipTextLeft2:SetText("<"..text..">  "..tmp.."("..tmp2..")")
				end
				if IsInGuild() and unitGuild == GetGuildInfo("player") then
					GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
				else
					GameTooltipTextLeft2:SetTextColor(1, 0.1, 0.8)
				end
			end
		end

		local color = unitColor(unit)
		local line1 = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText(("%s"), B.HexRGB(color)..line1)
		GameTooltipTextLeft1:SetTextColor(GameTooltip_UnitColor(unit))

        local alive = not UnitIsDeadOrGhost(unit)
		local level
		if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
			level = UnitBattlePetLevel(unit)
		else
			level = UnitLevel(unit)
		end

        if level then
            local unitClass = UnitIsPlayer(unit) and ("%s %s"):format(UnitRace(unit) or "", B.HexRGB(color)..(UnitClass(unit) or "").."|r") or ""
			local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)
			
			local boss
            if level == -1 then boss = "|cffff0000Boss|r" end

            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(B.HexRGB(diff), boss or ("%d"):format(level), classification[classify] or "")
			local tiptextLevel
			for i = 2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
				local linetext = tiptext:GetText()

				if(linetext and linetext:find(LEVEL)) then
					tiptextLevel = tiptext
				end
            end

			if(tiptextLevel) then
				tiptextLevel:SetFormattedText(("%s %s%s %s"), textLevel, creature, unitClass,
				(not alive and "|cffCCCCCC"..DEAD.."|r" or ""))
			end
        end

        if UnitExists(unit.."target") then
			local tarRicon = GetRaidTargetIndex(unit.."target")
			local tar = ("%s%s"):format((tarRicon and ICON_LIST[tarRicon].."10|t") or "", getTarget(unit.."target"))

			self:AddLine(TARGET..": "..tar)
        end
		
		if alive then
			GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
		else
			GameTooltipStatusBar:Hide()
		end
    else
        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end
    if GameTooltipStatusBar:IsShown() then
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOPLEFT", self, "TOPLEFT", 3, 10)
        GameTooltipStatusBar:SetPoint("TOPRIGHT", self, -3, 0)
    end
	self.TipUpdate = 0
end)

GameTooltipStatusBar:SetStatusBarTexture(DB.normTex)
GameTooltipStatusBar:SetHeight(4)
local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetTexture(DB.normTex)
bg:SetVertexColor(0.05, 0.05, 0.05, 0.6)
B.CreateSD(GameTooltipStatusBar, 3, 3)

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then return end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then return end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
            self.text:SetPoint("CENTER", GameTooltipStatusBar)
            self.text:SetFont(unpack(DB.Font))
        end
        self.text:Show()
        local hp = B.Numb(min).." / "..B.Numb(max)
        self.text:SetText(hp)
    end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local frame = GetMouseFocus()
    if NDuiDB["Tooltip"]["Cursor"] then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
	else
        tooltip:SetOwner(parent, "ANCHOR_NONE")	
        tooltip:SetPoint(C.Tooltip.Pos[1], UIParent, C.Tooltip.Pos[2], C.Tooltip.Pos[3], C.Tooltip.Pos[4])
    end
end)

local function style(frame)
	if(not frame) then return end
	frame:SetScale(C.Tooltip.Scale)
	if(not frame.styled) then
		B.CreateBD(frame, 0.7, 3)
		B.CreateTex(frame)
		frame.styled = true
	end
	frame:SetBackdropColor(0, 0, 0, 0.7)
	if not NDuiDB["Tooltip"] then NDuiDB["Tooltip"] = {} end
	if NDuiDB["Tooltip"]["ClassColor"] then
		if frame.GetItem then
			local _, item = frame:GetItem()
			if item then
				local quality = select(3, GetItemInfo(item))
				if(quality) then
					local r, g, b = GetItemQualityColor(quality)
					frame:SetBackdropBorderColor(r, g, b)
				end
			else
				frame:SetBackdropBorderColor(0, 0, 0)
			end
		end
		local _, unit = GameTooltip:GetUnit()
		if UnitExists(unit) and UnitIsPlayer(unit) then
			frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
		end
	else
		frame:SetBackdropBorderColor(0, 0, 0)
	end

    if frame.NumLines then
        for index = 1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(DB.TipFont[1], DB.TipFont[2] + 2, DB.TipFont[3])
            else
                _G[frame:GetName()..'TextLeft'..index]:SetFont(unpack(DB.TipFont))
            end
            _G[frame:GetName()..'TextRight'..index]:SetFont(unpack(DB.TipFont))
        end
    end
end

local function extrastyle(f)
	f:SetBackdrop(nil)
	f:DisableDrawLayer("BACKGROUND")
	local bg = CreateFrame("Frame", nil, f)
	bg:SetAllPoints()
	bg:SetFrameLevel(0)
	style(bg)
end

local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_DebugTools" and not IsAddOnLoaded("Aurora") then
		FrameStackTooltip:HookScript("OnShow", style)
	end

	if addon == "NDui" then
		local tooltips = {
			GameTooltip,
			ItemRefTooltip,
			ItemRefShoppingTooltip1,
			ItemRefShoppingTooltip2,
			ShoppingTooltip1,
			ShoppingTooltip2,
			AutoCompleteBox,
			FriendsTooltip,
			WorldMapTooltip,
			WorldMapCompareTooltip1,
			WorldMapCompareTooltip2,
			WorldMapCompareTooltip3,
			DropDownList1MenuBackdrop,
			DropDownList2MenuBackdrop,
			DropDownList3MenuBackdrop,
			ConsolidatedBuffsTooltip,
			FriendsMenuXPMenuBackdrop,
			FriendsMenuXPSecureMenuBackdrop,
			QuestScrollFrame.StoryTooltip,
			GeneralDockManagerOverflowButtonList,
		}
		for _, f in pairs(tooltips) do
			if f then
				f:HookScript("OnShow", style)
			end
		end

		local extra = {
			QueueStatusFrame,
			FloatingGarrisonFollowerTooltip,
			FloatingGarrisonFollowerAbilityTooltip,
			FloatingGarrisonMissionTooltip,
			GarrisonFollowerAbilityTooltip,
			GarrisonFollowerTooltip,
			BattlePetTooltip,
			PetBattlePrimaryAbilityTooltip,
			PetBattlePrimaryUnitTooltip,
			FloatingBattlePetTooltip,
			FloatingPetBattleAbilityTooltip,
		}
		for _, f in pairs(extra) do
			extrastyle(f)
		end
	end

	if addon == "Blizzard_Collections" then
		local petty = {
			PetJournalPrimaryAbilityTooltip,
			PetJournalSecondaryAbilityTooltip,
		}
		for _, f in pairs(petty) do
			extrastyle(f)
		end
	end

	if addon == "Blizzard_GarrisonUI" then
		local gt = {
			GarrisonMissionMechanicTooltip,
			GarrisonMissionMechanicFollowerCounterTooltip,
		}
		for _, f in pairs(gt) do
			extrastyle(f)
		end

		local BuildingLevelTooltip = GarrisonBuildingFrame.BuildingLevelTooltip
		for i = 1, 9 do
			select(i, BuildingLevelTooltip:GetRegions()):Hide()
			style(BuildingLevelTooltip)
		end
	end
end)

local function formatLines(self)
	for i = 1, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local point, relTo, relPoint, x, y = tiptext:GetPoint()
		tiptext:ClearAllPoints()

		if i == 1 then
			tiptext:SetPoint("TOPLEFT", self, "TOPLEFT", x, y)
		else
			local key = i - 1
			while(true) do
				local preTiptext = _G["GameTooltipTextLeft"..key]
				if(preTiptext and not preTiptext:IsShown()) then
					key = key - 1
				else
					break
				end
			end
			tiptext:SetPoint("TOPLEFT", _G["GameTooltipTextLeft"..key], "BOTTOMLEFT", x, -2)
		end
	end
end

local timer = 0.1
local function GT_OnUpdate(self, elapsed)
	self:SetBackdropColor(0, 0, 0, 0.7)
	self.TipUpdate = (self.TipUpdate or timer) - elapsed
	if(self.TipUpdate > 0) then return end
	self.TipUpdate = timer

	local unit = getUnit(self)
	if self:IsUnit(unit) then hideLines(self) end
	formatLines(self)
end
GameTooltip:HookScript("OnUpdate", GT_OnUpdate)

-- Because if you're not hacking, you're doing it wrong
local function OverrideGetBackdropColor()
	return 0, 0, 0, 0.7
end
GameTooltip.GetBackdropColor = OverrideGetBackdropColor
GameTooltip:SetBackdropColor(0, 0, 0, 0.7)

local function OverrideGetBackdropBorderColor()
	return 0, 0, 0
end
GameTooltip.GetBackdropBorderColor = OverrideGetBackdropBorderColor
GameTooltip:SetBackdropBorderColor(0, 0, 0)

-- Reskin Closebutton
if IsAddOnLoaded("Aurora") then
	local F, C = unpack(Aurora)
	F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
	F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
	F.ReskinClose(FloatingGarrisonMissionTooltip.CloseButton)
end

-- Temporary resize fix (patch 6.1)
hooksecurefunc("GameTooltip_Hide", function() GameTooltip:SetMinimumWidth(0, false) end)