local B, C, L, DB = unpack(select(2, ...))
if not C.Chat.Enable then return end

local chatFrame = SELECTED_DOCK_FRAME
local editBox = chatFrame.editBox
local cfg = C.Chat.Chatbar
local bw, bh, bs = cfg.Width, cfg.Height, cfg.Spacing

-- style
local SetChatbar = function(f, r, g, b)
	f:SetSize(bw, bh)
	f.Tex = f:CreateTexture(nil, "ARTWORK")
	f.Tex:SetTexture(DB.normTex)
	f.Tex:SetVertexColor(r, g, b)
	f.Tex:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
	f.Tex:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	f.HL = f:CreateTexture(nil, "HIGHLIGHT")
	f.HL:SetTexture(1,1,1,0.35)
	f.HL:SetAllPoints(f.Tex)
end

-- create buttons
local Chatbar = CreateFrame("Frame", nil, UIParent)
Chatbar:SetSize(bw, bh)
Chatbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 7)
local bars = {}
for i = 1, 7 do
	bars[i] = CreateFrame("Button", nil, Chatbar, "SecureActionButtonTemplate")
	if i == 1 then
		bars[i]:SetPoint("LEFT", Chatbar)
	else
		bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", bs, 0)
	end
	bars[i]:RegisterForClicks("AnyUp")
	B.CreateSD(bars[i], 1, 3)
end

-- SAY/YELL
bars[1]:SetScript("OnClick", function(self, btn)
	if btn == "RightButton" then
		ChatFrame_OpenChat("/y ", chatFrame)
	else
		ChatFrame_OpenChat("/s ", chatFrame)
	end
end)
SetChatbar(bars[1], 1, 1, 1)

-- WHIPSER
bars[2]:SetScript("OnClick", function(self, btn)
	if btn == "RightButton" then   
		ChatFrame_ReplyTell(chatFrame)
		if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
			ChatFrame_OpenChat("/w ", chatFrame)
		end
	else   
		if(UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player") == GetDefaultLanguage("target") )then
			local name = GetUnitName("target", true)
			ChatFrame_OpenChat("/w "..name.." ", chatFrame)
		else
			ChatFrame_OpenChat("/w ", chatFrame)
		end
	end
end)
SetChatbar(bars[2], 1, 0.5, 1)

-- INSTANCE/PARTY
bars[3]:SetScript("OnClick", function(self, btn)
	ChatFrame_OpenChat("/p ", chatFrame)
end)
SetChatbar(bars[3], 0.65, 0.65, 1)

-- RAID
bars[4]:SetScript("OnClick", function(self, btn)
	if IsPartyLFG() then
		ChatFrame_OpenChat("/i ", chatFrame)
	else
		ChatFrame_OpenChat("/raid ", chatFrame)
	end
end)
SetChatbar(bars[4], 1, 0.5, 0)

-- OFFICER/GUILD
bars[5]:SetScript("OnClick", function(self, btn)
	if btn == "RightButton" and CanEditOfficerNote() then
		ChatFrame_OpenChat("/o ", chatFrame)
	else
		ChatFrame_OpenChat("/g ", chatFrame)
	end
end)
SetChatbar(bars[5], 0.25, 1, 0.25)

-- ROLL
bars[6]:SetAttribute("*type*", "macro")
bars[6]:SetAttribute("macrotext", "/roll")
SetChatbar(bars[6], 0.8, 1, 0.6)
B.CreateFS(bars[6], 12, "R")

-- COMBATLOG
bars[7]:SetAttribute("*type*", "macro")
bars[7]:SetAttribute("macrotext", "/combatlog")
SetChatbar(bars[7], 1, 1, 0)
B.CreateFS(bars[7], 12, "C")

-- WORLD CHANNEL
if GetLocale() ~= "zhTW" and GetLocale() ~= "zhCN" then return end
local wc = CreateFrame("Button", nil, Chatbar)
wc:SetPoint("LEFT", bars[7], "RIGHT", bs, 0)
SetChatbar(wc, 1, 0.1, 0.1)
B.CreateSD(wc, 1, 3)
B.CreateFS(wc, 12, "W")
wc:RegisterEvent("PLAYER_LOGIN")
wc:RegisterEvent("CHANNEL_UI_UPDATE")
wc:SetScript("OnEvent", function()
	local channels, wcname, inWorldChannel, order = {GetChannelList()}, WORLD_CHANNEL_NAME
	for i = 1, #channels do
		if channels[i] == wcname then
			inWorldChannel = true
			order = channels[i-1]
		end
	end
	if inWorldChannel then
		wc.Tex:SetVertexColor(0.1, 0.1, 1)
	else
		wc.Tex:SetVertexColor(1, 0.1, 0.1)
	end
	wc:SetScript("OnMouseUp", function(self, btn)
		if inWorldChannel then
			if btn == "RightButton" then
				LeaveChannelByName(wcname)
				print("|cffFF7F50"..QUIT.."|r "..DB.InfoColor..WORLD_CHANNEL)
				inWorldChannel = false
			else
				ChatFrame_OpenChat("/"..order, chatFrame)
			end
		else
			JoinPermanentChannel(wcname,nil,1)
			ChatFrame_AddChannel(ChatFrame1,wcname)
			print("|cff00C957"..JOIN.."|r "..DB.InfoColor..WORLD_CHANNEL)
			inWorldChannel = true
		end
	end)
end)