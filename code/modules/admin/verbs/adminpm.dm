/client/proc/cmd_pm_client()
	set name = "Admin PM Player"
	set desc = "PMs a player/client in the world"
	set category = "Admin"

	if(!holder)
		alert(src, "Apologies, but only administrators can use this command!")
		return

	var/list/clients = list()
	for(var/client/P)
		clients += P
	var/client/C = input("Select a player","Admin PM") in clients
	cmd_admin_pm(C)


/client/proc/cmd_admin_pm(client/C)
	if(C)
		if(muted)
			src << "You are muted, have a nice day."
			return
		var/t = input("Message:", text("Private message to [C.key]"))  as text
		if(!(src.holder.level >= 5))
			t = strip_html(t,500)
		if (!( t ))
			return
		var/Mmsg
		var/Smsg
		if (src.holder)
			Mmsg = "\red Admin PM from-<b>[key_name(usr, C, 0)]</b>: [t]"
			Smsg = "\blue Admin PM to-<b>[key_name(C, usr, 1)]</b>: [t]"
		else
			if (C.holder)
				Mmsg = "\blue Reply PM from-<b>[key_name(usr, C, 1)]</b>: [t]"
			else
			//	Mmsg = "\red Reply PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
				world.log << "Incorrectly sent PM, [src.ckey], [C.ckey]"
			Smsg = "\blue Reply PM to-<b>[key_name(C, usr, 0)]</b>: [t]"

		C << Mmsg
		src << Smsg
		spawn(1)
			C << output(Mmsg, "adminhelp")
			src << output(Smsg, "adminhelp")

		log_admin("PM: [key_name(usr)]->[key_name(C)] : [t]")

		for(var/client/K)	//we don't use message_admins here because the sender/receiver might get it too
			var/Kmsg = "<B><font color='blue'>PM: [key_name(usr, K)]-&gt;[key_name(C, K)]:</B> \blue [t]</font>"
			if(K && K.holder && K.key != usr.key && K.key != C.key)
				K << Kmsg
				spawn(1)
					K << output(Kmsg, "adminhelp")