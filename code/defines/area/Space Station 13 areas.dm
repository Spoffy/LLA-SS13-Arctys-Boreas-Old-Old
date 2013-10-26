/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/


/area
	var/fire = null
	var/atmos = 1
	var/poweralm = 1
	var/party = null
	var/gimmick = 0
	level = null
	name = "Space"
	icon = 'areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	var/lightswitch = 1

	var/eject = null

	var/requires_power = 1
	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0


	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this


// == Engineering Department related areas
/area/engineering_department

/area/engineering_department/engineering
	name = "Engineering"
	icon_state = "engine"

/area/engineering_department/robotics
	name = "Robotics"
	icon_state = "robotics"

/area/engineering_department/chief_engineer_office
	name = "Chief Engineer's Office"
	icon_state = "ce"

/area/engineering_department/ai_chamber
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/engineering_department/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/engineering_department/ai_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"

/area/engineering_department/incinerator
	name = "Incinerator"
	icon_state = "incinerator"

/area/engineering_department/engineering_break_room
	name = "Engineering Break Room"
	icon_state = "engi_break_room"

/area/engineering_department/ai_maintenance
	name = "AI Maintenance"
	icon_state = "ai_maint"

/area/engineering_department/engineering_maintenance
	name = "Engineering Maintenance"
	icon_state = "engi_maint"

/area/engineering_department/engineering_locker_room
	name = "Engineering Locker Room"
	icon_state = "engi_locker_room"

/area/engineering_department/construction_area
	name = "Construction Area"
	icon_state = "construction"

/area/engineering_department/tech_storage
	name = "Tech Storage"
	icon_state = "tech_storage"

/area/engineering_department/tech_storage_maintenance
	name = "Tech Storage Maintenance"
	icon_state = "tech_maint"

/area/engineering_department/engineering_hallway
	name = "Engineering Hallway"
	icon_state = "engine_hallway"

/area/engineering_department/escape_maintenance
	name = "Escape Maintenance"
	icon_state = "escape_maint"

/area/engineering_department/emergency_storage
	name = "Emergency Storage"
	icon_state = "emergency_storage"

/area/engineering_department/mech_bay
	name = "Mech Bay"
	icon_state = "mech_bay"





// == Security Department related areas
/area/security_department

/area/security_department/brig
	name = "Brig"
	icon_state = "brig"

/area/security_department/armory
	name = "Armory"
	icon_state = "armory"

/area/security_department/detectives_office
	name = "Detective's Office"
	icon_state = "detective"

/area/security_department/lawyer
	name = "Lawyer's Office"
	icon_state = "lawyer"

/area/security_department/hos
	name = "Head Of Security's Office"
	icon_state = "hos"

/area/security_department/warden
	name = "Warden's Office"
	icon_state = "warden"

/area/security_department/permabrig
	name = "PermaBrig"
	icon_state = "security_sub"

/area/security_department/security_office
	name = "Security Office"
	icon_state = "security_sub"

/area/security_department/security_post
	name = "Security Post"
	icon_state = "checkpoint1"

/area/security_department/interrogation
	name = "Interrogation"
	icon_state = "purple"

/area/security_department/security_hallway
	name = "Security Hallway"
	icon_state = "yellow"

/area/security_department/court
	name = "Courtroom"
	icon_state = "courtroom"

/area/security_department/security_maintenance
	name = "Security Maintenance"
	icon_state = "sec_maint"

// == R&D related areas
/area/rnd

/area/rnd/locker_room
	name = "Locker Room"
	icon_state = "locker"

/area/rnd/arrivals
	name = "Tram Station"
	icon_state = "purple"

/area/rnd/dorms
	name = "Doormitories"
	icon_state = "crew_quarters"

/area/rnd/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/rnd/medbay
	name = "Medbay"
	icon_state = "medbay"

/area/rnd/cafe_maint
	name = "Cafeteria Maintenance"
	icon_state = "cafe_maint"

/area/rnd/security
	name = "Security Office"
	icon_state = "security"

/area/rnd/rd
	name = "Research Director's Office"
	icon_state = "rd"

/area/rnd/restroom
	name = "Restroom"
	icon_state = "dk_yellow"

/area/rnd/rnd
	name = "Research and Development"
	icon_state = "purple"

/area/rnd/toxin_storage
	name = "Toxin Storage"
	icon_state = "toxstorage"

/area/rnd/toxin_mixing
	name = "Toxin Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "Xenobiology"
	icon_state = "green"

/area/rnd/xenobiology_cells
	name = "Xenobiology Research"
	icon_state = "purple"

/area/rnd/north_hall
	name = "North Hallway"
	icon_state = "hallF"

/area/rnd/south_hall
	name = "South Hallway"
	icon_state = "hallA"

/area/rnd/east_hall
	name = "East Hallway"
	icon_state = "hallS"

/area/rnd/west_hall
	name = "West Hallway"
	icon_state = "hallP"

/area/rnd/atmospherics
	name = "Atmospherics"
	icon_state = "atmos"

/area/rnd/locker_maint
	name = "Locker Room Maintenance"
	icon_state = "green"

/area/rnd/disposals
	name = "Disposal"
	icon_state = "disposal"

/area/rnd/science_maint
	name = "Science Maintenance"
	icon_state = "green"

/area/rnd/storage
	name = "Storage"
	icon_state = "primarystorage"




// == Command Department related areas
/area/command_department

/area/command_department/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/command_department/conference
	name = "Conference"
	icon_state = "conference"

/area/command_department/emergency_storage
	name = "Bridge Emergency Storage"
	icon_state = "emergency_storage"

/area/command_department/hop
	name = "Head of Personnel's Office"
	icon_state = "hop"

/area/command_department/captain
	name = "Captain's Office"
	icon_state = "captain"

/area/command_department/bridge_maintenance
	name = "Captain's Office"
	icon_state = "bridge_maint"

/area/command_department/eva_maintenance
	name = "EVA Maintenance"
	icon_state = "eva_maint"

/area/command_department/eva_maintenance
	name = "Bridge Maintenance"
	icon_state = "bridge_maint"

/area/command_department/teleporter
	name = "Teleporter"
	icon_state = "teleporter"

/area/command_department/eva
	name = "EVA"
	icon_state = "eva"

// == Crew Department related areas
/area/crew

/area/crew/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/crew/bar
	name = "Bar"
	icon_state = "bar"

/area/crew/bar_storage
	name = "Bar Storage"
	icon_state = "green"

/area/crew/library
	name = "Library"
	icon_state = "library"

/area/crew/chapel
	name = "Chapel"
	icon_state = "chapel"

/area/crew/chapel_office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/crew/hydroponics
	name = "Hydroponics"
	icon_state = "purple"

/area/crew/theater
	name = "Theater"
	icon_state = "dk_yellow"

/area/crew/custrodial_office
	name = "Custrodial Office"
	icon_state = "janitor"

/area/crew/storage_area1
	name = "Storage"
	icon_state = "primarystorage"

/area/crew/storage_area2
	name = "Storage"
	icon_state = "primarystorage"

/area/crew/crew_department_maint
	name = "Crew Department Maintenance"
	icon_state = "crew_maint"


// == Cargo Department related areas
/area/cargo_department

/area/cargo_department/cargo_office
	name = "Cargo Office"
	icon_state = "purple"

/area/cargo_department/quarter_master
	name = "QM's Office"
	icon_state = "quartoffice"

/area/cargo_department/cargo_bay
	name = "Cargo Bay"
	icon_state = "hangar"

/area/cargo_department/cargo_maintenance
	name = "Cargo Maintenance"
	icon_state = "cargo_maint"

/area/cargo_department/mining_dock_north
	name = "North Mining Dock"
	icon_state = "green"

/area/cargo_department/mining_dock_south
	name = "South Mining Dock"
	icon_state = "dk_yellow"


// == Mars areas end here


// == Mars-related areas start here
/area/surface
	name = "surface"
	icon = 'areas.dmi'
	icon_state = "surface"
	requires_power = 0

/area/ops
	name = "Operations Center"
	icon_state = "ops"

/area/colony

/area/colony/arrival
	name = "Cargo"
	icon_state = "start"

/area/colony/engine
	name = "Solar Mainteniance"
	icon_state = "engine"

/area/colony/atmos
	name = "Atmospherics"
	icon_state = "atmos"

/area/colony/hangar
	name = "Hangar"
	icon_state = "hangar"

/area/colony/control
	name = "Control Room"
	icon_state = "bridge"

/area/colony/medical
	name = "Medbay"
	icon_state = "medbay"

/area/colony/research
	name = "Research Center"
	icon_state = "medresearch"


// == Mars areas end here


/area/engine/

/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"



//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.

/area/shuttle //DO NOT TURN THE SD_LIGHTING STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/escape
	name = "Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	icon_state = "shuttle"

// Crappy rename of the Prison shuttle, should change this

/area/shuttle/prison
	name = "Planetary Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/transfer
	icon_state = "shuttle"

/area/shuttle/prison/planet
	icon_state = "shuttle"

// === Trying to remove these areas:

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"

// === end remove


/area/prison/arrival_airlock
	name = "Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Quarters"
	icon_state = "security"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "Prison Medbay"
	icon_state = "medbay"

/area/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//

/area/centcom
	name = "Centcom"
	icon_state = "purple"
	requires_power = 0

/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"


/area/maintenance/fpmaint
	name = "Fore Port Maintenance"
	icon_state = "fpmaint"


/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance"
	icon_state = "fsmaint"


/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"


/area/maintenance/apmaint
	name = "Aft Port Maintenance"
	icon_state = "apmaint"


/area/maintenance/maintcentral
	name = "Central Maintenance"
	icon_state = "maintcentral"


/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"


/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"


/area/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"


/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"


/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"


/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"


/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"


/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"


/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"


/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"


/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"


/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"


/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"


/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"


/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "captain"


/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"


/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"


/area/crew_quarters/bar
	name= "Bar"
	icon_state = "bar"

/area/mailroom
	name= "Mailroom"
	icon_state = "bar"

/area/crew_quarters/barber
	name= "Barbers Shop"
	icon_state = "bar" // IOU

/area/crew_quarters/heads
	name = "Head of Staff's Quarters"
	icon_state = "head_quarters"


/area/crew_quarters/hor
	name = "Head of Research's Office"
	icon_state = "head_quarters"


/area/crew_quarters/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"



/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"


/area/engine/engine_smes
	name = "Engine SMES Room"
	icon_state = "engine"


/area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"

/area/engine/engine_gas_storage
	name = "Engine Storage"
	icon_state = "engine_gas_storage"


/area/engine/engine_hallway
	name = "Engine Hallway"
	icon_state = "engine_hallway"


/area/engine/engine_mon
	name = "Engine Monitoring"
	icon_state = "engine_monitoring"


/area/engine/combustion
	name = "Engine Combustion Chamber"
	icon_state = "engine"
	music = "signal"


/area/engine/engine_control
	name = "Engine Control"
	icon_state = "engine_control"

/area/engine/launcher
	name = "Engine Launcher Room"
	icon_state = "engine_monitoring"


/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"


/area/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"


/area/tdome
	name = "Thunderdome"
	icon_state = "medbay"
	requires_power = 0

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomea
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'signal.ogg'


/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"


/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"


/area/security/main
	name = "Security"
	icon_state = "security"


/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"


/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "security"


/area/security/brig
	name = "Brig"
	icon_state = "brig"


/area/security/detectives_office
	name = "Detectives Office"
	icon_state = "detective"

/area/solar
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/solar/fore
	name = "Fore Solar Array"
	icon_state = "yellow"


/area/solar/aft
	name = "Aft Solar Array"
	icon_state = "aft"


/area/solar/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"


/area/solar/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "aft"

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0


/area/quartermaster/office
	name = "Quartermaster's Office"
	icon_state = "quartoffice"


/area/quartermaster/storage
	name = "Quartermaster's Storage"
	icon_state = "quartstorage"


/area/quartermaster/
	name = "Quartermasters"
	icon_state = "quart"

/area/janitor/
	name = "Janitors Closet"
	icon_state = "janitor"


/area/chemistry
	name = "Chemistry"
	icon_state = "chem"


/area/toxins/lab
	name = "Toxin Lab"
	icon_state = "toxlab"


/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxstorage"


/area/toxins/test_area
	name = "Toxin Test Area"
	icon_state = "toxtest"


/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"


/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"


/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"


/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Emergency Storage A"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Emergency Storage B"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"

/area/derelict
	name = "Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Control Room"
	icon_state = "bridge"

/area/derelict/bridge/access
	name = "Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Ruined Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "Abandoned ship"
	icon_state = "yellow"

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/crew_quarters/crew
	name = "Crew Quarters"
	icon_state = "crew_quarters"

/area/storage/electrical
	name = "Electrical Storage"
	icon_state = "crew_quarters" // IOU a icon.

/area/smes
	name = "SMES Room"
	icon_state = "crew_quarters" // IOU a icon.

/area/mining
	name = "Mining"
	icon_state = "crew_quarters" // IOU a icon.

/area/hangar
	name = "Hangar"
	icon_state = "crew_quarters" // IOU a icon.

// Admin-Areas

/area/admin
	name = "Admin-Area"
	icon_state = "crew_quarters" // IOU a icon.
	requires_power = 0