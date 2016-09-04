local B, C, L, DB = unpack(select(2, ...))

--[[
	NDui Scripts, 各种代码杂烩
]]
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
SLASH_Archaeology1 = "/ar"

-- ALT+RightClick to buy a stack
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local cache = {}
function MerchantItemButton_OnModifiedClick(self, ...)
	if IsAltKeyDown() then
		local id = self:GetID()
		local itemLink = GetMerchantItemLink(id)
		if not itemLink then return end
		local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
		if ( maxStack and maxStack > 1 ) then
			if not cache[itemLink] then
				StaticPopupDialogs["BUY_STACK"] = {
					text = NDUI_MSG_BUY_STACK,
					button1 = YES,
					button2 = NO,
					OnAccept = function()
						BuyMerchantItem(id, GetMerchantItemMaxStack(id))
						cache[itemLink] = true
					end,
					hideOnEscape = 1,
					hasItemFrame = 1,
				}
				local r, g, b = GetItemQualityColor(quality or 1)
				StaticPopup_Show("BUY_STACK", "", "", {["texture"] = texture, ["name"] = name, ["color"] = {r, g, b, 1}, ["link"] = itemLink, ["index"] = id, ["count"] = maxStack})
			else
				BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			end
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
	[ERR_OUT_OF_SOUL_SHARDS] = true,
	[ERR_OUT_OF_ARCANE_CHARGES] = true,
	[ERR_OUT_OF_COMBO_POINTS] = true,
	[ERR_OUT_OF_CHI] = true,
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
erHide:RegisterEvent("UI_ERROR_MESSAGE")
erHide:SetScript("OnEvent", function(self, event, _, error)
	if not NDuiDB["Misc"]["HideErrors"] then return end
	if InCombatLockdown() and erList[error] then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
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

-- Drag AltPowerbar
PlayerPowerBarAlt:SetMovable(true)
PlayerPowerBarAlt:SetClampedToScreen(true)
PlayerPowerBarAlt:SetScript("OnMouseDown", function(self)
	if IsShiftKeyDown() then self:StartMoving() end
end)
PlayerPowerBarAlt:SetScript("OnMouseUp", function(self)
	self:StopMovingOrSizing()
end)
PlayerPowerBarAlt:HookScript("OnEnter", function(self)
	GameTooltip:AddLine(DB.InfoColor..NDUI_MSG_HOLD_SHIFT)
end)

-- Autoequip in Spec-changing
local au = CreateFrame("Frame")
au:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
au:SetScript("OnEvent", function(self, event, arg1, _, _, _, arg2)
	if not NDuiDB["Misc"]["Autoequip"] then
		self:UnregisterAllEvents()
		return
	end
	if arg1 ~= "player" or arg2 ~= 200749 then return end
	local _, _, id = GetInstanceInfo()
	if id == 8 then return end

	if not GetSpecialization() then return end
	local _, name = GetSpecializationInfo(GetSpecialization())
	if name and GetEquipmentSetInfoByName(name) then
		UseEquipmentSet(name)
		print(format(DB.InfoColor..EQUIPMENT_SETS, name))
	else
		for i = 1, GetNumEquipmentSets() do
			local name, _, _, isEquipped = GetEquipmentSetInfo(i)
			if isEquipped then
				print(format(DB.InfoColor..EQUIPMENT_SETS, name))
				break
			end
		end
	end
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
	if not NDuiDB["Misc"]["Screenshot"] then return end
	TakeScreen(1, Screenshot)
end)

-- RC in MasterSound
local rc = CreateFrame("Frame")
rc:RegisterEvent("READY_CHECK")
rc:SetScript("OnEvent", function()
	PlaySound("ReadyCheck", "master")
end)

-- Faster Looting
local tDelay = 0
local function FastLoot()
	if not NDuiDB["Misc"]["FasterLoot"] then return end
	if GetTime() - tDelay >= 0.3 then
		tDelay = GetTime()
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			tDelay = GetTime()
		end
	end
end
local faster = CreateFrame("Frame")
faster:RegisterEvent("LOOT_READY")
faster:SetScript("OnEvent", FastLoot)

-- Hide TalkingFrame
local function NoTalkingHeads(self)
	hooksecurefunc(TalkingHeadFrame, "Show", function(self)
		self:Hide()
	end)
	self:UnregisterAllEvents()
end

local talking = CreateFrame("Frame")
talking:RegisterEvent("ADDON_LOADED")
talking:RegisterEvent("PLAYER_ENTERING_WORLD")
talking:SetScript("OnEvent", function(self, event, arg1)
	if not NDuiDB["Misc"]["HideTalking"] then
		self:UnregisterAllEvents()
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
			NoTalkingHeads(self)
		end
	elseif event == "ADDON_LOADED" and arg1 == "Blizzard_TalkingHeadUI" then
		NoTalkingHeads(self)
	end
end)

-- Extend Instance
local extend = CreateFrame("Button", nil, RaidInfoFrame)
extend:SetPoint("TOPRIGHT", -35, -5)
extend:SetSize(25, 25)
B.CreateIF(extend, true)
extend.Icon:SetTexture(select(3,GetSpellInfo(80353)))
B.CreateGT(extend, NDUI_MSG_EXTENDALL, true)

extend:SetScript("OnMouseUp", function(_, btn)
	for i = 1, GetNumSavedInstances() do
		local _, _, _, _, _, extended, _, isRaid = GetSavedInstanceInfo(i)
		if isRaid then
			if btn == "LeftButton" then
				if not extended then
					SetSavedInstanceExtend(i, true)		-- extend
				end
			else
				if extended then
					SetSavedInstanceExtend(i, false)	-- cancel
				end
			end
		end
	end
	RequestRaidInfo()
	RaidInfoFrame_Update()
end)