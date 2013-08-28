/datum/organ
	name = "organ"

	var/mob/organism/organism			= null
	var/damage_brute					= 0
	var/damage_burn						= 0
	var/damage_toxic					= 0
	var/damage_limit					= 100
	var/limit							= 0
	var/limit_type						= null
	var/removeable						= TRUE
	var/broken							= FALSE
	var/breaks							= TRUE
	var/breaks_from_damage				= TRUE
	var/break_action					= ORGAN_BREAK_ACTION_NONE
	var/broken_action					= ORGAN_BROKEN_ACTION_LIFE

	proc/ChangeOrganism(var/mob/organism/new_organism)
		OnChangeOrganism(organism, organism = new_organism)

	proc/OnChangeOrganism(var/mob/organism/old_organism, var/mob/organism/new_organism)

	proc/ApplyDamage(var/brute_damage, var/burn_damage, var/toxic_damage)
		damage_brute += brute_damage
		damage_burn += burn_damage
		damage_toxic += toxic_damage

		if (breaks && breaks_from_damage && GetDamageTotal() > damage_limit)
			Break()

	proc/GetDamageTotal()
		return damage_brute + damage_burn + damage_toxic

	proc/HealDamage(var/brute_heal, var/burn_heal, var/toxic_heal)
		damage_brute = max(damage_brute - brute_heal, 0)
		damage_burn = max(damage_burn - burn_heal, 0)
		damage_toxic = max(damage_toxic - toxic_heal, 0)

	proc/Break()
		if (!breaks || broken)
			return FALSE

		broken = TRUE
		OnBreak()

		return TRUE

	proc/OnBreak()

	proc/Life()
		if (organism == null)
			return FALSE

		return TRUE

	proc/BrokenLife()