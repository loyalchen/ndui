local _, ns = ...
local oUF = ns.oUF or oUF

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local MAX_POWER_PER_EMBER = 10
local SPELL_POWER_DEMONIC_FURY = SPELL_POWER_DEMONIC_FURY
local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY
local LATEST_SPEC = 0

local Colors = { 
	[1] = {148/255, 130/255, 201/255, 1},
	[2] = {95/255, 222/255,  95/255, 1},
	[3] = {222/255, 50/255,  50/255, 1},
}

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "BURNING_EMBERS" and powerType ~= "SOUL_SHARDS" and powerType ~= "DEMONIC_FURY")) then return end
	local wsb = self.WarlockSpecBars
	if(wsb.PreUpdate) then wsb:PreUpdate(unit) end
	
	local spec = GetSpecialization()
	if spec then
		if (spec == SPEC_WARLOCK_DESTRUCTION) then	
			local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
			local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
			local numEmbers = power / MAX_POWER_PER_EMBER
			local numBars = floor(maxPower / MAX_POWER_PER_EMBER)
			for i = 1, numBars do
				wsb[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER, MAX_POWER_PER_EMBER * i)
				wsb[i]:SetValue(power)
				wsb[i]:SetAlpha(1)
				if power < MAX_POWER_PER_EMBER * i then
					wsb[i]:SetStatusBarColor(.8, .7, .3)
				else
					wsb[i]:SetStatusBarColor(unpack(Colors[spec]))
				end
			end
		elseif ( spec == SPEC_WARLOCK_AFFLICTION ) then
			local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
			local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)	
			for i = 1, maxShards do
				if i <= numShards then
					wsb[i]:SetAlpha(1)
				else
					wsb[i]:SetAlpha(.3)
				end
			end
		elseif spec == SPEC_WARLOCK_DEMONOLOGY then
			local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
			local maxPower = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)
			wsb[1]:SetMinMaxValues(0, maxPower)
			wsb[1]:SetValue(power)
			wsb[1]:SetAlpha(1)
		end

		for i = 1, 4 do
			if(wsb[i].bg) then
				wsb[i].bg:SetVertexColor(unpack(Colors[spec]))
				wsb[i].bg:SetAlpha(0.3)
			end
		end
	end

	if(wsb.PostUpdate) then
		return wsb:PostUpdate(spec)
	end
end

local function Visibility(self, event, unit)
	local wsb = self.WarlockSpecBars
	local spacing = select(4, wsb[4]:GetPoint())
	local w = wsb.width
	local s = wsb.margin or 2
	local spec = GetSpecialization()
	if spec then
		for i = 1, 4 do
			wsb[i]:Show()
		end
		if LATEST_SPEC ~= spec then
			for i = 1, 4 do
				local max = select(2, wsb[i]:GetMinMaxValues())
				if spec == SPEC_WARLOCK_AFFLICTION then
					wsb[i]:SetValue(max)
				else
					wsb[i]:SetValue(0)
				end
				wsb[i]:Show()
				if wsb[i].bg then wsb[i].bg:SetAlpha(0) end
			end
			if wsb[1].text then wsb[1].text:Hide() end
		end
		if spec == SPEC_WARLOCK_DESTRUCTION then
			local maxembers = 4
			for i = 1, maxembers do
				if i ~= maxembers then
					wsb[i]:SetWidth(w / maxembers - spacing)
					s = s + (w / maxembers)
				else
					wsb[i]:SetWidth(w - s)
				end
				wsb[i]:SetStatusBarColor(unpack(Colors[spec]))
			end
			if wsb[1].text then wsb[1].text:Hide() end
		elseif spec == SPEC_WARLOCK_AFFLICTION then
			local maxshards = 4
			for i = 1, maxshards do
				if i ~= maxshards then
					wsb[i]:SetWidth(w / maxshards - spacing)
					s = s + (w / maxshards)
				else
					wsb[i]:SetWidth(w - s)
				end
				wsb[i]:SetStatusBarColor(unpack(Colors[spec]))
			end
			if wsb[1].text then wsb[1].text:Hide() end
		elseif spec == SPEC_WARLOCK_DEMONOLOGY then
			for i = 1, 4 do
				wsb[i]:Hide()
				wsb[1]:Show()
				wsb[1]:SetWidth(w)
				wsb[1]:SetStatusBarColor(unpack(Colors[spec]))
				if wsb[i].bg then
					wsb[1].bg:SetVertexColor(0, 0, 0)
				end
			end
			if wsb[1].text then wsb[1].text:Show() end
		end
		Update(self, nil, "player")
	else
		for i = 1, 4 do
			wsb[i]:Hide()
		end
	end

	LATEST_SPEC = spec
end

local Path = function(self, ...)
	return (self.WarlockSpecBars.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit, "SOUL_SHARDS")
end

local function Enable(self)
	local wsb = self.WarlockSpecBars
	if(wsb) then
		wsb.__owner = self
		wsb.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Visibility)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Visibility)

		for i = 1, 4 do
			local Point = wsb[i]
			if not Point:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end
			Point:Hide()
		end
		return true
	end
end

local function Disable(self)
	local wsb = self.WarlockSpecBars
	if(wsb) then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Visibility)
		wsb.Visibility:UnregisterEvent("PLAYER_TALENT_UPDATE")
	end
end

oUF:AddElement("WarlockSpecBars", Path, Enable, Disable)