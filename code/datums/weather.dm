var/global/datum/controller/weather_system/weather_master

/datum/controller/weather_system
	var/datum/weather/pattern/current
	var/datum/weather/pattern/next

	proc/StartPattern()
		var/datum/weather/pattern/C = next

		if(C==null)
			C = new /datum/weather/pattern/calm/

		current = C

		world << "Starting pattern @ [current]"

		spawn(C.Setup())
			if(C == current)
				StartPattern()

/datum/weather/pattern
	var/static/icon/current_overlay = null

	proc/Setup()

	proc/Process()

// No snowfall.
// Insulating clothing not required.
// Medium to long duration.
// 70% chance of escalating to light.
// 30% chance of maintaining calm.
/datum/weather/pattern/calm
	Setup()
		// Determine temperature
		var/temperature = rand(T0C, T10C)

		// Update areas
		for(var/area/tundra/A)
			A.overlays -= current_overlay

		// Update turfs
		for (var/turf/simulated/snow/T in block(locate(1, 1, 1), locate(world.maxx, world.maxy, 1)))
			// Update overlay
			T.overlays -= current_overlay

			// Update temperature
			T.temperature = temperature

		// Determine next pattern
		switch (rand(100))
			if (0 to 70)
				weather_master.next = new /datum/weather/pattern/light
			if (70 to 100)
				weather_master.next = new /datum/weather/pattern/calm

		// Last from 6 minutes to 10 minutes.
		return rand(6 * 10 * 60, 10 * 10 * 60)

// Causes light amounts of snowfall.
// Light insulation required to survive for extended exposure times.
// Medium to long duration.
// 60% chance of dropping to calm.
// 40% chance of escalating to medium.
/datum/weather/pattern/light
	var/static/icon/overlay = new('snow.dmi', "snowfall_light")

	Setup()
		// Determine temperature
		var/temperature = rand(TN10C, T0C)

		// Update areas
		for(var/area/tundra/A)
			A.overlays -= current_overlay
			A.overlays += overlay

		current_overlay = overlay

		// Update turfs
		for (var/turf/simulated/snow/T in block(locate(1, 1, 1), locate(world.maxx, world.maxy, 1)))
			// Update temperature
			T.temperature = temperature

		// Determine next pattern
		switch(rand(100))
			if(0 to 60)
				weather_master.next = new /datum/weather/pattern/calm
			if(60 to 100)
				weather_master.next = new /datum/weather/pattern/medium

		// Make the pattern last from 4 minutes to 6 minutes.
		return rand(4 * 10 * 60, 6 * 10 * 60)

// Causes medium amounts of snowfall.
// Light insulation required even at minimal exposure times, specialized insulation required for extended exposure times.
// Medium duration.
// 50% chance of dropping to light.
// 50% chance of escalating to blizzard.
/datum/weather/pattern/medium
	var/static/icon/overlay = new('snow.dmi', "snowfall_light")

	Setup()
		var/temperature = rand(TN10C, T0C)

		// Update areas
		for(var/area/tundra/A)
			A.overlays -= current_overlay
			A.overlays += overlay

		current_overlay = overlay

		// Update turfs
		for (var/turf/simulated/snow/T in block(locate(1, 1, 1), locate(world.maxx, world.maxy, 1)))
			// Update temperature
			T.temperature = temperature

		// Determine next pattern
		switch(rand(100))
			if(0 to 50)
				weather_master.next = new /datum/weather/pattern/light
			if(50 to 100)
				weather_master.next = new /datum/weather/pattern/blizzard

		// Make the pattern last from 3 minutes to 5 minutes.
		return rand(3 * 10 * 60, 6 * 10 * 60)


// Causes heavy snowfall.
// Specialized insulation required to survive minimal exposure times.
// Short to medium duration.
// 70% chance of dropping to medium.
// 20% chance of escalating to superblizzard.
// 10% chance of dropping to light.
/datum/weather/pattern/blizzard
	var/static/icon/overlay = new('snow.dmi', "snowfall")

	Setup()
		var/temperature = rand(TN60C, TN40C)

		// Update areas
		for(var/area/tundra/A)
			A.overlays -= current_overlay
			A.overlays += overlay

		current_overlay = overlay

		// Update turfs
		for(var/turf/simulated/snow/T in block(locate(1, 1, 1), locate(world.maxx, world.maxy, 1)))
			// Update temperature
			T.temperature = temperature

		// Determine next pattern
		switch(rand(100))
			if(0 to 70)
				weather_master.next = new /datum/weather/pattern/medium
			if(70 to 90)
				weather_master.next = new /datum/weather/pattern/superblizzard
				command_alert("Severe weather patterns are approaching the station, seek refuge immediatly.", "Weather Alert")
			if(90 to 100)
				weather_master.next = new /datum/weather/pattern/light

		// Make the pattern last from 2 minutes to 4 minutes.
		return rand(2 * 10 * 60, 6 * 10 * 60)

// Causes massive snowfall.
// Freezes airlocks solid, interferes with power systems.
// Exposure with any amount of insulation will result in almost instant death.
// Short duration.
// 70% chance of dropping to calm.
// 20% chance of dropping to medium.
// 10% chance of dropping to blizzard.
/datum/weather/pattern/superblizzard
	var/static/icon/overlay = new('snow.dmi', "snowfall_heavy")

	Setup()
		// Update areas
		for(var/area/tundra/A)
			A.overlays -= current_overlay
			A.overlays += overlay

		current_overlay = overlay

		// Update turfs
		for (var/turf/simulated/snow/T in block(locate(1, 1, 1), locate(world.maxx, world.maxy, 1)))
			// Update temperature
			T.temperature = TN80C

		// Determine next pattern
		switch(rand(100))
			if(0 to 70)
				weather_master.next = new /datum/weather/pattern/calm
			if(70 to 90)
				weather_master.next = new /datum/weather/pattern/medium
			if(90 to 100)
				weather_master.next = new /datum/weather/pattern/blizzard

		// Make the pattern last from 1 minute to 3 minutes.
		return rand(1 * 10 * 60, 3 * 10 * 60)