/* The disposal vender from donut-station SS13. Readded by Tweet */

/obj/machinery/dpipedisp/attack_hand(user as mob)
	if(..())
		return

	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
"}

	user << browse("<HEAD><TITLE>Disposal Pipe Dispenser</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/dpipedisp/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["dmake"])
		var/p_type = text2num(href_list["dmake"])
		var/obj/disposalconstruct/C = new (src.loc)
		switch(p_type)
			if(0)
				C.ptype = 0
			if(1)
				C.ptype = 1
			if(2)
				C.ptype = 2
			if(3)
				C.ptype = 4
			if(4)
				C.ptype = 5

		C.update()

		usr << browse(null, "window=pipedispenser")
		usr.machine = null
	return

