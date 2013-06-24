// A proc added from the old code

/atom/proc/CheckPass(atom/O as mob|obj|turf|area)
	if(istype(O,/atom/movable))
		var/atom/movable/A = O
		return (!src.density || (!A.density && !A.throwing))
	return (!O.density || !src.density)

// the grinder

/obj/machinery/grinder
	name = "grinder"
	desc = "A heavy duty grinding machine capable of reducing almost anything to scrap."

	icon = 'recycling.dmi'
	icon_state = "grinder-o0"
	var/obj/machinery/grinder_over/over
	var/obj/machinery/grinder_over/out
	anchored = 1
	density = 1
	var/on = 0
	var/bloodlevel = 0 		// >0 if machine is bloody

/obj/machinery/grinder/New()
	..()
	icon_state = "grinder-a0"
	out = new/obj/machinery/grinder_over(get_step(src.loc,EAST), src)
	out.icon_state = "grinder-b0"

	over = new/obj/machinery/grinder_over(src.loc, src)
	over.pixel_y = 6
	over.density = 0
	machines -= over

/obj/machinery/grinder_over
	icon = 'recycling.dmi'
	icon_state = "grinder-o0"
	layer = FLY_LAYER
	density = 1
	anchored = 1
	var/obj/machinery/grinder/master


/obj/machinery/grinder_over/New(loc, var/obj/machinery/grinder/mstr)
	..()
	master = mstr
	name = master.name
	desc = master.desc


/obj/machinery/grinder/verb/tggl()
	set src in view()
	toggle()

/obj/machinery/grinder_over/verb/tggl()
	set src in view()
	master.toggle()

/obj/machinery/grinder/proc/toggle()

	on = !on
	update()

/obj/machinery/grinder/proc/update()
	icon_state="grinder-a[on]"
	over.icon_state="grinder-o[on][bloodlevel > 0 ? "bld" : ""]"
	out.icon_state="grinder-b[on]"


// only allow things to enter from the West turf and when grinder is running
/obj/machinery/grinder/CheckPass(atom/movable/O, var/turf/target)
	if(!density)
		return 1
	if(!on)
		return 0
	var/direct = get_dir(O, target)
	if(direct == EAST)
		return 1
	return 0

// don't allow anything to exit the grinder
/obj/machinery/grinder/CheckExit(atom/movable/O)

	return 0

// timed machine process
// reduce anything in this turf to scrap items and copy them into the output

/obj/machinery/grinder/process()
	if(!on || stat & (BROKEN|NOPOWER))
		return
	use_power(500)	// base power usage
	// first copy anything not anchored in the turf to the grinder contents
	for(var/atom/movable/A in loc.contents - src)
		if(A.anchored)
			continue
		A.grind_act(src)
		src.loc.contents += A.get_content() // note will recursively add contents of atom
		src.contents += A


	// now reduce everything in the grinder's contents to scrap
	var/obj/item/scrap/S
	var/obj/item/scrap/T = new()

	for(var/atom/movable/O in src)
		//world << "Found in grinder: [O]"

		// set T to the amounts in the object
		use_power(250)
		T.set_components(O.get_component(1), O.get_component(2), O.get_component(3))
		T.blood = min(2,round(bloodlevel/10))
		if(bloodlevel>0)
			bloodlevel--
			if(bloodlevel < 1)
				update()

		//world << "Turned into [T.to_text()]"

		if(T.total() > 0)
			var/obj/item/scrap/U = T.remainder()	// ensure T is not bigger than max size
			if(U)				// otherwise remainder is returned in U
				//world << "Limited to [T.to_text()]"
				//world << "Remainder [U.to_text()] added"
				contents += U	// if so, add it for later processing

			if(!S)				// did we create scrap yet?
				S = new(out)	// create if in the output
			S.add_scrap(T)		// add what was in T
			//world << "[S.to_text()] now in output"

			if(T && T.total() > 0)			// T will still exist if could not transfer all of T to output
				//world << "[T.to_text()] remaining"
				S = T.copy()	// so copy what's left into S
				S.loc = out		// and create it in the output
			else
				T = new()

		del(O)					// delete the item



// this is the output timed process
// if on, find a single item in contents and move it to the East
// this spreads out scrap into individual piles
/obj/machinery/grinder_over/process()
	if(!master.on)
		return


	var/atom/movable/A = locate() in src.contents
	if(A)
		//world << "[A] in output"
		A.loc = src.loc
		spawn(2)
			if(!step(A,EAST))
				if(A)
					A.loc = src			// if couldn't move to output turf, then put back inside

// recursively return the contents of an atom
// works to any depth of atoms nested inside others
/atom/proc/get_content()
	var/list/L = list()
	for(var/atom/A in src.contents)

		A.layer = initial(A.layer)
		L += A.get_content()
		L += A
	return L



// return the amount of metal, glass or waste making up this object
// defaults to m_amt, g_amt, w_amt
// cmp : 1=metal, 2=glass, 3=waste
/atom/movable/proc/get_component(var/cmp)
	return 0

/obj/get_component(var/cmp)
	switch(cmp)
		if(1)
			return m_amt
		if(2)
			return g_amt
		if(3)
			return w_amt


// action when crunched by grinder
// by default, do nothing
// may be overridden to perfom action - e.g. canister releases gas
/atom/movable/proc/grind_act(var/obj/machinery/grinder/grinder)
	return



/mob/grind_act(var/obj/machinery/grinder/grinder)
	if(src.client)
		var/mob/dead/observer/newmob = new/mob/dead/observer(src)
		src.client.mob = newmob
		newmob.client.eye = newmob