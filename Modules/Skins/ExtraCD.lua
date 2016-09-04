local B, C, L, DB = unpack(select(2, ...))
if not IsAddOnLoaded("ExtraCD") then return end

local ExtraCD = ExtraCD
hooksecurefunc(ExtraCD, "CreateIcon", function(self, order, bar)
	local btn = bar.btns[order]
	local backdrop = btn:GetBackdrop()
	local icon = backdrop.bgFile

	if not btn.icon then
		btn.icon = btn:CreateTexture(nil, "BORDER")
		btn.icon:SetAllPoints()
		btn.icon:SetTexCoord(unpack(DB.TexCoord))
		btn.HL = btn:CreateTexture(nil, "HIGHLIGHT")
		btn.HL:SetTexture(1,1,1,0.35)
		btn.HL:SetAllPoints(btn.icon)
	end
	btn.icon:SetTexture(icon)
	btn:SetBackdrop(nil)
	B.CreateSD(btn, 4, 4)
end)