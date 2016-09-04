-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.extrabar
local dragFrameList = ns.dragFrameList
local padding, margin = 10, 5
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = 1
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", NDUI_EXTRAACTION_BAR, UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
frame:SetHeight(cfg.size + 2*padding)
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 240, 80)
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
ExtraActionBarFrame:SetParent(frame)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

--the extra button
local button = ExtraActionButton1
table.insert(buttonList, button) --add the button object to the list
button:SetSize(cfg.size,cfg.size)

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

--create drag frame and drag functionality
if C.bars.userplaced then
	rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
end

--create the mouseover functionality
if cfg.mouseover.enable then
	rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end