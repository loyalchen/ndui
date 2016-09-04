-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.bar1
local dragFrameList = ns.dragFrameList
local padding, margin = 2, 2

-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = NUM_OVERRIDE_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "rABS_OverrideBar", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
frame:SetHeight(cfg.size + 2*padding)
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 21)
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
OverrideActionBar:SetParent(frame)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil) --remove the onshow script

local leaveButtonPlaced = false
OverrideActionBar.LeaveButton:Hide()

for i = 1, num do
	local button =  _G["OverrideActionBarButton"..i]
	if not button and not leaveButtonPlaced then
		button = OverrideActionBar.LeaveButton --the magic 7th button
		leaveButtonPlaced = true
	end
	if not button then break end
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["OverrideActionBarButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
	end
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

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