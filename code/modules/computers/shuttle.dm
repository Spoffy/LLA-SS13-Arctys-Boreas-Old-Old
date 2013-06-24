/obj/machinery/computer/shuttle/attackby(var/obj/item/weapon/card/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	if ((!( istype(W, /obj/item/weapon/card) ) || !( ticker ) || emergency_shuttle.location != 1 || !( user )))
		return


	if (istype(W, /obj/item/weapon/card/id))

		if (!W:access) //no access
			user << "The access level of [W:registered]\'s card is not high enough. "
			return

		var/list/cardaccess = W:access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			user << "The access level of [W:registered]\'s card is not high enough. "
			return

		if(!(access_heads in W:access)) //doesn't have this access
			user << "The access level of [W:registered]\'s card is not high enough. "
			return 0

		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		switch(choice)
			if("Authorize")
				src.authorized -= W:registered
				src.authorized += W:registered
				if (src.auth_need - src.authorized.len > 0)
					world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
				else
					world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
					emergency_shuttle.settimeleft(10)
					//src.authorized = null
					del(src.authorized)
					src.authorized = list(  )

			if("Repeal")
				src.authorized -= W:registered
				world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)

			if("Abort")
				world << "\blue <B>All authorizations to shorting time for shuttle launch have been revoked!</B>"
				src.authorized.len = 0
				src.authorized = list(  )

	else if (istype(W, /obj/item/weapon/card/emag))
		var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")
		switch(choice)
			if("Launch")
				world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
				emergency_shuttle.settimeleft( 10 )
			if("Cancel")
				return

	return

/*
/obj/shut_controller/proc/rotate(direct)

	var/SE_X = 1
	var/SE_Y = 1
	var/SW_X = 1
	var/SW_Y = 1
	var/NE_X = 1
	var/NE_Y = 1
	var/NW_X = 1
	var/NW_Y = 1
	for(var/obj/move/M in src.parts)
		if (M.x < SW_X)
			SW_X = M.x
		if (M.x > SE_X)
			SE_X = M.x
		if (M.y < SW_Y)
			SW_Y = M.y
		if (M.y > NW_Y)
			NW_Y = M.y
		if (M.y > NE_Y)
			NE_Y = M.y
		if (M.y < SE_Y)
			SE_Y = M.y
		if (M.x > NE_X)
			NE_X = M.x
		if (M.x < NW_X)
			NW_X = M.y
	var/length = abs(NE_X - NW_X)
	var/width = abs(NE_Y - SE_Y)
	var/obj/random = pick(src.parts)
	var/s_direct = null
	switch(s_direct)
		if(1.0)
			switch(direct)
				if(90.0)
					var/tx = SE_X
					var/ty = SE_Y
					var/t_z = random.z
					for(var/obj/move/M in src.parts)
						M.ty =  -M.x - tx
						M.tx =  -M.y - ty
						var/T = locate(M.x, M.y, 11)
						M.relocate(T)
						M.ty =  -M.ty
						M.tx += length
						//Foreach goto(374)
					for(var/obj/move/M in src.parts)
						M.tx += tx
						M.ty += ty
						var/T = locate(M.tx, M.ty, t_z)
						M.relocate(T, 90)
						//Foreach goto(468)
				if(-90.0)
					var/tx = SE_X
					var/ty = SE_Y
					var/t_z = random.z
					for(var/obj/move/M in src.parts)
						M.ty = M.x - tx
						M.tx = M.y - ty
						var/T = locate(M.x, M.y, 11)
						M.relocate(T)
						M.ty =  -M.ty
						M.ty += width
						//Foreach goto(571)
					for(var/obj/move/M in src.parts)
						M.tx += tx
						M.ty += ty
						var/T = locate(M.tx, M.ty, t_z)
						M.relocate(T, -90.0)
						//Foreach goto(663)
				else
		else
	return
*/

/obj/machinery/computer/prison_shuttle/verb/take_off()
	set src in oview(1)
	var/area/start_location
	var/area/end_location
	var/doorsclosing = 0
	var/zlevel
	var/A

	for(var/obj/machinery/computer/prison_shuttle/PS in world)
		if(!PS.isremotecontrol)
			zlevel = PS.z

	if (usr.stat || usr.restrained())
		return

	if(src.isworking)
		usr << "\red The console seems to be busy..."
		return

	if(!src.allowedtocall)
		usr << "\red The console seems irreparably damaged!"
		return
	if(zlevel == 2)
		usr << "\red Already in transit! Please wait!"
		return

	if(src.isremotecontrol)
		usr << "\red Launch sequence initiated!"
		usr << "\red Please be patient, the transfer may take up to 3 minutes."
	src.add_fingerprint(usr)

	if(zlevel == 5)
		A = locate(/area/shuttle/prison/planet)
	else
		A = locate(/area/shuttle/prison/station)

	for(var/obj/machinery/door/unpowered/shuttle/DR in A)
		if(!DR.density)
			src.isworking = 1
			doorsclosing = 1

	if(doorsclosing)
		for(var/mob/M in A)
			M.show_message("\red Step away from the doors, as they are being closed and locked.")

	for(var/obj/machinery/door/unpowered/shuttle/DR in A)
		if(!DR.density)
			DR.close()
			sleep(5)
		DR.operating = -1
	for(var/mob/M in A)
		M.show_message("\red Launch sequence initiated!")
		M.show_message("\red Please be patient, the transfer may take up to 3 minutes.")
		spawn(0)	shake_camera(M, 10, 1)
	sleep(10)

	src.isworking = 0

	/* Note */
	// 1 is the Station Z level
	// 2 is the Z level the Shuttle travels in
	// And 5 is the Planet Z level
	// Now uses keelin's move_contents_to

	if(zlevel == 5)
		start_location = locate(/area/shuttle/prison/planet)
		end_location = locate(/area/shuttle/prison/transfer)
		start_location.move_contents_to(end_location)

		sleep(rand(600,1800))

		start_location = locate(/area/shuttle/prison/transfer)
		end_location = locate(/area/shuttle/prison/station)
		start_location.move_contents_to(end_location)
	else
		start_location = locate(/area/shuttle/prison/station)
		end_location = locate(/area/shuttle/prison/transfer)
		start_location.move_contents_to(end_location)

		sleep(rand(600,1800))

		start_location = locate(/area/shuttle/prison/transfer)
		end_location = locate(/area/shuttle/prison/planet)
		start_location.move_contents_to(end_location)

	if(zlevel == 5)
		A = locate(/area/shuttle/prison/station)
	else
		A = locate(/area/shuttle/prison/planet)

	for(var/obj/machinery/door/unpowered/shuttle/DR in A)
		DR.operating = 0

	for(var/mob/M in A)
		M.show_message("\red Planetary shuttle has arrived at destination!")
		spawn(0)	shake_camera(M, 2, 1)
	return

/*
/obj/machinery/computer/prison_shuttle/verb/restabalize()
	set src in oview(1)

	src.add_fingerprint(usr)

	var/A = locate(/area/shuttle/prison/)
	for(var/mob/M in A)
		M.show_message("\red <B>Restabilizing Planetary shuttle atmosphere!</B>")
*/