/datum/organ/internal
	var/datum/organ/external/external_organ	= null

	proc/ChangeExternalOrgan(var/datum/organ/external/new_external_organ)
		OnChangeExternalOrgan(external_organ, new_external_organ)
		ChangeAnatomy(external_organ.anatomy)

	proc/OnChangeExternalOrgan(var/datum/organ/external/old_external_organ, var/datum/organ/external/new_external_organ)
		external_organ = new_external_organ
