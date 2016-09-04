local B, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "ROGUE" and DB.MyClass ~= "DRUID" then return end

-- Style
local CPBar, bar = CreateFrame("Frame", nil, UIParent), {}
local Colors = { 
	[1] = {0.8, 0.1, 0.1},
	[2] = {0.8, 0.3, 0.1},
	[3] = {0.9, 0.6, 0.1},
	[4] = {0.6, 0.9, 0.1},
	[5] = {0.1, 0.9, 0.1},
}

local function CPBarGo()
	CPBar:SetSize(7*C.Auras.IconSize, 0.4*C.Auras.IconSize)
	for i = 1, MAX_COMBO_POINTS do
		bar[i] = CreateFrame("StatusBar", nil, CPBar)
		bar[i]:SetSize((5*C.Auras.IconSize - 4)/5, 0.2*C.Auras.IconSize)
		bar[i]:SetStatusBarTexture(DB.normTex)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i == 1 then
			bar[i]:SetPoint("LEFT", CPBar, "LEFT", C.Auras.IconSize, 0)
		else
			bar[i]:SetPoint("LEFT", bar[i-1], "RIGHT", 1.5, 0)
		end
		B.CreateIF(bar[i])
		bar[i]:SetStatusBarColor(unpack(Colors[i]))
	end
	CPBar.Mover = B.Mover(CPBar, TOGGLE, "CPoints", C.Auras.CPointsPos, 220, 20)
	SlashCmdList["CPOINTS"] = function(msg)
		if msg:lower() == "reset" then
			wipe(NDuiDB["CPoints"])
			ReloadUI()
		else
			if CPBar.Mover:IsVisible() then
				CPBar.Mover:Hide()
			else
				CPBar.Mover:Show()
			end
		end
	end
	SLASH_CPOINTS1 = "/sb"
end

CPBar:RegisterEvent("UNIT_COMBO_POINTS")
CPBar:RegisterEvent("PLAYER_TARGET_CHANGED")
CPBar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
CPBar:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
CPBar:RegisterEvent("PLAYER_ENTERING_WORLD")
CPBar:SetScript("OnEvent", function(self, event)
	if not NDuiDB["CPoints"] then NDuiDB["CPoints"] = {} end
	if not NDuiDB["CPoints"]["Enable"] then return end
	if not self.styled then
		CPBarGo()
		self.styled = true
	end
	if self.styled then
		if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM" or event == "UNIT_COMBO_POINTS" then
			if DB.MyClass == "DRUID" then
				if GetShapeshiftFormID() == CAT_FORM then
					self:Show()
				else
					self:Hide()
				end
			end
		end
		if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_COMBO_POINTS" or event == "PLAYER_TARGET_CHANGED" then
			local cp = GetComboPoints('player', 'target')
			for i = 1, MAX_COMBO_POINTS do
				if i <= cp then
					bar[i]:SetAlpha(1)
				else
					bar[i]:SetAlpha(0.2)
				end
				if bar[1]:GetAlpha() == 1 then
					bar[i]:Show()
				else
					bar[i]:Hide()
				end
			end
		end
	end
end)