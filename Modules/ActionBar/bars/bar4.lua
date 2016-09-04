-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.bar4
local dragFrameList = ns.dragFrameList
local padding, margin = 2, 2
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", SHOW_MULTIBAR3_TEXT, UIParent, "SecureHandlerStateTemplate")
if C.bars.layout == 1 then
	frame:SetWidth(cfg.size + 2*padding)
	frame:SetHeight(num*cfg.size + (num-1)*margin + 2*padding)
	frame:SetPoint("RIGHT", UIParent, "RIGHT", -1, 0)
elseif C.bars.layout == 2 then
	frame:SetWidth(25*cfg.size + 27*margin + 2*padding)
	frame:SetHeight(2*cfg.size + margin + 2*padding)
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 23)
elseif C.bars.layout == 3 then
	frame:SetWidth(4*cfg.size + 3*margin + 2*padding)
	frame:SetHeight(3*cfg.size + 2*margin + 2*padding)
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 325, 23)
end
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
MultiBarRight:SetParent(frame)
MultiBarRight:EnableMouse(false)

for i = 1, num do
	local button = _G["MultiBarRightButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if C.bars.layout == 1 then
		if i == 1 then
			button:SetPoint("TOPRIGHT", frame, -padding, -padding)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		end
	elseif C.bars.layout == 2 then
		if i == 1 then
			button:SetPoint("TOPLEFT", frame, padding, -padding)
		elseif i == 4 then
			local previous = _G["MultiBarRightButton1"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		elseif i == 7 then
			local previous = _G["MultiBarRightButton3"]
			button:SetPoint("LEFT", previous, "RIGHT", 19*cfg.size + 23*margin, 0)
		elseif i == 10 then
			local previous = _G["MultiBarRightButton7"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	elseif C.bars.layout == 3 then
		if i == 1 then
			button:SetPoint("TOPLEFT", frame, padding, -padding)
		elseif i == 5 or i == 9 then
			local previous = _G["MultiBarRightButton"..i-4]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
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