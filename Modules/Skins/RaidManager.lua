local B, C, L, DB = unpack(select(2, ...))

-- RM Control Panel
local function RMLoad()
	local RaidManager = CreateFrame("Frame", "RaidManager", UIParent)
	RaidManager:SetSize(200, 170)
	B.CreateBD(RaidManager)
	B.CreateTex(RaidManager)
	RaidManager.State = false

	-- RM Open Button
	local RMOpen = CreateFrame("Button", "RMOpen", UIParent)
	RMOpen:SetScript("OnClick", function() RaidManager:Show() RMOpen:Hide() RaidManager.State = true end)
	RMOpen:SetSize(120, 30)
	B.CreateBD(RMOpen)
	B.CreateFS(RMOpen, 14, NDUI_RM_TITLE)
	B.CreateBC(RMOpen, 0.5)

	-- RM Close Button
	local RMClose = CreateFrame("Button", "RMClose", RaidManager)
	RMClose:SetPoint("TOP", RaidManager, "BOTTOM", 0, 2)
	RMClose:SetScript("OnClick", function() RaidManager:Hide() RMOpen:Show() RaidManager.State = false end)
	RMClose:SetSize(40, 20)
	B.CreateBD(RMClose)
	B.CreateFS(RMClose, 14, "▲")
	B.CreateBC(RMClose, 0.5)

	-- RM Mover
	local function RaidManagerGo()
		RaidManager.Mover = B.Mover(RaidManager, TOGGLE, "RaidManager", C.Skins.RMPos, 200, 50)
		RMOpen:SetPoint("TOP", RaidManager.Mover)
		SlashCmdList["RM"] = function(msg)
			if msg:lower() == "reset" then
				wipe(NDuiDB["RaidManager"])
				ReloadUI()
			else
				if RaidManager.Mover:IsVisible() then
					RaidManager.Mover:Hide()
				else
					RaidManager.Mover:Show()
				end
			end
		end
		SLASH_RM1 = "/rm"
	end

	-- Group Disband Button
	local RMDisband = CreateFrame("Button", "RMDisband", RaidManager, "UIMenuButtonStretchTemplate")
	RMDisband:SetPoint("TOPLEFT", RaidManager, "TOPLEFT", 5, -5)
	RMDisband:SetSize(95, 25)
	B.CreateBD(RMDisband, 0.3)
	B.CreateFS(RMDisband, 12, NDUI_RM_DISBAND)
	B.CreateBC(RMDisband)
	local GroupDisband = function()
		if InCombatLockdown() then return end
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
				if online and name ~= UnitName("player") then
					UninviteUnit(name)
				end
			end
		else
			for i = MAX_PARTY_MEMBERS, 1, -1 do
				if UnitExists("party"..i) then
					UninviteUnit(UnitName("party"..i))
				end
			end
		end
		LeaveParty()
	end
	StaticPopupDialogs["Group_Disband"] = {
		text = NDUI_RM_DISBANDINFO,
		button1 = YES,
		button2 = NO,
		OnAccept = GroupDisband,
		timeout = 0,
		whileDead = 1,
	}
	RMDisband:SetScript("OnClick", function()
		StaticPopup_Show("Group_Disband")
	end)

	-- Convert Grouptype Button
	local RMConvert = CreateFrame("Button", "RMConvert", RaidManager, "UIMenuButtonStretchTemplate")
	RMConvert:SetPoint("TOPRIGHT", RaidManager, "TOPRIGHT", -5, -5)
	RMConvert:SetSize(95, 25)
	B.CreateBD(RMConvert, 0.3)
	RMConvert.Text = B.CreateFS(RMConvert, 12, "")
	B.CreateBC(RMConvert)
	RMConvert:SetScript("OnClick", function()
		if IsInRaid() then
			ConvertToParty()
		else
			ConvertToRaid()
		end
	end)

	-- Role Check Button
	local RMRole = CreateFrame("Button", "RMRole", RaidManager, "UIMenuButtonStretchTemplate")
	RMRole:SetPoint("TOP", RMDisband, "BOTTOM", 0, 0)
	RMRole:SetSize(95, 25)
	B.CreateBD(RMRole, 0.3)
	B.CreateFS(RMRole, 12, ROLE_POLL)
	B.CreateBC(RMRole)
	RMRole:SetScript("OnClick", InitiateRolePoll)

	-- Ready Check Button
	local RMReady = CreateFrame("Button", "RMReady", RaidManager, "UIMenuButtonStretchTemplate")
	RMReady:SetPoint("TOP", RMConvert, "BOTTOM", 0, 0)
	RMReady:SetSize(95, 25)
	B.CreateBD(RMReady, 0.3)
	B.CreateFS(RMReady, 12, READY_CHECK)
	B.CreateBC(RMReady)
	RMReady:SetScript("OnClick", DoReadyCheck)

	-- Target Markers
	for i = 1, 8 do
		local RMTmark = CreateFrame("Button", "RMTmarkButton"..i, RaidManager)
		RMTmark:SetSize(32, 32)
		RMTmark:SetID(i)
		if i == 1 then
			RMTmark:SetPoint("TOPLEFT", RMRole, "BOTTOMLEFT", 12, -8)
		elseif i == 5 then
			RMTmark:SetPoint("TOP", "RMTmarkButton1", "BOTTOM", 0, -10)
		else
			RMTmark:SetPoint("LEFT", "RMTmarkButton"..i-1, "RIGHT", 12, 0)
		end
		RMTmark.Tex = RMTmark:CreateTexture(RMTmark:GetName().."NormalTexture", "ARTWORK");
		RMTmark.Tex:SetTexture[[Interface\TargetingFrame\UI-RaidTargetingIcons]]
		RMTmark.Tex:SetAllPoints()
		SetRaidTargetIconTexture(RMTmark.Tex, i)
		RMTmark:RegisterForClicks("AnyUp")
		RMTmark:SetScript("OnClick", function(self, arg1)
			PlaySound("uChatScrollButton")
			SetRaidTarget("target", (arg1 ~= "RightButton") and self:GetID() or 0)
		end)
		RMTmark:SetScript("OnEnter", function(self)
			self.Tex:ClearAllPoints()
			self.Tex:SetPoint("TOPLEFT", -10, 10)
			self.Tex:SetPoint("BOTTOMRIGHT", 10, -10)
		end)
		RMTmark:SetScript("OnLeave", function(self)
			self.Tex:SetAllPoints()
		end)
		RMTmark:SetScript("OnUpdate", function(self)
			if (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
				self:Enable()
				self:SetAlpha(1)
			else
				self:Disable()
				self:SetAlpha(0.5)
			end
		end)
	end

	-- Raid Control Button
	local RMControl = CreateFrame("Button", "RMControl", RaidManager, "UIMenuButtonStretchTemplate")
	RMControl:SetPoint("BOTTOMLEFT", RaidManager, "BOTTOMLEFT", 5, 5)
	RMControl:SetSize(95, 25)
	B.CreateBD(RMControl, 0.3)
	B.CreateFS(RMControl, 12, RAID_CONTROL)
	B.CreateBC(RMControl)
	RMControl:SetScript("OnClick", function() ToggleFriendsFrame(4) end)

	-- Everyone Assist Button
	local RMEveryone = CreateFrame("Frame", "RMEveryone", RaidManager)
	RMEveryone:SetPoint("LEFT", RMControl, "RIGHT", 10, 0)
	RMEveryone:SetSize(55, 25)
	B.CreateFS(RMEveryone, 12, ALL_ASSIST_LABEL)
	RMEveryone:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(ALL_ASSIST_DESCRIPTION)
		if not RaidFrameAllAssistCheckButton:IsEnabled() then
			GameTooltip:AddLine(ALL_ASSIST_NOT_LEADER_ERROR, 1, 0, 0)
		end
		GameTooltip:Show()
	end)
	RMEveryone:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	local RMEveryoneCB = CreateFrame("CheckButton", "RMEveryoneCB", RaidManager, "OptionsCheckButtonTemplate")
	RMEveryoneCB:SetPoint("LEFT", RMEveryone, "RIGHT", 0, 0)
	B.CreateCB(RMEveryoneCB, 0.3)
	RMEveryoneCB:SetScript("OnClick", function(self)
		if self.enabled then
			PlaySound("igMainMenuOptionCheckBoxOn")
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
		end
		SetEveryoneIsAssistant(self:GetChecked())
	end)

	-- World Marker Button
	local RMWmark = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
	RMWmark:ClearAllPoints()
	RMWmark:SetPoint("RIGHT", RMOpen, "LEFT", 0, 0)
	RMWmark:SetParent(RMOpen)
	RMWmark:SetSize(30, 30)
	RMWmark:GetNormalTexture():SetVertexColor(DB.cc.r, DB.cc.g, DB.cc.b)
	RMWmark.SetNormalTexture = function() end
	RMWmark.SetPushedTexture = function() end
	B.CreateBD(RMWmark, 0.3)
	B.CreateBC(RMWmark)
	RMWmark:SetScript("OnMouseUp", function(self, btn)
		self:SetBackdropColor(0, 0, 0, 0.3)
		if btn == "RightButton" then
			ClearRaidMarker()
		end
	end)

	-- Buff Check Button
	local RMBuff = CreateFrame("Button", "RMBuff", RMOpen, "UIMenuButtonStretchTemplate")
	RMBuff:SetPoint("LEFT", RMOpen, "RIGHT", 0, 0)
	RMBuff:SetSize(30, 30)
	B.CreateBD(RMBuff)
	B.CreateFS(RMBuff, 16, "!")
	B.CreateBC(RMBuff, 0.5)
	local ScanBuff = function()
		local NoFlask, NoFood, NoStats, NoStamina, NoCrit, NoMastery, NoMulti, NoVst, NoHaste, NoAP, NoSP, NoPres = {},{},{},{},{},{},{},{},{},{},{},{}
		local numPlayer, numFlask, numFood, numStats, numStamina, numCrit, numMastery, numMulti, numVst, numHaste, numAP, numSP, numPres = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, class, zone, online, isDead = GetRaidRosterInfo(i)
			if online and zone == GetRealZoneText() and not isDead then
				numPlayer = numPlayer + 1
				local HasFlask, HasFood, HasStats, HasStamina, HasCrit, HasMastery, HasMulti, HasVst, HasHaste, HasAP, HasSP, RightPres
				local j = 1
				local unit = "raid"..i
				while UnitBuff(unit, j) do
					local buffName = UnitBuff(unit, j)
					for n = 1, 11 do
						for key, value in pairs(DB.BuffList[n]) do
							local spellName = GetSpellInfo(value)
							if string.find(buffName, spellName) then
								if n == 1 then HasFlask = true end
								if n == 2 then HasFood = true end
								if n == 3 then HasStats = true end
								if n == 4 then HasStamina = true end
								if n == 5 then HasCrit = true end
								if n == 6 then HasMastery = true end
								if n == 7 then HasMulti = true end
								if n == 8 then HasVst = true end
								if n == 9 then HasHaste = true end
								if n == 10 then HasAP = true end
								if n == 11 then HasSP = true end
							end
						end
					end
					if class == "DEATHKNIGHT" and UnitGroupRolesAssigned(unit) == "TANK" then
						local blood = GetSpellInfo(48263)
						if string.find(buffName, blood) then
							RightPres = true
						end
					else
						RightPres = true
					end
					j = j + 1
				end
				if not HasFlask then numFlask = numFlask + 1 table.insert(NoFlask, name) end
				if not HasFood then numFood = numFood + 1 table.insert(NoFood, name) end
				if not HasStats then numStats = numStats + 1 table.insert(NoStats, name) end
				if not HasStamina then numStamina = numStamina + 1 table.insert(NoStamina, name) end
				if not HasCrit then numCrit = numCrit + 1 table.insert(NoCrit, name) end
				if not HasMastery then numMastery = numMastery + 1 table.insert(NoMastery, name) end
				if not HasMulti then numMulti = numMulti + 1 table.insert(NoMulti, name) end
				if not HasVst then numVst = numVst + 1 table.insert(NoVst, name) end
				if not HasHaste then numHaste = numHaste + 1 table.insert(NoHaste, name) end
				-- Melee check
				if UnitPowerMax(unit)*5 < UnitHealthMax(unit) then
					if not HasAP then numAP = numAP + 1 table.insert(NoAP, name) end
				else
					if not HasSP then numSP = numSP + 1 table.insert(NoSP, name) end
				end
				if not RightPres then numPres = numPres + 1 table.insert(NoPres, name) end
			end
		end

		if numFlask == 0 and numFood == 0 and numStats == 0 and numStamina == 0 and numCrit == 0 and numMastery == 0
			and numMulti == 0 and numVst == 0  and numHaste == 0 and numAP == 0 and numSP == 0 and numPres == 0 then
			SendChatMessage(NDUI_RM_ALLREADY, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
		else
			SendChatMessage(NDUI_RM_BUFFCHECK, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
			if numFlask > 0 then
				if numFlask >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_FLASK..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_FLASK..": "..table.concat(NoFlask, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numFood > 0 then
				if numFood >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_FOOD..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_FOOD..": "..table.concat(NoFood, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numStats > 0 then
				if numStats >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_1..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_1..": "..table.concat(NoStats, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numStamina > 0 then
				if numStamina >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_2..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_2..": "..table.concat(NoStamina, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numCrit > 0 then
				if numCrit >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_6..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_6..": "..table.concat(NoCrit, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numMastery > 0 then
				if numMastery >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_7..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_7..": "..table.concat(NoMastery, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numMulti > 0 then
				if numMulti >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_8..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_8..": "..table.concat(NoMulti, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numVst > 0 then
				if numVst >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_9..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_9..": "..table.concat(NoVst, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numHaste > 0 then
				if numHaste >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_4..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_4..": "..table.concat(NoHaste, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numAP > 0 then
				if numAP >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_3..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_3..": "..table.concat(NoAP, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numSP > 0 then
				if numSP >= numPlayer then
					SendChatMessage(LACK..RAID_BUFF_5..": "..ALL..PLAYER, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				else
					SendChatMessage(LACK..RAID_BUFF_5..": "..table.concat(NoSP, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
				end
			end
			if numPres > 0 then
				SendChatMessage(LACK..BLOOD_PRESENCE..": "..table.concat(NoPres, ","), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
			end
		end
		-- empty cache
		table.wipe(NoFlask)
		table.wipe(NoFood)
		table.wipe(NoStats)
		table.wipe(NoStamina)
		table.wipe(NoCrit)
		table.wipe(NoMastery)
		table.wipe(NoMulti)
		table.wipe(NoVst)
		table.wipe(NoHaste)
		table.wipe(NoAP)
		table.wipe(NoSP)
	end
	RMBuff:SetScript("OnEnter", function(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(DB.InfoColor..NDUI_RM_LEFTCLICK.."\n"..NDUI_RM_SCROLLCLICK.."\n"..NDUI_RM_RIGHTCLICK)
		GameTooltip:Show()
		self:SetBackdropBorderColor(DB.cc.r, DB.cc.g, DB.cc.b, 1)
	end)
	RMBuff:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	RMBuff:RegisterForClicks("AnyUp")
	RMBuff:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			ScanBuff()
		elseif button == "LeftButton" then
			if InCombatLockdown() then return end
			DoReadyCheck()
		else
			if IsAddOnLoaded("DBM-Core") then
				SlashCmdList["DEADLYBOSSMODS"]("pull 10")
			else
				UIErrorsFrame:AddMessage(DB.InfoColor..NDUI_RM_DBM)
			end
		end
	end)

	-- Reskin Buttons
	do
		local rmbtns = {
			"RMOpen",
			"RMClose",
			"RMDisband",
			"RMConvert",
			"RMRole",
			"RMReady",
			"RMControl",
			"RMBuff",
			"CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton"
		}
		for _, button in pairs(rmbtns) do
			local f = _G[button]
			for i = 1, 9 do
				select(i, f:GetRegions()):SetAlpha(0)
			end
		end
	end

	-- Event
	RaidManager:RegisterEvent("GROUP_ROSTER_UPDATE")
	RaidManager:RegisterEvent("PLAYER_ENTERING_WORLD")
	RaidManager:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if not self.styled then
			RaidManagerGo()
			self.styled = true
		end
		if self.styled then
			-- MainPanel
			if IsInGroup() then
				if RaidManager.State then
					self:Show()
					RMOpen:Hide()
				else
					self:Hide()
					RMOpen:Show()
				end
			else
				self:Hide()
				RMOpen:Hide()
			end
			-- Disband Button
			if UnitIsGroupLeader("player") then
				RMDisband:Enable()
				RMDisband:SetAlpha(1)
			else
				RMDisband:Disable()
				RMDisband:SetAlpha(0.5)
			end
			-- Grouptype Convert
			if IsInRaid() then
				RMConvert.Text:SetText(CONVERT_TO_PARTY)
			else
				RMConvert.Text:SetText(CONVERT_TO_RAID)
			end
			if UnitIsGroupLeader("player") and not HasLFGRestrictions() then
				RMConvert:Enable()
				RMConvert:SetAlpha(1)
			else
				RMConvert:Disable()
				RMConvert:SetAlpha(0.5)
			end
			-- Role Pole
			if IsInGroup() and not HasLFGRestrictions() and (UnitIsGroupLeader("player") or (UnitIsGroupAssistant("player") and IsInRaid())) then
				RMRole:Enable()
				RMRole:SetAlpha(1)
			else
				RMRole:Disable()
				RMRole:SetAlpha(0.5)
			end
			-- Ready Check
			if IsInGroup() and (UnitIsGroupLeader("player") or (UnitIsGroupAssistant("player") and IsInRaid())) then
				RMReady:Enable()
				RMReady:SetAlpha(1)
			else
				RMReady:Disable()
				RMReady:SetAlpha(0.5)
			end
			-- World Marker
			if (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
				RMWmark:Enable()
				RMWmark:SetAlpha(1)
			else
				RMWmark:Disable()
				RMWmark:SetAlpha(0.5)
			end
			-- All Assist Checkbox
			RMEveryoneCB:SetChecked(RaidFrameAllAssistCheckButton:GetChecked())
			if IsInRaid() and UnitIsGroupLeader("player") then
				RMEveryoneCB:Enable()
				RMEveryoneCB:SetAlpha(1)
				RMEveryone:SetAlpha(1)
			else
				RMEveryoneCB:Disable()
				RMEveryoneCB:SetAlpha(0.5)
				RMEveryone:SetAlpha(0.5)
			end
		end
	end)
end
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	if not NDuiDB["Skins"]["RM"] then return end
	RMLoad()
end)

-- Aurora-ed the default manager frame
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	local buttons = {
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup1,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup2,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup3,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup4,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup5,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup6,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup7,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup8,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck,
		--CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton,
		CompactRaidFrameManagerDisplayFrameLockedModeToggle,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggle,
		CompactRaidFrameManagerDisplayFrameConvertToRaid
	}
	--CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton.SetNormalTexture = function() end
	for _, button in pairs(buttons) do
		for i = 1, 9 do
			select(i, button:GetRegions()):SetAlpha(0)
		end
		F.Reskin(button)
	end
	for i = 1, 8 do
		select(i, CompactRaidFrameManager:GetRegions()):Hide()
	end
	select(1, CompactRaidFrameManagerDisplayFrameFilterOptions:GetRegions()):Hide()
	select(1, CompactRaidFrameManagerDisplayFrame:GetRegions()):Hide()
	select(4, CompactRaidFrameManagerDisplayFrame:GetRegions()):Hide()

	local bd = CreateFrame("Frame", nil, CompactRaidFrameManager)
	F.CreateBD(bd)
	bd:SetPoint("TOPLEFT", CompactRaidFrameManager, "TOPLEFT")
	bd:SetPoint("BOTTOMRIGHT", CompactRaidFrameManager, "BOTTOMRIGHT", -9, 9)
	F.ReskinDropDown(CompactRaidFrameManagerDisplayFrameProfileSelector)
	F.ReskinCheck(CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton)
end