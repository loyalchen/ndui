local B, C, L, DB = unpack(select(2, ...))
if GetLocale() ~= "zhCN" then return end

local hx = {
	[1] = "更新支持6.2；",
	[2] = "Skada更新；",
	[3] = "Aurora调整；",
	[4] = "控制台调整；",
	[5] = "技能监视列表更新；",
	[6] = "地图全亮添加塔纳安丛林。",
}

local function changelog()
	local f = CreateFrame("Frame", "NDuiChangeLog", UIParent)
	f:SetPoint("CENTER")
	f:SetSize(320, 180)		-- EDIT @HERE
	f:SetScale(1.2)
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.CreateBD(f)
	B.CreateTex(f)
	B.CreateFS(f, 30, "NDui", "TOPLEFT", 10, 25)
	B.CreateFS(f, 14, DB.Version, "TOPLEFT", 70, 12)
	B.CreateFS(f, 16, CHANGE_LOG, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, f)
	ll:SetPoint("TOP", -51, -35)
	B.CreateGF(ll, 100, 1, "Horizontal", 0, 0, 0, 0, 0.7)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, f)
	lr:SetPoint("TOP", 51, -35)
	B.CreateGF(lr, 100, 1, "Horizontal", 0, 0, 0, 0.7, 0)
	lr:SetFrameStrata("HIGH")
	for n, t in pairs(hx) do
		B.CreateFS(f, 12, n..": "..t, "TOPLEFT", 15, -(50+20*(n-1)), true)
	end
	local close = CreateFrame("Button", nil, f)
	close:SetPoint("TOPRIGHT", -10, -10)
	close:SetSize(20, 20)
	B.CreateBD(close, 0.3)
	B.CreateFS(close, 12, "X")
	B.CreateBC(close)
	close:SetScript("OnClick", function(self) f:Hide() end)
end

local cl = CreateFrame("Frame")
cl:RegisterEvent("PLAYER_ENTERING_WORLD")
cl:SetScript("OnEvent", function()
	cl:UnregisterEvent("PLAYER_ENTERING_WORLD")
	NDuiADB["Changelog"] = NDuiADB["Changelog"] or {}
	if (not HelloWorld) and NDuiADB["Changelog"].Version ~= DB.Version then
		changelog()
		NDuiADB["Changelog"].Version = DB.Version
		-- ADD NEW GUI OPTIONS HERE
		NDuiDB["Sets"]["TradeTab"] = true
	end
end)

SlashCmdList["NDUICHANGELOG"] = function()
	if not NDuiChangeLog then changelog() else NDuiChangeLog:Show() end
end
SLASH_NDUICHANGELOG1 = '/ncl'