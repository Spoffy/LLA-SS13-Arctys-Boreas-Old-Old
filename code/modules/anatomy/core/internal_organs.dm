/datum/organ/internal/lungs
	name							= "lungs"
	limit							= 2
	limit_type						= /datum/organ/internal/lungs
	broken_action					= ORGAN_BROKEN_ACTION_NONE

	Life()
		if (!..())
			return FALSE

		if (air_master.current_cycle % 4 == 2)
			var/datum/air_group/breath = TakeBreath()

			HandleBreath(breath)

			if (breath)
				organism.loc.assume_air(breath)

	proc/TakeBreath()
		if (organism == null) return null

		var/datum/air_group/breath = null

/*
		if (organism.internal)
			if (!anatomy.host.contents.Find(anatomy.host.internal))
				anatomy.host.internal = null

			if (!anatomy.host.wear_mask || !(anatomy.host.wear_mask.flags & MASKINTERNALS))
				anatomy.host.internal = null

			if (anatomy.host.internal)
				if (anatomy.host.internals)
					anatomy.host.internals.icon_state = "internal1"

				breath = anatomy.host.internal.remove_air_volume(BREATH_VOLUME)
			else
				if (anatomy.host.internals)
					anatomy.host.internals.icon_state = "internal0"
		else if (istype(anatomy.host.loc, /turf/))
			var/datum/gas_mixture/environment = anatomy.host.loc.return_air()
			var/breath_moles = environment.total_moles() * BREATH_PERCENTAGE

			breath = anatomy.host.loc.remove_air(breath_moles)
		else if (istype(anatomy.host.loc, /obj/))
			var/obj/location_as_object = anatomy.host.loc
			location_as_object.handle_internal_lifeform(anatomy.host, BREATH_VOLUME)
*/
		return breath

	proc/HandleBreath(var/datum/air_group/breath)