/obj/item/organ/external
	name = "external"
	var/vis_name = null
	var/icon_name = null
	var/brute_state = 0		// > Brute state
	var/burn_state 	= 0		// > Burn State
	var/brute_dam 	= 0		// > Brute damage
	var/burn_dam	= 0		// > Burn damage

	New()
		..()

		if(vis_name == null)
			vis_name = name

	proc/take_damage(brute, burn) // Damages the organ for the specified amounts
		brute	= max(0, brute)
		burn	= max(0, burn)

		var/inflict = max_damage - (brute_dam + burn_dam)
		if(!inflict)
			return 0

		if((brute + burn) < inflict)
			brute_dam += brute
			burn_dam += burn
		else
			if(brute > 0)
				if(burn > 0)
					brute 	= round((brute / (brute + burn)) * inflict, 1)
					burn	= inflict - brute

					brute_dam 	+= brute
					burn_dam 	+= burn
				else
					brute_dam	+= inflict
			else
				if(burn > 0)
					burn_dam	+= inflict
				else
					return 0

		damage = brute_dam + burn_dam
		return update_icon()


	proc/heal_damage(brute, burn) // Heals the organ for the specified amounts.
		brute	= max(0, brute)
		burn	= max(0, burn)
		brute_dam	= max(brute_dam - brute, 0)
		burn_dam	= max(burn_dam - burn, 0)

		return update_icon()

	proc/update_icon()
		var/tbrute	= round((brute_dam / max_damage) * 3, 1)
		var/tburn	= round((burn_dam / max_damage) * 3, 1)

		if(tbrute != brute_state || tburn != burn_state)
			brute_state = tbrute
			burn_state = tburn
			return 1

		return 0

/obj/item/organ/external/chest
		name = "chest"
		icon_name = "chest"
		max_damage = 150
		removable = 0

/obj/item/organ/external/groin
		name = "groin"
		icon_name = "groin"
		max_damage = 115

/obj/item/organ/external/head
		name = "head"
		icon_name = "head"
		max_damage = 125

/obj/item/organ/external/l_arm
		name = "l arm"
		vis_name = "left arm"
		icon_name = "l_arm"
		max_damage = 75

/obj/item/organ/external/l_hand
		name = "l hand"
		vis_name = "left hand"
		icon_name = "l_hand"
		max_damage = 40

/obj/item/organ/external/l_leg
		name = "l leg"
		vis_name = "left left"
		icon_name = "l_leg"
		max_damage = 75

/obj/item/organ/external/l_foot
		name = "l foot"
		vis_name = "left foot"
		icon_name = "l_foot"
		max_damage = 40

/obj/item/organ/external/r_arm
		name = "r arm"
		vis_name = "right arm"
		icon_name = "r_arm"
		max_damage = 75

/obj/item/organ/external/r_hand
		name = "r hand"
		vis_name = "right hand"
		icon_name = "r_hand"
		max_damage = 40

/obj/item/organ/external/r_leg
		name = "r leg"
		vis_name = "right leg"
		icon_name = "r_leg"
		max_damage = 75

/obj/item/organ/external/r_foot
		name = "r foot"
		vis_name = "right foot"
		icon_name = "r_foot"
		max_damage = 40

/obj/item/organ/external/eyes
		name = "eyes"
		icon_name = "eyes"
		max_damage = 60
		var/r = 0
		var/g = 0
		var/b = 0

