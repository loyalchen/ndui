local B, C, L, DB = unpack(select(2, ...))

--[[
	SoloInfo是一个告知你当前副本难度的小工具，防止我有时候单刷时进错难度了。
	instList左侧是副本ID，你可以使用"/getid"命令来获取当前副本的ID；右侧的是副本难度，常用的一般是：2为5H，4为25普通，6为25H。
]]
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
	if not NDuiDB["Misc"]["SoloInfo"] then return end
	local name, _, instType, diffname, _, _, _, id = GetInstanceInfo()
	if IsInInstance() and instType ~= 24 then
		if instList[id] and instList[id] ~= instType then
			f:Show()
			f.Text:SetText(DB.InfoColor..name..DB.MyColor.."\n( "..diffname.." )\n\n"..DB.InfoColor..NDUI_MSG_WRONG_INSTANCE)
		else
			f:Hide()
		end
	else
		f:Hide()
	end
end)
f:SetScript("OnMouseUp", function()
	f:Hide()
end)

--[[
	谁动了我的橙戒！
	简易通报谁使用橙戒的插件。
]]
local ringID = {
	[187616] = NDUI_ALERT_DPS,
	[187617] = NDUI_ALERT_TANK,
	[187618] = NDUI_ALERT_HEALER,
	[187619] = NDUI_ALERT_DPS,
	[187620] = NDUI_ALERT_DPS,
}
local ring = CreateFrame("Frame")
ring:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ring:SetScript("OnEvent", function(self, event, ...)
	if not NDuiDB["Misc"]["RingAlerter"] then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		return
	end
	if UnitIsDeadOrGhost("player") then return end
	local _, type, _, _, sourceName, _, _, _, _, _, _, _, name = ...
	if UnitInRaid(sourceName) and type == "SPELL_CAST_SUCCESS" then
		for key, value in pairs(ringID) do
			if name == GetSpellInfo(key) then
				SendChatMessage(format(ACTION_SPELL_CAST_SUCCESS_FULL_TEXT_NO_DEST, sourceName, value), "SAY")
			end
		end
	end
end)

--[[
	发现稀有/事件时的通报插件
]]
local rare = CreateFrame("Frame")
rare:RegisterEvent("VIGNETTE_ADDED")
rare.cache = {}
rare:SetScript("OnEvent", function(self, event, id)
	if not NDuiDB["Misc"]["RareAlerter"] then return end
	if id and not self.cache[id] then
		local _, _, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
		local left, right, top, bottom = GetObjectIconTextureCoords(icon)
		local tex = "|TInterface\\Minimap\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
		UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_MSG_RARE..tex..(name or ""))
		if NDuiDB["Misc"]["AlertinChat"] then
			print("  -> "..DB.InfoColor..NDUI_MSG_RARE..tex..(name or ""))
		end
		PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
		self.cache[id] = true
	end
end)