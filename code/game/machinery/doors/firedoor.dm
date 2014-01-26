/var/const/OPEN = 1
/var/const/CLOSED = 2

/obj/machinery/door/firedoor
	name = "Firelock"
	icon = 'door_fire.dmi'
	icon_state = "door_open"
	opacity = 0
	density = 0
	canglass = 0
	canemag = 0
	layer = 2.9

	var/blocked = null
	var/nextstate = null

/obj/machinery/door/firedoor/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

/obj/machinery/door/firedoor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if (!istype(C, /obj/item/weapon/crowbar) || operating || welded)
		return

	if (src.blocked)
		if(src.density)
			spawn( 0 )
				src.operating = 1

				animate("opening")
				sleep(15)
				src.density = 0
				update_icon()

				src.sd_SetOpacity(0)
				src.operating = 0
				return
		else
			spawn( 0 )
				src.operating = 1

				animate("closing")
				src.density = 1
				sleep(15)
				update_icon()

				src.sd_SetOpacity(1)
				src.operating = 0
				return

	return ..()

/obj/machinery/door/firedoor/process()
	if(src.operating)
		return
	if(src.nextstate)
		if(src.nextstate == OPEN && src.density)
			spawn()
				src.open()
		else if(src.nextstate == CLOSED && !src.density)
			spawn()
				src.close()
		src.nextstate = null

/obj/machinery/door/firedoor
	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group)
			var/direction = get_dir(src,target)
			return (dir != direction)
		else if(density)
			if(!height)
				var/direction = get_dir(src,target)
				return (dir != direction)
			else
				return 0

		return 1

	update_nearby_tiles(need_rebuild)
		if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/destination = get_step(source,dir)

		if(need_rebuild)
			if(istype(source)) //Rebuild/update nearby group geometry
				if(source.parent)
					air_master.groups_to_rebuild += source.parent
				else
					air_master.tiles_to_update += source
			if(istype(destination))
				if(destination.parent)
					air_master.groups_to_rebuild += destination.parent
				else
					air_master.tiles_to_update += destination

		else
			if(istype(source)) air_master.tiles_to_update += source
			if(istype(destination)) air_master.tiles_to_update += destination

		return 1