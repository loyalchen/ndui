local B, C, L, DB = unpack(select(2, ...))
if not C.UFs.Enable then return end
local addon, ns = ...
local lib = ns.lib
local oUF = ns.oUF or oUF

-----------------------------
-- STYLE FUNCTIONS
-----------------------------
local function CreatePlayerStyle(self, unit, isSingle)
	self.mystyle = "player"
	lib.init(self)
	self:SetSize(245, 30)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_ppstrings(self)
	lib.gen_castbar(self)
	lib.gen_RaidMark(self)
	lib.gen_InfoIcons(self)
	lib.gen_Resting(self)
	lib.gen_portrait(self)
	if NDuiDB["UFs"]["ExpRep"] then
		lib.Experience(self)
		lib.Reputation(self)
	end
	if NDuiDB["UFs"]["PlayerDebuff"] then lib.createDebuffs(self) end
	if NDuiDB["UFs"]["AltPowerBar"] then lib.AltPowerBar(self) end
	if NDuiDB["UFs"]["Runebar"] then lib.genRunes(self) end
	if NDuiDB["UFs"]["Holybar"] then lib.genHolyPower(self) end
	if NDuiDB["UFs"]["Harmonybar"] then lib.genHarmony(self) end
	if NDuiDB["UFs"]["ShadowOrbs"] then lib.genShadowOrbs(self) end
	if NDuiDB["UFs"]["WarlockSpecs"] then lib.genWarlockSpecBars(self) end
	if NDuiDB["UFs"]["Eclipsebar"] then lib.addEclipseBar(self) end
	if NDuiDB["UFs"]["Totems"] then lib.TotemBars(self) end
	if NDuiDB["UFs"]["CPoints"] then lib.genCPoints(self) end
end

local function CreateTargetStyle(self, unit, isSingle)
	self.mystyle = "target"
	lib.init(self)
	self:SetSize(245, 30)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_ppstrings(self)
	lib.gen_castbar(self)
	lib.gen_mirrorcb(self)
	lib.gen_RaidMark(self)
	lib.gen_InfoIcons(self)
	lib.addQuestIcon(self)
	lib.addPhaseIcon(self)
	lib.createAuras(self)
	lib.gen_portrait(self)
end

local function CreateFocusStyle(self, unit, isSingle)
	self.mystyle = "focus"
	lib.init(self)
	self:SetSize(200, 27)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_ppstrings(self)
	lib.gen_castbar(self)
	lib.gen_RaidMark(self)
	lib.gen_InfoIcons(self)
	lib.createAuras(self)
	lib.gen_portrait(self)
end

local function CreateToTStyle(self, unit, isSingle)
	self.mystyle = "tot"
	lib.init(self)
	self:SetSize(120, 27)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_RaidMark(self)
	if NDuiDB["UFs"]["ToTAuras"] then lib.createAuras(self) end
end

local function CreateFocusTargetStyle(self, unit, isSingle)
	self.mystyle = "focustarget"
	lib.init(self)
	self:SetSize(120, 27)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_RaidMark(self)
end

local function CreatePetStyle(self, unit, isSingle)
	local _, playerClass = UnitClass("player")
	self.mystyle = "pet"
	lib.init(self)
	self:SetSize(120, 27)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_castbar(self)	--Hide Vehicle castbar
	lib.gen_RaidMark(self)
end

local function CreateBossStyle(self, unit, isSingle)
	self.mystyle = "boss"
	self:SetSize(150, 20)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_ppstrings(self)
	lib.gen_castbar(self)
	lib.gen_RaidMark(self)
	lib.AltPowerBar(self)
	lib.createBuffs(self)
	lib.createDebuffs(self)
end

local function CreateArenaStyle(self, unit, isSingle)
	self.mystyle = "oUF_Arena"
	self:SetSize(150, 28)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_castbar(self)
	lib.gen_RaidMark(self)
	lib.createBuffs(self)
	lib.createDebuffs(self)
	lib.gen_portrait(self)
end

-----------------------------
-- SPAWN UNITS
-----------------------------
oUF:RegisterStyle("Player", CreatePlayerStyle)
oUF:RegisterStyle("Target", CreateTargetStyle)
oUF:RegisterStyle("ToT", CreateToTStyle)
oUF:RegisterStyle("Focus", CreateFocusStyle)
oUF:RegisterStyle("FocusTarget", CreateFocusTargetStyle)
oUF:RegisterStyle("Pet", CreatePetStyle)
oUF:RegisterStyle("Boss", CreateBossStyle)
oUF:RegisterStyle("oUF_Arena", CreateArenaStyle)

oUF:Factory(function(self)
	if not NDuiDB["UFs"]["Enable"] then return end

	self:SetActiveStyle("Player")
	local player = self:Spawn("player", "oUF_Player")
	player:SetPoint(unpack(C.UFs.PlayerPos))

	self:SetActiveStyle("Target")
	local target = self:Spawn("Target", "oUF_Target")
	target:SetPoint(unpack(C.UFs.TargetPos))

	self:SetActiveStyle("ToT")
	local targettarget = self:Spawn("targettarget", "oUF_tot")
	targettarget:SetPoint(unpack(C.UFs.ToTPos)) 

	self:SetActiveStyle("Pet")
	local pet = self:Spawn("pet", "oUF_pet")
	pet:SetPoint(unpack(C.UFs.PetPos))

	self:SetActiveStyle("Focus")
	local focus = self:Spawn("focus", "oUF_focus")
	focus:SetPoint(unpack(C.UFs.FocusPos))

	self:SetActiveStyle("FocusTarget")
	local focustarget = self:Spawn("focustarget", "oUF_focustarget")
	focustarget:SetPoint("LEFT", oUF_focus, "RIGHT", 7, 0)

  	if NDuiDB["UFs"]["Boss"] then
		self:SetActiveStyle("Boss")
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
			if i == 1 then
				boss[i]:SetPoint("RIGHT", UIParent, "RIGHT", -100, -90)
			else
				boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, 59)
			end
		end
	end

	if NDuiDB["UFs"]["Arena"] then
		oUF:SetActiveStyle("oUF_Arena")
		local arena = {}
		for i = 1, 5 do
			arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
			if i == 1 then
				arena[i]:SetPoint("TOP", UIParent, "BOTTOM", 500, 550)
			else
				arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 35)
			end
			arena[i]:SetSize(150, 28)
		end
		
		local QulightPrepArena = {}
		for i = 1, 5 do
			QulightPrepArena[i] = CreateFrame("Frame", "QulightPrepArena"..i, UIParent)
			QulightPrepArena[i]:SetAllPoints(arena[i])
			QulightPrepArena[i]:SetBackdropColor(0, 0, 0)
			B.CreateBD(QulightPrepArena[i])
			QulightPrepArena[i].Health = CreateFrame("StatusBar", nil, QulightPrepArena[i])
			QulightPrepArena[i].Health:SetAllPoints()
			QulightPrepArena[i].Health:SetStatusBarTexture(statusbar_texture)
			QulightPrepArena[i].Health:SetStatusBarColor(.3, .3, .3)
			QulightPrepArena[i].SpecClass = QulightPrepArena[i].Health:CreateFontString(nil, "OVERLAY")
			QulightPrepArena[i].SpecClass:SetFont(unpack(DB.Font))
			QulightPrepArena[i].SpecClass:SetPoint("CENTER")
			QulightPrepArena[i]:Hide()
		end

		local ArenaListener = CreateFrame("Frame", "QulightArenaListener", UIParent)
		ArenaListener:RegisterEvent("PLAYER_ENTERING_WORLD")
		ArenaListener:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		ArenaListener:RegisterEvent("ARENA_OPPONENT_UPDATE")
		ArenaListener:SetScript("OnEvent", function(self, event)
			if event == "ARENA_OPPONENT_UPDATE" then
				for i = 1, 5 do
					local f = _G["QulightPrepArena"..i]
					f:Hide()
				end
			else
				local numOpps = GetNumArenaOpponentSpecs()
				if numOpps > 0 then
					for i = 1, 5 do
						local f = _G["QulightPrepArena"..i]
						local s = GetArenaOpponentSpec(i)
						local _, spec, class = nil, "UNKNOWN", "UNKNOWN"
						if s and s > 0 then 
							_, spec, _, _, _, _, class = GetSpecializationInfoByID(s)
						end
						if (i <= numOpps) then
							if class and spec then
								local color = arena[i].colors.class[class]
								f.Health:SetStatusBarColor(unpack(color))
								f.SpecClass:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])
								f:Show()
							end
						else
							f:Hide()
						end
					end
				else
					for i = 1, 5 do
						local f = _G["QulightPrepArena"..i]
						f:Hide()
					end
				end
			end
		end)
	end
end)
--[[
do
	UnitPopupMenus["BATTLEPET"] = { "PET_SHOW_IN_JOURNAL", "SET_FOCUS", "OTHER_SUBSECTION_TITLE", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "CANCEL" };
	UnitPopupMenus["OTHERBATTLEPET"] = { "PET_SHOW_IN_JOURNAL", "SET_FOCUS", "OTHER_SUBSECTION_TITLE", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "REPORT_BATTLE_PET", "CANCEL" };
end]]