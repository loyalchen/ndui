local parent, ns = ...
local oUF = ns.oUF

local GetComboPoints = GetComboPoints
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local Update = function(self, event, unit)
	if(unit == 'pet') then return end

	local cpoints = self.CPoints
	if(cpoints.PreUpdate) then
		cpoints:PreUpdate()
	end

	local cp
	if(UnitHasVehicleUI'player') then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end

	for i=1, MAX_COMBO_POINTS do
		if(i <= cp) then
			cpoints[i]:SetAlpha(1)
		else
			cpoints[i]:SetAlpha(0.3)
		end
		if cpoints[1]:GetAlpha() == 1 then
			cpoints[i]:Show()
		else
			cpoints[i]:Hide()
		end
	end

	if(cpoints.PostUpdate) then
		return cpoints:PostUpdate(cp)
	end
end

local UPDATE_VISIBILITY = function(self, event)
	local cpoints = self.CPoints
	local cp = cpoints.Parent
	local myclass = select(2,UnitClass('player'))
	if myclass == "DRUID" then
		if GetShapeshiftFormID() == CAT_FORM then
			cp:Show()
		else
			cp:Hide()
		end
	end
	if(cpoints.PostUpdateVisibility) then
		return cpoints:PostUpdateVisibility(self.unit)
	end
end

local Path = function(self, ...)
	return (self.CPoints.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local cpoints = self.CPoints
	if(cpoints) then
		cpoints.__owner = self
		cpoints.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_COMBO_POINTS', Path, true)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', Path, true)
		self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', UPDATE_VISIBILITY, true)
		self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', UPDATE_VISIBILITY, true)

		for index = 1, MAX_COMBO_POINTS do
			local cpoint = cpoints[index]
			if(cpoint:IsObjectType'Texture' and not cpoint:GetTexture()) then
				cpoint:SetTexture[[Interface\ComboFrame\ComboPoint]]
				cpoint:SetTexCoord(0, 0.375, 0, 1)
			end
		end

		return true
	end
end

local Disable = function(self)
	local cpoints = self.CPoints
	if(cpoints) then
		for index = 1, MAX_COMBO_POINTS do
			cpoints[index]:Hide()
		end
		self:UnregisterEvent('UNIT_COMBO_POINTS', Path)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
		self:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED', UPDATE_VISIBILITY, true)
		self:UnregisterEvent('UPDATE_SHAPESHIFT_FORM', UPDATE_VISIBILITY, true)
	end
end

oUF:AddElement('CPoints', Path, Enable, Disable)