/var/const
	access_all = 999
	access_security = 1
	access_brig = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_medical = 5
	access_morgue = 6
	access_research = 7
	access_research_storage = 8
	access_medlab = 9
	access_engine = 10
	access_engine_equip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_bar = 24
	access_janitor = 25
	access_crematorium = 26
	access_kitchen = 27
	access_robotics = 28
	access_cargo = 29
	access_construction = 30
	access_chemistry = 31
	access_cargo_bot = 32
	access_mining = 33
	access_barber = 34
	access_manufactory = 35
	access_dummy = 36
	access_mail = 37
	access_hangar = 38
	access_head_hop = 39
	access_head_ce = 40
	access_head_hos = 41
	access_head_rd = 42

/proc/get_all_accesses()
		return list(
		access_all,
		access_security,
		access_brig,
		access_armory,
		access_forensics_lockers,
		access_medical,
		access_morgue,
		access_research,
		access_research_storage,
		access_medlab,
		access_engine,
		access_engine_equip,
		access_maint_tunnels,
		access_external_airlocks,
		access_emergency_storage,
		access_change_ids,
		access_ai_upload,
		access_teleporter,
		access_eva,
		access_heads,
		access_captain,
		access_all_personal_lockers,
		access_chapel_office,
		access_tech_storage,
		access_bar,
		access_janitor,
		access_crematorium,
		access_kitchen,
		access_robotics,
		access_cargo,
		access_construction,
		access_chemistry,
		access_cargo_bot,
		access_mining,
		access_barber,
		access_manufactory,
		access_dummy,
		access_mail,
		access_hangar,
		access_head_hop,
		access_head_ce,
		access_head_hos,
		access_head_rd)

//All objects have a list of accesses they may require
/obj/var/list/req_access = null
/obj/var/list/req_one_access = null

//Access can be requested from anything. Implementation is left up to the object.
/atom/proc/get_access()
	return list()

//Lists (like req_access) can't be edited in the map editor, so this is needed. It works in tandem with the others.
/obj/var/req_access_txt = null
/obj/var/req_one_access_txt = null
/obj/New()
	if(req_access_txt)
		req_access = list()
		var/req_access_str = params2list(req_access_txt)
		for(var/x in req_access_str)
			var/n = text2num(x)
			if(n)
				req_access += n
	if(req_one_access_txt)
		req_one_access = list()
		var/req_one_access_str = params2list(req_one_access_txt)
		for(var/x in req_one_access_str)
			var/n = text2num(x)
			if(n)
				req_one_access += n
	..()

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	var/access_list = M.get_access()

	if(src.check_access(access_list))
		return 1

	return 0

/obj/proc/check_access(list/access_list)
	//If both access fields either: Are not a list, or have no entries, then no access is needed.
	if((!istype(req_access, /list) || !length(req_access)) && (!istype(req_one_access, /list) || !length(req_one_access)))
		return 1
	if(!access_list || !length(access_list))
		return 0
	if(access_all in access_list)
		return 1

	for(var/access in req_one_access)
		if(access in access_list)
			return 1

	var/req_len = length(req_access)
	var/access_count = 0
	for(var/access in req_access)
		if(access in access_list)
			access_count++
			if(access_count == req_len)
				return 1

	return 0

/proc/get_access_values(job)
	switch(job)
		if("Geneticist")
			return list(access_medical, access_morgue, access_medlab)
		if("Station Engineer")
			return list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks)
		if("Assistant")
			return list(access_maint_tunnels)
		if("Chaplain")
			return list(access_morgue, access_chapel_office, access_crematorium)
		if("Detective")
			return list(access_security, access_forensics_lockers, access_morgue, access_maint_tunnels)
		if("Medical Doctor")
			return list(access_medical, access_morgue)
		if("Captain")
			return get_all_accesses()
		if("Security Officer")
			return list(access_security, access_brig)
		if("Scientist")
			return list(access_research, access_research_storage)
		if("Head of Security")
			return list(access_medical, access_morgue, access_research, access_research_storage, access_chemistry, access_medlab,
			            access_teleporter, access_heads, access_tech_storage, access_security, access_brig,
			            access_maint_tunnels, access_bar, access_janitor, access_kitchen, access_robotics, access_armory,
			            access_mining, access_mail, access_hangar)
		if("Head of Personnel")
			return list(access_security, access_brig, access_forensics_lockers,
			            access_research, access_research_storage, access_chemistry, access_medical, access_medlab, access_engine,
			            access_emergency_storage, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_tech_storage, access_maint_tunnels, access_bar, access_janitor,
			            access_crematorium, access_kitchen, access_robotics, access_cargo, access_cargo_bot, access_mining,
			            access_mail, access_hangar)
		if("Barman")
			return list(access_bar, access_maint_tunnels)
		if("Chemist")
			return list(access_medical, access_research, access_chemistry)
		if("Janitor")
			return list(access_janitor, access_maint_tunnels)
		if("Clown")
			return list(access_maint_tunnels)
		if("Chef")
			return list(access_kitchen, access_maint_tunnels)
		if("Roboticist")
			return list(access_robotics, access_tech_storage, access_medical, access_morgue, access_engine,
			            access_maint_tunnels)
		if("Quartermaster")
			return list(access_maint_tunnels, access_cargo, access_cargo_bot)
		if("Chief Engineer")
			return list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_emergency_storage, access_eva,
			            access_heads, access_ai_upload, access_construction, access_mining, access_hangar)
		if("Research Director")
			return list(access_medical, access_morgue, access_medlab, access_robotics,
			            access_tech_storage, access_maint_tunnels, access_heads, access_research,
			            access_research_storage, access_chemistry, access_teleporter, access_hangar)
		if("Lawyer")
			return list(access_maint_tunnels)
		if("Miner")
			return list(access_maint_tunnels, access_external_airlocks, access_mining, access_hangar)
		if("Barber")
			return list(access_barber)
		if("Mailman")
			return list(access_maint_tunnels, access_mail)
		else
			return list()

/proc/get_access_desc(A)
	switch(A)
		if(access_cargo)
			return "Cargo Bay"
		if(access_cargo_bot)
			return "Cargo Bot Delivery"
		if(access_security)
			return "Security"
		if(access_brig)
			return "Brig"
		if(access_forensics_lockers)
			return "Forensics"
		if(access_medical)
			return "Medical"
		if(access_medlab)
			return "Med-Sci"
		if(access_morgue)
			return "Morgue"
		if(access_research)
			return "Toxins Research"
		if(access_research_storage)
			return "Toxins Storage"
		if(access_chemistry)
			return "Toxins Chemical Lab"
		if(access_bar)
			return "Bar"
		if(access_janitor)
			return "Janitorial Equipment"
		if(access_engine)
			return "Engineering"
		if(access_engine_equip)
			return "Engine & Power Control Equipment"
		if(access_maint_tunnels)
			return "Maintenance"
		if(access_external_airlocks)
			return "External Airlock"
		if(access_emergency_storage)
			return "Emergency Storage"
		if(access_change_ids)
			return "ID Computer"
		if(access_ai_upload)
			return "AI Upload"
		if(access_teleporter)
			return "Teleporter"
		if(access_eva)
			return "EVA"
		if(access_heads)
			return "Head's Quarters/Bridge"
		if(access_captain)
			return "Captain's Quarters"
		if(access_all_personal_lockers)
			return "Personal Locker"
		if(access_chapel_office)
			return "Chapel Office"
		if(access_tech_storage)
			return "Technical Storage"
		if(access_crematorium)
			return "Crematorium"
		if(access_armory)
			return "Armory"
		if(access_construction)
			return "Construction Site"
		if(access_kitchen)
			return "Kitchen"
		if(access_mining)
			return "Mining"
		if(access_barber)
			return "Barbers shop"
		if(access_manufactory)
			return "manufactory access"
		if(access_mail)
			return "Mailroom"
		if(access_hangar)
			return "Hangar"


/proc/get_all_jobs()
	return list("Assistant", "Station Engineer", "Detective", "Medical Doctor", "Captain", "Security Officer",
				"Geneticist", "Scientist", "Head of Security", "Head of Personnel", "Atmospheric Technician",
				"Chaplain", "Barman", "Chemist", "Janitor", "Clown", "Chef", "Roboticist", "Quartermaster",
				"Chief Engineer", "Research Director", "Lawyer", "Miner", "Mailman")

