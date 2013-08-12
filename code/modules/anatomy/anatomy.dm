/datum/anatomy
	var/mob/living/carbon/host

	var/list/datum/organ/external/external_organs = list()

	proc/LocateOrgan(var/typepath)
		for(var/datum/organ/external/external_organ in external_organs)
			if (istype(external_organ, typepath))
				return external_organ

			for(var/datum/organ/internal/internal_organ in external_organ.internal_organs)
				if (istype(internal_organ, typepath))
					return internal_organ

		return null
