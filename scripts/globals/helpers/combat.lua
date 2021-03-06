-- NOTE: Just adding to this table does not add new stats. There are many places in code that reference the stat names directly (We should fix this one day)
allStatsTable = {
	"Strength",
	"Agility",
	"Intelligence",
	"Constitution",
	"Wisdom",
	"Will"
}

-- This is not in server settings because it is deeply engrained in the combat system. Not something that is easily modified
ARMORSLOTS ={
	"Head",
	"Chest",
	"Legs"
}

--- Determine if a mobile is disbabled (cannot cast, move, swing, use items or abilites)
-- @param mobileObj
-- @return true if mobile is disabled.
function IsMobileDisabled(mobileObj)
	return ( mobileObj:GetObjVar("Disabled") == true )
end

--- Determine if the mobile has an effect that makes them immune.
-- @param mobileObj
-- @return true if mobile is immune
function IsMobileImmune(mobileObj)
	return ( HasMobileEffect(mobileObj, "Immune") )
end

--- Determine if a is withing range of b
-- @param objA gameObj
-- @param objB gameObj
-- @param range double
-- @return true if within in range.
function WithinRange(objA, objB, range)
	if( objA == nil or not objA:IsValid() or objB == nil or not objB:IsValid() ) then return false end
	if ( objA == objB ) then return true end
	local distance = objA:DistanceFrom(objB)
    if( distance == nil ) then return false end
    return ( distance <= range )
end

--- Determine if an attacker is within range of a defender given a weaponType.
function WithinWeaponRange(attacker, defender, weaponType)
    return WithinRange(attacker, defender, GetCombatWeaponRange(attacker, defender, weaponType))
end

--- Determine if an attacker is within range of a defender given a range.
function WithinCombatRange(attacker, defender, range)
    return WithinRange(attacker, defender, GetCombatRange(attacker, defender, range))
end

--- Get the distance attacker must be from defender for combat.
-- @param attacker mobileObj
-- @param defender mobileObj
-- @param range double, distance between the two or barehand range if not provided
-- @return distance to consider attacker close enough to defender for combat
function GetCombatRange(attacker, defender, range)
	return ( range or Weapon.GetRange("BareHand") ) + GetBodySize(attacker) + GetBodySize(defender)
end

--- Convenience function that does what GetCombatRange does, but instead takes a weaponType as last parameter
-- @param attacker mobileObj (for body size/weapon range)
-- @param defender mobileObj (for body size)
-- @param weaponType(optional) string Defaults to weapon type of primary weapon for attacker
-- @return distance to consider attacker close enough to defender for combat
function GetCombatWeaponRange(attacker, defender, weaponType)
	weaponType = weaponType or GetPrimaryWeaponType(attacker)
	return GetCombatRange(attacker, defender, Weapon.GetRange(weaponType))
end

--- Determine if a gameObj is valid to gain skill on
-- @param gameObj
-- @param gainer
-- @return true if valid to gain skill from this gameObj.
function ValidCombatGainTarget(target,gainer)
	if ( target:IsPlayer() ) then return false end

	-- objects with attackable can be gained, they will default to 0 skill, (set a skill dictionary on them to change it)
	return ( target:GetObjVar("CombatGainable") == true or (target:IsMobile() and not IsDead(target) and not target:GetObjVar("Invulnerable")) )
end

--- Determine if an attacker can attack/damage a victim
-- @param attack mobileObj, the mobile doing the targeting.
-- @param victim mobileObj, the mobile being targeted.
-- @return true if valid combat target
function ValidCombatTarget(attacker, victim, silent)
	-- validate our attacker and victim
	if ( attacker == nil or victim == nil ) then return false end
	if ( not attacker:IsValid() or not victim:IsValid() ) then return false end
	if ( victim:IsMobile() ) then
		if ( IsDead(victim) ) then return false end
	else
		if ( victim:GetObjVar("Attackable") ~= true ) then return false end
	end
	if ( IsImmortal(attacker) and not TestMortal(attacker) ) then return true end
	-- handle attacking cloaked targets.
	if ( victim:IsCloaked() and not ShouldSeeCloakedObject(attacker, victim) ) then return false end

	-- prevent attacking guard protected stuff when the karma protection flag is on
	if ( ShouldKarmaProtect(attacker, victim, silent) ) then
		return false
	end

	-- default to attack everything (sandbox!)
	return true
end

---- TODO: Transition this to IsFriend function ( to help with auto targets and AoE effects )
--- Allow friendly actions to a potential friend?
-- @param mobileObj
-- @param potentialFriend mobileObj
-- @param notSilent(optional) Boolean
-- @param return true or false
function AllowFriendlyActions(mobileObj, potentialFriend, notSilent)

	-- reassign variables to the owner if applicable
	mobileObj = mobileObj:GetObjectOwner() or mobileObj
	potentialFriend = potentialFriend:GetObjectOwner() or potentialFriend

	-- always friendly to yourself and your pets.
	if ( mobileObj == potentialFriend ) then return true end

	-- allegiance rules
	-- prevent people in an allegiance benefiting anyone not in their allegiance
	local myAllegianceId = GetAllegianceId(mobileObj)
	-- in an allegiance, check if the potential friend is in an allegiance
	local theirAllegianceId = GetAllegianceId(potentialFriend)
	if (
		(myAllegianceId == nil and theirAllegianceId ~= nil)
		or
		(myAllegianceId ~= nil and theirAllegianceId ~= nil and myAllegianceId ~= theirAllegianceId)
	) then
		-- potential friend in an allegiance and it's not our allegiance
		if ( notSilent ) then
			mobileObj:SystemMessage("Allegiance rules prohibit such actions.", "info")
		end
		return false
	end

	-- prevent friendly actions against bad karma actors when the karma protection flag is on
	if ( mobileObj:GetObjVar("KarmaProtectionEnabled") == true ) then
		local karmaLevel = GetKarmaLevel(GetKarma(potentialFriend))
		local isPlayer = IsPlayerCharacter(potentialFriend)
		if ( 
			(isPlayer and karmaLevel.PunishBeneficialToPlayer)
			or
			(not isPlayer and karmaLevel.PunishBeneficialToNPC)
		) then
            if ( notSilent ) then
                mobileObj:SystemMessage("Disable Karma Protection to benefit that target.", "info")
            end
			return false
		end
	end

	-- allow friendly actions.
	return true
end

-- Given a weapon object calculate the crit damage bonus
-- @param attacker mobileObj
-- @param weapon weaponObj
-- @return crit damage bonus
function GetCritDamageBonus(mobileObj,weaponObj)
	if not(weaponObj) then
		return 0
	end

	return GetMagicItemCritDamageBonus(weaponObj)
end

function IsCombatMap()
	local worldName = GetWorldName()
	for i,j in pairs(ServerSettings.Misc.NonCombatMaps) do
		if (worldName == j) then
			return false
		end
	end
	return true
end

--Randomly Selects a location from the list of available slots 
function GetHitLocation()	
	local rnd = math.random(1,100)
	if ( rnd <= 10 ) then return "Head" end
	if ( rnd <= 40 ) then return "Legs" end
	return "Chest"
end

function CheckActiveSpellResist(target)
	-- 0 to 50% chance, 10 will = 0, 50 will = 50%
	if ( Success(0.5*((( GetWis(target) or 0 ) - ServerSettings.Stats.IndividualStatMin) / (ServerSettings.Stats.IndividualPlayerStatCap - ServerSettings.Stats.IndividualStatMin))) ) then
		target:PlayEffect("HoneycombShield", 1)
		return true
	end
	return false
end

function GetArmorProficiencyType(target)
	local armorClass = nil
	for i,slot in pairs(ARMORSLOTS) do
		local item = target:GetEquippedObject(slot)
		local curArmorClass = EquipmentStats.BaseArmorStats.Natural.ArmorClass
		if(item) then
			curArmorClass = GetArmorClass(item)			
		end

		if not(armorClass) then
			armorClass = curArmorClass
		elseif(curArmorClass ~= armorClass) then
			return nil
		end
	end

	return armorClass
end

function PlayWeaponSound(target, audioId, weapon)
	if(weapon == nil) then
		weapon = GetPrimaryWeapon(target)
	end
	if( weapon ~= nil) then
		weapon:PlayObjectSound(audioId, true)
	else
		local soundPrefix = "Hammer"
		target:PlayObjectSound(soundPrefix..audioId, false)
	end
end

function PlayShieldSound(target,audioId, shield)
	if(shield == nil) then
		shield = target:GetEquippedObject("LeftHand")
	end
	if( shield ~= nil ) then
		shield:PlayObjectSound(audioId, true)
	end
end

function CheckReflectiveArmor(victim, damageInfo)
	-- prevent reflective armor from working if they cast on them selves.
	if ( victim == damageInfo.Attacker ) then
		return false
	end
--check for active reflective armor spell on victim
	if(victim:HasModule("sp_reflective_armor")) then
		local rArmorRemaining = victim:GetObjVar("ReflectiveArmor") or 0
		if (rArmorRemaining > 0) then
			local reflectDamage = {}
			--copy the damageInfo
			reflectDamage.Attacker = victim
			reflectDamage.Damage = damageInfo.Damage
			reflectDamage.Class = damageInfo.Class
			reflectDamage.Type = damageInfo.Type
			reflectDamage.Source = damageInfo.Source
			reflectDamage.Slot = nil
			--if victim has more armor left than what was damaged
			if(rArmorRemaining > damageInfo.Damage) then
				--remove amount of magic armor remaining equal to damage done
				rArmorRemaining = math.floor(rArmorRemaining - damageInfo.Damage)
				victim:SetObjVar("ReflectiveArmor", rArmorRemaining)
				--reflect the damage back at the source
				ApplyDamageToTarget(damageInfo.Attacker, reflectDamage)
				--return true to end damage, victim reflected all the damage and took none
				return true;
			else
				--remove the damage to victim from what's remaining of the armor
				damageInfo.Damage = damageInfo.Damage - rArmorRemaining
				--reflect damage equal to the remaining armor we have left
				reflectDamage.Damage = rArmorRemaining
				--remove all reflective armor from victim
				victim:SendMessage("RemoveReflectiveArmor")
				--reflect the damage back at the source
				ApplyDamageToTarget(damageInfo.Attacker, reflectDamage)
				--continue on cause the victim still took SOME damage
			end
		else
			victim:SendMessage("RemoveReflectiveArmor")
		end
	end
	return false
end

function RandomAttackSoundChance(attacker)
	if(math.random(1,5) == 1) then 
		--D*ebugMessage(attacker:GetName().. " OUCH!")
		attacker:PlayObjectSound("Attack", true) 
	end
end

--- Does the graphic/sound of an arrow flying from one mobile to another
-- @param from mobileObj
-- @param to mobileObj
-- @param weapon gameObj
function PerformClientArrowShot(from, to, weapon)
	PlayAttackAnimation(from)
	from:PlayProjectileEffectTo("ArrowEffect", to, 100, 0, "Bone=Bone_Proj_Source")
	PlayWeaponSound(from, "Shoot", weapon)
end

--- Plays the attack animation for mobileObj
-- @param mobile mobileObj
function PlayAttackAnimation(mobile)
	mobile:PlayAnimation("attack")
end
-- The following require has been automatically added for the module manager.
require 'default:globals.helpers.combat'

-- The following require has been automatically added for the module manager.
require 'BA_DynamicWindows.BA_combat'
