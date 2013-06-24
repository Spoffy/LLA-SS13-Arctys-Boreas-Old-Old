obj/constructionkit/custom
	example
		itemname = "Example Machine"
		itempath = /obj/item/weapon/storage/bible

		setup()
			add_required_part("Crowbar",/obj/item/weapon/crowbar)
			add_required_part("Screwdriver",/obj/item/weapon/screwdriver)
			add_sequence(/obj/item/weapon/wirecutters,"You wire the bible to the crowbar.") //Both args are required
			add_sequence(/obj/item/weapon/wrench,"You beat yourself with a wrench.")

	cryo_cell
		itemname = "Cryo Cell"
		itempath = /obj/machinery/atmospherics/unary/cryo_cell

		setup()
			add_required_part("Glass",/obj/item/weapon/sheet/glass)
			add_required_part("Wires",/obj/item/weapon/cable_coil)
			add_required_part("Metal",/obj/item/weapon/sheet/metal)
			add_required_part("Control Board",/obj/item/constructionkit/component/control_board)
			add_required_part("Advanced Control Board",/obj/item/constructionkit/component/advanced_control_board)
			add_required_part("Relay Board",/obj/item/constructionkit/component/relay_board)
			add_required_part("Variable Resistor",/obj/item/constructionkit/component/variable_resistor)
			add_required_part("Transistor",/obj/item/constructionkit/component/transistor)
			add_required_part("Transistor",/obj/item/constructionkit/component/transistor)
			add_required_part("Capacitor",/obj/item/constructionkit/component/capacitor)
			add_sequence(/obj/item/weapon/screwdriver,"The control boards are screwed in place.")
			add_sequence(/obj/item/weapon/crowbar,"The maintenance hatch is closed.")
			add_sequence(/obj/item/weapon/wrench,"The outer frame is bolted together.")
			add_sequence(/obj/item/weapon/weldingtool, "The outer frame is welded in place.")
			add_sequence("hand", "The glass is inserted in place.")

