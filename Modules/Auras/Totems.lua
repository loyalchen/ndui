local B, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "SHAMAN" then return end

-- Style
local Totems, totem = CreateFrame("Frame", nil, UIParent), {}
local icons = {
	[1] = 120217, -- Fire
	[2] = 120218, -- Earth
	[3] = 120214, -- Water
	[4] = 120219, -- Air
}

local function TotemsGo()
	Totems:SetSize(C.Auras.IconSize, C.Auras.IconSize)
	for i = 1, 4 do
		totem[i] = CreateFrame("Frame", nil, Totems)
		totem[i]:SetSize(C.Auras.IconSize, C.Auras.IconSize)
		if i == 1 then
			totem[i]:SetPoint("CENTER", Totems)
		else
			totem[i]:SetPoint("LEFT", totem[i-1], "RIGHT", 5, 0)
		end
		B.CreateIF(totem[i], true)
		totem[i].Icon:SetTexture(select(3, GetSpellInfo(icons[i])))
		totem[i]:SetAlpha(0.3)
	end
	Totems.Mover = B.Mover(Totems, TOGGLE, "Totems", C.Auras.TotemsPos, 140, 32)
	SlashCmdList["TOTEMS"] = function(msg)
		if msg:lower() == "reset" then
			wipe(NDuiDB["Totems"])
			ReloadUI()
		else
			if Totems.Mover:IsVisible() then
				Totems.Mover:Hide()
			else
				Totems.Mover:Show()
			end
		end
	end
	SLASH_TOTEMS1 = "/sb"
end

-- Function
Totems:RegisterEvent("PLAYER_ENTERING_WORLD")
Totems:RegisterEvent("PLAYER_TOTEM_UPDATE")
Totems:SetScript("OnEvent", function(self, event)
	if not NDuiDB["Totems"]["Enable"] then return end
	if not self.styled then
		TotemsGo()
		self.styled = true
	end
	if self.styled then
		for slot = 1, 4 do
			local haveTotem, name, start, dur, icon = GetTotemInfo(slot)
			local id = select(7, GetSpellInfo(name))
			local Totem = totem[slot]
			if haveTotem and dur > 0 then
				Totem:SetAlpha(1)
				Totem.Icon:SetTexture(icon)
				Totem.CD:SetCooldown(start, dur)
			else
				Totem:SetAlpha(0.3)
				Totem.Icon:SetTexture(select(3, GetSpellInfo(icons[slot])))
				Totem.CD:SetCooldown(0, 0)
			end
			Totem:SetScript("OnEnter", function(self)
				GameTooltip:Hide()
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
				GameTooltip:ClearLines()
				GameTooltip:SetSpellByID(id or icons[slot])
				GameTooltip:Show()
			end)
			Totem:SetScript("OnLeave", GameTooltip_Hide)
			Totem:SetScript("OnUpdate", function(self, elapsed)
				local Time = start + dur - GetTime()
				if Time > 0 and Time < 0.8 then
					ActionButton_ShowOverlayGlow(Totem)
				else
					ActionButton_HideOverlayGlow(Totem)
				end
			end)
		end
	end
end)