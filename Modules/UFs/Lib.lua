local B, C, L, DB = unpack(select(2, ...))
if not C.UFs.Enable then return end
local addon, ns = ...
local cast = ns.cast
local oUF = ns.oUF or oUF
local lib = CreateFrame("Frame")
oUF.colors.runes = {{0.87, 0.12, 0.23};{0.40, 0.95, 0.20};{0.14, 0.50, 1};{.70, .21, 0.94};}
oUF.colors.smooth = {1, 0, 0, .85, .8, .45, .1, .1, .1}

-- Config
local retVal = function(f, val1, val2, val3)
	if f.mystyle == "player" or f.mystyle == "target" then
		return val1
	elseif f.mystyle == "focus" then
		return val3
	else
		return val2
	end
end

-- Elements
lib.menu = function(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
end

lib.init = function(f)
    f.menu = lib.menu
    f:RegisterForClicks("AnyUp")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
end

lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetWordWrap(false)
    fs:SetShadowColor(0, 0, 0)
    fs:SetShadowOffset(0.5, -0.5)
    return fs
end

lib.gen_hpbar = function(f)
    local s = CreateFrame("StatusBar", nil, f)
    s:SetPoint("TOP", 0, 0)
	s:SetHeight(retVal(f,24,18,22))
    s:SetWidth(f:GetWidth())
    s:SetStatusBarTexture(DB.normTex)
	s:SetStatusBarColor(.1, .1, .1)
	s:SetFrameStrata("LOW")
	s:GetStatusBarTexture():SetHorizTile(false)
	B.CreateSD(s, 3, 3)
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetAllPoints(s)
    b:SetTexture(DB.bdTex)
	b:SetVertexColor(.65, .65, .65)
	b.multiplier = .25
	if NDuiDB["UFs"]["Smooth"] then s.Smooth = true end
	if NDuiDB["UFs"]["ClassColor"] then
		s.colorClass = true
		s.colorTapping = true
		s.colorReaction = true
		s.colorDisconnected = true
	else
		if NDuiDB["UFs"]["SmoothColor"] then
			s.colorSmooth = true
		end
	end

	s.frequentUpdates = true
	f.Health = s
    f.Health.bg = b
end

lib.gen_hpstrings = function(f)
	local nameframe = CreateFrame("Frame", nil, f)
	nameframe:SetAllPoints(f.Health)
	nameframe:SetFrameLevel(f.Health:GetFrameLevel() + 1)

    local name = lib.gen_fontstring(nameframe, DB.Font[1], DB.Font[2], "THINOUTLINE")
    name:SetPoint("LEFT", nameframe, "LEFT", 3, -1)
    name:SetPoint("RIGHT", nameframe, "LEFT", f:GetWidth() * 0.6, -1)
    name:SetJustifyH("LEFT")

    local hpval = lib.gen_fontstring(nameframe, DB.Font[1], retVal(f,14,13,13), "THINOUTLINE")
    hpval:SetPoint("RIGHT", nameframe, "RIGHT", -3, -1)

	local status
	if not NDuiDB["UFs"]["ClassColor"] then
		status = "[color]"
	else
		status = ""
	end

	if f.mystyle == "player" then
		f:Tag(name, "  "..status.."[name]")
	elseif f.mystyle == "target" then
		f:Tag(name, "[level] "..status.."[name][afkdnd]")
	elseif f.mystyle == "focus" then
		f:Tag(name, status.."[name][afkdnd]")
	else
		f:Tag(name, status.."[name]")
	end
	f:Tag(hpval, "[hp]")
end

lib.gen_ppstrings = function(f)
	local powerframe = CreateFrame("Frame", nil, f)
	powerframe:SetAllPoints(f.Power)
	powerframe:SetFrameLevel(f.Power:GetFrameLevel() + 1)

    local ppval = lib.gen_fontstring(powerframe, DB.Font[1], retVal(f,14,12,12), "THINOUTLINE")
	ppval:SetPoint("RIGHT", powerframe, "RIGHT", -3, 2)
	f:Tag(ppval, retVal(f,"[color][power]","[color][power]","[color][power]"))
end

lib.gen_ppbar = function(f)
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(DB.normTex)
	s:GetStatusBarTexture():SetHorizTile(false)
	s:SetHeight(retVal(f,4,3,3))
    s:SetWidth(245)
    s:SetPoint("BOTTOM", f, "BOTTOM", 0, 1)
	s:SetFrameStrata("LOW")
	B.CreateSD(s, 3, 3)
	s.frequentUpdates = true
	if f.mystyle == "player" or f.mystyle == "target" then
		s:SetPoint("BOTTOM", 0, -1)
	end
	if f.mystyle == "focus" then
		s:SetPoint("BOTTOM", 0, -1)
		s:SetWidth(200)
	end
	if f.mystyle == "boss" then
		s:SetPoint("BOTTOM", 0, -3)
		s:SetWidth(150)
	end
	if f.mystyle == "oUF_Arena" then
		s:SetPoint("BOTTOM", 0, 3)
		s:SetWidth(150)
	end
	if f.mystyle == "pet" or f.mystyle == "tot" or f.mystyle == "focustarget" then
		s:SetPoint("BOTTOM", 0, 4)
		s:SetWidth(120)
	end
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetAllPoints(s)
    b:SetTexture(DB.normTex)
	b.multiplier = .3
	if NDuiDB["UFs"]["Smooth"] then s.Smooth = true end
	if NDuiDB["UFs"]["ClassColor"] then
		s.colorPower = true
	else
		s.colorClass = true
		s.colorTapping = true
		s.colorDisconnected = true
		s.colorReaction = true
	end

    f.Power = s
    f.Power.bg = b
end

local PortraitUpdate = function(self, unit) 
	self:SetAlpha(0) self:SetAlpha(0.2)
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end
end

local HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end

lib.gen_portrait = function(f)
	if not NDuiDB["UFs"]["Portrait"] then return end

    local portrait = CreateFrame("PlayerModel", nil, f)
    portrait:SetFrameStrata("LOW")
    portrait:SetFrameLevel(f.Health:GetFrameLevel() + 1)
	portrait:SetAllPoints(f.Health)
	table.insert(f.__elements, HidePortrait)
	portrait.PostUpdate = PortraitUpdate
	f.Portrait = portrait

    local overlay = CreateFrame("Frame", nil, f)
	overlay:SetFrameLevel(f.Health:GetFrameLevel() - 1)

	f.Health.bg:ClearAllPoints()
	f.Health.bg:SetPoint("BOTTOMLEFT", f.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	f.Health.bg:SetPoint("TOPRIGHT", f.Health)
	f.Health.bg:SetParent(overlay)
end

-- UFs' Infoicons
lib.gen_InfoIcons = function(f)
    if f.mystyle == "player" then
		f.Combat = f:CreateTexture(nil, "OVERLAY")
		f.Combat:SetSize(15, 15)
		f.Combat:SetPoint("BOTTOMRIGHT", 15, -5)
		f.Combat:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
		f.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
    end
	local ri = f:CreateTexture(nil, "OVERLAY")
	ri:SetPoint("TOPRIGHT", f, 0, 8)
	ri:SetSize(14, 14)
	f.LFDRole = ri
    local li = f:CreateTexture(nil, "OVERLAY")
    li:SetPoint("TOPLEFT", f, 0, 8)
    li:SetSize(12, 12)
    f.Leader = li
    local ai = f:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, 0, 8)
    ai:SetSize(12, 12)
    f.Assistant = ai
    local ml = f:CreateTexture(nil, "OVERLAY")
    ml:SetPoint("LEFT", f.Leader, "RIGHT")
    ml:SetSize(10, 10)
    f.MasterLooter = ml
end

lib.addPhaseIcon = function(f)
	local picon = f:CreateTexture(nil, "OVERLAY")
	picon:SetPoint("TOP", f, 0, 12)
	picon:SetSize(22, 22)
	f.PhaseIcon = picon
end

lib.addQuestIcon = function(f)
	local qicon = f:CreateTexture(nil, "OVERLAY")
	qicon:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 8)
	qicon:SetSize(16, 16)
	f.QuestIcon = qicon
end

lib.gen_Resting = function(f)
	local ricon = f:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", -10, 0)
	ricon:SetSize(20, 20)
	f.Resting = ricon
end

lib.gen_RaidMark = function(f)
    local ri = f:CreateTexture(nil, "OVERLAY")
    ri:SetPoint("TOPRIGHT", f, "TOPRIGHT", -30, 10)
	local size = retVal(f, 14, 12, 13)
	ri:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons")
    ri:SetSize(size, size)
    f.RaidIcon = ri
end

lib.gen_highlight = function(f)
    local OnEnter = function(f)
		UnitFrame_OnEnter(f)
		f.Highlight:Show()
    end
    local OnLeave = function(f)
		UnitFrame_OnLeave(f)
		f.Highlight:Hide()
    end
    f:SetScript("OnEnter", OnEnter)
    f:SetScript("OnLeave", OnLeave)
    local hl = f.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(f.Health)
    hl:SetTexture(DB.normTex)
    hl:SetVertexColor(.5, .5, .5, .3)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
end

lib.gen_castbar = function(f)
	if not NDuiDB["UFs"]["Castbars"] then return end

	local cbColor = {95/255, 182/255, 255/255}
    local s = CreateFrame("StatusBar", "oUF_Castbar"..f.mystyle, f)
    s:SetHeight(20)
    s:SetWidth(f:GetWidth() - 22)
    if f.mystyle == "player" then
	    s:SetPoint(unpack(C.UFs.Playercb))
		s:SetSize(unpack(C.UFs.PlayercbSize))
    elseif f.mystyle == "target" then
	    s:SetPoint(unpack(C.UFs.Targetcb))
		s:SetSize(unpack(C.UFs.TargetcbSize))
	elseif f.mystyle == "focus" then
	    s:SetPoint(unpack(C.UFs.Focuscb))
		s:SetSize(unpack(C.UFs.FocuscbSize))
    elseif f.mystyle == "boss" then
	    s:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -19)
		s:SetSize(131, 10)
	end
    s:SetStatusBarTexture(DB.normTex)
    s:SetStatusBarColor(95/255, 182/255, 255/255, 1)
    s:SetFrameLevel(1)
	B.CreateBD(s, .5, .1)
	B.CreateSD(s, 3, 3)

    s.CastingColor = cbColor
    s.CompleteColor = {20/255, 208/255, 0/255}
    s.FailColor = {255/255, 12/255, 0/255}
    s.ChannelingColor = cbColor

    local sp = s:CreateTexture(nil, "OVERLAY")							-- castbar spark
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)

    local txt = lib.gen_fontstring(s, DB.Font[1], 12, "THINOUTLINE")	-- spell name
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")

    local t = lib.gen_fontstring(s, DB.Font[1], 12, "THINOUTLINE")		-- spell time
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)

    local i = s:CreateTexture(nil, "ARTWORK")							-- castbar icon
    i:SetSize(s:GetHeight() + 1, s:GetHeight() + 1)
    i:SetPoint("RIGHT", s, "LEFT", -5, 0)
    i:SetTexCoord(unpack(DB.TexCoord))

    local ibg = CreateFrame("Frame", nil, s)							-- castbar icon shadow
    ibg:SetFrameLevel(0)
    ibg:SetPoint("TOPLEFT", i, "TOPLEFT", -1, 1)
    ibg:SetPoint("BOTTOMRIGHT", i, "BOTTOMRIGHT", 1, -1)
	B.CreateSD(ibg, 2, 3)

    if f.mystyle == "player" then
		local z = s:CreateTexture(nil,"OVERLAY")
		z:SetTexture(DB.normTex)
		z:SetVertexColor(1, 0.1, 0, .6)
		z:SetPoint("TOPRIGHT")
		z:SetPoint("BOTTOMRIGHT")
		s:SetFrameLevel(10)
		s.SafeZone = z
		local l = lib.gen_fontstring(s, DB.Font[1], 10, "THINOUTLINE")
		l:SetPoint("CENTER", -2, 17)
		l:SetJustifyH("RIGHT")
		l:Hide()
		s.Lag = l
		f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
    end
    s.OnUpdate = cast.OnCastbarUpdate
    s.PostCastStart = cast.PostCastStart
    s.PostChannelStart = cast.PostCastStart
    s.PostCastStop = cast.PostCastStop
    s.PostChannelStop = cast.PostChannelStop
    s.PostCastFailed = cast.PostCastFailed
    s.PostCastInterrupted = cast.PostCastFailed

    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
end

lib.gen_mirrorcb = function(f)
    for _, bar in pairs({"MirrorTimer1","MirrorTimer2","MirrorTimer3",}) do   
		for i, region in pairs({_G[bar]:GetRegions()}) do
			if (region.GetTexture and region:GetTexture() == DB.normTex) then
				region:Hide()
			end
		end
		_G[bar.."Border"]:Hide()
		_G[bar]:SetParent(UIParent)
		_G[bar]:SetScale(1)
		_G[bar]:SetHeight(15)
		_G[bar]:SetWidth(280)
		_G[bar.."Background"] = _G[bar]:CreateTexture(bar.."Background", "BACKGROUND", _G[bar])
		_G[bar.."Background"]:SetTexture(DB.normTex)
		_G[bar.."Background"]:SetAllPoints(bar)
		_G[bar.."Background"]:SetVertexColor(.15, .15, .15, .7)
		_G[bar.."Text"]:SetFont(DB.Font[1], 13)
		_G[bar.."Text"]:ClearAllPoints()
		_G[bar.."Text"]:SetPoint("CENTER", MirrorTimer1StatusBar, 0, 1)
		_G[bar.."StatusBar"]:SetAllPoints(_G[bar])
		--glowing borders
		B.CreateBD(_G[bar], .5, .1)
		B.CreateSD(_G[bar], 3, 3)
    end
end

-- Auras Relevant
local formatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

local setTimer = function (self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = formatTime(self.timeLeft)
					self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local postCreateIcon = function(element, button)
	local self = element:GetParent()
	element.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true
	B.CreateSD(button, 3, 3)

	local time = lib.gen_fontstring(button, DB.Font[1], self.fontsize, "THINOUTLINE")
	time:SetPoint("CENTER", button, "CENTER", 1, 0)
	time:SetJustifyH("CENTER")
	time:SetVertexColor(1,1,1)
	button.time = time

	local count = lib.gen_fontstring(button, DB.Font[1], self.fontsize, "THINOUTLINE")
	count:SetPoint("CENTER", button, "BOTTOMRIGHT", 0, 3)
	count:SetJustifyH("RIGHT")
	button.count = count

	button.icon:SetTexCoord(unpack(DB.TexCoord))
	button.icon:SetDrawLayer("ARTWORK")
end

local postUpdateIcon = function(element, unit, button, index)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, button.filter)

	if duration and duration > 0 then
		button.time:Show()
		button.timeLeft = expirationTime	
		button:SetScript("OnUpdate", setTimer)			
	else
		button.time:Hide()
		button.timeLeft = math.huge
		button:SetScript("OnUpdate", nil)
	end

	-- Desaturate non-Player Debuffs
	if(button.debuff) then
		if(unit == "target" or unit == "focus") then	
			if (unitCaster == "player" or unitCaster == "vehicle") then
				button.icon:SetDesaturated(false)
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don"t desaturate debuffs
				button:SetBackdropColor(0, 0, 0)
				button.overlay:SetVertexColor(0.3, 0.3, 0.3)
				button.icon:SetDesaturated(true)  
			end
		end
	end
	button:SetScript("OnMouseUp", function(self, mouseButton)
		if mouseButton == "RightButton" then
			CancelUnitBuff("player", index)
		end
	end)
	button.first = true
end

lib.createAuras = function(f)
	local Auras = CreateFrame("Frame", nil, f)
	Auras.size = 20
	Auras:SetHeight(41)
	Auras:SetWidth(f:GetWidth())
	Auras.spacing = 8
	f.fontsize = Auras.size*0.6
	if f.mystyle == "target" then
		Auras:SetPoint("BOTTOMLEFT", f, 0, -48)
		Auras.numBuffs = 20
		Auras.numDebuffs = 15
		Auras.spacing = 6
		Auras.size = 22
	end
	if f.mystyle == "tot" then
		Auras:SetPoint("LEFT", f, "LEFT", 0, -12)
		Auras.numBuffs = 0
		Auras.numDebuffs = 10
		Auras.spacing = 5
		Auras.size = 19
	end
	if f.mystyle == "focus" then
		Auras:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, 9)
		Auras.numBuffs = 0
		Auras.numDebuffs = 8
		Auras.spacing = 7
		Auras.size = 26
	end
	Auras.gap = true
	Auras.initialAnchor = "BOTTOMLEFT"
	Auras["growth-x"] = "RIGHT"
	Auras["growth-y"] = "DOWN"
	Auras.PostCreateIcon = postCreateIcon
	Auras.PostUpdateIcon = postUpdateIcon

	f.Auras = Auras
end

lib.createBuffs = function(f)
    local b = CreateFrame("Frame", nil, f)
	b.size = 20
    b.spacing = 5
    b.onlyShowPlayer = false
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f:GetWidth())
	f.fontsize = b.size*0.6
    if f.mystyle == "target" then
		b:SetPoint("TOP", f, "TOP", 0, 51)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "UP"
	    b.num = 10
    elseif f.mystyle == "player" then
	    b.size = 28
		b:SetPoint("TOPRIGHT", UIParent,  -180, -10)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 40
    elseif f.mystyle == "boss" then
	    b.size = 22
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, 0)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 6
	elseif f.mystyle == "oUF_Arena" then
	    b.size = 20
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, 0)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 10
	else
		b.num = 0
    end
    b.PostCreateIcon = postCreateIcon
    b.PostUpdateIcon = postUpdateIcon

    f.Buffs = b
end

lib.createDebuffs = function(f)
    local b = CreateFrame("Frame", nil, f)
    b.size = 20
	b.num = 18
	b.onlyShowPlayer = false
    b.spacing = 5
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f:GetWidth())
	f.fontsize = b.size*0.6
	if f.mystyle == "target" then
		b:SetPoint("TOP", f, "TOP", 0, 25)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "UP"
	elseif f.mystyle == "player" then
		b:SetPoint("BOTTOMRIGHT", f, 0, -48)
		b.initialAnchor = "BOTTOMRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
	    b.size = 22
		b.spacing = 6
	elseif f.mystyle == "boss" then
	    b.size = 22
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, -25)
		b.initialAnchor = "TOPRIGHT"
		b.onlyShowPlayer = true
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 6
	elseif f.mystyle == "oUF_Arena" then
	    b.size = 20
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", 8, 0)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "DOWN"
		b.num = 5
	else
		b.num = 0
	end
    b.PostCreateIcon = postCreateIcon
    b.PostUpdateIcon = postUpdateIcon

    f.Debuffs = b
end

-- Class Resources
local margin = C.UFs.BarMargin
local width, height = unpack(C.UFs.BarSize)

local function PostUpdateClassIcon(element, cur, max, diff, event)
	if(diff or event == "ClassPowerEnable") then
		for i = 1, max do
			local bar = element[i]
			bar:SetWidth((width - (max-1)*margin)/max)
		end
	end
end

local function genResourcebar(self)
	local bars = {}
	for i = 1, 6 do
		bars[i] = CreateFrame("StatusBar", nil, self)
		bars[i]:SetHeight(height)
		bars[i]:SetFrameLevel(self:GetFrameLevel() + 2)
		bars[i]:SetStatusBarTexture(DB.normTex)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetStatusBarColor(228/255, 225/255, 16/255)
		B.CreateSD(bars[i], 3, 3)
		if i == 1 then
			bars[i]:SetPoint(unpack(C.UFs.BarPoint))
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", margin, 0)
		end
	end

	bars.PostUpdate = PostUpdateClassIcon
	bars.margin = margin
	self.ClassIcons = bars
end

lib.genHolyPower = function(self)
	if DB.MyClass ~= "PALADIN" then return end
	genResourcebar(self)
end

lib.genHarmony = function(self)
	if DB.MyClass ~= "MONK" then return end
	genResourcebar(self)
end

lib.genShadowOrbs = function(self)
	if DB.MyClass ~= "PRIEST" then return end
	genResourcebar(self)
end

lib.genWarlockSpecBars = function(self)
	if DB.MyClass ~= "WARLOCK" then return end
	local bars = {}
	for i = 1, 4 do
		bars[i] = CreateFrame("StatusBar", nil, self)
		bars[i]:SetHeight(height)
		bars[i]:SetFrameLevel(self:GetFrameLevel() + 2)
		bars[i]:SetStatusBarTexture(DB.normTex)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		B.CreateSD(bars[i], 3, 3)
		if i == 1 then
			bars[i]:SetPoint(unpack(C.UFs.BarPoint))
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", margin, 0)
		end
		bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
		bars[i].bg:SetAllPoints()
		bars[i].bg:SetTexture(DB.normTex)

		bars[1].text = lib.gen_fontstring(bars[1], DB.Font[1], 14, "THINOUTLINE")
		bars[1].text:SetPoint("CENTER", 0, 1)
		bars[1].text:Hide()
		self:Tag(bars[1].text, "|cff5fde5f[curdemon]")
	end

	bars.width = width
	bars.margin = margin
	self.WarlockSpecBars = bars
end

lib.genRunes = function(self)
	if DB.MyClass ~= "DEATHKNIGHT" then return end
	local runes, bars = CreateFrame("Frame", nil, self), {}
	runes:SetPoint(unpack(C.UFs.BarPoint))
	runes:SetFrameLevel(self:GetFrameLevel() + 2)
	runes:SetSize(unpack(C.UFs.BarSize))
	for i = 1, 6 do
		bars[i] = CreateFrame("StatusBar", nil, runes)
		bars[i]:SetHeight(runes:GetHeight())
		bars[i]:SetWidth((runes:GetWidth() - 5*margin) / 6)
		bars[i]:SetStatusBarTexture(DB.normTex)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		B.CreateSD(bars[i], 3, 3)
		if (i == 1) then
			bars[i]:SetPoint("LEFT", runes)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", margin, 0)
		end
		bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
		bars[i].bg:SetAllPoints()
		bars[i].bg:SetTexture(DB.normTex)
		bars[i].bg.multiplier = 0.2
	end

	self.Runes = bars
end

lib.genCPoints = function(self)
	local color = {{0.8, 0.1, 0.1};{0.8, 0.3, 0.1};{0.9, 0.6, 0.1};{0.6, 0.9, 0.1};{0.1, 0.9, 0.1}}
	local cp, bars = CreateFrame("Frame", nil, self), {}
	cp:SetPoint(unpack(C.UFs.BarPoint))
	cp:SetFrameLevel(self:GetFrameLevel() + 2)
	cp:SetSize(unpack(C.UFs.BarSize))
	for i = 1, 5 do
		bars[i] = CreateFrame("StatusBar", nil, cp)
		bars[i]:SetHeight(cp:GetHeight())
		bars[i]:SetWidth((cp:GetWidth() - 4*margin)/5)
		bars[i]:SetStatusBarTexture(DB.normTex)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
		bars[i]:SetStatusBarColor(unpack(color[i]))
		B.CreateSD(bars[i], 3, 3)
		if i == 1 then
			bars[i]:SetPoint("LEFT", cp)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", margin, 0)
		end
	end

	self.CPoints = bars
	self.CPoints.Parent = cp
end

lib.TotemBars = function(self)
	if DB.MyClass ~= "SHAMAN" then return end
	local TotemBar, Totems = CreateFrame("Frame", nil, self), {}
	TotemBar:SetPoint(unpack(C.UFs.BarPoint))
	TotemBar:SetFrameLevel(self:GetFrameLevel() + 2)
	TotemBar:SetSize(unpack(C.UFs.BarSize))
	for i = 1, 4 do
		Totems[i] = CreateFrame("StatusBar", nil, TotemBar)
		Totems[i]:SetHeight(TotemBar:GetHeight())
		Totems[i]:SetWidth((TotemBar:GetWidth() - 3*margin)/4)
		Totems[i]:SetStatusBarTexture(DB.normTex)
		Totems[i]:GetStatusBarTexture():SetHorizTile(false)
		B.CreateSD(Totems[i], 3, 3)
		if (i == 1) then
			Totems[i]:SetPoint("LEFT", TotemBar, "LEFT", 0, 0)
		else
			Totems[i]:SetPoint("TOPLEFT", Totems[i-1], "TOPRIGHT", margin, 0)
		end

		Totems[i].Time = lib.gen_fontstring(Totems[i], DB.Font[1], 14, "THINOUTLINE")
		Totems[i].Time:SetPoint("CENTER", 0, 1)
	end

	Totems.colors = {{233/255, 46/255, 16/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}
	self.TotemBar = Totems
end

lib.addEclipseBar = function(self)
	if DB.MyClass ~= "DRUID" then return end
	local eclipseBar = CreateFrame("Frame", nil, self)
	eclipseBar:SetPoint(unpack(C.UFs.BarPoint))
	eclipseBar:SetFrameLevel(self:GetFrameLevel() + 2)
	eclipseBar:SetSize(unpack(C.UFs.BarSize))
	B.CreateSD(eclipseBar, 3, 3)

	local lunarBar = CreateFrame("StatusBar", nil, eclipseBar)
	lunarBar:SetPoint("LEFT", eclipseBar, "LEFT", 0, 0)
	lunarBar:SetWidth(eclipseBar:GetWidth())
	lunarBar:SetHeight(eclipseBar:GetHeight())
	lunarBar:SetStatusBarTexture(DB.normTex)
	lunarBar:SetStatusBarColor(0, 0, 1)
	eclipseBar.LunarBar = lunarBar

	local solarBar = CreateFrame("StatusBar", nil, eclipseBar)
	solarBar:SetPoint("LEFT", lunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
	solarBar:SetWidth(eclipseBar:GetWidth())
	solarBar:SetHeight(eclipseBar:GetHeight())
	solarBar:SetStatusBarTexture(DB.normTex)
	solarBar:SetStatusBarColor(1, 3/5, 0)
	eclipseBar.SolarBar = solarBar

	local eclipseBarText = lib.gen_fontstring(solarBar, DB.Font[1], 14, "THINOUTLINE")
	eclipseBarText:SetPoint("CENTER", eclipseBar, "CENTER", 0, 1)
	self:Tag(eclipseBarText, "[pereclipse]")

	self.EclipseBar = eclipseBar
end

local function AltPowerBarOnToggle(self)
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
end
local function AltPowerBarPostUpdate(self, min, cur, max)
	local perc = math.floor((cur/max)*100)
	if perc < 35 then
		self:SetStatusBarColor(0, 1, 0)
	elseif perc < 70 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
	local type = select(10, UnitAlternatePowerInfo(unit))
end
lib.AltPowerBar = function(self)
	local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
	AltPowerBar:SetStatusBarTexture(DB.normTex)
	AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
	AltPowerBar:EnableMouse(true)
	if self.unit == "boss" then
		AltPowerBar:SetPoint("BOTTOM", self, "BOTTOM", 0, -2)
		AltPowerBar:SetWidth(self:GetWidth() - 30)
		AltPowerBar:SetHeight(5)
	else
		AltPowerBar:SetPoint("BOTTOM", self, "BOTTOM", 0, -12)
		AltPowerBar:SetWidth(self:GetWidth())
		AltPowerBar:SetHeight(5)
	end
	B.CreateBD(AltPowerBar, .5, .1)
	B.CreateSD(AltPowerBar, 3, 3)

	local AltPowerBarText = lib.gen_fontstring(AltPowerBar, DB.Font[1], 14, "THINOUTLINE")
	AltPowerBarText:SetPoint("CENTER")
	AltPowerBarText:SetJustifyH("CENTER")
	self:Tag(AltPowerBarText, "[altpower]")

	AltPowerBar:HookScript("OnShow", AltPowerBarOnToggle)
	AltPowerBar:HookScript("OnHide", AltPowerBarOnToggle)
	self.AltPowerBar = AltPowerBar		
	self.AltPowerBar.PostUpdate = AltPowerBarPostUpdate
end

lib.Experience = function(self)
	local Experience = CreateFrame("StatusBar", nil, self)
	Experience:SetStatusBarTexture(DB.normTex)
	Experience:SetStatusBarColor(0, 0.7, 1)
	Experience:SetPoint("TOPRIGHT", oUF_Player, "TOPRIGHT", 9, 0)
	Experience:SetHeight(30)
	Experience:SetWidth(5)
	Experience:SetFrameLevel(2)
	Experience:SetOrientation("VERTICAL")
	B.CreateBD(Experience, .5, .1)
	B.CreateSD(Experience, 3, 3)

	local Rested = CreateFrame("StatusBar", nil, Experience)
	Rested:SetStatusBarTexture(DB.normTex)
	Rested:SetStatusBarColor(0, 0.4, 1, 0.6)
	Rested:SetFrameLevel(2)
	Rested:SetOrientation("VERTICAL")
	Rested:SetAllPoints(Experience)

	Experience.Tooltip = true
	self.Experience = Experience
	self.Experience.Rested = Rested
	self.Experience.PostUpdate = ExperiencePostUpdate
end

local UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
end
lib.Reputation = function(self)
	local Reputation = CreateFrame("StatusBar", nil, self)
	Reputation:SetStatusBarTexture(DB.normTex)
	Reputation:SetPoint("TOPLEFT", oUF_Player, "TOPLEFT", -9, 0)
	Reputation:SetWidth(5)
	Reputation:SetHeight(30)
	Reputation:SetFrameLevel(2)
	Reputation:SetOrientation("VERTICAL")
	B.CreateBD(Reputation, .5, .1)
	B.CreateSD(Reputation, 3, 3)

	Reputation.Tooltip = true
	Reputation.PostUpdate = UpdateReputationColor
	self.Reputation = Reputation
end

lib.HealPrediction = function(self)
	if not NDuiDB["UFs"]["HealPrediction"] then return end

	local mhpb = self:CreateTexture(nil, "ARTWORK", 5)
	mhpb:SetWidth(1)
	mhpb:SetTexture(DB.normTex)
	mhpb:SetVertexColor(0, 1, 0.5, .4)

	local ohpb = self:CreateTexture(nil, "ARTWORK", 5)
	ohpb:SetWidth(1)
	ohpb:SetTexture(DB.normTex)
	ohpb:SetVertexColor(0, 1, 0, .4)

	local abb = self:CreateTexture(nil, "ARTWORK", 5)
	abb:SetWidth(1)
	abb:SetTexture(DB.normTex)
	abb:SetVertexColor(.66, 1, 1, .7)

	local abbo = self:CreateTexture(nil, "ARTWORK", 1)
	abbo:SetAllPoints(abb)
	abbo:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
	abbo.tileSize = 32

	local oag = self:CreateTexture(nil, "ARTWORK", 1)
	oag:SetWidth(15)
	oag:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
	oag:SetBlendMode("ADD")
	oag:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -5, 2)
	oag:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -5, -2)

	self.HealPredictionAndAbsorb = {
		myBar = mhpb,
		otherBar = ohpb,
		absorbBar = abb,
		absorbBarOverlay = abbo,
		overAbsorbGlow = oag,
		maxOverflow = 1.01,
	}
end
ns.lib = lib