/obj/machinery/mail
	name = "mailing unit"
	desc = "A pneumatic mailing unit."
	icon = 'disposal.dmi'
	icon_state = "mail_disp"
	anchored = 1
	density = 1
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = 0	// true if flush handle is pulled
	var/obj/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress

	// create a new disposal
	// find the attached trunk (if present) and init gas resvr.
	New()
		..()
		spawn(5)
			trunk = locate() in src.loc
			if(!trunk)
				mode = 0
				flush = 0
			else
				trunk.linked = src	// link the pipe trunk to self

			air_contents = new/datum/gas_mixture()
			//gas.volume = 1.05 * CELLSTANDARD
			update()


	// attack by item places it in to disposal
	attackby(var/obj/item/I, var/mob/user)
		if(stat & BROKEN)
			return

		var/obj/item/weapon/grab/G = I
		if(istype(G))	// handle grabbed mob
			if(ismob(G.affecting))
				var/mob/GM = G.affecting
				if (GM.client)
					GM.client.perspective = EYE_PERSPECTIVE
					GM.client.eye = src
				GM.loc = src
				for (var/mob/C in viewers(src))
					C.show_message("\red [GM.name] has been placed in the [src] by [user].", 3)
				del(G)


		else
			user.drop_item()
			I.loc = src
			user << "You place \the [I] into the [src]."
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] places \the [I] into the [src].", 3)

		update()

	// mouse drop another mob or self
	//
	MouseDrop_T(mob/target, mob/user)
		if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
			return

		var/msg

		if(target == user && !user.stat)	// if drop self, then climbed in
												// must be awake
			msg = "[user.name] attempts to climp into the [src]."
			user << "This won't fit."
			return
		else if(target != user && !user.restrained())
			msg = "[user.name] attempts to stuffs [target.name] into the [src]!"
			user << "This won't fit."
			return
		else
			return
		if (target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		target.loc = src

		for (var/mob/C in viewers(src))
			if(C == user)
				continue
			C.show_message(msg, 3)


	// monkeys can only pull the flush lever
	attack_paw(mob/user as mob)
		if(stat & BROKEN)
			return

		flush = !flush
		update()
		return

	// ai as human but can't flush
	attack_ai(mob/user as mob)
		interact(user, 1)

	// human interact with machine
	attack_hand(mob/user as mob)
		interact(user, 0)

	// user interaction
	proc/interact(mob/user, var/ai=0)
		src.add_fingerprint(user)
		if(stat & BROKEN)
			user.machine = null
			return

		var/dat = "<head><title>Pneumatic Mailing Unit</title></head><body><TT><B>Station-wide Mailing System</B><HR>"

		if(!ai)  // AI can't pull flush handle
			if(flush)
				dat += "Trigger: <A href='?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
			else
				dat += "Trigger: <B>Disengaged</B> <A href='?src=\ref[src];handle=1'>Engage</A>"

			dat += "<BR><HR><A href='?src=\ref[src];eject=1'>Eject contents</A><HR>"

		if(mode == 0)
			dat += "Pump: <B>Off</B> <A href='?src=\ref[src];pump=1'>On</A><BR>"
		else if(mode == 1)
			dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
		else
			dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

		var/per = 100* air_contents.return_pressure() / (2*ONE_ATMOSPHERE)

		dat += "Pressure: [round(per, 1)]%<BR></body>"


		user.machine = src
		user << browse(dat, "window=disposal;size=360x170")
		onclose(user, "disposal")

	// handle machine interaction

	Topic(href, href_list)
		..()
		src.add_fingerprint(usr)
		if(stat & BROKEN)
			return
		if(usr.stat || usr.restrained() || src.flushing)
			return

		if (in_range(src, usr) && istype(src.loc, /turf))
			usr.machine = src

			if(href_list["close"])
				usr.machine = null
				usr << browse(null, "window=disposal")
				return

			if(href_list["pump"])
				if(text2num(href_list["pump"]))
					mode = 1
				else
					mode = 0
				update()

			if(href_list["handle"])
				flush = text2num(href_list["handle"])
				update()

			if(href_list["eject"])
				eject()
		else
			usr << browse(null, "window=disposal")
			usr.machine = null
			return
		return

	// eject the contents of the disposal unit
	proc/eject()
		for(var/atom/movable/AM in src)
			AM.loc = src.loc
			AM.pipe_eject(0)
		update()

	// update the icon & overlays to reflect mode & status
	proc/update()
		overlays = null
		if(stat & BROKEN)
			icon_state = "disposal-broken"
			mode = 0
			flush = 0
			return

		// flush handle
		if(flush)
			overlays += image('disposal.dmi', "dispover-handle")

		// only handle is shown if no power
		if(stat & NOPOWER)
			return

		// 	check for items in disposal - occupied light
		if(contents.len > 0)
			overlays += image('disposal.dmi', "dispover-full")

		// charging and ready light
		if(mode == 1)
			overlays += image('disposal.dmi', "dispover-charge")
		else if(mode == 2)
			overlays += image('disposal.dmi', "dispover-ready")

	// timed process
	// charge the gas reservoir and perform flush if ready
	process()
		if(stat & BROKEN)			// nothing can happen if broken
			return

		src.updateDialog()

		if(flush && air_contents.return_pressure() >= 2*ONE_ATMOSPHERE)	// flush can happen even without power
			flush()

		if(stat & NOPOWER)			// won't charge if no power
			return

		use_power(100)		// base power usage

		if(mode != 1)		// if off or ready, no need to charge
			return

		// otherwise charge
		use_power(500)		// charging power usage





		var/atom/L = loc						// recharging from loc turf

		var/datum/gas_mixture/env = L.return_air()
		var/pressure_delta = (ONE_ATMOSPHERE*2.1) - air_contents.return_pressure()

		if(env.temperature > 0)
			var/transfer_moles = 0.1 * pressure_delta*air_contents.volume/(env.temperature * R_IDEAL_GAS_EQUATION)

			//Actually transfer the gas
			var/datum/gas_mixture/removed = env.remove(transfer_moles)
			air_contents.merge(removed)


		// if full enough, switch to ready mode
		if(air_contents.return_pressure() >= 2*ONE_ATMOSPHERE)
			mode = 2
			update()
		return

	// perform a flush
	proc/flush()

		flushing = 1
		flick("mail_disp-flush", src)

		var/obj/disposalholder/H = new()	// virtual holder object which actually
											// travels through the pipes.

		H.init(src)	// copy the contents of disposer to holder

		air_contents = new()		// new empty gas resv.

		sleep(10)
		playsound(src, 'disposalflush.ogg', 50, 0, 0)
		sleep(5) // wait for animation to finish


		H.start(src) // start the holder processing movement
		flushing = 0
		// now reset disposal state
		flush = 0
		if(mode == 2)	// if was ready,
			mode = 1	// switch to charging
		update()
		return


	// called when area power changes
	power_change()
		..()	// do default setting/reset of stat NOPOWER bit
		update()	// update icon
		return


	// called when holder is expelled from a disposal
	// should usually only occur if the pipe network is modified
	proc/expel(var/obj/disposalholder/H)

		var/turf/target
		playsound(src, 'hiss.ogg', 50, 0, 0)
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.loc = src.loc
			AM.pipe_eject(0)
			spawn(1)
				if(AM)
					AM.throw_at(target, 5, 1)

		H.vent_gas(loc)
		del(H)