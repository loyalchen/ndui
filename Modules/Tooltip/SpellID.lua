local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

local select, UnitAura, tonumber, strfind, hooksecurefunc, GetGlyphSocketInfo =
select, UnitAura, tonumber, strfind, hooksecurefunc, GetGlyphSocketInfo
local types = {
	spell       = SPELLS..ID..":",
	item        = ITEMS..ID..":",
	glyph       = GLYPHS..ID..":",
	quest       = QUESTS_LABEL..ID..":",
	talent      = TALENT..ID..":",
	achievement = ACHIEVEMENTS..ID..":"
}
local function addLine(self, id, type, noadd)
	for i = 1, self:NumLines() do
		local line = _G[self:GetName().."TextLeft"..i]
		if not line then break end
		local text = line:GetText()
		if text and text == type then return end
	end
	if not noadd then self:AddLine(" ") end
	if type == types.item then
		if GetItemCount(id, true) and GetItemCount(id, true) - GetItemCount(id) > 0 then
			self:AddDoubleLine(BAGSLOT.."/"..BANK..":", format(DB.InfoColor.."%s|r", GetItemCount(id).."/"..GetItemCount(id, true) - GetItemCount(id)))
		elseif GetItemCount(id) > 0 then
			self:AddDoubleLine(BAGSLOT..":", format(DB.InfoColor.."%s|r", GetItemCount(id)))
		end
		if select(8, GetItemInfo(id)) and select(8, GetItemInfo(id)) >1 then
			self:AddDoubleLine(STACK_CAPS..":", format(DB.InfoColor.."%s|r", select(8, GetItemInfo(id))))
		end
	end
	self:AddDoubleLine(type, format(DB.InfoColor.."%s|r",id))
	self:Show()
end

-- All types, primarily for linked tooltips
local function onSetHyperlink(self, link)
	local type, id = string.match(link,"^(%a+):(%d+)")
	if not type or not id then return end
	if type == "spell" or type == "enchant" or type == "trade" then
		addLine(self, id, types.spell)
	elseif type == "glyph" then
		addLine(self, id, types.glyph)
	elseif type == "talent" then
		addLine(self, id, types.talent, true)
	elseif type == "quest" then
		addLine(self, id, types.quest)
	elseif type == "achievement" then
		addLine(self, id, types.achievement)
	elseif type == "item" then
		addLine(self, id, types.item)
	end
end
hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

-- Spells
hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11, UnitAura(...))
	if id then addLine(self, id, types.spell) end
end)
GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3, self:GetSpell())
	if id then addLine(self, id, types.spell) end
end)
hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip, id, types.spell) end
end)

-- Items
local function attachItemTooltip(self)
	local link = select(2, self:GetItem())
	if not link then return end
	local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
	if id then addLine(self, id, types.item) end
end
GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)

-- Glyphs
hooksecurefunc(GameTooltip, "SetGlyph", function(self, ...)
	local id = select(4, GetGlyphSocketInfo(...))
	if id then addLine(self, id, types.glyph) end
end)
hooksecurefunc(GameTooltip, "SetGlyphByID", function(self, id)
	if id then addLine(self, id, types.glyph) end
end)