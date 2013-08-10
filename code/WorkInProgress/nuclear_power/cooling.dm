/obj/machinery/power/nuclear_power/generator
	name = "Generator"
	desc = "Cools the reactors and generates power, all in one unit."
	icon = 'nuclear.dmi'
	icon_state = "plut_adder"
	anchored = 1
	density = 1

	var/obj/machinery/power/nuclear_power/reactor/reactor
	var/power_generated = 0 //Object level so we can access it from elsewhere.

	proc/calculate_heat_loss(reactor_temp, temp_difference)
		var/proportion_lost = min((reactor_temp ** 2)/3600000, 0.5) //Capping it at 0.5, to prevent instant drops to room temperature, which is just silly.

		return temp_difference*proportion_lost

	proc/calculate_power(temp_difference)
		return sqrt(temp_difference) * 5800



	proc/handle_reactor_tick()
		if(!reactor) return
		var/reactor_temp = reactor.get_temp() - reactor.reaction_rate //Adjusting for the discrepancy between the displayed value and the value used in this calculation. (Reaction rate added prior to cooling)
		var/temp_difference = max(reactor_temp - loc:temperature, 0)

		var/heat_loss = calculate_heat_loss(reactor_temp, temp_difference)
		power_generated = calculate_power(temp_difference)

		reactor.add_temp(-heat_loss)
		add_power(power_generated)


	proc/add_power(power)
		if(!powernet)
			powernet = locate(/datum/powernet) in loc
		add_avail(power)

	proc/get_power_generated()
		return power_generated