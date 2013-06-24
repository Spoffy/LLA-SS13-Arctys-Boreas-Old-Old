/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (muted)
		alert("You cannot do this, you are muted!")
		return

	for (var/mob/M in world)
		if (M.client && M.client.holder)
			var/totab = "\blue <b><font color=red>HELP: </font>[key_name(src, M)](<A HREF='?src=\ref[M.client.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]"
			M << totab
			spawn(1)
				M << output(totab, "adminhelp")

	src << "Your message has been broadcast to administrators."
	log_admin("HELP: [key_name(src)]: [msg]")
