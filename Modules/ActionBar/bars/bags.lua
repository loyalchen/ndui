-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.bags
local dragFrameList = ns.dragFrameList
local padding = 15
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end

--bag button objects
local buttonList = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
}

local NUM_BAG_BUTTONS = # buttonList
local buttonWidth = MainMenuBarBackpackButton:GetWidth()
local buttonHeight = MainMenuBarBackpackButton:GetHeight()
local gap = 2

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "rABS_BagFrame", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(NUM_BAG_BUTTONS*buttonWidth + (NUM_BAG_BUTTONS-1)*gap + 2*padding)
frame:SetHeight(buttonHeight + 2*padding)
frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
for _, button in pairs(buttonList) do
	button:SetParent(frame)
end
MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint("RIGHT", -padding, 0)

if not cfg.show then --wait...you no see me? :(
	frame:SetParent(ns.pastebin)
	return
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

--create drag frame and drag functionality
if C.bars.userplaced then
	rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
end

--create the mouseover functionality
if cfg.mouseover.enable then
	rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end