----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_guard_protect.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Change 'DamageInflicted' handler to ignore non-lethal damage.
--                Fire a message when entering/exiting guard protection.
----------------------------------------------------------------------------------------------------------------------------------

-- Override the default event to include pvp lethality check.
-- TODO: If the default method becomes a stand alone function, this should be changed to apply the mod, then call the base function.
function OVRDamageInflicted(damager, damageAmt)
  if (damager:HasObjVar("CalledGuardsFirst") 
              or damager:HasModule("ai_guard") 
              or damager:HasModule("ai_super_guard")
              or damager:IsImmortal()
              or damager:HasObjVar("Invulnerable")) then
    return
  end

  if (this:HasTimer("EndGuardCallProtection")) then
    return
  end

  local guardProtectionType = GetGuardProtection()

  --slay anyone who PvP's in a region they're not supposed to even do combat in.
  if (guardProtectionType == "InstaKill" and not damager:IsDemiGod() ) then
    damager:SendMessage("ProcessDamage", this, 5000)
    damager:PlayEffect("LightningCloudEffect")
    damager:SystemMessage("Beings more powerful than you do not approve of violence in this sanctuary.")
    this:SetObjVar("CalledGuardsFirst",true)
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000), "EndGuardCallProtection")
    return
  end

  local crimeIndex = CRIME_ASSAULT

  if(IsDead(this)) then
    crimeIndex = CRIME_MURDER
  --  return
  end     

  --DebugMessage("*********HandleDamageReceived "..tostring(damager).. ", "..tostring(damageAmt))

  if( damager == nil or not(damager:IsValid()) or IsDead(damager) or damager == this ) then
    return
  end

  if (GetFaction(this,"Villagers") < -35) then
    return
  end
  --no protection for traitor's pets either
  local controller = this:GetObjVar("controller")
  if (controller ~= nil and GetFaction(controller,"Villagers") < -35) then
    return
  end

  local damagerIsPlayer = damager:IsPlayer()
  local thisIsPlayer = this:IsPlayer()
  local damagerIsLethal = false
  if (damager:GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_DEADLY) then
    damagerIsLethal = true
  end

  --DFB HACK to stop them from slaying NPC's you get into fights with
  if (thisIsPlayer and not damagerIsPlayer and damager:GetObjVar("MobileTeamType") == "Villagers") then
    return
  end

  if(thisIsPlayer and damagerIsPlayer and (this:HasTimer("EnteredProtection") or not damagerIsLethal)) then
    return      
  end

  local guardObj = GetNearestGuard()

  --if( searchRegion ~= nil ) then  
  --DebugMessage("*********Search region "..searchRegion.. ", guard: "..tostring(guardObj))
  if( guardObj == nil ) then
    --if guarneteed guard protection is enabled then spawn a super guard that slays whoever starts a fight in these areas.
    if (guardProtectionType == "Guard" and damager:IsPlayer() and this:IsPlayer()) then
      local playerLoc = damager:GetLoc()
      
      
      --DebugMessage("[player:HandleDamageTaken] "..this:GetName()..": No guard to help me")
      for i=0,1 do
        local spawnPosition = GetSpawnPosition(this:GetLoc())
        CreateObj("super_guard", spawnPosition, "super_guard", damager)
      end
        
      this:SetObjVar("CalledGuardsFirst",true)
      this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000), "EndGuardCallProtection")
    end
    return
  end
  
  --if it's an attack by the pet
  if (damager:HasObjVar("controller")) then
    local firstGuard = guardObj --save the first guard
    local secondGuard = GetNearestGuard(guardObj) --get a second gaurd
    firstGuard:SendMessage("AttackEnemy",damager) --send the first guard to kill the pet
    damager:SendMessage("EndCombatMessage")--stop the animal so it doesn't spam it.
    damager = damager:GetObjVar("controller")  --target the player for prosecution
    crimeIndex = CRIME_ANIMAL_ATTACK --set it to an animal attack
    guardObj = secondGuard --set the guard object to the guard that isn't preoccupied.
  end

  if (this:HasModule("ai_guard")) then
    crimeIndex = CRIME_ASSAULT_ON_OFFICER
  end

  if not this:IsPlayer() and not this:HasModule("ai_guard") and not IsDead(this) then
    this:NpcSpeech("Help! Guards!!")
  end

  this:SetObjVar("CalledGuardsFirst",true)
  this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000), "EndGuardCallProtection")
  
  guardObj:SendMessage("RequestHelp",damager,crimeIndex,this)   
  --end
end


-- Mod to fire a message when entering or leaving guard protection.
local default_UpdatePlayerProtection = UpdatePlayerProtection

function UpdatePlayerProtection(curProtection)
  if (curProtection ~= playerGuardProtection) then
    -- Call the default method first.
    default_UpdatePlayerProtection(curProtection)
    this:SendMessage(PALMSG_LETHALITY_UDATE_IN_GUARD_PROTECTION, not (curProtection == "None"))
  end
end