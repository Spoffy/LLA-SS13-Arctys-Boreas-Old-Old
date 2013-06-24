/datum/anatomy
	var/mob/living/carbon/body
	var/obj/item/organ/organs = list()
	var/datum/reagents/reagents

	New(var/mob/living/carbon/B)
		..()
		body = B

		reagents = new /datum/reagents(1000)
		reagents.my_atom = src

	proc/add(var/obj/item/organ/O)
		organs += O

		O.act_add(src)
		for(var/obj/item/organ/organ in organs - O)
			organ.act_add_other(O)

	proc/remove(var/obj/item/organ/O)
		organs -= O

		O.act_remove(src)
		for(var/obj/item/organ/organ in organs)
			organ.act_remove_other(O)

	proc/life()
		for(var/obj/item/organ/organ in organs)
			organ.life()

	proc/locate_organ(var/type)
		for(var/organ in organs)
			if(istype(organ, type))
				return organ

		return null

	proc/locate_organs(var/type)
		var/list/obj/item/organ/organs = list()

		for(var/organ in organs)
			if(istype(organ, type))
				organs += organ

		return organs