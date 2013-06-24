// separator machine
// refines scrap into purer types

/obj/machinery/separator
	anchored = 1
	density = 1
	icon = 'recycling.dmi'
	icon_state = "separator-A0"
	var/on = 1
	var/outdir = SOUTH
	var/obj/overlay/over
	var/base_state = "separator-A"

/obj/machinery/separator/New()
	..()

	over = new/obj/overlay(src.loc)
	over.icon = 'recycling.dmi'
	over.layer = FLY_LAYER
	over.pixel_y = 6
	over.anchored = 1
	update()

/obj/machinery/separator/proc/update()
	icon_state = "[base_state][on]"
	over.icon_state = "[base_state]O[on]"

// only allow scrap to enter from the West turf and when separator is running
/obj/machinery/separator/CheckPass(atom/movable/O, var/turf/target)
	if(!on)
		return 0
	if(!istype(O, /obj/item/scrap))
		return 0
	var/direct = get_dir(O, target)
	if(direct == EAST)
		return 1
	return 0


/obj/machinery/separator/proc/refine(var/obj/item/scrap/S)
	return

/obj/machinery/separator/process()
	if(!on || stat & (BROKEN|NOPOWER))
		return
	use_power(1000)

	var/obj/item/scrap/S = locate() in src.loc
	if(!S)
		return

	var/obj/item/scrap/T = refine(S)

	if(S)
		spawn(5)
			step(S,EAST)
	if(T)
		spawn(5)
			step(T,outdir)


/obj/machinery/separator/metal1
	name = "ferromagnetic separator"
	desc = "A coarse metal separator that sorts scrap using magnets."

	refine(var/obj/item/scrap/S)
		if(!S)
			return null

		var/obj/item/scrap/T = new(src.loc)

		var/T_m_amt = round(S.m_amt / 2)
		if(T_m_amt < 50)
			T_m_amt = S.m_amt
		S.m_amt -= T_m_amt
		S.update()
		T.set_components(T_m_amt, 0,0)
		T.update()

		if(T.total()<1)
			del(T)

		if(S.total()<1)
			del(S)

		return T


/obj/machinery/separator/metal2
	name = "paramagnetic separator"
	desc = "A fine metal separator that sorts scrap using induced magnetic fields."

	refine(var/obj/item/scrap/S)
		if(!S)
			return null

		var/obj/item/scrap/T = new(src.loc)

		var/T_g_amt = round(S.g_amt / 2, 1)
		var/T_w_amt = round(S.w_amt / 2, 1)
		if(T_g_amt < 100)
			T_g_amt = S.g_amt

		if(T_w_amt < 100)
			T_w_amt = S.w_amt


		S.g_amt -= T_g_amt
		S.w_amt -= T_w_amt
		S.update()
		T.set_components(0, T_g_amt,T_w_amt)
		T.update()

		if(T.total()<1)
			del(T)

		if(S.total()<1)
			del(S)

		return T

/obj/machinery/separator/density
	name = "cyclonic separator"
	desc = "A density separator that sorts scrap using a cyclonic vaccuum."

	refine(var/obj/item/scrap/S)
		if(!S)
			return null

		var/obj/item/scrap/T = new(src.loc)

		var/T_m_amt = round(S.m_amt / 2,1)
		var/T_g_amt = round(S.g_amt / 2,1)

		if(T_g_amt < 100)
			T_g_amt = S.g_amt

		S.m_amt -= T_m_amt
		S.g_amt -= T_g_amt

		S.update()
		T.set_components(T_m_amt, T_g_amt, 0)
		T.update()

		if(T.total()<1)
			del(T)

		if(S.total()<1)
			del(S)

		return T
