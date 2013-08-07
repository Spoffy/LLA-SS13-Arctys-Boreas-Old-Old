/*
Quick explanation of how this works:
Two types of kit, custom kits and generated kits.
> Custom kits are kits in which every stage of construction and every component needed is defined.
> Generated kits are generated from their name. These are added in initialize.dm. They are stored as kit data datums until they are spawned.
Initialize is called to add all the generated kits. Just add the kit desired in here.

Kits have a list of required parts and a sequence. The sequence is a list of things that need to be done to the kit to make it spawn, eg, using a screwdriver on it.

Parts and Sequences are stored as datums.
 */

// Datum used to stored info about stages of construction.
datum/constructionkit/sequence
	var/tool = null
	var/message = null

	New(toolArg,messageArg)
		..()
		tool = toolArg
		message = messageArg
		if(!tool)
			del src
			return 0

	proc/get_tool()
		return tool

	proc/get_message()
		return message

//*****************************************************
//Datum used to store info on a required part.
datum/constructionkit/required_part
	var/name = null
	var/path = null

	New(nameArg,pathArg)
		..()
		name = nameArg
		path = pathArg
		if(!name || !path)
			del src
			return 0

	proc/get_name()
		return name

	proc/get_path()
		return path

//*****************************************************
// The base construction kit itself
obj/constructionkit
	name = "A Construction Kit"
	desc = "The base construction kit. Should not be spawned."
	icon = 'storage.dmi'
	icon_state = "crate"

	var/itemname = "Base" // Used to generate the name, among other things.
	var/itempath = /obj/constructionkit //Constructionkitception. The item path of the item being made.
	var/list/required_parts = list() // List of components needed.
	var/list/sequence = list() // Sequence to be followed for construction.
	var/state = 0 //How far we are in the construction process. 0 means it is still waiting for more parts.
	var/finishstate = 1


	New() //Do nothing, as this shouldn't be instantiated.
		..()


	proc/part_needed(path) //Identifies is an object is required by the kit.
		for(var/i = 1;i <= length(required_parts);i++)
			var/datum/constructionkit/required_part/required_part = required_parts[i]
			if(ispath(path,required_part.get_path()))
				return i
		return 0

	attack_hand(mob/user)
		return attackby("hand",user)

	attackby(obj/W, mob/user)
		if(state == 0)
			var/required = part_needed(W.type) //Gets the index of the part, if it's needed, else returns 0
			if(required) //If needed
				visible_message("The [W.name] is added to the kit.")
				required_parts.Cut(required,required+1) //Remove the part from the list now.
				if(("amount" in W.vars) && W:amount > 1) //Handle metals, etc.
					W:amount -= 1
				else
					del W
				if(!length(required_parts)) //If we've got all our parts, time to build!
					state = 1
				generate_desc()
		else if(state != 0)
			if(W != "hand")
				W = W.type
			var/datum/constructionkit/sequence/S = sequence[state]
			if(S && S.get_tool() == W )
				if(S.get_message())
					visible_message(S.get_message())
				else
					visible_message("The kit is advanced by the [W.name]")
				state++
				generate_desc()

		if(state == finishstate)
			complete_build()




	proc/complete_build()
		sleep(50)
		visible_message("The kit beeps as the item is created.")
		new itempath(src.loc)
		del src

	proc/add_required_part(name,path)
		var/datum/constructionkit/required_part/P = new/datum/constructionkit/required_part(name,path)
		if(!P)
			return 0
		required_parts += P

	proc/add_sequence(tool,message)
		var/datum/constructionkit/sequence/S = new /datum/constructionkit/sequence(tool,message)
		if(!S)
			return 0
		sequence += S

	proc/generate_desc()
		if(state == 0)
			desc = "A construction kit. It still requires "
			for(var/datum/constructionkit/required_part/P in required_parts)
				desc += "[P.get_name()], "
			desc = copytext(desc,1,length(desc)-1)
			desc += "."
		else if(state)
			desc = "A construction kit. It is on stage [state] of construction."
		else
			desc = "A construction kit."


obj/constructionkit/custom

	New()
		..()
		setup()
		if(!length(required_parts) || !itemname || !itempath)
			del src
			return 0
		finishstate = length(sequence)+1

		name = "[itemname] Construction Kit"
		generate_desc()

	proc/setup()
		world << "Error: [type] has base setup proc! Report this to a coder!"
		return 0


obj/constructionkit/generated
	New(location, iname,ipath,list/parts,list/seq)
		..()
		if(!iname || !ipath || !length(parts))
			del src
			return 0
		itemname = iname
		itempath = ipath
		required_parts = parts
		sequence = seq

		finishstate = length(sequence)+1

		name = "[itemname] Construction Kit"
		generate_desc()

//*******************************************************************
//Datum in which the basic data is stored for generated items.
datum/constructionkit/kit_data
	var/name
	var/path
	var/difficulty

	var/list/components = list()
	var/list/stored_sequence = list()

	New(nname,npath,ndifficulty)
		name = nname
		path = npath
		difficulty = ndifficulty
		if(!name || !path || !difficulty)
			del src

		generate_components()
		generate_sequence()

	proc
		set_name(newName)
			name = newName

		get_name()
			return name

		set_path(newPath)
			path = newPath

		get_path()
			return path

		set_difficulty(newDifficulty)
			difficulty = newDifficulty

		get_difficulty()
			return difficulty

		get_components()
			return components

		add_sequence(tool,message)
			stored_sequence += new /datum/constructionkit/sequence(tool,message)

		get_sequence()
			return stored_sequence

		//This is a fair bit inefficient due to the item spawning, but it should only be called once per game, so it isn't too major.
		generate_components()
			var/list/component_chart = (typesof(/obj/item/constructionkit/component) - /obj/item/constructionkit/component) //Generate the list of components

			var/text_pos = 0
			for(var/i = 1; i <= difficulty; i++) //For each level of difficulty, add a new component
				text_pos = (text_pos > length(name)? 1 : text_pos + 1) //Cycle through the letters of the name to seed the components.

				var/ascii = text2ascii(copytext(name,text_pos,text_pos + 1)) //Convert the letter to ascii number.
				ascii = (ascii % length(component_chart))+1 //Perform an integer wrap.

				var/temp_path = component_chart[ascii]
				var/obj/temp = new temp_path() //Create a new component to we can get its name.
				components += new /datum/constructionkit/required_part(temp.name,temp.type) //Add a component to the list.
				del temp //Remove the temp object.

		generate_sequence()
			add_sequence("hand","The kit's primary power is activated.")
			add_sequence(/obj/item/weapon/wirecutters,"The kit's configuration wires are connected.")
			add_sequence(/obj/item/weapon/screwdriver,"The kit's molecular clamp is adjusted to the datum point.")
			add_sequence("hand","The kit's control panel is shut.")
			add_sequence("hand","The kit is activated and begins to construct the item.")



		create_new(loc)
			if(!loc)
				return 0
			return new /obj/constructionkit/generated(loc,name,path,components,stored_sequence)


//***********************************************
//Kit management global. Yes, globals suck, but I'm not writing a singleton solely for access, given it guarantees nothing.

var/list/construction_kit_data = list()

proc/add_construction_kit(name,itempath,difficulty)
	 construction_kit_data += new /datum/constructionkit/kit_data(name,itempath,difficulty)

/*
mob/verb/test_con_kits()
	set name = "Test construction kits"

	init_construction_kits()
	world << "Length: [length(construction_kit_data)]"
	for(var/datum/constructionkit/kit_data/D in construction_kit_data)
		world << D
		if(D.create_new(src.loc))
			world << "DNEW WORKING"
*/