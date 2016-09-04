-----------------------------------
-- NDui Sripts
-----------------------------------
local B, C, L, DB = unpack(select(2, ...))
if not NDuiDB["Sets"] then NDuiDB["Sets"] = {} end

-- Archaeology counts
SlashCmdList["Archaeology"] = function()
	print("|cff0080ff【NDui】".."|c0000FF00"..INTRO..":")
	local ta = 0
	for x = 1, 15 do
		local c = GetNumArtifactsByRace(x)
		local a = 0
		for y = 1, c do
			local t = select(9, GetArtifactInfoByRace(x, y))
			a = a + t
		end
		local rn = GetArchaeologyRaceInfo(x)
		if (c > 1) then
			print("     * |cfffed100"..rn..": ".."|cff70C0F5"..a)
			ta = ta + a
		end 
	end
	print("    -> |c0000ff00"..TOTAL..": ".."|cffff0000"..ta);
end
SLASH_Archaeology1= '/ar'

-- ALT+RightClick to buy a stack
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local itemLink = GetMerchantItemLink(self:GetID())
		if not itemLink then return end
		local maxStack = select(8, GetItemInfo(itemLink))
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end

-- Hide errors in combat
local erList = {
	[ERR_ABILITY_COOLDOWN] = true,
	[ERR_ATTACK_MOUNTED] = true,
	[ERR_OUT_OF_ENERGY] = true,
	[ERR_OUT_OF_FOCUS] = true,
	[ERR_OUT_OF_HEALTH] = true,
	[ERR_OUT_OF_MANA] = true,
	[ERR_OUT_OF_RAGE] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_OUT_OF_RUNES] = true,
	[ERR_OUT_OF_HOLY_POWER] = true,
	[ERR_OUT_OF_RUNIC_POWER] = true,
	[ERR_OUT_OF_SHADOW_ORBS] = true,
	[ERR_OUT_OF_SOUL_SHARDS] = true,
	[ERR_OUT_OF_ARCANE_CHARGES] = true,
	[ERR_OUT_OF_BALANCE_NEGATIVE] = true,
	[ERR_OUT_OF_BALANCE_POSITIVE] = true,
	[ERR_OUT_OF_BURNING_EMBERS] = true,
	[ERR_OUT_OF_COMBO_POINTS] = true,
	[ERR_OUT_OF_DARK_FORCE] = true,
	[ERR_OUT_OF_DEMONIC_FURY] = true,
	[ERR_OUT_OF_CHI] = true,
	[ERR_OUT_OF_LIGHT_FORCE] = true,
	[ERR_OUT_OF_POWER_DISPLAY] = true,
	[ERR_SPELL_COOLDOWN] = true,
	[ERR_ITEM_COOLDOWN] = true,
	[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = true,
	[SPELL_FAILED_BAD_TARGETS] = true,
	[SPELL_FAILED_CASTER_AURASTATE] = true,
	[SPELL_FAILED_NO_COMBO_POINTS] = true,
	[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
	[SPELL_FAILED_TARGET_AURASTATE] = true,
}
local erHide = CreateFrame("Frame")
erHide:RegisterEvent("PLAYER_REGEN_DISABLED")
erHide:RegisterEvent("PLAYER_REGEN_ENABLED")
erHide:RegisterEvent("UI_ERROR_MESSAGE")
erHide:SetScript("OnEvent", function(self, event, error)
	if not NDuiDB["Sets"]["HideErrors"] then return end
	if event == "PLAYER_REGEN_DISABLED" then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	elseif event == "PLAYER_REGEN_ENABLED" then
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
	end
	if(not erList[error]) and InCombatLockdown() then
		UIErrorsFrame:AddMessage(error, 1, .1, .1)
	end
end)

-- Autoinvite by whisper
local f = CreateFrame("frame")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("CHAT_MSG_BN_WHISPER")
f:SetScript("OnEvent", function(self,event,arg1,arg2,_,_,_,_,_,_,_,_,_,_,arg3)
	if (not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and arg1:lower():match(C.Sets.Keyword) then
        if event == "CHAT_MSG_BN_WHISPER" then
			BNInviteFriend(arg3)
		else
			InviteUnit(arg2)
		end
    end
end)

-- Helm/Cloak quick check
local hcheck = CreateFrame("CheckButton", "HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
hcheck:SetSize(26, 26)
hcheck:SetHitRectInsets(0, 0, 0, 0)
hcheck:SetPoint("LEFT", CharacterHeadSlot, "RIGHT", 5, 0)
hcheck:SetScript("OnClick", function () ShowHelm(not ShowingHelm()) end)
hcheck:SetScript("OnEnter", function ()
 	GameTooltip:SetOwner(hcheck, "ANCHOR_RIGHT")
	GameTooltip:SetText(SHOW_HELM)
end)
hcheck:SetScript("OnLeave", function () GameTooltip:Hide() end)
hcheck:SetFrameStrata("HIGH")

local ccheck = CreateFrame("CheckButton", "CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
ccheck:SetSize(26, 26)
ccheck:SetHitRectInsets(0, 0, 0, 0)
ccheck:SetPoint("LEFT", CharacterBackSlot, "RIGHT", 5, 0)
ccheck:SetScript("OnClick", function () ShowCloak(not ShowingCloak()) end)
ccheck:SetScript("OnEnter", function ()
	GameTooltip:SetOwner(ccheck, "ANCHOR_RIGHT")
	GameTooltip:SetText(SHOW_CLOAK)
end)
ccheck:SetScript("OnLeave", function () GameTooltip:Hide() end)
ccheck:SetFrameStrata("HIGH")
hcheck:SetChecked(ShowingHelm())
ccheck:SetChecked(ShowingCloak())
B.CreateCB(HelmCheckBox)
B.CreateCB(CloakCheckBox)
hooksecurefunc("ShowHelm", function(v) hcheck:SetChecked(v) end)
hooksecurefunc("ShowCloak", function(v)	ccheck:SetChecked(v) end)

-- Be able to say "FUCK"
local sVars = CreateFrame("Frame")
sVars:RegisterEvent("PLAYER_LOGIN")
sVars:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_LOGIN")
	if not NDuiDB["Sets"]["Freedom"] then
		BNSetMatureLanguageFilter(true)
	else
		BNSetMatureLanguageFilter(false)
	end
end)


-- Show BID and highlight price
hooksecurefunc("AuctionFrame_LoadUI", function()
	if AuctionFrameBrowse_Update then
		hooksecurefunc("AuctionFrameBrowse_Update", function()
			local numBatchAuctions = GetNumAuctionItems("list")
			local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
			for i=1, NUM_BROWSE_TO_DISPLAY do
				local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
				if index <= numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page) then
					local name, _, count, _, _, _, _, _, _, buyoutPrice, bidAmount =  GetAuctionItemInfo("list", offset + i)
					local alpha = 0.5
					local color = "yellow"
					if name then
						local itemName = _G["BrowseButton"..i.."Name"]
						local moneyFrame = _G["BrowseButton"..i.."MoneyFrame"]
						local buyoutMoney = _G["BrowseButton"..i.."BuyoutFrameMoney"]
						if (buyoutPrice/10000) >= 5000 then color = "red" end
						if bidAmount > 0 then
							name = name .. " |cffffff00"..BID.."|r"
							alpha = 1.0
						end
						itemName:SetText(name)
						moneyFrame:SetAlpha(alpha)
						SetMoneyFrameColor(buyoutMoney:GetName(), color)
					end
				end
			end
		end)
	end
end)

-- Countdown for fire
local frame = CreateFrame("frame", nil)
SlashCmdList['COUNTDOWN'] = function(newtime)
    if newtime ~= "" then
        cdtime = newtime + 1
    else
        cdtime = 7
    end
    local ending = false
    local start = floor(GetTime())
    local throttle = cdtime
    frame:SetScript("OnUpdate", function()
        if ending == true then return end
        local countdown = (start - floor(GetTime()) + cdtime)
        if (countdown + 1) == throttle and countdown >= 0 then
            if countdown == 0 then
                SendChatMessage(NDUI_MSG_FIRE, (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) and IsInRaid() and "RAID_WARNING" or "SAY")
                throttle = countdown
                ending = true
            else
                SendChatMessage(countdown, (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) and IsInRaid() and "RAID_WARNING" or "SAY")
                throttle = countdown
            end
        end
    end)
end
SLASH_COUNTDOWN1 = "/cd"

-- Rare notification
local rare = CreateFrame("Frame", nil, UIParent)
rare:RegisterEvent("VIGNETTE_ADDED")
rare.cache = {}
rare:SetScript("OnEvent",function(self, event, id)
	if not NDuiDB["Sets"]["RareAlerter"] then return end
	if id and not self.cache[id] then
		local _, _, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
		local left, right, top, bottom = GetObjectIconTextureCoords(icon)
		local tex = "|TInterface\\MINIMAP\\OBJECTICONS:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
		UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_MSG_RARE..tex..name)
		PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
		self.cache[id] = true
	end
end)


-- Drag AltPowerbar
PlayerPowerBarAlt:SetMovable(true)
PlayerPowerBarAlt:SetUserPlaced(true)
PlayerPowerBarAlt:SetClampedToScreen(true)
PlayerPowerBarAlt:SetScript("OnMouseDown", function(self)
	if IsShiftKeyDown() then self:StartMoving() end
end)
PlayerPowerBarAlt:SetScript('OnMouseUp', function(self)
	self:StopMovingOrSizing()
end)
PlayerPowerBarAlt:HookScript("OnEnter", function(self)
	GameTooltip:AddLine(DB.InfoColor..NDUI_MSG_HOLD_SHIFT)
end)

-- Autoequip in Spec-changing
local au = CreateFrame("Frame")
au:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
au:SetScript("OnEvent", function()
	if not NDuiDB["Sets"]["Autoequip"] then return end
	if not GetSpecialization() then return end
	local _, name = GetSpecializationInfo(GetSpecialization())
	if name then UseEquipmentSet(name) end
end)

-- Auto screenshot when achieved
local function TakeScreen(delay, func, ...)
	local waitTable = {}
	local waitFrame = CreateFrame("Frame", nil, UIParent)
	waitFrame:SetScript("OnUpdate", function(self, elapse)
		local count = #waitTable
		local i = 1
		while (i <= count) do
			local waitRecord = tremove(waitTable, i)
			local d = tremove(waitRecord, 1)
			local f = tremove(waitRecord, 1)
			local p = tremove(waitRecord, 1)
			if (d > elapse) then
				tinsert(waitTable, i, {d-elapse, f, p})
				i = i + 1
			else
				count = count - 1
				f(unpack(p))
			end
		end
	end)
	tinsert(waitTable, {delay, func, {...}})
end
local AchScreen = CreateFrame("Frame")
AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
AchScreen:SetScript("OnEvent", function()
	if not NDuiDB["Sets"]["Screenshot"] then return end
	TakeScreen(1, Screenshot)
end)

-- Master sound for rc
local rc = CreateFrame("Frame")
rc:RegisterEvent("READY_CHECK")
rc:SetScript("OnEvent", function()
	PlaySound("ReadyCheck", "master")
end)