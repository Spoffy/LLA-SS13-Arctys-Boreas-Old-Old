/* A prayer system, availiable in the chapel. */

/mob/verb/pray()
	set name = "Pray"
	set category = "IC"
	var/rmsg = input(src,"For what do you want to pray?","Praying") as text
	var/msg = copytext(sanitize(rmsg),1,MAX_MESSAGE_LEN)
	var/area/myarea = src.loc.loc // Insert the the check here. I don't get the areas
	if(istype(myarea, /area/chapel))
		src.emote("clap")
		src.whisper("[msg]")
		sendprayer(msg, src)
		return
	else
		usr << "This place just dont feel spiritual enough..."

/proc/sendprayer(var/text, var/mob/P)
	for (var/mob/M in world)
		if (M.client && M.client.holder && M.client.listenpray)
			M << "\blue <b>PRAY: [key_name(P,M)](<A href='?src=\ref[M.client.holder];prayeropts=\ref[P]'>X</A>):</b> [text]"

/client/proc/tprayers()
	set category = "Special Verbs"
	set desc= "Hear you can toggle if you want to listen to prayers or not."
	set name= "Prayers"
	if(src.listenpray == 0)
		src.listenpray = 1
		usr << "You are now listening to prayers."
		log_admin("[key_name(usr)] turned LISTEN PRAYERS: ON.")
	else
		src.listenpray = 0
		usr << "You are not listening to prayers anymore."
		log_admin("[key_name(usr)] turned LISTEN PRAYERS: OFF.")

/*

/proc/pray_thunder(var/name)
	name:eye_stat += rand(0, 5)
	name << "\red You hear a crackle of thunder!"
	return

/proc/item_in_face(var/name)
	var/list/selectable = list()
	for(var/O in typesof(/obj/item/))
		//Note, these istypes don't work
		if(istype(O, /obj/item/weapon/gun))
			continue
		if(istype(O, /obj/item/assembly))
			continue
		if(istype(O, /obj/item/weapon/camera))
			continue
		if(istype(O, /obj/item/weapon/cloaking_device))
			continue
		if(istype(O, /obj/item/weapon/dummy))
			continue
		if(istype(O, /obj/item/weapon/sword))
			continue
		if(istype(O, /obj/item/device/shield))
			continue
		selectable += O

	var/hsbitem = input(usr, "Choose an object to spawn.", "Pray penalty:") in selectable + "Cancel"
	if(hsbitem != "Cancel")
		pray_thunder(name)
		new hsbitem(name:loc)
		return
	else
		return

*/