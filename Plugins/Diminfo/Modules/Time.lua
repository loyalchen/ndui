local addon, ns = ...
local cfg = ns.cfg
local init = ns.init
local panel = CreateFrame("Frame", nil, UIParent)

if cfg.Time == true then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text = panel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(unpack(cfg.Fonts))
	Text:SetPoint(unpack(cfg.TimePoint))

	local int = 1
	local function Update(self, t)
		local pendingCalendarInvites = CalendarGetNumPendingInvites()
		int = int - t
		if int < 0 then
			if GetCVar("timeMgrUseLocalTime") == "1" then
				Hr24 = tonumber(date("%H"))
				Hr = tonumber(date("%I"))
				Min = date("%M")
				if GetCVar("timeMgrUseMilitaryTime") == "1" then
					if pendingCalendarInvites > 0 then
					Text:SetText("|cffFF0000"..Hr24..":"..Min)
				else
					Text:SetText(Hr24..":"..Min)
				end
			else
				if Hr24 >= 12 then
					if pendingCalendarInvites > 0 then
						Text:SetText(cfg.ColorClass and "|cffFF0000"..Hr..":"..Min..init.Colored.."pm|r" or "|cffFF0000"..Hr..":"..Min.."|cffffffffpm|r")
					else
						Text:SetText(cfg.ColorClass and Hr..":"..Min..init.Colored.."pm|r" or Hr..":"..Min.."|cffffffffpm|r")
					end
				else
					if pendingCalendarInvites > 0 then
						Text:SetText(cfg.ColorClass and "|cffFF0000"..Hr..":"..Min..init.Colored.."am|r" or "|cffFF0000"..Hr..":"..Min.."|cffffffffam|r")
					else
						Text:SetText(cfg.ColorClass and Hr..":"..Min..init.Colored.."am|r" or Hr..":"..Min.."|cffffffffam|r")
					end
				end
			end
		else
			local Hr, Min = GetGameTime()
			if Min < 10 then Min = "0"..Min end
			if GetCVar("timeMgrUseMilitaryTime") == "1" then
				if pendingCalendarInvites > 0 then			
					Text:SetText("|cffFF0000"..Hr..":"..Min.."|cffffffff|r")
				else
					Text:SetText(Hr..":"..Min.."|cffffffff|r")
				end
			else
				if Hr >= 12 then
					if Hr > 12 then Hr = Hr - 12 end
					if pendingCalendarInvites > 0 then
						Text:SetText(cfg.ColorClass and "|cffFF0000"..Hr..":"..Min..init.Colored.."pm|r" or "|cffFF0000"..Hr..":"..Min.."|cffffffffpm|r")
					else
						Text:SetText(cfg.ColorClass and Hr..":"..Min..init.Colored.."pm|r" or Hr..":"..Min.."|cffffffffpm|r")
					end
				else
					if Hr == 0 then Hr = 12 end
					if pendingCalendarInvites > 0 then
						Text:SetText(cfg.ColorClass and "|cffFF0000"..Hr..":"..Min..init.Colored.."am|r" or "|cffFF0000"..Hr..":"..Min.."|cffffffffam|r")
					else
						Text:SetText(cfg.ColorClass and Hr..":"..Min..init.Colored.."am|r" or Hr..":"..Min.."|cffffffffam|r")
					end
				end
			end
		end
		self:SetAllPoints(Text)
		int = 1
		end
	end

	Stat:SetScript("OnEnter", function(self)
		OnLoad = function(self) RequestRaidInfo() end

		GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6)
		GameTooltip:ClearLines()
		local months = {
			MONTH_JANUARY, MONTH_FEBRUARY, MONTH_MARCH,	MONTH_APRIL, MONTH_MAY, MONTH_JUNE,
			MONTH_JULY, MONTH_AUGUST, MONTH_SEPTEMBER, MONTH_OCTOBER, MONTH_NOVEMBER, MONTH_DECEMBER,
		}
		local w, m, d, y = CalendarGetDate()
		GameTooltip:AddLine(format(FULLDATE, CALENDAR_WEEKDAY_NAMES[w], months[m], d, y),0,.6,1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, GameTime_GetLocalTime(true),.6,.8,1,1,1,1)
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GameTime_GetGameTime(true),.6,.8,1,1,1,1)
		GameTooltip:AddLine(" ")
		for i = 1, 2 do		--GetNumWorldPVPAreas(), not for Ashland
			local _, name, inprogress, canQueue, timeleft, canEnter = GetWorldPVPAreaInfo(i)
			local tr, tg, tb
			if timeleft == nil then
				timeleft = QUEUE_TIME_UNAVAILABLE
			elseif inprogress then
				timeleft = WINTERGRASP_IN_PROGRESS
			else
				local hour = tonumber(format("%01.f", floor(timeleft/3600)))
				local min = format(hour > 0 and "%02.f" or "%01.f", floor(timeleft/60 - (hour*60)))
				local sec = format("%02.f", floor(timeleft - hour*3600 - min *60)) 
				timeleft = (hour > 0 and hour..":" or "")..min..":"..sec
			end
			if canQueue and canEnter then tr, tg, tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end
			GameTooltip:AddDoubleLine(name..":", timeleft,.6,.8,1,tr,tg,tb)
		end

		local oneboss
		for i = 1, GetNumSavedWorldBosses() do
			local name, _, reset = GetSavedWorldBossInfo(i)
			if not oneboss then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(RAID_INFO_WORLD_BOSS,.6,.8,1)
				oneboss = true
			end
			GameTooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3),1,1,1,1,1,1)
		end

		local oneraid
		for i = 1, GetNumSavedInstances() do
			local name, _, reset, _, locked, extended, _, isRaid, _, diffName = GetSavedInstanceInfo(i)
			if isRaid and (locked or extended) then
				local tr,tg,tb
				if not oneraid then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(RAID_INFO,.6,.8,1)
					oneraid = true
				end
				if extended then tr,tg,tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end
				GameTooltip:AddDoubleLine(name.." - "..diffName, SecondsToTime(reset, true, nil, 3),1,1,1,tr,tg,tb)
			end
		end

		local draenor
		local bosslist = {
			{index = 1291, quest = 37462},
			{index = 1211, quest = 37462},
			{index = 1262, quest = 37464},
		}
		for _, boss in pairs(bosslist) do
			local _, name = EJ_GetCreatureInfo(1, boss.index)
			if boss.quest and IsQuestFlaggedCompleted(boss.quest) then
				if not draenor then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(SPLASH_NEW_RIGHT_TITLE..RAID_INFO_WORLD_BOSS,.6,.8,1)
					draenor = true
				end
				GameTooltip:AddDoubleLine(name, BOSS_DEAD, 1,1,1,1,0,0)
			end
		end

		GameTooltip:AddDoubleLine(" ","--------------",1,1,1,0.5,0.5,0.5)
		GameTooltip:AddDoubleLine(" ",infoL["Toggle Calendar"],1,1,1,.6,.8,1)
		GameTooltip:AddDoubleLine(" ",infoL["Toggle Clock"],1,1,1,.6,.8,1)
		GameTooltip:AddDoubleLine(" ",infoL["Join WorldPVP"],1,1,1,.6,.8,1)
		GameTooltip:Show()
	end)

	local menuFrame = CreateFrame("Frame", "JoinBattlefieldMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = WORLD..PVP, isTitle = true, notCheckable = true},
		{notCheckable = true},
		{notCheckable = true},
		{notCheckable = true},
	}

	Stat:SetScript("OnLeave", GameTooltip_Hide)
	Stat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("UPDATE_INSTANCE_INFO")
	Stat:SetScript("OnUpdate", Update)
	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton"  then
			for i = 1, 2 do
				local id, name = GetWorldPVPAreaInfo(i)
				menuList[i+1].text = name
				menuList[i+1].func = function() BattlefieldMgrQueueRequest(id) end
			end
			EasyMenu(menuList, menuFrame, self, -50, 100, "MENU", 2)
		elseif btn == "MiddleButton" then					
			ToggleTimeManager()
		else
			GameTimeFrame:Click()
		end
	end)
	Update(Stat, 10)
end