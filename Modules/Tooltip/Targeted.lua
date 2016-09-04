local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

local function ScanTargets(unit)
	if not IsInGroup() then return end

	local targetTable = {}
	for i = 1, GetNumGroupMembers() do
		local member = (IsInRaid() and "raid"..i or "party"..i)
		if UnitIsUnit(unit, member.."target") and not UnitIsUnit("player", member) then
			local color = B.HexRGB(B.UnitColor(member))
			local name = color..UnitName(member).."|r"
			tinsert(targetTable, name)
		end
	end

	if #targetTable > 0 then
		GameTooltip:AddLine(TARGETED_BY..DB.InfoColor.."("..#targetTable..")|r "..table.concat(targetTable, ", "), nil, nil, nil, 1)
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", function()
	if not NDuiDB["Tooltip"]["TargetBy"] then return end
	local _, unit = GameTooltip:GetUnit()
	if UnitExists(unit) then ScanTargets(unit) end
end)