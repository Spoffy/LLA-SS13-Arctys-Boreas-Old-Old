/mob/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	if (src.client)
		src << browse_rsc('somerights20.png')
		src << browse_rsc('ms13logo.png')
		src << browse_rsc('88x31.png')
		src << browse('changelog.html', "window=changes;size=425x650")

/mob/verb/help()
	set name = "Help"
	set category = "OOC"
	src << browse('help.html', "window=help")
	return
