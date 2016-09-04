local B, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "MONK" then return end

-- Style
local f = CreateFrame("Frame", nil, UIParent)
local Icon1 = CreateFrame("Frame", nil, UIParent)
local Icon2 = CreateFrame("Frame", nil, UIParent)
local Icon3 = CreateFrame("Frame", nil, UIParent)
local Statue = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
local function StaggerGo()
	f:SetSize(C.Auras.IconSize, C.Auras.IconSize)
	B.CreateIF(f, true)
	f.Bar = CreateFrame("StatusBar", nil, f)
	f.Bar:SetSize(C.Auras.IconSize*4 + 12, 5)
	B.CreateSB(f.Bar)
	f:SetPoint("BOTTOMRIGHT", f.Bar, "TOPRIGHT", 0, 4)
	f.Text = f:CreateFontString(nil, "OVERLAY")
	f.Text:SetFont(DB.Font[1], DB.Font[2] + 4, DB.Font[3])
	f.Text:SetPoint("TOPRIGHT", f.Bar, "BOTTOMRIGHT", 0, -2)

	-- Elusive Brew
	Icon3:SetSize(C.Auras.IconSize, C.Auras.IconSize)
	Icon3:SetPoint("RIGHT", f, "LEFT", -4, 0)
	B.CreateIF(Icon3, true)
	Icon3.Icon:SetTexture(select(3, GetSpellInfo(115308)))
	Icon3.Count = Icon3:CreateFontString(nil, "OVERLAY")
	Icon3.Count:SetFont(DB.Font[1], DB.Font[2] + 6, DB.Font[3])
	Icon3.Count:SetPoint("CENTER")

	-- Guard
	Icon2:SetSize(C.Auras.IconSize, C.Auras.IconSize)
	Icon2:SetPoint("RIGHT", Icon3, "LEFT", -4, 0)
	B.CreateIF(Icon2, true)
	Icon2.Icon:SetTexture(select(3, GetSpellInfo(115295)))
	Icon2.Text = Icon2:CreateFontString(nil, "OVERLAY")
	Icon2.Text:SetFont(DB.Font[1], DB.Font[2] + 2, DB.Font[3])
	Icon2.Text:SetPoint("CENTER")

	-- Shuffle
	Icon1:SetSize(C.Auras.IconSize, C.Auras.IconSize)
	Icon1:SetPoint("RIGHT", Icon2, "LEFT", -4, 0)
	B.CreateIF(Icon1, true)
	Icon1.Icon:SetTexture(select(3, GetSpellInfo(115307)))
	
	-- Ox Statue
	Statue:SetSize(C.Auras.IconSize*3/4, C.Auras.IconSize*3/4)
	Statue:SetPoint("TOPLEFT", f.Bar, "BOTTOMLEFT", 1, -3)
	B.CreateIF(Statue, true)
	Statue.Icon:SetTexture(select(3, GetSpellInfo(115069)))
	Statue:SetAttribute("*type*", "macro")
	Statue:SetAttribute("macrotext", "/click TotemFrameTotem1 RightButton")

	f.Mover = B.Mover(f.Bar, TOGGLE, "Stagger", C.Auras.StaggerPos, 140, 20)
	SlashCmdList["STAGGER"] = function(msg)
		if msg:lower() == "reset" then
			wipe(NDuiDB["Stagger"])
			ReloadUI()
		else
			if f.Mover:IsVisible() then
				f.Mover:Hide()
			else
				f.Mover:Show()
			end
		end
	end
	SLASH_STAGGER1 = "/sb"
end

-- Event
f:RegisterUnitEvent("UNIT_AURA", "player")
f:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_MAXHEALTH")
f:RegisterEvent("PLAYER_TOTEM_UPDATE")
f:SetScript("OnEvent", function()
	if not NDuiDB["Stagger"]["Enable"] then return end
	if not f.styled then
		StaggerGo()
		f.styled = true
	end
	if f.styled then
		if GetSpecialization() == 1 then
			f:Show()
			Icon1:Show()
			Icon2:Show()
			Icon3:Show()
			Statue:Show()

			-- Stagger
			do
				local Total, Per
				local name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, value = UnitAura("player", GetSpellInfo(124275), "", "HARMFUL")
				if (not name) then name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, value = UnitAura("player", GetSpellInfo(124274), "", "HARMFUL") end
				if (not name) then name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, value = UnitAura("player", GetSpellInfo(124273), "", "HARMFUL") end
				if name and value > 0 and duration > 0 then
					Total = value * math.floor(duration)
					Per = Total / UnitHealthMax("player") * 100
					f:SetAlpha(1)
					f.Icon:SetTexture(icon)
					f.CD:SetCooldown(expire - 10, 10)
				else
					value = 0
					Per = 0
					f:SetAlpha(0.3)
					f.Icon:SetTexture(select(3, GetSpellInfo(124275)))
					f.CD:SetCooldown(0, 0)
				end
				f.Bar:SetMinMaxValues(0, 100)
				f.Bar:SetValue(Per)
				f.Text:SetText(DB.InfoColor..B.Numb(value).." "..DB.MyColor..B.Numb(Per).."%")
				if UnitAura("player", GetSpellInfo(124273), "", "HARMFUL") then
					ActionButton_ShowOverlayGlow(f)
				else
					ActionButton_HideOverlayGlow(f)
				end
			end

			-- Shuffle
			do
				local name, _, _, _, _, dur, exp = UnitBuff("player", GetSpellInfo(115307))
				if exp then
					Icon1:SetAlpha(1)
					Icon1.CD:SetCooldown(exp - dur, dur)
					B.CreateAT(Icon1, name)
				else
					Icon1:SetAlpha(0.3)
					Icon1.CD:SetCooldown(0, 0)
				end
			end

			-- Guard
			do
				local name, _, _, _, _, dur, exp, _, _, _, _, _, _, _, value  = UnitBuff("player", GetSpellInfo(115295))
				if value and value > 0 then
					Icon2:SetAlpha(1)
					--Icon2.CD:SetCooldown(exp - dur, dur)
					Icon2.Text:SetText(B.Numb(value))
					B.CreateAT(Icon2, name, "ANCHOR_RIGHT")
				else
					Icon2:SetAlpha(0.3)
					--Icon2.CD:SetCooldown(0, 0)
					Icon2.Text:SetText("")
				end
			end

			-- Elusive Brew
			do
				local name1, _, _, _, _, dur, exp = UnitBuff("player", GetSpellInfo(115308))
				local name2, _, _, count = UnitBuff("player", GetSpellInfo(128939))
				if name1 then
					Icon3:SetAlpha(1)
					Icon3.CD:SetCooldown(exp - dur, dur)
					Icon3.Count:SetText(nil)
					B.CreateAT(Icon3, name1)
				elseif name2 then
					Icon3:SetAlpha(1)
					Icon3.CD:SetCooldown(0,0)
					Icon3.Count:SetText(count)
					B.CreateAT(Icon3, name2)
				else
					Icon3:SetAlpha(0.3)
					Icon3.Count:SetText("")
				end
				if count and count == 15 then
					ActionButton_ShowOverlayGlow(Icon3)
				else
					ActionButton_HideOverlayGlow(Icon3)
				end
			end

			-- Ox Statue
			do
				local haveStatue, name, start, dur = GetTotemInfo(1)
				if haveStatue and dur > 0 then
					Statue:SetAlpha(1)
					Statue.CD:SetCooldown(start, dur)
				else
					Statue:SetAlpha(0.3)
					Statue.CD:SetCooldown(0, 0)
				end			
				Statue:SetScript("OnEnter", function(self)
					GameTooltip:Hide()
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
					GameTooltip:ClearLines()
					GameTooltip:SetTotem(1)
					GameTooltip:Show()
				end)
				Statue:SetScript("OnLeave", GameTooltip_Hide)
			end
		else
			f:Hide()
			Icon1:Hide()
			Icon2:Hide()
			Icon3:Hide()
			Statue:Hide()
		end
	end
end)
function Testhehe()
	local n1 =GetSpellInfo(128939)
	local n2 =GetSpellInfo(115308)
	if n1 == n2 then
		print("true")
	else
		print("xxx")
	end
end