local B, C, L, DB = unpack(select(2, ...))

--[[
	在角色面板显示耐久度，当你低于20%时在屏幕中间提示。
]]
local SLOTIDS = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do
	SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot")
end

local function RYGColorGradient(perc)
	local relperc = perc*2 % 1
	if perc <= 0 then
		return 1, 0, 0
	elseif perc < 0.5 then
		return 1, relperc, 0
	elseif perc == 0.5 then
		return 1, 1, 0
	elseif perc < 1.0 then
		return 1 - relperc, 1, 0
	else
		return 0, 1, 0
	end
end

local fontstrings = setmetatable({}, {
	__index = function(t,i)
		local gslot = _G["Character"..i.."Slot"]
		assert(gslot, "Character"..i.."Slot does not exist")
		local fstr = B.CreateFS(gslot, DB.Font[2], "Dur")
		fstr:SetPoint("CENTER", gslot, "BOTTOM", 1, 8)
		t[i] = fstr
		return fstr
	end,
})

local onEvent = function()
	for slot, id in pairs(SLOTIDS) do
		local v1, v2 = GetInventoryItemDurability(id)

		if v1 and v2 and v2 ~= 0 then
			local str = fontstrings[slot]
			str:SetTextColor(RYGColorGradient(v1/v2))
			str:SetText(string.format("%d%%", v1/v2*100))
		else
			local str = rawget(fontstrings, slot)
			if str then str:SetText(nil) end
		end
	end
end

-- Durability informing
local dur = CreateFrame("Frame")
dur:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
dur:SetSize(200, 50)
dur:Hide()
B.CreateBD(dur)
B.CreateTex(dur)
dur.Text = dur:CreateFontString(nil, "OVERLAY")
dur.Text:SetFont(unpack(DB.Font))
dur.Text:SetPoint("CENTER", dur)

dur:RegisterEvent("PLAYER_ENTERING_WORLD")
dur:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
dur:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not NDuiDB["Misc"]["Durability"] then return end
	onEvent()

	if InCombatLockdown() then return end
	for slot, id in pairs(SLOTIDS) do
		local cur, max = GetInventoryItemDurability(id)
		if cur then
			local value = cur/max
			if value < 0.2 then
				dur:Show()
				dur.Text:SetText(DB.InfoColor..NDUI_MSG_DURABILITY)
			else
				dur:Hide()
			end
		else
			dur:Hide()
		end
	end
end)
dur:SetScript("OnMouseUp", function()
	dur:Hide()
end)