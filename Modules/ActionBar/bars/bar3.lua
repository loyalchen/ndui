-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.bar3
local dragFrameList = ns.dragFrameList
local padding, margin = 2, 2
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", SHOW_MULTIBAR2_TEXT, UIParent, "SecureHandlerStateTemplate")
if cfg.uselayout2x3x2 then
	frame:SetWidth(19*cfg.size + 19*margin + 2*padding)
	frame:SetHeight(2*cfg.size + margin + 2*padding)
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 23)
else
	frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
	frame:SetHeight(cfg.size + 2*padding)
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", -1, 81)
end
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
MultiBarBottomRight:SetParent(frame)
MultiBarBottomRight:EnableMouse(false)

for i = 1, num do
	local button = _G["MultiBarBottomRightButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		if cfg.uselayout2x3x2 then
			button:SetPoint("TOPLEFT", frame, padding, -padding)
		else
			button:SetPoint("LEFT", frame, padding, 0)
		end
	elseif cfg.uselayout2x3x2 and i == 4 then
		local previous = _G["MultiBarBottomRightButton1"]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
	elseif cfg.uselayout2x3x2 and i == 7 then
		local previous = _G["MultiBarBottomRightButton3"]
		button:SetPoint("LEFT", previous, "RIGHT", 13*cfg.size+15*margin, 0)
	elseif cfg.uselayout2x3x2 and i == 10 then
		local previous = _G["MultiBarBottomRightButton7"]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
	else
		local previous = _G["MultiBarBottomRightButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
	end
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

--create drag frame and drag functionality
if C.bars.userplaced then
	rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
end

--create the mouseover functionality
if cfg.mouseover.enable then
	rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
	frame.mouseover = cfg.mouseover
end

--create the combat fader
if cfg.combat.enable then
	rCombatFrameFader(frame, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
end