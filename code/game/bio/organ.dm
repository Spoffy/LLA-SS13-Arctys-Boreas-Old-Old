/obj/item/organ
	name = "organ"
	icon = 'bio.dmi'

	var/datum/anatomy/anatomy = null
	var/damage = 0
	var/max_damage = 100
	var/max_count = 1
	var/removable = 1

	proc/life()

	proc/act_add(var/datum/anatomy/A)
		anatomy = A

	proc/act_add_other(var/obj/item/organ/O)

	proc/act_remove(var/datum/anatomy/A)
		anatomy = null

	proc/act_remove_other(var/obj/item/organ/O)