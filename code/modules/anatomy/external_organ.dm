/datum/organ/external
	name = "external organ"

	var/list/datum/organ/internal/internal_organs = list()

	OnChangeAnatomy(var/datum/anatomy/old_anatomy, var/datum/anatomy/new_anatomy)
		..()

		for (var/datum/organ/internal/O in internal_organs)
			O.ChangeAnatomy(new_anatomy)

	proc/CanContain(var/datum/organ/internal/O)
		return FALSE

	proc/AddInternalOrgan(var/datum/organ/internal/O)
		if (!CanContain(O))
			return FALSE

		internal_organs += O
		O.ChangeExternalOrgan(src)
		return TRUE

	proc/OnAddInternalOrgan(var/datum/organ/internal/O)