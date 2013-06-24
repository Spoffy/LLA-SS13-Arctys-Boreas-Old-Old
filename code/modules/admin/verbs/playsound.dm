/client/proc/play_sound()
	set category = "Fun"
	set name = "Play Global Sound"

	//if(Debug2)
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	var/sound/S = 0 //I don't like using null.
	//Selecting a pre-uploaded sound, or a new one.
	var/response = input("Select the sound you wish to play:","Play Global Sound") as null|anything in (flist("data/sound/") + "Upload New Sound" + "Delete Sound")
	if(!response)
		return 0
	if(response == "Upload New Sound")
		S = input("Select a sound to upload","Upload Sound") as sound|null
		if(S)
			var/name = input("Select a name for this sound (Include the extension)","Name","Sound [length(flist("data/sound/"))]") as text
			fcopy(S, "data/sound/[name]")
		return 0
	else if(response == "Delete Sound")
		var/todel = input("Select a sound to delete","Delete Sound") as null|anything in flist("data/sound/")
		fdel("data/sound/[todel]")
		return 0
	else
		S = file("data/sound/[response]")

	var/sound/uploaded_sound = sound(S,0,1,0)
	uploaded_sound.channel = 777
	uploaded_sound.priority = 254
	uploaded_sound.wait = 1

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)
	for(var/client/C)
		if(C.midis)
			C << uploaded_sound

// Commented out below and adjusted above so that admins get unlimited sounds. All code still intact.

/*	else
		if(usr.client.canplaysound)
			usr.client.canplaysound = 0
			log_admin("[key_name(src)] played sound [S]")
			message_admins("[key_name_admin(src)] played sound [S]", 1)
			for(var/mob/M in world)
				if(M.client)
					if(M.client.midis)
						M << uploaded_sound
		return */


/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(get_turf_loc(src.mob), S, 50, 0, 0)
	return