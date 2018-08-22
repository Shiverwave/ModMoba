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
EquipmentStats.BaseWeaponClass.Crook = {
			Accuracy = 5,
			Critical = 0,
			Variance = 0.10,
			WeaponSkill = "BashingSkill",
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
EquipmentStats.BaseWeaponStats.CrookOfCruelty = {
		WeaponClass = "Crook",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Stun",
			SecondaryAbility = "StunPunch",
	}
EquipmentStats.BaseWeaponStats.ScepterOfMagic = {
		WeaponClass = "Scepter",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "Concus",
	}