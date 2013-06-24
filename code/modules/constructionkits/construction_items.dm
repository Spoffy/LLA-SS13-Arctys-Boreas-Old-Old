obj/item/constructionkit/component
	name = "Base Component"
	icon = 'construction.dmi'
	icon_state = "Control_board"
	desc = "Base component for the construction system."
	throwforce = 0
	w_class = 2.0
	throw_speed = 2
	throw_range = 7
	flags = TABLEPASS
	item_state = "Control_board"


	capacitor
		name = "Miniature Capacitor"
		desc = "A small, charge holding component"
		icon_state = "Capacitor"
		item_state = "Capacitor"

	battery
		name = "Portable Battery"
		desc = "A small battery, much weaker than the cells used to power the station."
		icon_state = "Portable_battery"
		item_state = "Portable_battery"

	amplifier_circuit
		name = "Amplifier circuit"
		desc = "Used to boost the current of a circuit."
		icon_state = "Amplifier_circuit"
		item_state = "Amplifier_circuit"

	control_board
		name = "Programmable Control Board"
		desc = "Used as the main interface between the hardware and IC."
		icon_state = "Control_board"
		item_state = "Control_board"

	diode
		name = "Diode"
		desc = "Only allows the current in a circuit to flow one way."
		icon_state = "Diode"
		item_state = "Diode"

	advanced_control_board
		name = "Advanced Control Board"
		desc = "Used to interface advanced modules with the main control board."
		icon_state = "Adv_control_board"
		item_state = "Adv_control_board"

	relay_board
		name = "Relay board"
		desc = "A board of electronic switches."
		icon_state = "Relay_board"
		item_state = "Relay_board"

	transistor
		name = "Transistor"
		desc = "Current amplifying component, as well as an electronic switch."
		icon_state = "Transistor"
		item_state = "Transistor"

	solder
		name = "Solder wire"
		desc = "Metal with a low melting point used to join components."
		icon_state = "Solder"
		item_state = "Solder"

	thermocouple
		name = "Powered Thermocouple"
		desc = "Portable thermocouple with radiation source, used for long-term, low-power applications."
		icon_state = "Diode"
		item_state = "Diode"

	mini_fusion_reactor
		name = "Miniaturised Fusion Reactor"
		desc = "A small but imperfect fusion reactor. Capable of extending a power supply's lifetime tenfold."
		icon_state = "Diode"
		item_state = "Diode"

	variable_resistor
		name = "Variable Resistor Circuit"
		desc = "An advanced variable resistor, capable of automatically managing current."
		icon_state = "Diode"
		item_state = "Diode"