#define ORGAN_BREAK_ACTION_NONE				0
#define ORGAN_BREAK_ACTION_DELETE 			1

#define ORGAN_BROKEN_ACTION_NONE			0
#define ORGAN_BROKEN_ACTION_LIFE			1
#define ORGAN_BROKEN_ACTION_BROKEN_LIFE		2

/datum/organ
	name = "organ"

	var/datum/anatomy/anatomy			= null

	var/damage_brute					= 0
	var/damage_burn						= 0
	var/damage_toxic					= 0
	var/damage_limit					= 100

	var/organ_broken					= FALSE
	var/organ_breaks					= TRUE
	var/organ_damage_breaks				= TRUE
	var/organ_break_action				= ORGAN_BREAK_ACTION_NONE
	var/organ_broken_action				= ORGAN_BROKEN_ACTION_LIFE

	proc/ChangeAnatomy(var/datum/anatomy/new_anatomy)
		OnChangeAnatomy(anatomy, anatomy = new_anatomy)

	proc/OnChangeAnatomy(var/datum/anatomy/old_anatomy, var/datum/anatomy/new_anatomy)
		anatomy = new_anatomy

	proc/ApplyDamage(var/brute_damage, var/burn_damage, var/toxic_damage)
		damage_brute += brute_damage
		damage_burn += burn_damage
		damage_toxic += toxic_damage

		if (organ_breaks && !organ_broken && GetDamageTotal() > damage_limit)
			Break()

	proc/GetDamageTotal()
		return damage_brute + damage_burn + damage_toxic

	proc/HealDamage(var/brute_heal, var/burn_heal, var/toxic_heal)
		damage_brute = max(damage_brute - brute_heal, 0)
		damage_burn = max(damage_burn - burn_heal, 0)
		damage_toxic = max(damage_toxic - toxic_heal, 0)

	proc/Break()

	proc/OnBreak()

	proc/Life()

	proc/BrokenLife()