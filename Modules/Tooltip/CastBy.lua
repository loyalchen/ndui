local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

local cc = {}
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
do
	for class, c in pairs(CUSTOM_CLASS_COLORS) do
		cc[class] = format('|cff%02x%02x%02x', c.r*255, c.g*255, c.b*255)
	end
end

local function SetCaster(self, unit, index, filter)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, filter)
	if unitCaster then
		local uname, urealm = UnitName(unitCaster)
		local _, uclass = UnitClass(unitCaster)
		if urealm then uname = uname..'-'..urealm end
		self:AddDoubleLine(CAST_BY..":", (cc[uclass] or '|cffffffff')..uname..'|r')
		self:Show()
	end
end
hooksecurefunc(GameTooltip, 'SetUnitAura', SetCaster)