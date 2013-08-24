/*This is modelled on real life reactors. Each rod emits X neutrons(a type of particle), while control rods absorb Y neutrons. 1 neutron is needed per fuel to continue the reaction.
More than 1, reaction increases, less than 1, reaction decreases.

I'm well aware the way the reactor starts and runs is actually bad physics, but it actually makes for a suprisingly good system.

--System Architecture--
The computer is responsible for linking with and controlling the reactor core.
The reactor core is responsible for processing the reaction and handling the attached machines through handle_reactor_tick()
The rod controllers are controlled by the reactor.
The generator is triggered by the reactor and returns information to it.

*/

//TODO -  Meltdowns. Radiation. Icons. Pretty up the menu. Anything else you might have forgotten.

var/const/REACTOR_WARNING_TEMP = 1000
var/const/REACTOR_FAILSAFE_TEMP = 1300
var/const/REACTOR_CRITICAL_TEMP = 1600

/obj/machinery/power/nuclear_power/reactor
	name = "Reactor Core"
	desc = "A state of the art nuclear power reactor."
	icon = 'nuclear.dmi'
	icon_state = "reactor"
	anchored = 1
	density = 1

	var/reaction_rate = 0
	var/num_per_fuel = 0
	var/temp = 293 //kelvin
	var/maintain_reaction = 0
	var/emergency_shutdown = 0 //Toggled to 1 if reactor entered emergency shutdown
	var/safeties = 1

	//Config values


	var/obj/machinery/power/nuclear_power/control/computer //CHANGE TO COMPUTER 2 ONCE WORKING
	var/obj/machinery/power/nuclear_power/fuel_rod_control/fuel_control
	var/obj/machinery/power/nuclear_power/control_rod_control/rod_control
	var/obj/machinery/power/nuclear_power/generator/generator


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

		if(!generator)
			var/turf/loc = locate(x,y+1,z)
			for(var/obj/machinery/power/nuclear_power/generator/G in loc)
				generator = G
				G.reactor = src
				break

#define BASEPOWER 50
	process()
		// Check the reactor won't explode on this tick.. if the safeties are activated.
		if(safeties)
			safety_check()

		if(temp > REACTOR_CRITICAL_TEMP)
			meltdown()

		// Only handle the nuclear reactions if we're actually reacting.
		if(reaction_rate)
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
				rod_control.add_insertion(new_insertion - rod_control.insertion)

			//Treat the reaction_rate as the amount temperature increases for simplicities sake.
			add_temp(reaction_rate)

			//Numbers are geared towards 15-20 minutes runtime.
			fuel_control.use_fuel(reaction_rate/10)
			rod_control.decay_rods(0.2)

		if(generator)
			generator.handle_reactor_tick()

		if(computer)
			computer.handle_reactor_tick()

	proc/start_engine()
		if(is_emrg_shutdown()) return
		if(reaction_rate != 0) return
		check_parts()
		reaction_rate = 1

	proc/emergency_shutdown() //Insert 100% - Don't stop the processing until cooled - Handle process stopping in process
		if(is_emrg_shutdown()) return
		if(rod_control)
			rod_control.insertion = 100
		emergency_shutdown = 1
		maintain_reaction = 0

	proc/is_emrg_shutdown()
		return emergency_shutdown

	proc/clear_emrg()
		emergency_shutdown = 0

	proc/retrieve_paramlist()
		return "[emergency_shutdown]&[reaction_rate]&[num_per_fuel]&[rod_control.insertion]&[temp]&[maintain_reaction]&[(generator)? generator.get_power_generated():"0"]&[safeties]"

	proc/get_temp()
		return temp

	proc/add_temp(add)
		temp += add

	proc/safety_check()
		if(temp > REACTOR_FAILSAFE_TEMP)
			emergency_shutdown()

	proc/meltdown()
		return




