var/CMinutes = null
var/savefile/Banlist

/proc/GetKeyString(var/index) //Get a string representing all the banned player's keys.
	var/string = "No key found"

	Banlist.cd = "/base/[index]/keys"
	string = "Keys: "
	for(var/key in Banlist.dir)
		string += "[key] "
	return string

/proc/GetCidString(var/index) //Get a string representing all the banned player's cids.
	var/string = "No CIDs found"

	Banlist.cd = "/base/[index]/cids"
	string = "CIDs: "
	for(var/cid in Banlist.dir)
		string += "[cid] "
	return string

/proc/GetIpString(var/index) //Get a string representing all the banned player's ips
	var/string = "No IPs found"

	Banlist.cd = "/base/[index]/ips"
	string = "IPs: "
	for(var/ip in Banlist.dir)
		string += "[ip] "
	return string

/proc/UpdateBanDetails(var/index, var/client/clientvar, var/key, var/id, var/ip)

	if(clientvar) //Give the option of using a client OR the raw values
		id = clientvar.computer_id
		key = clientvar.ckey
		ip = clientvar.address

	var/added = 0

	Banlist.cd = "/base/[index]/keys"
	if(!Banlist.dir.Find("[key]"))
		Banlist.dir.Add("[key]")
		added++
	Banlist.cd = "/base/[index]/cids"
	if(!Banlist.dir.Find("[id]"))
		Banlist.dir.Add("[id]")
		added++
	Banlist.cd = "/base/[index]/ips"
	if(!Banlist.dir.Find("[ip]"))
		Banlist.dir.Add("[ip]")
		added++

	if(added >= 3)
		world.log << "Error: Added 3 details at [index]. Check for impossibility."

	return added


/proc/CheckBan(var/client/clientvar)

	var/banned = RawCheckBan(clientvar) //Check for an index.

	if(!banned)
		return 0

	Banlist.cd = "/base/[banned]" //Move the player's index.
	if(Banlist["minutes"] > 0) //-1 is a perma, above 0 is a temp. 0 is obviously no ban/error.
		if(!GetExp(Banlist["minutes"])) //If expired
			RemoveBan(banned) //Remove the ban and return 0.
			return 0
		else
			UpdateBanDetails(banned, clientvar) //If banned, updated their known details.
			Banlist.cd = "/base/[banned]"
			return "[Banlist["reason"]]\n(This ban will be automatically removed in [GetExp(Banlist["minutes"])].)" //Return reason
	else if (Banlist["minutes"] < 0) //Perma
		UpdateBanDetails(banned, clientvar) //If permabanned, update their known details
		Banlist.cd = "/base/[banned]"
		return "[Banlist["reason"]]\n(This is a permanent ban)" //Return reason
	else if(Banlist["minutes"] == 0) //This shouldn't occur. But what if it does?
		RemoveBan(banned) //Remove the ban
		var/bannedkeys = GetKeyString(banned) //Log the error.
		world.log << "Error Invalid Ban, [bannedkeys] "
		message_admins("Error Invalid Ban, [bannedkeys]")
		return 0

	return 0

proc/RawCheckBan(client/client, key, cid, ip) //Simply outputs the index if a ban is found.
	if(client) //Give the option of using the client, or the raw details.
		key = client.ckey
		cid = client.computer_id
		ip = client.address
	var/banned = 0

	Banlist.cd = "/base" //Base directory
	for(var/index in Banlist.dir) //Go to a specific index, each representing a player
		Banlist.cd = "/base/" + index + "/keys" //Go to that player's keys.
		if(Banlist.dir.Find("[key]")) //Search for the key.
			banned = index
			break;
		Banlist.cd = "/base/" + index + "/cids" // No key. Search for the CID!
		if(Banlist.dir.Find("[cid]"))
			banned = index
			break;
		Banlist.cd = "/base/" + index + "/ips"
		if(Banlist.dir.Find("[ip]"))
			banned = index
			break;

	Banlist.cd = "/base"
	return banned





	/*
	if (Banlist.dir.Find("[key][id]"))
		Banlist.cd = "[key][id]"
		if (Banlist["temp"])
			if (!GetExp(Banlist["minutes"]))
				ClearTempbans()
				return 0
			else
				return "[Banlist["reason"]]\n(This ban will be automatically removed in [GetExp(Banlist["minutes"])].)"
		else
			Banlist.cd = "/base/[key][id]"
			return "[Banlist["reason"]]\n(This is a permanent ban)"

	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		Banlist.cd = "/base/[A]"
		if (id == Banlist["id"] || key == Banlist["key"])
			if(Banlist["temp"])
				if (!GetExp(Banlist["minutes"]))
					ClearTempbans()
					return 0
				else
					return "[Banlist["reason"]]\n(This ban will be automatically removed in [GetExp(Banlist["minutes"])].)"
			else
				return "[Banlist["reason"]]\n(This is a permanent ban)"

*/

	return 0


/proc/UpdateTime() //No idea why i made this a proc.
	CMinutes = (world.realtime / 10) / 60
	return 1

//GOT TO HERE

/proc/LoadBans()

	Banlist = new("data/banlist.bdb")
	log_admin("Loading Banlist")

	if (!length(Banlist.dir)) log_admin("Banlist is empty.")

	if (!Banlist.dir.Find("base"))
		log_admin("Banlist missing base dir.")
		Banlist.dir.Add("base")
		Banlist.cd = "/base"
	else if (Banlist.dir.Find("base"))
		Banlist.cd = "/base"

	ClearTempbans()
	return 1

/proc/ClearTempbans()
	UpdateTime()

	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		Banlist.cd = "/base/[A]"
		if (CMinutes >= Banlist["minutes"] || Banlist["minutes"] == 0) RemoveBan(A)

	return 1


/proc/AddBan(ckey, computerid, ip, reason, bannedby, minutes)

	if(!ckey && !computerid && !ip)
		return 0

	var/bantimestamp = 0

	if (minutes > 0)
		UpdateTime()
		bantimestamp = CMinutes + minutes
	else
		bantimestamp = minutes

	Banlist.cd = "/base"
	var/banned = RawCheckBan(0,ckey,computerid,ip)
	if (banned) //Check for an existing ban
		UpdateBanDetails(banned, 0, ckey, computerid, ip)
		usr << text("\red Ban already exists.")
		return 0
	else
		Banlist.cd = "/base"
		var/max_index_loc = length(Banlist.dir) //The last index in the list WILL be the largest.
		var/max_index = Banlist.dir[max_index_loc] //Retrieve the highest index
		max_index = text2num(max_index) + 1  // Convert it to a number and increment it for the new ban.

		Banlist.dir.Add("[max_index]")
		Banlist.cd = "/base/[max_index]" //Go to the new ban we created.

		if(ckey)
			Banlist.dir.Add("keys") //Add a list of keys.
			Banlist.cd = "keys"
			Banlist.dir.Add("[ckey]") //Add the ckey to the ban

			Banlist.cd = "/base/[max_index]" //Back up we go!

		if(computerid)
			Banlist.dir.Add("cids") //Add a list of cids
			Banlist.cd = "cids"
			Banlist.dir.Add("[computerid]") //Add the cid to the ban

			Banlist.cd = "/base/[max_index]" //Back again.

		if(ip)
			Banlist.dir.Add("ips") //Add a list of ips
			Banlist.cd = "ips"
			Banlist.dir.Add("[ip]") //Add the ip to ban

			Banlist.cd = "/base/[max_index]" //Back we go again. Last time.

		Banlist["reason"] << reason //Store the reason for the ban
		Banlist["bannedby"] << bannedby //Store the banner
		Banlist["minutes"] << bantimestamp //Store the ban time

	return 1 //YAY. WE'RE DONE.

/proc/RemoveBan(foldername)

	Banlist.cd = "/base"
	var/key = GetKeyString(foldername)

	if (!Banlist.dir.Remove(foldername)) return 0

	if(!usr)
		log_admin("Ban Expired: [key]")
		message_admins("Ban Expired: [key]")
	else
		log_admin("[key_name_admin(usr)] unbanned [key]")
		message_admins("[key_name_admin(usr)] unbanned: [key]")

	return 1

/proc/GetExp(minutes as num)
	UpdateTime()
	var/exp = minutes - CMinutes
	if (exp <= 0)
		return 0
	else
		var/timeleftstring
		if (exp >= 1440) //1440 = 1 day in minutes
			timeleftstring = "[round(exp / 1440, 0.1)] Days"
		else if (exp >= 60) //60 = 1 hour in minutes
			timeleftstring = "[round(exp / 60, 0.1)] Hours"
		else
			timeleftstring = "[exp] Minutes"
		return timeleftstring

//////////////////////////////////// DEBUG ////////////////////////////////////

/proc/CreateBans()

	UpdateTime()

	var/i

	for(i=0, i<100, i++)
		var/minutes = pick(-1, 0, 100)
		AddBan("Test Ckey", "0101011101(Fake)", "192.100.100.100(Fake)","Test reason","A coder",minutes)

	Banlist.cd = "/base"

/proc/ClearAllBans()
	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		RemoveBan(A)

