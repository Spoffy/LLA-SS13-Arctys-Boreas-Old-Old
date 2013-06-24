/* 	Barber-system:

	It contains:
	sissors
	Razor blade
	Dye bottle
	Dye mixer
*/

// needed objects, defined here - code can be easily exported.
/obj/item/weapon/scissors
	name = "scissors"
	icon = 'barber.dmi'
	icon_state = "scissors"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 4.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	m_amt = 1000
	g_amt = 0

/obj/item/weapon/razor
	name = "razor blade"
	desc = "A razor blade. Keep it away from children."
	icon = 'barber.dmi'
	icon_state = "razor_closed"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 0.1
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	m_amt = 1000
	g_amt = 0
	var/active = 0
	var/sharp = 0

/obj/item/weapon/razor/active
	icon_state = "razor_open"
	force = 7.0
	throwforce = 7.0
	w_class = 4.0
	active = 1

/obj/item/weapon/razor/active/outsh
	icon_state = "razor_open"
	force = 9.0
	throwforce = 15.0
	w_class = 4.0
	active = 1
	sharp = 1

/obj/item/weapon/dye_h
	name = "dye bottle"
	icon = 'barber.dmi'
	icon_state = "dye_empty"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 0.1
	w_class = 3.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	m_amt = 1000
	g_amt = 0
	var/filled = 0
	var/r = 0.0
	var/g = 0.0
	var/b = 0.0

/* Simple hair-cut script  */

/obj/item/weapon/scissors/attack(mob/M as mob, mob/user as mob)
	if ((usr.mutations & 16) && prob(50)) // Clumsy? Cut yourself!
		src.add_fingerprint(user)
		usr << "\red You cut your finger!"
		user.bruteloss += 5
	if(user.zone_sel.selecting == "head")
		if(M.buckled)
			if(!istype(M, /mob))
				M << "\red You can only cut human hair with this scissors." // For idiots that try to cut a monkey.
				..()
				return
			else
				if(istype(M, /mob/living/carbon/human) && ((M:head && M:head.flags & HEADCOVERSEYES) || (M:wear_mask && M:wear_mask.flags & MASKCOVERSEYES) || (M:glasses && M:glasses.flags & GLASSESCOVERSEYES)))
					user << "\red You are going to need to remove that helmet/glasses/mask first!"
				else
					if(M:hair_icon_state == "bald") // Messed up once? Haha.
						user << "\red You can't find a single hair."
						src.add_fingerprint(user)
						return
					else
						if(M == user) user << "You start cutting your own hair."
						else
							user << "You start cutting [M]'s hair."
							M << "\red [user] starts cutting your hair!"
						var/hair_style = input(user, "Please select hair style", "Choose haircut")  as null|anything in list( "Cut Hair", "Short Hair", "Long Hair", "Mohawk", "Balding", "Fag", "Bedhead", "Dreadlocks", "Bald" )
						switch(hair_style)
							if("Short Hair")
								M:hair_icon_state = "hair_a"
							if("Long Hair")
								M:hair_icon_state = "hair_b"
							if("Cut Hair")
								M:hair_icon_state = "hair_c"
							if("Mohawk")
								M:hair_icon_state = "hair_d"
							if("Balding")
								M:hair_icon_state = "hair_e"
							if("Fag")
								M:hair_icon_state = "hair_f"
							if("Bedhead")
								M:hair_icon_state = "hair_bedhead"
							if("Dreadlocks")
								M:hair_icon_state = "hair_dreads"
							else
								M:hair_icon_state = "bald"
						sleep(150)
						if(M == user)
							if(prob(25))
								user << "\red You mess up!"
								M:hair_icon_state = "bald"
							else
								user << "\blue You successfuly cut your own hair."
						else
							user << "\red You cut [M]'s hair."
							M << "\red [user] cuts your hair!"
						src.add_fingerprint(user)
						M:update_face()
		else
			user << "\red Your client needs to be buckled."
			..()
			return
	else
		..()
		return

/* A simple shave-script */

/obj/item/weapon/razor/attack(mob/M as mob, mob/user as mob)
	if (active == 0) // You need to open the razor.
		M << "\red [user] stabs you with the closed razor blade!"
		user << "\red You stab [M] with the closed razor blade!"
		..()
	else
		if(user.zone_sel.selecting == "head")
			if(M.buckled)
				if(!istype(M, /mob))
					..()
					user << "\red You can only shave humans with this razor blade!"
					return
				else
					if(istype(M, /mob/living/carbon/human) && ((M:head && M:head.flags & HEADCOVERSEYES) || (M:wear_mask && M:wear_mask.flags & MASKCOVERSEYES) || (M:glasses && M:glasses.flags & GLASSESCOVERSEYES)))
						user << "\red You are going to need to remove that helmet/glasses/mask first!"
						return
					else
						if(M:face_icon_state == "bald")
							user << "\red You can't find a single hair."
							src.add_fingerprint(user)
							return
						else
							if (M == user) user << "You start shaving yourself."
							else
								M << "\red [user] starts shaving you!"
								user << "You start shaving [M]."
							var/chin_style = input(user, "Please select facial style", "Please choose a beard")  as null|anything in list("Watson", "Chaplin", "Selleck", "Full Beard", "Long Beard", "Neckbeard", "Van Dyke", "Elvis", "Abe", "Chinstrap", "Hipster", "Goatee", "Hogan", "Shaved")
							switch(chin_style) // What have you choosen, sir?
								if ("Watson")
									M:face_icon_state = "facial_watson"
								if ("Chaplin")
									M:face_icon_state = "facial_chaplin"
								if ("Selleck")
									M:face_icon_state = "facial_selleck"
								if ("Neckbeard")
									M:face_icon_state = "facial_neckbeard"
								if ("Full Beard")
									M:face_icon_state = "facial_fullbeard"
								if ("Long Beard")
									M:face_icon_state = "facial_longbeard"
								if ("Van Dyke")
									M:face_icon_state = "facial_vandyke"
								if ("Elvis")
									M:face_icon_state = "facial_elvis"
								if ("Abe")
									M:face_icon_state = "facial_abe"
								if ("Chinstrap")
									M:face_icon_state = "facial_chin"
								if ("Hipster")
									M:face_icon_state = "facial_hip"
								if ("Goatee")
									M:face_icon_state = "facial_gt"
								if ("Hogan")
									M:face_icon_state = "facial_hogan"
								else
									M:face_icon_state = "bald"
							sleep(150)
							if(M == user)
								if(prob(25))
									user << "\red You mess up!"
									M:face_icon_state = "bald"
								else
									user << "\blue You successfuly shave yourself."
							else
								user << "\blue You shave [M].."
								M << "\red [user] shaves you!"
							src.add_fingerprint(user)
							M:update_face() // Update your face.
			else
				..()
				user << "\red Your client needs to be buckled."
		else
			..()
			return


/* You can open and close the razor */

/obj/item/weapon/razor/attack_self(mob/user as mob)
	if(!active)
		active = 1
		icon_state = "razor_open"
		user << "You open the razor blade."
		if(sharp)
			force = 9.0
			throwforce = 25.0
		if(!sharp)
			force = 7.0
			throwforce = 7.0
		w_class = 4.0
		src.add_fingerprint(user)
		if ((usr.mutations & 16) && prob(50)) // Being clumsy is NEVER good
			user << "\red You accidentaly stab your eyes with the razor blade."
			user.bruteloss += 25
			user.sdisabilities |= 1
			user.weakened += 4
	else
		active = 0
		icon_state = "razor_closed"
		user << "You close the razor blade."
		force = 0.1
		throwforce = 1.0
		w_class = 1.0
		src.add_fingerprint(user)

/* Simple hair dye bottle */

/obj/item/weapon/dye_h/attack(mob/M as mob, mob/user as mob)
	if(!filled)
		user << "\red The dye bottle is empty!"
		..()
		return
	if(istype(M, /mob/living/carbon/human) && ((M:head && M:head.flags & HEADCOVERSEYES) || (M:wear_mask && M:wear_mask.flags & MASKCOVERSEYES) || (M:glasses && M:glasses.flags & GLASSESCOVERSEYES)))
		user << "\red You are going to need to remove that helmet/glasses/mask first!"
		return
	else
		if(user.zone_sel.selecting == "head")
			M:r_hair = src.r
			M:g_hair = src.g // Transfer the rgb values to the subject's head.
			M:b_hair = src.b
			if(M == user)
				user << "\blue You successfully dye your own hair."
			else
				user << "\blue You successfully dye [M]'s hair."
				M << "\red [user] dyes you hair!"
			M:update_face()
			src.add_fingerprint(user)
			src.filled = 0 // Now empty the bottle...
			icon_state = "dye_empty"
			src.r = 0.0
			src.g = 0.0 // ...and remove the colors in it.
			src.b = 0.0
		else if(user.zone_sel.selecting == "mouth")
			M:r_facial = src.r
			M:g_facial = src.g // Transfer the rgb values to the subject's head.
			M:b_facial = src.b
			if(M == user)
				user << "\blue You successfully dye your own facial hair."
			else
				user << "\blue You successfully dye [M]'s facial hair."
				M << "\red [user] dyes your facial hair!"
			M:update_face()
			src.add_fingerprint(user)
			src.filled = 0 // Now empty the bottle...
			icon_state = "dye_empty"
			src.r = 0.0
			src.g = 0.0 // ...and remove the colors in it.
			src.b = 0.0
		else
			user << "\red You don't know where to apply the dye!"
			..()
			return

/* If you examine the dye bottle tell if its filled and what is in it! */

/obj/item/weapon/dye_h/examine()
	if(filled)
		set src in view(1)
		if(usr && !usr.stat)
			usr << "It seems to be filled. The mixture looks like [r] red, [g] green, [b] blue!"
	else
		set src in view(1)
		if(usr && !usr.stat)
			usr << "It doesn't seems to be filled."

/* Hair dye mixer */

/obj/machinery/dye_mixer/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/dye_h))
		src.add_fingerprint(user)
		user << "You hold the bottle into the dispenser."
		var/dye_color = input(user, "Please select hair color.", "Dye selection") as color
		if(dye_color)
			O:r = hex2num(copytext(dye_color, 2, 4))
			O:g = hex2num(copytext(dye_color, 4, 6))
			O:b = hex2num(copytext(dye_color, 6, 8))
		user << "The dispenser starts dispensing the dye!"
		sleep(100)
		O:filled = 1
		O:icon_state = "dye_full"
		user << "\blue The dipenser stops dispensing."
	else
		user << "\red The dispenser can only hold a dye bottle!"
		return