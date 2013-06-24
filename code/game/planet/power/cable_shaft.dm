/*
#############
# THE INPUT #
#############
*/
/obj/machinery/power/shaft
	name = "cable shaft"
	level = 1
	density = 0
	anchored = 1
	directwired = 0
	var/id = ""
	var/n_tag = null

/obj/machinery/power/shaft/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & BROKEN) return
	interact(user)

/obj/machinery/power/shaft/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & BROKEN) return
	interact(user)

/obj/machinery/power/shaft/proc/interact(mob/user)
	..

/obj/machinery/power/shaft/input
	desc = "A small shaft with a fuse box attached to it."
	icon_state = "cable_shaft_in"
	var/sh_output = 10000
	var/sh_output_max = 80000
	var/sh_online = 1
	var/delivered_output_power = 0
	var/output_shaft_found = 0
	var/obj/machinery/power/shaft/output/output_shaft

/obj/machinery/power/shaft/input/New()
	..()
	spawn(5)
		DetectOutput()

/obj/machinery/power/shaft/input/proc/DetectOutput()
	for(var/obj/machinery/power/shaft/output/found_output_shaft in world)
		if(id == found_output_shaft.id)
			output_shaft = found_output_shaft
			output_shaft_found = 1
			output_shaft.input_shaft = src
			output_shaft.input_shaft_found = 1
			output_shaft.n_tag = n_tag

/obj/machinery/power/shaft/input/interact(mob/user)

	if ((get_dist(src, user) > 1))
		if (!istype(user, /mob/living/silicon/ai))
			user.machine = null
			user << browse(null, "window=fusebox")
			return

	user.machine = src


	var/t = "<TT><B>Fuse Box</B> [n_tag? "([n_tag])" : null]<HR>"

	if(!output_shaft_found || !output_shaft)
		sh_online = 0
		t += "<font color='#FF0000'><B>Eroor:</B> Cable connection not detected.</font> <A href = '?src=\ref[src];redetect=1'>Redetect</A>?"
		t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(t, "window=fusebox;size=460x200")
		onclose(user, "fusebox")
		return

	sh_output = max(0, min(sh_output_max, sh_output, surplus()))

	t += "<PRE>"
	t += "Availible power: [round(surplus())] W<BR>"

	t += "Main breaker: [sh_online ? "<B>On</B> <A href = '?src=\ref[src];online=1'>Off</A>" : "<A href = '?src=\ref[src];online=1'>On</A> <B>Off</B> "]<BR>"

	t += "Output level: <A href = '?src=\ref[src];output=-4'>M</A> <A href = '?src=\ref[src];output=-3'>-</A> <A href = '?src=\ref[src];output=-2'>-</A> <A href = '?src=\ref[src];output=-1'>-</A> [add_lspace(sh_output,5)] <A href = '?src=\ref[src];output=1'>+</A> <A href = '?src=\ref[src];output=2'>+</A> <A href = '?src=\ref[src];output=3'>+</A> <A href = '?src=\ref[src];output=4'>M</A><BR>"

	t += "Output load: [round(output_shaft.powernet.load)] W<BR>"

	t += "<BR></PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	user << browse(t, "window=fusebox;size=460x200")
	onclose(user, "fusebox")
	return

/obj/machinery/power/shaft/input/process()
	if(stat & BROKEN)
		return

	if(!output_shaft_found || !output_shaft)
		output_shaft_found = 0
		sh_online = 0

	sh_output = max(0, min(sh_output_max, sh_output, surplus()))

	if(sh_online && output_shaft_found)
		add_load(output_shaft.powernet.load)
		output_shaft.add_avail(sh_output)
		output_shaft.availible_power = sh_output

	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)

/obj/machinery/power/shaft/input/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained() )
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/living/silicon/ai))
			usr << "\red You don't have the dexterity to do this!"
			return

	if (( usr.machine==src && ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))

		if( href_list["close"] )
			usr << browse(null, "window=fusebox")
			usr.machine = null
			return

		else if( href_list["redetect"] )
			DetectOutput()

		else if( href_list["online"] )
			sh_online = !sh_online

		else if( href_list["output"] )

			var/i = text2num(href_list["output"])

			var/d = 0
			switch(i)
				if(-4)
					sh_output = 0
				if(4)
					sh_output = sh_output_max
				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			sh_output += d
			sh_output = max(0, min(sh_output_max, sh_output, surplus()))	// clamp to range and availible power


		src.updateUsrDialog()

	else
		usr << browse(null, "window=fusebox")
		usr.machine = null

	return


/*
##############
# THE OUTPUT #
##############
*/

/obj/machinery/power/shaft/output
	desc = "A small shaft."
	icon_state = "cable_shaft_out"
	var/obj/machinery/power/shaft/input/input_shaft
	var/input_shaft_found = 0
	var/availible_power = 0

/obj/machinery/power/shaft/output/interact(mob/user)

	if ((get_dist(src, user) > 1))
		if (!istype(user, /mob/living/silicon/ai))
			user.machine = null
			user << browse(null, "window=cableshaft")
			return

	user.machine = src

	var/t = "<TT><B>Cable Shaft</B> [n_tag? "([n_tag])" : null]<HR>"

	if(!input_shaft_found || !input_shaft)
		t += "<font color='#FF0000'><B>Eroor:</B> Cable connection not detected.</font>"
		t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(t, "window=cableshaft;size=460x200")
		onclose(user, "cableshaft")
		return

	t += "<PRE>"
	t += "Availible power: [round(availible_power)] W<BR>"
	t += "Load: [round(powernet.load)] W<BR>"
	t += "</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"
	t += "</TT>"
	user << browse(t, "window=cableshaft;size=460x200")
	onclose(user, "cableshaft")
	return

/obj/machinery/power/shaft/output/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained() )
		return

	if (( usr.machine==src && ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		if( href_list["close"] )
			usr << browse(null, "window=cableshaft")
			usr.machine = null
			return
		src.updateUsrDialog()
	else
		usr << browse(null, "window=cableshaft")
		usr.machine = null
	return