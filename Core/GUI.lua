local B, C, L, DB = unpack(select(2, ...))

-- Default Settings
local event = CreateFrame("Frame")
event:RegisterEvent("PLAYER_LOGIN")
event:SetScript("OnEvent", function()
	if not NDuiDB["GUI"] then
		NDuiDB = {
			["GUI"] = true,
			["Actionbar"] = {
				["Layout"] = 1,
				["Hotkeys"] = true,
				["Macro"] = true,
				["Count"] = true,
				["Classcolor"] = false,
			},
			["Stagger"] = {
				["Enable"] = true,
			},
			["BloodHelper"] = {
				["Enable"] = true,
			},
			["AuraWatch"] = {
				["Enable"] = true,
				["Hint"] = true,
			},
			["Checker"] = {
				["Enable"] = true,
				["Party"] = true,
			},
			["Reminder"] = {
				["Enable"] = true,
			},
			["CPoints"] = {
				["Enable"] = true,
			},
			["Totems"] = {
				["Enable"] = true,
			},
			["Resolve"] = {
				["Enable"] = true,
			},
			["UFs"] = {
				["Enable"] = true,
				["Portrait"] = true,
				["ClassColor"] = false,
				["SmoothColor"] = false,
				["Smooth"] = true,
				["HealPrediction"] = true,
				["PlayerDebuff"] = true,
				["ToTAuras"] = false,
				["Boss"] = true,
				["Arena"] = true,
				["ExpRep"] = false,
				["AltPowerBar"] = false,
				["Totems"] = false,
				["CPoints"] = false,
				["Runebar"] = true,
				["Harmonybar"] = true,
				["Holybar"] = true,
				["Eclipsebar"] = true,
				["WarlockSpecs"] = true,
				["ShadowOrbs"] = true,
				["Castbars"] = true,
			},
			["Chat"] = {
				["Sticky"] = true,
			},
			["Map"] = {
				["Coord"] = true,
				["Invite"] = true,
				["Clock"] = false,
			},
			["Nameplate"] = {
				["Enable"] = true,
				["HealthValue"] = false,
				["TankMode"] = true,
				["CombatShow"] = false,
				["TrackAuras"] = true,
			},
			["Skins"] = {
				["DBM"] = true,
				["MicroMenu"] = true,
				["Skada"] = true,
				["RM"] = true,
			},
			["Tooltip"] = {
				["Cursor"] = false,
				["CombatHide"] = false,
				["HideTitle"] = false,
				["HideRealm"] = false,
				["HideRank"] = false,
				["HidePVP"] = true,
				["HideFaction"] = false,
				["FactionIcon"] = false,
				["ClassColor"] = false,
			},
			["Sets"] = {
				["Mail"] = true,
				["Durability"] = true,
				["HideErrors"] = true,
				["Freedom"] = true,
				["SoloInfo"] = true,
				["RareAlerter"] = true,
				["Focuser"] = true,
				["Autoequip"] = true,
				["ExpRep"] = true,
				["Screenshot"] = false,
				["TradeTab"] = true,
			},
		}
	end
end)

-- Config
local r, g, b = DB.cc.r, DB.cc.g, DB.cc.b
local optionlist = {
	NDUI_GUI_ACTIONBAR,
	NDUI_GUI_AURAS,
	NDUI_GUI_UFS,
	NDUI_GUI_CHAT,
	NDUI_GUI_MAPS,
	NDUI_GUI_NAMEPLATE,
	NDUI_GUI_SKINS,
	NDUI_GUI_TOOLTIP,
	NDUI_GUI_SETS,
}
local f = CreateFrame("Frame", "NDuiGUI", UIParent)
f:Hide()
local tab, x, y = {}

local function CreateTab(i, name)
	local tab = CreateFrame("Button", "NDuiGUI_Tab"..i, NDuiGUI)
	tab:SetPoint("TOPLEFT", 30, -(28*i + 40))
	tab:SetSize(130, 26)
	B.CreateBD(tab, .3, 1.2)
	B.CreateFS(tab, 14, name, "LEFT", 15, 0)
	local hl = tab:CreateTexture(nil, "HIGHLIGHT")
	hl:SetPoint("TOPLEFT", 1, -1)
	hl:SetPoint("BOTTOMRIGHT", -1, 1)
	hl:SetTexture(r, g, b, .3)
	return tab
end

function CreateOption(f, i, index, name)
	f = CreateFrame("CheckButton", "NDuiGUI_Page"..i.."_Option"..index, _G["NDuiGUI_Page"..i], "InterfaceOptionsCheckButtonTemplate")
	f:SetSize(26, 26)
	if index <= 13 then
		f:SetPoint("TOPLEFT", 20, 15-index*35)
	else
		f:SetPoint("TOPLEFT", 250, 15-(index-13)*35)
	end
	B.CreateCB(f)
	B.CreateFS(f, 12, name, "LEFT", 30, 0, true)
	return f
end
--[[
function CreateDropdown(f, i, index, name, x, y)
	f = CreateFrame("Button", "NDuiGUI_Page"..i.."_Option"..index, _G["NDuiGUI_Page"..i])
	f:SetSize(18, 18)
	f:SetPoint("TOPLEFT", x, y)
	B.CreateBD(f, .5, 2)
	B.CreateFS(f, 12, name, "LEFT", 25, 0, true)
	local arrow = B.CreateFS(f, 12, "▼")
	arrow:SetTextColor(1, 1, 1)
	f:SetScript("OnEnter", function()
		arrow:SetTextColor(.6, .8, 1)
	end)
	f:SetScript("OnLeave", function()
		arrow:SetTextColor(1, 1, 1)
	end)
	return f
end]]

function SetOption(i)
	if i == 1 then
		--[[local opt1 = CreateDropdown(opt1, i, 1, "动作条布局"..NDuiDB["Actionbar"]["Layout"], 24, -25)
		local menuFrame = CreateFrame("Frame", opt1:GetName().."Dropdown", opt1, "UIDropDownMenuTemplate")
		local menuList = {
			{notCheckable = true, text = "动作条布局1", value = "1"},
			{notCheckable = true, text = "动作条布局2", value = "2"},
			{notCheckable = true, text = "动作条布局3", value = "3"},
		}
		opt1:SetScript("OnMouseUp", function(self)
			for i = 1, 3 do
				local function selectbj()
					NDuiDB["Actionbar"]["Layout"] = menuList[i].value
				end
				if i == NDuiDB["Actionbar"]["Layout"] then
					menuList[i].checked = true
				end
				menuList[i].func = function() selectbj() end
			end
			EasyMenu(menuList, menuFrame, opt1, 0, 0, "MENU", 1)
		end)]]

		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P1B1)
		opt1:SetChecked(NDuiDB["Actionbar"]["Hotkeys"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Actionbar"]["Hotkeys"] = true
			else
				NDuiDB["Actionbar"]["Hotkeys"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P1B2)
		opt2:SetChecked(NDuiDB["Actionbar"]["Macro"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Actionbar"]["Macro"] = true
			else
				NDuiDB["Actionbar"]["Macro"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P1B3)
		opt3:SetChecked(NDuiDB["Actionbar"]["Count"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Actionbar"]["Count"] = true
			else
				NDuiDB["Actionbar"]["Count"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 4, NDUI_GUI_P1B4)
		opt4:SetChecked(NDuiDB["Actionbar"]["Classcolor"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Actionbar"]["Classcolor"] = true
			else
				NDuiDB["Actionbar"]["Classcolor"] = false
			end
		end)
	elseif i == 2 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P2B1)
		opt1:SetChecked(NDuiDB["AuraWatch"]["Enable"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["AuraWatch"]["Enable"] = true
			else
				NDuiDB["AuraWatch"]["Enable"] = false
			end
		end)

		local opt101 = CreateOption(opt101, i, 14, NDUI_GUI_P2B2)
		opt101:SetChecked(NDuiDB["AuraWatch"]["Hint"])
		opt101:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["AuraWatch"]["Hint"] = true
			else
				NDuiDB["AuraWatch"]["Hint"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P2B3)
		opt2:SetChecked(NDuiDB["Checker"]["Enable"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Checker"]["Enable"] = true
			else
				NDuiDB["Checker"]["Enable"] = false
			end
		end)

		local opt201 = CreateOption(opt201, i, 15, NDUI_GUI_P2B4)
		opt201:SetChecked(NDuiDB["Checker"]["Party"])
		opt201:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Checker"]["Party"] = true
			else
				NDuiDB["Checker"]["Party"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P2B5)
		opt3:SetChecked(NDuiDB["Reminder"]["Enable"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Reminder"]["Enable"] = true
			else
				NDuiDB["Reminder"]["Enable"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 5, NDUI_GUI_P2B6)
		opt4:SetChecked(NDuiDB["BloodHelper"]["Enable"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["BloodHelper"]["Enable"] = true
			else
				NDuiDB["BloodHelper"]["Enable"] = false
			end
		end)

		local opt5 = CreateOption(opt5, i, 6, NDUI_GUI_P2B7)
		opt5:SetChecked(NDuiDB["Stagger"]["Enable"])
		opt5:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Stagger"]["Enable"] = true
			else
				NDuiDB["Stagger"]["Enable"] = false
			end
		end)

		local opt6 = CreateOption(opt6, i, 7, NDUI_GUI_P2B8)
		opt6:SetChecked(NDuiDB["CPoints"]["Enable"])
		opt6:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["CPoints"]["Enable"] = true
			else
				NDuiDB["CPoints"]["Enable"] = false
			end
		end)

		local opt7 = CreateOption(opt7, i, 8, NDUI_GUI_P2B9)
		opt7:SetChecked(NDuiDB["Totems"]["Enable"])
		opt7:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Totems"]["Enable"] = true
			else
				NDuiDB["Totems"]["Enable"] = false
			end
		end)

		local opt8 = CreateOption(opt8, i, 9, NDUI_GUI_P2B10)
		opt8:SetChecked(NDuiDB["Resolve"]["Enable"])
		opt8:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Resolve"]["Enable"] = true
			else
				NDuiDB["Resolve"]["Enable"] = false
			end
		end)
	elseif i == 3 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P3B1)
		opt1:SetChecked(NDuiDB["UFs"]["Enable"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Enable"] = true
			else
				NDuiDB["UFs"]["Enable"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P3B2)
		opt2:SetChecked(NDuiDB["UFs"]["Portrait"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Portrait"] = true
			else
				NDuiDB["UFs"]["Portrait"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P3B3)
		opt3:SetChecked(NDuiDB["UFs"]["ClassColor"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["ClassColor"] = true
			else
				NDuiDB["UFs"]["ClassColor"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 16, NDUI_GUI_P3B4)
		opt4:SetChecked(NDuiDB["UFs"]["SmoothColor"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["SmoothColor"] = true
			else
				NDuiDB["UFs"]["SmoothColor"] = false
			end
		end)

		local opt5 = CreateOption(opt5, i, 4, NDUI_GUI_P3B5)
		opt5:SetChecked(NDuiDB["UFs"]["Smooth"])
		opt5:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Smooth"] = true
			else
				NDuiDB["UFs"]["Smooth"] = false
			end
		end)

		local opt6 = CreateOption(opt6, i, 17, NDUI_GUI_P3B6)
		opt6:SetChecked(NDuiDB["UFs"]["HealPrediction"])
		opt6:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["HealPrediction"] = true
			else
				NDuiDB["UFs"]["HealPrediction"] = false
			end
		end)

		local opt7 = CreateOption(opt7, i, 5, NDUI_GUI_P3B7)
		opt7:SetChecked(NDuiDB["UFs"]["PlayerDebuff"])
		opt7:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["PlayerDebuff"] = true
			else
				NDuiDB["UFs"]["PlayerDebuff"] = false
			end
		end)

		local opt8 = CreateOption(opt8, i, 18, NDUI_GUI_P3B8)
		opt8:SetChecked(NDuiDB["UFs"]["ToTAuras"])
		opt8:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["ToTAuras"] = true
			else
				NDuiDB["UFs"]["ToTAuras"] = false
			end
		end)

		local opt9 = CreateOption(opt9, i, 6, NDUI_GUI_P3B9)
		opt9:SetChecked(NDuiDB["UFs"]["Boss"])
		opt9:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Boss"] = true
			else
				NDuiDB["UFs"]["Boss"] = false
			end
		end)

		local opt10 = CreateOption(opt10, i, 19, NDUI_GUI_P3B10)
		opt10:SetChecked(NDuiDB["UFs"]["Arena"])
		opt10:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Arena"] = true
			else
				NDuiDB["UFs"]["Arena"] = false
			end
		end)

		local opt11 = CreateOption(opt11, i, 8, NDUI_GUI_P3B11)
		opt11:SetChecked(NDuiDB["UFs"]["ExpRep"])
		opt11:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["ExpRep"] = true
			else
				NDuiDB["UFs"]["ExpRep"] = false
			end
		end)

		local opt12 = CreateOption(opt12, i, 15, NDUI_GUI_P3B12)
		opt12:SetChecked(NDuiDB["UFs"]["Castbars"])
		opt12:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Castbars"] = true
			else
				NDuiDB["UFs"]["Castbars"] = false
			end
		end)

		local opt13 = CreateOption(opt13, i, 21, NDUI_GUI_P3B13)
		opt13:SetChecked(NDuiDB["UFs"]["AltPowerBar"])
		opt13:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["AltPowerBar"] = true
			else
				NDuiDB["UFs"]["AltPowerBar"] = false
			end
		end)

		local opt14 = CreateOption(opt14, i, 22, NDUI_GUI_P3B14)
		opt14:SetChecked(NDuiDB["UFs"]["Totems"])
		opt14:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Totems"] = true
			else
				NDuiDB["UFs"]["Totems"] = false
			end
		end)

		local opt15 = CreateOption(opt15, i, 9, NDUI_GUI_P3B15)
		opt15:SetChecked(NDuiDB["UFs"]["CPoints"])
		opt15:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["CPoints"] = true
			else
				NDuiDB["UFs"]["CPoints"] = false
			end
		end)

		local opt16 = CreateOption(opt16, i, 23, NDUI_GUI_P3B16)
		opt16:SetChecked(NDuiDB["UFs"]["Runebar"])
		opt16:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Runebar"] = true
			else
				NDuiDB["UFs"]["Runebar"] = false
			end
		end)

		local opt17 = CreateOption(opt17, i, 10, NDUI_GUI_P3B17)
		opt17:SetChecked(NDuiDB["UFs"]["Harmonybar"])
		opt17:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Harmonybar"] = true
			else
				NDuiDB["UFs"]["Harmonybar"] = false
			end
		end)

		local opt18 = CreateOption(opt18, i, 24, NDUI_GUI_P3B18)
		opt18:SetChecked(NDuiDB["UFs"]["Holybar"])
		opt18:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Holybar"] = true
			else
				NDuiDB["UFs"]["Holybar"] = false
			end
		end)

		local opt19 = CreateOption(opt19, i, 11, NDUI_GUI_P3B19)
		opt19:SetChecked(NDuiDB["UFs"]["Eclipsebar"])
		opt19:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["Eclipsebar"] = true
			else
				NDuiDB["UFs"]["Eclipsebar"] = false
			end
		end)

		local opt20 = CreateOption(opt20, i, 25, NDUI_GUI_P3B20)
		opt20:SetChecked(NDuiDB["UFs"]["WarlockSpecs"])
		opt20:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["WarlockSpecs"] = true
			else
				NDuiDB["UFs"]["WarlockSpecs"] = false
			end
		end)

		local opt21 = CreateOption(opt21, i, 12, NDUI_GUI_P3B21)
		opt21:SetChecked(NDuiDB["UFs"]["ShadowOrbs"])
		opt21:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["UFs"]["ShadowOrbs"] = true
			else
				NDuiDB["UFs"]["ShadowOrbs"] = false
			end
		end)
	elseif i == 4 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P4B1)
		opt1:SetChecked(NDuiDB["Chat"]["Sticky"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Chat"]["Sticky"] = true
			else
				NDuiDB["Chat"]["Sticky"] = false
			end
		end)
	elseif i == 5 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P5B1)
		opt1:SetChecked(NDuiDB["Map"]["Coord"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Map"]["Coord"] = true
			else
				NDuiDB["Map"]["Coord"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P5B2)
		opt2:SetChecked(NDuiDB["Map"]["Invite"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Map"]["Invite"] = true
			else
				NDuiDB["Map"]["Invite"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P5B3)
		opt3:SetChecked(NDuiDB["Map"]["Clock"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Map"]["Clock"] = true
			else
				NDuiDB["Map"]["Clock"] = false
			end
		end)
	elseif i == 6 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P6B1)
		opt1:SetChecked(NDuiDB["Nameplate"]["Enable"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Nameplate"]["Enable"] = true
			else
				NDuiDB["Nameplate"]["Enable"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P6B2)
		opt2:SetChecked(NDuiDB["Nameplate"]["HealthValue"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Nameplate"]["HealthValue"] = true
			else
				NDuiDB["Nameplate"]["HealthValue"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P6B3)
		opt3:SetChecked(NDuiDB["Nameplate"]["TankMode"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Nameplate"]["TankMode"] = true
			else
				NDuiDB["Nameplate"]["TankMode"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 4, NDUI_GUI_P6B4)
		opt4:SetChecked(NDuiDB["Nameplate"]["CombatShow"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Nameplate"]["CombatShow"] = true
			else
				NDuiDB["Nameplate"]["CombatShow"] = false
			end
		end)

		local opt5 = CreateOption(opt5, i, 5, NDUI_GUI_P6B5)
		opt5:SetChecked(NDuiDB["Nameplate"]["TrackAuras"])
		opt5:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Nameplate"]["TrackAuras"] = true
			else
				NDuiDB["Nameplate"]["TrackAuras"] = false
			end
		end)
	elseif i == 7 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P7B1)
		opt1:SetChecked(NDuiDB["Skins"]["DBM"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Skins"]["DBM"] = true
			else
				NDuiDB["Skins"]["DBM"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P7B2)
		opt2:SetChecked(NDuiDB["Skins"]["MicroMenu"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Skins"]["MicroMenu"] = true
			else
				NDuiDB["Skins"]["MicroMenu"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P7B3)
		opt3:SetChecked(NDuiDB["Skins"]["Skada"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Skins"]["Skada"] = true
			else
				NDuiDB["Skins"]["Skada"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 4, NDUI_GUI_P7B4)
		opt4:SetChecked(NDuiDB["Skins"]["RM"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Skins"]["RM"] = true
			else
				NDuiDB["Skins"]["RM"] = false
			end
		end)
	elseif i == 8 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P8B1)
		opt1:SetChecked(NDuiDB["Tooltip"]["CombatHide"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["CombatHide"] = true
			else
				NDuiDB["Tooltip"]["CombatHide"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P8B2)
		opt2:SetChecked(NDuiDB["Tooltip"]["Cursor"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["Cursor"] = true
			else
				NDuiDB["Tooltip"]["Cursor"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 15, NDUI_GUI_P8B3)
		opt3:SetChecked(NDuiDB["Tooltip"]["ClassColor"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["ClassColor"] = true
			else
				NDuiDB["Tooltip"]["ClassColor"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 4, NDUI_GUI_P8B4)
		opt4:SetChecked(NDuiDB["Tooltip"]["HideTitle"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["HideTitle"] = true
			else
				NDuiDB["Tooltip"]["HideTitle"] = false
			end
		end)

		local opt5 = CreateOption(opt5, i, 17, NDUI_GUI_P8B5)
		opt5:SetChecked(NDuiDB["Tooltip"]["HideRealm"])
		opt5:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["HideRealm"] = true
			else
				NDuiDB["Tooltip"]["HideRealm"] = false
			end
		end)

		local opt6 = CreateOption(opt6, i, 5, NDUI_GUI_P8B6)
		opt6:SetChecked(NDuiDB["Tooltip"]["HideRank"])
		opt6:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["HideRank"] = true
			else
				NDuiDB["Tooltip"]["HideRank"] = false
			end
		end)

		local opt7 = CreateOption(opt7, i, 18, NDUI_GUI_P8B7)
		opt7:SetChecked(NDuiDB["Tooltip"]["HidePVP"])
		opt7:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["HidePVP"] = true
			else
				NDuiDB["Tooltip"]["HidePVP"] = false
			end
		end)

		local opt8 = CreateOption(opt8, i, 6, NDUI_GUI_P8B8)
		opt8:SetChecked(NDuiDB["Tooltip"]["HideFaction"])
		opt8:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["HideFaction"] = true
			else
				NDuiDB["Tooltip"]["HideFaction"] = false
			end
		end)

		local opt9 = CreateOption(opt9, i, 19, NDUI_GUI_P8B9)
		opt9:SetChecked(NDuiDB["Tooltip"]["FactionIcon"])
		opt9:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Tooltip"]["FactionIcon"] = true
			else
				NDuiDB["Tooltip"]["FactionIcon"] = false
			end
		end)
	elseif i == 9 then
		local opt1 = CreateOption(opt1, i, 1, NDUI_GUI_P9B1)
		opt1:SetChecked(NDuiDB["Sets"]["Mail"])
		opt1:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["Mail"] = true
			else
				NDuiDB["Sets"]["Mail"] = false
			end
		end)

		local opt2 = CreateOption(opt2, i, 2, NDUI_GUI_P9B2)
		opt2:SetChecked(NDuiDB["Sets"]["Durability"])
		opt2:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["Durability"] = true
			else
				NDuiDB["Sets"]["Durability"] = false
			end
		end)

		local opt3 = CreateOption(opt3, i, 3, NDUI_GUI_P9B3)
		opt3:SetChecked(NDuiDB["Sets"]["HideErrors"])
		opt3:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["HideErrors"] = true
			else
				NDuiDB["Sets"]["HideErrors"] = false
			end
		end)

		local opt4 = CreateOption(opt4, i, 4, NDUI_GUI_P9B4)
		opt4:SetChecked(NDuiDB["Sets"]["Freedom"])
		opt4:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["Freedom"] = true
			else
				NDuiDB["Sets"]["Freedom"] = false
			end
		end)

		local opt5 = CreateOption(opt5, i, 5, NDUI_GUI_P9B5)
		opt5:SetChecked(NDuiDB["Sets"]["SoloInfo"])
		opt5:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["SoloInfo"] = true
			else
				NDuiDB["Sets"]["SoloInfo"] = false
			end
		end)

		local opt6 = CreateOption(opt6, i, 6, NDUI_GUI_P9B6)
		opt6:SetChecked(NDuiDB["Sets"]["RareAlerter"])
		opt6:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["RareAlerter"] = true
			else
				NDuiDB["Sets"]["RareAlerter"] = false
			end
		end)

		local opt7 = CreateOption(opt7, i, 7, NDUI_GUI_P9B7)
		opt7:SetChecked(NDuiDB["Sets"]["Focuser"])
		opt7:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["Focuser"] = true
			else
				NDuiDB["Sets"]["Focuser"] = false
			end
		end)

		local opt8 = CreateOption(opt8, i, 8, NDUI_GUI_P9B8)
		opt8:SetChecked(NDuiDB["Sets"]["Autoequip"])
		opt8:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["Autoequip"] = true
			else
				NDuiDB["Sets"]["Autoequip"] = false
			end
		end)

		local opt9 = CreateOption(opt9, i, 9, NDUI_GUI_P9B9)
		opt9:SetChecked(NDuiDB["Sets"]["ExpRep"])
		opt9:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["ExpRep"] = true
			else
				NDuiDB["Sets"]["ExpRep"] = false
			end
		end)

		local opt10 = CreateOption(opt10, i, 10, NDUI_GUI_P9B10)
		opt10:SetChecked(NDuiDB["Sets"]["Screenshot"])
		opt10:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["Screenshot"] = true
			else
				NDuiDB["Sets"]["Screenshot"] = false
			end
		end)

		local opt11 = CreateOption(opt11, i, 11, NDUI_GUI_P9B11)
		opt11:SetChecked(NDuiDB["Sets"]["TradeTab"])
		opt11:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NDuiDB["Sets"]["TradeTab"] = true
			else
				NDuiDB["Sets"]["TradeTab"] = false
			end
		end)
	end
end

function SelectTab(i)
	for num = 1, #optionlist do
		if num == i then
			_G["NDuiGUI_Tab"..num]:SetBackdropColor(r, g, b, .3)
			_G["NDuiGUI_Page"..num]:Show()
		else
			_G["NDuiGUI_Tab"..num]:SetBackdropColor(0, 0, 0, .3)
			_G["NDuiGUI_Page"..num]:Hide()
		end
	end
end

local function OpenGUI()
	if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
	if f.created then f:Show() return end

	-- Main Frame
	f:SetSize(800, 600)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.CreateBD(f)
	B.CreateTex(f)
	B.CreateFS(f, 18, NDUI_GUI_HEADER, "TOP", 0, -10, true)

	local lu = CreateFrame("Frame", nil, f)
	lu:SetPoint("BOTTOMLEFT", f, "LEFT", 180, 1)
	B.CreateGF(lu, .5, 250, "Vertical", .7, .7, .7, .7, 0)
	lu:SetFrameStrata("HIGH")
	local ld = CreateFrame("Frame", nil, f)
	ld:SetPoint("TOPLEFT", f, "LEFT", 180, -1)
	B.CreateGF(ld, .5, 250, "Vertical", .7, .7, .7, 0, .7)
	ld:SetFrameStrata("HIGH")

	local close = CreateFrame("Button", nil, f)
	close:SetPoint("BOTTOMRIGHT", -15, 15)
	close:SetSize(80, 20)
	B.CreateBD(close, 0.3, 2)
	B.CreateBC(close)
	B.CreateFS(close, 14, CLOSE)
	close:SetScript("OnClick", function(self)
		f:Hide()
	end)
	local ok = CreateFrame("Button", nil, f)
	ok:SetPoint("RIGHT", close, "LEFT", -10, 0)
	ok:SetSize(80, 20)
	B.CreateBD(ok, 0.3, 2)
	B.CreateBC(ok)
	B.CreateFS(ok, 14, OKAY)
	ok:SetScript("OnClick", function(self)
		f:Hide()
		StaticPopup_Show("RELOAD_NDUI")
	end)

	for i = 1, #optionlist do
		local f = CreateFrame("Frame", "NDuiGUI_Page"..i, NDuiGUI)
		f:SetPoint("TOPLEFT", 200, -60)
		f:SetSize(570, 500)
		B.CreateBD(f, .3, .1)
		f:Hide()
		SetOption(i)
		tab[i] = CreateTab(i, optionlist[i])
		tab[i]:SetScript("OnClick", function(self)
			PlaySound("igMainMenuOptionCheckBoxOn")
			SelectTab(i)
		end)
	end

	f:Show()
	SelectTab(1)
	f.created = true
end

local gui = CreateFrame("Button", "GameMenuFrameNDui", GameMenuFrame, "GameMenuButtonTemplate")
gui:SetText(NDUI_GUI_HEADER)
gui:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -21)
GameMenuFrame:HookScript("OnShow", function(self)
	GameMenuButtonLogout:SetPoint("TOP", gui, "BOTTOM", 0, -21)
	self:SetHeight(self:GetHeight() + gui:GetHeight() + 22)
end)

gui:SetScript("OnClick", function()
	OpenGUI()
	HideUIPanel(GameMenuFrame)
	PlaySound("igMainMenuOption")
end)

-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	F = unpack(Aurora)
	F.Reskin(gui)
end