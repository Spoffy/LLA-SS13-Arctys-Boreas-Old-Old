/client/verb/listen_ooc()
	set name = "(Un)Mute OOC"
	set category = "OOC"

	src.listen_ooc = !src.listen_ooc
	if (listen_ooc)
		src << "\blue You are now listening to messages on the OOC channel."
	else
		src << "\blue You are no longer listening to messages on the OOC channel."

/mob/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"
	if (IsGuestKey(src.key))
		src << "You are not authorized to communicate over these channels."
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	else if (!src.client.listen_ooc)
		return
	else if (!ooc_allowed && !src.client.holder)
		return
/*	else if (!dooc_allowed && !src.client.holder && (src.client.deadchat != 0))
		usr << "OOC for dead mobs has been turned off."
		return */
	else if (src.client && (src.client.muted /*|| src.client.muted_complete*/))
		src << "You are muted."
		return
	else if (findtext(msg, "byond://") && !src.client.holder)
		src << "<B>Advertising other servers is not allowed.</B>"
		log_admin("[key_name(src)] has attempted to advertise in OOC.")
		message_admins("[key_name_admin(src)] has attempted to advertise in OOC.")
		return

	log_ooc("[src.name]/[src.key] : [msg]")

	var/message = "This should not be seen."
	var/player_message = "This should not be seen."
	if(src.client.holder && src.client.holder.rank == "Admin Observer") //If AO, then
		message = "<span class='adminobserverooc'>"
/*	else if(((client.holder && client.holder.level >= 5) || client.vip) && client.ooccolor) //If OOC Colour then. Gotta make a holder/VIP check, as someone stored OOC colours for normal players -.-
		message = "<font color=[src.client.ooccolor]><b>" */
	else if(src.client.holder) //If just a holder, then.
		message = "<span class='adminooc'>"
	else //If no holder and no special colour, normal player
		message = "<span class='ooc'>"

/*	for(var/image/I in client.badges) //Add badges to the message!
		message += "\icon [I]"*/

	message += "<b><span class='prefix'>OOC: </span>[(src.client.stealth)? ("[src.key]/([src.client.fakekey])"):(src.key)]: <span class='message'>[msg]</span>" //Setup the message. Doesn't matter that fakeID is being added, as stealthed admins give out a totally different message.

/*	if(src.client.ooccolor) //End it properly.
		message += "</b></font>"
	else
		message += "</span>" */

	message += "</span>" //Remove this when above is uncommented.

	if(src.client.stealth)
		player_message = "<span class='ooc'><span class='prefix'>OOC: </span>[src.client.fakekey]: <span class='message'>[msg]</span></span>"
	else
		player_message = message



	for (var/client/C)
		if (src.client.holder && C.holder) //Send admins the proper message. Force them to see other admin messages.
			C << message
			spawn(1)
				C << output(message, "ooc")
		else if (C.listen_ooc) //Otherwise, give them the 'falsified' message.
			C << player_message
			spawn(1)
				C << output(player_message, "ooc")