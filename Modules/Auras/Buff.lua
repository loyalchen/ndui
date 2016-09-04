local B, C, L, DB = unpack(select(2, ...))

-- main
local BuffFrame = BuffFrame
local ConsolidatedBuffs = ConsolidatedBuffs
local IconsPerRow = C.Auras.IconsPerRow

BuffFrame:ClearAllPoints()
BuffFrame:SetPoint(unpack(C.Auras.BuffPos))
BuffFrame.SetPoint = B.Dummy

ConsolidatedBuffsIcon:SetSize(C.Auras.IconSize, C.Auras.IconSize)
ConsolidatedBuffsIcon:SetTexCoord(.16, .34, .31, .69)
ConsolidatedBuffsIcon:SetPoint("TOPLEFT", ConsolidatedBuffs, 1, -1)
ConsolidatedBuffsIcon:SetPoint("BOTTOMRIGHT", ConsolidatedBuffs, -1, -1)
ConsolidatedBuffs.count:ClearAllPoints()
ConsolidatedBuffs.count:SetPoint("TOP", ConsolidatedBuffs, "TOP", 2, -2)
ConsolidatedBuffs.count:SetVertexColor(DB.cc.r, DB.cc.g, DB.cc.b)
local bg = CreateFrame("Frame", nil, ConsolidatedBuffs)
bg:SetFrameLevel(0)
bg:SetAllPoints()
B.CreateSD(bg, 3, 3)

local function Style(Button)
	if not Button or (Button and Button.styled) then return end
	local name = Button:GetName()
	local Border = _G[name.."Border"]
	if Border then Border:Hide() end

	local Icon = _G[name.."Icon"]
	Icon:SetAllPoints()
	Icon:SetTexCoord(unpack(DB.TexCoord))
	Icon:SetDrawLayer("BACKGROUND", 1)

	local Duration = _G[name.."Duration"]
	Duration:ClearAllPoints()
	Duration:SetPoint("TOP", Button, "BOTTOM", 2, 2)
	Duration:SetFont(unpack(DB.Font))

	local Count = _G[name.."Count"]
	Count:ClearAllPoints()
	Count:SetParent(Button)
	Count:SetPoint("TOPRIGHT", Button, "TOPRIGHT", -1, -3)
	Count:SetFont(unpack(DB.Font))

	Button:SetSize(C.Auras.IconSize-2, C.Auras.IconSize-2)
	Button.HL = Button:CreateTexture(nil, "HIGHLIGHT")
	Button.HL:SetTexture(1,1,1,0.35)
	Button.HL:SetAllPoints(Icon)
	B.CreateSD(Button, 3, 3, 0)
	Button.styled = true
end

local function MakeBuffFrame()
	local buff, previousBuff, aboveBuff, index
    local numBuffs = 0
    local slack = BuffFrame.numEnchants

    if ShouldShowConsolidatedBuffFrame() then
        slack = slack + 1
    end

    for i = 1, BUFF_ACTUAL_DISPLAY do
        buff = _G["BuffButton"..i]
        if not buff.consolidated then
			if not buff.styled then Style(buff) end
            numBuffs = numBuffs + 1
            index = numBuffs + slack
			buff:ClearAllPoints()
            if index > 1 and mod(index, IconsPerRow) == 1 then
                if index == IconsPerRow + 1 then
                    buff:SetPoint("TOP", ConsolidatedBuffs, "BOTTOM", 0, -12)
                else
                    buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -12)
                end
                aboveBuff = buff
            elseif index == 1 then
                buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
            else
                if numBuffs == 1 then
                    if BuffFrame.numEnchants > 0 then
                        buff:SetPoint("TOPRIGHT", "TemporaryEnchantFrame", "TOPLEFT", -C.Auras.Spacing, 0)
                    else
                        buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -C.Auras.Spacing, 0)
                    end
                else
                    buff:SetPoint("RIGHT", previousBuff, "LEFT", -C.Auras.Spacing, 0)
                end
            end
            previousBuff = buff
        end
    end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", MakeBuffFrame)

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
	local bu = _G["TempEnchant"..i]
	Style(bu)
end

for i = 1, NUM_LE_RAID_BUFF_TYPES do
	local buff = ConsolidatedBuffsTooltip["Buff"..i]
	buff.icon:SetTexCoord(unpack(DB.TexCoord))
end

hooksecurefunc("RaidBuffTray_Update", function()
	if ShouldShowConsolidatedBuffFrame() then
		for i = 1, NUM_LE_RAID_BUFF_TYPES do
			local buff = ConsolidatedBuffsTooltip["Buff"..i]
			if not buff.name then buff.icon:SetTexture("") end
		end
	end
end)

local function MakeDebuffFrame(_, i)
	local Debuff = _G["DebuffButton"..i]
	Style(Debuff)
	local Pre = _G["DebuffButton"..(i-1)]
	Debuff:ClearAllPoints()
	if i == 1 then
		Debuff:SetPoint(unpack(C.Auras.DebuffPos))
	elseif i == IconsPerRow + 1 then
		Debuff:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -10)
	elseif i < IconsPerRow*2 + 1 then
		Debuff:SetPoint("RIGHT", Pre, "LEFT", -C.Auras.Spacing, 0)
	end
end
hooksecurefunc("DebuffButton_UpdateAnchors", MakeDebuffFrame)

local function FlashOnEnd(self, elapsed)
	if self.timeLeft < 10 then
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end
hooksecurefunc("AuraButton_OnUpdate", FlashOnEnd)