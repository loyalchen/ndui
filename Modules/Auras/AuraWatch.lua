local B, C, L, DB = unpack(select(2, ...))
local AuraList, Aura, UnitIDTable, MaxFrame = {}, {}, {}, 12
if not AuraWatchDB then AuraWatchDB = {} end

-- Init
local function BuildAuraList()
	AuraList = C.AuraWatchList["ALL"] and C.AuraWatchList["ALL"] or {}
	for key, _ in pairs(C.AuraWatchList) do
		if key == DB.MyClass then
			for _, value in pairs(C.AuraWatchList[DB.MyClass]) do
				tinsert(AuraList, value)
			end
		end
	end
	wipe(C.AuraWatchList)
end
local function BuildUnitIDTable()
	for _, VALUE in pairs(AuraList) do
		for _, value in pairs(VALUE.List) do
			local Flag = true
			for _,v in pairs(UnitIDTable) do
				if value.UnitID == v then Flag = false end
			end
			if Flag then tinsert(UnitIDTable, value.UnitID) end
		end
	end
end
local function MakeMoveHandle(Frame, Text, key, Pos)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetWidth(Frame:GetWidth())
	MoveHandle:SetHeight(Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.normTex})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle.Text = MoveHandle:CreateFontString(nil, "OVERLAY")
	MoveHandle.Text:SetFont(unpack(DB.Font))
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	if not AuraWatchDB[key] then 
		MoveHandle:SetPoint(unpack(Pos))
	else
		MoveHandle:SetPoint(unpack(AuraWatchDB[key]))
	end
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		AuraWatchDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end

-----> STYLED CODE START
-- BuildICON
local function BuildICON(iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(iconSize)
	Frame:SetHeight(iconSize)
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
	Frame.Icon:SetAllPoints()
	Frame.Icon:SetTexCoord(unpack(DB.TexCoord))
	B.CreateSD(Frame, 3, 3)

	Frame.Count = Frame:CreateFontString(nil, "OVERLAY")
	Frame.Count:SetFont(DB.Font[1], iconSize*0.55, "THINOUTLINE")
	Frame.Count:SetPoint("BOTTOMRIGHT", 5, -3)

	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, "CooldownFrameTemplate")
	Frame.Cooldown:SetAllPoints()
	Frame.Cooldown:SetReverse(true)

	Frame.Spellname = Frame:CreateFontString(nil, "ARTWORK")
	Frame.Spellname:SetFont(DB.Font[1], 14, "THINOUTLINE")
	Frame.Spellname:SetPoint("BOTTOM", 0, -3)

	if NDuiDB["AuraWatch"]["Hint"] then
		Frame:EnableMouse(true)
		Frame.HL = Frame:CreateTexture(nil, "HIGHLIGHT")
		Frame.HL:SetTexture(1, 1, 1, 0.35)
		Frame.HL:SetAllPoints(Frame.Icon)

		Frame:SetScript("OnEnter", function(self)
			local str = "spell:%s"
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 3)
			if self.type == 1 then
				GameTooltip:SetSpellByID(self.spellID)
			elseif self.type == 2 then
				GameTooltip:SetHyperlink(select(2, GetItemInfo(self.spellID)))
			elseif self.type == 3 then
				GameTooltip:SetInventoryItem("player", self.spellID)
			elseif self.type == 4 then
				GameTooltip:SetUnitAura(self.unitID, self.id, self.filter)
			end
			GameTooltip:Show()
		end)
		Frame:SetScript("OnLeave", GameTooltip_Hide)
	end

	Frame:Hide()
	return Frame
end

-- BuildBAR
local function BuildBAR(barWidth, iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(iconSize)
	Frame:SetHeight(iconSize)
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
	Frame.Icon:SetAllPoints()
	Frame.Icon:SetTexCoord(unpack(DB.TexCoord))
	B.CreateSD(Frame, 4, 4)

	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame)
	Frame.Statusbar:SetWidth(barWidth)
	Frame.Statusbar:SetHeight(iconSize/2.5)
	Frame.Statusbar:SetPoint("BOTTOMLEFT", Frame, "BOTTOMRIGHT", 5, 0)
	Frame.Statusbar:SetMinMaxValues(0, 1)
	Frame.Statusbar:SetValue(0)
	B.CreateSB(Frame.Statusbar)

	Frame.Spark = Frame.Statusbar:CreateTexture(nil, "OVERLAY")
	Frame.Spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
	Frame.Spark:SetBlendMode("ADD")
	Frame.Spark:SetAlpha(.8)
	Frame.Spark:SetPoint("TOPLEFT", Frame.Statusbar:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
	Frame.Spark:SetPoint("BOTTOMRIGHT", Frame.Statusbar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

	Frame.Count = Frame:CreateFontString(nil, "OVERLAY")
	Frame.Count:SetFont(DB.Font[1], 14, "THINOUTLINE")
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1)

	Frame.Time = Frame.Statusbar:CreateFontString(nil, "ARTWORK")
	Frame.Time:SetFont(DB.Font[1], 14, "THINOUTLINE")
	Frame.Time:SetPoint("RIGHT", 0, 8)

	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, "ARTWORK")
	Frame.Spellname:SetFont(DB.Font[1], 14, "THINOUTLINE")
	Frame.Spellname:SetPoint("LEFT", 2, 8)

	if NDuiDB["AuraWatch"]["Hint"] then
		Frame:EnableMouse(true)
		Frame.HL = Frame:CreateTexture(nil, "HIGHLIGHT")
		Frame.HL:SetTexture(1, 1, 1, 0.35)
		Frame.HL:SetAllPoints(Frame.Icon)

		Frame:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 3)
			if self.type == 1 then
				GameTooltip:SetSpellByID(self.spellID)
			elseif self.type == 2 then
				GameTooltip:SetHyperlink(select(2, GetItemInfo(self.spellID)))
			elseif self.type == 3 then
				GameTooltip:SetInventoryItem("player", self.spellID)
			elseif self.type == 4 then
				GameTooltip:SetUnitAura(self.unitID, self.id, self.filter)
			end
			GameTooltip:Show()
		end)
		Frame:SetScript("OnLeave",  GameTooltip_Hide)
	end

	Frame:Hide()
	return Frame
end
-----> STYLED CODE END

local function BuildAura()
	for key, value in pairs(AuraList) do
		local FrameTable = {}
		for i = 1, MaxFrame do
			if value.Mode:lower() == "icon" then
				local Frame = BuildICON(value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			elseif value.Mode:lower() == "bar" then
				local Frame = BuildBAR(value.BarWidth, value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			end
		end
		FrameTable.Index = 1
		tinsert(Aura, FrameTable)
	end
end
local function Pos()
	for key, VALUE in pairs(Aura) do
		local value = AuraList[key]
		local Pre = nil
		for i = 1, #VALUE do
			local Frame = VALUE[i]
			if i == 1 then
				Frame:SetPoint("CENTER", Frame.MoveHandle)
			elseif value.Direction:lower() == "right" then
				Frame:SetPoint("LEFT", Pre, "RIGHT", value.Interval, 0)
			elseif value.Direction:lower() == "left" then
				Frame:SetPoint("RIGHT", Pre, "LEFT", -value.Interval, 0)
			elseif value.Direction:lower() == "up" then
				Frame:SetPoint("BOTTOM", Pre, "TOP", 0, value.Interval)
			elseif value.Direction:lower() == "down" then
				Frame:SetPoint("TOP", Pre, "BOTTOM", 0, -value.Interval)
			end
			Pre = Frame
		end
	end
end
local function Init()
	BuildAuraList()
	BuildUnitIDTable()
	BuildAura()
	Pos()
end

-- UpdateCD
local function UpdateCDFrame(index, name, icon, start, duration, bool, type, id)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		Frame.Cooldown:SetCooldown(start, duration)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.IsCD = true
		Frame.duration = duration
		Frame.start = start
		Frame.Timer = 0
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = self.start+self.duration-GetTime()
			if self.Timer < 0 then
				if self.Time then self.Time:SetText("N/A") end
				self.Statusbar:SetMinMaxValues(0, 1)
				self.Statusbar:SetValue(0)
				self.Spark:Hide()
			elseif self.Timer < 60 then
				if self.Time then self.Time:SetFormattedText("%.1f", self.Timer) end
				self.Statusbar:SetMinMaxValues(0, self.duration)
				self.Statusbar:SetValue(self.Timer)
				self.Spark:Show()
			else
				if self.Time then self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60) end
				self.Statusbar:SetMinMaxValues(0, self.duration)
				self.Statusbar:SetValue(self.Timer)
				self.Spark:Show()
			end
		end)
	end
	Frame.type = type
	Frame.spellID = id

	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function UpdateCD()
	for KEY, VALUE in pairs(AuraList) do
		for _, value in pairs(VALUE.List) do
			if value.SpellID then
				if GetSpellCooldown(value.SpellID) and select(2, GetSpellCooldown(value.SpellID)) > 1.5 then
					local name, _, icon = GetSpellInfo(value.SpellID)
					local start, duration = GetSpellCooldown(value.SpellID)
					if VALUE.Mode:lower() == "icon" then
						name = nil
					end
					UpdateCDFrame(KEY, name, icon, start, duration, true, 1, value.SpellID)
				end
			end
			if value.ItemID then
				if select(2, GetItemCooldown(value.ItemID)) > 1.5 then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)
					local start, duration = GetItemCooldown(value.ItemID)
					if VALUE.Mode:lower() == "icon" then
						name = nil
					end
					UpdateCDFrame(KEY, name, icon, start, duration, false, 2, value.ItemID)
				end
			end
			if value.SlotID then
				local link = GetInventoryItemLink("player", value.SlotID)
				if link then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(link)
					local start, duration = GetInventoryItemCooldown("player", value.SlotID)
					if duration > 1.5 then
						if VALUE.Mode:lower() == "icon" then
							name = nil
						end
						UpdateCDFrame(KEY, name, icon, start, duration, false, 3, value.SlotID)
					end
				end
			end
			if value.TotemID then
				local haveTotem, name, start, duration, icon = GetTotemInfo(value.TotemID)
				local id = select(7, GetSpellInfo(name))
				if haveTotem then
					if duration > 1.5 then
						if VALUE.Mode:lower() == "icon" then
							name = nil
						end
						UpdateCDFrame(KEY, name, icon, start, duration, false, 4, id)
					end
				end
			end
		end
	end
end

-- UpdateAura
local function UpdateAuraFrame(index, UnitID, name, icon, count, duration, expires, id, filter)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Count then Frame.Count:SetText(count > 1 and count or nil) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(true)
		Frame.Cooldown:SetCooldown(expires-duration, duration)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.duration = duration
		Frame.expires = expires
		Frame.Timer = 0
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = self.expires-GetTime()
			if self.Timer < 0 then
				if self.Time then self.Time:SetText("N/A") end
				self.Statusbar:SetMinMaxValues(0, 1)
				self.Statusbar:SetValue(0)
				self.Spark:Hide()
			elseif self.Timer < 60 then
				if self.Time then self.Time:SetFormattedText("%.1f", self.Timer) end
				self.Statusbar:SetMinMaxValues(0, self.duration)
				self.Statusbar:SetValue(self.Timer)
				self.Spark:Show()
			else
				if self.Time then self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60) end
				self.Statusbar:SetMinMaxValues(0, self.duration)
				self.Statusbar:SetValue(self.Timer)
				self.Spark:Show()
			end
		end)
	end
	Frame.type = 4
	Frame.unitID = UnitID
	Frame.id = id
	Frame.filter = filter

	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function AuraFilter(spellID, UnitID, index, bool)
	for KEY, VALUE in pairs(AuraList) do
		for key, value in pairs(VALUE.List) do
			if value.AuraID == spellID and value.UnitID == UnitID then
				if bool then
					local name, _, icon, count, _, duration, expires, caster, _, _, _, _, _, _, number = UnitBuff(value.UnitID, index)
					if value.Combat and not InCombatLockdown() then return false end
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					if value.Value and number then
						if VALUE.Mode:lower() == "icon" then
							name = B.Numb(number)
						elseif VALUE.Mode:lower() == "bar" then
							name = name..":"..B.Numb(number)
						end
					else
						if VALUE.Mode:lower() == "icon" then
							name = nil
						elseif VALUE.Mode:lower() == "bar" then
							name = name
						end
					end
					if value.Timeless then duration, expires = 0, 0 end
					return KEY, value.UnitID, name, icon, count, duration, expires, index, "HELPFUL"
				else
					local name, _, icon, count, _, duration, expires, caster, _, _, _, _, _, _, number = UnitDebuff(value.UnitID, index)
					if value.Combat and not InCombatLockdown() then return false end
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					if value.Value and number then
						if VALUE.Mode:lower() == "icon" then
							name = B.Numb(number)
						elseif VALUE.Mode:lower() == "bar" then
							name = name..":"..B.Numb(number)
						end
					else
						if VALUE.Mode:lower() == "icon" then
							name = nil
						elseif VALUE.Mode:lower() == "bar" then
							name = name
						end
					end
					if value.Timeless then duration, expires = 0, 0 end
					return KEY, value.UnitID, name, icon, count, duration, expires, index, "HARMFUL"
				end
			end
		end
	end
	return false
end
local function UpdateAura(UnitID)
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(UnitID, index)
		if not name then break end
		if AuraFilter(spellID, UnitID, index, true) then UpdateAuraFrame(AuraFilter(spellID, UnitID, index, true)) end
		index = index + 1
	end
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitDebuff(UnitID, index)
		if not name then break end
		if AuraFilter(spellID, UnitID, index, false) then UpdateAuraFrame(AuraFilter(spellID, UnitID, index, false)) end
		index = index + 1
	end
end

-- CleanUp
local function CleanUp()
	for _, value in pairs(Aura) do
		for i = 1, MaxFrame do
			if value[i] then
				value[i]:Hide()
				value[i]:SetScript("OnUpdate", nil)
			end
			if value[i].Icon then value[i].Icon:SetTexture(nil) end
			if value[i].Count then value[i].Count:SetText(nil) end
			if value[i].Spellname then value[i].Spellname:SetText(nil) end
			if value[i].Statusbar then
				value[i].Statusbar:SetMinMaxValues(0, 1) 
				value[i].Statusbar:SetValue(0)
			end
		end
		value.Index = 1
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, event, unitID, ...)
	if not NDuiDB["AuraWatch"]["Enable"] then return end
	if event == "PLAYER_ENTERING_WORLD" and not AuraWatchDB.Hide then
		Init()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
Event.Timer = 0
local onUpdate = function(self, elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 0 then
		self.Timer = 0
		CleanUp()
		UpdateCD()
		for _, value in pairs(UnitIDTable) do
			UpdateAura(value)
		end
	end
end
Event:SetScript("OnUpdate", onUpdate)

-- Test
local TestFlag = true
SlashCmdList.AuraWatch = function(msg)
	if msg:lower() == "move" then
		Event:SetScript("OnUpdate", nil)
		for _, value in pairs(Aura) do
			for i = 1, MaxFrame do
				if value[i] then
					value[i]:SetScript("OnUpdate", nil)
					value[i]:Show()
				end
				if value[i].Icon then value[i].Icon:SetTexture(select(3, GetSpellInfo(118))) end
				if value[i].Count then value[i].Count:SetText("9") end
				if value[i].Time then value[i].Time:SetText("59.59") end
				if value[i].Statusbar then value[i].Statusbar:SetValue(1) end
				if value[i].Spellname then value[i].Spellname:SetText("变形术") end
			end
			value[1].MoveHandle:Show()
		end
	elseif msg:lower() == "lock" then
		CleanUp()
		for _, value in pairs(Aura) do
			value[1].MoveHandle:Hide()
		end
		Event:SetScript("OnUpdate", onUpdate)
	elseif msg:lower() == "reset" then
		wipe(AuraWatchDB)
		ReloadUI()
	elseif msg:lower() == "hide" then
		CleanUp()
		Event:SetScript("OnUpdate", nil)
		AuraWatchDB.Hide = true
	else
		print("|cff70C0F5------------------------")
		print("|cff0080ffAuraWatch |cff70C0F5"..COMMAND..":")
		print("|c0000ff00/aw move |cff70C0F5"..UNLOCK)
		print("|c0000ff00/aw lock |cff70C0F5"..LOCK)
		print("|c0000ff00/aw reset |cff70C0F5"..RESET)
		print("|c0000ff00/aw hide |cff70C0F5"..DISABLE)
		print("|cff70C0F5------------------------")
	end
end
SLASH_AuraWatch1 = "/aw"