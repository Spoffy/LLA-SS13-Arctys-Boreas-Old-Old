/obj/structure/tramline
	name = "Tram Rail"
	desc = "A rail that trams run along"
	density = 0
	opacity = 0
	anchored = 1
	icon = 'tram.dmi'
	icon_state = "track"
	dir = 4
	var/current_dir = 4 //Used to identify a change in direction
	var/max_connections = 2 //Max connections a single rail can have
	var/list/connections[] = list() //All the connections.
	var/list/conn_dirs[]

	New()
		..()
		current_dir = dir
		for(var/obj/structure/tramline/T in loc) //If it finds one, abort!
			if(T != src)
				del src
				return 0

	proc/connection_dirs(dir as num) //Returns the directions it should be connecting in as an array. Used argument for flexibility. Less optimal, I know.
		var/list/return_vals[2]
		switch(dir)
			if(1,2)
				return_vals[1] = 1
				return_vals[2] = 2
			if(4,8)
				return_vals[1] = 4
				return_vals[2] = 8
			if(5)
				return_vals[1] = 8
				return_vals[2] = 2
			if(6)
				return_vals[1] = 1
				return_vals[2] = 8
			if(9)
				return_vals[1] = 4
				return_vals[2] = 2
			if(10)
				return_vals[1] = 1
				return_vals[2] = 4
			if(0)
				dir = 4
				return_vals[1] = 4
				return_vals[2] = 8

		return return_vals

	proc/handle_dir(obj/tram/tram,obj/structure/tramline/target)
		if((dir & 3) && dir > 4)//If the direction is a diagonal
			var/dirtonext = get_dir(src,target)
			for(var/direction in conn_dirs)
				if(direction == tram.dir)
					if(direction == dirtonext)
						return tram.dir
					else
						return reverseNESW(dirtonext)
				else if(direction == reverseNESW(tram.dir))
					if(direction == dirtonext)
						return reverseNESW(direction)
					else
						return dirtonext


		return tram.dir


	proc/connect() //Connect to adjacent rails
		conn_dirs = connection_dirs(dir) //Identify where to look
		for(var/direction in conn_dirs)
			var/location = get_step(src,direction) //Get the turfs to check
			for(var/obj/structure/tramline/T in location)//Loop through tramlines in those turfs.
				if(T.add_connection(src)) //If we successfully add a connection to that line, add one to us!
					connections += T
		return 1 //Success!

	proc/disconnect()
		for(var/obj/structure/tramline/T in connections) //For everything in connections...
			if(T.remove_connection(src)) //If we successfully remove the connection from the other one, remove it from ours!
				connections -= T
		if(length(connections))
			return 0

		return 1

	proc/add_connection(obj/structure/tramline/connection)
		if(length(connections) == max_connections)
			return 0
		if(!(get_dir(src,connection) in connection_dirs(dir)))
			return 0
		connections += connection
		return 1

	proc/remove_connection(obj/structure/tramline/connection)
		connections.Remove(connection)
		return 1

	proc/next_rail(obj/structure/tramline/last)
		if(dir != current_dir)
			if(disconnect())
				connect()
			else
				return 0
		for(var/i = 1,i < 3, i++)
			for(var/obj/structure/tramline/T in connections)
				if(last != T)
					return T
			if(disconnect())
				connect()
		return 0

	New()
		..()
		connect()

	Del()
		if(!disconnect())
			return 0
		..()
	proc/check_tram_entry(obj/tram/T) //Called to check if a tram can enter the track. Returns 1 by default.
		return 1

	proc/after_tram_entry(obj/tram/T) //Called after movement has completed. Returns 1 by default.
		return 1

/obj/structure/tramline/brake
	name = "Tram Brake"
	desc = "Stops trams in their tracks."

	after_tram_entry(obj/tram/T)
		if(istype(T,/obj/tram/powered))
			T.moving = 0
			return 1
		..()

/obj/structure/tramline/points //Tad confusing. The subtypes represent different types of points. the 'dir' value of the points represent the direction they're currently working in.
	dir = 1
	max_connections = 3
	var/list/point_dirs[3] //List of directions which the points can work between.
	var/active_dir = 1

	New()
		..()
		if(!point_dirs[active_dir])
			del src
			return 0
		update_icon_state()

	handle_dir(obj/tram/tram,obj/structure/tramline/target,obj/structure/tramline/lasttrack)
		var/direction = get_dir(src,target) //This is the direction we'll be heading in if we're going forward.
		var/dircheck = get_dir(lasttrack,tram) // GGet the direction to the tram from the last track it was on.
		if(tram.dir == dircheck) //But is the tram going forwards or backwards? If it's facing the same way as it's travelling, forwards!
			return direction
		else //Else it's going backwards.
			return reverseNESW(direction)

	next_rail(obj/structure/tramline/last)
		for(var/obj/structure/tramline/T in connections)
			if(T != last && get_dir(src,T) & point_dirs[active_dir])
				return T
		if(disconnect())
			connect()
		return 0

	check_tram_entry(obj/tram/T) //Called to see if we can enter the points.
		if(!(get_dir(src,T) & point_dirs[active_dir]))
			return 0
		return 1

	attack_hand(mob/user)
		cycle_points()
		return 1

	proc/update_icon_state()
		icon_state = "NEW[point_dirs[active_dir]]"
		return 1

	proc/cycle_points()
		active_dir++
		if(active_dir > length(point_dirs))
			active_dir = 1
		update_icon_state()

	NEW
		point_dirs = list(12,5,9) //E->W,N->E,W->N, that order.
		//Redefine the connection_dirs proc
		connection_dirs(dir)
			return list(4,8,1)
		//Child specific updates
		update_icon_state()
			icon_state = "NEW[point_dirs[active_dir]]"
			return 1

	SEW
		point_dirs = list(12,6,10)
		//Redefine the connection_dirs proc
		connection_dirs(dir)
			return list(4,8,2)
		//Child specific updates
		update_icon_state()
			icon_state = "SEW[point_dirs[active_dir]]"
			return 1
	ENS
		point_dirs = list(3,5,6)
		//Redefine the connection_dirs proc
		connection_dirs(dir)
			return list(1,2,4)
		//Child specific updates
		update_icon_state()
			icon_state = "ENS[point_dirs[active_dir]]"
			return 1
	WNS
		point_dirs = list(3,9,10)
		//Redefine the connection_dirs proc
		connection_dirs(dir)
			return list(1,2,8)
		//Child specific updates
		update_icon_state()
			icon_state = "WNS[point_dirs[active_dir]]"
			return 1


/obj/tram
	name = "Tram"
	desc = "A rail-mounted vehicle designed to move personnel and goods around."
	density = 1
	opacity = 0
	icon = 'tram.dmi'
	icon_state = "tram_empty"
	anchored = 1
	var/moving = 0
	var/movement_delay = 2 //Control that speed!
	var/obj/structure/tramline/last_track
	var/obj/structure/tramline/current_track
	var/obj/structure/tramline/next_track
	var/list/connected_trams = list()

	New()
		..()
		for(var/obj/structure/tramline/T in loc) //Need to align it with the tracks, else some weird bugs occur with movement keys.
			dir = T.dir
			break
		regenerate_icon()

	proc/set_mov_dir(direction)
		for(var/obj/structure/tramline/T in loc) //CHeck to see if we're on a track, if not, quit.
			current_track = T;
			break
		if(!current_track)
			return 0
		for(var/obj/structure/tramline/T in current_track.connections)
			if(get_dir(src, T) == direction)
				next_track = T
				if(dir == direction)
					moving = 1
				else
					moving = -1
				return 1
		return 0


	proc/follow_track()
		while(next_track && moving) //While we have somewhere to move and are moving.
			//Handles the directions
			var/olddir = dir //The original direction.
			var/newdir = current_track.handle_dir(src,next_track,last_track)
			if(!next_track.check_tram_entry(src))
				moving = 0
				break
			//Performs the movements
			if(!Move(next_track.loc,newdir)) //Attempt to move. If we can't, stop the tram!
				moving = 0
				break
			for(var/obj/tram/T in connected_trams)
				if(!T.pull_tram(src,current_track,moving))
					loc = current_track.loc
					moving = 0
					return 0
			//Increments the track
			last_track = current_track //Advance to the next tracks in sequence.
			current_track = next_track
			next_track = current_track.next_rail(last_track)
			//Regenerates the icon
			if(dir != olddir) //If our direction has changed as a result, recreate our icon.
				regenerate_icon()
			current_track.after_tram_entry(src)


			sleep(movement_delay) //Delay till the next movement.

		moving = 0
		regenerate_icon()
		return 1

	Bump()
		moving = 0

	proc/regenerate_icon()
		return 1

	proc/pull_tram(var/obj/tram/puller, var/obj/structure/tramline/target)
		if(!current_track)
			for(var/obj/structure/tramline/T in loc) //CHeck to see if we're on a track, if not, quit.
				current_track = T;
				break
		if(!current_track)
			return 0
		var/olddir = dir
		var/newdir = current_track.handle_dir(src,target)
		if(!Move(target.loc,newdir))
			return 0
		for(var/obj/tram/T in connected_trams)
			if(T == puller) continue
			if(!T.pull_tram(src,current_track))
				loc = current_track.loc
				return 0
		current_track = target
		if(dir != olddir)
			regenerate_icon()
		current_track.after_tram_entry(src)
		return 1

	verb/connect_trams()
		set src in view(1)
		set name = "Connect Trams"
		if(length(connected_trams) >= 2)
			visible_message("The tram is already fully connected!")
			return 0
		if(!current_track)
			for(var/obj/structure/tramline/T in loc) //CHeck to see if we're on a track, if not, quit.
				current_track = T;
				break
		var/connected_dirs = 0
		for(var/obj/tram/tram in connected_trams)
			connected_dirs |= get_dir(src, tram)
		for(var/obj/structure/tramline/T in current_track.connections)
			if(connected_dirs & get_dir(src,T))
				continue
			for(var/obj/tram/tram in T.loc) //THIS WILL CONNECT TWO TRAMS IN ONE DIRECTION AND WILL NEED REWRITING
				if(length(connected_trams) <= 2 && length(tram.connected_trams) <= 2 && !(src in tram.connected_trams))
					connected_trams += tram
					tram.connected_trams += src
					break

	verb/disconnect_tram()
		set src in view(1)
		set name = "Disconnect Tram"
		var/dir_list = list()
		for(var/obj/tram/T in connected_trams)
			var/dirtotram = get_dir(src,T)
			switch(dirtotram)
				if(1) dirtotram = "North";
				if(2) dirtotram = "South";
				if(4) dirtotram = "East";
				if(8) dirtotram = "West";
				else dirtotram = "Unknown Direction";
			dir_list[dirtotram] = T
		var/choice = input("Select the tram to detach","Detach Tram") as null|anything in dir_list;
		if(!choice)
			return 0
		var/obj/tram/chosen = dir_list[choice]
		chosen.connected_trams.Remove(src)
		src.connected_trams.Remove(chosen)
		return 1


/obj/tram/powered
	name = "Tram Car"
	desc = "A rail-mounted vehicle designed to move personnel and goods around."
	density = 1
	opacity = 0
	icon = 'tram.dmi'
	icon_state = "tram_empty"
	anchored = 1
	moving = 0
	movement_delay = 2 //Control that speed!

	verb/enter()
		set name = "Enter Tram"
		set desc = "Get into the tram."
		set category = "IC"
		set src in view(1)

		usr.loc = src
		usr.client.eye = src
		usr.client.perspective = EYE_PERSPECTIVE
		regenerate_icon()

	verb/exit()
		set name = "Exit Tram"
		set desc = "Exit the tram"
		set category = "IC"
		set src in range(0)

		usr.loc = src.loc
		if(usr.client)
			usr.client.eye = usr
			usr.client.perspective = MOB_PERSPECTIVE
		regenerate_icon()

	regenerate_icon() //Weird way of doing it, but everything else failed due to weird layering.
		var/mob/living/carbon/human/driver
		for(var/mob/living/carbon/human/H in src) //Identify who's driving. Possibly simplify?
			driver = H
			break
		overlays = list() //We're rebuilding the icon. Need to purge the old overlays.
		if(driver) //If we have a driver, get a new image and overlay it. Make sure it layers correctly, they can be a bit dodgy. Human overlay's (E.g clothes) cause it to always appear on layer 20.
			var/image/driver_image = image(driver,dir=dir) //Need a new image with the correct direction.
			if(dir == 1 || dir == 2) //If north or south, underlay. Else, overlay. It's the way the icons are done.
				layer = 4.5
				overlays += driver_image
			else
				layer = 3
				overlays += driver_image

		return 1 //Yay, we rebuilt the icon! Trams for all!

	relaymove(mob/user, direction)
		if(moving && next_track && direction == get_dir(src,next_track)) //If moving and direction is the one we're travelling in, do nothing.
			return 1
		if(moving && last_track && direction == get_dir(src, last_track)) //If moving and direction is opposite to the one we're travelling in, stop moving.
			moving = 0
			return 1
		if(!set_mov_dir(direction)) //Check to see if we can start moving, as well as assign the track 'sequence'.
			exit() //If returned 0, then the direction wasn't appropriate, and the tram should be exited.
			user.Move(get_step(src,direction),direction)
			return 0
		follow_track()

obj/tram/passenger
	name = "Passenger car"
	icon_state = "passenger"

	verb/enter()
		set name = "Enter Tram"
		set desc = "Get into the tram."
		set category = "IC"
		set src in view(1)

		usr.loc = src
		usr.client.eye = src
		usr.client.perspective = EYE_PERSPECTIVE
		regenerate_icon()

	verb/exit()
		set name = "Exit Tram"
		set desc = "Exit the tram"
		set category = "IC"
		set src in view(0)

		usr.loc = src.loc
		if(usr.client)
			usr.client.eye = usr
			usr.client.perspective = MOB_PERSPECTIVE
		regenerate_icon()

	regenerate_icon() //Weird way of doing it, but everything else failed due to weird layering.
		var/mob/living/carbon/human/driver
		for(var/mob/living/carbon/human/H in src) //Identify who's driving. Possibly simplify?
			driver = H
			break
		overlays = list() //We're rebuilding the icon. Need to purge the old overlays.
		if(driver) //If we have a driver, get a new image and overlay it. Make sure it layers correctly, they can be a bit dodgy. Human overlay's (E.g clothes) cause it to always appear on layer 20.
			var/image/driver_image = image(driver,dir=dir) //Need a new image with the correct direction.
			if(dir == 1 || dir == 2) //If north or south, underlay. Else, overlay. It's the way the icons are done.
				layer = 4.5
				overlays += driver_image
			else
				layer = 3
				overlays += driver_image

		return 1 //Yay, we rebuilt the icon! Trams for all!


obj/tram/freight
	name = "Cargo car"
	icon_state = "freight_crate0"
	var/list/crates[3]
	var/crates_loaded = 0
	var/max_crates = 3

	MouseDrop_T(var/atom/movable/C, mob/user)
		if(istype(C,/obj/crate) && get_dist(src,C) <= 1)
			if(crates_loaded >= max_crates) //Better safe than sorry.
				visible_message("[user] attempts to load a crate onto the tram, but it's already full!")
				return 1
			C.loc = src
			crates_loaded++
			crates[crates_loaded] = C
			icon_state = "freight_crate[crates_loaded]"
			visible_message("[user] loads a crate onto the tram!")

			return 1
		..()

	attack_hand(mob/user as mob)
		if(crates_loaded > 0 && get_dist(src,user) <= 1)
			var/obj/crate/C = crates[crates_loaded]
			C.loc = user.loc
			crates[crates_loaded] = null
			crates_loaded--
			icon_state = "freight_crate[crates_loaded]"
			visible_message("[user] unloads a crate from the tram")

			return 1
		..()







//DEBUG
/*
/obj/follower
	name = "Tracksky"
	desc = "Follows tracks!"
	opacity = 0
	density = 1
	icon = 'aibots.dmi'
	icon_state = "helmet_signaler"

	proc/follow_tracks() //Confusing stuff. Just follow it through. Tl;DR, it keeps 3 tracks in memory. It moves to the next track, cycles all the track back a step, then picks a new next track.
		var/obj/structure/tramline/last_track
		var/obj/structure/tramline/current_track
		var/obj/structure/tramline/next_track
		for(var/obj/structure/tramline/T in loc)
			current_track = T
		if(!current_track)
			return
		world << "WE GOT THIS FAR BROS"
		next_track = pick(current_track.connections)
		while(next_track)
			Move(next_track.loc)
			last_track = current_track
			current_track = next_track
			sleep(5)
			next_track = current_track.next_rail(last_track)

	New()
		..()
		follow_tracks()


*/
