var/list/beta_tester_keylist

/proc/beta_tester_loadfile()
	beta_tester_keylist = new/list()
	var/text = file2text("config/testers.txt")
	if (!text)
		diary << "Failed to load config/testers.txt\n"
	else
		var/list/lines = dd_text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			var/tester_key = copytext(line, 1, 0)
			beta_tester_keylist.Add(tester_key)

/proc/istester(X)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((ckey(X) in beta_tester_keylist)) return 1
	else return 0