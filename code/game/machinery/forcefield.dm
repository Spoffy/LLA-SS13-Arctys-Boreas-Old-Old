/* Forcefields by Tweet. 08/11/2010 - We need better graphics tough */

/obj/machinery/forcefield
	name = "forcefield"
	desc = "A field barrier"
	icon = 'forcefield.dmi'
	icon_state = "active"
	var/active = 1
	var/overcharged = 0
	var/emagged = 0
	req_access = null
	anchored = 1
	density = 1

/obj/machinery/forcefield/security
	name = "security forcefield"
	req_access = list(access_security)

/obj/machinery/forcefield/bridge
	name = "bridge forcefield"
	req_access = list(access_heads)

/obj/machinery/forcefield/attack_hand(mob/user as mob)
	if(overcharged)
		shock(user)
	else
		if(src.allowed(user))
			if(active)
				user << "You deactivate the forcefield."
				active = 0
				icon_state = "inactive"
				src.add_fingerprint(user)
				density = 0
				return
			else if(!emagged)
				user << "You activate the forcefield."
				active = 1
				icon_state = "active"
				src.add_fingerprint(user)
				density = 1
				return
		else
			user << "\red Access denied."
			return

/obj/machinery/forcefield/attack_ai(mob/user as mob)
	switch(alert("Deactivate or overcharge?",,"Deactivate","Overcharge","Cancel"))
		if("Deactivate")
			icon_state = "inactive"
			active = 0
			density = 0
			src.add_fingerprint(user)
			return
		if("Overcharge")
			icon_state = "overcharged"
			overcharged = 1
			src.add_fingerprint(user)
			return
		if("Cancel")
			return

/obj/machinery/forcefield/attackby(obj/item/I as obj, mob/user as mob)
	if ((src.density && istype(I, /obj/item/weapon/card/emag)) && !emagged)
		switch(alert("Deactivate or overcharge?",,"Deactivate","Overcharge","Cancel"))
			if("Deactivate")
				icon_state = "unpowered"
				active = 0
				src.add_fingerprint(user)
				density = 0
				emagged = 1
				user << "You break the forcefield."
				return
			if("Overcharge")
				icon_state = "overcharged"
				overcharged = 1
				emagged = 1
				src.add_fingerprint(user)
			if("Cancel")
				return
	else if(overcharged)
		shock(user)
	else
		..()


/obj/machinery/forcefield/proc/shock(mob/user as mob)
	user.burn_skin(40)
	user.fireloss += 40
	user.updatehealth()
	var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
	user.throw_at(target, 200, 4)
	if(user.stunned < 40)	user.stunned = 40
	if(user.weakened < 10)	user.weakened = 10*20
	for(var/mob/M in viewers(src))
		if(M == user)	continue
		M.show_message("\red [user.name] was shocked by the [src.name]!", 3, "\red You hear a heavy electrical crack", 2)

/obj/machinery/forcefield/proc/open()
	if(emagged)
		return
	else
		density = 0
		active = 0
		icon_state = "inactive"

/obj/machinery/forcefield/proc/close()
	if(emagged)
		return
	else
		density = 1
		active = 1
		icon_state = "active"


// Brig Forcefields here, many things are copy pasted (i.e. timers), but who gives a shit?

/obj/machinery/forcefield/brig
	name = "security forcefield"
	req_access = list(access_brig)
	var/id = 1.0

// Bring people bumping it trough

///obj/machinery/forcefield/Bumped(atom/A)
//	if(istype(A, /obj/))
//		return
//	else if(istype(A, /mob/living/carbon/human))
//		if(src.allowed(A))
//			A:loc = src.loc
//		else
//			return
//	return



// Timeeeers


/obj/machinery/forcefield_timer
	name = "Forcefield Timer"
	icon = 'stationobjs.dmi'
	icon_state = "doortimer0"
	desc = "A remote control switch for a forcefield."
	req_access = list(access_brig)
	anchored = 1.0
	var/id = null
	var/time = 30.0
	var/timing = 0.0

/obj/machinery/forcefield_timer/process()
	..()
	if (src.timing)
		if (src.time > 0)
			src.time = round(src.time) - 1
		else
			alarm()
			src.time = 0
			src.timing = 0
		src.updateDialog()
		src.update_icon()
	return

/obj/machinery/forcefield_timer/power_change()
	update_icon()


/obj/machinery/forcefield_timer/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return
	for(var/obj/machinery/forcefield/brig/M in world)
		if (M.id == src.id)
			if(M.density)
				spawn( 0 )
					M.open()
			else
				spawn( 0 )
					M.close()
	for(var/obj/secure_closet/brig/B in world)
		if (B.id == src.id)
			if(B.locked)
				B.locked = 0
			B.icon_state = text("[(B.locked ? "1" : null)]secure")
	src.updateUsrDialog()
	src.update_icon()
	return

/obj/machinery/forcefield_timer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/forcefield_timer/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/forcefield_timer/attack_hand(var/mob/user as mob)
	if(..())
		return

	var/dat = "<HTML><BODY><TT><B>Door [src.id] controls</B>"
	user.machine = src
	var/d2
	if (src.timing)
		d2 = text("<A href='?src=\ref[];time=0'>Stop Timed</A><br>", src)
	else
		d2 = text("<A href='?src=\ref[];time=1'>Initiate Time</A><br>", src)
	var/second = src.time % 60
	var/minute = (src.time - second) / 60
	dat += text("<br><HR>\nTimer System: [d2]\nTime Left: [(minute ? text("[minute]:") : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>")
	for(var/obj/machinery/flasher/F in world)
		if(F.id == src.id)
			if(F.last_flash && world.time < F.last_flash + 150)
				dat += text("<BR><BR><A href='?src=\ref[];fc=1'>Flash Cell (Charging)</A>", src)
			else
				dat += text("<BR><BR><A href='?src=\ref[];fc=1'>Flash Cell</A>", src)
	dat += text("<BR><BR><A href='?src=\ref[];mach_close=computer'>Close</A></TT></BODY></HTML>", user)
	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/forcefield_timer/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["time"])
			if(src.allowed(usr))
				src.timing = text2num(href_list["time"])
		else
			if (href_list["tp"])
				if(src.allowed(usr))
					var/tp = text2num(href_list["tp"])
					src.time += tp
					src.time = min(max(round(src.time), 0), 600)
			if (href_list["fc"])
				if(src.allowed(usr))
					for (var/obj/machinery/flasher/F in world)
						if (F.id == src.id)
							F.flash()
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		src.update_icon()
	return

/obj/machinery/forcefield_timer/proc/update_icon()
	if(stat & (NOPOWER))
		icon_state = "doortimer-p"
		return
	else if(stat & (BROKEN))
		icon_state = "doortimer-b"
		return
	else
		if(src.timing)
			icon_state = "doortimer1"
		else if(src.time > 0)
			icon_state = "doortimer0"
		else
			spawn( 50 )
				icon_state = "doortimer0"
			icon_state = "doortimer2"

// Prepared forcefields and timers for easier mapping

/obj/machinery/forcefield/brig/cell1
	name = "holding cell 1"
	id = 1

/obj/machinery/forcefield/brig/cell2
	name = "holding cell 2"
	id = 2

/obj/machinery/forcefield/brig/cell3
	name = "holding cell 3"
	id = 3

/obj/machinery/forcefield/brig/cell4
	name = "holding cell 4"
	id = 4

/obj/machinery/forcefield/brig/cell5
	name = "holding cell 5"
	id = 5

/obj/machinery/forcefield/brig/cell6
	name = "holding cell 6"
	id = 6

/obj/machinery/forcefield_timer/cell1
	name = "forcefield timer 1"
	id = 1

/obj/machinery/forcefield_timer/cell2
	name = "forcefield timer 2"
	id = 2

/obj/machinery/forcefield_timer/cell3
	name = "forcefield timer 3"
	id = 3

/obj/machinery/forcefield_timer/cell4
	name = "forcefield timer 4"
	id = 4

/obj/machinery/forcefield_timer/cell5
	name = "forcefield timer 5"
	id = 5

/obj/machinery/forcefield_timer/cell6
	name = "forcefield timer 6"
	id = 6