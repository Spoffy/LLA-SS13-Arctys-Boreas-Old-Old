obj/structure/comm_tower
	name = "Communications Tower"
	desc = "A mast used to relay radio communications around the planet."
	anchored = 1
	density = 1
	icon = 'structures32x96.dmi'
	icon_state = "radio_mast"
	radio_range = 100

	New()
		..()
		sleep(100)
		radio_controller.relay_masts += src