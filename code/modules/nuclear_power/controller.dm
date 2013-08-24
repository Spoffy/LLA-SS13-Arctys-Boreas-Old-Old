/obj/machinery/power/nuclear_power/control
	name = "Core Control Computer"
	desc = "A computer. For the core."
	icon = 'computer.dmi'
	icon_state = "core"
	anchored = 1
	density = 1

	var/obj/machinery/power/nuclear_power/reactor/reactor
	var/list/users = list()

	proc/find_reactor()
		if(!reactor)
			var/turf/loc = locate(src.x,src.y+1,src.z)
			for(var/obj/machinery/power/nuclear_power/reactor/R in loc)
				reactor = R
				R.computer = src
				return 1
			return 0
		return 1

	attack_hand(mob/user)
		if(!reactor)
			if(!find_reactor())
				user << "ERROR: Unable to locate working reactor."
				return

		if(!(user in users))
			users += user
			generate_menu(user)
		sleep(5)
		update_menu(user)

	attackby(obj/item/I, mob/M)
		if(istype(I, /obj/item/weapon/card/id))
			if(reactor)
				if(access_engine in I:access)
					if(reactor.is_emrg_shutdown())
						reactor.clear_emrg()
						for(var/user in users)
							update_menu(user)
						return
				if(access_heads in I:access)
					if(reactor.safeties)
						reactor.safeties = 0
						M << "You deactivate the reactor's failsafes."
					else
						reactor.safeties = 1
						M << "You activate the reactor's failsafes."
					return


	proc/update_menu(mob/user)
		if(!user || !reactor) return
		if(get_dist(src,user) > 1 || !user.client)
			remove_user(user)
			return
		user << output(reactor.retrieve_paramlist(),"engine_control.browser:updateAll")

	proc/remove_user(mob/user)
		users -= user
		user << browse(null,"window=engine_control")

	proc/generate_menu(mob/user)
		var/html = {"
		<script type='text/javascript'>
		function updateEngineStatus(emrg, rate){
			var selected = document.getElementById("status")
			selected.innerHTML = (rate != "0")?"ACTIVE":"INACTIVE";
			if(emrg == "1")
				selected.innerHTML = "EMRG"
			selected.style.backgroundColor = (rate != "0" && emrg == "0")?"green":"red";
		}
		function updateRate(rate){
			var selected = document.getElementById("rate")
			selected.innerHTML = rate
			selected.style.backgroundColor = (rate == "0")?"red":"green"
		}
		function updateMultiplier(multiplier){
			var selected = document.getElementById("multiplier")
			selected.innerHTML = multiplier
			selected.style.backgroundColor = (multiplier > 1.5)?"orange":"green";
		}
		function updateInsertion(insertion){
			var selected = document.getElementById("insertion")
			selected.innerHTML = insertion + "%"
			selected.style.backgroundColor = (insertion == "0")?"red":"green";
		}
		function updateTemperature(temp){
			var selected = document.getElementById("temp")
			selected.innerHTML = temp
			if(temp > [REACTOR_FAILSAFE_TEMP]) {
				selected.style.backgroundColor = "red";
				return;
			}
			selected.style.backgroundColor = (temp > [REACTOR_WARNING_TEMP])?"orange":"green";
		}
		function updateMaintain(maintain){
			var selected = document.getElementById("maintain")
			selected.innerHTML = (maintain != "0")? maintain:"INACTIVE";
			selected.style.backgroundColor = (maintain == "0")?"red":"green";
		}
		function updatePower(power){
			var selected = document.getElementById("power")
			selected.innerHTML = power + "W"
			selected.style.backgroundColor = (power == "0")?"red":"green";
		}
		function updateSafe(safety){
			var selected = document.getElementById("safe")
			selected.innerHTML = (safety == "0")? "INACTIVE":"ACTIVE";
			selected.style.backgroundColor = (safety == "0")?"red":"green";
		}
		function updateAll(status,rate,multiplier,insertion,temp,maintain,power,safety){
			updateEngineStatus(status,rate);
			updateRate(rate);
			updateMultiplier(multiplier);
			updateInsertion(insertion);
			updateTemperature(temp);
			updateMaintain(maintain);
			updatePower(power);
			updateSafe(safety);
		}
		</script>
		<body style='background-color=#8FB6FF;text-align=center;'>
		<center>
		<table border = 1 style='table-layout=fixed;font-family=Courier New;font-weight=bold;background-color=black;border-color=black;border-width=6px;'>
		<tr><td style='text-align=left;background-color=yellow;'>Fissile Status:</td><td id='status' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Reaction Rate:</td><td id='rate' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Reaction Multiplier:</td><td id='multiplier' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Rod Insertion:</td><td id='insertion' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Temperature (K):</td><td id='temp' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Maintain Reaction:</td><td id='maintain' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Power Output:</td><td id='power' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		<tr><td style='text-align=left;background-color=yellow;'>Safeties:</td><td id='safe' style='text-align=center; background-color=yellow;'>LOADING...</td></tr>
		</table>
		<table border = 0 style='table-layout=fixed;font-family=Courier New;font-weight=bold;text-align:center;'>
		<tr><td><button onclick='window.location = "?src=\ref[src];startup=1;mob=\ref[user];";'>Start up Reactor</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];shutdown=1;mob=\ref[user];";'>Emergency Shutdown</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];insert=5;mob=\ref[user];";'>&#x25B2;</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];insert=1;mob=\ref[user];";'>&#x25B2;</button></td></tr>
		<tr><td>Insertion</td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];retract=1;mob=\ref[user];";'>&#x25BC;</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];retract=5;mob=\ref[user];";'>&#x25BC;</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];maintain=1;mob=\ref[user];";'>Maintain</button></td></tr>
		<tr><td><button onclick='window.location = "?src=\ref[src];close_user=1;mob=\ref[user];";'>Close</button></td></tr>
		</table>
		</center>
		</body>
		"}
		user << browse(html,"window=engine_control;can_resize=0;size=300x590;can_close=0;")

	Topic(href, href_list[])
		var/mob/user
		if(href_list["mob"])
			user = locate(href_list["mob"])
		if(!user) return
		if(get_dist(src,user) > 1 || !user.client || !reactor)
			remove_user(user)

		if(href_list["close_user"])
			remove_user(user)
		else if(href_list["startup"])
			reactor.start_engine()
		else if(href_list["shutdown"])
			reactor.emergency_shutdown()
		else if(href_list["insert"])
			if(!reactor.rod_control) return
			var/add = text2num(href_list["insert"])
			reactor.rod_control.add_insertion(add)
			update_menu(user)
		else if(href_list["retract"])
			if(!reactor.rod_control) return
			var/add = text2num(href_list["retract"])
			reactor.rod_control.add_insertion(-add)
			update_menu(user)
		else if(href_list["maintain"])
			if(reactor.maintain_reaction)
				reactor.maintain_reaction = 0
			else
				reactor.maintain_reaction = round(reactor.reaction_rate,1)
			update_menu(user)

	proc/handle_reactor_tick()
		for(var/user in users)
			update_menu(user)