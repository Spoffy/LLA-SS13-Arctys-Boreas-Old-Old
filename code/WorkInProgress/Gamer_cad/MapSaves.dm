#define MAPSAVE_VERSION 1
#define MAX_X_REGEN 15
#define MAX_Y_REGEN 15
datum/Map_Regenerator/proc/GenerateMapSave()
	world << "\blue Saving map. Some lag may occur."
	var/start_time = world.timeofday
	var/last_turf_type
	var/counter = 0
	if(fexists("data/MapSave.sav"))
		fdel("data/MapSave.sav")
	var/savefile/output = new /savefile("data/MapSave.sav")
	output.cd = "/"
	output["VERSION"] << MAPSAVE_VERSION
	for(var/Y = 1, Y <= world.maxy, Y++)
		for(var/X = 1, X <= world.maxx, X++)
			var/turf/active_turf = locate(X,Y,1)
			if(!active_turf)
				continue
			for(var/obj/window/W in active_turf)
				if(istype(W, /obj/window/reinforced))
					output["/obj/window/reinforced/[X]/[Y]/[W.dir]"] << 1
				else
					output["/obj/window/[X]/[Y]/[W.dir]"] << 1
			if(!last_turf_type)
				last_turf_type = active_turf.type
				output["[counter]"] << active_turf.type
				counter++
				continue
			if(last_turf_type == active_turf.type)
				counter++
				continue
			if(last_turf_type != active_turf.type)
				counter++
				output["[counter]"] << active_turf.type
				last_turf_type = active_turf.type
				continue
	var/time_taken = (world.timeofday-start_time)/10
	world << "\blue Save complete."
	message_admins("Save completed in [time_taken] seconds!")

datum/Map_Regenerator/proc/LoadMapSave(x as num,y as num,x2 as num,y2 as num)
	var/savefile/save = new /savefile("data/MapSave.sav") // Load the save
	save.cd = "/" // Set the save's CD
	if(!save["VERSION"]) // Identifies whether the map has been saved using version numbers/
		message_admins("No map save found! Cannot load.") //Might need updating when taken out of testing.
		return
	var/minx = min(x,x2) //These 4 procs calcuate the rectangle's boundries.
	var/maxx = max(x,x2)
	var/miny = min(y,y2)
	var/maxy = max(y,y2)
	var/start_iteration = CoordToIter(min(x,x2),min(y,y2)) //The lowest iteration of a turf
	var/finish_iteration = CoordToIter(max(x,x2),max(y,y2)) //The highest iteration of a turf.
	var/list/filtered[] = list() //Filter down the turfs so that only those between x1,y1 and x2,y2 are shown.
	var/list/real_start = list() //The start point is the last turf change BEFORE the starting turf. Find them for each y value.
	for(var/I in save.dir)
		var/num = text2num(I)
		if(num <= finish_iteration && num > start_iteration)
			save[I] >> filtered[I]
			continue
		if(num > real_start && num <= start_iteration)
			real_start = num
			continue
	save[num2text(real_start)] >> filtered[num2text(real_start)] //Loads in the first starting turf.

	//Now we need to find the starting turfs for each Y value, as they may lie outside the box we defined.
	//First, make a list of all the maximum starting iterations for each turf.
	var/list/ltb = list() //ltb = lower turf bounds. Quicker to type.
	for(var/start_y = miny, start_y <= maxy, start_y++)
		ltb += CoordToIter(minx,start_y)
	//Now we can compare them, and add them to their own list.
	var/yrange = (y2 - y)+1
	var/list/rltb[] = new /list(yrange) //rltb = real lower turf bounds.
	for(var/yIt = 1, yIt <= yrange, yIt++) //Populating the list with starting values.
		rltb[yIt] = 0
	//Now we can populate the real turf bounds. We can also trim the excess turf changes in this loop
	//to cut down on processing time later.
	var/list/toremove[] = list() //Sadly, this is necessary as we can't edit a list when we're looping through it. =(
	for(var/I in filtered)
		var/num = text2num(I)
		for(var/test_val = 1, test_val <= yrange, test_val++)
			if(num <= ltb[test_val] && num > rltb[test_val])
				rltb[test_val] = num
		var/list/coords[] = IterToCoord(num)
		if(coords[1] < minx || coords[1] > maxx)
			toremove += I
	//Alter the turf data so it ALL lies within the boundries.
	for(var/B = 1, B<=length(ltb),B++)
		filtered[num2text(ltb[B])] = filtered[num2text(rltb[B])]
	//Removes data for all iterations outside the boundries. We don't need it at this point.
	for(var/R in toremove)
		filtered -= R
	//Filtered is now populated with all the appropriate turf changes. That now needs interpreting into something we can use.
	for(var/I in filtered)
		var/list/coords[] = IterToCoord(text2num(I))
		var/type = filtered[I]
		var/turf/T = new type(locate(coords[1],coords[2],1))
		T.name = "UPDATEPOINT"
	var/active_type
	for(var/iy = miny, iy<= maxy, iy++)
		for(var/ix = minx, ix <= maxx, ix++)
			var/turf/T = locate(ix,iy,1)
			if(T.name == "UPDATEPOINT")
				active_type = T.type
				T.name = initial(T.name)
			else if(active_type)
				T = new active_type(T)
			for(var/atom/A in view(sd_top_luminosity, T))
				if(A.luminosity)
					var/Lum = (A.luminosity-get_dist(A,T))
					if(Lum < 0) continue
					T.sd_lumcount += Lum
					T.sd_LumUpdate()
			save.cd = "/obj/window/reinforced/[ix]/[iy]"
//			world << "CD: [save.cd]"
//			world << "Len: [length(save.dir)]"
			if(length(save.dir) != 0)
				for(var/d in save.dir)
//					world << "Direction: [d]"
					var/obj/window/reinforced/W = new(T)
					W.dir = text2num(d)
			save.cd = "/obj/window/[ix]/[iy]"
//			world << "CD: [save.cd]"
//			world << "Len: [length(save.dir)]"
			if(length(save.dir != 0))
				for(var/d in save.dir)
//					world << "Direction: [d]"
					var/obj/window/W = new(T)
					W.dir = text2num(d)
//	world << "Load (term used loosely) complete in [(world.timeofday - start)/10] seconds!"


proc/CoordToIter(x,y)
	return (((y-1)*world.maxx)+x)

proc/IterToCoord(iter)
	var/list/coords[] = new /list(2)
	coords[2] = round((iter-1)/world.maxx)+1
	coords[1] = iter - ((coords[2]-1)*world.maxx)
	return coords

/*client/verb/ItoC(x as num)
	var/list/L = IterToCoord(x)
	world << "X: [L[1]]"
	world << "Y: [L[2]]"*/

client/proc/Repair_Map()
	set name = "Repair Map"
	set category = "Admin"
	var/x = input("Lower Left Corner X Coordinate", "X Coord 1") as num
	var/y = input("Lower Left Corner Y Coordinate", "Y Coord 1") as num
	var/x2 = input("Top Right Corner X Coordinate", "X Coord 2") as num
	var/y2 = input("Top Right Corner Y Coordinate", "Y Coord 2") as num
	if(((max(x,x2)-min(x,x2)) > MAX_X_REGEN) || ((max(y,y2)-min(y,y2)) > MAX_Y_REGEN))
		usr << "The area to repair cannot exceed [MAX_X_REGEN] by [MAX_Y_REGEN] tiles!"
		return
	var/abort = input("Do you wish to continue with the map repair? This may cause some lag.","Continue?") in list("Yes","No")
	if(abort == "No") return
	var/datum/Map_Regenerator/Regen = new()
	var/regen_begin_time = world.timeofday
	world << "\blue Beginning map repair, some lag may occur."
	Regen.LoadMapSave(x,y,x2,y2)
	del Regen
	world << "\blue Repair complete."
	message_admins("Map Regeneration complete in [(world.timeofday-regen_begin_time)/10] seconds!")

client/proc/Save_Map()
	set name = "Generate Map Save"
	set category = "Debug"
	set desc = "Creates a map save for use with the map repair tool."
	var/datum/Map_Regenerator/Regen = new()
	Regen.GenerateMapSave()
