/obj/machinery/door
	name = "Door"
	icon = 'door_basic.dmi'
	icon_state = "door1"
	opacity = 1
	density = 1
	anchored = 1

	var/secondsElectrified = 0
	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/requires_id = 1
	var/welded = 0
	var/transparent = 0
	var/canglass = 1
	var/canemag = 1
	var/canweld = 1

	New()
		..()
		update_nearby_tiles(need_rebuild = 1)

	Del()
		update_nearby_tiles()
		..()

	Bumped(atom/AM)
		if(p_open || operating)
			return

		if(ismob(AM))
			var/mob/M = AM

			if(world.timeofday - AM.last_bumped <= 5)
				return

			if(M.client && !M:handcuffed)
				attack_hand(M)

		else if(istype(AM, /obj/machinery/bot))
			var/obj/machinery/bot/bot = AM

			if(src.check_access(bot.botcard))
				if(density)
					open()

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group)
			return 0

		if(istype(mover, /obj/beam))
			return transparent || !opacity

		return !density

	meteorhit(obj/M as obj)
		src.open()
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		return src.attackby(user, user)

	attackby(obj/item/I as obj, mob/user as mob)
		if (src.operating)
			return

		src.add_fingerprint(user)

		if (!src.requires_id)
			user = null

		if (src.density)
			if(istype(I, /obj/item/weapon/card/emag) && canemag)
				src.operating = -1
				flick("door_spark", src)
				sleep(6)
				open()

				return 1
			else if(istype(I, /obj/item/weapon/weldingtool) && canweld)
				var/obj/item/weapon/weldingtool/W = I

				if(!W.welding)
					return

				if (W.get_fuel() > 2)
					W.use_fuel(2)

				if (src.welded)
					src.welded = 0
				else
					src.welded = 1

				update_icon()

				return

		if (src.allowed(user))
			if (src.density && !src.welded)
				open()
			else
				close()
		else if (src.density)
			flick("door_deny", src)

		return

	blob_act()
		if(prob(20))
			del(src)

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
			if(2.0)
				if(prob(25))
					del(src)
			if(3.0)
				if(prob(80))
					var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
					s.set_up(2, 1, src)
					s.start()

	proc/requiresID()
		return src.requires_id

	proc/update_nearby_tiles(need_rebuild)
		if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/north = get_step(source,NORTH)
		var/turf/simulated/south = get_step(source,SOUTH)
		var/turf/simulated/east = get_step(source,EAST)
		var/turf/simulated/west = get_step(source,WEST)

		if(need_rebuild)
			if(istype(source)) //Rebuild/update nearby group geometry
				if(source.parent)
					air_master.groups_to_rebuild += source.parent
				else
					air_master.tiles_to_update += source
			if(istype(north))
				if(north.parent)
					air_master.groups_to_rebuild += north.parent
				else
					air_master.tiles_to_update += north
			if(istype(south))
				if(south.parent)
					air_master.groups_to_rebuild += south.parent
				else
					air_master.tiles_to_update += south
			if(istype(east))
				if(east.parent)
					air_master.groups_to_rebuild += east.parent
				else
					air_master.tiles_to_update += east
			if(istype(west))
				if(west.parent)
					air_master.groups_to_rebuild += west.parent
				else
					air_master.tiles_to_update += west
		else
			if(istype(source)) air_master.tiles_to_update += source
			if(istype(north)) air_master.tiles_to_update += north
			if(istype(south)) air_master.tiles_to_update += south
			if(istype(east)) air_master.tiles_to_update += east
			if(istype(west)) air_master.tiles_to_update += west

		return 1


	proc/update_icon()
		if(density)
			icon_state = "door_closed"
		else
			icon_state = "door_open"
		return

	proc/animate(animation)
		switch(animation)
			if("opening")
				if(overlays) overlays = null
				if(p_open)
					icon_state = "o_door_opening" //can not use flick due to BYOND bug updating overlays right before flicking
				else
					flick("door_opening", src)
			if("closing")
				if(overlays) overlays = null
				if(p_open)
					flick("o_door_closing", src)
				else
					flick("door_closing", src)
			if("spark")
				flick("door_spark", src)
			if("deny")
				flick("door_deny", src)
		return

	proc/open()
		if(!density)
			return 1
		if (src.operating == 1) //doors can still open when emag-disabled
			return
		if (!ticker)
			return 0
		if(!src.operating) //in case of emag
			src.operating = 1

		animate("opening")
		sleep(10)
		src.density = 0
		update_icon()

		src.sd_SetOpacity(0)
		update_nearby_tiles()

		if(operating == 1) //emag again
			src.operating = 0

		if(autoclose)
			spawn(150)
				autoclose()
		return 1

	proc/close()
		if(density)
			return 1

		if (src.operating)
			return

		src.operating = 1

		animate("closing")
		src.density = 1
		sleep(10)
		update_icon()

		if (src.visible && (!istype(src, /obj/machinery/door/airlock/glass)))
			src.sd_SetOpacity(1)
		if(operating == 1)
			operating = 0
		update_nearby_tiles()

/obj/machinery/door/proc/autoclose()
	var/obj/machinery/door/airlock/A = src
	if ((!A.density) && !( A.operating ) && !(A.locked) && !( A.welded ))
		close()
	else return

/////////////////////////////////////////////////// Unpowered doors

/obj/machinery/door/unpowered
	autoclose = 0

/obj/machinery/door/unpowered/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/unpowered/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/unpowered/attack_hand(mob/user as mob)
	return src.attackby(null, user)

/obj/machinery/door/unpowered/attackby(obj/item/I as obj, mob/user as mob)
	if (src.operating)
		return
	src.add_fingerprint(user)
	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()
	return

/obj/machinery/door/unpowered/shuttle
	icon = 'shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = 1