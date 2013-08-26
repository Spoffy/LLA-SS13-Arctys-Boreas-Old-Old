datum/robotics/program
	var/name = "Program"
	var/program_id = "generic_program"
	var/data_used = 0
	var/html = ""

	proc/Run(var/mob/living/robotics/rai/A)
		usr << "A generic program has been run."
		return 1

	proc/afterattack(atom/target, mob/user)
		return 0



	door_jack
		name = "Door Jack"
		program_id = "door_jack"
		data_used = 10 //Arbitrary amount for now.

		Run(mob/living/robotics/rai/A)
			html = A.format_console("Activating Door Jack...")
			return