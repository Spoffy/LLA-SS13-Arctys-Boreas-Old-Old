#define MINING_SHUTTLE_PLANET 1
#define MINING_SHUTTLE_SPACE 2
var/mining_shuttle_status = MINING_SHUTTLE_PLANET

/area/shuttle/mining/planet
	name = "Mining Shuttle Planet"
	icon_state = "shuttle"

/area/shuttle/mining/space
	name = "Mining Shuttle Space"
	icon_state = "shuttle"

/obj/machinery/computer/mining_shuttle
	name = "Mining Shuttle Nav Console"
	desc = "Controls the mining shuttle!"
	icon_state = "shuttle"
	var/moving = 0

	proc/change_location()

		var/area/shuttle/mining/source
		var/area/shuttle/mining/dest

		if(mining_shuttle_status == MINING_SHUTTLE_PLANET) //If we're on the planet, we're going from the planet to SPAAACEEEE
			source = locate(/area/shuttle/mining/planet)
			dest = locate(/area/shuttle/mining/space)
			mining_shuttle_status = MINING_SHUTTLE_SPACE
		else if(mining_shuttle_status == MINING_SHUTTLE_SPACE) //Else. You know. Vice versa.
			source = locate(/area/shuttle/mining/space)
			dest = locate(/area/shuttle/mining/planet)
			mining_shuttle_status = MINING_SHUTTLE_PLANET
		else
			return //LOST. IN. SPPPAAAAAACCCEEE.

		for(var/mob/M in source)
			M << "<span class='game say'><span class='name'>Shuttle:</span> <span class='message'>Main Engine Sequence Initiated, firing in 10 seconds.</span></span>"

		// 10 seconds until liftoff!
		sleep(100)

		// Close the doors
		for(var/obj/machinery/door/door in source)
			if(!door.density)
				door.close()

		// Have a short break for aesthetic appeal.
		sleep(10)

		// Move us to SPAAACCEEEE (Or the planet).
		source.move_contents_to(dest)

	attack_hand(mob/user)
		if(moving || (stat & (BROKEN|NOPOWER))) return

		moving = 1
		change_location()
		moving = 0

		return 1