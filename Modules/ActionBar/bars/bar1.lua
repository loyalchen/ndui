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
local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", NDUI_ACTION_BAR, UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
frame:SetHeight(cfg.size + 2*padding)
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 21)
frame:SetScale(cfg.scale)

--move the buttons into position and reparent them
MainMenuBarArtFrame:SetParent(frame)
MainMenuBarArtFrame:EnableMouse(false)

for i = 1, num do
	local button = _G["ActionButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["ActionButton"..i-1]
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

--fix stupid blizzard
local shit = CreateFrame("Frame")
shit:RegisterEvent("CVAR_UPDATE")
shit:SetScript("OnEvent", function()
	if InCombatLockdown() then return end	--fuck stupid taint
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local button = _G["ActionButton"..i]
		if GetCVar("alwaysShowActionBars") == "1" then
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		else
			button:SetAttribute("showgrid", 0)
			ActionButton_HideGrid(button)
		end
	end
end)