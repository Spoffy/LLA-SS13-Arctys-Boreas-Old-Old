/datum/organ/external
	name = "external organ"

	var/list/datum/organ/internal/internal_organs 	= list()
	var/complexity_limit							= 100

	ChangeOrganism(var/mob/organism/new_organism)
		..()

		for (var/datum/organ/internal/O in internal_organs)
			O.ChangeOrganism(new_organism)

	Break()
		if (..() && break_action == ORGAN_BREAK_ACTION_DELETE)
			organism.RemoveExternalOrgan(src)

			for (var/datum/organ/internal/O in internal_organs)
				internal_organs -= O
				del O

			del src

	proc/GetInternalComplexity()
		var/complexity = 0

		for (var/datum/organ/internal/O in internal_organs)
			complexity += O.complexity

		return complexity

	proc/CanContain(var/datum/organ/internal/O)
		if (O == null)
			return FALSE

		if (O.limit > 0 && LocateOrgans(O.limit_type) >= O.limit)
			return FALSE

		if (GetInternalComplexity() + O.complexity > complexity_limit)
			return FALSE

		return TRUE

	proc/AddInternalOrgan(var/datum/organ/internal/O)
		if (O == null || !CanContain(O))
			return FALSE

		internal_organs += O

		O.ChangeExternalOrgan(src)
		OnAddInternalOrgan(O)

		return TRUE

	proc/OnAddInternalOrgan(var/datum/organ/internal/O)

	proc/RemoveInternalOrgan(var/datum/organ/internal/O)
		if (O == null || internal_organs.Find(O) == 0)
			return FALSE

		internal_organs -= O

		O.ChangeExternalOrgan(src)
		OnRemoveInternalOrgan(O)

		return TRUE

	proc/OnRemoveInternalOrgan(var/datum/organ/internal/O)

	proc/LocateOrgans(var/typepath)
		var/list/datum/organ/organs = list()

		for(var/datum/organ/internal/internal_organ in internal_organs)
			if (istype(internal_organ, typepath))
				organs += internal_organ

		return organs