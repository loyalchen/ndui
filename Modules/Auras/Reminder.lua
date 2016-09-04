local B, C, L, DB = unpack(select(2, ...))

local tab = DB.ReminderBuffs[DB.MyClass]
if not tab then tab = {} end
local function OnEvent(self)
	if UnitLevel("player") < 10 then return end
	local group = tab[self.id]
	if not group.spells and not group.weapon and not group.stance then return end
	if not GetActiveSpecGroup() then return end
	if group.level and UnitLevel("player") < group.level then return end

	self.icon:SetTexture(nil)
	self:Hide()
	if group.negate_spells then
		for buff, value in pairs(group.negate_spells) do
			if value == true then
				local name = GetSpellInfo(buff)
				if (name and UnitBuff("player", name)) then
					return
				end
			end
		end
	end

	local hasOffhandWeapon = OffhandHasWeapon()
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
	if group.spells then
		for buff, value in pairs(group.spells) do
			if value == true then
				local name = GetSpellInfo(buff)
				local usable, nomana = IsUsableSpell(name)
				if (usable or nomana) then
					self.icon:SetTexture(select(3, GetSpellInfo(buff)))
					break
				end
			end
		end
	elseif group.weapon then
		if hasOffhandWeapon == nil then
			if hasMainHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		else
			if hasOffHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 17))
			end
			
			if hasMainHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		end
	elseif group.stance and GetNumShapeshiftForms() > 0 then
		local index = GetShapeshiftForm()
        if index < 1 or index > GetNumShapeshiftForms() then
			self.icon:SetTexture(GetShapeshiftFormInfo(1))
        end
	end

	local role = group.role
	local tree = group.tree
	local talent = group.talent
	local combat = group.combat
	local personal = group.personal
	local instance = group.instance
	local pvp = group.pvp
	local reversecheck = group.reversecheck
	local negate_reversecheck = group.negate_reversecheck
	local rolepass, treepass, talentpass, combatpass, instancepass, pvppass
	local inInstance, instanceType = IsInInstance()

	if role ~= nil then
		if role == DB.Role then
			rolepass = true
		else
			rolepass = false
		end
	else
		rolepass = true
	end

	if tree ~= nil then
		if tree == GetSpecialization() then
			treepass = true
		else
			treepass = false	
		end
	else
		treepass = true
	end

	if talent ~= nil then
		for t = 1, 7 do
			for c = 1, 3 do
				local talentID, _, _, selected = GetTalentInfo(t, c, GetActiveSpecGroup())
				if selected then
					if talent == talentID then
						talentpass = true
					else
						talentpass = false
					end
				end
			end
		end
	else
		talentpass = true
	end

	if combat and UnitAffectingCombat("player") then
		combatpass = true
	else
		combatpass = false
	end

	if instance and inInstance and (instanceType == "scenario" or instanceType == "party" or instanceType == "raid") then
		instancepass = true
	else
		instancepass = false
	end

	if pvp and (instanceType == "arena" or instanceType == "pvp" or GetZonePVPInfo() == "combat") then
		pvppass = true
	else
		pvppass = false
	end

	if not instance and not pvp then
		instancepass = true
		pvp = true
	end

	--Prevent user error
	if reversecheck ~= nil and (role == nil and tree == nil) then reversecheck = nil end

	if group.spells then
		if treepass and rolepass and talentpass and (combatpass or instancepass or pvppass) and not (UnitInVehicle("player") and self.icon:GetTexture()) then	
			for buff, value in pairs(group.spells) do
				if value == true then
					local name
					if GetSpellInfo(buff) == nil then return else name = GetSpellInfo(buff) end
					local _, _, icon, _, _, _, _, unitCaster, _, _, _ = UnitBuff("player", name)
					if personal and personal == true then
						if (name and icon and unitCaster == "player") then
							self:Hide()
							return
						end
					else
						if (name and icon) then
							self:Hide()
							return
						end
					end
				end
			end
			self:Show()
			B.CreateFS(self, 14, LACK.." "..self.id, "BOTTOM", 0, -18)
		elseif (combatpass or instancepass or pvppass) and reversecheck and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			if negate_reversecheck and negate_reversecheck == GetSpecialization() then self:Hide() return end
			for buff, value in pairs(group.spells) do
				if value == true then
					local name = GetSpellInfo(buff)
					local _, _, icon, _, _, _, _, unitCaster, _, _, _ = UnitBuff("player", name)
					if (name and icon and unitCaster == "player") then
						self:Show()
						B.CreateFS(self, 14, CANCEL.." "..self.id, "BOTTOM", 0, -18)
						return
					end	
				end
			end
		end
	elseif group.weapon then
		if treepass and rolepass and talentpass and (combatpass or instancepass or pvppass) and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			if not hasOffhandWeapon then
				if not hasMainHandEnchant then
					self:Show()
					B.CreateFS(self, 14, LACK.." "..self.id, "BOTTOM", 0, -18)
					self.icon:SetTexture(GetInventoryItemTexture("player", 16))
				end
			else
				if (not hasMainHandEnchant or not hasOffHandEnchant) then	
					self:Show()
					B.CreateFS(self, 14, LACK.." "..self.id, "BOTTOM", 0, -18)
					if not hasMainHandEnchant then
						self.icon:SetTexture(GetInventoryItemTexture("player", 16))
					else
						self.icon:SetTexture(GetInventoryItemTexture("player", 17))
					end
				end
			end
		end
	elseif group.stance then
		if treepass and rolepass and talentpass and (combatpass or instancepass or pvppass) and not (UnitInVehicle("player") and self.icon:GetTexture()) then
		    local index = GetShapeshiftForm()
            if index < 1 or index > GetNumShapeshiftForms() then
                self:Show()
				B.CreateFS(self, 14, LACK.." "..self.id, "BOTTOM", 0, -18)
                self.icon:SetTexture(GetShapeshiftFormInfo(1))
            end
        end
	end
end

local i = 0
for groupName, _ in pairs(tab) do
	i = i + 1
	local frame = CreateFrame("Frame", "ReminderFrame"..i, UIParent)
	frame:SetSize(42,42)
	frame:SetPoint("CENTER", UIParent, "CENTER", -220, 130)
	frame:SetFrameLevel(1)
	frame.id = groupName
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetTexCoord(unpack(DB.TexCoord))
	frame.icon:SetAllPoints()
	frame:Hide()
	B.CreateSD(frame, 4, 4)

	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")
	frame:SetScript("OnEvent", function(self)
		if not NDuiDB["Reminder"]["Enable"] then return end
		OnEvent(self)
	end)
	frame:SetScript("OnUpdate", function(self, elapsed)
		if not self.icon:GetTexture() then
			self:Hide()
		end
	end)
	frame:SetScript("OnShow", function(self)
		if not self.icon:GetTexture() then
			self:Hide()
		end
	end)
end