local B, C, _, DB = unpack(select(2, ...))
local cr, cg, cb = DB.cc.r, DB.cc.g, DB.cc.b

-- commands
SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

-- gradient frame
B.CreateGF = function(f, w, h, o, r, g, b, a1, a2)
	f:SetSize(w, h)
	f:SetFrameStrata("BACKGROUND")
	local gf = f:CreateTexture(nil, "BACKGROUND")
	gf:SetPoint("TOPLEFT", f, -1, 1)
	gf:SetPoint("BOTTOMRIGHT", f, 1, -1)
	gf:SetTexture(DB.normTex)
	gf:SetVertexColor(r, g, b)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

-- create backdrop
B.CreateBD = function(f, a, s)
	f:SetBackdrop({
		bgFile = DB.bdTex, edgeFile = DB.glowTex, edgeSize = s or 4,
		insets = {left = s or 4, right = s or 4, top = s or 4, bottom = s or 4},
	})
	f:SetBackdropColor(0, 0, 0, a or 0.5)
	f:SetBackdropBorderColor(0, 0, 0)
end

-- create shadow
B.CreateSD = function(f, m, s, n)
	if f.Shadow then return end
	f.Shadow = CreateFrame("Frame", nil, f)
	f.Shadow:SetPoint("TOPLEFT", f, -m, m)
	f.Shadow:SetPoint("BOTTOMRIGHT", f, m, -m)
	f.Shadow:SetBackdrop({
		edgeFile = DB.glowTex, edgeSize = s })
	f.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow:SetFrameLevel(n or f:GetFrameLevel())
	return f.Shadow
end

-- create skin
B.CreateTex = function(f)
	if f.Tex then return end
	f.Tex = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.Tex:SetPoint("TOPLEFT", 2, -2)
	f.Tex:SetPoint("BOTTOMRIGHT", -2, 2)
	f.Tex:SetTexture(DB.bgTex, true)
	f.Tex:SetHorizTile(true)
	f.Tex:SetVertTile(true)
	f.Tex:SetBlendMode("ADD")
end

-- frame text
B.CreateFS = function(f, size, text, p1, p2, p3, white)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(DB.Font[1], size, DB.Font[3])
	fs:SetText(text)
	if (p1 and p2 and p3) then
		fs:SetPoint(p1, p2, p3)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	if not white then
		fs:SetTextColor(cr, cg, cb)
	end
	return fs
end

-- micromenu icons
B.CreateMM = function(f, t)
	f:SetSize(50, 50)
	f:SetFrameStrata("BACKGROUND")
	f:SetBackdrop({bgFile = DB.Micro..t})
	f:SetBackdropColor(cr, cg, cb, 1)
end

-- micromenu backdrop
B.CreateMB = function(f, parent, w, h, x, y)
	f:SetSize(w, h)
	f:SetPoint("CENTER", parent, "CENTER", x, y)
	B.CreateBD(f, 1)
	f:SetFrameLevel(parent:GetFrameLevel() - 1)
	f:SetAlpha(0)
end

-- Gametooltip
B.CreateGT = function(f, text, cc)
	f:SetScript("OnEnter", function(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
		GameTooltip:ClearLines()
		if cc then
			GameTooltip:AddLine(text, cr, cg, cb)
		else
			GameTooltip:AddLine(text)
		end
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", GameTooltip_Hide)
end
B.CreateAT = function(f, name)
	f:SetScript("OnEnter", function(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
		GameTooltip:ClearLines()
		GameTooltip:SetUnitAura("player", name)
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", GameTooltip_Hide)
end

-- button color
B.CreateBC = function(f, a)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	f:SetScript("OnEnter", function()
		f:SetBackdropBorderColor(cr, cg, cb, 1)
	end)
	f:SetScript("OnLeave", function()
		f:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	f:SetScript("OnMouseDown", function()
		f:SetBackdropColor(cr, cg, cb, a or 0.3)
	end)
	f:SetScript("OnMouseUp", function()
		f:SetBackdropColor(0, 0, 0, a or 0.3)
	end)
end

-- check box
B.CreateCB = function(f, a)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(DB.bdTex)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(cr, cg, cb, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel() - 1)
	B.CreateBD(bd, a, 2)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(cr, cg, cb)
end

-- movable frame
B.CreateMF = function(f)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetUserPlaced(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	f:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
end

-- icon style
B.CreateIF = function(f, HL)
	B.CreateSD(f, 4, 4)
	f.Icon = f:CreateTexture(nil, "ARTWORK")
	f.Icon:SetAllPoints()
	f.Icon:SetTexCoord(unpack(DB.TexCoord))
	f.CD = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
	f.CD:SetAllPoints()
	f.CD:SetReverse(true)
	if HL then
		f:EnableMouse(true)
		f.HL = f:CreateTexture(nil, "HIGHLIGHT")
		f.HL:SetTexture(1,1,1,0.35)
		f.HL:SetAllPoints(f.Icon)
	end
end

-- statusbar
B.CreateSB = function(f)
	f:SetStatusBarTexture(DB.normTex)
	f:SetStatusBarColor(cr, cg, cb)
	B.CreateSD(f, 3, 3)
	f.BG = f:CreateTexture(nil, "BACKGROUND")
	f.BG:SetAllPoints()
	f.BG:SetTexture(DB.normTex)
	f.BG:SetVertexColor(cr, cg, cb, 0.2)
end

-- numberize
B.Numb = function(n)
	if C.NDui.numbType == 1 then
		if (n >= 1e6) then
			return ("%.1fm"):format(n / 1e6)
		elseif (n >= 1e3) then
			return ("%.1fk"):format(n / 1e3)
		else
			return ("%.0f"):format(n)
		end
	elseif C.NDui.numbType == 2 then
		if (n >= 1e8) then
			return ("%.1fy"):format(n / 1e8)
		elseif (n >= 1e4) then
			return ("%.1fw"):format(n / 1e4)
		else
			return ("%.0f"):format(n)
		end
	elseif C.NDui.numbType == 3 then
		return ("%.0f"):format(n)
	end
end

B.Mover = function(Frame, Text, key, Pos, w, h)
	if not NDuiDB[key] then NDuiDB[key] = {} end
	local Mover = CreateFrame("Frame", nil, UIParent)
	Mover:SetWidth(w or Frame:GetWidth())
	Mover:SetHeight(h or Frame:GetHeight())
	B.CreateBD(Mover)
	Mover.Text = Mover:CreateFontString(nil, "OVERLAY")
	Mover.Text:SetFont(unpack(DB.Font))
	Mover.Text:SetPoint("CENTER")
	Mover.Text:SetText(Text)
	if not NDuiDB[key]["Mover"] then 
		Mover:SetPoint(unpack(Pos))
	else
		Mover:SetPoint(unpack(NDuiDB[key]["Mover"]))
	end
	Mover:EnableMouse(true)
	Mover:SetMovable(true)
	Mover:SetClampedToScreen(true)
	Mover:SetFrameStrata("HIGH")
	Mover:RegisterForDrag("LeftButton")
	Mover:SetScript("OnDragStart", function(self) Mover:StartMoving() end)
	Mover:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		NDuiDB[key]["Mover"] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	Mover:Hide()
	Frame:SetPoint("TOPLEFT", Mover)
	return Mover
end

-- Color reformat
B.HexRGB = function(r, g, b)
	if r then
		if (type(r) == "table") then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
	end
end

-- Disable function
B.Dummy = function() return end

-- Smoothy
local smoothing = {}
local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end
function B.SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = Smooth
	end
end
local SmoothUpdate = CreateFrame("Frame")
SmoothUpdate:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)/8, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if (cur == value or math.abs(new - value) < 1) then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)