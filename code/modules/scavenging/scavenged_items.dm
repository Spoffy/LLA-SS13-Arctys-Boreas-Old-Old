//The format used for the example is the format for the file, please stick to it where possible (And/or rewrite it :P)

obj/scavenging/item
	//EXAMPLE
	example
		name = "Example Item"
		desc = "An example item for the scavenging system."
		icon = 'stationobjs.dmi'
		icon_state = "crema1old"
		event_chance = 50

		setup_item()
			add_sequence_item(/obj/item/weapon/wrench,"You randomly unscrew a bolt. The machine creaks.","crema1")
			add_sequence_item(/obj/item/weapon/screwdriver,"You unscrew the bolt further with your screwdriver. Yes, this machine is made of bolts.")
			add_sequence_item("hand","You punch the machine.")
			add_fixedreward(/obj/item/weapon/wrench)

		handle_event()
			visible_message("This is an event!")
			return 1
	//-------

/obj/scavenging/item
	engine
		name = "Decaying Engine"
		desc = "An old engine unit, worn and corroded with time."
		icon = 'tram.dmi'
		icon_state = ""
		event_chance = 20

		setup_item()
			add_sequence_item(/obj/item/weapon/screwdriver, "You unscrew the screws on the maintenance panel.")
			add_sequence_item(/obj/item/weapon/crowbar,"You pry off the maintenance panel.")
			add_sequence_item(/obj/item/weapon/wirecutters, "You remove some of the worn out wires.")
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut away the edges of the panel.")
			add_sequence_item(/obj/item/weapon/wirecutters, "You remove some more wires.")
			add_sequence_item(/obj/item/weapon/screwdriver, "You remove any remaining useful parts from the engine.")
			add_fixedreward(/obj/item/weapon/cable_coil)
			add_fixedreward(/obj/item/weapon/sheet/metal/random)
			add_fixedreward(/obj/item/constructionkit/component/control_board)
			add_fixedreward(/obj/item/constructionkit/component/relay_board)
			add_fixedreward(/obj/item/constructionkit/component/capacitor)
			add_fixedreward(/obj/item/constructionkit/component/solder)
			add_randomreward(/obj/item/constructionkit/component/transistor)
			add_randomreward(/obj/item/weapon/tank/plasma)
			add_randomreward(/obj/item/weapon/tank/oxygen)

	oldcryopod
		name = "Emergency Cryo-pod"
		desc = "An out-dated cryo-pod, commonly used before the escape shuttle gained bluespace capabilities."
		icon = 'Cryogenic2.dmi'
		icon_state = "restruct_1"
		//Default event chance
		rand_reward_quant = 3

		setup_item()
			add_sequence_item(/obj/item/weapon/screwdriver, "You open up the control panel.")
			add_sequence_item(/obj/item/device/multitool, "You override the safeties.")
			add_sequence_item(/obj/item/weapon/screwdriver, "You close the control panel.")
			add_sequence_item("hand","You shut down the pod.")
			add_sequence_item(/obj/item/weapon/wrench, "You undo the internal bolts")
			add_sequence_item(/obj/item/weapon/screwdriver, "You loosen the internal equipment")
			add_sequence_item(/obj/item/weapon/crowbar,"You pry out the internal equipment.")
			add_fixedreward(/obj/item/weapon/sheet/metal/random)
			add_fixedreward(/obj/item/weapon/cable_coil)
			add_randomreward(/obj/item/weapon/reagent_containers/glass/beaker)
			add_randomreward(/obj/item/weapon/medical/bruise_pack)
			add_randomreward(/obj/item/weapon/medical/ointment)
			add_randomreward(/mob/living/carbon/monkey)
			add_randomreward(/obj/item/weapon/tank/oxygen)
			add_randomreward(/obj/item/constructionkit/component/control_board)
			add_randomreward(/obj/item/constructionkit/component/advanced_control_board)
			add_randomreward(/obj/item/constructionkit/component/relay_board)
			add_randomreward(/obj/item/constructionkit/component/variable_resistor)
			add_randomreward(/obj/item/constructionkit/component/transistor)
			add_randomreward(/obj/item/constructionkit/component/transistor)
			add_randomreward(/obj/item/constructionkit/component/capacitor)

		handle_event()
			var/random = rand(1,2)
			if(random == 1)
				visible_message("Without warning, the door opens and a partially rotted monkey corpse falls out.")
				var/mob/living/carbon/monkey/M = new(src.loc)
				M.death()
			else if(random == 2)
				visible_message("The [name] suddenly flashes to life with a burst of orange light. Blood and guts begin to ooze from inside.")
				new /obj/decal/cleanable/blood/gibs(src.loc)
			return 1

	oldnucleargen
		name = "Depreceated Nuclear Generator"
		desc = "An old class III nuclear generator, reknowned for their high fatality counts."
		icon = 'nuclear.dmi'
		icon_state = "reactor"
		event_chance = 10

		setup_item()
			add_sequence_item(/obj/item/weapon/screwdriver, "You loosen the maintenance cover.")
			add_sequence_item(/obj/item/weapon/crowbar, "You pry off the maintenance cover.")
			add_sequence_item(/obj/item/weapon/wirecutters, "You dismantle the inner wiring.")
			add_sequence_item("hand", "You trigger the emergency release switch.")
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut through the internal radiation shielding.")
			add_sequence_item(/obj/item/weapon/wrench, "You fully dismantle the core.")
			add_fixedreward(/obj/item/weapon/sheet/metal/random)
			add_fixedreward(/obj/item/weapon/cable_coil)
			add_fixedreward(/obj/item/weapon/nuclear/plutonium)
			add_fixedreward(/obj/item/constructionkit/component/control_board)
			add_randomreward(/obj/item/weapon/cell)

	thermalgenerator
		name = "Rusting Thermal Generator"
		desc = "An old class thermal generator with small internal SMES, creates power via heat."
		icon = 'power.dmi'
		icon_state = "teg"
		event_chance = 0

		setup_item()
			add_sequence_item(/obj/item/weapon/screwdriver, "You loosen the maintenance cover.")
			add_sequence_item(/obj/item/weapon/crowbar, "You pry off the maintenance cover.")
			add_sequence_item(/obj/item/weapon/wirecutters, "You cut free the power cells.")
			add_sequence_item(/obj/item/weapon/screwdriver, "You remove the primary power board.")
			add_sequence_item("hand", "You force the safeties to release.")
			add_sequence_item(/obj/item/weapon/weldingtool, "You weaken the outer frame.")
			add_sequence_item(/obj/item/weapon/crowbar, "You pry the frame apart.")
			add_fixedreward(/obj/item/weapon/sheet/metal/random)
			add_fixedreward(/obj/item/weapon/cable_coil)
			add_fixedreward(/obj/item/weapon/cell)
			add_fixedreward(/obj/item/weapon/cell)
			add_fixedreward(/obj/item/constructionkit/component/battery)
			add_fixedreward(/obj/item/constructionkit/component/diode)
			add_fixedreward(/obj/item/constructionkit/component/solder)
			add_fixedreward(/obj/item/constructionkit/component/variable_resistor)
			add_fixedreward(/obj/item/constructionkit/component/control_board)
			add_fixedreward(/obj/item/constructionkit/component/amplifier_circuit)
			add_randomreward(/obj/item/weapon/cell/medium)
			add_randomreward(/obj/item/weapon/cell/large)

	infiniteimprobabilitydrive
		name = "Prototype Infinite Improbability Drive"
		desc = "A rare, but powerful, propulsion drive capable of propelling ships massive distances by harnessing the power of infinitely unlikely quantum scenarios."
		icon = 'power.dmi' //Placeholder
		icon_state = "teg"
		event_chance = 5
		rand_reward_quant = 3

		setup_item()
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut through the outer casing.")
			add_sequence_item(/obj/item/weapon/crowbar, "You cut through the improbability shields.")
			add_sequence_item(/obj/item/weapon/screwdriver, "You remove the Bambelweeny 57 Sub-Meson Brain")
			add_sequence_item("hand", "You remove the Brownian Motion Suspension Fluid")
			add_sequence_item(/obj/item/weapon/wrench, "You dismantle the frame.")
			add_fixedreward(/obj/item/weapon/sheet/metal/random)
			add_fixedreward(/obj/item/weapon/cable_coil)
			add_fixedreward(/obj/item/constructionkit/component/amplifier_circuit)
			add_fixedreward(/obj/item/constructionkit/component/relay_board)
			add_fixedreward(/obj/item/constructionkit/component/thermocouple)
			add_fixedreward(/obj/item/constructionkit/component/mini_fusion_reactor)
			add_fixedreward(/obj/item/constructionkit/component/diode)
			add_fixedreward(/obj/item/constructionkit/component/diode)
			add_fixedreward(/obj/item/constructionkit/component/mini_fusion_reactor)
			add_randomreward(/obj/item/weapon/banana)
			add_randomreward(/obj/item/weapon/cell/large)
			add_randomreward(/obj/item/weapon/reagent_containers/food/drinks/milk)
			add_randomreward(/obj/item/weapon/reagent_containers/food/drinks/vodka)
			add_randomreward(/obj/item/weapon/reagent_containers/food/drinks/beer)
			add_randomreward(/obj/item/weapon/reagent_containers/food/drinks/cola)
			add_randomreward(/obj/item/weapon/reagent_containers/food/drinks/coffee)
			add_randomreward(/obj/item/clothing/head/cakehat)
			add_randomreward(/obj/item/clothing/head/helmet/hardhat)
			add_randomreward(/obj/item/clothing/head/wizard)
			add_randomreward(/obj/machinery/the_singularitygen)

		handle_event()
			var/random = rand(1,100)
			if(random <= 60)
				event()
				visible_message("A wave of improbability is released!")
			else
				visible_message("The drive misfires!")
				world << "<font color='blue'>A wave of improbability washes over the station!</font>"
				var/locations = list()
				for(var/mob/living/carbon/C in world)
					locations += C.loc
				for(var/mob/living/carbon/C in world)
					C.loc = pick(locations)

	derelictshipcannon
		name = "Ancient Anti-Ship Cannon"
		desc = "An anti-ship cannon from prior to the invention of laser technology. This one has fallen apart."
		event_chance = 10
		setup_item()
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut through the edges of the rusted barrel.")
			add_sequence_item(/obj/item/weapon/crowbar, "You pry out a barrel segment.")
			add_sequence_item("hand","You remove an antequated artillery shell.")
//			add_fixed_reward( //REWARD NEEDED

		handle_event()
			visible_message("The shell slips and hits the side. A faint ticking can be heard.")
			sleep(30)
			explosion(src.loc,0,1,3,5)


	triagetable
		name = "Derelict Surgery Table"
		desc = "An old medical table, complete with restraints and blood drains."
		event_chance = 0
		setup_item()
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut away the restraints.")
			add_sequence_item("hand","You search for any remaining supplies.")
			add_fixedreward(/obj/item/weapon/handcuffs)
			add_randomreward(/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline)
			add_randomreward(/obj/item/weapon/reagent_containers/glass/bottle/antitoxin)
			add_randomreward(/obj/item/weapon/reagent_containers/glass/bottle/stoxin)
			add_randomreward(/obj/item/weapon/reagent_containers/glass/bottle/toxin)
			add_randomreward(/obj/item/weapon/reagent_containers/syringe)
			add_randomreward(/obj/item/weapon/tank/anesthetic)

	cargopod
		name = "P-Class Pod"
		desc = "A heavy duty cargo containment pod, designed for transporting highly hazardous or classified materials or lifeforms."
		icon = 'storage.dmi'
		icon_state = "crate"
		event_chance = 10
		attack_hand(mob/user)
			if(state == 1)
				user << "The cargo pod is unpowered."
			else
				..()

		setup_item()
			add_sequence_item(/obj/item/weapon/screwdriver, "You open the control panel.")
			add_sequence_item(/obj/item/weapon/crowbar, "You pry open the battery compartment.")
			add_sequence_item(/obj/item/weapon/cell,"You insert a new cell.")
			add_sequence_item(/obj/item/weapon/crowbar, "You close the battery compartment.")
			add_sequence_item(/obj/item/device/multitool, "You override the safeties.")
			add_sequence_item(/obj/item/weapon/screwdriver, "You close the control panel cover,")
			add_sequence_item("hand","You activate the emergency bolt release.")
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut through the primary bolts.")
			add_sequence_item(/obj/item/weapon/wrench, "You detach the secure rods.")
			add_sequence_item(/obj/item/weapon/weldingtool, "You cut through the secondary bolts.")
			add_sequence_item(/obj/item/weapon/crowbar, "You pry open the container's doors.")
			add_fixedreward(/obj/item/weapon/crowbar)

		handle_state_change(obj/item/tool)
			if(state == 3)
				del tool
			if(state == 11) //Handle reward distribution here, so we can specify probabilities.
				var/probability = rand(1,100)
				if(probability < 10)
					for(var/i = 1;i <= 4;i++)
						new /obj/item/weapon/gun/energy/pulse_rifle(src.loc)
				else if(probability < 20)
					new /obj/item/weapon/gun/energy/teleport_gun(src.loc)
				else if(probability < 40)
					new /obj/item/weapon/storage/emp_kit(src.loc)
					for(var/i = 1;i <= 5; i++)
						new /obj/item/weapon/incendiarygrenade(src.loc)
				else if(probability < 70)
					var/possibilities = (typesof(/obj/constructionkit) - list(/obj/constructionkit,/obj/constructionkit/custom,/obj/constructionkit/generated)) - /obj/constructionkit/custom/example
					for(var/i=1;i <= rand(1,5);i++)
						var/path = pick(possibilities)
						new path(src.loc)
				else if(probability < 80)
					for(var/i=1;i <= rand(1,3);i++)
						new /obj/alien/facehugger(src.loc)
				else if(probability < 90)
					for(var/i=1;i <= 8;i++)
						var/mob/living/carbon/monkey/M = new()
						M.death()
						M.loc = src.loc
				else if(probability < 100)
					var/mob/A = new /mob/living/carbon/alien/humanoid(src.loc)
					var/list/observers = list()
					var/mob/dead/observer/chosen
					for(var/mob/dead/observer/O)
						observers += O
					if(!observers.len)
						return 0
					while(!chosen)
						chosen = pick(observers)
						if(!chosen.client)
							chosen = 0
					chosen.client.mob = A
					del chosen