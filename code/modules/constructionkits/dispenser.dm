obj/machinery/kit_dispenser
	name = "Construction Kit Dispenser"
	desc = "A machine that constructs kits for constructing things."

	icon = 'stationobjs.dmi'
	icon_state = "autolathe"

	var/next_dispense_time = 0
	var/time_delay = 20

	attack_hand(mob/user)
		var/html = "<div style='text-align:center;'><b><u>Construction Kits</b></u><br><br>"
		html += "Cooldown Remaining: " + ((world.timeofday > next_dispense_time)? "Ready":(num2text(round((next_dispense_time - world.timeofday)/10))+ " seconds")) //SO MANY BRACKETS.
		html += "<br><br>"
		for(var/datum/constructionkit/kit_data/D in construction_kit_data)
			html += "<a href='?src=\ref[src];chosen=[D.get_name()];user=\ref[user]'>[D.get_name()] - Complexity: [D.get_difficulty()]</a><br>"

		html += "</div>"

		user << browse(html,"window='Construction Kit Dispenser'")


	Topic(href,href_list[])
		if(href_list["chosen"] && href_list["user"])
			var/kit_name = href_list["chosen"]
			var/mob/user = locate(href_list["user"])

			if(next_dispense_time > world.timeofday)
				attack_hand(user)
				return 0

			for(var/datum/constructionkit/kit_data/D in construction_kit_data)
				if(D.get_name() == kit_name)
					D.create_new(src.loc)
					next_dispense_time = world.timeofday + time_delay*10
					user << browse(null,"window='Construction Kit Dispenser'")
					return 1
		..()