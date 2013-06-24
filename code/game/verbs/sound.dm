/client/verb/toggle_midis()
	set category = "OOC"
	set name = "Toggle Midis"
	set desc = "Toggle recieving admin midis"

	if(midis)
		src << "\blue Midis are now toggled off."
		midis = 0
		var/sound/S = sound(null,0,0,777,0)
		S.priority = 255
		src << S
		return 0
	else
		src << "\blue Midis are now toggled on."
		midis = 1
		return 1
