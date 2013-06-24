/client/New()
	if(findtextEx(src.key, "Telnet @"))
		src << "Sorry, this game does not support Telnet."
		del(src)
	var/isbanned = CheckBan(src)
	if (isbanned)
		log_access("Failed Login: [src] - Banned")
		message_admins("\blue Failed Login: [src] - Banned")
		alert(src,"You have been banned.\nReason : [isbanned]","Ban","Ok")
		del(src)


	if (((world.address == src.address || !(src.address)) && !(host)))
		host = src.key
		world.update_status()

	..()

	if (join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"

	src.update_world()

//new admin bit - Nannek

	if (admins.Find(src.ckey))
		src.holder = new /obj/admins(src, src)
		src.holder.rank = admins[src.ckey]
		update_admins(admins[src.ckey])

	if (ticker && ticker.mode && ticker.mode.name =="sandbox")
		CanBuild()
		if(src.holder  && (src.holder.level >= 2))
			src.verbs += /mob/proc/Delete

/client/Del()
	spawn(0)
		if(src.holder)
			del(src.holder)
	return ..()

/client/North()
	..()

/client/South()
	..()

/client/West()
	..()

/client/East()
	..()

/client/Northeast()
	if(istype(src.mob, /mob/living/carbon))
		src.mob:swap_hand()
	return

/client/Southeast()
	var/obj/item/weapon/W = src.mob.equipped()
	if (W)
		W.attack_self(src.mob)
	return

/client/Northwest()
	src.mob.drop_item_v()
	return

/client/Center()
	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (src.mob.canmove)
			return O.relaymove(src.mob, 16)
	return

/client/Move(n, direct)
	if(istype(src.mob, /mob/dead/observer))
		return src.mob.Move(n,direct)
	if (src.moving)
		return 0
	if (world.time < src.move_delay)
		return
	if (!( src.mob ))
		return
	if (src.mob.stat == 2)
		return
	if(istype(src.mob, /mob/living/silicon/ai))
		return AIMove(n,direct,src.mob)
	if (src.mob.monkeyizing)
		return

	var/is_monkey = istype(src.mob, /mob/living/carbon/monkey)
	if (locate(/obj/item/weapon/grab, locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
		var/list/grabbing = list(  )
		if (istype(src.mob.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.l_hand
			grabbing += G.affecting
		if (istype(src.mob.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/weapon/grab/G in src.mob.grabbed_by)
			if (G.state == 1)
				if (!( grabbing.Find(G.assailant) ))
					del(G)
			else
				if (G.state == 2)
					src.move_delay = world.time + 10
					if ((prob(25) && (!( is_monkey ) || prob(25))))
						mob.visible_message("\red [mob] has broken free of [G.assailant]'s grip!")
						del(G)
					else
						return
				else
					if (G.state == 3)
						src.move_delay = world.time + 10
						if ((prob(5) && !( is_monkey ) || prob(25)))
							mob.visible_message("\red [mob] has broken free of [G.assailant]'s headlock!")
							del(G)
						else
							return
	if (src.mob.canmove)

		if(src.mob.m_intent == "face")
			src.mob.dir = direct

		var/j_pack = 0
		if ((istype(src.mob.loc, /turf/space)))
			if (!( src.mob.restrained() ))
				if (!( (locate(/obj/grille) in oview(1, src.mob)) || (locate(/turf/simulated) in oview(1, src.mob)) || (locate(/obj/lattice) in oview(1, src.mob)) ))
					if (istype(src.mob.back, /obj/item/weapon/tank/jetpack))
						var/obj/item/weapon/tank/jetpack/J = src.mob.back
						j_pack = J.allow_thrust(0.01, src.mob)
						if(j_pack)
							src.mob.inertia_dir = 0
						if (!( j_pack ))
							return 0
					else
						return 0
			else
				return 0


		if (isturf(src.mob.loc))
			src.move_delay = world.time
			if ((j_pack && j_pack < 1))
				src.move_delay += 5
			switch(src.mob.m_intent)
				if("run")
					if (src.mob.drowsyness > 0)
						src.move_delay += 6
					src.move_delay += 1
				if("face")
					src.mob.dir = direct
					return
				if("walk")
					src.move_delay += 7


			src.move_delay += src.mob.movement_delay()

			if (src.mob.restrained())
				for(var/mob/M in range(src.mob, 1))
					if (((M.pulling == src.mob && (!( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
						src << "\blue You're restrained! You can't move!"
						return 0
			src.moving = 1
			if (locate(/obj/item/weapon/grab, src.mob))
				src.move_delay = max(src.move_delay, world.time + 7)
				var/list/L = src.mob.ret_grab()
				if (istype(L, /list))
					if (L.len == 2)
						L -= src.mob
						var/mob/M = L[1]
						if ((get_dist(src.mob, M) <= 1 || M.loc == src.mob.loc))
							var/turf/T = src.mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(src.mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(src.mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
					else
						for(var/mob/M in L)
							M.other_mobs = 1
							if (src.mob != M)
								M.animate_movement = 3
						for(var/mob/M in L)
							spawn( 0 )
								step(M, direct)
								return
							spawn( 1 )
								M.other_mobs = null
								M.animate_movement = 2
								return
			else
				if(src.mob.confused)
					step(src.mob, pick(cardinal))
				else
					. = ..()
			src.moving = null
			return .
		else
			if (isobj(src.mob.loc) || ismob(src.mob.loc))
				var/atom/O = src.mob.loc
				if (src.mob.canmove)
					return O.relaymove(src.mob, direct)
	else
		return
	return

#define TOPIC_SPAM_DELAY	7

/client/Topic(href, href_list, hsrc)
	//Reduces spamming of links by dropping calls that happen during the delay period
	if(next_allowed_topic_time > world.time)
//		src << "\red DEBUG: Error: SPAM"
		return
	next_allowed_topic_time = world.time + TOPIC_SPAM_DELAY

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_admins("Attempted use of scripts within a topic call, by [src]")
		del(usr)
		return

	if(href_list["priv_msg"])
		var/O = locate(href_list["priv_msg"])
		var/client/C
		if(isclient(O))
			C = O
		else if(ismob(O))
			C = O:client
		else return
		if(!C) return
		if(src.holder)
			src.cmd_admin_pm(C)
		return

	..()