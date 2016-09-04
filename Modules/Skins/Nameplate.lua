local B, C, L, DB = unpack(select(2, ...))

local frames, numChildren, select = {}, -1, select
local badR, badG, badB = 1, 0, 0
local transitionR, transitionG, transitionB = 1, 1, 0

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function QueueObject(frame, object)
	frame.queue = frame.queue or {}
	frame.queue[object] = true
end

local function HideObjects(frame)
	for object in pairs(frame.queue) do
		if object:GetObjectType() == "Texture" then
			object:SetTexture('')
		elseif object:GetObjectType() == "FontString" then
			object:SetWidth(0.001)
		elseif object:GetObjectType() == "StatusBar" then
			object:SetStatusBarTexture('')
		else
			object:Hide()
		end
	end
end

-- Create a fake backdrop frame using textures
local function CreateVirtualFrame(parent, point)
	if point == nil then point = parent end

	if point.backdrop then return end
	parent.backdrop = parent:CreateTexture(nil, "BORDER")
	parent.backdrop:SetDrawLayer("BORDER", 1)
	parent.backdrop:SetPoint("TOPLEFT", point, "TOPLEFT", -1, 1)
	parent.backdrop:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", 1, -1)
	parent.backdrop:SetTexture(0, 0, 0)

	parent.glow = CreateFrame("Frame",nil,parent)
	parent.glow:SetPoint("TOPLEFT", point, "TOPLEFT", -4, 4)
	parent.glow:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", 4, -4)
	parent.glow:SetBackdrop({
		edgeFile = DB.glowTex, edgeSize = 4,
	})
	parent.glow:SetBackdropColor(0, 0, 0)
	parent.glow:SetBackdropBorderColor(0, 0, 0)
	parent.glow:SetFrameLevel(0)
end

local function SetVirtualBorder(parent, r, g, b, a)
	if not a then a = 1 end
	parent.glow:SetBackdropBorderColor(r, g, b, a)
end

-- Create aura icons
local function CreateAuraIcon(frame)
	local button = CreateFrame("Frame", nil, frame)
	button:SetParent(frame.hp)
	button:SetWidth(C.Nameplate.AuraSize)
	button:SetHeight(C.Nameplate.AuraSize - 6)

	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetAllPoints()
	button.Icon:SetTexCoord(unpack(DB.TexCoord))
	B.CreateSD(button, 3, 3)

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetPoint("TOPRIGHT", button, "TOPRIGHT", 2, 6)
	button.text:SetJustifyH("CENTER")
	button.text:SetFont(unpack(DB.Font))

	button.count = button:CreateFontString(nil,"OVERLAY")
	button.count:SetFont(unpack(DB.Font))
	button.count:SetShadowColor(0, 0, 0, 0.4)
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -6)
	return button
end

-- Auras timer
local function FormatAuraTime(seconds)
	local d, h, m, str = 86400, 3600, 60
	if seconds >= d then
		str = format("%d"..DB.MyColor.."d", seconds/d)
	elseif seconds >= h then
		str = format("%d"..DB.MyColor.."h", seconds/h)
	elseif seconds >= m then
		str = format("%d"..DB.MyColor.."m", seconds/m)
	else
		if seconds <= 5 then
			str = format("|cffff0000%.1f|r", seconds) -- red
		elseif seconds <= 10 then
			str = format("|cffffff00%.1f|r", seconds) -- yellow
		else
			str = format("%d", seconds)
		end
	end
	return str
end

local function UpdateAuraTimer(self, elapsed)
	if not self.timeLeft then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		if not self.firstUpdate then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.firstUpdate = false
		end
		if self.timeLeft < 0 then
			self.text:SetText("")
		elseif self.timeLeft > 0 then
			local time = FormatAuraTime(self.timeLeft)
			self.text:SetText(time)
		else
			self.text:SetText("")
			self:SetScript("OnUpdate", nil)
			self:Hide()
		end
		self.elapsed = 0
	end
end

-- Update an aura icon
local function UpdateAuraIcon(button, unit, index, filter)
	local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)
	button.Icon:SetTexture(icon)
	button.firstUpdate = true
	button.duration = duration
	button.spellID = spellID
	button.timeLeft = expirationTime
	if count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	if not button:GetScript("OnUpdate") then
		button:SetScript("OnUpdate", UpdateAuraTimer)
	end
	button:Show()
end

-- Filter auras on nameplate, and determine if we need to update them or not
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit or not NDuiDB["Nameplate"]["TrackAuras"] then return end
	local i = 1
	for index = 1, 40 do
		if i > C.Nameplate.Width / C.Nameplate.AuraSize then return end
		local match
		local name, _, _, _, _, duration, _, caster, _, _, spellid = UnitAura(frame.unit, index, "HARMFUL")

		if DB.DebuffWhiteList[name] and caster == "player" then match = true end

		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT", frame.icons, "RIGHT") end
			if i ~= 1 and i <= C.Nameplate.Width / C.Nameplate.AuraSize then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

-- Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function CastTextUpdate(frame, curValue)
	local _, maxValue = frame:GetMinMaxValues()
	local last = frame.last and frame.last or 0
	local finish = (curValue > last) and (maxValue - curValue) or curValue

	frame.time:SetFormattedText("%.1f ", finish)
	frame.last = curValue
	if frame.shield:IsShown() then
		frame:SetStatusBarColor(0.78, 0.25, 0.25)
		frame.cbbg:SetTexture(0.78, 0.25, 0.25, 0.2)
	else
		frame:SetStatusBarColor(0.37, 0.71, 1)
		frame.cbbg:SetTexture(0.75, 0.75, 0.25, 0.2)
	end
end

local function OnHealthValueChanged(frame)
	local frame = frame:GetParent()
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue() - 1)
	frame.hp:SetValue(frame.healthOriginal:GetValue())
end

-- We need to reset everything when a nameplate it hidden
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp:SetScale(1)
	frame.overlay:Hide()
	frame.cb:SetScale(1)
	frame.cb:Hide()
	frame.unit = nil
	frame.guid = nil
	frame.isTapped = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _, icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end
	frame:SetScript("OnUpdate", nil)
end

-- Color Nameplate
local function Colorize(frame)
	local r, g, b = frame.healthOriginal:GetStatusBarColor()
	local newr, newg, newb
	
	frame.isTapped = nil
	if r>=.5 and r<=.6 and g>=.5 and g<=.6 and b>=.5 and b<=.6 then -- tapped
		frame.isTapped = true
	end

	if g + b == 0 then	-- Hostile
		newr, newg, newb = 1, .1, .1
	elseif r + b == 0 then	-- Friendly npc
		newr, newg, newb = 0, .6, .1
	elseif r + g == 0 then	-- Friendly player
		newr, newg, newb = .1, .1, 1
	elseif (r + g > 1.95 and b == 0) then	-- Neutral
		newr, newg, newb = .9, .9, 0
	else
		newr, newg, newb = r, g, b
	end

	frame.r, frame.g, frame.b = newr, newg, newb
	frame.hp:SetStatusBarColor(newr, newg, newb)
	frame.hp.hpbg:SetTexture(newr, newg, newb, 0.2)
	if frame.overlay:IsShown() then
		frame.hp.name:SetTextColor(newr, newg, newb)
	else
		frame.hp.name:SetTextColor(1, 1, 1)
	end
end

-- HealthBar OnShow, use this to set variables for the nameplate
local function UpdateObjects(frame)
	local frame = frame:GetParent()

	-- Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(C.Nameplate.Width, C.Nameplate.Height)
	frame.hp:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)

	-- Match values
	OnHealthValueChanged(frame.hp)

	-- Colorize Plate
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	SetVirtualBorder(frame.hp, 0,0,0,0)

	local isSmallNP
	if frame.hp:GetEffectiveScale() < 1 then isSmallNP = true end

	while frame.hp:GetEffectiveScale() < 1 do
		frame.hp:SetScale(frame.hp:GetScale() + 0.01)
	end
	while frame.cb:GetEffectiveScale() < 1 do
		frame.cb:SetScale(frame.cb:GetScale() + 0.01)
	end

	if isSmallNP then
		frame.hp:SetSize(C.Nameplate.Width*2/3, C.Nameplate.Height)
	end

	-- Set the level and name text
	local level, elite, mylevel, nametext = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player"), frame.hp.oldname:GetText()
	if frame.hp.boss:IsShown() then
		frame.hp.name:SetText("|cffff0000Boss|r "..nametext)
	elseif isSmallNP then
		frame.hp.name:SetText(frame.hp.oldname:GetText())
	elseif (not elite and level == mylevel) or isSmallNP then
		frame.hp.name:SetText(nametext)
	else
		frame.hp.name:SetText(B.HexRGB(frame.hp.oldlevel:GetTextColor())..level..(elite and "+|r " or "|r ")..nametext)
	end

	HideObjects(frame)
end

-- This is where we create most 'Static' objects for the nameplate
local function SkinObjects(frame, nameFrame)
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbname, cbshadow = cb:GetRegions()

	-- Health Bar
	frame.healthOriginal = oldhp
	local hp = CreateFrame("Statusbar", nil, frame)
	hp:SetFrameLevel(oldhp:GetFrameLevel())
	hp:SetFrameStrata(oldhp:GetFrameStrata())
	hp:SetStatusBarTexture(DB.normTex)
	CreateVirtualFrame(hp)
	B.SmoothBar(hp)
	if not hp.mark1 then
		hp.mark1 = hp:CreateFontString(nil, "OVERLAY")
		hp.mark1:SetFont(DB.Font[1], 36, DB.Font[3])
		hp.mark1:SetText(">")
		hp.mark1:SetTextColor(1,0,1)
		hp.mark1:SetPoint("RIGHT", hp, "LEFT", -1, 2)
	end
	if not hp.mark2 then
		hp.mark2 = hp:CreateFontString(nil, "OVERLAY")
		hp.mark2:SetFont(DB.Font[1], 36, DB.Font[3])
		hp.mark2:SetText("<")
		hp.mark2:SetTextColor(1,0,1)
		hp.mark2:SetPoint("LEFT", hp, "RIGHT", 1, 2)
	end
		
	-- Create Level
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite

	-- Create Health Text
	hp.value = hp:CreateFontString(nil, "OVERLAY")
	hp.value:SetFont(unpack(DB.Font))
	hp.value:SetPoint("RIGHT", hp, "BOTTOMRIGHT", 0, 0)
	hp.value:SetTextColor(1, 1, 1)

	-- Create Name Text
	hp.name = hp:CreateFontString(nil, "OVERLAY")
	hp.name:SetPoint("BOTTOMLEFT", hp, "TOPLEFT", -3, 2)
	hp.name:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 3, 2)
	hp.name:SetFont(unpack(DB.Font))
	hp.name:SetWordWrap(false)
	hp.oldname = oldname

	hp.hpbg = hp:CreateTexture(nil, "BORDER")
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1, 1, 1, 0.2)

	hp:HookScript("OnShow", UpdateObjects)
	frame.hp = hp

	if not frame.threat then
		frame.threat = threat
	end

	-- Create Cast Bar
	cb:ClearAllPoints()
	cb:SetPoint("TOPRIGHT", hp, "BOTTOMRIGHT", 0, -8)
	cb:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -8-C.Nameplate.Height)
	cb:SetStatusBarTexture(DB.normTex)
	CreateVirtualFrame(cb)

	cb.cbbg = cb:CreateTexture(nil, "BORDER")
	cb.cbbg:SetAllPoints(cb)
	cb.cbbg:SetTexture(0.75, 0.75, 0.25, 0.2)

	-- Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:SetPoint("RIGHT", cb, "RIGHT", 3, 0)
	cb.time:SetFont(unpack(DB.Font))
	cb.time:SetTextColor(1, 1, 1)

	-- Create Cast Name Text
	cbname:ClearAllPoints()
	cb.name = cbname
	cb.name:SetPoint("CENTER", cb, "CENTER", 0, -6)
	cb.name:SetFont(DB.Font[1], DB.Font[2]-2, DB.Font[3])
	cb.name:SetTextColor(1, 1, 1)

	-- Create CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)
	cbicon:SetSize((C.Nameplate.Height * 2) + 8, (C.Nameplate.Height * 2) + 8)
	cbicon:SetTexCoord(unpack(DB.TexCoord))
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	CreateVirtualFrame(cb, cb.icon)

	cb.shield = cbshield
	cb:HookScript("OnValueChanged", CastTextUpdate)
	frame.cb = cb

	-- Aura tracking
	if NDuiDB["Nameplate"]["TrackAuras"] then
		if not frame.icons then
			frame.icons = CreateFrame("Frame", nil, frame.hp)
			frame.icons:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, 17)
			frame.icons:SetWidth(20 + C.Nameplate.Width)
			frame.icons:SetHeight(C.Nameplate.AuraSize)
			frame.icons:SetFrameLevel(frame.hp:GetFrameLevel() + 2)
			frame:RegisterEvent("UNIT_AURA")
			frame:HookScript("OnEvent", OnAura)
		end
	end

	-- Highlight texture
	if not frame.overlay then
		overlay:SetTexture(1, 1, 1, 0.15)
		overlay:SetParent(frame.hp)
		overlay:SetAllPoints()
		frame.overlay = overlay
	end

	-- Raid icon
	if not frame.raidicon then
		raidicon:ClearAllPoints()
		raidicon:SetPoint("BOTTOMRIGHT", frame.hp, "TOPLEFT", -2, 2)
		raidicon:SetSize((C.Nameplate.Height * 2) + 8, (C.Nameplate.Height * 2) + 8)
		frame.raidicon = raidicon
	end

	-- Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, cbshadow)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)

	UpdateObjects(hp)

	frame:HookScript("OnHide", OnHide)
	frames[frame] = true
end

local function UpdateThreat(frame, elapsed)
	frame.hp:Show()
	Colorize(frame)
	SetVirtualBorder(frame.hp, 0, 0, 0)
	if frame.isTapped == true then return end

	if NDuiDB["Nameplate"]["TankMode"] and DB.Role == "Tank" then
		if frame.threat:IsShown() then
			-- Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.threat:GetVertexColor()
			if g + b == 0 then
				-- Have Threat
				frame.hp:SetStatusBarColor(0.9, 0.1, 0.9)
				frame.hp.hpbg:SetTexture(badR, badG, badB, 0.2)
			else
				-- Losing/Gaining Threat
				frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)
				frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.2)
			end
		else
			-- Set colors to their original, not in combat
			frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
			frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.2)
		end
	else
		if frame.threat:IsShown() then
			local _, val = frame.threat:GetVertexColor()
			if val > 0.7 then
				SetVirtualBorder(frame.hp, transitionR, transitionG, transitionB)
			else
				SetVirtualBorder(frame.hp, badR, badG, badB)
			end
		end
	end
end

-- Create our blacklist for nameplates
local function CheckBlacklist(frame, ...)
	if DB.PlateBlacklist[frame.hp.name:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end

-- Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.hp.name:GetText() and frame:GetParent():GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

-- Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	OnHealthValueChanged(frame.hp)
	-- Show current health value
	local _, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local p = (valueHealth / maxHealth) * 100

	-- Match values
	frame.hp:SetValue(valueHealth - 1)
	frame.hp:SetValue(valueHealth)
	if p < 100 and valueHealth >= 1 then
		if NDuiDB["Nameplate"]["HealthValue"] then
			frame.hp.value:SetText(B.Numb(valueHealth).."-"..(string.format("%d%%", math.floor((valueHealth / maxHealth) * 100))))
		else
			frame.hp.value:SetText(string.format("%d%%", math.floor((valueHealth / maxHealth) * 100)))
		end
	else
		frame.hp.value:SetText("")
	end

	if (p <= 50 and p >= 35) then
		frame.hp.value:SetTextColor(253/255, 238/255, 80/255)
	elseif (p < 35 and p >= 20) then
		frame.hp.value:SetTextColor(250/255, 130/255, 0/255)
	elseif (p < 20) then
		frame.hp.value:SetTextColor(200/255, 20/255, 40/255)
	else
		frame.hp.value:SetTextColor(1,1,1)
	end

	if UnitName("target") and frame:GetParent():GetAlpha() == 1 then
		frame.hp.mark1:Show()
		frame.hp.mark2:Show()
	else
		frame.hp.mark1:Hide()
		frame.hp.mark2:Hide()
	end
end

-- Scan all visible nameplate for a known unit
local function CheckUnit_Guid(frame, ...)
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.hp.oldname:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.oldname:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end
end

-- Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end

	if frame.guid == destGUID then
		for _, icon in ipairs(frame.icons) do
			if icon.spellID == spellID then
				icon:Hide()
			end
		end
	end
end

-- Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame and frame:GetParent():IsShown() then
			functionToRun(frame, ...)
		end
	end
end

-- Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local function HookFrames(...)
	for index = 1, select("#", ...) do
		local frame = select(index, ...)
		if frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d") then
			local child1, child2 = frame:GetChildren()
			SkinObjects(child1, child2)
			frame.isSkinned = true
		end
	end
end

-- Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
NamePlates:SetScript("OnUpdate", function(self, elapsed)
	if not NDuiDB["Nameplate"]["Enable"] then return end
	if WorldFrame:GetNumChildren() ~= numChildren then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if self.elapsed and self.elapsed > 0.15 then
		ForEachPlate(UpdateThreat, self.elapsed)
		ForEachPlate(AdjustNameLevel)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end

	ForEachPlate(ShowHealth)
	ForEachPlate(CheckBlacklist)
	ForEachPlate(CheckUnit_Guid)
end)

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if not NDuiDB["Nameplate"]["Enable"] then return end
	if event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_BROKEN" or event == "SPELL_AURA_BROKEN_SPELL" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") or arg4 == UnitGUID("pet") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

-- Only show nameplates when in combat
NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
function NamePlates:PLAYER_REGEN_ENABLED()
	if not NDuiDB["Nameplate"]["CombatShow"] then return end
	SetCVar("nameplateShowEnemies", 0)
end
function NamePlates:PLAYER_REGEN_DISABLED()
	if not NDuiDB["Nameplate"]["CombatShow"] then return end
	SetCVar("nameplateShowEnemies", 1)
end