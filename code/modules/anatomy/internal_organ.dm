/datum/organ/internal
	var/datum/organ/external/external_organ	= null
	var/complexity							= 0

	proc/ChangeExternalOrgan(var/datum/organ/external/new_external_organ)
		OnChangeExternalOrgan(external_organ, new_external_organ)

		if (new_external_organ)
			ChangeOrganism(new_external_organ.organism)
		else
			ChangeOrganism(null)

	proc/OnChangeExternalOrgan(var/datum/organ/external/old_external_organ, var/datum/organ/external/new_external_organ)
		external_organ = new_external_organ

	Break()
		if (..() && break_action == ORGAN_BREAK_ACTION_DELETE)
			external_organ.RemoveInternalOrgan(src)

			del src
