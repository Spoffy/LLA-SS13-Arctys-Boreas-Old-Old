//This is the AI unit that controls robotics applications. It should be embedded in an AI core.
//It has to be a mob so a player can control it.

//Design a feature at a time, as with engine.
// 1) Programs and applications. Interface via core
mob/living/robotics/rai
	name = "AI Unit"

	var/list/programs = list()
	var/obj/item/robotics/core/core
	var/datum/robotics/program/active_program

	var/emagged = 0

	New()
		..()
		programs += new /datum/robotics/program/door_jack(src)

	// Add a program to the AI database.
	proc/AddProgram(var/datum/robotics/program)
		if(program)
			programs += program

	// Remove a program from the AI database,
	proc/RemoveProgram(var/program_id)
		if(program_id)
			for(var/i = 1; i <= length(programs); i++)
				var/datum/robotics/program/P = programs[i]
				if(P.program_id == program_id)
					programs -= P

	// Find a program by id.
	proc/FindProgram(var/program_id)
		for(var/datum/robotics/program/P in programs)
			if(P.program_id == program_id)
				return P

	Move(NewLoc, dir, step_x, step_y)
		if(core)
			core.Move(NewLoc, dir, step_x, step_y)
		return

	verb/SpawnBody() // REMOVE
		set name = "Give body"
		set category = "AI"

		var/obj/item/robotics/core/C = new (src.loc)
		C.SetAI(src)
