/*This is modelled on real life reactors. Each rod emits X neutrons(a type of particle), while control rods absorb Y neutrons. 1 neutron is needed per fuel to continue the reaction.
More than 1, reaction increases, less than 1, reaction decreases.

I'm well aware the way the reactor starts and runs is actually bad physics, but it actually makes for a suprisingly good system.
*/

//TODO - Add buttons to allow faster insertion. Whole cooling + power system. Balancing. Make trigger to turn off emergency shutdown. Meltdowns. Radiation. Icons. Control rod decay. Anything else you might have forgotten.


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
	var/temp = 293 //kelvin
	var/maintain_reaction = 0
	var/emergency_shutdown = 0 //Toggled to 1 if reactor entered emergency shutdown

	var/obj/machinery/power/nuclear_power/control/computer //CHANGE TO COMPUTER 2 ONCE WORKING
	var/obj/machinery/power/nuclear_power/fuel_rod_control/fuel_control
	var/obj/machinery/power/nuclear_power/control_rod_control/rod_control

	var/list/users = list()

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
		// Work out how many neutrons continue
		var/emissions = fuel_control.emission_rate()
		var/absorptions = 0
		if(rod_control)
			absorptions = rod_control.absorption_rate()*(rod_control.insertion/100) //Absorptions = raw absorption rate of rods * % insertion.

		var/remaining_neutrons = max(emissions - absorptions,0)

		// Work out how many are continuing on per fuel.
		num_per_fuel = 0
		var/total_fuel = fuel_control.total_fuel()
		if(remaining_neutrons > 0)
			num_per_fuel = remaining_neutrons/total_fuel

		// Calculate our change in reaction.
		reaction_rate = reaction_rate*num_per_fuel //Because 1 is stable. E.g, 2 neutrons continuing would double reaction rate, as for each reaction, 2 more are caused.

		//Maintain reaction - Auto reaction maintenance - Calculate insertion % for the desired num_per_fuel
		//Formula for desired insertion: insertion = ((emissions - (num_per_fuel * total_fuel))/absorptions)*100
		if(maintain_reaction && rod_control)
			var/difference = reaction_rate - maintain_reaction
			var/new_insertion = rod_control.insertion
			if(difference > 0.5)
				new_insertion = ((emissions - (0.99 * total_fuel))/rod_control.absorption_rate())*100
			else if(difference < -0.5)
				new_insertion = ((emissions - (1.01 * total_fuel))/rod_control.absorption_rate())*100
			rod_control.update_insertion(new_insertion)

		//-More complicated bit: Temperature
		//Treat the reaction_rate as the amount temperature increases for simplicities sake.
		temp += reaction_rate

		//Handle lowering the temperature here.
		//TODO WHEN TEMP CONTROL COOTED

		fuel_control.use_fuel(reaction_rate/10)

		for(var/user in users)
			update_menu(user)

	proc/start_engine()
		if(running == 2) return
		if(running == 1 && reaction_rate != 0) return
		running = 1
		reaction_rate = 1

	proc/emergency_shutdown() //Insert 100% - Don't stop the processing until cooled - Handle process stopping in process
		if(!running || running == 2) return
		if(rod_control)
			rod_control.insertion = 100
		running = 2
		maintain_reaction = 0


	proc/update_menu(mob/user)
		if(!user) return
		if(get_dist(src,user) > 1 || !user.client)
			remove_user(user)
			return
		var/paramlist = "[running]&[reaction_rate]&[num_per_fuel]&[rod_control.insertion]&[temp]&[maintain_reaction]"
		user << output(paramlist,"engine_control.browser:updateAll")

	proc/remove_user(mob/user)
		users -= user
		user << browse(null,"window=engine_control")

	proc/generate_menu(mob/user)
		var/html = {"
		<script type='text/javascript'>
		function updateEngineStatus(active){
			var selected = document.getElementById("status")
			selected.innerHTML = (active == "1")?"ACTIVE":"INACTIVE";
			if(active == "2")
				selected.innerHTML = "EMRG"
			selected.style.backgroundColor = (active == "1")?"green":"red";
		}
		function updateRate(rate){
			var selected = document.getElementById("rate")
			selected.innerHTML = rate
			selected.style.backgroundColor = (rate == "0")?"red":"green"
		}
		function updateMultiplier(multiplier){
			var selected = document.getElementById("multiplier")
			selected.innerHTML = multiplier
			selected.style.backgroundColor = (multiplier > 1.5)?"orange":"green";
		}
		function updateInsertion(insertion){
			var selected = document.getElementById("insertion")
			selected.innerHTML = insertion + "%"
			selected.style.backgroundColor = (insertion == "0")?"red":"green";
		}
		function updateTemperature(temp){
			var selected = document.getElementById("temp")
			selected.innerHTML = temp
			if(temp > 1350) {
				selected.style.backgroundColor = "red";
				return;
			}
			selected.style.backgroundColor = (temp > 1000)?"orange":"green";
		}
		function updateMaintain(maintain){
			var selected = document.getElementById("maintain")
			selected.innerHTML = (maintain != "0")? maintain:"INACTIVE";
			selected.style.backgroundColor = (maintain == "0")?"red":"green";
		}
		function updateAll(status,rate,multiplier,insertion,temp,maintain){
			updateEngineStatus(status);
			updateRate(rate);
			updateMultiplier(multiplier);
			updateInsertion(insertion);
			updateTemperature(temp);
			updateMaintain(maintain);
		}
		</script>
		<body style='background-color=#8FB6FF;text-align=center;'>
		<center>
		<table border = 1 style='table-layout=fixed;font-family=Courier New;font-weight=bold;background-color=black;border-color=black;border-width=6px;'>
		<tr><td style='text-align=left;background-color=yellow;'>Fissile Status:</td><td id='status' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Reaction Rate:</td><td id='rate' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Reaction Multiplier:</td><td id='multiplier' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Rod Insertion:</td><td id='insertion' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Temperature (K):</td><td id='temp' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Maintain Reaction:</td><td id='maintain' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		</table>
		<table border = 0 style='table-layout=fixed;font-family=Courier New;font-weight=bold;text-align:center;'>
		<tr><td><button onclick='window.location = "?src=\ref[src];startup=1;mob=\ref[user];";'>Start up Reactor</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];shutdown=1;mob=\ref[user];";'>Emergency Shutdown</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];insert=1;mob=\ref[user];";'>&#x25B2;</button></td></tr>
		<tr><td>Insertion</td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];retract=1;mob=\ref[user];";'>&#x25BC;</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];maintain=1;mob=\ref[user];";'>Maintain</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];close_user=1;mob=\ref[user];";'>Close</button></td></tr>
		</table>
		</center>
		</body>
		"}
		user << browse(html,"window=engine_control;can_resize=0;size=300x500;can_close=0;")

	attack_hand(mob/user)
		if(!(user in users))
			users += user
			generate_menu(user)
		sleep(5)
		update_menu(user)

	Topic(href, href_list[])
		var/mob/user
		if(href_list["mob"])
			user = locate(href_list["mob"])
		if(!user) return
		if(get_dist(src,user) > 1 || !user.client)
			remove_user(user)

		if(href_list["close_user"])
			remove_user(user)
		else if(href_list["startup"])
			start_engine()
		else if(href_list["shutdown"])
			emergency_shutdown()
		else if(href_list["insert"])
			if(!rod_control) return
			rod_control.add_insertion(1)
			update_menu(user)
		else if(href_list["retract"])
			if(!rod_control) return
			rod_control.add_insertion(-1)
			update_menu(user)
		else if(href_list["maintain"])
			if(maintain_reaction)
				maintain_reaction = 0
			else
				maintain_reaction = round(reaction_rate)
			update_menu(user)


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
