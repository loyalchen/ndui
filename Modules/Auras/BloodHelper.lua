--------------------------------------
-- BloodHelper by 各种囧@NGA
--------------------------------------
local B, C, L, DB = unpack(select(2, ...))
if DB.MyClass ~= "DEATHKNIGHT" then return end

-- initialize
local rune, runicP = {}, 0
local RSchecked = {}
local DScount = 0
local recentdamage, total = {}, 0
local IconSize = C.Auras.IconSize + 8
local BHFont = {DB.Font[1], DB.Font[2] + 4, DB.Font[3]}

for i = 1, 6 do
	rune[i] = {tp, start, duration, runeReady}
end

local function updatesource()
	for i = 1, 6 do
		rune[i].tp = GetRuneType(i)
		rune[i].start, rune[i].duration, rune[i].runeReady = GetRuneCooldown(i)
	end
	runicP = UnitPower("player")
end

local function checkRS()
	updatesource()
	local b, o = 0, 0
	for i = 1, 6 do
		if rune[i].tp == 1 and (rune[i].start - GetTime()) > 0 then b = b + 1
		elseif rune[i].tp ~= 1 and (rune[i].start - GetTime()) > 0 then o = o + 1
		end
	end
	RSchecked.canrecharge = (b == 0 and o > 0) and true or false
	RSchecked.count = floor(runicP / 30)
	return RSchecked
end

local function checkDS()
	updatesource()
	local u, f, d = 0, 0, 0
	for i = 1, 6 do
		u = (rune[i].tp == 2 and rune[i].runeReady) and u + 1 or u
		f = (rune[i].tp == 3 and rune[i].runeReady) and f + 1 or f
		d = (rune[i].tp == 4 and rune[i].runeReady) and d + 1 or d
	end
	local x = math.min(f, u)
	local y = math.max(f, u)
	if x == 0 then
		if y == 0 then
			DScount = math.floor(d / 2)
		else
			DScount = math.min(d, y) + (math.floor((d - y) / 2) > 0 and math.floor((d - y) / 2) or 0)
		end
	else
		DScount = x + math.min(d, y - x) + (math.floor((d - (y - x)) / 2) > 0 and math.floor((d - (y - x)) / 2) or 0)
	end
	return DScount
end

local function updatedamage()
	total = 0
	local time, lag = GetTime(), select(3, GetNetStats())
	lag = lag/1000
	for k, v in pairs(recentdamage) do
		if (time - tonumber(k) + lag) <= 5 then
			total = total + v
		end
	end
	total = 1.45*.2*total/UnitHealthMax("Player") < .07 and "|cff11FF117" or "|cff11FF11"..ceil(1.45*.2*total/UnitHealthMax("Player")*1000)/10
end

local function cleardamage()
	local time = GetTime()
	for k, v in pairs(recentdamage) do
		if (time - tonumber(k)) > 5 then
			recentdamage[tonumber(k)] = nil
		end
	end
end

local function SetFrame(f)
	f:SetSize(IconSize, IconSize)
	B.CreateSD(f, 4, 4)
	f.icon = f:CreateTexture(nil, "ARTWORK")
	f.icon:SetAllPoints(f)
	f.icon:SetTexCoord(unpack(DB.TexCoord))
	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetFont(unpack(BHFont))
end
-- Main
local BloodHelper = CreateFrame("Frame", nil, UIParent)
local function BloodHelperGo()
	BloodHelper:SetSize(2 * IconSize + 4, IconSize)
	BloodHelper.Mover = B.Mover(BloodHelper, TOGGLE, "BloodHelper", C.Auras.BHPos, 80, 80)
	BloodHelper:Hide()
	SlashCmdList["BLOODHELPER"] = function(msg)
		if msg:lower() == "reset" then
			wipe(NDuiDB["BloodHelper"])
			ReloadUI()
		else
			if BloodHelper.Mover:IsVisible() then
				BloodHelper.Mover:Hide()
			else
				BloodHelper.Mover:Show()
			end
		end
	end
	SLASH_BLOODHELPER1 = "/sb"
end
BloodHelper:RegisterEvent("PLAYER_ENTERING_WORLD")
BloodHelper:SetScript("OnEvent", function(self, event, ...)
	if not NDuiDB["BloodHelper"]["Enable"] then return end
	if not self.styled then
		BloodHelperGo()
		self.styled = true
	end
	if self.styled then
		if event == "PLAYER_ENTERING_WORLD" then
			BHFont[2] = 20*768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/UIParent:GetEffectiveScale()
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			-- Rune Strike & Death Strike
			RS = CreateFrame("Frame", nil, self)
			DS = CreateFrame("Frame", nil, self)
			RS:SetPoint("TOPLEFT", self)
			DS:SetPoint("TOPRIGHT", self)
			SetFrame(RS)
			SetFrame(DS)
			RS.text:SetPoint("BOTTOMRIGHT", RS)
			DS.text:SetPoint("BOTTOMRIGHT", DS)
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
			-- Blood Shield
			BS = CreateFrame("Frame", nil, self)
			BS:SetPoint("TOP", self, "BOTTOM", 0, -4)
			BS:SetSize(130, 5)
			B.CreateSD(BS, 4, 4)
			BS.status = CreateFrame("StatusBar", nil, BS)
			BS.status:SetAllPoints(BS)
			BS.status:SetStatusBarTexture(DB.normTex)
			BS.status:SetStatusBarColor(DB.cc.r, DB.cc.g, DB.cc.b)
			BS.status:SetMinMaxValues(0, 10)
			BS.BG = BS.status:CreateTexture(nil, "BACKGROUND")
			BS.BG:SetAllPoints()
			BS.BG:SetTexture(DB.normTex)
			BS.BG:SetVertexColor(DB.cc.r, DB.cc.g, DB.cc.b, 0.2)
			BS.text = BS.status:CreateFontString(nil, "OVERLAY")
			BS.text:SetFont(unpack(BHFont))
			BS.text:SetPoint("TOPLEFT", BS, "LEFT", 4, 3)
			BS.spark = BS.status:CreateTexture(nil, "OVERLAY")
			BS.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
			BS.spark:SetBlendMode("ADD")
			BS.spark:SetAlpha(.8)
			BS.spark:SetPoint("TOPLEFT", BS.status:GetStatusBarTexture(), "TOPRIGHT", -10, 16)
			BS.spark:SetPoint("BOTTOMRIGHT", BS.status:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -16)
			-- Death Strike Healing predict
			DS:RegisterUnitEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
			DS:SetScript("OnEvent", function(self, ...)
				local time = GetTime()
				local event, timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, destGUID, destName, destFlags, destRaidFlags, param9, param10, param11, param12, param13, param14,  param15, param16, param17, param18, param19, param20 = ...
				if not event or not eventtype or not destName then return end
				if eventtype:find("_DAMAGE") and destName == myname then
					if eventtype:find("SWING_") and param9 then
						-- local damage, absorb = param9, param14 or 0
						recentdamage[time] = param9
					elseif (eventtype:find("SPELL_") or eventtype:find("RANGE_")) and srcName then
						-- local damage, absorb, school = param12 or 0, param17 or 0, param14 or 0
						local spellName = param10 or nil
						if param12 and not (spellName == SPIRIT_LINK_SPELL and srcName == SPIRIT_LINK_TOTEM) then recentdamage[time] = param12 end
					end
				end
			end)
			DS.predict = DS:CreateFontString(nil, "OVERLAY")
			DS.predict:SetFont(unpack(BHFont))
			DS.predict:SetPoint("BOTTOMLEFT", DS, "BOTTOMRIGHT", 4, 0)
		end
		if event == "PLAYER_REGEN_ENABLED" then 
			self:Hide() 	
			self:SetScript("OnUpdate", nil)
			cleardamage()
			collectgarbage("collect")
		end
		if event == "PLAYER_REGEN_DISABLED" and GetSpecialization() == 1 then
			BloodHelper.Mover:Hide()
			self:Show()
			cleardamage()
			RS.icon:SetTexture(select(3, GetSpellInfo(47541)))
			DS.icon:SetTexture(select(3, GetSpellInfo(49998)))
			self:SetScript("OnUpdate", function(self, elapsed)
				self.elapsed = (self.elapsed or 0.1) - elapsed
				if self.elapsed <= 0 then
					checkRS()
					checkDS()
					RS.text:SetText(RSchecked.count)
					DS.text:SetText(DScount)
					if DScount ~= 0 then DS:SetAlpha(1) else DS:SetAlpha(0.3) end
					if RSchecked.canrecharge and RSchecked.count ~= 0 then RS:SetAlpha(1) else RS:SetAlpha(0.3) end
					
					local BStime = select(7, UnitBuff("player", GetSpellInfo(77535)))
					if BStime then
						BS:Show()
						BStime = BStime - GetTime()
						local BSabsorb = select(15, UnitBuff("player", GetSpellInfo(77535)))
						BS.text:SetText(BSabsorb)
						BS.status:SetValue(BStime)
					else
						BS:Hide()
					end
					updatedamage()
					DS.predict:SetText(total.."%|r")
				end
			end)
		end
	end
end)