local B, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "MAGE" then return end

-- Arcane Familiar
local f = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
f:SetSize(30,30)
f:SetPoint("BOTTOMLEFT", 360, 270)
B.CreateIF(f, true)
f.Icon:SetTexture(select(3, GetSpellInfo(210126)))
f:SetAttribute("*type*", "macro")
f:SetAttribute("macrotext", "/click TotemFrameTotem1 RightButton")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_TOTEM_UPDATE")
f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:SetScript("OnEvent", function()
	if not NDuiDB["Auras"]["Familiar"] then
		f:UnregisterAllEvents()
		f:Hide()
		return
	end
	if not IsSpellKnown(205022) then f:SetAlpha(0) return end
	local haveTotem, _, start, dur = GetTotemInfo(4)
	if haveTotem then
		f.CD:SetCooldown(start, dur)
		f:SetAlpha(1)
	else
		f.CD:SetCooldown(0, 0)
		f:SetAlpha(0)
	end
end)