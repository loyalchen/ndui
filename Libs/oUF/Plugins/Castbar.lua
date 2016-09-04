local addon, ns = ...
local cast = CreateFrame("Frame")  

local channelingTicks = {
	-- warlock
	[GetSpellInfo(689)] = 6,		-- drain life
	[GetSpellInfo(103103)] = 4,		-- drain soul
	[GetSpellInfo(1949)] = 15, 		-- hellfire
	[GetSpellInfo(755)] = 3, 		-- health funnel
	[GetSpellInfo(103103)] = 4, 	-- malefic grasp
	-- druid
	[GetSpellInfo(740)] = 4,		-- Tranquility
	[GetSpellInfo(16914)] = 10,		-- Hurricane
	-- priest
	[GetSpellInfo(15407)] = 3,		-- mind flay
	[GetSpellInfo(129197)] = 3, 	-- insanity
	[GetSpellInfo(48045)] = 5, 		-- mind sear
	[GetSpellInfo(47540)] = 3,		-- penance
	[GetSpellInfo(64843)] = 4,		-- divine hymn
	-- mage
	[GetSpellInfo(5143)] = 5, 		-- arcane missiles
	[GetSpellInfo(10)] = 7, 		-- blizzard
	[GetSpellInfo(12051)] = 3, 		-- evocation
	-- monk
	[GetSpellInfo(101546)] = 3, 	-- spinning crane kick
	[GetSpellInfo(115175)] = 9, 	-- smoothing mist
}
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LEVEL_UP")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	local myclass, mfTicks = select(2, UnitClass("player")), 3
	if myclass == "PRIEST" and IsSpellKnown(157223) then -- Enhanced Mind Flay
		mfTicks = 4
		self:UnregisterEvent("PLAYER_LEVEL_UP")
	end

	channelingTicks[GetSpellInfo(15407)] = mfTicks -- mind flay
	channelingTicks[GetSpellInfo(129197)] = mfTicks -- insanity
end)
local ticks = {}
cast.setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture("Interface\\Addons\\NDui\\Media\\normTex")
				ticks[k]:SetVertexColor(0, 0, 0, 0.7)
				ticks[k]:SetWidth(1.2)
				ticks[k]:SetHeight(castBar:GetHeight())
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end
cast.OnCastbarUpdate = function(self, elapsed)
	if not self.Lag then self.Lag = 0 end
	if GetNetStats() == 0 then return end
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		if parent.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('%.2f | |cffff0000%.2f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText('%.2f | %.2f', duration, self.max)
				if self.SafeZone and self.SafeZone.timeDiff ~= 0 then self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000) end
			end
		else
			self.Time:SetFormattedText('%.2f | %.2f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end
cast.OnCastSent = function(self, event, unit, spell, rank)
	if self.unit ~= unit or not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
	self.Castbar.SafeZone.castSent = true
end
cast.PostCastStart = function(self, unit, name, rank, text)
	local pcolor = {255/255, 128/255, 128/255}
	local interruptcb = {95/255, 182/255, 255/255}
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	if unit == "vehicle" then 
		self.SafeZone:Hide()
		self.Lag:Hide()
	elseif unit == "player" then
		if GetNetStats() == 0 then return end
		local sf = self.SafeZone
		if not sf then return end
		sf.timeDiff = 0
		self.Lag:SetText("")
		if sf.castSent == true then
			sf.timeDiff = GetTime() - sf.sendTime
			sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
			sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
			sf:Show()
			sf.castSent = false
		end
		if not UnitInVehicle("player") then sf:Show() self.Lag:Show() else sf:Hide() self.Lag:Hide() end
		if self.casting then
			cast.setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			cast.setBarTicks(self, self.channelingTicks)
		end
	elseif (unit == "target" or unit == "focus") and not self.interrupt then
		self:SetStatusBarColor(interruptcb[1],interruptcb[2],interruptcb[3],1)
	else
		self:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
	end
end
cast.PostCastStop = function(self, unit, name, rank, castid)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end
cast.PostChannelStop = function(self, unit, name, rank)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end
cast.PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end
ns.cast = cast