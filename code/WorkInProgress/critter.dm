/*
	Critters!
	I probably won't finish them.
*/

// don't treat critters as mobs, just make them a object.
/obj/critter
	name = "critter"
	desc = "A admin spawnable monster." // only the basic object, seriously don't try to spawn this.
	icon = 'critter.dmi'
	icon_state = "default"
	density = 1

	// variables for critters.
	var/
		hp = 0 // critters dont need damage zones or anything. simple health.
		alive = 1 // when you're dead i'll be still alive..
		melee = 0 // critter can perform a melee attack?
		range = 0 // critter can perfrom ranged attacks?
		damagem = 0 // damage the critter deals in melee combat
		damager = 0 // damage the critter deals in ranged combat
		peaceful = 0 // will the critter attack without being provoked?
		deadicon = "" // icon for the dead critter goes here
		attacker = "" // shitty non-performant work around
		state = 0 // wat.
		nmelee = "" // name of melee attack
		nrange = "" // name of ranged attack
		petspeak = 0 // will it speak when you pet it?
		petspeaktxt = "" // text it speaks when you pet it
		mob/living/carbon/target
		list/path_target = new/list()
		turf/trg_idle
		list/path_idle = new/list()

	New()
		src.process() // it's alive, oh god!

// critters defined
/obj/critter/testythingy
	name = "test critter"
	density = 0
	hp = 10
	melee = 1
	range = 1
	damagem = 15
	damager = 5
	nmelee = "punch"
	nrange = "spit"

/obj/critter/testythingypeace
	name = "test critter"
	peaceful = 1
	density = 0
	hp = 10
	melee = 1
	range = 1
	damagem = 15
	damager = 5
	nmelee = "punch"
	nrange = "spit"

// procs
/obj/critter/proc/
	live()
		return

	die()
		src:density = 0
		src:hp = 0
		src:icon_state = src:deadicon
		src:alive = 0
		for (var/mob/C in viewers(src))
			C.show_message("\red The [src] dies!")

obj/critter/proc/get_attack(var/attacksname, var/tgt)
	switch(attacksname)
		if("punch")
			punch(tgt)
		if("spit")
			spit(tgt)

// attacks
/obj/critter/proc/
	punch(mob/target as mob)
		for(var/mob/C in viewers(src))
			C.show_message("\red The [src] punches [target]!")
		target.bruteloss += damagem

	spit(mob/target as mob)
		for(var/mob/C in viewers(src))
			C.show_message("\red The [src] spits at [target]!")
		target.bruteloss += damager

/obj/critter/attack_hand(mob/user as mob)
	if(user.a_intent == "help")
		for (var/mob/C in viewers(src))
			C.show_message("\blue [user] pets the [src].")
			if(petspeak)
				C.show_message(petspeaktxt)
	else
		for (var/mob/C in viewers(src))
			C.show_message("\red [user] attacks the [src]!")
		attacker = user.real_name
		for(var/mob/living/carbon/C in viewers(src))
			if(C.real_name == attacker) target = C
		hp -= 1 // punching only does very little damage
		..()

/obj/critter/attack_ai(mob/user as mob)
	return

/obj/critter/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	src:hp = src:hp - O:force
	if(src:hp <= 0) src.die()

/obj/critter/bullet_act(flag, A as obj)
	if (flag == PROJECTILE_BULLET)
		hp = hp - 20
	else if (flag == PROJECTILE_WEAKBULLET)
		hp = hp - 4
	else if (flag == PROJECTILE_LASER)
		hp = hp - 10
	if(hp <= 0) src.die()

// copy pasta from facehuggers here
/obj/critter/

	proc/set_attack()
		state = 1
		if(path_idle.len) path_idle = new/list()
		trg_idle = null

	proc/set_idle()
		state = 2
		if (path_target.len) path_target = new/list()
		target = null

	proc/set_null()
		state = 0
		if (path_target.len) path_target = new/list()
		if (path_idle.len) path_idle = new/list()
		target = null
		trg_idle = null

	proc/process()
		set background = 1
		var/quick_move = 0

		if (!alive)
			return

		if (!target)
			if (path_target.len) path_target = new/list()

			var/last_health = INFINITY

			for (var/mob/living/carbon/C in range(viewrange-2,src.loc))
				if(!peaceful)
					if (C.stat == 2 || !can_see(src,C,viewrange))
						continue
					if(C:stunned || C:paralysis || C:weakened)
						target = C
						break
					if(C:health < last_health)
						last_health = C:health
						target = C

			if(target)
				set_attack()
			else if(state != 2)
				set_idle()
				idle()

		else if(target)
			var/turf/distance = get_dist(src, target)
			set_attack()

			if(can_see(src,target,viewrange))
				if(distance <= 1)
					get_attack(nmelee, target)
				else if(distance <= 5)
					get_attack(nrange, target)

				step_towards(src,get_step_towards2(src , target))
			else
				if( !path_target.len )

					path_attack(target)
					if(!path_target.len)
						set_null()
						spawn(cycle_pause) src.process()
						return
				else
					var/turf/next = path_target[1]

					if(next in range(1,src))
						path_attack(target)
					else
						next = path_target[1]
						path_target -= next
						step_towards(src,next)
						quick_move = 1

		if(quick_move)
			spawn(cycle_pause/2)
				src.process()
		else
			spawn(cycle_pause)
				src.process()

	proc/idle()
		set background = 1
		var/quick_move = 0

		if(state != 2 || !alive || target) return
		else

			if(can_see(src,trg_idle,viewrange))
				switch(get_dist(src, trg_idle))
					if(2 to INFINITY)
						step_towards(src,get_step_towards2(src , trg_idle))
						if(path_idle.len) path_idle = new/list()
			else
				var/turf/next = path_idle[1]
				if(!next in range(1,src))
					path_idle(trg_idle)

				if(!path_idle.len)
					spawn(cycle_pause) src.idle()
					return
				else
					next = path_idle[1]
					path_idle -= next
					step_towards(src,next)
					quick_move = 1

		if(quick_move)
			spawn(cycle_pause/2)
				idle()
		else
			spawn(cycle_pause)
				idle()

	proc/path_idle(var/atom/trg)
		path_idle = AStar(src.loc, get_turf(trg), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, null, null)
		path_idle = reverselist(path_idle)

	proc/path_attack(var/atom/trg)
		target = trg
		path_target = AStar(src.loc, target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, null, null)
		path_target = reverselist(path_target)

	proc/healthcheck()
		if (src.hp <= 0)
			src.die()