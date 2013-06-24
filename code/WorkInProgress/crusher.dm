// A crusher to turn waste into handy little chunks
// IDEA: dertmine how much glass/metal is in a item by the values for the autolathe
// If no data availiable just produce trash, robots make metal, humans/monkey something red.

/obj/machinery/crusher/crusher/
	name = "crushing unit"
	desc = "A gigantic machine that destroyes everything in its way."
	density = 1
	anchored = 1
	icon = 'stationobjs.dmi'
	icon_state = "crusher"

	var/id = ""

	var/toggled = 1

	blob_act()
		if (prob(25))
			del(src)

	meteorhit()
		del(src)
		return


/obj/machinery/crusher/crusher/Bumped(atom/A)
	if(toggled)
		if(istype(A, /obj/machinery/conveyor)) // dont crush the conveyor.
			return
		if(istype(A, /mob/living))
			A:gib()
			new /obj/item/nscrap/human(src.loc)
		if(istype(A, /obj/))
			if(A)
				if(A:g_amount >= A:m_amount)
					new /obj/item/nscrap/glass(src.loc)
				else
					new /obj/item/nscrap/metal(src.loc)
				del(A)
		return
	else if(!toggled)
		return
	else del(src) // this is never ever supposed to happen. delete it before it does only god knows what.

// emergency shutdown

/obj/machinery/crusher/toggle/
	name = "emergency stop"
	desc = "A button linked to the crusher to turn it off, in case of an emergency."
	density = 0
	anchored = 1
	icon = 'stationobjs.dmi'
	icon_state = "crglac"

	var/id = ""
	var/glass = 1

/obj/machinery/crusher/toggle/attack_hand(mob/user as mob)
	if(glass)
		glass = 0
		user << "\red You break the glass that covered the emergency shutdown!"
		for (var/mob/C in viewers(src))
			C.show_message("\red [user] breaks the glass that covered the crusher emergency shutdown!")
		// spawn a shard
		if(id:toggled) icon_state = "crac"
		else icon_state = "crde"
		return
	if(!glass)
		if(id:toggled)
			user << "\red You pull the crusher emergency shutdown!"
			for (var/mob/C in viewers(src))
				C.show_message("\red [user] pulls the crusher emergency shutdown!")
			id:toggled = 0
			icon_state = "crde"
			return
		if(!id:toggled)
			user << "\red You release the crusher ermergency shutdown!"
			for (var/mob/C in viewers(src))
				C.show_message("\red [user] releases the crusher emergency shutdown!")
			id:toggled = 1
			icon_state = "crac"
			return
		else
			return
		src.add_fingerprint(user)
		return

/obj/machinery/crusher/toggle/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/crusher/toggle/attackby(obj/item/weapon/W, mob/user as mob)
	return

// scrap, static

/obj/item/nscrap/
	name = "scrap"
	desc = "A useless pile of junk."
	icon = 'scrap.dmi'
	icon_state = "2metal0"
	anchored = 0

/obj/item/nscrap/metal/
	icon_state = "2metal0"

/obj/item/nscrap/glass/
	icon_state = "3glass0"

/obj/item/nscrap/human/
	icon_state = "3mixed2"