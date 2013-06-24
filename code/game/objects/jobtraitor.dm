// Job related traitor items

// BARBER
/obj/item/weapon/jobitems/sharpening
	name = "sharpening stone"
	icon = 'items.dmi'
	icon_state = "c_tube"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 0.2
	w_class = 3.0
	throwforce = 0.2
	throw_speed = 2
	throw_range = 3

// make sure it works both ways...
/obj/item/weapon/jobitems/sharpening/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/razor))
		if(O:sharp)
			user << "\red This razor blade is already sharpened!"
		if(!O:sharp)
			user << "\red You sharp the razor blade.. it looks like a decent weapon now."
			O:sharp = 1
			O:force = 9.0
			O:throwforce = 25.0
	else
		..()
	return

/obj/item/weapon/razor/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/jobitems/sharpening))
		if(src:sharp)
			user << "\red This razor blade is already sharpened!"
		if(!src:sharp)
			user << "\red You sharp the razor blade.. it looks like a decent weapon now."
			src:sharp = 1
			src:force = 9.0
			src:throwforce = 25.0
	else
		..()
	return