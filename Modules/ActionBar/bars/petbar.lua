-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.petbar
local dragFrameList = ns.dragFrameList
local padding, margin = 2, 3
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = NUM_PET_ACTION_SLOTS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "rABS_PetBar", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
frame:SetHeight(cfg.size + 2*padding)
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 100, 103)
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
PetActionBarFrame:SetParent(frame)
PetActionBarFrame:EnableMouse(false)

for i = 1, num do
	local button = _G["PetActionButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("LEFT", frame, padding, 0)
	else
		local previous = _G["PetActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
	end
	--cooldown fix
	local cd = _G["PetActionButton"..i.."Cooldown"]
	cd:SetAllPoints(button)
end

if not cfg.show then --wait...you no see me? :(
	frame:SetParent(ns.pastebin)
	return
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists] show; hide")

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