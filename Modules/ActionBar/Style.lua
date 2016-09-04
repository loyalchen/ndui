---------------------------------------
-- VARIABLES
---------------------------------------
--get the addon namespace
local B, C, L, DB = unpack(select(2, ...))

--backdrop settings
local bgfile, edgefile = "", ""
if C.Actionbar.ShowSD then edgefile = DB.textures.outer_shadow end
if C.Actionbar.ShowBG then bgfile = DB.textures.buttonbackflat end

--backdrop
local backdrop = {
	bgFile = bgfile, edgeFile = edgefile, tile = false, tileSize = 32, edgeSize = 4,
	insets = {
		left = 4, right = 4, top = 4, bottom = 4,
	},
}

---------------------------------------
-- FUNCTIONS
---------------------------------------

local function applyBackground(bu)
	if not bu or (bu and bu.bg) then return end
	--shadows+background
	if bu:GetFrameLevel() < 1 then bu:SetFrameLevel(1) end
	if C.Actionbar.ShowBG or C.Actionbar.ShowSD then
		bu.bg = CreateFrame("Frame", nil, bu)
		bu.bg:SetAllPoints(bu)
		bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -3, 3)
		bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 3, -3)
		bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		bu.bg:SetBackdrop(backdrop)
		if C.Actionbar.ShowBG then
			if NDuiDB["Actionbar"]["Classcolor"] then
				bu.bg:SetBackdropColor(DB.cc.r,DB.cc.g,DB.cc.b,0.1)
			else
				bu.bg:SetBackdropColor(C.Actionbar.BGColor.r,C.Actionbar.BGColor.g,C.Actionbar.BGColor.b,C.Actionbar.BGColor.a)
			end
		end
		if C.Actionbar.ShowSD then
			bu.bg:SetBackdropBorderColor(C.Actionbar.SDColor.r,C.Actionbar.SDColor.g,C.Actionbar.SDColor.b,C.Actionbar.SDColor.a)
		end
	end
end

--style extraactionbutton
local function styleExtraActionButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ho = _G[name.."HotKey"]
	--remove the style background theme
	bu.style:SetTexture(nil)
	hooksecurefunc(bu.style, "SetTexture", function(self, texture)
		if texture then
			self:SetTexture(nil)
		end
	end)
	--icon
	bu.icon:SetTexCoord(unpack(DB.TexCoord))
	bu.icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	bu.icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	--cooldown
	bu.cooldown:SetAllPoints(bu.icon)
	--hotkey
	ho:Hide()
	--add button normaltexture
	bu:SetNormalTexture(DB.textures.normal)
	bu:SetPushedTexture(DB.textures.pushed)
	local nt = bu:GetNormalTexture()
	nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
	nt:SetAllPoints(bu)
	nt:SetTexCoord(unpack(DB.TexCoord))
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--initial style func
local function styleActionButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local action = bu.action
	local name = bu:GetName()
	local ic  = _G[name.."Icon"]
	local co  = _G[name.."Count"]
	local bo  = _G[name.."Border"]
	local ho  = _G[name.."HotKey"]
	local cd  = _G[name.."Cooldown"]
	local na  = _G[name.."Name"]
	local fl  = _G[name.."Flash"]
	local nt  = _G[name.."NormalTexture"]
	local fbg  = _G[name.."FloatingBG"]
	local fob = _G[name.."FlyoutBorder"]
	local fobs = _G[name.."FlyoutBorderShadow"]
	if fbg then fbg:Hide() end  --floating background
	--flyout border stuff
	if fob then fob:SetTexture(nil) end
	if fobs then fobs:SetTexture(nil) end
	bo:SetTexture(nil) --hide the border (plain ugly, sry blizz)
	--hotkey
	ho:SetFont(unpack(DB.Font))
	ho:ClearAllPoints()
	ho:SetPoint("TOPRIGHT",bu,0,0)
	ho:SetPoint("TOPLEFT",bu,0,0)
	if not NDuiDB["Actionbar"]["Hotkeys"] then
		ho:Hide()
	end
	--macro name
	na:SetFont(unpack(DB.Font))
	na:ClearAllPoints()
	na:SetPoint("BOTTOMLEFT",bu,0,0)
	na:SetPoint("BOTTOMRIGHT",bu,0,0)
	if not NDuiDB["Actionbar"]["Macro"] then
		na:Hide()
	end
	--item stack count
	co:SetFont(unpack(DB.Font))
	co:ClearAllPoints()
	co:SetPoint("BOTTOMRIGHT",bu,2,0)
	if not NDuiDB["Actionbar"]["Count"] then
		co:Hide()
	end
	--applying the textures
	fl:SetTexture(DB.textures.flash)
	bu:SetPushedTexture(DB.textures.pushed)
	bu:SetCheckedTexture(DB.textures.checked)
	bu:SetNormalTexture(DB.textures.normal)
	bu:SetHighlightTexture(nil)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetTexture(1,1,1,0.35)
	bu.HL:SetAllPoints(ic)
	if not nt then
		--fix the non existent texture problem (no clue what is causing this)
		nt = bu:GetNormalTexture()
	end
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(unpack(DB.TexCoord))
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	--adjust the cooldown frame
	cd:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	--apply the normaltexture
	if action and IsEquippedAction(action) then
		bu:SetNormalTexture(DB.textures.equipped)
		nt:SetVertexColor(C.Actionbar.Equipped.r,C.Actionbar.Equipped.g,C.Actionbar.Equipped.b,1)
	else
		bu:SetNormalTexture(DB.textures.normal)
		nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
	end
	--make the normaltexture match the buttonsize
	nt:SetAllPoints(bu)
	nt:SetTexCoord(unpack(DB.TexCoord))
	--hook to prevent Blizzard from reseting our colors
	hooksecurefunc(nt, "SetVertexColor", function(nt, r, g, b, a)
		local bu = nt:GetParent()
		local action = bu.action
		--print("bu"..bu:GetName().."R"..r.."G"..g.."B"..b)
		if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
			if C.Actionbar.Equipped.r == 1 and  C.Actionbar.Equipped.g == 1 and  C.Actionbar.Equipped.b == 1 then
				nt:SetVertexColor(0.999,0.999,0.999,1)
			else
				nt:SetVertexColor(C.Actionbar.Equipped.r,C.Actionbar.Equipped.g,C.Actionbar.Equipped.b,1)
			end
		elseif r==0.5 and g==0.5 and b==1 then
			--blizzard oom color
			if C.Actionbar.Normal.r == 0.5 and  C.Actionbar.Normal.g == 0.5 and  C.Actionbar.Normal.b == 1 then
				nt:SetVertexColor(0.499,0.499,0.999,1)
			else
				nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
			end
		elseif r==1 and g==1 and b==1 then
			if C.Actionbar.Normal.r == 1 and  C.Actionbar.Normal.g == 1 and  C.Actionbar.Normal.b == 1 then
				nt:SetVertexColor(0.999,0.999,0.999,1)
			else
				nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
			end
		end
	end)
	--shadows+background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

local function styleLeaveButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	--shadows+background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--style pet buttons
local function stylePetButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ic  = _G[name.."Icon"]
	local fl  = _G[name.."Flash"]
	local nt  = _G[name.."NormalTexture2"]
	nt:SetAllPoints(bu)
	nt:SetTexCoord(unpack(DB.TexCoord))
	--applying color
	nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
	--setting the textures
	fl:SetTexture(DB.textures.flash)
	bu:SetPushedTexture(DB.textures.pushed)
	bu:SetCheckedTexture(DB.textures.checked)
	bu:SetNormalTexture(DB.textures.normal)
	bu:SetHighlightTexture(nil)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetTexture(1,1,1,0.35)
	bu.HL:SetAllPoints(ic)
	hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
		--make sure the normaltexture stays the way we want it
		if texture and texture ~= DB.textures.normal then
			self:SetNormalTexture(DB.textures.normal)
		end
	end)
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(unpack(DB.TexCoord))
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	--shadows+background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--style stance buttons
local function styleStanceButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ic  = _G[name.."Icon"]
	local fl  = _G[name.."Flash"]
	local nt  = _G[name.."NormalTexture2"]
	nt:SetAllPoints(bu)
	nt:SetTexCoord(unpack(DB.TexCoord))
	--applying color
	nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
	--setting the textures
	fl:SetTexture(DB.textures.flash)
	bu:SetPushedTexture(DB.textures.pushed)
	bu:SetCheckedTexture(DB.textures.checked)
	bu:SetNormalTexture(DB.textures.normal)
	bu:SetHighlightTexture(nil)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetTexture(1,1,1,0.35)
	bu.HL:SetAllPoints(ic)
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(unpack(DB.TexCoord))
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	--shadows+background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--style possess buttons
local function stylePossessButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ic  = _G[name.."Icon"]
	local fl  = _G[name.."Flash"]
	local nt  = _G[name.."NormalTexture"]
	nt:SetAllPoints(bu)
	nt:SetTexCoord(unpack(DB.TexCoord))
	--applying color
	nt:SetVertexColor(C.Actionbar.Normal.r,C.Actionbar.Normal.g,C.Actionbar.Normal.b,1)
	--setting the textures
	fl:SetTexture(DB.textures.flash)
	bu:SetPushedTexture(DB.textures.pushed)
	bu:SetCheckedTexture(DB.textures.checked)
	bu:SetNormalTexture(DB.textures.normal)
	bu:SetHighlightTexture(nil)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetTexture(1,1,1,0.35)
	bu.HL:SetAllPoints(ic)
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(unpack(DB.TexCoord))
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
	--shadows+background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--update hotkey func
local function updateHotkey(self, actionButtonType)
	local ho = _G[self:GetName().."HotKey"]
	if ho and not NDuiDB["Actionbar"]["Hotkeys"] and ho:IsShown() then
		ho:Hide()
	end
end

---------------------------------------
-- INIT
---------------------------------------

local function init()
	--style the actionbar buttons
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		styleActionButton(_G["ActionButton"..i])
		styleActionButton(_G["MultiBarBottomLeftButton"..i])
		styleActionButton(_G["MultiBarBottomRightButton"..i])
		styleActionButton(_G["MultiBarRightButton"..i])
		styleActionButton(_G["MultiBarLeftButton"..i])
	end
	for i = 1, 6 do
		styleActionButton(_G["OverrideActionBarButton"..i])
	end
	--style leave button
	styleLeaveButton(OverrideActionBarLeaveFrameLeaveButton)
	styleLeaveButton(rABS_LeaveVehicleButton)
	--petbar buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		stylePetButton(_G["PetActionButton"..i])
	end
	--stancebar buttons
	for i = 1, NUM_STANCE_SLOTS do
		styleStanceButton(_G["StanceButton"..i])
	end
	--possess buttons
	for i = 1, NUM_POSSESS_SLOTS do
		stylePossessButton(_G["PossessButton"..i])
	end
	--extraactionbutton1
	styleExtraActionButton(ExtraActionButton1)
	--spell flyout
	SpellFlyoutBackgroundEnd:SetTexture(nil)
	SpellFlyoutHorizontalBackground:SetTexture(nil)
	SpellFlyoutVerticalBackground:SetTexture(nil)
	local function checkForFlyoutButtons(self)
		local NUM_FLYOUT_BUTTONS = 10
		for i = 1, NUM_FLYOUT_BUTTONS do
			styleActionButton(_G["SpellFlyoutButton"..i])
		end
	end
	SpellFlyout:HookScript("OnShow",checkForFlyoutButtons)

	--hide the hotkeys if needed
	if not NDuiDB["Actionbar"]["Hotkeys"] then
		hooksecurefunc("ActionButton_UpdateHotkeys",  updateHotkey)
	end
end

---------------------------------------
-- CALL
---------------------------------------

local a = CreateFrame("Frame")
a:RegisterEvent("PLAYER_LOGIN")
a:SetScript("OnEvent", init)