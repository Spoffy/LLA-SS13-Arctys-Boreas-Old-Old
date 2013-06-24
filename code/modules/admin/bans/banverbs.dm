/client/proc/ban_player()
	set name = "Ban Player"
	set category = "Admin"
	set desc = "Ban a player"
	var/list/clients = list()
	for(var/client/C)
		clients += C
	var/client/target = input("Select the player","Ban") as null | anything in clients
	if(!target)
		return 0
	if ((target.holder && (target.holder.level >= src.holder.level)))
		alert("You cannot perform this action. You must be of a higher administrative rank!")
		return
	switch(alert("Temporary Ban?",,"Yes","No"))
		if("Yes")
			var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num
			if(!mins)
				return
			if(mins >= 525600) mins = 525599
			UpdateTime() //Gonna convert to days/mins/hours using an existing proc.
			var/confirm = alert("This is a [GetExp(CMinutes + mins)] ban. Are you sure?","Ban","Yes","No")
			if(confirm == "No")
				return 0
			var/reason = input(usr,"Reason?","reason","Griefer") as text
			if(!reason)
				return
			AddBan(target.ckey, target.computer_id, target.address, reason, usr.ckey, mins)
			target << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
			target << "\red This is a temporary ban, it will be removed in [mins] minutes."
			target << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
			log_admin("[usr.client.ckey] has banned [target.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			message_admins("\blue[usr.client.ckey] has banned [target.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")

			var/mob/Tmob = target.mob
			del(target)
			del(Tmob)
		if("No")
			var/reason = input(usr,"Reason?","reason","Griefer") as text
			if(!reason)
				return
			var/confirm = alert("This is a permanent ban. Are you sure?","Ban","Yes","No")
			if(confirm == "No")
				return 0
			AddBan(target.ckey, target.computer_id, target.address, reason, usr.ckey, -1)
			target << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
			target << "\red This is a permanent ban."
			target << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
			log_admin("[usr.client.ckey] has banned [target.ckey].\nReason: [reason]\nThis is a permanent ban.")
			message_admins("\blue[usr.client.ckey] has banned [target.ckey].\nReason: [reason]\nThis is a permanent ban.")

			var/mob/Tmob = target.mob
			del(target)
			del(Tmob)

/obj/admins/proc/unbanpanel()
	var/count = 0
	var/dat
	//var/dat = "<HR><B>Unban Player:</B> \blue(U) = Unban , (E) = Edit Ban\green (Total<HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >"
	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		count++
		Banlist.cd = "/base/[A]"
		var/key = GetKeyString(A)
		var/cid = GetCidString(A)
		var/ip = GetIpString(A)
		Banlist.cd = "/base/[A]"
		var/time = "Error: No time found!"
		if(Banlist["minutes"] > 0)
			time = GetExp(Banlist["minutes"])
			if(!time)
				time = "Pending Removal"
		else if(Banlist["minutes"] < 0)
			time = "Permanent"

		dat += "<tr><td>[key]</td><td>Index: [A]</td><td>[cid]</td><td>[ip]</td><td>Banned By: [Banlist["bannedby"]]</td><td>Reason: [Banlist["reason"]]</td><td>[time]</td></tr>"

	dat += "</table>"
	dat = "<HR><B>Bans:</B> <FONT COLOR=blue>(U) = Unban , (E) = Edit Ban</FONT> - <FONT COLOR=green>([count] Bans)</FONT><HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >[dat]"
	usr << browse(dat, "window=unbanp;size=875x400")