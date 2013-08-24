datum/robotics/program
	var/name = "Program"
	var/program_id = "generic_program"
	var/data_used = 0
	var/html = ""

	proc/Run(var/mob/living/robotics/rai/A)
		usr << "A generic program has been run."
		return 1



	door_jack
		name = "Door Jack"
		program_id = "door_jack"
		data_used = 10 //Arbitrary amount for now.

		Run()

			return