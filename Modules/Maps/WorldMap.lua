local B, C, L, DB = unpack(select(2, ...))
if not C.Maps.Enable then return end

-- Coords
WorldMapFrame:SetScale(1.1)
local formattext, player, cursor = ": %.1f, %.1f"
local function gen_string(point, X, Y)
	local t = WorldMapTitleButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t:SetFont(GameFontNormal:GetFont(), 14, "THINOUTLINE")
	t:SetPoint("TOPLEFT", WorldMapTitleButton, point, X, Y)
	t:SetJustifyH("LEFT")
	return t
end

local function Cursor()
	local left, top = WorldMapDetailFrame:GetLeft() or 0, WorldMapDetailFrame:GetTop() or 0
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
	return cx, cy
end

local function OnUpdate(player, cursor)
	local cx, cy = Cursor()
	local px, py = GetPlayerMapPosition("player")
	if cx and cy then
		cursor:SetFormattedText(MOUSE_LABEL..DB.MyColor..formattext, 100 * cx, 100 * cy)
	else
		cursor:SetText(MOUSE_LABEL..DB.MyColor..": --, --")
	end
	if px == 0 or py == 0 then
		player:SetText(PLAYER..DB.MyColor..": --, --")
	else
		player:SetFormattedText(PLAYER..DB.MyColor..formattext, 100 * px, 100 * py)
	end
end

local function UpdateCoords(self, elapsed)
	self.elapsed = self.elapsed - elapsed
	if self.elapsed <= 0 then
		self.elapsed = 0.1
		OnUpdate(player, cursor)
	end
end

local tpt = {"LEFT", self, "BOTTOM"}
local function gen_coords(self)
	if player or cursor then return end
	player = gen_string("TOP", -350, -6)
	cursor = gen_string("TOP", -200, -6)
end

local w = CreateFrame("Frame")
w:RegisterEvent("PLAYER_ENTERING_WORLD")
w:RegisterEvent("WORLD_MAP_UPDATE")
w:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		gen_coords(self)
		for i = 1, MAX_PARTY_MEMBERS do
			local pi = _G["WorldMapParty"..i]
			pi:SetWidth(C.Maps.IconSize)
			pi:SetHeight(C.Maps.IconSize)
		end
		for i = 1, MAX_RAID_MEMBERS do
			local ri = _G["WorldMapRaid"..i]
			ri:SetWidth(C.Maps.IconSize)
			ri:SetHeight(C.Maps.IconSize)
		end
		local cond = false
	elseif event == "WORLD_MAP_UPDATE" then
		-- making sure that coordinates are not calculated when map is hidden
		if not NDuiDB["Map"] then
			NDuiDB["Map"] = {}
			NDuiDB["Map"]["Coord"] = true
		end
		if not NDuiDB["Map"]["Coord"] then return end
		if not WorldMapFrame:IsVisible() and cond then
			self.elapsed = nil
			self:SetScript("OnUpdate", nil)
			cond = false
		else
			self.elapsed = 0.1
			self:SetScript("OnUpdate", UpdateCoords)
			cond = true
		end
	end
end)