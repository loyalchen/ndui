local B, C, L, DB = unpack(select(2, ...))

--[[
	一个简易的邮箱插件，修改自OpenAll
]]
local function MailLoad()
	local takingOnlyCash, onlyCurrentMail = false, false
	local deletedelay, t, mailIndex, mailItemIndex = 0.5, 0, 1, 0
	local button1, button2, button3, lastopened, imOrig_InboxFrame_OnClick, hasNewMail, needsToWait, candelete, dbtn

	InboxNextPageButton:SetScript("OnClick", function()
		mailIndex = mailIndex + 1
		InboxNextPage()
	end)
	InboxPrevPageButton:SetScript("OnClick", function()
		mailIndex = mailIndex - 1
		InboxPrevPage()
	end)

	for i = 1, 7 do
		local mailBoxButton = _G["MailItem"..i.."Button"]
		mailBoxButton:SetScript("OnClick", function(self)
			mailItemIndex = 7 * (mailIndex - 1) + tonumber(string.sub(self:GetName(), 9, 9))
			local modifiedClick = IsModifiedClick("MAILAUTOLOOTTOGGLE")
			if ( modifiedClick ) then
				InboxFrame_OnModifiedClick(self, self.index)
			else
				InboxFrame_OnClick(self, self.index)
			end
		end)
	end

	function doNothing() end

	function OpenAll()
		if (GetInboxNumItems() == 0) then return end
		button1:SetScript("OnClick", nil)
		button2:SetScript("OnClick", nil)
		button3:SetScript("OnClick", nil)
		imOrig_InboxFrame_OnClick = InboxFrame_OnClick
		InboxFrame_OnClick = doNothing
		if (onlyCurrentMail) then
			button3:RegisterEvent("UI_ERROR_MESSAGE")
			OpenMail(button3, mailItemIndex)
		else
			button1:RegisterEvent("UI_ERROR_MESSAGE")
			OpenMail(button1, GetInboxNumItems())
		end
	end

	function OpenMail(button, index)
		if (not InboxFrame:IsVisible() or index == 0) then
			return StopOpening()
		end
		local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(index)
		if (money > 0) then
			TakeInboxMoney(index)
			needsToWait = true
		elseif (not takingOnlyCash and numItems and numItems > 0 and COD <= 0) then
			TakeInboxItem(index)
			needsToWait = true
		elseif (not takingOnlyCash and InboxItemCanDelete(index)) then
			DeleteInboxItem(index)
			needsToWait = true
		end

		local items = GetInboxNumItems()
		if ((numItems and numItems > 0) or (not onlyCurrentMail and items > 1 and index <= items)) then
			lastopened = index
			button:SetScript("OnUpdate", WaitForMail)
		else
			StopOpening()
		end
	end

	function WaitForMail(self, arg1)
		t = t + arg1
		if (not needsToWait) or (t > deletedelay) then
			t = 0
			needsToWait = false
			self:SetScript("OnUpdate", nil)

			local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(lastopened)
			if (money > 0 or (not takingOnlyCash and numItems and numItems > 0 and COD <= 0)) then
				OpenMail(self, lastopened)
			else
				OpenMail(self, lastopened - 1)
			end
		end
	end

	function StopOpening()
		button1:SetScript("OnUpdate", nil)
		button1:SetScript("OnClick", function() onlyCurrentMail = false OpenAll() end)
		button2:SetScript("OnClick", function() takingOnlyCash = true OpenAll() end)
		button3:SetScript("OnUpdate", nil)
		button3:SetScript("OnClick", function() onlyCurrentMail = true OpenAll() end)
		if (imOrig_InboxFrame_OnClick) then
			InboxFrame_OnClick = imOrig_InboxFrame_OnClick
		end
		if (onlyCurrentMail) then
			button3:UnregisterEvent("UI_ERROR_MESSAGE")
		else
			button1:UnregisterEvent("UI_ERROR_MESSAGE")
		end
		takingOnlyCash = false
		onlyCurrentMail = false
		needsToWait = false
	end

	function OpenAll_OnEvent(frame, event, arg1, arg2, arg3, arg4)
		if (event == "UI_ERROR_MESSAGE") then
			if (arg1 == ERR_INV_FULL) then
				StopOpening()
			end
		elseif (event == "MAIL_CLOSED") then
			if (not hasNewMail) then
				MiniMapMailFrame:Hide()
			end
		end
	end

	function TotalCash_OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local total_cash = 0
		for index = 0, GetInboxNumItems() do
			total_cash = total_cash + select(5, GetInboxHeaderInfo(index))
		end
		if total_cash > 0 then SetTooltipMoney(GameTooltip, total_cash)	end
		GameTooltip:Show()
	end

	function CreatButton(id, parent, text, w, h, ap, frame, rp, x, y)
		local button = CreateFrame("Button", id, parent, "UIPanelButtonTemplate")
		button:SetWidth(w)
		button:SetHeight(h)
		button:SetPoint(ap, frame, rp, x, y)
		button:SetText(text)
		return button
	end

	button1 = CreatButton("OpenAllButton1", InboxFrame, COLLECT_ALL, 100, 28, "CENTER", "InboxFrame","TOP", -70, -50)
	button1:RegisterEvent("MAIL_CLOSED")
	button1:SetScript("OnClick", OpenAll)
	button1:SetScript("OnEvent", OpenAll_OnEvent)

	button2 = CreatButton("OpenAllButton2", InboxFrame, COLLECT_GOLD, 100, 28, "CENTER", "InboxFrame","TOP", 70, -50)
	button2:SetScript("OnClick", function() takingOnlyCash = true OpenAll() end)
	button2:SetScript("OnEnter", TotalCash_OnEnter)
	button2:SetScript("OnUpdate", function(self) if GameTooltip:IsOwned(self) then TotalCash_OnEnter(self) end end)
	button2:SetScript("OnLeave", function()	GameTooltip:Hide() end)

	button3 = CreatButton("OpenAllButton3", OpenMailFrame, COLLECT_LETTER, 86, 22, "RIGHT", "OpenMailReplyButton","LEFT", 0, 0)
	button3:SetScript("OnClick", function() onlyCurrentMail = true OpenAll() end)
	button3:SetScript("OnEvent", OpenAll_OnEvent)

	local function deleteClick(self, button, down)
		selectedID = self.id + (InboxFrame.pageNum-1)*7
		if InboxItemCanDelete(selectedID) then
			DeleteInboxItem(selectedID)
		else
			UIErrorsFrame:AddMessage(DB.InfoColor..ERR_MAIL_DELETE_ITEM_ERROR)
		end
	end

	hooksecurefunc("InboxFrame_Update", function()
		hasNewMail = false
		if (select(4, GetInboxHeaderInfo(1))) then
			for i = 1, GetInboxNumItems() do
				local wasRead = select(9, GetInboxHeaderInfo(i))
				if (not wasRead) then
					hasNewMail = true
					break
				end
			end
		end

		for i = 1, 7 do
			local b = _G["MailItem"..i.."ExpireTime"]
			if not b.delete then
				b.delete = CreateFrame("BUTTON", nil, b)
				b.delete:SetPoint("TOPRIGHT", b, "BOTTOMRIGHT", -5, -1)
				b.delete:SetWidth(16)
				b.delete:SetHeight(16)
				b.delete.texture = b.delete:CreateTexture(nil, "BACKGROUND")
				b.delete.texture:SetAllPoints()
				b.delete.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
				b.delete.texture:SetTexCoord(1, 0, 0, 1)
				b.delete.id = i
				b.delete:SetScript("OnClick", deleteClick)
				B.CreateGT(b.delete, DELETE)
			end
		end
	end)

	hooksecurefunc("InboxFrameItem_OnEnter", function(self)
		local tooltip = GameTooltip
		local items = {}
		wipe(items)
		local itemAttached = select(8, GetInboxHeaderInfo(self.index))
		if itemAttached then
			local itemName, itemTexture, itemCount, itemQuality, itemid, r, g, b
			for attachID = 1, 12 do
				itemName, _, _, itemCount = GetInboxItem(self.index, attachID)
				if itemCount and itemCount > 0 then
					_, itemid = strsplit(":", GetInboxItemLink(self.index, attachID))
					itemid = tonumber(itemid)
					items[itemid] = (items[itemid] or 0) + itemCount
				end
			end
			if itemAttached > 1 then
				tooltip:AddLine("|n"..ATTACH_LIST)
				for key, value in pairs(items) do
					itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(key)
					r, g, b = GetItemQualityColor(itemQuality)
					tooltip:AddDoubleLine("  |T"..itemTexture..":0|t "..itemName, value, r, g, b)
				end
				tooltip:Show()
			end
		end
	end)

	-- Replace the alert frame
	if InboxTooMuchMail then
		InboxTooMuchMail:ClearAllPoints()
		InboxTooMuchMail:SetPoint("BOTTOM", MailFrame, "TOP", 0, 5)
	end

	-- Aurora Reskin
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.Reskin(OpenAllButton1)
		F.Reskin(OpenAllButton2)
		F.Reskin(OpenAllButton3)
	end
end

local ml = CreateFrame("Frame")
ml:RegisterEvent("PLAYER_LOGIN")
ml:SetScript("OnEvent", function()
	if not NDuiDB["Misc"]["Mail"] then return end
	MailLoad()
end)