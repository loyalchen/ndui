--------------------------
-- NDui Default Settings
--------------------------
local B, C, L, DB = unpack(select(2, ...))
print("|cff0080ff< NDui >|cff70C0F5----------------")
print("|cff00ff00  WoD|c00ffff00 "..DB.Version.." |c0000ff00"..NDUI_MSG_LOAD_1)
print("|c0000ff00  "..NDUI_MSG_LOAD_2.."|c00ffff00 /ndui |c0000ff00"..NDUI_MSG_LOAD_3)
print("|cff70C0F5------------------------")

-- Tuitorial
local ForceDefaultSettings = function()
	--if(NDuiDB) then table.wipe(NDuiDB) end
	SetCVar("showTutorials", 0)
	SetCVar("buffDurations", 1)
	SetCVar("consolidateBuffs", 0)
	SetCVar("autoLootDefault", 1)
	SetCVar("alwaysCompareItems", 0)
	SetCVar("lootUnderMouse", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("bloattest", 0)
	SetCVar("bloatthreat", 0)
	SetCVar("threatWarning", 3)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("screenshotQuality", 10)
	SetCVar("showTutorials", 0)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("lockActionBars", 1)
	SetCVar("countdownForCooldowns", 0)
end

local ForceUIScale = function()
	SetCVar("useUiScale", 1)
	local scale = 0.8*768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
	if scale < 0.64 then
		UIParent:SetScale(scale)
	else
		SetCVar("uiScale", scale)
	end
end

local ForceChatSettings = function()
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 28)
	ChatFrame1:SetWidth(380)
	ChatFrame1:SetHeight(190)
    ChatFrame1:SetUserPlaced(true)
	for i= 1, 10 do
		local cf = _G["ChatFrame"..i]
		FCF_SetWindowAlpha(cf, 0)
		ChatFrame_RemoveMessageGroup(cf,"CHANNEL")
	end
	local channels = {"SAY","EMOTE","YELL","GUILD","OFFICER","GUILD_ACHIEVEMENT","ACHIEVEMENT",
	"WHISPER","PARTY","PARTY_LEADER","RAID","RAID_LEADER","RAID_WARNING","INSTANCE_CHAT",
	"INSTANCE_CHAT_LEADER","CHANNEL1","CHANNEL2","CHANNEL3","CHANNEL4","CHANNEL5","CHANNEL6","CHANNEL7",
	}	
	for i, v in ipairs(channels) do
		ToggleChatColorNamesByClassGroup(true, v)
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, true)
end

StaticPopupDialogs["QUIT_TUTORIAL"] = {
	text = NDUI_MSG_QUIT_TUTORIAL,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		NDui_Tutorial:Hide()
	end,
}

StaticPopupDialogs["RELOAD_NDUI"] = {
	text = NDUI_MSG_RELOAD_UI,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		ReloadUI()
	end,
}

-- DBM bars	
local ForceDBMOptions = function()
	if not IsAddOnLoaded("DBM-Core") then return end
	if(DBT_AllPersistentOptions) then table.wipe(DBT_AllPersistentOptions) end
	DBT_AllPersistentOptions = {
		["Default"] = {
			["DBM"] = {
				["Scale"] = 1,
				["HugeScale"] = 1,
				["ExpandUpwards"] = true,
				["BarXOffset"] = 0,
				["BarYOffset"] = 15,
				["TimerPoint"] = "LEFT",
				["TimerX"] = 117.7955598588925,
				["TimerY"] = -114.8654337879873,
				["Width"] = 175,
				["Heigh"] = 20,
				["HugeWidth"] = 210,
				["HugeBarXOffset"] = 0,
				["HugeBarYOffset"] = 15,
				["HugeTimerPoint"] = "CENTER",
				["HugeTimerX"] = 14.86061168014081,
				["HugeTimerY"] = -120,
				["FontSize"] = 10,
				["StartColorR"] = 1,
				["StartColorG"] = 0.7019607843137254,
				["StartColorB"] = 0,
				["EndColorR"] = 1,
				["EndColorG"] = 0,
				["EndColorB"] = 0,
				["Texture"] = DB.normTex,
			},
		},
	}
end

-- Skada
local ForceSkadaOptions = function()
	if not IsAddOnLoaded("Skada") then return end
	if(SkadaDB) then table.wipe(SkadaDB) end
	SkadaDB = {
		["hasUpgraded"] = true,
		["profiles"] = {
			["Default"] = {
				["windows"] = {
					{
						["barheight"] = 18,
						["classicons"] = false,
						["barslocked"] = true,
						["y"] = 24,
						["x"] = -5,
						["title"] = {
							["color"] = {
								["a"] = 0.3,
								["b"] = 0,
								["g"] = 0,
								["r"] = 0,
							},
							["font"] = "",
							["borderthickness"] = 0,
							["fontsize"] = 14,
							["texture"] = "normTex",
						},
						["point"] = "BOTTOMRIGHT",
						["mode"] = "",
						["barwidth"] = 300,
						["barbgcolor"] = {
							["a"] = 0,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["barfontsize"] = 16,
						["background"] = {
							["height"] = 180,
							["texture"] = "None",
						},
						["bartexture"] = "normTex",
					}, -- [1]
				},
				["icon"] = {
					["hide"] = true,
				},
				["tooltiprows"] = 10,
				["setstokeep"] = 30,
				["tooltippos"] = "topleft",
				["reset"] = {
					["join"] = 1,
				},
			},
		},
	}
end

local function gogogo()
	if not NDui_Tutorial then
		local f = CreateFrame("Frame", "NDui_Tutorial")
		f:SetPoint("CENTER")
		f:SetSize(250, 200)
		f:SetFrameStrata("HIGH")
		B.CreateMF(f)
		B.CreateBD(f)
		B.CreateTex(f)
		f.Logo = B.CreateFS(f, 30, "NDui", "TOPLEFT", 10, 25)

		f.Close = CreateFrame("Button", nil, f)
		f.Close:SetPoint("TOPRIGHT", -5, -5)
		f.Close:SetSize(20, 20)
		B.CreateBD(f.Close, 0.3)
		B.CreateFS(f.Close, 12, "X")
		B.CreateBC(f.Close)
		f.Close:SetScript("OnClick", function() StaticPopup_Show("QUIT_TUTORIAL") end)
		
		f.Title = f:CreateFontString(nil, "OVERLAY")
		f.Title:SetFont(unpack(DB.Font))
		f.Title:SetPoint("TOP", 0, -10)

		local ll = CreateFrame("Frame", nil, f)
		ll:SetPoint("TOP", -41, -32)
		B.CreateGF(ll, 80, .5, "Horizontal", .7, .7, .7, 0, 0.7)
		ll:SetFrameStrata("HIGH")
		local lr = CreateFrame("Frame", nil, f)
		lr:SetPoint("TOP", 41, -32)
		B.CreateGF(lr, 80, .5, "Horizontal", .7, .7, .7, 0.7, 0)
		lr:SetFrameStrata("HIGH")

		f.Body = f:CreateFontString(nil, "OVERLAY")
		f.Body:SetFont(unpack(DB.Font))
		f.Body:SetPoint("TOPLEFT", 10, -50)
		f.Body:SetPoint("BOTTOMRIGHT", -10, 50)
		f.Body:SetJustifyV("TOP")
		f.Body:SetJustifyH("LEFT")

		f.Foot = f:CreateFontString(nil, "OVERLAY")
		f.Foot:SetFont(unpack(DB.Font))
		f.Foot:SetPoint("BOTTOM", 0, 10)

		f.Load = CreateFrame("Button", "NDui_Load", f)
		f.Load:SetPoint("BOTTOMRIGHT", -10, 10)
		f.Load:SetSize(50, 20)
		B.CreateBD(f.Load, 0.3)
		B.CreateFS(f.Load, 12, APPLY)
		B.CreateBC(f.Load)

		f.Pass = CreateFrame("Button", "NDui_Pass", f)
		f.Pass:SetPoint("BOTTOMLEFT", 10, 10)
		f.Pass:SetSize(50, 20)
		B.CreateBD(f.Pass, 0.3)
		B.CreateFS(f.Pass, 12, SKIP)
		B.CreateBC(f.Pass)

		f.Direc = CreateFrame("Button", "NDui_Direc", f)
		f.Direc:SetPoint("BOTTOM", 0, 40)
		f.Direc:SetSize(80, 20)
		B.CreateBD(f.Direc, 0.3)
		B.CreateFS(f.Direc, 12, NDUI_MSG_PASS_IT)
		B.CreateBC(f.Direc)
		f.Direc:SetScript("OnClick", function()
			NDui_Tutorial:Hide()
			ForceDefaultSettings()
			ForceUIScale()
			ForceChatSettings()
			ForceDBMOptions()
			ForceSkadaOptions()
			StaticPopup_Show("RELOAD_NDUI")
		end)
	end
	NDui_Tutorial:Show()

	local function page5()
		NDui_Tutorial.Title:SetText(DB.InfoColor..NDUI_MSG_TIPS)
		NDui_Tutorial.Body:SetText(NDUI_TUTOR_PAGE_5)
		NDui_Tutorial.Foot:SetText("5/5")
		NDui_Load:SetScript("OnClick", function()
			NDui_Tutorial:Hide()
			StaticPopup_Show("RELOAD_NDUI")
		end)
		NDui_Pass:SetScript("OnClick", function() StaticPopup_Show("QUIT_TUTORIAL") end)
	end	
	local function page4()
		NDui_Tutorial.Title:SetText(DB.InfoColor..ADDONS..SETTINGS)
		NDui_Tutorial.Body:SetText(NDUI_TUTOR_PAGE_4)
		NDui_Tutorial.Foot:SetText("4/5")
		NDui_Load:SetScript("OnClick", function()
			PlaySound("igQuestLogOpen")
			ForceDBMOptions()
			ForceSkadaOptions()
			UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_MSG_ADDONS_SUCCEED)
			page5()
		end)
		NDui_Pass:SetScript("OnClick", function() page5() PlaySound("igQuestLogOpen") end)
	end	
	local function page3()
		NDui_Tutorial.Title:SetText(DB.InfoColor..CHAT)
		NDui_Tutorial.Body:SetText(NDUI_TUTOR_PAGE_3)
		NDui_Tutorial.Foot:SetText("3/5")
		NDui_Load:SetScript("OnClick", function()
			PlaySound("igQuestLogOpen")
			ForceChatSettings()
			UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_MSG_CHAT_SETTINGS_SUCCEED)
			page4()
		end)
		NDui_Pass:SetScript("OnClick", function() page4() PlaySound("igQuestLogOpen") end)
	end	
	local function page2()
		NDui_Tutorial.Title:SetText(DB.InfoColor..UI_SCALE)
		NDui_Tutorial.Body:SetText(NDUI_TUTOR_PAGE_2)
		NDui_Tutorial.Foot:SetText("2/5")
		NDui_Load:SetScript("OnClick", function()
			PlaySound("igQuestLogOpen")
			ForceUIScale()
			UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_MSG_UI_SCALE_SUCCEED)
			page3()
		end)
		NDui_Pass:SetScript("OnClick", function() page3() PlaySound("igQuestLogOpen") end)
	end	
	local function page1()
		NDui_Tutorial.Title:SetText(DB.InfoColor..SETTINGS..GUIDE)
		NDui_Tutorial.Body:SetText(NDUI_TUTOR_PAGE_1)
		NDui_Tutorial.Foot:SetText("1/5")
		NDui_Load:SetScript("OnClick", function()
			PlaySound("igQuestLogOpen")
			ForceDefaultSettings()
			UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_MSG_DEFAULT_SETTINGS_SUCCEED)
			page2()
		end)
		NDui_Pass:SetScript("OnClick", function() page2() PlaySound("igQuestLogOpen") end)
	end
	page1()
end

local function HelloWorld()
	local c1, c2 = "|c00FFFF00", "|c0000FF00"
	local welcome = CreateFrame("Frame", "HelloWorld", UIParent)
	welcome:SetPoint("CENTER")
	welcome:SetSize(300, 400)
	welcome:SetScale(1.2)
	welcome:SetFrameStrata("HIGH")
	B.CreateMF(welcome)
	B.CreateBD(welcome)
	B.CreateTex(welcome)
	B.CreateFS(welcome, 30, "NDui", "TOPLEFT", 10, 25)
	B.CreateFS(welcome, 14, DB.Version, "TOPLEFT", 70, 12)
	B.CreateFS(welcome, 16, NDUI_HELP_LINE_TITLE, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, welcome)
	ll:SetPoint("TOP", -51, -35)
	B.CreateGF(ll, 100, .5, "Horizontal", .7, .7, .7, 0, .7)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, welcome)
	lr:SetPoint("TOP", 51, -35)
	B.CreateGF(lr, 100, .5, "Horizontal", .7, .7, .7, .7, 0)
	lr:SetFrameStrata("HIGH")
	B.CreateFS(welcome, 12, NDUI_HELP_LINE_1, "TOPLEFT", 20, -50, true)
	B.CreateFS(welcome, 12, NDUI_HELP_LINE_2, "TOPLEFT", 20, -70, true)
	B.CreateFS(welcome, 12, c1.." /ab "..c2..NDUI_HELP_LINE_3, "TOPLEFT", 20, -100, true)
	B.CreateFS(welcome, 12, c1.." /ar "..c2..NDUI_HELP_LINE_4, "TOPLEFT", 20, -120, true)
	B.CreateFS(welcome, 12, c1.." /aw "..c2..NDUI_HELP_LINE_5, "TOPLEFT", 20, -140, true)
	B.CreateFS(welcome, 12, c1.." /hb "..c2..NDUI_HELP_LINE_6, "TOPLEFT", 20, -160, true)
	B.CreateFS(welcome, 12, c1.." /omf "..c2..NDUI_HELP_LINE_7, "TOPLEFT", 20, -180, true)
	B.CreateFS(welcome, 12, c1.." /rl "..c2..NDUI_HELP_LINE_8, "TOPLEFT", 20, -200, true)
	B.CreateFS(welcome, 12, c1.." /rm "..c2..NDUI_HELP_LINE_9, "TOPLEFT", 20, -220, true)
	B.CreateFS(welcome, 12, c1.." /sb "..c2..NDUI_HELP_LINE_10, "TOPLEFT", 20, -240, true)
	B.CreateFS(welcome, 12, c1.." /ncl "..c2..NDUI_HELP_LINE_11, "TOPLEFT", 20, -260, true)
	B.CreateFS(welcome, 12, c1.." /ndui "..c2..NDUI_HELP_LINE_12, "TOPLEFT", 20, -280, true)
	B.CreateFS(welcome, 12, NDUI_HELP_LINE_13, "TOPLEFT", 20, -310, true)
	B.CreateFS(welcome, 12, NDUI_HELP_LINE_14, "TOPLEFT", 20, -330, true)
	local close = CreateFrame("Button", nil, welcome)
	close:SetPoint("TOPRIGHT", -10, -10)
	close:SetSize(20, 20)
	B.CreateBD(close, 0.3)
	B.CreateFS(close, 12, "X")
	B.CreateBC(close)
	close:SetScript("OnClick", function(self) welcome:Hide() end)
	local tutor = CreateFrame("Button", nil, welcome)
	tutor:SetPoint("BOTTOM", 0, 10)
	tutor:SetSize(100, 20)
	B.CreateBD(tutor, 0.3)
	B.CreateFS(tutor, 12, SETTINGS..GUIDE)
	B.CreateBC(tutor)
	tutor:SetScript("OnClick", function(self) welcome:Hide() gogogo() end)
end
local ndui = CreateFrame("Frame")
ndui:RegisterEvent("PLAYER_ENTERING_WORLD")
ndui:SetScript("OnEvent", function()
	ndui:UnregisterEvent("PLAYER_ENTERING_WORLD")
	NDuiDB["Tutorial"] = NDuiDB["Tutorial"] or {}
	if not NDuiDB["Tutorial"].Shown then
		HelloWorld()
		NDuiDB["Tutorial"].Shown = true
	end
end)
SlashCmdList["NDUI"] = function()
	if not welcome then HelloWorld() else welcome:Show() end
end
SLASH_NDUI1 = '/ndui'