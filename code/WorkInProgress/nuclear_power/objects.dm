// Definitions
/obj/item/weapon/nuclear/plutonium
	name = "Plutonium rod"
	desc = "A rod of highly radioactive plutonium."
	icon = 'nuclear.dmi'
	icon_state = "plutonium"
	var/initial_fuel = 500
	var/average_emission = 3 //Neutrons emitted.

	var/fuel_remaining = 0

	New()
		..()
		fuel_remaining = initial_fuel

	proc/use_fuel(fuel)
		fuel_remaining = max((fuel_remaining - fuel),0)

	//Number of neutrons currently being emitted.
	proc/emission_rate()
		return (fuel_remaining * average_emission)

/obj/item/weapon/nuclear/control_rod
	name = "Control rod"
	desc = "A silver-indium-cadmium control rod for absorbing neutrons in a fission reactor. 0% Decayed."
	icon = 'nuclear.dmi'
	icon_state = "plutonium"

	var/decay = 0
	var/absorbs = 3000 //How many neutrons absorbed. Should be ~Twice the emission rate

	proc/decay(amount)
		decay = min(decay+amount,100)
		desc = "A silver-indium-cadmium control rod for absorbing neutrons in a fission reactor. [decay]% Decayed."

	proc/absorption_rate()
		return (absorbs * (decay/100))

/obj/item/weapon/nuclear/plutonium/safe
	name = "Plutonium Tube"
	desc = "A lead-lined tube to safely contain Plutonium. Suitable for use in a reactor."
	icon = 'nuclear.dmi'
	icon_state = "leadcase"