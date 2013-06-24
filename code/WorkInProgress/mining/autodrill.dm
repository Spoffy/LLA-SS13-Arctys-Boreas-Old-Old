/*/obj/machinery/mining/drill
	name = "drill"
	icon = 'mining.dmi'
	icon_state = "drill"
	desc = "An automatic material mining unit. Wrench to secure."
	density = 1
	anchored = 0 // If anchored, will attempt to mine minerals
	var/mat_seconds_per_unit = 2
	var/mat_power_per_unit = 100
	var/is_drilling = 0
	var/temp = null
	var/list/L = list()
	var/input_area
	var/output_area
	var/cover_open = 0
	var/pdmessage = 0
	var/battery_inserted = 0
	var/obj/item/weapon/cell/battery

/obj/machinery/mining/drill/New()
	battery = new /obj/item/weapon/cell(src)
	battery_inserted = 1
	battery.maxcharge = 15000
	battery.charge = battery.maxcharge
	DoIconUpdate()

/obj/machinery/mining/drill/examine()
	set src in view(1)
	if(usr && !usr.stat)
		usr << "An automatic material mining unit. Wrench to secure.\n"
		if(battery_inserted && !cover_open)
			usr << "The charge meter reads [round(battery.percent())]%."
		if(cover_open)
			usr << "The cover is opened, and the power cell is [ battery ? "installed" : "missing"]."

/obj/machinery/mining/drill/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/wrench))
		if(anchored)
			user << "You unsecure the mining drill."
			anchored = !anchored
		else
			if(!cover_open)
				is_drilling = 0
				pdmessage = 0
				input_area = locate(src.x, src.y, src.z)
				output_area = locate(src.x, src.y-1, src.z)
				user << "You secure the mining drill."
				anchored = !anchored
			else
				user << "You can't secure the drill, as the cover is open."
	if (istype(O, /obj/item/weapon/crowbar))
		if(!anchored)
			if(cover_open)
				cover_open = !cover_open
			else
				cover_open = !cover_open
			DoIconUpdate()
		else
			user << "You can't open the cover, as the drill is secured."
	if (istype(O, /obj/item/weapon/cell))
		if(battery_inserted)
			user << "There is already a power cell installed."
		else
			user << "You insert the power cell into the drill."
			user.drop_item()
			O.loc = src
			battery = O
			battery_inserted = 1
			DoIconUpdate()

/obj/machinery/mining/drill/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/mining/drill/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(stat & BROKEN) return
	if(cover_open && (!istype(user, /mob/living/silicon)))
		if(battery)
			battery.loc = usr
			battery.layer = 20
			if (user.hand)
				user.l_hand = battery
			else
				user.r_hand = battery

			battery.add_fingerprint(user)
			battery.updateicon()
			battery_inserted = 0
			battery = null
			DoIconUpdate()
			user << "You remove the power cell."
	else if

/obj/machinery/mining/drill/proc/DoIconUpdate()
	if(cover_open)
		if(battery_inserted)
			icon_state = "drill_open"
		else
			icon_state = "drill_open_nobattery"
	else
		icon_state = "drill"

/obj/machinery/mining/drill/proc/Drill()
	if(!anchored)
		spawn(mat_seconds_per_unit*10) Drill()
		return
	if(battery.charge < mat_power_per_unit)
		if(!pdmessage)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("The drill powers down."), 1)
			pdmessage = 1
		spawn(mat_seconds_per_unit*10) Drill()
		return
	for(var/obj/mars/rock/mineral_rock in input_area)
		if(battery.charge < mat_power_per_unit)
			if(!pdmessage)
				for(var/mob/O in viewers(src, null))
					O.show_message(text("The drill powers down."), 1)
				pdmessage = 1
			spawn(mat_seconds_per_unit*10) Drill()
			return
		if(!is_drilling)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("The drill begins mining the minerals."), 1)
		is_drilling = 1
		mineral_rock.RemoveMineral()
		battery.charge -= mat_power_per_unit
		spawn(15)
			playsound(src.loc, 'Crowbar.ogg', 50, 1)
			var/obj/item/weapon/chunk/thechunk = new /obj/item/weapon/chunk(output_area)
			thechunk.mineral_type = rand(0,2)
			thechunk.SetDescription()
			if(mineral_rock.mineral_amount < 1)
				del(mineral_rock)
	is_drilling = 0
	for(var/obj/mars/rock/mineral_rock in input_area)
		is_drilling = 1
	spawn(mat_seconds_per_unit*10) Drill()

*/


/obj/machinery/mining/drill
	name = "Industrial Mining Drill"
	desc = "A standard XXX co. mining drill."
	icon = 'mining.dmi'
	icon_state = "drill"
	var/extraction_rate = 5 //Ore extracted per cycle
//	var/list/hopper = list() //All the ore we've extracted that hasn't been emptied.

	proc/extractOre()
		if(!istype(src.loc,/turf/surface))
			return 0
		if(!src.loc:getMinerals())
			return 0

		var/datum/mining/mineral/M = src.loc:getMinerals()
		var/amountToExtract = extraction_rate
		var/amountAvailable = M.getAmount()
		if(amountAvailable < amountToExtract) amountToExtract = amountAvailable

		var/obj/item/weapon/chunk/chunk = new /obj/item/weapon/chunk(src.loc)
		var/datum/mining/mineral/minedMineral = new M.type(amountToExtract,M.getQuality())
		chunk.addMineral(minedMineral)

		M.setAmount(amountAvailable - amountToExtract)

		return 1




