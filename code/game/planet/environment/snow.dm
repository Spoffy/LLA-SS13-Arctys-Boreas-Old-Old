/turf/unsimulated/snow
	icon = 'snow.dmi'
	icon_state = "snow4"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	var/volume = 40

	proc/adjust_volume(var/amount)
		set_volume(volume + amount)

	proc/set_volume(var/amount)
		volume = amount
		update()

	proc/update()
		volume = min(max(volume, 0), 100)

		switch(volume)
			if(0 to 30) icon_state = pick("snow1", "snow2", "snow3")
			if(30 to 50) icon_state = "snow4"
			if(50 to 70) icon_state = "snow5"
			if(70 to 100) icon_state = "snow6"

		density = volume > 80
		opacity = volume > 80