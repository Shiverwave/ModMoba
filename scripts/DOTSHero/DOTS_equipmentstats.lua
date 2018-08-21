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
EquipmentStats.BaseWeaponStats.BladeOfShadows = {
		WeaponClass = "ShadowDagger",
			Attack = 41,
			MinSkill = 0,
			Speed = 1.5,
			PrimaryAbility = "Stab",
			SecondaryAbility = "Bleed",
	}