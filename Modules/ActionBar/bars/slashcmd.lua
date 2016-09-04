-----------------------------
-- INIT
-----------------------------
local addon, ns = ...
local dragFrameList = {}
local color         = "|cff00ff00"
local shortcut      = "ab"

--make variables available in the namespace
ns.dragFrameList    = dragFrameList
ns.addonColor       = color
ns.addonShortcut    = shortcut

-----------------------------
-- FUNCTIONS
-----------------------------
SlashCmdList[shortcut] = rCreateSlashCmdFunction(addon, shortcut, dragFrameList, color)
SLASH_ab1 = "/"..shortcut --the value in the between SLASH_ and NUMBER has to match the value of shortcut