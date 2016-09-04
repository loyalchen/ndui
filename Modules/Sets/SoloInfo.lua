--[[
	SoloInfo是一个告知你当前副本难度的小工具，防止我有时候单刷时进错难度了。
	instList左侧是副本ID，你可以使用"/getid"命令来获取当前副本的ID；右侧的是副本难度，常用的一般是：2为5H，4为25普通，6为25H。
]]
local B, C, L, DB = unpack(select(2, ...))

local instList = {
	[556] = 2,		-- 塞塔克大厅，乌鸦
	[575] = 2,		-- 乌特加德之巅，蓝龙
	[585] = 2,		-- 魔导师平台，白鸡
	[603] = 4,		-- 奥杜尔，飞机头
	[631] = 6,		-- 冰冠堡垒，无敌
}

local f = CreateFrame("Frame")
f:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
f:SetSize(150, 70)
f:Hide()
B.CreateBD(f)
B.CreateTex(f)
f.Text = f:CreateFontString(nil, "OVERLAY")
f.Text:SetFont(unpack(DB.Font))
f.Text:SetPoint("CENTER", f)

f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	if not NDuiDB["Sets"]["SoloInfo"] then return end
	local name, _, instType, diffname, _, _, _, id = GetInstanceInfo()
	if IsInInstance() then
		if instList[id] and instList[id] ~= instType then
			f:Show()
			f.Text:SetText(DB.InfoColor..name..DB.MyColor.."\n("..diffname..")\n\n"..DB.InfoColor..NDUI_MSG_WRONG_INSTANCE)
		else
			f:Hide()
		end
	else
		f:Hide()
	end

	SlashCmdList['INSTANCEID'] = function()
		print(id)
	end
	SLASH_INSTANCEID1 = '/getid'
end)
f:SetScript("OnMouseUp", function()
	f:Hide()
end)