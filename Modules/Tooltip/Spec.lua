local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

local gtt = GameTooltip
local TALENTS_PREFIX = SPECIALIZATION..": "..DB.InfoColor
local NO_TALENTS = DB.GreyColor..NONE.."|r"
local CACHE_SIZE = 25
local INSPECT_DELAY = 0.2
local INSPECT_FREQ = 2
local ttt = CreateFrame("Frame", nil)
local cache = {}
local current = {}

lastInspectRequest = 0
ttt.cache = cache
ttt.current = current
ttt:Hide()
local function IsInspectFrameOpen() return (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown()) end

local function GatherTalents(isInspect)
	local spec = isInspect and GetInspectSpecialization(current.unit) or GetSpecialization()
	if (spec) and (spec > 0) then
		local _, specName = GetSpecializationInfoByID(spec)
		local _, tname, _, selected = GetTalentInfo(7, 3, GetActiveSpecGroup(true), true, current.unit)
		if spec == 73 and selected then
			current.format = specName.." ("..tname..")" or "N/A"
		else
			current.format = specName or "N/A"
		end
	else
		current.format = NO_TALENTS
	end

	if (not isInspect) then
		local spec1 = GetSpecialization()
		if spec1 == nil then
			gtt:AddLine(TALENTS_PREFIX..NO_TALENTS)
		else
			local id, specName1 = GetSpecializationInfo(spec1)
			local _, tname, _, selected = GetTalentInfo(7, 3, GetActiveSpecGroup())
			if id == 73 and selected then
				gtt:AddLine(TALENTS_PREFIX..specName1.." ("..tname..")|r")
			else
				gtt:AddLine(TALENTS_PREFIX..specName1.."|r")
			end
		end
	elseif (gtt:GetUnit()) then
		for i = 2, gtt:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX)) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s", TALENTS_PREFIX, current.format.."|r")
				if (not gtt.fadeOut) then
					gtt:Show()
				end
				break
			end
		end
	end

	local cacheSize = CACHE_SIZE
	for i = #cache, 1, -1 do
		if (current.name == cache[i].name) then
			tremove(cache,i)
			break
		end
	end
	if (#cache > cacheSize) then
		tremove(cache,1)
	end
	if (cacheSize > 0) then
		cache[#cache + 1] = CopyTable(current)
	end
end

ttt:SetScript("OnEvent",function(self,event,guid)
	self:UnregisterEvent(event)
	if (guid == current.guid) then
		GatherTalents(1)
	end
end)

ttt:SetScript("OnUpdate",function(self,elapsed)
	self.nextUpdate = (self.nextUpdate - elapsed)
	if (self.nextUpdate <= 0) then
		self:Hide()
		if (UnitGUID("mouseover") == current.guid) and (not IsInspectFrameOpen()) then
			lastInspectRequest = GetTime()
			self:RegisterEvent("INSPECT_READY")
			NotifyInspect(current.unit)
		end
	end
end)

gtt:HookScript("OnTooltipSetUnit",function(self,...)
	ttt:Hide()
	local _, unit = self:GetUnit()
	if (not unit) then
		local mFocus = GetMouseFocus()
		if (mFocus) and (mFocus.unit) then
			unit = mFocus.unit
		end
	end
	if (not unit) or (not UnitIsPlayer(unit)) then
		return
	end
	local level = UnitLevel(unit)
	if (level > 9 or level == -1) then
		wipe(current)
		current.unit = unit
		current.name = UnitName(unit)
		current.guid = UnitGUID(unit)
		if (UnitIsUnit(unit,"player")) then
			GatherTalents()
			return
		end
		local cacheLoaded = false
		for _, entry in ipairs(cache) do
			if (current.name == entry.name) then
				self:AddLine(TALENTS_PREFIX..entry.format.."|r")
				current.format = entry.format
				cacheLoaded = true
				break
			end
		end
		if (CanInspect(unit)) and (not IsInspectFrameOpen()) then
			local lastInspectTime = (GetTime() - lastInspectRequest)
			ttt.nextUpdate = (lastInspectTime > INSPECT_FREQ) and INSPECT_DELAY or (INSPECT_FREQ - lastInspectTime + INSPECT_DELAY)
			ttt:Show()
			if (not cacheLoaded) then
				self:AddLine(TALENTS_PREFIX..LFG_LIST_LOADING)
			end
		end
	end
end)