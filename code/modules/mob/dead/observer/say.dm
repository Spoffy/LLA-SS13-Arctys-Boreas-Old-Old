/mob/dead/observer/say_understands(var/other)
	return 1

/mob/dead/observer/say(var/message)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if (!message)
		return

	log_say("Ghost/[src.key] : [message]")

	if (src.client && src.client.muted)
		return

	. = src.say_dead(message)

	for (var/mob/M in hearers(null, null))
		if (!M.stat)
			if(M.job == "Chaplain")
				if (prob (49))
					M.show_message("<span class='game'><i>You hear muffled speech... but nothing is there...</i></span>", 2)
				else
					M.show_message("<span class='game'><i>[stutter(message)]</i></span>", 2)
			else
				if (prob(50))
					return
				else if (prob (95))
					M.show_message("<span class='game'><i>You hear muffled speech... but nothing is there...</i></span>", 2)
				else
					M.show_message("<span class='game'><i>[stutter(message)]</i></span>", 2)