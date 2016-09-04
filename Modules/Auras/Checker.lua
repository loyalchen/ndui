local B, C, L, DB = unpack(select(2, ...))

-- Main
local BuffFrame = {}
for i = 1, 11 do
	local Temp = CreateFrame("Frame", nil, UIParent)
	Temp:SetWidth(C.Auras.IconSize - 4)
	Temp:SetHeight(C.Auras.IconSize - 4)
	B.CreateSD(Temp, 2, 3)
	
	Temp.Icon = Temp:CreateTexture(nil, "ARTWORK")
	Temp.Icon:SetPoint("TOPLEFT", 1, -1)
	Temp.Icon:SetPoint("BOTTOMRIGHT", -1, 1)
	Temp.Icon:SetTexCoord(unpack(DB.TexCoord))

	Temp.Text = Temp:CreateFontString(nil, "OVERLAY")
	Temp.Text:SetPoint("CENTER", 1, 0)
	Temp.Text:SetFont(DB.Font[1], 18, DB.Font[3])

	if i == 1 then
		Temp:SetPoint(unpack(C.Auras.CheckerPos))
	else
		Temp:SetPoint("LEFT", BuffFrame[i-1], "RIGHT", 1, 0)
	end

	Temp:SetAlpha(0)	
	table.insert(BuffFrame,Temp)
end

-- Event
local Melee, text
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterUnitEvent("UNIT_AURA", "player")
Event:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
Event:RegisterEvent("BAG_UPDATE")
Event:RegisterEvent("GROUP_ROSTER_UPDATE")
Event:SetScript("OnEvent",function(self, event, unit, ...)
	if not NDuiDB["Checker"] then NDuiDB["Checker"] = {} end
	if not NDuiDB["Checker"]["Enable"] then return end
	if UnitLevel("player") < 10 then return end
	for key, value in pairs(BuffFrame) do
		if NDuiDB["Checker"]["Party"] and GetNumGroupMembers() == 0 then
			value:Hide()
		elseif NDuiDB["Checker"]["Party"] and GetNumGroupMembers() > 0 then
			value:Show()
		end
	end

	if (DB.Role == "Melee") or (DB.Role == "Tank") then
		Melee = true
	else
		Melee = false
	end

	for i = 1, 9 do
		if DB.BuffList[i] and DB.BuffList[i][1] then
			BuffFrame[i]:SetAlpha(0.2)
			BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(DB.BuffList[i][1])))
			BuffFrame[i].hasBuff = nil
			for key, value in pairs(DB.BuffList[i]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[i].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(1)
					BuffFrame[i].hasBuff = true
					BuffFrame[i].name = name
					break
				end
			end
		end
	end
	--攻强/法强
	if Melee then
		if DB.BuffList[10] and DB.BuffList[10][1] then
			BuffFrame[10]:SetAlpha(0.2)
			BuffFrame[10].Icon:SetTexture(select(3, GetSpellInfo(DB.BuffList[10][1])))
			BuffFrame[10].hasBuff = nil
			for key, value in pairs(DB.BuffList[10]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[10].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[10]:SetAlpha(1)
					BuffFrame[10].hasBuff = true
					BuffFrame[10].name = name
					break
				end
			end
		end
	else
		if DB.BuffList[11] and DB.BuffList[11][1] then
			BuffFrame[10]:SetAlpha(0.2)
			BuffFrame[10].Icon:SetTexture(select(3, GetSpellInfo(DB.BuffList[11][1])))
			BuffFrame[10].hasBuff = nil
			for key, value in pairs(DB.BuffList[11]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[10].Icon:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[10]:SetAlpha(1)
					BuffFrame[10].hasBuff = true
					BuffFrame[10].name = name
					break
				end
			end
		end
	end
	--治疗石
	if DB.BuffList[12] and DB.BuffList[12][1] then
		local stone = select(10, GetItemInfo(DB.BuffList[12][1]))
		BuffFrame[11]:SetAlpha(0.2)
		BuffFrame[11].Icon:SetTexture(stone)
		BuffFrame[11].Text:SetText(nil)
		BuffFrame[11].hasBuff = nil
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local tex = GetContainerItemInfo(bag, slot)
				if tex and tex == stone then
					BuffFrame[11]:SetAlpha(1)
					BuffFrame[11].Text:SetText(GetItemCount(DB.BuffList[12][1], nil, true))
					BuffFrame[11].hasBuff = true
					BuffFrame[11].info = {bag, slot}
					break
				end
			end
		end					
	end
end)

for i = 1, 11 do
	local function Button_OnEnter(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -5, -5)
		GameTooltip:ClearLines()

		if(self.hasBuff) then
			if i == 11 then
				GameTooltip:SetBagItem(unpack(BuffFrame[11].info))
			else
				GameTooltip:SetUnitAura("player", BuffFrame[i].name)
			end
		else	
			if i == 1 then text = RAID_BUFF_FLASK
			elseif i == 2 then text = RAID_BUFF_FOOD
			elseif i == 3 then text = RAID_BUFF_1	--属性
			elseif i == 4 then text = RAID_BUFF_2	--耐力
			elseif i == 5 then text = RAID_BUFF_6	--暴击
			elseif i == 6 then text = RAID_BUFF_7	--精通
			elseif i == 7 then text = RAID_BUFF_8	--溅射
			elseif i == 8 then text = RAID_BUFF_9	--全能
			elseif i == 9 then text = RAID_BUFF_4	--急速
			elseif i == 10 then
				if Melee then text = RAID_BUFF_3 else text = RAID_BUFF_5 end --攻强/法强
			elseif i == 11 then text = RAID_BUFF_HS	--治疗石
			end
			GameTooltip:AddLine(DB.MyColor..text..": |cffff0000"..LACK)	
		end
		GameTooltip:Show()
	end
	BuffFrame[i]:SetScript("OnEnter", Button_OnEnter)
	BuffFrame[i]:SetScript("OnLeave", GameTooltip_Hide)
end