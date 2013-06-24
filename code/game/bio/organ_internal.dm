/obj/item/organ/internal
	name = "internal"

/obj/item/organ/internal/throat
	name = "throat"

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"

	var/obj/item/organ/internal/throat = null


	life()
		if(air_master.current_cycle % 4 == 2)
			breathe()


	act_add()
		..()

		throat = anatomy.locate_organ(/obj/item/organ/internal/throat)

	proc/breathe()
		if(!can_breath())
			return

		if(anatomy.reagents.has_reagent("lexorin"))
			return

			//var/turf/loc = anatomy.body.loc
			//var/datum/gas_mixture/environment = loc.return_air()
			//var/datum/air_group/breath

	proc/can_breath()
		if(throat == null || throat.anatomy != anatomy)
			throat = anatomy.locate_organ(/obj/item/organ/internal/throat)

		return throat != null

/obj/item/organ/internal/lungs/rebreather
	name = "rebreather"
	icon_state = "rebreather"
