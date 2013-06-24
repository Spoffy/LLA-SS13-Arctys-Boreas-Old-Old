// Lightbarrier, a auto-trigger for massdrivers

/obj/machinery/lightbarrier/
	name = "light barrier"
	desc = "A light barrier, it is used to trigger mass drivers."
	icon = 'stationobjs.dmi'
	icon_state = "lightbarrier"
	anchored = 1
	density = 0

	var/on = 1
	var/id = ""
	var/delay = 50


/obj/machinery/lightbarrier/HasEntered()
	if(src.on)
		use_power(5)
		sleep(delay)
		for(var/obj/machinery/door/poddoor/M in machines)
			if (M.id == src.id)
				if (M.density)
					M.open()
					return
				else
					M.close()
					return
		sleep(1)
		for(var/obj/machinery/mass_driver/M in machines)
			if(M.id == src.id)
				M.drive()
	if(!src.on)
		return

/obj/machinery/lightbarrier/proc/Toggle()
	if(src.on)
		src.on = 0
		src.icon_state = "lightbarrier_off"
		use_power(0)
	if(!src.on)
		src.on = 1
		src.icon_state = "lightbarrier"
		use_power(5)
	return

// power procs

/obj/machinery/lightbarrier/power_change(null)
	if(powered())
		if(src.on)
			return
		if(!src.on)
			src.Toggle()
	if(!powered())
		if(src.on)
			src.Toggle()
		if(!src.on)
			return