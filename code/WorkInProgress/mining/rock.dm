/*/obj/mars/rock
	name = "rock"
	icon = 'mining.dmi'
	icon_state = "1"
	desc = "A rock."
	anchored = 1
	density = 0
	opacity = 0
	var/mineral_amount
	var/mineral_type
	// Mineral types:
	// 0 : Ore (Metal)
	// 1 : Sand (Glass)
	// 2 : Chrystal (Energy)

/obj/mars/rock/New()
	icon_state = "[pick(1,2,3,4,5)]"
	mineral_amount = rand(55,69)
	//mineral_type = rand(0,2) << The mineral_type is now randomly selected upon chunk creation.

/obj/mars/rock/proc/RemoveMineral()
	mineral_amount -= 1
	if(mineral_amount >= 40)
		desc = "A rock."
		return
	if(mineral_amount >= 23)
		desc = "A rock. Looks like someone already mined some chunks out of it."
		return
	if(mineral_amount >= 1)
		desc = "A small rock, with sharp edges."
		return

/obj/mars/rock/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/pickaxe))
		user << "You begin to mine a chunk out of the rock..."
		src.RemoveMineral()
		spawn(15)
			playsound(src.loc, 'Crowbar.ogg', 50, 1)
			user << "You finish mining a chunk out of the rock!"
			var/obj/item/weapon/chunk/thechunk = new /obj/item/weapon/chunk(usr.loc)
			//thechunk.mineral_type = src.mineral_type
			thechunk.mineral_type = rand(0,2)
			thechunk.SetDescription()
			if(mineral_amount < 1)
				del(src)


*/