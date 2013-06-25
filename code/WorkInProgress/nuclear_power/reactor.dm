/*This is modelled on real life reactors. Each rod emits X neutrons(a type of particle), while control rods absorb Y neutrons. 1 neutron is needed per fuel to continue the reaction.
More than 1, reaction increases, less than 1, reaction decreases.

I'm well aware the way the reactor starts and runs is actually bad physics, but it actually makes for a suprisingly good system.
*/


/obj/machinery/power/nuclear_power/reactor
	name = "Reactor Core"
	desc = "A state of the art nuclear power reactor."
	icon = 'nuclear.dmi'
	icon_state = "reactor"
	anchored = 1
	density = 1

	var/running = 0
	var/reaction_rate = 0
	var/num_per_fuel = 0
	var/temp = 273 //kelvin
	var/maintain_reaction = 0

	var/obj/machinery/power/nuclear_power/control/computer //CHANGE TO COMPUTER 2 ONCE WORKING
	var/obj/machinery/power/nuclear_power/fuel_rod_control/fuel_control
	var/obj/machinery/power/nuclear_power/control_rod_control/rod_control

	New()
		..()
		spawn(15) //Gives the parts time to spawn.
			check_parts()

	proc/check_parts()
		if(!fuel_control)
			var/turf/loc = locate(x-1,y,z)
			for(var/obj/machinery/power/nuclear_power/fuel_rod_control/F in loc)
				fuel_control = F
				break

		if(!rod_control)
			var/turf/loc = locate(x+1,y,z)
			for(var/obj/machinery/power/nuclear_power/control_rod_control/C in loc)
				rod_control = C
				break

#define BASEPOWER 50
	process()
		if(!running)
			return
		if(!rod_control)
			running = 0
			return
		// Work out how many neutrons continue
		var/emissions = fuel_control.emission_rate()
		var/absorptions = 0
		if(rod_control)
			absorptions = rod_control.absorption_rate()
		var/remaining_neutrons = max(emissions - absorptions,0)

		// Work out how many are continuing on per fuel.
		num_per_fuel = 0
		if(remaining_neutrons > 0)
			num_per_fuel = remaining_neutrons/fuel_control.total_fuel()

		// Calculate our change in reaction.
		reaction_rate = reaction_rate*num_per_fuel //Because 1 is stable. E.g, 2 neutrons continuing would double reaction rate, as for each reaction, 2 more are caused.

		//Maintain reaction - Auto reaction maintenance
		if(maintain_reaction && rod_control)
			var/difference = reaction_rate - maintain_reaction
			if(difference > 0)
				//CONTINUE - REMOVE(Use a low rate of change so big values take ages to adjust)

		//-More complicated bit: Temperature
		//Treat the reaction_rate as the amount temperature increases for simplicities sake.
		temp += reaction_rate

		//Handle lowering the temperature here.
		//TODO WHEN TEMP CONTROL COOTED

		fuel_control.use_fuel(reaction_rate/10)

		world << "Remaining Neutrons: [remaining_neutrons]"
		world << "Reaction Rate: [reaction_rate]"
		world << "Num Per Fuel: [num_per_fuel]"
		world << "Temp: [temp]"

	verb/test()
		set src in view()
		running =1
		reaction_rate = 1
		temp = 273
		process()
	verb/maintain()
		set src in view()
		if(maintain_reaction)
			maintain_reaction = 0
		else
			maintain_reaction = reaction_rate

/obj/machinery/power/nuclear_power/fuel_rod_control
	name = "Fuel Rod Manager"
	desc = "Machine for automated control rod insertion."
	icon = 'nuclear.dmi'
	icon_state = "plut_adder"
	anchored = 1
	density = 1

	var/list/fuel_rods = list()
	var/max_fuel_rods = 6

	attackby(var/obj/O as obj, var/mob/user as mob)
		if(istype(O, /obj/item/weapon/nuclear/plutonium))
			if(length(fuel_rods) >= max_fuel_rods)
				user << "All of the plutonium chambers are full!"
				return
			O.loc = src
			fuel_rods += O
			user.u_equip(O)

			user << "You insert the plutonium into an empty chamber."
			return

		return ..()

	attack_hand(mob/user)
		if(!length(fuel_rods))
			return 0
		var/list/rod_option_list[6]
		for(var/i = 1; i <= length(fuel_rods);i++)
			var/obj/item/weapon/nuclear/plutonium/P = fuel_rods[i]
			var/fuel_percent = round((P.fuel_remaining/P.initial_fuel)*100)
			rod_option_list[i] = "Rod [i] - Fuel Remaining: [fuel_percent]%"
		var/choice = input(user,"Select the rod to remove","Rod removal") as null|anything in rod_option_list
		if(!choice)
			return
		for(var/k = 1; k <= length(rod_option_list); k++)
			if(choice == rod_option_list[k])
				choice = k
				break
		var/obj/item/weapon/nuclear/plutonium/P = fuel_rods[choice]
		fuel_rods -= P
		user.put_in_hand(P)

	proc/use_fuel(fuel_amt)
		var/list/todo = fuel_rods.Copy() //Make a new list containing all the fuel rods.
		var/total_used = 0 //Amount of fuel used so far, up to a maximum of fuel_amt
		for(var/i = 1; i <= length(fuel_rods);i++) //Looping through once for each rod
			var/obj/item/weapon/nuclear/plutonium/P = pick(fuel_rods) //Pick a rod at random
			var/fuel_used = rand( (fuel_amt/(2*length(fuel_rods))) ,((1.5*fuel_amt)/length(fuel_rods)) ) //Calculate fuel used. This can be 0.5*Average fuel per rod or 1.5*Average fuel per rod
			if( ((total_used + fuel_used) > fuel_amt) || i == length(fuel_rods)) //If we're going to use too much, or it's the last rod, use up enough to reach fuel_amt and no more..
				fuel_used = fuel_amt - total_used
			P.use_fuel(fuel_used) //Take the fuel from the rod
			total_used += fuel_used //Add to total
			todo -= P //Remove rod from list to prevent reselection

	proc/emission_rate()
		var/total = 0
		for(var/obj/item/weapon/nuclear/plutonium/P in fuel_rods)
			total += P.emission_rate()
		return total

	proc/total_fuel()
		var/total = 0
		for(var/obj/item/weapon/nuclear/plutonium/P in fuel_rods)
			total += P.fuel_remaining
		return total

	proc/rod_number()
		return length(fuel_rods)




/obj/machinery/power/nuclear_power/control_rod_control
	name = "Control Rod Manager"
	desc = "Machine for automated control rod insertion. Insertion: 0%"
	icon = 'nuclear.dmi'
	icon_state = "plut_adder"
	anchored = 1
	density = 1

	var/list/control_rods = list()
	var/max_control_rods = 6
	var/insertion = 0

	// Transfer decay over to reactor, simplify proc.
	var/decay_delay = 200
	var/next_decay = 0

	attackby(var/obj/O as obj, var/mob/user as mob)
		if(istype(O, /obj/item/weapon/nuclear/control_rod))
			if(length(control_rods) >= max_control_rods)
				user << "All of the control rod chambers are full!"
				return
			O.loc = src
			control_rods += O
			user.u_equip(O)

			user << "You insert the control rod into an empty chamber."
			return

		return ..()

	attack_hand(mob/user)
		if(!length(control_rods))
			return 0
		var/list/rod_option_list[6]
		for(var/i = 1; i <= length(control_rods);i++)
			var/obj/item/weapon/nuclear/control_rod/C = control_rods[i]
			rod_option_list[i] = "Rod [i] - Decay Percentage: [round(C.decay)]%"
		var/choice = input(user,"Select the rod to remove","Rod removal") as null|anything in rod_option_list
		if(!choice)
			return
		for(var/k = 1; k <= length(rod_option_list); k++)
			if(choice == rod_option_list[k])
				choice = k
				break
		var/obj/item/weapon/nuclear/control_rod/C = control_rods[choice]
		control_rods -= C
		user.put_in_hand(C)

	proc/decay_rods()
		for(var/obj/item/weapon/nuclear/control_rod/C in control_rods)
			var/decay = rand(0,1)
			C.decay(decay)

	proc/update_insertion(n_insertion)
		insertion = n_insertion
		desc = "Machine for automated control rod insertion. Insertion: [insertion]%"

	proc/absorption_rate()
		var/total = 0
		for(var/obj/item/weapon/nuclear/control_rod/C in control_rods)
			total += C.absorption_rate()
		return total*insertion/100

	proc/rod_number()
		return length(control_rods)

	verb/set_height(h as num)
		set category = "NUCLEAR"
		set src in view()
		insertion = max(min(h,100),0)

/obj/machinery/power/nuclear_power/control
	name = "core control computer"
	desc = "A computer. For the core."
	icon = 'computer.dmi'
	icon_state = "core"
	anchored = 1
	density = 1

/*
	New()

	attack_hand(mob/user as mob)
		user.machine = src
		var/coolant = cool_one.coolant + cool_two.coolant
		var/plutonium = plut_one.plutonium + plut_two.plutonium
		var/dat = "<B>NUCLEAR REACTOR CONTROL PANEL</B><BR><HR><BR>"
		if(src.hooked.running)
			dat += "Running: YES<BR>Temperature: [src.hooked.temperature]°C<BR>Control rods: [src.hooked.control_rods]%<BR>Power output: [hooked.power_out]<BR>Coolant left: [coolant]<BR>Plutonium left: [plutonium]<BR><HR><BR>"
			dat += "<A href='?src=\ref[src];toggle=1'>Stop</A><BR><A href='?src=\ref[src];cr_minusten=1'>--</A> <A href='?src=\ref[src];cr_minus=1'>-</A>Control rods<A href='?src=\ref[src];cr_plus=1'>+</A> <A href='?src=\ref[src];cr_plusten=1'>++</A><BR>"
		else
			dat += "Running: NO<BR>Temperature: [hooked.temperature]°C<BR>Control rods: n/a%<BR>Power output: [hooked.power_out]<BR>Coolant left: n/a<BR>Plutonium left: n/a<BR><HR><BR>"
			dat += "<A href='?src=\ref[src];toggle=1'>Start</A><BR><A href='?src=\ref[src];cr_minusten=-1'>--</A> <A href='?src=\ref[src];cr_minus=1'>-</A>Control rods<A href='?src=\ref[src];cr_plus=1'>+</A> <A href='?src=\ref[src];cr_plusten=1'>++</A><BR>"
		user << browse("[dat]", "window=core_control")
		onclose(user, "core_control")

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src

		if (href_list["toggle"])
			if(src.hooked.running)
				src.hooked.running = 0
			else
				src.hooked.running = 1
		if (href_list["cr_minusten"])
			if((src.hooked.control_rods - 10) >= 0)
				src.hooked.control_rods -= 10
			else
				hooked.control_rods = 0
		if (href_list["cr_minus"])
			if((src.hooked.control_rods - 1) >= 0)
				src.hooked.control_rods -= 1
			else
				hooked.control_rods = 0
		if (href_list["cr_plusten"])
			if((src.hooked.control_rods + 10) <= 100)
				src.hooked.control_rods += 10
			else
				hooked.control_rods = 100
		if (href_list["cr_plus"])
			if((src.hooked.control_rods + 1) <= 100)
				src.hooked.control_rods += 1
			else
				src.hooked.control_rods = 100
		src.updateUsrDialog()

*/
