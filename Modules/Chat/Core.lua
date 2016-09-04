local B, C, L, DB = unpack(select(2, ...))
if not C.Chat.Enable then return end
-----------------------------
-- INIT rChat, zork
-- NDui Mod
-----------------------------
FCF_FadeInChatFrame = function(self)
	self.hasBeenFaded = true
end

FCF_FadeOutChatFrame = function(self)
	self.hasBeenFaded = false
end

FCFTab_UpdateColors = function(self, selected)
	if (selected) then
		self:SetAlpha(1)
		self:GetFontString():SetTextColor(unpack(C.Chat.TabColor1))
		self.leftSelectedTexture:Show()
		self.middleSelectedTexture:Show()
		self.rightSelectedTexture:Show()
	else
		self:GetFontString():SetTextColor(unpack(C.Chat.TabColor2))
		self:SetAlpha(0.3)
		self.leftSelectedTexture:Hide()
		self.middleSelectedTexture:Hide()
		self.rightSelectedTexture:Hide()
	end
end

for i = 1, 23 do
	CHAT_FONT_HEIGHTS[i] = i + 7
end

ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
ChatFrameMenuButton:Hide()
FriendsMicroButton:HookScript("OnShow", FriendsMicroButton.Hide)
FriendsMicroButton:Hide()

BNToastFrame:SetClampedToScreen(true)
BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 25)
end)

ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 16, "0")
ChatFontNormal:SetShadowOffset(1, -1)
ChatFontNormal:SetShadowColor(0, 0, 0, 0.6)

-----------------------------
-- FUNCTIONS
-----------------------------
local function skinChat(self)
	if not self or (self and self.skinApplied) then return end

	local name = self:GetName()
		self:SetClampRectInsets(0, 0, 0, 0)
		self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
		self:SetMinResize(100, 50)
		self:SetFont(STANDARD_TEXT_FONT, 14, "0")
		self:SetShadowOffset(1,-1)
		self:SetShadowColor(0,0,0,0.6)

	local frame = _G[name.."ButtonFrame"]
		frame:Hide()
		frame:HookScript("OnShow", frame.Hide)
		_G[name.."EditBoxLeft"]:Hide()
		_G[name.."EditBoxMid"]:Hide()
		_G[name.."EditBoxRight"]:Hide()
	
	local eb = _G[name.."EditBox"]
		eb:SetAltArrowKeyMode(false)
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOM",self,"TOP",0,22)
		eb:SetPoint("LEFT",self,-5,0)
		eb:SetPoint("RIGHT",self,10,0)

	local tab = _G[name.."Tab"]
	local tabFs = tab:GetFontString()
		tabFs:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
		tabFs:SetShadowOffset(1,-1)
		tabFs:SetShadowColor(0,0,0,0.6)
		tabFs:SetTextColor(unpack(C.Chat.TabColor1))
	if C.Chat.HideTabBG then
		_G[name.."TabLeft"]:SetTexture(nil)
		_G[name.."TabMiddle"]:SetTexture(nil)
		_G[name.."TabRight"]:SetTexture(nil)
		_G[name.."TabSelectedLeft"]:SetTexture(nil)
		_G[name.."TabSelectedMiddle"]:SetTexture(nil)
		_G[name.."TabSelectedRight"]:SetTexture(nil)
		_G[name.."TabHighlightLeft"]:SetTexture(nil)
		_G[name.."TabHighlightMiddle"]:SetTexture(nil)
		_G[name.."TabHighlightRight"]:SetTexture(nil)
	end
	tab:SetAlpha(1)

	self.skinApplied = true
end

-----------------------------
-- CALL
-----------------------------
for i = 1, NUM_CHAT_WINDOWS do
	skinChat(_G["ChatFrame"..i])
end

hooksecurefunc("FCF_OpenTemporaryWindow", function()
	for _, chatFrameName in pairs(CHAT_FRAMES) do
		local frame = _G[chatFrameName]
		if (frame.isTemporary) then
			skinChat(frame)
		end
	end
end)

-- Timestamps
do
	ChatFrame2ButtonFrameBottomButton:RegisterEvent("PLAYER_LOGIN")
	ChatFrame2ButtonFrameBottomButton:SetScript("OnEvent", function(f)
		TIMESTAMP_FORMAT_HHMM = DB.GreyColor.."[%I:%M]|r "
		TIMESTAMP_FORMAT_HHMMSS = DB.GreyColor.."[%I:%M:%S]|r "
		TIMESTAMP_FORMAT_HHMMSS_24HR = DB.GreyColor.."[%H:%M:%S]|r "
		TIMESTAMP_FORMAT_HHMMSS_AMPM = DB.GreyColor.."[%I:%M:%S %p]|r "
		TIMESTAMP_FORMAT_HHMM_24HR = DB.GreyColor.."[%H:%M]|r "
		TIMESTAMP_FORMAT_HHMM_AMPM = DB.GreyColor.."[%I:%M %p]|r "
		f:UnregisterEvent("PLAYER_LOGIN")
		f:SetScript("OnEvent", nil)
	end)
end

-- Swith channels by Tab
local cycles = {
	{ chatType = "SAY", use = function(self, editbox) return 1 end},
    { chatType = "PARTY", use = function(self, editbox) return IsInGroup() end},
    { chatType = "RAID", use = function(self, editbox) return IsInRaid() end},
    { chatType = "INSTANCE_CHAT", use = function(self, editbox) return IsPartyLFG() end},
    { chatType = "GUILD", use = function(self, editbox) return IsInGuild() end},
    --{ chatType = "OFFICER", use = function(self, editbox) return CanEditOfficerNote() end},
    { chatType = "SAY", use = function(self, editbox) return 1 end},
}

function ChatEdit_CustomTabPressed(self)
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
    local currChatType = self:GetAttribute("chatType")
    for i, curr in ipairs(cycles) do
        if curr.chatType == currChatType then
            local h, r, step = i+1, #cycles, 1
            if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
            for j = h, r, step do
                if cycles[j]:use(self, currChatType) then
                    self:SetAttribute("chatType", cycles[j].chatType)
                    ChatEdit_UpdateHeader(self)
                    return
                end
            end
        end
    end
end

-- Quick Scroll
FloatingChatFrame_OnMouseScroll = function(self, dir)
	if(dir > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	else
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end

-- combatlogframe
local function fixStuffOnLogin()
	for i = 1, NUM_CHAT_WINDOWS do
		local name = "ChatFrame"..i
		local tab = _G[name.."Tab"]
		tab:SetAlpha(1)
	end
	CombatLogQuickButtonFrame_Custom:HookScript("OnShow", CombatLogQuickButtonFrame_Custom.Hide)
	CombatLogQuickButtonFrame_Custom:Hide()
	CombatLogQuickButtonFrame_Custom:SetHeight(0)

	-- Sticky
	if not NDuiDB["Chat"]["Sticky"] then
		ChatTypeInfo["WHISPER"].sticky = 0
		ChatTypeInfo["BN_WHISPER"].sticky = 0
	end
end

local a = CreateFrame("Frame")
a:RegisterEvent("PLAYER_LOGIN")
a:SetScript("OnEvent", fixStuffOnLogin)