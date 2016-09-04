------------------------
--	PetTip(by ape47)
------------------------
local B, C, L, DB = unpack(select(2, ...))
if not C.Tooltip.Enable then return end

local pisize = 20
local PET_TYPE_SUFFIX, UnitIsBattlePetCompanion, UnitIsWildBattlePet, UnitBattlePetType, UnitBattlePetLevel = PET_TYPE_SUFFIX, UnitIsBattlePetCompanion, UnitIsWildBattlePet, UnitBattlePetType, UnitBattlePetLevel

local function GetPetTypeTexture(petType)
	if PET_TYPE_SUFFIX[petType] then
		return "Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType]
	end
end

local function DetectPet(self)
	local _, unit = self:GetUnit()
	if not unit then return end
	if not UnitIsBattlePet(unit) then return end
	-- Pet Species icon
	local peticon = '|T'..GetPetTypeTexture(UnitBattlePetType(unit))..':'..pisize..':'..pisize..':0:0:128:256:62:102:128:168|t'
	GameTooltipTextLeft1:SetText(peticon..' '..GameTooltipTextLeft1:GetText())
	-- Pet ID
	local speciesID = UnitBattlePetSpeciesID(unit)
	self:AddDoubleLine(PET..ID..":", ((DB.InfoColor..speciesID.."|r") or (DB.GreyColor..UNKNOWN.."|r")))
end
GameTooltip:HookScript('OnTooltipSetUnit', DetectPet)