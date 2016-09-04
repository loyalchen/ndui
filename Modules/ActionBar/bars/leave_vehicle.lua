-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local B, C, L, DB = unpack(select(2, ...))
local cfg = C.bars.leave_vehicle
local dragFrameList = ns.dragFrameList
local padding, margin = 10, 5
-----------------------------
-- FUNCTIONS
-----------------------------
if not cfg.enable then return end
local num = 1
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", NDUI_LEAVEVEHICLE_BAR, UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
frame:SetHeight(cfg.size + 2*padding)
if C.bars.layout == 3 then
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 300, 120)
else
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 300, 80)
end
frame:SetScale(cfg.scale)

--the button
local button = CreateFrame("Button", "rABS_LeaveVehicleButton", frame)
table.insert(buttonList, button) --add the button object to the list
button:SetSize(cfg.size, cfg.size)
button:SetPoint("BOTTOMLEFT", frame, padding, padding)
button:RegisterForClicks("AnyUp")
button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
local nt = button:GetNormalTexture()
local pu = button:GetPushedTexture()
local hi = button:GetHighlightTexture()
nt:SetTexCoord(0.0859375,0.1679688,0.359375,0.4414063)
pu:SetTexCoord(0.001953125,0.08398438,0.359375,0.4414063)
hi:SetTexCoord(0.6152344,0.6972656,0.359375,0.4414063)
hi:SetBlendMode("ADD")

-- leave the taxi/vehicle
local function UpdateVisible()
	if CanExitVehicle() then
		button:Show()
		button:GetNormalTexture():SetVertexColor(1, 1, 1)
		button:EnableMouse(true)
	else
		button:Hide()
	end
end
button:SetScript("OnClick", function(self)
	if UnitOnTaxi("player") then
		TaxiRequestEarlyLanding()
		self:GetNormalTexture():SetVertexColor(1, 0, 0)
		self:EnableMouse(false)
	else
		VehicleExit()
	end
end)
button:SetScript("OnEnter", MainMenuBarVehicleLeaveButton_OnEnter)
button:SetScript("OnLeave", GameTooltip_Hide)
hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", UpdateVisible)

--frame is visibile when no vehicle ui is visible
RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

--create drag frame and drag functionality
if C.bars.userplaced then
	rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
end

--create the mouseover functionality
if cfg.mouseover.enable then
	rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end