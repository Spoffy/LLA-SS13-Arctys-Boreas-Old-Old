/mob/organism
	var/list/datum/organ/external/external_organs 	= list()

	proc/AddExternalOrgan(var/datum/organ/external/O)
		external_organs += O

	proc/RemoveExternalOrgan(var/datum/organ/external/O)
		external_organs -= O

	proc/LocateOrgan(var/typepath)
		for(var/datum/organ/external/external_organ in external_organs)
			if (istype(external_organ, typepath))
				return external_organ

			for(var/datum/organ/internal/internal_organ in external_organ.internal_organs)
				if (istype(internal_organ, typepath))
					return internal_organ

		return null

	proc/LocateOrgans(var/typepath)
		var/list/datum/organ/organs = list()

		for(var/datum/organ/external/external_organ in external_organs)
			if (istype(external_organ, typepath))
				organs += external_organ

			for(var/datum/organ/internal/internal_organ in external_organ.internal_organs)
				if (istype(internal_organ, typepath))
					organs += internal_organ

		return organs