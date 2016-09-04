----------------------------------
-- dimInfo by Loshine, NDui MOD
----------------------------------
local addon, ns = ...
local cfg = CreateFrame("Frame")

-- Top infobar
cfg.Guild = true
cfg.GuildPoint = {"topleft", UIParent, 10, -5}

cfg.Friends = true
cfg.FriendsPoint = {"topleft", UIParent, 100, -5}

cfg.System = true
cfg.SystemPoint = {"topleft", UIParent, 190, -5}

cfg.Memory = true
cfg.MemoryPoint = {"topleft", UIParent, 310, -5}
cfg.MaxAddOns = 20

cfg.Positions = true
cfg.PositionsPoint = {"topleft", UIParent, 390, -5}

-- Bottomright infobar
cfg.Spec = true
cfg.SpecPoint = {"bottomright", UIParent, -310, 5}

cfg.Durability = true
cfg.DurabilityPoint = {"bottomright", UIParent, -190, 5}

cfg.Gold = true
cfg.GoldPoint = {"bottomright", UIParent, -90, 5}

cfg.Time = true
cfg.TimePoint = {"bottomright", UIParent, -20, 5}

-- Fonts and Colors
cfg.Fonts = {STANDARD_TEXT_FONT, 13, "THINOUTLINE"}
cfg.ColorClass = true

ns.cfg = cfg

-- init
local init = CreateFrame("Frame")

local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass('player'))] 
init.Colored = ("|cff%.2x%.2x%.2x"):format(classc.r * 255, classc.g * 255, classc.b * 255)

init.gradient = function(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1,g1,b1,r2,g2,b2 = select(seg*3+1,1,0,0,1,1,0,0,1,0,0,0,0) -- R -> Y -> G
	local r,g,b = r1+(r2-r1)*relperc,g1+(g2-g1)*relperc,b1+(b2-b1)*relperc
	return format("|cff%02x%02x%02x",r*255,g*255,b*255),r,g,b
end

if (diminfo == nil) then diminfo = {}; end

ns.init = init