local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

local function GetLFDRole(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "NONE" then
		return DB.GreyColor..NONE.."|r"
	elseif role == "TANK" then
		return "|cFFE06D1B"..TANK.."|r"
	elseif role == "HEALER" then
		return "|cFF1B70E0"..HEALER.."|r"
	else
		return "|cFFE01B35"..DAMAGER.."|r"
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
	local name, unit = GameTooltip:GetUnit()
	if(unit and UnitIsPlayer(unit) and IsInGroup(unit))then
		GameTooltip:AddLine(ROLE..": " .. GetLFDRole(unit))
	end
end)