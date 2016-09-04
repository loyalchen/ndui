local addon, ns = ...
local cfg = ns.cfg
local init = ns.init
local panel = CreateFrame("Frame", nil, UIParent)

if cfg.Gold == true then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = panel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(unpack(cfg.Fonts))
	Text:SetPoint(unpack(cfg.GoldPoint))

	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0

	local function formatMoney(money)
		local gold = floor(math.abs(money) / 10000)
		local silver = mod(floor(math.abs(money) / 100), 100)
		local copper = mod(floor(math.abs(money)), 100)
		if gold ~= 0 then
			return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
		elseif silver ~= 0 then
			return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
		else
			return format("%s".."|cffeda55fc|r", copper)
		end
	end
	
	local function formatTextMoney(money)
		return format("%.0f|cffffd700%s|r", money * 0.0001, GOLD_AMOUNT_SYMBOL)
	end

	local function FormatTooltipMoney(money)
		local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
		local cash = ""
		cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)
		return cash
	end	

	local function OnEvent(self, event)
		if (diminfo.AutoSell == nil) then diminfo.AutoSell = true end
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney > NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Moeny
			Profit = Profit + Change
		end
		
		Text:SetText(formatTextMoney(NewMoney))
		-- Setup Money Tooltip
		self:SetAllPoints(Text)

		local myPlayerRealm = GetRealmName()
		local myPlayerName  = UnitName("player")	
		if (diminfo.gold == nil) then diminfo.gold = {} end
		if (diminfo.gold[myPlayerRealm]==nil) then diminfo.gold[myPlayerRealm]={} end
		diminfo.gold[myPlayerRealm][myPlayerName] = GetMoney()
		
		self:SetScript("OnEnter", function()
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(CURRENCY,0,.6,1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(infoL["Session"]..": ",.6,.8,1)
			GameTooltip:AddDoubleLine(infoL["Earned:"], formatMoney(Profit), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(infoL["Spent:"], formatMoney(Spent), 1, 1, 1, 1, 1, 1)
			if Profit < Spent then
				GameTooltip:AddDoubleLine(infoL["Deficit:"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
			elseif (Profit-Spent)>0 then
				GameTooltip:AddDoubleLine(infoL["Profit:"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
			end
			GameTooltip:AddLine(" ")

			local totalGold = 0
			GameTooltip:AddLine(infoL["Character"]..": ",.6,.8,1)
			local thisRealmList = diminfo.gold[myPlayerRealm]
			for k, v in pairs(thisRealmList) do
				GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
				totalGold = totalGold + v
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(infoL["Server"]..": ",.6,.8,1)
			GameTooltip:AddDoubleLine(TOTAL..": ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)
			for i = 1, GetNumWatchedTokens() do
				local name, count, icon, currencyID = GetBackpackCurrencyInfo(i)
				if name and i == 1 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(CURRENCY,.6,.8,1)
				end
				if name and count then	-- add icons for currency
					local iconTexture = " |T"..icon..":12:12:0:0:64:64:4:60:4:60|t "
					GameTooltip:AddDoubleLine(name, count..iconTexture, 1, 1, 1, 1, 1, 1)
				end
			end
			GameTooltip:AddDoubleLine(" ","--------------",1,1,1,0.5,0.5,0.5)
			GameTooltip:AddDoubleLine(" ",infoL["AutoSell junk"]..": "..(diminfo.AutoSell and "|cff55ff55"..infoL["ON"] or "|cffff5555"..strupper(OFF)),1,1,1,.6,.8,1)
			GameTooltip:AddDoubleLine(" ",infoL["Reset Gold"],1,1,1,.6,.8,1)
			GameTooltip:Show()
		end)
		self:SetScript("OnLeave", GameTooltip_Hide)
		
		OldMoney = NewMoney
	end

	-- reset gold diminfo
	local function RESETGOLD()
		local myPlayerRealm = GetRealmName()
		local myPlayerName  = UnitName("player")
		diminfo.gold = {}
		diminfo.gold[myPlayerRealm]={}
		diminfo.gold[myPlayerRealm][myPlayerName] = GetMoney()
	end
	StaticPopupDialogs["RESETGOLD"] = {
		text = infoL["Are you sure to reset the gold count?"],
		button1 = YES,
		button2 = NO,
		OnAccept = RESETGOLD,
		timeout = 0,
		whileDead = 1,
	}

	Stat:RegisterEvent("PLAYER_MONEY")
	Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	Stat:RegisterEvent("PLAYER_TRADE_MONEY")
	Stat:RegisterEvent("TRADE_MONEY_CHANGED")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function(self, button)
		if IsControlKeyDown() then
			StaticPopup_Show("RESETGOLD")
		elseif button == "RightButton" then
			diminfo.AutoSell = not diminfo.AutoSell
			self:GetScript("OnEnter")(self)
		else
			ToggleCharacter("TokenFrame")
		end
	end)
	
	-- autosell junk function
	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", function()
		if diminfo.AutoSell == true then
			local c = 0
			for b = 0, 4 do
				for s = 1, GetContainerNumSlots(b) do
					local l = GetContainerItemLink(b, s)
					if l then
						local price = select(11, GetItemInfo(l))
						local _, count, _, quality = GetContainerItemInfo(b, s)
						if quality == 0 and price > 0 then
							UseContainerItem(b, s)
							PickupMerchantItem()
							c = c + price*count
						end
					end
				end
			end
			if c > 0 then
				print(format("|cff99CCFF"..infoL["Your vendor trash has been sold and you earned"].."|r|cffFFFFFF%.1f|r|cffffd700%s|r", c * 0.0001,GOLD_AMOUNT_SYMBOL))
			end
		end
	end)
	f:RegisterEvent("MERCHANT_SHOW")
	f:RegisterEvent("MERCHANT_UPDATE")
end