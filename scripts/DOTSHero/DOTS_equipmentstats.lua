--[[
EquipmentStats.BaseWeaponClass.MagicKnife = {
	Accuracy = 5,
	Critical = 90,
	Variance = 0.15,
	WeaponSkill = "SlashingSkill",
	WeaponDamageType = "Bashing",
	WeaponHitType = "Melee",
}
EquipmentStats.BaseWeaponStats.Crysknife = {
	WeaponClass = "MagicKnife",
	Attack = 5,
	MinSkill = 0,
	Speed = 1.25,
	PrimaryAbility = "lacerate",
	SecondaryAbility = "Worm",
}
--]]

--Blade of Shadows EquipmentStats
EquipmentStats.BaseWeaponClass.ShadowDagger = {
			Accuracy = -5,
			Critical = 225,
			Variance = 0.05,
			WeaponSkill = "PiercingSkill",
			WeaponDamageType = "Piercing",
			WeaponHitType = "Melee",
	}
EquipmentStats.BaseWeaponClass.MagicBow = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.05,
			WeaponSkill = "ArcherySkill",
			WeaponDamageType = "Bow",
			WeaponHitType = "Ranged",
			TwoHandedWeapon = true,
			Range = 10,
	}
EquipmentStats.BaseWeaponClass.BoStaff = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.05,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bow",
			WeaponHitType = "Bashing",
			TwoHandedWeapon = true,
	}
EquipmentStats.BaseWeaponClass.Scepter = {
			Accuracy = 0,
			Critical = 40,
			Variance = 0.20,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
	}
EquipmentStats.BaseWeaponClass.CrookCruel = {
			Accuracy = 5,
			Critical = 0,
			Variance = 0.10,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
	}
EquipmentStats.BaseWeaponClass.RaarghSword = {
			Accuracy = 0,
			Critical = 80,
			Variance = 0.10,
			WeaponSkill = "SlashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
	}
EquipmentStats.BaseWeaponClass.PickOfAxing = {
			Accuracy = -4,
			Critical = 0,
			Speed = 2.5,
			Variance = 0,
			WeaponSkill = "PiercingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		}
EquipmentStats.BaseWeaponClass.UltimatePickOfAxing = {
			Accuracy = 4,
			Critical = 0,
			Speed = 1,
			Variance = 0,
			WeaponSkill = "PiercingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		}
	
EquipmentStats.BaseWeaponStats.BladeOfShadows = {
		WeaponClass = "ShadowDagger",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Stab",
			SecondaryAbility = "Bleed",
	}
EquipmentStats.BaseWeaponStats.ForkCook = {
		WeaponClass = "Fist",
			Attack = 10,
			MinSkill = 0,
			Speed = 0.25,
			PrimaryAbility = "Stab",
			SecondaryAbility = "Bleed",
	}
EquipmentStats.BaseWeaponStats.BowOfPerception = {
		WeaponClass = "MagicBow",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
	}
EquipmentStats.BaseWeaponStats.StaffOfBalance = {
		WeaponClass = "BoStaff",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Stun",
			SecondaryAbility = "Stab",
	}
EquipmentStats.BaseWeaponStats.Crook = {
		WeaponClass = "Tool",
			Attack = 41,
			MinSkill = 0,
			Speed = 2.5,
			PrimaryAbility = "Stun",
			SecondaryAbility = "Tame",
	}
EquipmentStats.BaseWeaponStats.ScepterOfMagic = {
		WeaponClass = "Scepter",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Focus",
			SecondaryAbility = "Concus",
	}
EquipmentStats.BaseWeaponStats.SwordOfPain = {
		WeaponClass = "RaarghSword",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Bash",
			SecondaryAbility = "Slash",
	}
EquipmentStats.BaseWeaponStats.PickOfPower = {
			WeaponClass = "PickOfAxing",
			Attack = 41,
			MinSkill = 0,
			PrimaryAbility = "Mine",
			TwoHandedWeapon = true,
			Speed = 3,
	}
EquipmentStats.BaseWeaponStats.PickOfPower2 = {
			WeaponClass = "PickOfAxing",
			Attack = 61.5,
			MinSkill = 0,
			PrimaryAbility = "Mine",
			TwoHandedWeapon = true,
			Speed = 2,
	}
EquipmentStats.BaseWeaponStats.PickOfPower3 = {
			WeaponClass = "PickOfAxing",
			Attack = 82,
			MinSkill = 0,
			PrimaryAbility = "Mine",
			TwoHandedWeapon = true,
			Speed = 1.5,
	}
EquipmentStats.BaseWeaponStats.UltimatePickOfPower = {
			WeaponClass = "UltimatePickOfAxing",
			Attack = 102.5,
			MinSkill = 0,
			PrimaryAbility = "Mine",
			TwoHandedWeapon = true,
			Speed = 1,
	}
	
EquipmentStats.BaseShieldStats.ColossusShield = {
			BaseBlockChance = 20,
			ArmorRating = 90,
			MinSkill = 0,
	}