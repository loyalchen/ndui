local B, C, L, DB = unpack(select(2, ...))

local f = CreateFrame("Frame", nil, UIParent)
local function Init()
	f:SetSize(C.Auras.IconSize, C.Auras.IconSize)
	f:SetPoint("CENTER", UIParent, "CENTER", -430, 0)
	B.CreateIF(f, true)
	f.Icon:SetTexture(select(3, GetSpellInfo(158300)))

	f.Bar = CreateFrame("Statusbar", nil, f)
	f.Bar:SetSize(C.Auras.IconSize*4, C.Auras.IconSize/4)
	f.Bar:SetPoint("BOTTOMLEFT", f, "BOTTOMRIGHT", 4, 0)
	B.CreateSB(f.Bar)
	f.Bar:SetMinMaxValues(0, 240)

	f.Text = f:CreateFontString(nil, "OVERLAY")
	f.Text:SetFont(DB.Font[1], DB.Font[2]+4, DB.Font[3])
	f.Text:SetPoint("BOTTOMRIGHT", f.Bar, "TOPRIGHT", 0, 2)
	
	if not NDuiDB["Resolve"] then NDuiDB["Resolve"] = {} end
	if NDuiDB["Resolve"]["Mover"] then
		f:SetPoint(unpack(NDuiDB["Resolve"]["Mover"]))
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:SetFrameStrata("HIGH")
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) f:StartMoving() end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		NDuiDB["Resolve"]["Mover"] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)	
end

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterUnitEvent("UNIT_AURA", "player")
f:SetScript("OnEvent", function()
	if not NDuiDB["Resolve"]["Enable"] then return end
	if not f.styled then
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		Init()
		f.styled = true
	end
	if f.styled then
		local name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, val1, _, val2 = UnitAura("player", GetSpellInfo(158300), "", "HELPFUL")
		if name and val2 > 0 then
			f.Bar:SetValue(val1)
			f.Text:SetText(val1.."% ("..val2..")")
			f:Show()
		else
			f.Bar:SetValue(0)
			f.Text:SetText("")
			f:Hide()
		end
	end
end)