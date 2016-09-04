-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.micromenu
local dragFrameList = ns.dragFrameList
local padding = 10
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local MICRO_BUTTONS = MICRO_BUTTONS
local buttonList = {}

--check the buttons in the MICRO_BUTTONS table
for _, buttonName in pairs(MICRO_BUTTONS) do
	local button = _G[buttonName]
	if button then
		--if not button:IsShown() then print(buttonName.." is not shown") end
		tinsert(buttonList, button)
	end
end

local NUM_MICROBUTTONS = # buttonList
local buttonWidth = CharacterMicroButton:GetWidth()
local buttonHeight = CharacterMicroButton:GetHeight()
local gap = -3

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "rABS_MicroMenu", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(NUM_MICROBUTTONS*buttonWidth + (NUM_MICROBUTTONS-1)*gap + 2*padding)
frame:SetHeight(buttonHeight + 2*padding)
frame:SetPoint("TOP", UIParent, "TOP", 0, 25)
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
for _, button in pairs(buttonList) do
	button:SetParent(frame)
end
CharacterMicroButton:ClearAllPoints();
CharacterMicroButton:SetPoint("LEFT", padding, 0)

--disable reanchoring of the micro menu by the petbattle ui
PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil) --remove the onshow script

if not cfg.show then --wait...you no see me? :(
	frame:SetParent(ns.pastebin)
	return
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

--create drag frame and drag functionality
if C.bars.userplaced then
	rCreateDragFrame(frame, dragFrameList, -2 , false) --frame, dragFrameList, inset, clamp
end

--create the mouseover functionality
if cfg.mouseover.enable then
	rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end