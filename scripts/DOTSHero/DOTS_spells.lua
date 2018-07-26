--[[
SpellData.AllSpells.fireBlast = {
			PowerWords = "Dab Yeet Woke!",
			manaCost = 20,
			upkeepCost = 0,
			effectDamageType = "Fire",
			effectType = "Projectile",
			BaseCastTime = "Three",
			castTimeOffset = 0,
			SpellPower = 25,
			critChance = 25,
			SpellRange = 15,
			TargetType = "targetMobile",
			TargetRequired = true,
			CanBeInterrupted = true,
			SpellTravelRate = 1,
			critEffectTargetScript = "sp_burn_effect",
			SpellType = "MagicAttackTypeSpell",
			SpellPrimeFXName = "PrimedVoid",
			CanBeDodged = true,
			CanBeBlocked = true,
			CanBeParried = true,
			MinTravelTime = 0.5,
			SpellFXName = "CastVoid",
			SpellFXArgs = "Bone=R_Hand",
			SpellFXDelay = 0.15,
			SpellHitFX = "RedCoreImpactWaveEffect",
			SpellPrimeSFX = "CastFire",
			SpellHitSFX = "FireballImpact",
			SpellPotencySkill = "EvocationSkill",
			SpellTooltipString = "Shoots a slow and powerful flaming ball that does fire damage to the target on impact.",
			requireLineOfSight = true,
			Skill = "EvocationSkill",
			MinSkillRequired = 0,
			spellSkillLevel = 10,
			AttackSpellType = true,
			SpellEnabled = true,
			SpellFireAnim = "spell_fire",
			SpellDisplayName = "Dark Blast",
			StanceOverride = {
				Defensive = {
					SpellReleaseUserScript  = "sp_fireshockwave_effect",
					critEffectTargetScript = "sp_knockback_effect",
					castTimeOffset = 0,
					critChance = 5,
					SpellRange = 6,
					manaCost = 12,
				},
			},
			Reagents = {
				"LemonGrass",
			},
			Circle = 5,
}
SpellData.AllSpells.bloodRend = {
			PowerWords = "Yeet-eth! Woke-eth!",
			manaCost = 35,
			upkeepCost = 0,
			effectDamageType = "Bleed",
			effectType = "Projectile",
			BaseCastTime = "Two",
			castTimeOffset = 0,
			SpellPower = 5,
			critChance = 100,
			SpellRange = 2.5,
			TargetType = "targetMobile",
			TargetRequired = true,
			CanBeInterrupted = true,
			SpellTravelRate = 2,
			critEffectTargetScript = "sp_poison_effect",
			SpellType = "MagicAttackTypeSpell",
			SpellPrimeFXName = "ChargedWeaponEffect",
			CanBeDodged = true,
			CanBeBlocked = true,
			CanBeParried = true,
			MinTravelTime = 0.4,
			SpellFXName = "BloodEffect_A",
			SpellFXArgs = "Bone=R_Hand",
			SpellFXDelay = 0,
			SpellHitFX = "BodyExplosion",
			SpellPrimeSFX = "CastFire",
			SpellHitSFX = "FireballImpact",
			SpellPotencySkill = "EvocationSkill",
			SpellTooltipString = "Rend the target from range.",
			requireLineOfSight = true,
			Skill = "EvocationSkill",
			MinSkillRequired = 15,
			spellSkillLevel = 20,
			AttackSpellType = true,
			SpellEnabled = true,
			SpellFireAnim = "spell_fire",
			SpellDisplayName = "Blood Rend",
			StanceOverride = {
				Defensive = {
					SpellReleaseUserScript  = "sp_fireshockwave_effect",
					critEffectTargetScript = "sp_knockback_effect",
					castTimeOffset = 0,
					critChance = 100,
					SpellRange = 4,
					manaCost = 8,
				},
			},
			Reagents = {
				"LemonGrass",
			},
			Circle = 5,
}
--]]