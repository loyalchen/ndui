-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.bar5
local dragFrameList = ns.dragFrameList
local padding, margin = 2, 2
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", SHOW_MULTIBAR4_TEXT, UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(cfg.size + 2*padding)
frame:SetHeight(num*cfg.size + (num-1)*margin + 2*padding)
if C.bars.layout == 1 then
	frame:SetPoint("RIGHT", UIParent, "RIGHT", -(frame:GetWidth()-1), 0)
else
	frame:SetPoint("RIGHT", UIParent, "RIGHT", -1, 0)
end
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
MultiBarLeft:SetParent(frame)
MultiBarLeft:EnableMouse(false)

for i = 1, num do
	local button = _G["MultiBarLeftButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPRIGHT", frame, -padding, -padding)
	else
		local previous = _G["MultiBarLeftButton"..i-1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
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