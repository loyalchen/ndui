-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.stancebar
local dragFrameList = ns.dragFrameList
local padding, margin = 2, 5
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = NUM_STANCE_SLOTS
local NUM_POSSESS_SLOTS = NUM_POSSESS_SLOTS
local buttonList = {}

--make a frame that fits the size of all microbuttons
local frame = CreateFrame("Frame", NDUI_STANCE_BAR, UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
frame:SetHeight(cfg.size + 2*padding)
frame:SetPoint("BOTTOM", UIParent,"BOTTOM", -80, 94)
frame:SetScale(cfg.scale)

--STANCE BAR

--move the buttons into position and reparent them
StanceBarFrame:SetParent(frame)
StanceBarFrame:EnableMouse(false)

for i=1, num do
	local button = _G["StanceButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["StanceButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
	end
end

--POSSESS BAR

--move the buttons into position and reparent them
PossessBarFrame:SetParent(frame)
PossessBarFrame:EnableMouse(false)

for i = 1, NUM_POSSESS_SLOTS do
	local button = _G["PossessButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["PossessButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
	end
end

if not cfg.show then --wait...you no see me? :(
	frame:SetParent(ns.pastebin)
	return
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
end

--create the combat fader
if cfg.combat.enable then
	rCombatFrameFader(frame, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
end