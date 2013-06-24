// A small explososive used to breach windows for example to vent gasses quickly out.

/obj/machinery/em_breach/em_breach/
	name = "breaching charge"
	desc = "A small explosive to break the windows in case of an emergency. Runs on battery power."
	icon = 'stationobjs.dmi'
	icon_state = "em_breach"
	density = 0
	anchored = 1

	var/id = ""

/obj/machinery/em_breach/em_auth/
	name = "emergency vent"
	desc = "A ID scanner protected by glass."
	icon = 'stationobjs.dmi'
	icon_state = "em_auth_gl"

	var/id = ""
	var/glass = 1
	var/emagged = 0

/obj/machinery/em_breach/em_auth/attack_hand(mob/user as mob)
	if(glass)
		user << "\red You break the glass of the emergency vent."
		for (var/mob/C in viewers(src))
			C.show_message("\red [user] breaks the glass that covered the emergency vent!")
		new /obj/item/weapon/shard(src.loc)
		icon_state = "em_auth"
		glass = 0
		return
	else
		return
	return

/obj/machinery/em_breach/em_auth/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/sheet/glass))
		W:amount--
		glass = 1
		icon_state = "em_auth_gl"
	else if(istype(W, /obj/item/weapon/card/id))
		if(src.allowed(user))
			if(emagged)
				id:explode(1)
			else if(!emagged)
				id:explode(0)
		else
			user << "\red Access denied!"
	else if(istype(W, /obj/item/weapon/card/emag))
		emagged = 1
		return
	else
		..()
	return

/obj/machinery/em_breach/em_breach/proc/explode(var/big)
	var/turf/T = get_turf(src.loc)
	if(ismob(src.loc))
		var/mob/M = src.loc
		M:gib()
	if(T)
		if(big)
			explosion(T, -1, -1, 4, 6)
		if(!big)
			explosion(T, -1, -1, 2, 3)
	return