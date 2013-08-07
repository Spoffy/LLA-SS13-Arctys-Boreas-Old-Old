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

	proc/decay_rods(amt)
		var/list/todo = control_rods.Copy() //Make a new list containing all the control rods.
		var/total_used = 0 //Amount of fuel used so far, up to a maximum of fuel_amt
		for(var/i = 1; i <= length(control_rods);i++) //Looping through once for each rod
			var/obj/item/weapon/nuclear/control_rod/C = pick(control_rods) //Pick a rod at random
			var/rod_used = rand( (amt/(2*length(control_rods))) ,((1.5*amt)/length(control_rods)) ) //Calculate decay. This can be 0.5*Average decay per rod or 1.5*decay fuel per rod
			if( ((total_used + rod_used) > amt) || i == length(control_rods)) //If we're going to use too much, or it's the last rod, use up enough to reach amt and no more..
				rod_used = amt - total_used
			C.decay(rod_used) //Decay the rod
			total_used += rod_used //Add to total
			todo -= C //Remove rod from list to prevent reselection

	proc/add_insertion(i_added)
		update_insertion(max(min(insertion+i_added,100),0))

	proc/update_insertion(n_insertion)
		insertion = n_insertion
		desc = "Machine for automated control rod insertion. Insertion: [insertion]%"

	proc/absorption_rate()
		var/total = 0
		for(var/obj/item/weapon/nuclear/control_rod/C in control_rods)
			total += C.absorption_rate()
		return total

	proc/rod_number()
		return length(control_rods)