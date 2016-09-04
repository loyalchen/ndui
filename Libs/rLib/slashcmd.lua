
  -- // slashcmd functionality
  -- // zork - 2012

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------
  local InfoColor = "|cff70C0F5"

  --rCreateSlashCmdFunction func
  function rCreateSlashCmdFunction(addon, shortcut, dragFrameList, color)
    if not addon or not shortcut or not dragFrameList then return end
    local slashCmdFunction = function(cmd)
      if (cmd:match"unlock") then
        rUnlockAllFrames(dragFrameList, color..addon..": "..InfoColor..ACTIONBAR_TEXT_UNLOCK)
      elseif (cmd:match"lock") then
        rLockAllFrames(dragFrameList, color..addon..": "..InfoColor..ACTIONBAR_TEXT_LOCK)
      elseif (cmd:match"reset") then
        rResetAllFramesToDefault(dragFrameList, color..addon..": "..InfoColor..ACTIONBAR_TEXT_RESET)
      else
        print(InfoColor.."------------------------")
        print("|cff0080ff"..addon.." "..InfoColor..ACTIONBAR_TEXT_CMD_LIST..":")
        print(color.."\/"..shortcut.." lock|r "..InfoColor..ACTIONBAR_TEXT_LOCK)
        print(color.."\/"..shortcut.." unlock|r "..InfoColor..ACTIONBAR_TEXT_UNLOCK)
        print(color.."\/"..shortcut.." reset|r "..InfoColor..ACTIONBAR_TEXT_RESET)
        print(InfoColor.."------------------------")
      end
    end
    return slashCmdFunction
  end