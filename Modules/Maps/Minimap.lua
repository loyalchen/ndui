local B, C, L, DB = unpack(select(2, ...))
if not C.Minimap.Enable then return end

-- Shape, location and scale
function GetMinimapShape() return "SQUARE" end
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(C.Minimap.Pos))
MinimapCluster:SetScale(C.Minimap.Scale)
Minimap:SetFrameLevel(10)
DropDownList1:SetClampedToScreen(true)

-- Mask texture hint => addon will work with Carbonite
local hint = CreateFrame("Frame")
local total = 0
local SetTextureTrick = function(self, elapsed)
    total = total + elapsed
    if(total > 2) then
        Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
        hint:SetScript("OnUpdate", nil)
    end
end

hint:RegisterEvent("PLAYER_LOGIN")
hint:SetScript("OnEvent", function()
    hint:SetScript("OnUpdate", SetTextureTrick)
end)

-- Background
local MBG = CreateFrame("Frame", nil, Minimap)
MBG:SetFrameLevel(Minimap:GetFrameLevel() - 1)
MBG:SetPoint("TOPLEFT", -4, 4)
MBG:SetPoint("BOTTOMRIGHT", 4, -4)
B.CreateBD(MBG)

-- Mousewheel zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

-- Hiding ugly things
local dummy = function() end
local _G = getfenv(0)

local frames = {
    "GameTimeFrame",
    "MinimapBorderTop",
    "MinimapNorthTag",
    "MinimapBorder",
    "MinimapZoneTextButton",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MiniMapMailBorder",
    "MiniMapTracking",
}

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end
MinimapCluster:EnableMouse(false)
Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)

-- Garrison
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -3, 3)
GarrisonLandingPageMinimapButton:SetSize(42, 42)
GarrisonLandingPageMinimapButton:SetScale(0.7)

-- QueueStatus Button
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButtonBorder:Hide()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, -5)

-- Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
MiniMapInstanceDifficulty:SetScale(0.75)
MiniMapInstanceDifficulty:SetFrameStrata("LOW")

-- Guild Instance Difficulty flag
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
GuildInstanceDifficulty:SetScale(0.75)
GuildInstanceDifficulty:SetFrameStrata("LOW")

-- Mail icon
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
MiniMapMailIcon:SetTexture(DB.Mail)
MiniMapMailFrame:SetFrameStrata("LOW")

-- Invites Icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent("Minimap")
GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")
local Invt = CreateFrame("Button")
Invt:SetPoint("TOPRIGHT", Minimap, "BOTTOMLEFT", -20, -20)
Invt:SetSize(200, 50)
B.CreateBD(Invt)
B.CreateTex(Invt)
Invt.Text = Invt:CreateFontString(nil, "OVERLAY")
Invt.Text:SetFont(unpack(DB.Font))
Invt.Text:SetPoint("CENTER", Invt)
Invt.Text:SetText(DB.InfoColor..GAMETIME_TOOLTIP_CALENDAR_INVITES)
Invt:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
Invt:RegisterEvent("PLAYER_ENTERING_WORLD")
Invt:SetScript("OnEvent", function()
	if not NDuiDB["Map"] then NDuiDB["Map"] = {} end
	if NDuiDB["Map"]["Invite"] and CalendarGetNumPendingInvites() > 0 then
		Invt:Show()
	else
		Invt:Hide()
	end
end)
Invt:RegisterForClicks("AnyUp")
Invt:SetScript("OnClick", function(self, btn)
	self:UnregisterAllEvents()
	if btn == "LeftButton" then
		ToggleCalendar()
		Invt:Hide()
	else
		Invt:Hide()
	end
end)

-- Micro button alerts
if TalentMicroButtonAlert then
	TalentMicroButtonAlert:ClearAllPoints()
	TalentMicroButtonAlert:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -220, 40)
	TalentMicroButtonAlert:SetScript("OnMouseUp", function(self, button)
		if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end
		ToggleFrame(PlayerTalentFrame)
	end)
end

if EJMicroButtonAlert then
	EJMicroButtonAlert:ClearAllPoints()
	EJMicroButtonAlert:SetPoint("BOTTOM", UIParent, "BOTTOM", 45, 40)
	EJMicroButtonAlert:SetScript("OnMouseUp", function(self, button)
		if not EncounterJournal then LoadAddOn("Blizzard_EncounterJournal") end
		ToggleFrame(EncounterJournal)
	end)
end

if CollectionsMicroButtonAlert then
	CollectionsMicroButtonAlert:ClearAllPoints()
	CollectionsMicroButtonAlert:SetPoint("BOTTOM", UIParent, "BOTTOM", 65, 40)
	CollectionsMicroButtonAlert:SetScript("OnMouseUp", function(self, button)
		if not IsAddOnLoaded("Blizzard_Collections") then LoadAddOn("Blizzard_Collections") end
		ToggleFrame(PetJournalParent)
	end)
end

if TicketStatusFrame then
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOP", UIParent, "TOP", -400, -20)
end

-- Click func
Minimap:SetScript('OnMouseUp', function(self, btn)
Minimap:StopMovingOrSizing()
    if btn == "MiddleButton" then
        ToggleCalendar()
    elseif btn =="RightButton" then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), (Minimap:GetWidth() * 0.3))
    else
        Minimap_OnClick(self)
    end
end)

-- Clock
local c = CreateFrame("Frame")
c:RegisterEvent("PLAYER_ENTERING_WORLD")
c:SetScript("OnEvent", function()
	if NDuiDB["Map"]["Clock"] then
		if not TimeManagerClockButton then LoadAddOn("Blizzard_TimeManager") end
		local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
		clockFrame:Hide()
		clockTime:SetFont(unpack(DB.Font))
		clockTime:SetTextColor(1,1,1)
		TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -6)
		TimeManagerClockButton:SetScript("OnMouseUp", function(_,click)
			if click == "RightButton" then
				if not CalendarFrame then
					LoadAddOn("Blizzard_Calendar")
				end
				CalendarFrame:Show()
			end
		end)
	else
		if TimeManagerClockButton then TimeManagerClockButton:Hide() end
		GameTimeFrame:Hide()
	end
end)