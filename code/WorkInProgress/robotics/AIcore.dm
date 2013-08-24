/obj/item/robotics/core
	name = "AI Core Unit"
	desc = "A unit that holds an active AI."
	icon = 'module.dmi'
	icon_state = "id_mod"

	var/mob/living/robotics/rai/ai

	// Set the AI of the core.
	proc/SetAI(mob/living/robotics/rai/R)
		ai = R
		R.core = src

	// Clear the AI stored in the core.
	proc/ClearAI()
		ai.core = null
		ai = null

	Move()
		return

