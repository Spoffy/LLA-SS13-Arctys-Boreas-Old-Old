/obj/item/device/planet/navigation/pointer
	name = "Planetary Navigation System"
	icon = 'device.dmi'
	icon_state = "mpinoff"
	desc = "This shows you the way back to base, every team-leader should have such a device."
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	w_class = 2.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	m_amt = 500
	var/obj/machinery/planet/mbeacon/the_disk = null
	var/active = 0

	attack_self()
		if(!active)
			if(usr.z == 5 || usr.loc.z == 5)
				active = 1
				work()
				usr << "\blue You activate the navigator"
			else
				usr << "\red Unable to locate beacon"
		else
			active = 0
			icon_state = "mpinoff"
			usr << "\blue You deactivate the navigator"

	proc/work()
		if(!(usr.z == 5 || usr.loc.z == 5))
//			active = 0
			icon_state = "mpinonnull"
			usr << "\red Beacon signal lost. Plese only use the system on the planet."
			return
		if(!active) return
		if(!the_disk)
			the_disk = locate()
			if(!the_disk)
				active = 0
				icon_state = "mpinonnull"
				return
		src.dir = get_dir(src,the_disk)
		switch(get_dist(src,the_disk))
			if(0)
				icon_state = "mpinondirect"
			if(1 to 8)
				icon_state = "mpinonclose"
			if(9 to 16)
				icon_state = "mpinonmedium"
			if(16 to INFINITY)
				icon_state = "mpinonfar"
		spawn(5) .()