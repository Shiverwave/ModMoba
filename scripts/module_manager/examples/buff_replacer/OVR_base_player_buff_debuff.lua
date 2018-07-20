----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_base_player_buff_debuff.lua
-- Author:        DjOli (Adam Britto)
-- Type:          Override
-- Date:          23/9/16
-- Description:   Override AddBuff method to allow buff overrides.
----------------------------------------------------------------------------------------------------------------------------------
local default_AddBuff = AddBuff

function AddBuff(buff, timeSecs)
  local buffs = this:GetObjVar("BuffIcons") or {}

  -- Go through the buffs, if we find the current one, replace it.
  for i, existingBuff in pairs(buffs) do
    if (existingBuff.Identifier == buff.Identifier) then
      buffs[i] = buff
      this:SetObjVar("BuffIcons", buffs)
      ShowBuffWindow()
      return
    end
  end

  -- If we got this far, the buff isn't present yet. Refer to default.
  default_AddBuff(buff, timeSecs)
end
